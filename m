From: akpm@linux-foundation.org
Subject: - uart_get_baud_rate-stop-mangling-termios.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:55:25 -0700
Message-ID: <200804282155.m3SLtPVG018100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935193AbYD1Vzl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:55:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     uart_get_baud_rate: stop mangling termios
has been removed from the -mm tree.  Its filename was
     uart_get_baud_rate-stop-mangling-termios.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uart_get_baud_rate: stop mangling termios
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Russell King noticed this one: We have to avoid replacing B0 when we pick a
baud rate for a "hung up" port.  Ugly but the proper fix is in the tty layer
and means changing the tty<->serial interfaces so we will defer that for now.

[akpm@linux-foundation.org: fix uninitialised var]
Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN drivers/serial/serial_core.c~uart_get_baud_rate-stop-mangling-termios drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~uart_get_baud_rate-stop-mangling-termios
+++ a/drivers/serial/serial_core.c
@@ -329,13 +329,15 @@ EXPORT_SYMBOL(uart_update_timeout);
  *	If it's still invalid, we try 9600 baud.
  *
  *	Update the @termios structure to reflect the baud rate
- *	we're actually going to be using.
+ *	we're actually going to be using. Don't do this for the case
+ *	where B0 is requested ("hang up").
  */
 unsigned int
 uart_get_baud_rate(struct uart_port *port, struct ktermios *termios,
 		   struct ktermios *old, unsigned int min, unsigned int max)
 {
 	unsigned int try, baud, altbaud = 38400;
+	int hung_up = 0;
 	upf_t flags = port->flags & UPF_SPD_MASK;
 
 	if (flags == UPF_SPD_HI)
@@ -360,8 +362,10 @@ uart_get_baud_rate(struct uart_port *por
 		/*
 		 * Special case: B0 rate.
 		 */
-		if (baud == 0)
+		if (baud == 0) {
+			hung_up = 1;
 			baud = 9600;
+		}
 
 		if (baud >= min && baud <= max)
 			return baud;
@@ -373,7 +377,9 @@ uart_get_baud_rate(struct uart_port *por
 		termios->c_cflag &= ~CBAUD;
 		if (old) {
 			baud = tty_termios_baud_rate(old);
-			tty_termios_encode_baud_rate(termios, baud, baud);
+			if (!hung_up)
+				tty_termios_encode_baud_rate(termios,
+								baud, baud);
 			old = NULL;
 			continue;
 		}
@@ -382,7 +388,8 @@ uart_get_baud_rate(struct uart_port *por
 		 * As a last resort, if the quotient is zero,
 		 * default to 9600 bps
 		 */
-		tty_termios_encode_baud_rate(termios, 9600, 9600);
+		if (!hung_up)
+			tty_termios_encode_baud_rate(termios, 9600, 9600);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
vt-fix-background-color-on-line-feed.patch
do_task_stat-dont-take-rcu_read_lock.patch
amiserial-prepare-for-locking-relaxation-in-caller.patch
cyclades-prepare-for-relaxed-locking-in-callers.patch
epca-lock_kernel-push-down.patch
esp-lock_kernel-push-down.patch
isicom-prepare-for-lock_kernel-push-down.patch
isicom-istallion-prepare-for-lock_kernel-pushdown.patch
mxser-prepare-for-bkl-pushdown.patch
riscom8-prepare-for-bkl-pushdown.patch
rocket-prepare-for-bkl-pushdown.patch
serial167-prepare-to-push-bkl-down-into-drivers.patch
specialix-prepare-for-bkl-pushdown.patch
stallion-prepare-for-bkl-push-down.patch
sx-prepare-for-bkl-pushdown.patch
synclink-series-prepare-for-bkl-pushdown.patch
viocons-bkl-locking.patch
vt_ioctl-prepare-for-bkl-push-down.patch
isdn_tty-prepare-for-bkl-push-down.patch
68360serial-note-that-there-isnt-any-info-mcr-locking.patch
serial_core-prepare-for-bkl-push-down.patch
tty-bkl-pushdown.patch
tty-bkl-pushdown-fix1.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
tty_ioctl-locking-for-tty_wait_until_sent.patch
tty_ioctl-soft-carrier-handling.patch
tty-drop-the-bkl-for-driver-ldisc-ioctl-methods.patch
sxc-fix-printk-warnings-on-sparc32.patch
istallion-tiocg-ssoftcar-handling-removal.patch
cyclades-coding-style-review.patch
tty-serial-lay-the-foundations-for-the-next-set-of-reworks.patch
s390-tty-prepare-for-put_char-to-return-success-fail.patch
serial-m68k-put_char-returns.patch
usb-gadget-switch-to-put_char-returning-int.patch
amiserial-switch-put-char-to-return-success-fail.patch
char-switch-gs-cyclades-and-esp-to-return-int-for-put_char.patch
mxser-switch-to-put_char-being-int.patch
pcmcia-serial-to-int-put_char-method.patch
riscom-rocket-switch-to-int-put_char-method.patch
serial167-switch-to-int-put_char-method.patch
specialix-switch-to-int-put_char-method.patch
synclink-series-switch-to-int-put_char-method.patch
consoles-switch-to-int-put_char-method.patch
isdn-switch-to-int-put_char-method.patch
pty-prepare-for-tty-ops-changes.patch
pc300-update-to-tty_set_operations.patch
serial-switch-the-serial-core-to-int-put_char-methods.patch
isicom-bring-into-coding-style.patch
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework.patch
tty-the-big-operations-rework-broke-wan-x25_asy-fix.patch
tty-the-big-operations-rework-fix-2.patch
tty-the-big-operations-rework-isicom-fix.patch
tty-the-big-operations-rework-simserial-fix.patch
strip-fix-up-strip-for-the-new-order.patch
tty-the-big-operations-rework-vs-git-kgdb-light.patch
tty-the-big-operations-rework-vs-kgdb-2.patch
proc-convert-proc-tty-ldiscs-to-seq_file-interface.patch
edac-new-support-for-intel-3100-chipset.patch
edac-add-e752x-parameter-for-sysbus_parity-selection.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
edac-remove-unneeded-functions-and-add-static-accessor.patch
edac-fix-module-initialization-on-several-modules-2nd-time.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

