From: akpm@linux-foundation.org
Subject: + isdn_tty-prepare-for-bkl-push-down.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:36:44 -0800
Message-ID: <200802230737.m1N7bXRd018524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754403AbYBWIAq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:00:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, kkeil@suse.de


The patch titled
     isdn_tty: Prepare for BKL push down
has been added to the -mm tree.  Its filename is
     isdn_tty-prepare-for-bkl-push-down.patch

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
libata-isolate-and-rework-cable-logic.patch
pata_amd-fix-sparse-warning.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
megaraid-outb_p-extermination.patch
usb-serial-prepare-for-bkl-push-down.patch
ftdi_sio-note-missing-locking.patch
usb-serial-note-mos7480-and-option-dont-lock-modem-status.patch
io_ti-lock-mcr-and-msr-shadows-properly.patch
iuu_phoenix-lock-priv-tiostatus-properly.patch
kobil_sct-get-rid-of-unneeded-priv-line_state.patch
ti_usb_3410_5052-extend-locking-to-msr-and-shadow-mcr.patch
git-watchdog.patch
crisv10-prepare-for-bkl-push-down.patch
fix-tty-speed-handling-on-8250.patch
uart_get_baud_rate-stop-mangling-termios.patch
do_task_stat-dont-take-rcu_read_lock.patch
amiserial-prepare-for-locking-relaxation-in-caller.patch
cyclades-prepare-for-relaxed-locking-in-callers.patch
epca-lock_kernel-push-down.patch
esp-lock_kernel-push-down.patch
isicom-prepare-for-lock_kernel-push-down.patch
isicom-istallion-prepare-for-lock_kernel-pushdown.patch
mxser-prepare-for-bkl-pushdown.patch
nozomi-prepare-for-bkl-pushdown.patch
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
put_pid-make-sure-we-dont-free-the-live-pid.patch
