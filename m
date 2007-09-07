From: akpm@linux-foundation.org
Subject: - de-dosify-iforce-protocoltxt.patch removed from -mm tree
Date: Thu, 06 Sep 2007 17:42:22 -0700
Message-ID: <200709070042.l870gMKe016035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33734 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964852AbXIGAnF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2007 20:43:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, apw@shadowen.org, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     de-dosify iforce-protocol.txt
has been removed from the -mm tree.  Its filename was
     de-dosify-iforce-protocoltxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: de-dosify iforce-protocol.txt
From: Andrew Morton <akpm@linux-foundation.org>

This file uses DOS line endings.

Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/input/iforce-protocol.txt |  508 +++++++++++-----------
 1 file changed, 254 insertions(+), 254 deletions(-)

diff -puN Documentation/input/iforce-protocol.txt~de-dosify-iforce-protocoltxt Documentation/input/iforce-protocol.txt
--- a/Documentation/input/iforce-protocol.txt~de-dosify-iforce-protocoltxt
+++ a/Documentation/input/iforce-protocol.txt
@@ -1,254 +1,254 @@
-** Introduction
-This document describes what I managed to discover about the protocol used to
-specify force effects to I-Force 2.0 devices.  None of this information comes
-from Immerse. That's why you should not trust what is written in this
-document. This document is intended to help understanding the protocol.
-This is not a reference. Comments and corrections are welcome.  To contact me,
-send an email to: deneux@ifrance.com
-
-** WARNING **
-I may not be held responsible for any dammage or harm caused if you try to
-send data to your I-Force device based on what you read in this document.
-
-** Preliminary Notes:
-All values are hexadecimal with big-endian encoding (msb on the left). Beware,
-values inside packets are encoded using little-endian.  Bytes whose roles are
-unknown are marked ???  Information that needs deeper inspection is marked (?)
-
-** General form of a packet **
-This is how packets look when the device uses the rs232 to communicate.
-2B OP LEN DATA CS
-CS is the checksum. It is equal to the exclusive or of all bytes.
-
-When using USB:
-OP DATA
-The 2B, LEN and CS fields have disappeared, probably because USB handles frames and
-data corruption is handled or unsignificant.
-
-First, I describe effects that are sent by the device to the computer
-
-** Device input state
-This packet is used to indicate the state of each button and the value of each
-axis
-OP= 01 for a joystick, 03 for a wheel
-LEN= Varies from device to device
-00 X-Axis lsb
-01 X-Axis msb
-02 Y-Axis lsb, or gas pedal for a wheel
-03 Y-Axis msb, or brake pedal for a wheel
-04 Throttle
-05 Buttons
-06 Lower 4 bits: Buttons
-   Upper 4 bits: Hat
-07 Rudder
-
-** Device effects states
-OP= 02
-LEN= Varies
-00 ? Bit 1 (Value 2) is the value of the deadman switch
-01 Bit 8 is set if the effect is playing. Bits 0 to 7 are the effect id.
-02 ??
-03 Address of parameter block changed (lsb)
-04 Address of parameter block changed (msb)
-05 Address of second parameter block changed (lsb)
-... depending on the number of parameter blocks updated
-
-** Force effect **
-OP=  01
-LEN= 0e
-00 Channel (when playing several effects at the same time, each must be assigned a channel)
-01 Wave form
-	Val 00 Constant
-	Val 20 Square
-	Val 21 Triangle
-	Val 22 Sine
-	Val 23 Sawtooth up
-	Val 24 Sawtooth down
-	Val 40 Spring (Force = f(pos))
-	Val 41 Friction (Force = f(velocity)) and Inertia (Force = f(acceleration))
-
-	
-02 Axes affected and trigger
-	Bits 4-7: Val 2 = effect along one axis. Byte 05 indicates direction
-	          Val 4 = X axis only. Byte 05 must contain 5a
-	          Val 8 = Y axis only. Byte 05 must contain b4
-	          Val c = X and Y axes. Bytes 05 must contain 60
-	Bits 0-3: Val 0 = No trigger
-	          Val x+1 = Button x triggers the effect
-	When the whole byte is 0, cancel the previously set trigger
-
-03-04 Duration of effect (little endian encoding, in ms)
-
-05 Direction of effect, if applicable. Else, see 02 for value to assign.
-
-06-07 Minimum time between triggering.
-
-08-09 Address of periodicity or magnitude parameters
-0a-0b Address of attack and fade parameters, or ffff if none.
-*or*
-08-09 Address of interactive parameters for X-axis, or ffff if not applicable
-0a-0b Address of interactive parameters for Y-axis, or ffff if not applicable
-
-0c-0d Delay before execution of effect (little endian encoding, in ms)
-
-
-** Time based parameters **
-
-*** Attack and fade ***
-OP=  02
-LEN= 08
-00-01 Address where to store the parameteres
-02-03 Duration of attack (little endian encoding, in ms)
-04 Level at end of attack. Signed byte.
-05-06 Duration of fade.
-07 Level at end of fade.
-
-*** Magnitude ***
-OP=  03
-LEN= 03
-00-01 Address
-02 Level. Signed byte.
-
-*** Periodicity ***
-OP=  04
-LEN= 07
-00-01 Address
-02 Magnitude. Signed byte.
-03 Offset. Signed byte.
-04 Phase. Val 00 = 0 deg, Val 40 = 90 degs.
-05-06 Period (little endian encoding, in ms)
-
-** Interactive parameters **
-OP=  05
-LEN= 0a
-00-01 Address
-02 Positive Coeff
-03 Negative Coeff
-04+05 Offset (center)
-06+07 Dead band (Val 01F4 = 5000 (decimal))
-08 Positive saturation (Val 0a = 1000 (decimal) Val 64 = 10000 (decimal))
-09 Negative saturation
-
-The encoding is a bit funny here: For coeffs, these are signed values. The
-maximum value is 64 (100 decimal), the min is 9c.
-For the offset, the minimum value is FE0C, the maximum value is 01F4.
-For the deadband, the minimum value is 0, the max is 03E8.
-
-** Controls **
-OP=  41
-LEN= 03
-00 Channel
-01 Start/Stop
-	Val 00: Stop
-	Val 01: Start and play once.
-	Val 41: Start and play n times (See byte 02 below)
-02 Number of iterations n.
-
-** Init **
-
-*** Querying features ***
-OP=  ff
-Query command. Length varies according to the query type.
-The general format of this packet is:
-ff 01 QUERY [INDEX] CHECKSUM
-reponses are of the same form:
-FF LEN QUERY VALUE_QUERIED CHECKSUM2
-where LEN = 1 + length(VALUE_QUERIED)
-
-**** Query ram size ****
-QUERY = 42 ('B'uffer size)
-The device should reply with the same packet plus two additionnal bytes
-containing the size of the memory:
-ff 03 42 03 e8 CS would mean that the device has 1000 bytes of ram available.
-
-**** Query number of effects ****
-QUERY = 4e ('N'umber of effects)
-The device should respond by sending the number of effects that can be played
-at the same time (one byte)
-ff 02 4e 14 CS would stand for 20 effects.
-
-**** Vendor's id ****
-QUERY = 4d ('M'anufacturer)
-Query the vendors'id (2 bytes)
-
-**** Product id *****
-QUERY = 50 ('P'roduct)
-Query the product id (2 bytes)
-
-**** Open device ****
-QUERY = 4f ('O'pen) 
-No data returned.
-
-**** Close device *****
-QUERY = 43 ('C')lose
-No data returned.
-
-**** Query effect ****
-QUERY = 45 ('E') 
-Send effect type.
-Returns nonzero if supported (2 bytes)
-
-**** Firmware Version ****
-QUERY = 56 ('V'ersion)
-Sends back 3 bytes - major, minor, subminor
-
-*** Initialisation of the device ***
-
-**** Set Control ****
-!!! Device dependent, can be different on different models !!!
-OP=  40 <idx> <val> [<val>]
-LEN= 2 or 3
-00 Idx
-   Idx 00 Set dead zone (0..2048) 
-   Idx 01 Ignore Deadman sensor (0..1)     
-   Idx 02 Enable comm watchdog (0..1)     
-   Idx 03 Set the strength of the spring (0..100)   
-   Idx 04 Enable or disable the spring (0/1)
-   Idx 05 Set axis saturation threshold (0..2048) 
-
-**** Set Effect State ****
-OP=  42 <val>
-LEN= 1
-00 State
-   Bit 3 Pause force feedback
-   Bit 2 Enable force feedback
-   Bit 0 Stop all effects
-
-**** Set overall gain ****
-OP=  43 <val>
-LEN= 1
-00 Gain
-   Val 00 = 0%
-   Val 40 = 50%
-   Val 80 = 100%
-
-** Parameter memory **
-
-Each device has a certain amount of memory to store parameters of effects.
-The amount of RAM may vary, I encountered values from 200 to 1000 bytes. Below
-is the amount of memory apparently needed for every set of parameters:
- - period : 0c
- - magnitude : 02
- - attack and fade : 0e
- - interactive : 08
-
-** Appendix: How to study the protocol ? **
-
-1. Generate effects using the force editor provided with the DirectX SDK, or use Immersion Studio (freely available at their web site in the developer section: www.immersion.com)
-2. Start a soft spying RS232 or USB (depending on where you connected your joystick/wheel). I used ComPortSpy from fCoder (alpha version!)
-3. Play the effect, and watch what happens on the spy screen.
-
-A few words about ComPortSpy:
-At first glance, this soft seems, hum, well... buggy. In fact, data appear with a few seconds latency. Personnaly, I restart it every time I play an effect.
-Remember it's free (as in free beer) and alpha!
-
-** URLS **
-Check www.immerse.com for Immersion Studio, and www.fcoder.com for ComPortSpy.
-
-** Author of this document **
-Johann Deneux <deneux@ifrance.com>
-Home page at http://www.esil.univ-mrs.fr/~jdeneux/projects/ff/
-
-Additions by Vojtech Pavlik.
-
-I-Force is trademark of Immersion Corp.
+** Introduction
+This document describes what I managed to discover about the protocol used to
+specify force effects to I-Force 2.0 devices.  None of this information comes
+from Immerse. That's why you should not trust what is written in this
+document. This document is intended to help understanding the protocol.
+This is not a reference. Comments and corrections are welcome.  To contact me,
+send an email to: deneux@ifrance.com
+
+** WARNING **
+I may not be held responsible for any dammage or harm caused if you try to
+send data to your I-Force device based on what you read in this document.
+
+** Preliminary Notes:
+All values are hexadecimal with big-endian encoding (msb on the left). Beware,
+values inside packets are encoded using little-endian.  Bytes whose roles are
+unknown are marked ???  Information that needs deeper inspection is marked (?)
+
+** General form of a packet **
+This is how packets look when the device uses the rs232 to communicate.
+2B OP LEN DATA CS
+CS is the checksum. It is equal to the exclusive or of all bytes.
+
+When using USB:
+OP DATA
+The 2B, LEN and CS fields have disappeared, probably because USB handles frames and
+data corruption is handled or unsignificant.
+
+First, I describe effects that are sent by the device to the computer
+
+** Device input state
+This packet is used to indicate the state of each button and the value of each
+axis
+OP= 01 for a joystick, 03 for a wheel
+LEN= Varies from device to device
+00 X-Axis lsb
+01 X-Axis msb
+02 Y-Axis lsb, or gas pedal for a wheel
+03 Y-Axis msb, or brake pedal for a wheel
+04 Throttle
+05 Buttons
+06 Lower 4 bits: Buttons
+   Upper 4 bits: Hat
+07 Rudder
+
+** Device effects states
+OP= 02
+LEN= Varies
+00 ? Bit 1 (Value 2) is the value of the deadman switch
+01 Bit 8 is set if the effect is playing. Bits 0 to 7 are the effect id.
+02 ??
+03 Address of parameter block changed (lsb)
+04 Address of parameter block changed (msb)
+05 Address of second parameter block changed (lsb)
+... depending on the number of parameter blocks updated
+
+** Force effect **
+OP=  01
+LEN= 0e
+00 Channel (when playing several effects at the same time, each must be assigned a channel)
+01 Wave form
+	Val 00 Constant
+	Val 20 Square
+	Val 21 Triangle
+	Val 22 Sine
+	Val 23 Sawtooth up
+	Val 24 Sawtooth down
+	Val 40 Spring (Force = f(pos))
+	Val 41 Friction (Force = f(velocity)) and Inertia (Force = f(acceleration))
+
+
+02 Axes affected and trigger
+	Bits 4-7: Val 2 = effect along one axis. Byte 05 indicates direction
+	          Val 4 = X axis only. Byte 05 must contain 5a
+	          Val 8 = Y axis only. Byte 05 must contain b4
+	          Val c = X and Y axes. Bytes 05 must contain 60
+	Bits 0-3: Val 0 = No trigger
+	          Val x+1 = Button x triggers the effect
+	When the whole byte is 0, cancel the previously set trigger
+
+03-04 Duration of effect (little endian encoding, in ms)
+
+05 Direction of effect, if applicable. Else, see 02 for value to assign.
+
+06-07 Minimum time between triggering.
+
+08-09 Address of periodicity or magnitude parameters
+0a-0b Address of attack and fade parameters, or ffff if none.
+*or*
+08-09 Address of interactive parameters for X-axis, or ffff if not applicable
+0a-0b Address of interactive parameters for Y-axis, or ffff if not applicable
+
+0c-0d Delay before execution of effect (little endian encoding, in ms)
+
+
+** Time based parameters **
+
+*** Attack and fade ***
+OP=  02
+LEN= 08
+00-01 Address where to store the parameteres
+02-03 Duration of attack (little endian encoding, in ms)
+04 Level at end of attack. Signed byte.
+05-06 Duration of fade.
+07 Level at end of fade.
+
+*** Magnitude ***
+OP=  03
+LEN= 03
+00-01 Address
+02 Level. Signed byte.
+
+*** Periodicity ***
+OP=  04
+LEN= 07
+00-01 Address
+02 Magnitude. Signed byte.
+03 Offset. Signed byte.
+04 Phase. Val 00 = 0 deg, Val 40 = 90 degs.
+05-06 Period (little endian encoding, in ms)
+
+** Interactive parameters **
+OP=  05
+LEN= 0a
+00-01 Address
+02 Positive Coeff
+03 Negative Coeff
+04+05 Offset (center)
+06+07 Dead band (Val 01F4 = 5000 (decimal))
+08 Positive saturation (Val 0a = 1000 (decimal) Val 64 = 10000 (decimal))
+09 Negative saturation
+
+The encoding is a bit funny here: For coeffs, these are signed values. The
+maximum value is 64 (100 decimal), the min is 9c.
+For the offset, the minimum value is FE0C, the maximum value is 01F4.
+For the deadband, the minimum value is 0, the max is 03E8.
+
+** Controls **
+OP=  41
+LEN= 03
+00 Channel
+01 Start/Stop
+	Val 00: Stop
+	Val 01: Start and play once.
+	Val 41: Start and play n times (See byte 02 below)
+02 Number of iterations n.
+
+** Init **
+
+*** Querying features ***
+OP=  ff
+Query command. Length varies according to the query type.
+The general format of this packet is:
+ff 01 QUERY [INDEX] CHECKSUM
+reponses are of the same form:
+FF LEN QUERY VALUE_QUERIED CHECKSUM2
+where LEN = 1 + length(VALUE_QUERIED)
+
+**** Query ram size ****
+QUERY = 42 ('B'uffer size)
+The device should reply with the same packet plus two additionnal bytes
+containing the size of the memory:
+ff 03 42 03 e8 CS would mean that the device has 1000 bytes of ram available.
+
+**** Query number of effects ****
+QUERY = 4e ('N'umber of effects)
+The device should respond by sending the number of effects that can be played
+at the same time (one byte)
+ff 02 4e 14 CS would stand for 20 effects.
+
+**** Vendor's id ****
+QUERY = 4d ('M'anufacturer)
+Query the vendors'id (2 bytes)
+
+**** Product id *****
+QUERY = 50 ('P'roduct)
+Query the product id (2 bytes)
+
+**** Open device ****
+QUERY = 4f ('O'pen)
+No data returned.
+
+**** Close device *****
+QUERY = 43 ('C')lose
+No data returned.
+
+**** Query effect ****
+QUERY = 45 ('E')
+Send effect type.
+Returns nonzero if supported (2 bytes)
+
+**** Firmware Version ****
+QUERY = 56 ('V'ersion)
+Sends back 3 bytes - major, minor, subminor
+
+*** Initialisation of the device ***
+
+**** Set Control ****
+!!! Device dependent, can be different on different models !!!
+OP=  40 <idx> <val> [<val>]
+LEN= 2 or 3
+00 Idx
+   Idx 00 Set dead zone (0..2048)
+   Idx 01 Ignore Deadman sensor (0..1)
+   Idx 02 Enable comm watchdog (0..1)
+   Idx 03 Set the strength of the spring (0..100)
+   Idx 04 Enable or disable the spring (0/1)
+   Idx 05 Set axis saturation threshold (0..2048)
+
+**** Set Effect State ****
+OP=  42 <val>
+LEN= 1
+00 State
+   Bit 3 Pause force feedback
+   Bit 2 Enable force feedback
+   Bit 0 Stop all effects
+
+**** Set overall gain ****
+OP=  43 <val>
+LEN= 1
+00 Gain
+   Val 00 = 0%
+   Val 40 = 50%
+   Val 80 = 100%
+
+** Parameter memory **
+
+Each device has a certain amount of memory to store parameters of effects.
+The amount of RAM may vary, I encountered values from 200 to 1000 bytes. Below
+is the amount of memory apparently needed for every set of parameters:
+ - period : 0c
+ - magnitude : 02
+ - attack and fade : 0e
+ - interactive : 08
+
+** Appendix: How to study the protocol ? **
+
+1. Generate effects using the force editor provided with the DirectX SDK, or use Immersion Studio (freely available at their web site in the developer section: www.immersion.com)
+2. Start a soft spying RS232 or USB (depending on where you connected your joystick/wheel). I used ComPortSpy from fCoder (alpha version!)
+3. Play the effect, and watch what happens on the spy screen.
+
+A few words about ComPortSpy:
+At first glance, this soft seems, hum, well... buggy. In fact, data appear with a few seconds latency. Personnaly, I restart it every time I play an effect.
+Remember it's free (as in free beer) and alpha!
+
+** URLS **
+Check www.immerse.com for Immersion Studio, and www.fcoder.com for ComPortSpy.
+
+** Author of this document **
+Johann Deneux <deneux@ifrance.com>
+Home page at http://www.esil.univ-mrs.fr/~jdeneux/projects/ff/
+
+Additions by Vojtech Pavlik.
+
+I-Force is trademark of Immersion Corp.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-powerpc-fixup.patch
revert-gregkh-driver-block-device.patch
revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
git-dvb.patch
git-dvb-fixup-2.patch
infiniband-work-around-gcc-slub-problem.patch
git-input.patch
adbhid-produce-all-capslock-key-events.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
git-kbuild.patch
git-kvm.patch
git-libata-all.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61patch.patch
ide-arm-hack.patch
git-mips.patch
git-mmc.patch
git-mmc-fixup2.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-netdev-all.patch
e1000e-build-fix.patch
revert-8139too-clean-up-i-o-remapping.patch
git-net.patch
git-net-fixup.patch
net-atm-lecc-printk-warning-fix.patch
git-backlight.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
git-ocfs2.patch
revert-gregkh-pci-pci_bridge-device.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
fix-ide-legacy-mode-resources-fix.patch
git-s390.patch
git-scsi-misc.patch
advansys-printk-fix.patch
git-block-fixup.patch
git-block-fix-headers_check.patch
git-unionfs.patch
git-unionfs-fix-2.patch
fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
net-add-ath5k-wireless-driver-fix.patch
revert-x86_64-mm-intel_cacheinfo-adjustments.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
intel_cacheinfo-misc-section-annotation-fixes-fix.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
hpet-force-enable-on-vt8235-37-chipsets-fix.patch
x86-convert-cpu_sibling_map-to-be-a-per-cpu-variable-broke-ia64.patch
git-xfs.patch
git-xtensa.patch
i386-apic-fix-4-bit-apicid-assumption-of-mach-default.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
binfmt_flat-warning-fixes.patch
console-events-and-accessibility-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
md-software-raid-autodetect-dev-list-not-array-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
isolate-some-explicit-usage-of-task-tgid-fix-fix.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
