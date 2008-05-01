From: akpm@linux-foundation.org
Subject: - epca-lock_kernel-push-down.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:48 -0700
Message-ID: <200805010927.m419RmvZ030448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756536AbYEAJ2M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     epca: lock_kernel push down
has been removed from the -mm tree.  Its filename was
     epca-lock_kernel-push-down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epca: lock_kernel push down
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Prepare epca for removing the lock from above. Most of epca is internally
locked so we can trivially push it down to a few bits of code. Drop the TIOCG/SSOFTCAR handling as that is done *properly* with locks by the mid layer.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/epca.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff -puN drivers/char/epca.c~epca-lock_kernel-push-down drivers/char/epca.c
--- a/drivers/char/epca.c~epca-lock_kernel-push-down
+++ a/drivers/char/epca.c
@@ -2206,21 +2206,6 @@ static int pc_ioctl(struct tty_struct *t
 		tty_wait_until_sent(tty, 0);
 		digi_send_break(ch, arg ? arg*(HZ/10) : HZ/4);
 		return 0;
-	case TIOCGSOFTCAR:
-		if (put_user(C_CLOCAL(tty)?1:0, (unsigned long __user *)arg))
-			return -EFAULT;
-		return 0;
-	case TIOCSSOFTCAR:
-		{
-			unsigned int value;
-
-			if (get_user(value, (unsigned __user *)argp))
-				return -EFAULT;
-			tty->termios->c_cflag =
-				((tty->termios->c_cflag & ~CLOCAL) |
-				 (value ? CLOCAL : 0));
-			return 0;
-		}
 	case TIOCMODG:
 		mflag = pc_tiocmget(tty, file);
 		if (put_user(mflag, (unsigned long __user *)argp))
@@ -2253,6 +2238,7 @@ static int pc_ioctl(struct tty_struct *t
 		break;
 	case DIGI_SETAW:
 	case DIGI_SETAF:
+		lock_kernel();
 		if (cmd == DIGI_SETAW) {
 			/* Setup an event to indicate when the transmit buffer empties */
 			spin_lock_irqsave(&epca_lock, flags);
@@ -2264,6 +2250,7 @@ static int pc_ioctl(struct tty_struct *t
 			if (tty->ldisc.flush_buffer)
 				tty->ldisc.flush_buffer(tty);
 		}
+		unlock_kernel();
 		/* Fall Thru */
 	case DIGI_SETA:
 		if (copy_from_user(&ch->digiext, argp, sizeof(digi_t)))
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

