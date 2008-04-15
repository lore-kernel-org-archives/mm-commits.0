From: akpm@linux-foundation.org
Subject: + pty-prepare-for-tty-ops-changes.patch added to -mm tree
Date: Mon, 14 Apr 2008 19:04:42 -0700
Message-ID: <200804150204.m3F24gCS005639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760137AbYDOCFR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 22:05:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, hpa@zytor.com


The patch titled
     pty: prepare for tty->ops changes
has been added to the -mm tree.  Its filename is
     pty-prepare-for-tty-ops-changes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pty: prepare for tty->ops changes
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

We are about to change the tty layer to avoid keeping private copies of all
the methods in each tty.  We have to update the pty layer first as it
currently patches the ioctl method according to the tty type.  Use multiple
tty operations sets instead.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pty.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff -puN drivers/char/pty.c~pty-prepare-for-tty-ops-changes drivers/char/pty.c
--- a/drivers/char/pty.c~pty-prepare-for-tty-ops-changes
+++ a/drivers/char/pty.c
@@ -254,6 +254,18 @@ static int pty_bsd_ioctl(struct tty_stru
 static int legacy_count = CONFIG_LEGACY_PTY_COUNT;
 module_param(legacy_count, int, 0);
 
+static const struct tty_operations pty_ops_bsd = {
+	.open = pty_open,
+	.close = pty_close,
+	.write = pty_write,
+	.write_room = pty_write_room,
+	.flush_buffer = pty_flush_buffer,
+	.chars_in_buffer = pty_chars_in_buffer,
+	.unthrottle = pty_unthrottle,
+	.set_termios = pty_set_termios,
+	.ioctl = pty_bsd_ioctl,
+};
+
 static void __init legacy_pty_init(void)
 {
 	if (legacy_count <= 0)
@@ -284,7 +296,6 @@ static void __init legacy_pty_init(void)
 	pty_driver->flags = TTY_DRIVER_RESET_TERMIOS | TTY_DRIVER_REAL_RAW;
 	pty_driver->other = pty_slave_driver;
 	tty_set_operations(pty_driver, &pty_ops);
-	pty_driver->ioctl = pty_bsd_ioctl;
 
 	pty_slave_driver->owner = THIS_MODULE;
 	pty_slave_driver->driver_name = "pty_slave";
@@ -377,6 +388,19 @@ static int pty_unix98_ioctl(struct tty_s
 	return -ENOIOCTLCMD;
 }
 
+static const struct tty_operations pty_unix98_ops = {
+	.open = pty_open,
+	.close = pty_close,
+	.write = pty_write,
+	.write_room = pty_write_room,
+	.flush_buffer = pty_flush_buffer,
+	.chars_in_buffer = pty_chars_in_buffer,
+	.unthrottle = pty_unthrottle,
+	.set_termios = pty_set_termios,
+	.ioctl = pty_unix98_ioctl
+};
+
+
 static void __init unix98_pty_init(void)
 {
 	ptm_driver = alloc_tty_driver(NR_UNIX98_PTY_MAX);
@@ -403,8 +427,7 @@ static void __init unix98_pty_init(void)
 	ptm_driver->flags = TTY_DRIVER_RESET_TERMIOS | TTY_DRIVER_REAL_RAW |
 		TTY_DRIVER_DYNAMIC_DEV | TTY_DRIVER_DEVPTS_MEM;
 	ptm_driver->other = pts_driver;
-	tty_set_operations(ptm_driver, &pty_ops);
-	ptm_driver->ioctl = pty_unix98_ioctl;
+	tty_set_operations(ptm_driver, &pty_unix98_ops);
 
 	pts_driver->owner = THIS_MODULE;
 	pts_driver->driver_name = "pty_slave";
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
git-libata-all.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-simplex-clear-fix.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
parisc-new-termios-definitions.patch
aacraid-fix-unchecked-down_interruptible.patch
crisv10-prepare-for-bkl-push-down.patch
fix-tty-speed-handling-on-8250.patch
uart_get_baud_rate-stop-mangling-termios.patch
serial-8250-tighten-test-for-using-backup-timer.patch
x86-geode-add-virtual-systems-architecture-detection.patch
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
tty-the-big-operations-rework.patch
strip-fix-up-strip-for-the-new-order.patch
edac-new-support-for-intel-3100-chipset.patch
edac-add-e752x-parameter-for-sysbus_parity-selection.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
edac-remove-unneeded-functions-and-add-static-accessor.patch
edac-fix-module-initialization-on-several-modules-2nd-time.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

