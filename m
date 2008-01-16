From: akpm@linux-foundation.org
Subject: - mos7720-clean-up-termios.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:39:48 -0800
Message-ID: <200801160139.m0G1dmtx014035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41234 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756438AbYAPBto (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:49:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     mos7720: clean up termios
has been removed from the -mm tree.  Its filename was
     mos7720-clean-up-termios.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mos7720: clean up termios
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Remove lots of NULL checks that can no longer occur
Encode the baud rate back into the termios (again someone with docs see
FIXME to improve this further)

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/mos7720.c |   28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff -puN drivers/usb/serial/mos7720.c~mos7720-clean-up-termios drivers/usb/serial/mos7720.c
--- a/drivers/usb/serial/mos7720.c~mos7720-clean-up-termios
+++ a/drivers/usb/serial/mos7720.c
@@ -1040,11 +1040,6 @@ static void change_port_settings(struct 
 
 	tty = mos7720_port->port->tty;
 
-	if ((!tty) || (!tty->termios)) {
-		dbg("%s - no tty structures", __FUNCTION__);
-		return;
-	}
-
 	dbg("%s: Entering ..........", __FUNCTION__);
 
 	lData = UART_LCR_WLEN8;
@@ -1175,7 +1170,10 @@ static void change_port_settings(struct 
 
 	dbg("%s - baud rate = %d", __FUNCTION__, baud);
 	status = send_cmd_write_baud_rate(mos7720_port, baud);
-
+	/* FIXME: needs to write actual resulting baud back not just
+	   blindly do so */
+	if (cflag & CBAUD)
+		tty_encode_baud_rate(tty, baud, baud);
 	/* Enable Interrupts */
 	data = 0x0c;
 	send_mos_cmd(serial, MOS_WRITE, port_number, UART_IER, &data);
@@ -1214,10 +1212,6 @@ static void mos7720_set_termios(struct u
 
 	tty = port->tty;
 
-	if (!port->tty || !port->tty->termios) {
-		dbg("%s - no tty or termios", __FUNCTION__);
-		return;
-	}
 
 	if (!mos7720_port->open) {
 		dbg("%s - port not opened", __FUNCTION__);
@@ -1228,19 +1222,13 @@ static void mos7720_set_termios(struct u
 
 	cflag = tty->termios->c_cflag;
 
-	if (!cflag) {
-		printk("%s %s\n",__FUNCTION__,"cflag is NULL");
-		return;
-	}
-
-	dbg("%s - clfag %08x iflag %08x", __FUNCTION__,
+	dbg("%s - cflag %08x iflag %08x", __FUNCTION__,
 	    tty->termios->c_cflag,
 	    RELEVANT_IFLAG(tty->termios->c_iflag));
 
-	if (old_termios)
-		dbg("%s - old clfag %08x old iflag %08x", __FUNCTION__,
-		    old_termios->c_cflag,
-		    RELEVANT_IFLAG(old_termios->c_iflag));
+	dbg("%s - old cflag %08x old iflag %08x", __FUNCTION__,
+	    old_termios->c_cflag,
+	    RELEVANT_IFLAG(old_termios->c_iflag));
 
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
