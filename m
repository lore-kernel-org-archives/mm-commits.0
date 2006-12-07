From: akpm@osdl.org
Subject: - new-updated-devicestxt-lanana.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:16:23 -0800
Message-ID: <200612072316.kB7NGNj3030828@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53643 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163796AbWLGXQb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:16:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torben.mathiasen@hp.com, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     New updated devices.txt - LANANA
has been removed from the -mm tree.  Its filename was
     new-updated-devicestxt-lanana.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: New updated devices.txt - LANANA
From: Torben Mathiasen <torben.mathiasen@hp.com>

[jengelh@linux01.gwdg.de: cleanups]
Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Acked-by: Torben Mathiasen <torben.mathiasen@hp.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/devices.txt |  102 ++++++++++++++++++++++--------------
 1 file changed, 64 insertions(+), 38 deletions(-)

diff -puN Documentation/devices.txt~new-updated-devicestxt-lanana Documentation/devices.txt
--- a/Documentation/devices.txt~new-updated-devicestxt-lanana
+++ a/Documentation/devices.txt
@@ -3,7 +3,7 @@
 
 	     Maintained by Torben Mathiasen <device@lanana.org>
 
-		      Last revised: 15 May 2006
+		      Last revised: 29 November 2006
 
 This list is the Linux Device List, the official registry of allocated
 device numbers and /dev directory nodes for the Linux operating
@@ -94,6 +94,7 @@ Your cooperation is appreciated.
 		  9 = /dev/urandom	Faster, less secure random number gen.
 		 10 = /dev/aio		Asynchronous I/O notification interface
 		 11 = /dev/kmsg		Writes to this come out as printk's
+
   1 block	RAM disk
 		  0 = /dev/ram0		First RAM disk
 		  1 = /dev/ram1		Second RAM disk
@@ -122,7 +123,7 @@ Your cooperation is appreciated.
 		devices are on major 128 and above and use the PTY
 		master multiplex (/dev/ptmx) to acquire a PTY on
 		demand.
-  
+
   2 block	Floppy disks
 		  0 = /dev/fd0		Controller 0, drive 0, autodetect
 		  1 = /dev/fd1		Controller 0, drive 1, autodetect
@@ -257,7 +258,7 @@ Your cooperation is appreciated.
 		129 = /dev/vcsa1	tty1 text/attribute contents
 		    ...
 		191 = /dev/vcsa63	tty63 text/attribute contents
-	
+
 		NOTE: These devices permit both read and write access.
 
   7 block	Loopback devices
@@ -411,7 +412,7 @@ Your cooperation is appreciated.
 		207 = /dev/video/em8300_sp	EM8300 DVD decoder subpicture
 		208 = /dev/compaq/cpqphpc	Compaq PCI Hot Plug Controller
 		209 = /dev/compaq/cpqrid	Compaq Remote Insight Driver
-		210 = /dev/impi/bt	IMPI coprocessor block transfer	
+		210 = /dev/impi/bt	IMPI coprocessor block transfer
 		211 = /dev/impi/smic	IMPI coprocessor stream interface
 		212 = /dev/watchdogs/0	First watchdog device
 		213 = /dev/watchdogs/1	Second watchdog device
@@ -506,6 +507,7 @@ Your cooperation is appreciated.
 		 33 = /dev/patmgr1	Sequencer patch manager
 		 34 = /dev/midi02	Third MIDI port
 		 50 = /dev/midi03	Fourth MIDI port
+
  14 block	BIOS harddrive callback support {2.6}
 		  0 = /dev/dos_hda	First BIOS harddrive whole disk
 		 64 = /dev/dos_hdb	Second BIOS harddrive whole disk
@@ -527,6 +529,7 @@ Your cooperation is appreciated.
 
  16 char	Non-SCSI scanners
 		  0 = /dev/gs4500	Genius 4500 handheld scanner
+
  16 block	GoldStar CD-ROM
 		  0 = /dev/gscd		GoldStar CD-ROM
 
@@ -548,6 +551,7 @@ Your cooperation is appreciated.
 		  0 = /dev/ttyC0	First Cyclades port
 		    ...
 		 31 = /dev/ttyC31	32nd Cyclades port
