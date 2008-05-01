From: akpm@linux-foundation.org
Subject: - tty-drop-the-bkl-for-driver-ldisc-ioctl-methods.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:42 -0700
Message-ID: <200805010928.m419Sgns030598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757486AbYEAJ3B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty: drop the BKL for driver/ldisc ioctl methods
has been removed from the -mm tree.  Its filename was
     tty-drop-the-bkl-for-driver-ldisc-ioctl-methods.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

