From: akpm@linux-foundation.org
Subject: + mct232-speed-new-termios-and-compliance-cleanups.patch added to -mm tree
Date: Mon, 26 Nov 2007 14:55:02 -0800
Message-ID: <200711262255.lAQMt2hg027304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51885 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596AbXKZWzy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 17:55:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, zaitcev@redhat.com


The patch titled
     mct232: speed, new termios and compliance cleanups
has been added to the -mm tree.  Its filename is
     mct232-speed-new-termios-and-compliance-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mct232: speed, new termios and compliance cleanups
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/mct_u232.c |   25 +++++++++++++++++--------
 drivers/usb/serial/mct_u232.h |    2 +-
 2 files changed, 18 insertions(+), 9 deletions(-)

diff -puN drivers/usb/serial/mct_u232.c~mct232-speed-new-termios-and-compliance-cleanups drivers/usb/serial/mct_u232.c
--- a/drivers/usb/serial/mct_u232.c~mct232-speed-new-termios-and-compliance-cleanups
+++ a/drivers/usb/serial/mct_u232.c
@@ -184,8 +184,10 @@ struct mct_u232_private {
  * we do not know how to support. We ignore them for the moment.
  * XXX Rate-limit the error message, it's user triggerable.
  */
-static int mct_u232_calculate_baud_rate(struct usb_serial *serial, speed_t value)
+static int mct_u232_calculate_baud_rate(struct usb_serial *serial, speed_t value, speed_t *result)
 {
+	*result = value;
+
 	if (le16_to_cpu(serial->dev->descriptor.idProduct) == MCT_U232_SITECOM_PID
 	  || le16_to_cpu(serial->dev->descriptor.idProduct) == MCT_U232_BELKIN_F5U109_PID) {
 		switch (value) {
@@ -200,11 +202,13 @@ static int mct_u232_calculate_baud_rate(
 		case  57600: return 0x0b;
 		case 115200: return 0x0c;
 		default:
-			err("MCT USB-RS232: unsupported baudrate request 0x%x,"
-			    " using default of B9600", value);
+			*result = 9600;
 			return 0x08;
 		}
 	} else {
+		/* FIXME: Can we use any divider - should we do
+		   divider = 115200/value;
+		   real baud = 115200/divider */
 		switch (value) {
 		case 300: break;
 		case 600: break;
@@ -217,9 +221,8 @@ static int mct_u232_calculate_baud_rate(
 		case 57600: break;
 		case 115200: break;
 		default:
-			err("MCT USB-RS232: unsupported baudrate request 0x%x,"
-			    " using default of B9600", value);
 			value = 9600;
+			*result = 9600;
 		}
 		return 115200/value;
 	}
@@ -232,16 +235,19 @@ static int mct_u232_set_baud_rate(struct
         int rc;
         unsigned char zero_byte = 0;
         unsigned char cts_enable_byte = 0;
+        speed_t speed;
 
-	divisor = cpu_to_le32(mct_u232_calculate_baud_rate(serial, value));
+	divisor = cpu_to_le32(mct_u232_calculate_baud_rate(serial, value, &speed));
 
         rc = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
                              MCT_U232_SET_BAUD_RATE_REQUEST,
 			     MCT_U232_SET_REQUEST_TYPE,
                              0, 0, &divisor, MCT_U232_SET_BAUD_RATE_SIZE,
 			     WDR_TIMEOUT);
-	if (rc < 0)
+	if (rc < 0)	/*FIXME: What value speed results */
 		err("Set BAUD RATE %d failed (error = %d)", value, rc);
+	else
+		tty_encode_baud_rate(port->tty, speed, speed);
 	dbg("set_baud_rate: value: 0x%x, divisor: 0x%x", value, divisor);
 
 	/* Mimic the MCT-supplied Windows driver (version 1.21P.0104), which
@@ -608,7 +614,8 @@ static void mct_u232_set_termios (struct
 {
 	struct usb_serial *serial = port->serial;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
-	unsigned int cflag = port->tty->termios->c_cflag;
+	struct ktermios *termios = port->tty->termios;
+	unsigned int cflag = termios->c_cflag;
 	unsigned int old_cflag = old_termios->c_cflag;
 	unsigned long flags;
 	unsigned int control_state;
@@ -670,6 +677,8 @@ static void mct_u232_set_termios (struct
 		break;
 	}
 
+	termios->c_cflag &= ~CMSPAR;
+
 	/* set the number of stop bits */
 	last_lcr |= (cflag & CSTOPB) ?
 		MCT_U232_STOP_BITS_2 : MCT_U232_STOP_BITS_1;
diff -puN drivers/usb/serial/mct_u232.h~mct232-speed-new-termios-and-compliance-cleanups drivers/usb/serial/mct_u232.h
--- a/drivers/usb/serial/mct_u232.h~mct232-speed-new-termios-and-compliance-cleanups
+++ a/drivers/usb/serial/mct_u232.h
@@ -79,7 +79,7 @@
  * and "Intel solution". They are the regular MCT and "Sitecom" for us.
  * This is pointless to document in the header, see the code for the bits.
  */
-static int mct_u232_calculate_baud_rate(struct usb_serial *serial, speed_t value);
+static int mct_u232_calculate_baud_rate(struct usb_serial *serial, speed_t value, speed_t *result);
 
 /*
  * Line Control Register (LCR)
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

termios-document-callback-more-clearly.patch
revert-keyspan-init-termios-properly.patch
git-arm.patch
git-libata-all.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes.patch
libata-fix-ata_acpi_gtm_xfermask.patch
libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi.patch
libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask.patch
libata-add-ata_cbl_pata_ign.patch
pata_amd-update-mode-selection-for-nv-patas.patch
pata_pcmcia-minor-cleanups-and-support-for-dual-channel-cards.patch
git-netdev-all.patch
bluetooth-rfcomm-tty_close-before-destruct.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-scsi-rc-fixes.patch
initio-fix-conflict-when-loading-driver.patch
belkin_sa-clean-up-for-new-style-termios-and-speed.patch
keyspan_pda-clean-up-speed-handling.patch
mct232-speed-new-termios-and-compliance-cleanups.patch
mct232-speed-new-termios-and-compliance-cleanups-fix.patch
pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
tty-add-the-new-termios2-ioctls-to-the-compatible.patch
geode-lists-are-subscriber-only.patch
tty-kill-tty_flipbuf_size.patch
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch
tty-let-architectures-override-the-user-kernel-macros.patch
tty-s390-support-for-termios2.patch
moxa-first-pass-at-termios-reporting.patch
n_tty-clean-up-old-code-to-follow-coding-style-and-mostly-checkpatch.patch
rocket-first-pass-at-termios-reporting.patch
rocket-dont-let-random-users-reset-the-controller.patch
tty_audit-fix-checkpatch-complaint.patch
tty_io-drag-screaming-into-coding-style-compliance.patch
tty_ioctl-drag-screaming-into-compliance-with-the-coding.patch
8250_early-coding-style.patch
8250_gsc-coding-style.patch
8250_hp300-coding-style.patch
8250_hub6-codding-style.patch
8250_pci-coding-style.patch
serial8250-coding-style.patch
8250-enable-rate-reporting-via-termios.patch
serial_core-bring-mostly-into-line-with-coding-style.patch