+
  19 block	"Double" compressed disk
 		  0 = /dev/double0	First compressed disk
 		    ...
@@ -563,6 +567,7 @@ Your cooperation is appreciated.
 		  0 = /dev/cub0		Callout device for ttyC0
 		    ...
 		 31 = /dev/cub31	Callout device for ttyC31
+
  20 block	Hitachi CD-ROM (under development)
 		  0 = /dev/hitcd	Hitachi CD-ROM
 
@@ -582,7 +587,7 @@ Your cooperation is appreciated.
 
 		This device is used on the ARM-based Acorn RiscPC.
 		Partitions are handled the same way as for IDE disks
-		(see major number 3). 
+		(see major number 3).
 
  22 char	Digiboard serial card
 		  0 = /dev/ttyD0	First Digiboard port
@@ -591,7 +596,7 @@ Your cooperation is appreciated.
  22 block	Second IDE hard disk/CD-ROM interface
 		  0 = /dev/hdc		Master: whole disk (or CD-ROM)
 		 64 = /dev/hdd		Slave: whole disk (or CD-ROM)
-		
+
 		Partitions are handled the same way as for the first
 		interface (see major number 3).
 
@@ -639,6 +644,7 @@ Your cooperation is appreciated.
 
  26 char	Quanta WinVision frame grabber {2.6}
 		  0 = /dev/wvisfgrab	Quanta WinVision frame grabber
+
  26 block	Second Matsushita (Panasonic/SoundBlaster) CD-ROM
 		  0 = /dev/sbpcd4	Panasonic CD-ROM controller 1 unit 0
 		  1 = /dev/sbpcd5	Panasonic CD-ROM controller 1 unit 1
@@ -670,6 +676,7 @@ Your cooperation is appreciated.
 		 37 = /dev/nrawqft1	Unit 1, no rewind-on-close, no file marks
 		 38 = /dev/nrawqft2	Unit 2, no rewind-on-close, no file marks
 		 39 = /dev/nrawqft3	Unit 3, no rewind-on-close, no file marks
+
  27 block	Third Matsushita (Panasonic/SoundBlaster) CD-ROM
 		  0 = /dev/sbpcd8	Panasonic CD-ROM controller 2 unit 0
 		  1 = /dev/sbpcd9	Panasonic CD-ROM controller 2 unit 1
@@ -681,6 +688,7 @@ Your cooperation is appreciated.
 		  1 = /dev/staliomem1	Second Stallion card I/O memory
 		  2 = /dev/staliomem2	Third Stallion card I/O memory
 		  3 = /dev/staliomem3	Fourth Stallion card I/O memory
+
  28 char	Atari SLM ACSI laser printer (68k/Atari)
 		  0 = /dev/slm0		First SLM laser printer
 		  1 = /dev/slm1		Second SLM laser printer
@@ -690,6 +698,7 @@ Your cooperation is appreciated.
 		  1 = /dev/sbpcd13	Panasonic CD-ROM controller 3 unit 1
 		  2 = /dev/sbpcd14	Panasonic CD-ROM controller 3 unit 2
 		  3 = /dev/sbpcd15	Panasonic CD-ROM controller 3 unit 3
+
  28 block	ACSI disk (68k/Atari)
 		  0 = /dev/ada		First ACSI disk whole disk
 		 16 = /dev/adb		Second ACSI disk whole disk
@@ -750,6 +759,7 @@ Your cooperation is appreciated.
  31 char	MPU-401 MIDI
 		  0 = /dev/mpu401data	MPU-401 data port
 		  1 = /dev/mpu401stat	MPU-401 status port
+
  31 block	ROM/flash memory card
 		  0 = /dev/rom0		First ROM card (rw)
 		      ...
@@ -801,7 +811,7 @@ Your cooperation is appreciated.
  34 block	Fourth IDE hard disk/CD-ROM interface
 		  0 = /dev/hdg		Master: whole disk (or CD-ROM)
 		 64 = /dev/hdh		Slave: whole disk (or CD-ROM)
-		
+
 		Partitions are handled the same way as for the first
 		interface (see major number 3).
 
