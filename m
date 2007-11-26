From: akpm@linux-foundation.org
Subject: + belkin_sa-clean-up-for-new-style-termios-and-speed.patch added to -mm tree
Date: Mon, 26 Nov 2007 14:52:34 -0800
Message-ID: <200711262252.lAQMqYHQ027167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48673 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753432AbXKZWx0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 17:53:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com


The patch titled
     belkin_sa: clean up for new style termios and speed  handling, plus style
has been added to the -mm tree.  Its filename is
     belkin_sa-clean-up-for-new-style-termios-and-speed.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: belkin_sa: clean up for new style termios and speed  handling, plus style
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

A tester with actual hardware would be useful

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/belkin_sa.c |   35 +++++++++++++------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff -puN drivers/usb/serial/belkin_sa.c~belkin_sa-clean-up-for-new-style-termios-and-speed drivers/usb/serial/belkin_sa.c
--- a/drivers/usb/serial/belkin_sa.c~belkin_sa-clean-up-for-new-style-termios-and-speed
+++ a/drivers/usb/serial/belkin_sa.c
@@ -350,14 +350,12 @@ static void belkin_sa_set_termios (struc
 	unsigned long control_state;
 	int bad_flow_control;
 	speed_t baud;
+	struct ktermios *termios = port->tty->termios;
 	
-	if ((!port->tty) || (!port->tty->termios)) {
-		dbg ("%s - no tty or termios structure", __FUNCTION__);
-		return;
-	}
+	iflag = termios->c_iflag;
+	cflag = termios->c_cflag;
 
-	iflag = port->tty->termios->c_iflag;
-	cflag = port->tty->termios->c_cflag;
+	termios->c_cflag &= ~CMSPAR;
 
 	/* get a local copy of the current port settings */
 	spin_lock_irqsave(&priv->lock, flags);
@@ -369,33 +367,30 @@ static void belkin_sa_set_termios (struc
 	old_cflag = old_termios->c_cflag;
 
 	/* Set the baud rate */
-	if( (cflag&CBAUD) != (old_cflag&CBAUD) ) {
+	if ((cflag & CBAUD) != (old_cflag & CBAUD)) {
 		/* reassert DTR and (maybe) RTS on transition from B0 */
 		if( (old_cflag&CBAUD) == B0 ) {
 			control_state |= (TIOCM_DTR|TIOCM_RTS);
 			if (BSA_USB_CMD(BELKIN_SA_SET_DTR_REQUEST, 1) < 0)
 				err("Set DTR error");
 			/* don't set RTS if using hardware flow control */
-			if (!(old_cflag&CRTSCTS) )
+			if (!(old_cflag & CRTSCTS))
 				if (BSA_USB_CMD(BELKIN_SA_SET_RTS_REQUEST, 1) < 0)
 					err("Set RTS error");
 		}
 	}
 
 	baud = tty_get_baud_rate(port->tty);
-	if (baud == 0) {
-		dbg("%s - tty_get_baud_rate says 0 baud", __FUNCTION__);
-		return;
-	}
-	urb_value = BELKIN_SA_BAUD(baud);
-	/* Clip to maximum speed */
-	if (urb_value == 0)
-		urb_value = 1;
-	/* Turn it back into a resulting real baud rate */
-	baud = BELKIN_SA_BAUD(urb_value);
-	/* FIXME: Once the tty updates are done then push this back to the tty */
+	if (baud) {
+		urb_value = BELKIN_SA_BAUD(baud);
+		/* Clip to maximum speed */
+		if (urb_value == 0)
+			urb_value = 1;
+		/* Turn it back into a resulting real baud rate */
+		baud = BELKIN_SA_BAUD(urb_value);
 
-	if ((cflag & CBAUD) != B0 ) {
+		/* Report the actual baud rate back to the caller */
+		tty_encode_baud_rate(port->tty, baud, baud);
 		if (BSA_USB_CMD(BELKIN_SA_SET_BAUDRATE_REQUEST, urb_value) < 0)
 			err("Set baudrate error");
 	} else {
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
