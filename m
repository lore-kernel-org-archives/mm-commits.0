From: akpm@linux-foundation.org
Subject: - specialix-prepare-for-bkl-pushdown.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:04 -0700
Message-ID: <200805010928.m419S4dF030548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757531AbYEAJ20 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     specialix: Prepare for BKL pushdown
has been removed from the -mm tree.  Its filename was
     specialix-prepare-for-bkl-pushdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1922,29 +1922,13 @@ static inline int sx_set_serial_info(str
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
@@ -1956,6 +1940,7 @@ static inline int sx_set_serial_info(str
 		    ((tmp.flags & ~ASYNC_USR_MASK) !=
 		     (port->flags & ~ASYNC_USR_MASK))) {
 			func_exit();
+			unlock_kernel();
 			return -EPERM;
 		}
 		port->flags = ((port->flags & ~ASYNC_USR_MASK) |
@@ -1972,6 +1957,7 @@ static inline int sx_set_serial_info(str
 		sx_change_speed(bp, port);
 	}
 	func_exit();
+	unlock_kernel();
 	return 0;
 }
 
@@ -1984,12 +1970,8 @@ static inline int sx_get_serial_info(str
 
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
@@ -2000,6 +1982,7 @@ static inline int sx_get_serial_info(str
 	tmp.closing_wait = port->closing_wait * HZ/100;
 	tmp.custom_divisor =  port->custom_divisor;
 	tmp.xmit_fifo_size = CD186x_NFIFO;
+	unlock_kernel();
 	if (copy_to_user(retinfo, &tmp, sizeof(tmp))) {
 		func_exit();
 		return -EFAULT;
@@ -2045,23 +2028,6 @@ static int sx_ioctl(struct tty_struct * 
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
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