@@ -818,6 +828,7 @@ Your cooperation is appreciated.
 		129 = /dev/smpte1	Second MIDI port, SMPTE timed
 		130 = /dev/smpte2	Third MIDI port, SMPTE timed
 		131 = /dev/smpte3	Fourth MIDI port, SMPTE timed
+
  35 block	Slow memory ramdisk
 		  0 = /dev/slram	Slow memory ramdisk
 
@@ -828,6 +839,7 @@ Your cooperation is appreciated.
 		 16 = /dev/tap0		First Ethertap device
 		    ...
 		 31 = /dev/tap15	16th Ethertap device
+
  36 block	MCA ESDI hard disk
 		  0 = /dev/eda		First ESDI disk whole disk
 		 64 = /dev/edb		Second ESDI disk whole disk
@@ -882,6 +894,7 @@ Your cooperation is appreciated.
 
  40 char	Matrox Meteor frame grabber {2.6}
 		  0 = /dev/mmetfgrab	Matrox Meteor frame grabber
+
  40 block	Syquest EZ135 parallel port removable drive
 		  0 = /dev/eza		Parallel EZ135 drive, whole disk
 
@@ -893,6 +906,7 @@ Your cooperation is appreciated.
 
  41 char	Yet Another Micro Monitor
 		  0 = /dev/yamm		Yet Another Micro Monitor
+
  41 block	MicroSolutions BackPack parallel port CD-ROM
 		  0 = /dev/bpcd		BackPack CD-ROM
 
@@ -901,6 +915,7 @@ Your cooperation is appreciated.
 		the parallel port ATAPI CD-ROM driver at major number 46.
 
  42 char	Demo/sample use
+
  42 block	Demo/sample use
 
 		This number is intended for use in sample code, as
@@ -918,6 +933,7 @@ Your cooperation is appreciated.
 		  0 = /dev/ttyI0	First virtual modem
 		    ...
 		 63 = /dev/ttyI63	64th virtual modem
+
  43 block	Network block devices
 		  0 = /dev/nb0		First network block device
 		  1 = /dev/nb1		Second network block device
@@ -934,12 +950,13 @@ Your cooperation is appreciated.
 		  0 = /dev/cui0		Callout device for ttyI0
 		    ...
 		 63 = /dev/cui63	Callout device for ttyI63
+
  44 block	Flash Translation Layer (FTL) filesystems
 		  0 = /dev/ftla		FTL on first Memory Technology Device
 		 16 = /dev/ftlb		FTL on second Memory Technology Device
 		 32 = /dev/ftlc		FTL on third Memory Technology Device
 		    ...
-		240 = /dev/ftlp		FTL on 16th Memory Technology Device 
+		240 = /dev/ftlp		FTL on 16th Memory Technology Device
 
 		Partitions are handled in the same way as for IDE
 		disks (see major number 3) except that the partition
@@ -958,6 +975,7 @@ Your cooperation is appreciated.
 		191 = /dev/ippp63	64th SyncPPP device
 
 		255 = /dev/isdninfo	ISDN monitor interface
+
  45 block	Parallel port IDE disk devices
 		  0 = /dev/pda		First parallel port IDE disk
 		 16 = /dev/pdb		Second parallel port IDE disk
@@ -1044,6 +1062,7 @@ Your cooperation is appreciated.
 		  1 = /dev/dcbri1	Second DataComm card
 		  2 = /dev/dcbri2	Third DataComm card
 		  3 = /dev/dcbri3	Fourth DataComm card
+
  52 block	Mylex DAC960 PCI RAID controller; fifth controller
 		  0 = /dev/rd/c4d0	First disk, whole disk
 		  8 = /dev/rd/c4d1	Second disk, whole disk
@@ -1093,6 +1112,7 @@ Your cooperation is appreciated.
 
  55 char	DSP56001 digital signal processor
 		  0 = /dev/dsp56k	First DSP56001
+
  55 block	Mylex DAC960 PCI RAID controller; eighth controller
 		  0 = /dev/rd/c7d0	First disk, whole disk
 		  8 = /dev/rd/c7d1	Second disk, whole disk
@@ -1130,6 +1150,7 @@ Your cooperation is appreciated.
 		  0 = /dev/cup0		Callout device for ttyP0
 		  1 = /dev/cup1		Callout device for ttyP1
 		    ...
