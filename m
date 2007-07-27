From: akpm@linux-foundation.org
Subject: + mct_u232-convert-to-proper-speed-handling-api.patch added to -mm tree
Date: Thu, 26 Jul 2007 23:03:32 -0700
Message-ID: <200707270603.l6R63W5C008630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60736 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753368AbXG0GEQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 02:04:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, zaitcev@redhat.com


The patch titled
     mct_u232: convert to proper speed handling API
has been added to the -mm tree.  Its filename is
     mct_u232-convert-to-proper-speed-handling-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mct_u232: convert to proper speed handling API
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/mct_u232.c |   54 ++++++++++++++++----------------
 drivers/usb/serial/mct_u232.h |    2 -
 2 files changed, 28 insertions(+), 28 deletions(-)

diff -puN drivers/usb/serial/mct_u232.c~mct_u232-convert-to-proper-speed-handling-api drivers/usb/serial/mct_u232.c
--- a/drivers/usb/serial/mct_u232.c~mct_u232-convert-to-proper-speed-handling-api
+++ a/drivers/usb/serial/mct_u232.c
@@ -184,21 +184,21 @@ struct mct_u232_private {
  * we do not know how to support. We ignore them for the moment.
  * XXX Rate-limit the error message, it's user triggerable.
  */
-static int mct_u232_calculate_baud_rate(struct usb_serial *serial, int value)
+static int mct_u232_calculate_baud_rate(struct usb_serial *serial, speed_t value)
 {
 	if (le16_to_cpu(serial->dev->descriptor.idProduct) == MCT_U232_SITECOM_PID
 	  || le16_to_cpu(serial->dev->descriptor.idProduct) == MCT_U232_BELKIN_F5U109_PID) {
 		switch (value) {
-		case    B300: return 0x01;
-		case    B600: return 0x02; /* this one not tested */
-		case   B1200: return 0x03;
-		case   B2400: return 0x04;
-		case   B4800: return 0x06;
-		case   B9600: return 0x08;
-		case  B19200: return 0x09;
-		case  B38400: return 0x0a;
-		case  B57600: return 0x0b;
-		case B115200: return 0x0c;
+		case    300: return 0x01;
+		case    600: return 0x02; /* this one not tested */
+		case   1200: return 0x03;
+		case   2400: return 0x04;
+		case   4800: return 0x06;
+		case   9600: return 0x08;
+		case  19200: return 0x09;
+		case  38400: return 0x0a;
+		case  57600: return 0x0b;
+		case 115200: return 0x0c;
 		default:
 			err("MCT USB-RS232: unsupported baudrate request 0x%x,"
 			    " using default of B9600", value);
@@ -206,27 +206,27 @@ static int mct_u232_calculate_baud_rate(
 		}
 	} else {
 		switch (value) {
-		case    B300: value =     300; break;
-		case    B600: value =     600; break;
-		case   B1200: value =    1200; break;
-		case   B2400: value =    2400; break;
-		case   B4800: value =    4800; break;
-		case   B9600: value =    9600; break;
-		case  B19200: value =   19200; break;
-		case  B38400: value =   38400; break;
-		case  B57600: value =   57600; break;
-		case B115200: value =  115200; break;
-		default:
-			err("MCT USB-RS232: unsupported baudrate request 0x%x,"
-			    " using default of B9600", value);
-			value = 9600;
+			case 300: break;
+			case 600: break;
+			case 1200: break;
+			case 2400: break;
+			case 4800: break;
+			case 9600: break;
+			case 19200: break;
+			case 38400: break;
+			case 57600: break;
+			case 115200: break;
+			default:
+				err("MCT USB-RS232: unsupported baudrate request 0x%x,"
+				    " using default of B9600", value);
+				value = 9600;
 		}
 		return 115200/value;
 	}
 }
 
 static int mct_u232_set_baud_rate(struct usb_serial *serial, struct usb_serial_port *port,
-				  int value)
+				  speed_t value)
 {
 	__le32 divisor;
         int rc;
@@ -634,7 +634,7 @@ static void mct_u232_set_termios (struct
 		mct_u232_set_modem_ctrl(serial, control_state);
 	}
 
-	mct_u232_set_baud_rate(serial, port, cflag & CBAUD);
+	mct_u232_set_baud_rate(serial, port, tty_get_baud_rate(port->tty));
 
 	if ((cflag & CBAUD) == B0 ) {
 		dbg("%s: baud is B0", __FUNCTION__);
diff -puN drivers/usb/serial/mct_u232.h~mct_u232-convert-to-proper-speed-handling-api drivers/usb/serial/mct_u232.h
--- a/drivers/usb/serial/mct_u232.h~mct_u232-convert-to-proper-speed-handling-api
+++ a/drivers/usb/serial/mct_u232.h
@@ -79,7 +79,7 @@
  * and "Intel solution". They are the regular MCT and "Sitecom" for us.
  * This is pointless to document in the header, see the code for the bits.
  */
-static int mct_u232_calculate_baud_rate(struct usb_serial *serial, int value);
+static int mct_u232_calculate_baud_rate(struct usb_serial *serial, speed_t value);
 
 /*
  * Line Control Register (LCR)
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
drivers-edac-fix-reset-edac_mc-pollmsec.patch
drivers-edac-fix-edac_pci-sysfs.patch
include-asm-mips-add-missing-edac-h-file.patch
drivers-edac-fix-pasemi-kconfig-depends.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
nozomi-shoot-defunct-label.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch
libata-acpi-checks-for-80wire-cable-headers.patch
libata-acpi-checks-for-80wire-cable-implementation.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_via.patch
libata-sff-unbreak-non-dma-capable-controllers-again.patch
pata_cmd64x-correct-the-speed-ranges.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
lib8390-comment-on-locking-by-alan-cox.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
git-scsi-rc-fixes.patch
dtc-clean-up-indent-damage-and-add-printk-levels.patch
digi_acceleport-drag-the-driver-kicking-and-screaming-into.patch
kl5kusb105-switch-to-new-speed-api.patch
mct_u232-convert-to-proper-speed-handling-api.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
geode-setup-correct-chipset-access-functions-fix.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
blackfin-enable-arbitary-speed-serial-setting.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe.patch
remove-kconfig-setting-config_debug_shirq.patch
debug-handling-of-early-spurious-interrupts.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
