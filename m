From: akpm@linux-foundation.org
Subject: + specialix-prepare-for-bkl-pushdown.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:36:31 -0800
Message-ID: <200802230737.m1N7bK4B018506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756580AbYBWHyx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     specialix: Prepare for BKL pushdown
has been added to the -mm tree.  Its filename is
     specialix-prepare-for-bkl-pushdown.patch

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
Subject: specialix: Prepare for BKL pushdown
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Lock the ioctl handlers and remove bogus softcar handling.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/specialix.c |   46 ++++---------------------------------
 1 file changed, 6 insertions(+), 40 deletions(-)

diff -puN drivers/char/specialix.c~specialix-prepare-for-bkl-pushdown drivers/char/specialix.c
--- a/drivers/char/specialix.c~specialix-prepare-for-bkl-pushdown
+++ a/drivers/char/specialix.c
@@ -1924,29 +1924,13 @@ static inline int sx_set_serial_info(str
 	int change_speed;
 
 	func_enter();
-	/*
-	if (!access_ok(VERIFY_READ, (void *) newinfo, sizeof(tmp))) {
-		func_exit();
-		return -EFAULT;
-	}
-	*/
+
 	if (copy_from_user(&tmp, newinfo, sizeof(tmp))) {
 		func_enter();
 		return -EFAULT;
 	}
 
-#if 0
-	if ((tmp.irq != bp->irq) ||
-	    (tmp.port != bp->base) ||
-	    (tmp.type != PORT_CIRRUS) ||
-	    (tmp.baud_base != (SX_OSCFREQ + CD186x_TPC/2) / CD186x_TPC) ||
-	    (tmp.custom_divisor != 0) ||
-	    (tmp.xmit_fifo_size != CD186x_NFIFO) ||
-	    (tmp.flags & ~SPECIALIX_LEGAL_FLAGS)) {
-		func_exit();
-		return -EINVAL;
-	}
-#endif
+	lock_kernel();
 
 	change_speed = ((port->flags & ASYNC_SPD_MASK) !=
 			(tmp.flags & ASYNC_SPD_MASK));
@@ -1958,6 +1942,7 @@ static inline int sx_set_serial_info(str
 		    ((tmp.flags & ~ASYNC_USR_MASK) !=
 		     (port->flags & ~ASYNC_USR_MASK))) {
 			func_exit();
+			unlock_kernel();
 			return -EPERM;
 		}
 		port->flags = ((port->flags & ~ASYNC_USR_MASK) |
@@ -1974,6 +1959,7 @@ static inline int sx_set_serial_info(str
 		sx_change_speed(bp, port);
 	}
 	func_exit();
+	unlock_kernel();
 	return 0;
 }
 
@@ -1986,12 +1972,8 @@ static inline int sx_get_serial_info(str
 
 	func_enter();
 
-	/*
-	if (!access_ok(VERIFY_WRITE, (void *) retinfo, sizeof(tmp)))
-		return -EFAULT;
-	*/
-
 	memset(&tmp, 0, sizeof(tmp));
+	lock_kernel();
 	tmp.type = PORT_CIRRUS;
 	tmp.line = port - sx_port;
 	tmp.port = bp->base;
@@ -2002,6 +1984,7 @@ static inline int sx_get_serial_info(str
 	tmp.closing_wait = port->closing_wait * HZ/100;
 	tmp.custom_divisor =  port->custom_divisor;
 	tmp.xmit_fifo_size = CD186x_NFIFO;
+	unlock_kernel();
 	if (copy_to_user(retinfo, &tmp, sizeof(tmp))) {
 		func_exit();
 		return -EFAULT;
@@ -2047,23 +2030,6 @@ static int sx_ioctl(struct tty_struct * 
 		sx_send_break(port, arg ? arg*(HZ/10) : HZ/4);
 		func_exit();
 		return 0;
-	 case TIOCGSOFTCAR:
-		 if (put_user(C_CLOCAL(tty)?1:0, (unsigned long __user *)argp)) {
-			 func_exit();
-			 return -EFAULT;
-		 }
-		 func_exit();
-		return 0;
-	 case TIOCSSOFTCAR:
-		 if (get_user(arg, (unsigned long __user *) argp)) {
-			 func_exit();
-			 return -EFAULT;
-		 }
-		tty->termios->c_cflag =
-			((tty->termios->c_cflag & ~CLOCAL) |
-			(arg ? CLOCAL : 0));
-		func_exit();
-		return 0;
 	 case TIOCGSERIAL:
 		 func_exit();
 		return sx_get_serial_info(port, argp);
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
