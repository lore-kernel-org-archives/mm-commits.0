From: akpm@linux-foundation.org
Subject: - belkin_sa-clean-up-for-new-style-termios-and-speed.patch removed from -mm tree
Date: Fri, 21 Dec 2007 14:08:28 -0800
Message-ID: <200712212208.lBLM8Stt001714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41779 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756544AbXLUWJt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 17:09:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     belkin_sa: clean up for new style termios and speed  handling, plus style
has been removed from the -mm tree.  Its filename was
     belkin_sa-clean-up-for-new-style-termios-and-speed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-arm.patch
git-libata-all.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
git-netdev-all.patch
bluetooth-rfcomm-tty_close-before-destruct.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
geode-lists-are-subscriber-only.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
documentation-about-unaligned-memory-access.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
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
