From: akpm@linux-foundation.org
Subject: - crisv10-prepare-for-bkl-push-down.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:40 -0700
Message-ID: <200804282154.m3SLsef5018029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934976AbYD1VzR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:55:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mikael.starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     crisv10: prepare for BKL push down
has been removed from the -mm tree.  Its filename was
     crisv10-prepare-for-bkl-push-down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: crisv10: prepare for BKL push down
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Just the modem bits this time

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/crisv10.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/serial/crisv10.c~crisv10-prepare-for-bkl-push-down drivers/serial/crisv10.c
--- a/drivers/serial/crisv10.c~crisv10-prepare-for-bkl-push-down
+++ a/drivers/serial/crisv10.c
@@ -3582,6 +3582,8 @@ rs_tiocmset(struct tty_struct *tty, stru
 {
 	struct e100_serial *info = (struct e100_serial *)tty->driver_data;
 
+	lock_kernel();
+
 	if (clear & TIOCM_RTS)
 		e100_rts(info, 0);
 	if (clear & TIOCM_DTR)
@@ -3601,6 +3603,8 @@ rs_tiocmset(struct tty_struct *tty, stru
 		e100_ri_out(info, 1);
 	if (set & TIOCM_CD)
 		e100_cd_out(info, 1);
+
+	unlock_kernel();
 	return 0;
 }
 
@@ -3610,6 +3614,7 @@ rs_tiocmget(struct tty_struct *tty, stru
 	struct e100_serial *info = (struct e100_serial *)tty->driver_data;
 	unsigned int result;
 
+	lock_kernel();
 	result =
 		(!E100_RTS_GET(info) ? TIOCM_RTS : 0)
 		| (!E100_DTR_GET(info) ? TIOCM_DTR : 0)
@@ -3618,6 +3623,8 @@ rs_tiocmget(struct tty_struct *tty, stru
 		| (!E100_CD_GET(info) ? TIOCM_CAR : 0)
 		| (!E100_CTS_GET(info) ? TIOCM_CTS : 0);
 
+	unlock_kernel();
+
 #ifdef SERIAL_DEBUG_IO
 	printk(KERN_DEBUG "ser%i: modem state: %i 0x%08X\n",
 		info->line, result, result);
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

