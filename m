From: akpm@linux-foundation.org
Subject: - isdn_tty-prepare-for-bkl-push-down.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:18 -0700
Message-ID: <200805010928.m419SICk030568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757813AbYEAJ2d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn_tty: Prepare for BKL push down
has been removed from the -mm tree.  Its filename was
     isdn_tty-prepare-for-bkl-push-down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn_tty: Prepare for BKL push down
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Three things here
- Remove softcar handler
- Correct termios change detection logic
- Wrap break/ioctl in lock_kernel ready to drop it in the caller

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/i4l/isdn_tty.c |   26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff -puN drivers/isdn/i4l/isdn_tty.c~isdn_tty-prepare-for-bkl-push-down drivers/isdn/i4l/isdn_tty.c
--- a/drivers/isdn/i4l/isdn_tty.c~isdn_tty-prepare-for-bkl-push-down
+++ a/drivers/isdn/i4l/isdn_tty.c
@@ -1352,12 +1352,14 @@ isdn_tty_tiocmget(struct tty_struct *tty
 	if (tty->flags & (1 << TTY_IO_ERROR))
 		return -EIO;
 
+	lock_kernel();
 #ifdef ISDN_DEBUG_MODEM_IOCTL
 	printk(KERN_DEBUG "ttyI%d ioctl TIOCMGET\n", info->line);
 #endif
 
 	control = info->mcr;
 	status = info->msr;
+	unlock_kernel();
 	return ((control & UART_MCR_RTS) ? TIOCM_RTS : 0)
 	    | ((control & UART_MCR_DTR) ? TIOCM_DTR : 0)
 	    | ((status & UART_MSR_DCD) ? TIOCM_CAR : 0)
@@ -1381,6 +1383,7 @@ isdn_tty_tiocmset(struct tty_struct *tty
 	printk(KERN_DEBUG "ttyI%d ioctl TIOCMxxx: %x %x\n", info->line, set, clear);
 #endif
 
+	lock_kernel();
 	if (set & TIOCM_RTS)
 		info->mcr |= UART_MCR_RTS;
 	if (set & TIOCM_DTR) {
@@ -1402,6 +1405,7 @@ isdn_tty_tiocmset(struct tty_struct *tty
 			isdn_tty_modem_hup(info, 1);
 		}
 	}
+	unlock_kernel();
 	return 0;
 }
 
@@ -1435,21 +1439,6 @@ isdn_tty_ioctl(struct tty_struct *tty, s
 				return retval;
 			tty_wait_until_sent(tty, 0);
 			return 0;
-		case TIOCGSOFTCAR:
-#ifdef ISDN_DEBUG_MODEM_IOCTL
-			printk(KERN_DEBUG "ttyI%d ioctl TIOCGSOFTCAR\n", info->line);
-#endif
-			return put_user(C_CLOCAL(tty) ? 1 : 0, (ulong __user *) arg);
-		case TIOCSSOFTCAR:
-#ifdef ISDN_DEBUG_MODEM_IOCTL
-			printk(KERN_DEBUG "ttyI%d ioctl TIOCSSOFTCAR\n", info->line);
-#endif
-			if (get_user(arg, (ulong __user *) arg))
-				return -EFAULT;
-			tty->termios->c_cflag =
-			    ((tty->termios->c_cflag & ~CLOCAL) |
-			     (arg ? CLOCAL : 0));
-			return 0;
 		case TIOCSERGETLSR:	/* Get line status register */
 #ifdef ISDN_DEBUG_MODEM_IOCTL
 			printk(KERN_DEBUG "ttyI%d ioctl TIOCSERGETLSR\n", info->line);
@@ -1472,13 +1461,14 @@ isdn_tty_set_termios(struct tty_struct *
 	if (!old_termios)
 		isdn_tty_change_speed(info);
 	else {
-		if (tty->termios->c_cflag == old_termios->c_cflag)
+		if (tty->termios->c_cflag == old_termios->c_cflag &&
+		    tty->termios->c_ispeed == old_termios->c_ispeed &&
+		    tty->termios->c_ospeed == old_termios->c_ospeed)
 			return;
 		isdn_tty_change_speed(info);
 		if ((old_termios->c_cflag & CRTSCTS) &&
-		    !(tty->termios->c_cflag & CRTSCTS)) {
+		    !(tty->termios->c_cflag & CRTSCTS))
 			tty->hw_stopped = 0;
-		}
 	}
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