+
  58 block	Reserved for logical volume manager
 
  59 char	sf firewall package
@@ -1149,6 +1170,7 @@ Your cooperation is appreciated.
 		NAMING CONFLICT -- PROPOSED REVISED NAME /dev/rpda0 etc
 
  60-63 char	LOCAL/EXPERIMENTAL USE
+
  60-63 block	LOCAL/EXPERIMENTAL USE
 		Allocated for local/experimental use.  For devices not
 		assigned official numbers, these ranges should be
@@ -1434,7 +1456,6 @@ Your cooperation is appreciated.
 		DAC960 (see major number 48) except that the limit on
 		partitions is 15.
 
-
  78 char	PAM Software's multimodem boards
 		  0 = /dev/ttyM0	First PAM modem
 		  1 = /dev/ttyM1	Second PAM modem
@@ -1450,7 +1471,6 @@ Your cooperation is appreciated.
 		DAC960 (see major number 48) except that the limit on
 		partitions is 15.
 
-
  79 char	PAM Software's multimodem boards - alternate devices
 		  0 = /dev/cum0		Callout device for ttyM0
 		  1 = /dev/cum1		Callout device for ttyM1
@@ -1466,7 +1486,6 @@ Your cooperation is appreciated.
 		DAC960 (see major number 48) except that the limit on
 		partitions is 15.
 
-
  80 char	Photometrics AT200 CCD camera
 		  0 = /dev/at200	Photometrics AT200 CCD camera
 
@@ -1679,7 +1698,7 @@ Your cooperation is appreciated.
 		  1 = /dev/dcxx1	Second capture card
 		    ...
 
- 94 block IBM S/390 DASD block storage
+ 94 block	IBM S/390 DASD block storage
     		  0 = /dev/dasda First DASD device, major
     		  1 = /dev/dasda1 First DASD device, block 1
 	    	  2 = /dev/dasda2 First DASD device, block 2
@@ -1695,7 +1714,7 @@ Your cooperation is appreciated.
 		  1 = /dev/ipnat	NAT control device/log file
 		  2 = /dev/ipstate	State information log file
 		  3 = /dev/ipauth	Authentication control device/log file
-		    ...		
+		    ...
 
  96 char	Parallel port ATAPI tape devices
 		  0 = /dev/pt0		First parallel port ATAPI tape
@@ -1705,7 +1724,7 @@ Your cooperation is appreciated.
 		129 = /dev/npt1		Second p.p. ATAPI tape, no rewind
 		    ...
 
- 96 block Inverse NAND Flash Translation Layer
+ 96 block	Inverse NAND Flash Translation Layer
 		  0 = /dev/inftla First INFTL layer
 		 16 = /dev/inftlb Second INFTL layer
 		    ...
@@ -1937,7 +1956,6 @@ Your cooperation is appreciated.
 		    ...
 
 113 block	IBM iSeries virtual CD-ROM
-
 		  0 = /dev/iseries/vcda	First virtual CD-ROM
 		  1 = /dev/iseries/vcdb	Second virtual CD-ROM
 		    ...
@@ -2059,11 +2077,12 @@ Your cooperation is appreciated.
 		    ...
 
 119 char	VMware virtual network control
-		  0 = /dev/vnet0	1st virtual network
-		  1 = /dev/vnet1	2nd virtual network
+		  0 = /dev/vmnet0	1st virtual network
+		  1 = /dev/vmnet1	2nd virtual network
 		    ...
 
 120-127 char	LOCAL/EXPERIMENTAL USE
+
 120-127 block	LOCAL/EXPERIMENTAL USE
 		Allocated for local/experimental use.  For devices not
 		assigned official numbers, these ranges should be
@@ -2075,7 +2094,6 @@ Your cooperation is appreciated.
 		nodes; instead they should be accessed through the
 		/dev/ptmx cloning interface.
 
-
 128 block       SCSI disk devices (128-143)
                   0 = /dev/sddy         129th SCSI disk whole disk
                  16 = /dev/sddz         130th SCSI disk whole disk
@@ -2087,7 +2105,6 @@ Your cooperation is appreciated.
 		disks (see major number 3) except that the limit on
 		partitions is 15.
 
