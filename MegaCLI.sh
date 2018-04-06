#!/bin/bash

if [ -f /opt/MegaRAID/MegaCli/MegaCli64 ]

then

#I  need to search the dmidecode for hw_model as the script is built for UCS servers only

# Check if MEGACLI is Installed or not
 

a=0

b=1

 
virttotal=$(/opt/MegaRAID/MegaCli/MegaCli64 -ldpdinfo -a0 | grep 'Virtual Drive:' | wc -l)

for (( a=0,b=1; b<=$virttotal; a++,b++ ))

do


#Find the Faulty Devices

FD=$(/opt/MegaRAID/MegaCli/MegaCli64 -ldpdinfo -a0 | sed -n -e "/Virtual Drive: $a /,/Virtual Drive: $b /p" | grep 'Virtual Drive:' | head -1)

errors=$(/opt/MegaRAID/MegaCli/MegaCli64 -ldpdinfo -a0 | sed -n -e "/Virtual Drive: $a /,/Virtual Drive: $b /p" | grep 'Media Error Count:')

ENCNAME=$(/opt/MegaRAID/MegaCli/MegaCli64 -ldpdinfo -a0 | sed -n -e "/Virtual Drive: $a /,/Virtual Drive: $b /p" | grep 'Enclosure Device ID:')

SLOTNUMBER=$(/opt/MegaRAID/MegaCli/MegaCli64 -ldpdinfo -a0 | sed -n -e "/Virtual Drive: $a /,/Virtual Drive: $b /p" | grep 'Slot Number:')

DEVSERIAL=$(/opt/MegaRAID/MegaCli/MegaCli64 -ldpdinfo -a0 | sed -n -e "/Virtual Drive: $a /,/Virtual Drive: $b /p" | grep 'Inquiry Data:')

DEVSIZE=$(/opt/MegaRAID/MegaCli/MegaCli64 -ldpdinfo -a0 | sed -n -e "/Virtual Drive: $a /,/Virtual Drive: $b /p" | grep 'Raw Size:')

 

echo "$errors" | while read -r line

                        do

                                ERRORCOUNT=$(echo "$line" | awk '{print $4}')

                                if [[ "$ERRORCOUNT" > 0 ]]

                                then

                                echo "The Following Virtual Drive is Faulty"

                                echo "$FD" | head

                                #Below is the Virtual Drive Number

                                VDN=$(echo "$FD" | head | awk '{print $3}')

                                #echo $VDN

                                printf "OS Device Name: " ; sg_map -x | awk -v src=$VDN '{if($4==src) {print $7}}'

                                echo "Media Error Count: $ERRORCOUNT"

                                echo "$ENCNAME"

                                echo "$SLOTNUMBER"

                                echo "$DEVSERIAL"

                                echo "$DEVSIZE"

                                printf "\n"

                                continue

                                else

                                :

                                fi

 

#I will add some code here to make the drives flash

                        done

done


else

 
echo "MegaCLI Need to be Installed first"

exit 1;

fi

#Here, I need to make sure to search for JBOD devices and link it to the SCSI devices
