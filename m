From: akpm@linux-foundation.org
Subject: - io_ti-clean-up-termios-handling.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:39:50 -0800
Message-ID: <200801160139.m0G1dofQ014038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44289 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756460AbYAPBto (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:49:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     io_ti: clean up termios handling
has been removed from the -mm tree.  Its filename was
     io_ti-clean-up-termios-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: io_ti: clean up termios handling
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Don't pass NULL into termios functions when calling them internally Remove
all the crap which then checks for NULL which can't occur now.

Clear CMSPAR as it is not supported.

Report the baud rate back to the caller properly (See FIXME someone with
the docs).

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/io_ti.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff -puN drivers/usb/serial/io_ti.c~io_ti-clean-up-termios-handling drivers/usb/serial/io_ti.c
--- a/drivers/usb/serial/io_ti.c~io_ti-clean-up-termios-handling
+++ a/drivers/usb/serial/io_ti.c
@@ -1979,7 +1979,7 @@ static int edge_open (struct usb_serial_
 	}
 	
 	/* set up the port settings */
-	edge_set_termios (port, NULL);
+	edge_set_termios (port, port->tty->termios);
 
 	/* open up the port */
 
@@ -2394,11 +2394,6 @@ static void change_port_settings (struct
 	dbg("%s - port %d", __FUNCTION__, edge_port->port->number);
 
 	tty = edge_port->port->tty;
-	if ((!tty) ||
-	    (!tty->termios)) {
-		dbg("%s - no tty structures", __FUNCTION__);
-		return;
-	}
 
 	config = kmalloc (sizeof (*config), GFP_KERNEL);
 	if (!config) {
@@ -2493,14 +2488,20 @@ static void change_port_settings (struct
 		}
 	}
 
+	tty->termios->c_cflag &= ~CMSPAR;
+
 	/* Round the baud rate */
 	baud = tty_get_baud_rate(tty);
 	if (!baud) {
 		/* pick a default, any default... */
 		baud = 9600;
-	}
+	} else
+		tty_encode_baud_rate(tty, baud, baud);
+
 	edge_port->baud_rate = baud;
 	config->wBaudRate = (__u16)((461550L + baud/2) / baud);
+
+	/* FIXME: Recompute actual baud from divisor here */
 
 	dbg ("%s - baud rate = %d, wBaudRate = %d", __FUNCTION__, baud, config->wBaudRate);
 
@@ -2539,19 +2540,12 @@ static void edge_set_termios (struct usb
 	struct tty_struct *tty = port->tty;
 	unsigned int cflag;
 
-	if (!port->tty || !port->tty->termios) {
-		dbg ("%s - no tty or termios", __FUNCTION__);
-		return;
-	}
-
 	cflag = tty->termios->c_cflag;
 
 	dbg("%s - clfag %08x iflag %08x", __FUNCTION__, 
 	    tty->termios->c_cflag, tty->termios->c_iflag);
-	if (old_termios) {
-		dbg("%s - old clfag %08x old iflag %08x", __FUNCTION__,
-		    old_termios->c_cflag, old_termios->c_iflag);
-	}
+	dbg("%s - old clfag %08x old iflag %08x", __FUNCTION__,
+	    old_termios->c_cflag, old_termios->c_iflag);
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
 
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