-
 129 block       SCSI disk devices (144-159)
                   0 = /dev/sdeo         145th SCSI disk whole disk
                  16 = /dev/sdep         146th SCSI disk whole disk
@@ -2123,7 +2140,6 @@ Your cooperation is appreciated.
 		disks (see major number 3) except that the limit on
 		partitions is 15.
 
-
 132 block       SCSI disk devices (192-207)
                   0 = /dev/sdgk         193rd SCSI disk whole disk
                  16 = /dev/sdgl         194th SCSI disk whole disk
@@ -2135,7 +2151,6 @@ Your cooperation is appreciated.
 		disks (see major number 3) except that the limit on
 		partitions is 15.
 
-
 133 block       SCSI disk devices (208-223)
                   0 = /dev/sdha         209th SCSI disk whole disk
                  16 = /dev/sdhb         210th SCSI disk whole disk
@@ -2147,7 +2162,6 @@ Your cooperation is appreciated.
 		disks (see major number 3) except that the limit on
 		partitions is 15.
 
-
 134 block       SCSI disk devices (224-239)
                   0 = /dev/sdhq         225th SCSI disk whole disk
                  16 = /dev/sdhr         226th SCSI disk whole disk
@@ -2159,7 +2173,6 @@ Your cooperation is appreciated.
 		disks (see major number 3) except that the limit on
 		partitions is 15.
 
-
 135 block       SCSI disk devices (240-255)
                   0 = /dev/sdig         241st SCSI disk whole disk
                  16 = /dev/sdih         242nd SCSI disk whole disk
@@ -2171,7 +2184,6 @@ Your cooperation is appreciated.
 		disks (see major number 3) except that the limit on
 		partitions is 15.
 
-
 136-143 char	Unix98 PTY slaves
 		  0 = /dev/pts/0	First Unix98 pseudo-TTY
 		  1 = /dev/pts/1	Second Unix98 pesudo-TTY
@@ -2384,6 +2396,7 @@ Your cooperation is appreciated.
 		    ...
 
 159 char	RESERVED
+
 159 block	RESERVED
 
 160 char	General Purpose Instrument Bus (GPIB)
@@ -2427,7 +2440,7 @@ Your cooperation is appreciated.
 
 		Partitions are handled in the same way as for IDE
 		disks (see major number 3) except that the limit on
-		partitions is 31. 
+		partitions is 31.
 
 162 char	Raw block device interface
 		  0 = /dev/rawctl	Raw I/O control device
@@ -2483,7 +2496,6 @@ Your cooperation is appreciated.
 
 171 char	Reserved for IEEE 1394 (Firewire)
 
-
 172 char	Moxa Intellio serial card
 		  0 = /dev/ttyMX0	First Moxa port
 		  1 = /dev/ttyMX1	Second Moxa port
@@ -2543,9 +2555,6 @@ Your cooperation is appreciated.
 		 64 = /dev/usb/rio500	Diamond Rio 500
 		 65 = /dev/usb/usblcd	USBLCD Interface (info@usblcd.de)
 		 66 = /dev/usb/cpad0	Synaptics cPad (mouse/LCD)
-		 67 = /dev/usb/adutux0	1st Ontrak ADU device
-		    ...
-		 76 = /dev/usb/adutux10	10th Ontrak ADU device
 		 96 = /dev/usb/hiddev0	1st USB HID device
 		    ...
 		111 = /dev/usb/hiddev15	16th USB HID device
@@ -2558,7 +2567,7 @@ Your cooperation is appreciated.
 		132 = /dev/usb/idmouse	ID Mouse (fingerprint scanner) device
 		133 = /dev/usb/sisusbvga1	First SiSUSB VGA device
 		    ...
-		140 = /dev/usb/sisusbvga8	Eigth SISUSB VGA device
+		140 = /dev/usb/sisusbvga8	Eighth SISUSB VGA device
 		144 = /dev/usb/lcd	USB LCD device
 		160 = /dev/usb/legousbtower0	1st USB Legotower device
 		    ...
@@ -2571,7 +2580,7 @@ Your cooperation is appreciated.
 		  0 = /dev/uba		First USB block device
 		  8 = /dev/ubb		Second USB block device
 		 16 = /dev/ubc		Third USB block device
