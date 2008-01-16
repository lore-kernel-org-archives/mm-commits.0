From: akpm@linux-foundation.org
Subject: - ti_usb-termios-cleanups.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:39:46 -0800
Message-ID: <200801160139.m0G1dkbn014032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41405 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756464AbYAPBts (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:49:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     ti_usb: termios cleanups
has been removed from the -mm tree.  Its filename was
     ti_usb-termios-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ti_usb: termios cleanups
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Remove internal NULL passing in termios code
Remove all the if checks it causes
Encode the baud rate back properly
Clear CMSPAR as it is not supported

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ti_usb_3410_5052.c |   31 ++++++++++--------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff -puN drivers/usb/serial/ti_usb_3410_5052.c~ti_usb-termios-cleanups drivers/usb/serial/ti_usb_3410_5052.c
--- a/drivers/usb/serial/ti_usb_3410_5052.c~ti_usb-termios-cleanups
+++ a/drivers/usb/serial/ti_usb_3410_5052.c
@@ -581,7 +581,7 @@ static int ti_open(struct usb_serial_por
 		}
 	}
 
-	ti_set_termios(port, NULL);
+	ti_set_termios(port, &port->tty->termios);
 
 	dbg("%s - sending TI_OPEN_PORT", __FUNCTION__);
 	status = ti_command_out_sync(tdev, TI_OPEN_PORT,
@@ -618,7 +618,7 @@ static int ti_open(struct usb_serial_por
 	usb_clear_halt(dev, port->write_urb->pipe);
 	usb_clear_halt(dev, port->read_urb->pipe);
 
-	ti_set_termios(port, NULL);
+	ti_set_termios(port, &port->tty->termios);
 
 	dbg("%s - sending TI_OPEN_PORT (2)", __FUNCTION__);
 	status = ti_command_out_sync(tdev, TI_OPEN_PORT,
@@ -897,24 +897,11 @@ static void ti_set_termios(struct usb_se
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
 
-	if (!tty || !tty->termios) {
-		dbg("%s - no tty or termios", __FUNCTION__);
-		return;
-	}
-
 	cflag = tty->termios->c_cflag;
 	iflag = tty->termios->c_iflag;
 
-	if (old_termios && cflag == old_termios->c_cflag
-	&& iflag == old_termios->c_iflag) {
-		dbg("%s - nothing to change", __FUNCTION__);
-		return;
-	}
-
-	dbg("%s - clfag %08x, iflag %08x", __FUNCTION__, cflag, iflag);
-
-	if (old_termios)
-		dbg("%s - old clfag %08x, old iflag %08x", __FUNCTION__, old_termios->c_cflag, old_termios->c_iflag);
+	dbg("%s - cflag %08x, iflag %08x", __FUNCTION__, cflag, iflag);
+	dbg("%s - old clfag %08x, old iflag %08x", __FUNCTION__, old_termios->c_cflag, old_termios->c_iflag);
 
 	if (tport == NULL)
 		return;
@@ -948,6 +935,9 @@ static void ti_set_termios(struct usb_se
 			    break;
 	}
 
+	/* CMSPAR isn't supported by this driver */
+	tty->termios->c_cflag &= ~CMSPAR;
+
 	if (cflag & PARENB) {
 		if (cflag & PARODD) {
 			config->wFlags |= TI_UART_ENABLE_PARITY_CHECKING;
@@ -990,12 +980,17 @@ static void ti_set_termios(struct usb_se
 	}
 
 	baud = tty_get_baud_rate(tty);
-	if (!baud) baud = 9600;
+	if (!baud)
+		baud = 9600;
 	if (tport->tp_tdev->td_is_3410)
 		config->wBaudRate = (__u16)((923077 + baud/2) / baud);
 	else
 		config->wBaudRate = (__u16)((461538 + baud/2) / baud);
 
+	/* FIXME: Should calculate resulting baud here and report it back */
+	if ((cflag & CBAUD) != B0)
+		tty_encode_baud_rate(tty, baud, baud);
+
 	dbg("%s - BaudRate=%d, wBaudRate=%d, wFlags=0x%04X, bDataBits=%d, bParity=%d, bStopBits=%d, cXon=%d, cXoff=%d, bUartMode=%d",
 	__FUNCTION__, baud, config->wBaudRate, config->wFlags, config->bDataBits, config->bParity, config->bStopBits, config->cXon, config->cXoff, config->bUartMode);
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-acpi.patch
git-arm.patch
git-libata-all.patch
git-libata-all-wtf.patch
pata_legacy-resychronize-with-upstream-changes-and-resubmit.patch
git-netdev-all.patch
bluetooth-rfcomm-tty_close-before-destruct.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250c-support-specifying-dw-apb-uarts-in-device-platform_data.patch
avoid-waking-up-closed-serial-ports-on-resume.patch
serial-avoid-stalling-suspend-if-serial-port-wont-drain.patch
serial-speed-setup-failure-reporting.patch
serial-coding-style.patch
git-scsi-misc.patch
wdt-fix-locking.patch
wdt-fix-locking-checkpatch-fixes.patch
git-x86.patch
keyspan-fix-oops.patch
geode-lists-are-subscriber-only.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
documentation-about-unaligned-memory-access.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline.patch
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
