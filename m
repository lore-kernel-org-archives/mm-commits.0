From: akpm@linux-foundation.org
Subject: + cris-build-fixes-defconfig-updates.patch added to -mm tree
Date: Tue, 30 Oct 2007 15:13:34 -0700
Message-ID: <200710302213.l9UMDYmE030511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51453 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752838AbXJ3WNi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 18:13:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     cris build fixes: defconfig updates
has been added to the -mm tree.  Its filename is
     cris-build-fixes-defconfig-updates.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cris build fixes: defconfig updates
From: Jesper Nilsson <jesper.nilsson@axis.com>

Remove some unused config lines, and add some others that needs to be off
for a succesful compile. This is the minimal set of changes for 2.6.23.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/defconfig |   76 ++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 43 deletions(-)

diff -puN arch/cris/defconfig~cris-build-fixes-defconfig-updates arch/cris/defconfig
--- a/arch/cris/defconfig~cris-build-fixes-defconfig-updates
+++ a/arch/cris/defconfig
@@ -276,6 +276,7 @@ CONFIG_MTDRAM_ABS_POS=0x0
 # CONFIG_BLK_DEV_FD is not set
 # CONFIG_BLK_DEV_COW_COMMON is not set
 # CONFIG_BLK_DEV_LOOP is not set
+# CONFIG_BLK_DEV_CRYPTOLOOP is not set
 # CONFIG_BLK_DEV_NBD is not set
 # CONFIG_BLK_DEV_UB is not set
 CONFIG_BLK_DEV_RAM=y
@@ -302,16 +303,14 @@ CONFIG_IOSCHED_CFQ=y
 #
 # ATA/ATAPI/MFM/RLL support
 #
-CONFIG_IDE=y
-CONFIG_BLK_DEV_IDE=y
+# CONFIG_IDE is not set
+# CONFIG_PARIDE is not set
 
 #
 # Please see Documentation/ide.txt for help/info on IDE drives
 #
 # CONFIG_BLK_DEV_IDE_SATA is not set
-CONFIG_BLK_DEV_IDEDISK=y
 # CONFIG_IDEDISK_MULTI_MODE is not set
-CONFIG_BLK_DEV_IDECD=y
 # CONFIG_BLK_DEV_IDETAPE is not set
 # CONFIG_BLK_DEV_IDEFLOPPY is not set
 # CONFIG_IDE_TASK_IOCTL is not set
@@ -321,7 +320,6 @@ CONFIG_BLK_DEV_IDECD=y
 #
 # CONFIG_IDE_GENERIC is not set
 # CONFIG_IDE_ARM is not set
-CONFIG_BLK_DEV_IDEDMA=y
 # CONFIG_IDEDMA_AUTO is not set
 # CONFIG_BLK_DEV_HD is not set
 
@@ -329,6 +327,7 @@ CONFIG_BLK_DEV_IDEDMA=y
 # SCSI device support
 #
 # CONFIG_SCSI is not set
+# CONFIG_ISCSI_TCP is not set
 
 #
 # IEEE 1394 (FireWire) support
@@ -414,26 +413,11 @@ CONFIG_NETFILTER=y
 # CONFIG_NET_POLL_CONTROLLER is not set
 # CONFIG_HAMRADIO is not set
 # CONFIG_IRDA is not set
-CONFIG_BT=y
-CONFIG_BT_L2CAP=y
-# CONFIG_BT_SCO is not set
-CONFIG_BT_RFCOMM=y
-# CONFIG_BT_RFCOMM_TTY is not set
-CONFIG_BT_BNEP=y
-# CONFIG_BT_BNEP_MC_FILTER is not set
-# CONFIG_BT_BNEP_PROTO_FILTER is not set
-# CONFIG_BT_HIDP is not set
-
-#
-# Bluetooth device drivers
-#
-CONFIG_BT_HCIUSB=y
-# CONFIG_BT_HCIUSB_SCO is not set
-# CONFIG_BT_HCIUART is not set
-# CONFIG_BT_HCIBCM203X is not set
-# CONFIG_BT_HCIBPA10X is not set
-# CONFIG_BT_HCIBFUSB is not set
-# CONFIG_BT_HCIVHCI is not set
+# CONFIG_AF_RXRPC is not set
+# CONFIG_AF_RXRPC_DEBUG is not set
+# CONFIG_BT is not set
+# CONFIG_I2C is not set
+
 CONFIG_NETDEVICES=y
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
@@ -485,31 +469,17 @@ CONFIG_NET_ETHERNET=y
 #
 # Input device support
 #