-		    ...
+ 		    ...
 
 181 char	Conrad Electronic parallel port radio clocks
 		  0 = /dev/pcfclock0	First Conrad radio clock
@@ -2657,7 +2666,7 @@ Your cooperation is appreciated.
 		 32 = /dev/mvideo/status2	Third device
 		    ...
 		    ...
-		240 = /dev/mvideo/status15	16th device 
+		240 = /dev/mvideo/status15	16th device
 		    ...
 
 195 char	Nvidia graphics devices
@@ -2795,6 +2804,10 @@ Your cooperation is appreciated.
 		    ...
 		 185 = /dev/ttyNX15		Hilscher netX serial port 15
 		 186 = /dev/ttyJ0		JTAG1 DCC protocol based serial port emulation
+		 187 = /dev/ttyUL0		Xilinx uartlite - port 0
+		    ...
+		 190 = /dev/ttyUL3		Xilinx uartlite - port 3
+		 191 = /dev/xvc0		Xen virtual console - port 0
 
 205 char	Low-density serial ports (alternate device)
 		  0 = /dev/culu0		Callout device for ttyLU0
@@ -2832,7 +2845,6 @@ Your cooperation is appreciated.
 		 82 = /dev/cuvr0		Callout device for ttyVR0
 		 83 = /dev/cuvr1		Callout device for ttyVR1
 
-
 206 char	OnStream SC-x0 tape devices
 		  0 = /dev/osst0		First OnStream SCSI tape, mode 0
 		  1 = /dev/osst1		Second OnStream SCSI tape, mode 0
@@ -2922,7 +2934,6 @@ Your cooperation is appreciated.
 		    ...
 
 212 char	LinuxTV.org DVB driver subsystem
-
 		  0 = /dev/dvb/adapter0/video0    first video decoder of first card
 		  1 = /dev/dvb/adapter0/audio0    first audio decoder of first card
 		  2 = /dev/dvb/adapter0/sec0      (obsolete/unused)
@@ -3008,9 +3019,9 @@ Your cooperation is appreciated.
 		  2 = /dev/3270/tub2		Second 3270 terminal
 		    ...
 
-229 char	IBM iSeries virtual console
-		  0 = /dev/iseries/vtty0	First console port
-		  1 = /dev/iseries/vtty1	Second console port
+229 char	IBM iSeries/pSeries virtual console
+		  0 = /dev/hvc0			First console port
+		  1 = /dev/hvc1			Second console port
 		    ...
 
 230 char	IBM iSeries virtual tape
@@ -3083,12 +3094,14 @@ Your cooperation is appreciated.
 234-239		UNASSIGNED
 
 240-254 char	LOCAL/EXPERIMENTAL USE
+
 240-254 block	LOCAL/EXPERIMENTAL USE
 		Allocated for local/experimental use.  For devices not
 		assigned official numbers, these ranges should be
 		used in order to avoid conflicting with future assignments.
 
 255 char	RESERVED
+
 255 block	RESERVED
 
 		This major is reserved to assist the expansion to a
@@ -3115,7 +3128,20 @@ Your cooperation is appreciated.
 257 char	Phoenix Technologies Cryptographic Services Driver
 		  0 = /dev/ptlsec	Crypto Services Driver
 
-
+257 block	SSFDC Flash Translation Layer filesystem
+		  0 = /dev/ssfdca	First SSFDC layer
+		  8 = /dev/ssfdcb	Second SSFDC layer
+		 16 = /dev/ssfdcc	Third SSFDC layer
+		 24 = /dev/ssfdcd	4th SSFDC layer
+		 32 = /dev/ssfdce	5th SSFDC layer
+		 40 = /dev/ssfdcf	6th SSFDC layer
+		 48 = /dev/ssfdcg	7th SSFDC layer
+		 56 = /dev/ssfdch	8th SSFDC layer
+
+258 block	ROM/Flash read-only translation layer
+		  0 = /dev/blockrom0	First ROM card's translation layer interface
+		  1 = /dev/blockrom1	Second ROM card's translation layer interface
+		  ...
 
  ****	ADDITIONAL /dev DIRECTORY ENTRIES
 
_

Patches currently in -mm which might be from torben.mathiasen@hp.com are

origin.patch

