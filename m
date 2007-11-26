From: akpm@linux-foundation.org
Subject: + keyspan_pda-clean-up-speed-handling.patch added to -mm tree
Date: Mon, 26 Nov 2007 14:53:06 -0800
Message-ID: <200711262253.lAQMr6Ld027199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43135 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755543AbXKZWx5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 17:53:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com


The patch titled
     keyspan_pda: clean up speed handling
has been added to the -mm tree.  Its filename is
     keyspan_pda-clean-up-speed-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: keyspan_pda: clean up speed handling
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/keyspan_pda.c |   40 ++++++++++++++---------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff -puN drivers/usb/serial/keyspan_pda.c~keyspan_pda-clean-up-speed-handling drivers/usb/serial/keyspan_pda.c
--- a/drivers/usb/serial/keyspan_pda.c~keyspan_pda-clean-up-speed-handling
+++ a/drivers/usb/serial/keyspan_pda.c
@@ -303,7 +303,7 @@ static void keyspan_pda_rx_unthrottle (s
 }
 
 
-static int keyspan_pda_setbaud (struct usb_serial *serial, int baud)
+static speed_t keyspan_pda_setbaud (struct usb_serial *serial, speed_t baud)
 {
 	int rc;
 	int bindex;
@@ -319,7 +319,9 @@ static int keyspan_pda_setbaud (struct u
 		case 38400: bindex = 7; break;
 		case 57600: bindex = 8; break;
 		case 115200: bindex = 9; break;
-		default: return -EINVAL;
+		default:
+			bindex = 5;	/* Default to 9600 */
+			baud = 9600;
 	}
 
 	/* rather than figure out how to sleep while waiting for this
@@ -334,7 +336,9 @@ static int keyspan_pda_setbaud (struct u
 			     NULL, /* &data */
 			     0, /* size */
 			     2000); /* timeout */
-	return(rc);
+	if (rc < 0)
+		return 0;
+	return baud;
 }
 
 
@@ -366,7 +370,7 @@ static void keyspan_pda_set_termios (str
 				     struct ktermios *old_termios)
 {
 	struct usb_serial *serial = port->serial;
-	unsigned int cflag = port->tty->termios->c_cflag;
+	speed_t speed;
 
 	/* cflag specifies lots of stuff: number of stop bits, parity, number
 	   of data bits, baud. What can the device actually handle?:
@@ -388,22 +392,18 @@ static void keyspan_pda_set_termios (str
 
 	   For now, just do baud. */
 
-	switch (cflag & CBAUD) {
-		/* we could support more values here, just need to calculate
-		   the necessary divisors in the firmware. <asm/termbits.h>
-		   has the Bnnn constants. */
-		case B110: keyspan_pda_setbaud(serial, 110); break;
-		case B300: keyspan_pda_setbaud(serial, 300); break;
-		case B1200: keyspan_pda_setbaud(serial, 1200); break;
-		case B2400: keyspan_pda_setbaud(serial, 2400); break;
-		case B4800: keyspan_pda_setbaud(serial, 4800); break;
-		case B9600: keyspan_pda_setbaud(serial, 9600); break;
-		case B19200: keyspan_pda_setbaud(serial, 19200); break;
-		case B38400: keyspan_pda_setbaud(serial, 38400); break;
-		case B57600: keyspan_pda_setbaud(serial, 57600); break;
-		case B115200: keyspan_pda_setbaud(serial, 115200); break;
-		default: dbg("can't handle requested baud rate"); break;
-	}
+	speed = tty_get_baud_rate(port->tty);
+	speed = keyspan_pda_setbaud(serial, speed);
+
+	if (speed == 0) {
+		dbg("can't handle requested baud rate");
+		/* It hasn't changed so.. */
+		speed = tty_termios_baud_rate(old_termios);
+	}
+	/* Only speed can change so copy the old h/w parameters
+	   then encode the new speed */
+	tty_termios_copy_hw(port->tty->termios, old_termios);
+	tty_encode_baud_rate(port->tty, speed, speed);
 }
 
 
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