-CONFIG_INPUT=y
-
-#
-# Userland interfaces
-#
-CONFIG_INPUT_MOUSEDEV=y
-CONFIG_INPUT_MOUSEDEV_PSAUX=y
-CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
-CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
-# CONFIG_INPUT_JOYDEV is not set
-# CONFIG_INPUT_TSDEV is not set
-# CONFIG_INPUT_EVDEV is not set
-# CONFIG_INPUT_EVBUG is not set
+# CONFIG_INPUT is not set
 
 #
 # Input I/O drivers
 #
-# CONFIG_GAMEPORT is not set
-CONFIG_SOUND_GAMEPORT=y
 CONFIG_SERIO=y
 # CONFIG_SERIO_I8042 is not set
 # CONFIG_SERIO_SERPORT is not set
-# CONFIG_SERIO_CT82C710 is not set
-CONFIG_SERIO_LIBPS2=y
+# CONFIG_SERIO_LIBPS2 is not set
 # CONFIG_SERIO_RAW is not set
+# CONFIG_GAMEPORT is not set
 
 #
 # Input Device Drivers
@@ -525,6 +495,7 @@ CONFIG_MOUSE_PS2=y
 # CONFIG_MOUSE_SERIAL is not set
 # CONFIG_MOUSE_VSXXXAA is not set
 # CONFIG_INPUT_JOYSTICK is not set
+# CONFIG_INPUT_TABLET is not set
 # CONFIG_INPUT_TOUCHSCREEN is not set
 # CONFIG_INPUT_MISC is not set
 
@@ -542,6 +513,8 @@ CONFIG_MOUSE_PS2=y
 #
 # Non-8250 serial port support
 #
+CONFIG_SERIAL_CORE=y
+CONFIG_SERIAL_CORE_CONSOLE=y
 CONFIG_UNIX98_PTYS=y
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
@@ -559,6 +532,8 @@ CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_GEN_RTC is not set
 # CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
+# CONFIG_RTC_LIB is not set
+# CONFIG_RTC_CLASS is not set
 
 #
 # Ftape, the floppy tape device driver
@@ -660,7 +635,9 @@ CONFIG_NFS_V3=y
 # CONFIG_NFSD is not set
 CONFIG_LOCKD=y
 CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
+# CONFIG_SUNRPC_BIND34 is not set
 # CONFIG_RPCSEC_GSS_KRB5 is not set
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
 # CONFIG_SMB_FS is not set
@@ -686,9 +663,21 @@ CONFIG_MSDOS_PARTITION=y
 # CONFIG_SOUND is not set
 
 #
+# Generic devices
+#
+# CONFIG_SND_MPU401_UART is not set
+# CONFIG_SND_DUMMY is not set
+# CONFIG_SND_VIRMIDI is not set
+# CONFIG_SND_MTPAV is not set
+# CONFIG_SND_SERIAL_U16550 is not set
+# CONFIG_SND_MPU401 is not set
+
+#
 # PCCARD (PCMCIA/CardBus) support
 #
 # CONFIG_PCCARD is not set
+# CONFIG_PARPORT_PC_PCMCIA is not set
+# CONFIG_NET_PCMCIA is not set
 
 #
 # PC-card bridges
@@ -734,6 +723,7 @@ CONFIG_USB_DEVICEFS=y
 # USB Input Devices
 #
 # CONFIG_USB_HID is not set
+# HID_SUPPORT is not set
 
 #
 # USB HID Boot Protocol drivers
@@ -829,7 +819,7 @@ CONFIG_USB_RTL8150=y
 
 #
 # Hardware crypto devices
-#
+# CONFIG_CRYPTO_HW is not set
 
 #
 # Library routines
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

cris-build-fixes-fix-csum_tcpudp_magic-declaration.patch
cris-build-fixes-add-missing-syscalls.patch
cris-build-fixes-hardirqh-include-asm-irqh.patch
cris-build-fixes-atomich-needs-compilerh.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-irq-fixes.patch
cris-build-fixes-sys_crisc-needs-fsh.patch
cris-build-fixes-add-baud-rate-defines.patch
cris-build-fixes-update-eth_v10c-ethernet-driver.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-fix-mtdramh.patch
cris-build-fixes-fix-mtdramh-checkpatch-fixes.patch
cris-build-fixes-corrected-and-improved-nmi-and-irq-handling.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch
cris-build-fixes-setupc-needs-paramh.patch
cris-build-fixes-fix-crisksymsc.patch
cris-build-fixes-defconfig-updates.patch
