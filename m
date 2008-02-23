From: akpm@linux-foundation.org
Subject: + epca-lock_kernel-push-down.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:36:13 -0800
Message-ID: <200802230737.m1N7b2mA018476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755443AbYBWHyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     epca: lock_kernel push down
has been added to the -mm tree.  Its filename is
     epca-lock_kernel-push-down.patch

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
