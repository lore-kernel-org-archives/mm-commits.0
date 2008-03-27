From: akpm@linux-foundation.org
Subject: + tty-drop-the-bkl-for-driver-ldisc-ioctl-methods.patch added to -mm tree
Date: Thu, 27 Mar 2008 01:36:31 -0700
Message-ID: <200803270836.m2R8aVUv026021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754293AbYC0Ig6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 04:36:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     tty: drop the BKL for driver/ldisc ioctl methods
has been added to the -mm tree.  Its filename is
     tty-drop-the-bkl-for-driver-ldisc-ioctl-methods.patch

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
Subject: tty: drop the BKL for driver/ldisc ioctl methods
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Now we have pushed the lock down we can stop wrapping the call with a lock in
the tty layer.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN drivers/char/tty_io.c~tty-drop-the-bkl-for-driver-ldisc-ioctl-methods drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-drop-the-bkl-for-driver-ldisc-ioctl-methods
+++ a/drivers/char/tty_io.c
@@ -3459,11 +3459,8 @@ long tty_ioctl(struct file *file, unsign
 		switch (cmd) {
 		case TIOCSBRK:
 		case TIOCCBRK:
-			if (tty->driver->ioctl) {
-				lock_kernel();
+			if (tty->driver->ioctl)
 				retval = tty->driver->ioctl(tty, file, cmd, arg);
-				unlock_kernel();
-			}
 			return retval;
 
 		/* These two ioctl's always return success; even if */
@@ -3584,18 +3581,14 @@ long tty_ioctl(struct file *file, unsign
 		break;
 	}
 	if (tty->driver->ioctl) {
-		lock_kernel();
 		retval = (tty->driver->ioctl)(tty, file, cmd, arg);
-		unlock_kernel();
 		if (retval != -ENOIOCTLCMD)
 			return retval;
 	}
 	ld = tty_ldisc_ref_wait(tty);
 	retval = -EINVAL;
 	if (ld->ioctl) {
-		lock_kernel();
 		retval = ld->ioctl(tty, file, cmd, arg);
-		unlock_kernel();
 		if (retval == -ENOIOCTLCMD)
 			retval = -EINVAL;
 	}
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
git-libata-all.patch
libata-isolate-and-rework-cable-logic.patch
devres-implement-pcim_iomap_regions_request_all-fix.patch
devres-implement-pcim_iomap_regions_request_all-fix-fix.patch
pata_atiixp-simplex-clear.patch
pata_amd-fix-sparse-warning.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
parisc-new-termios-definitions.patch
crisv10-prepare-for-bkl-push-down.patch
fix-tty-speed-handling-on-8250.patch
uart_get_baud_rate-stop-mangling-termios.patch
serial-8250-tighten-test-for-using-backup-timer.patch
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
edac-new-support-for-intel-3100-chipset.patch
edac-fix-module-initialization-on-several-modules.patch
edac-add-e752x-parameter-for-sysbus_parity-selection.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

