From: akpm@linux-foundation.org
Subject: - riscom8-prepare-for-bkl-pushdown.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:58 -0700
Message-ID: <200805010927.m419RwrW030463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757533AbYEAJ2Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     riscom8: Prepare for BKL pushdown
has been removed from the -mm tree.  Its filename was
     riscom8-prepare-for-bkl-pushdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: riscom8: Prepare for BKL pushdown
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Push the locking down into a couple of functions that need it and remove
bogus TIOCG/SSOFTCAR handling

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/riscom8.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff -puN drivers/char/riscom8.c~riscom8-prepare-for-bkl-pushdown drivers/char/riscom8.c
--- a/drivers/char/riscom8.c~riscom8-prepare-for-bkl-pushdown
+++ a/drivers/char/riscom8.c
@@ -1385,7 +1385,7 @@ static int rc_ioctl(struct tty_struct * 
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
 	void __user *argp = (void __user *)arg;
-	int retval;
+	int retval = 0;
 				
 	if (rc_paranoia_check(port, tty->name, "rc_ioctl"))
 		return -ENODEV;
@@ -1406,23 +1406,20 @@ static int rc_ioctl(struct tty_struct * 
 		tty_wait_until_sent(tty, 0);
 		rc_send_break(port, arg ? arg*(HZ/10) : HZ/4);
 		break;
-	 case TIOCGSOFTCAR:
-		return put_user(C_CLOCAL(tty) ? 1 : 0, (unsigned __user *)argp);
-	 case TIOCSSOFTCAR:
-		if (get_user(arg,(unsigned __user *) argp))
-			return -EFAULT;
-		tty->termios->c_cflag =
-			((tty->termios->c_cflag & ~CLOCAL) |
-			(arg ? CLOCAL : 0));
+	 case TIOCGSERIAL:
+	 	lock_kernel();
+		retval = rc_get_serial_info(port, argp);
+		unlock_kernel();
 		break;
-	 case TIOCGSERIAL:	
-		return rc_get_serial_info(port, argp);
 	 case TIOCSSERIAL:	
-		return rc_set_serial_info(port, argp);
+	 	lock_kernel();
+		retval = rc_set_serial_info(port, argp);
+		unlock_kernel();
+		break;
 	 default:
-		return -ENOIOCTLCMD;
+		retval = -ENOIOCTLCMD;
 	}
-	return 0;
+	return retval;
 }
 
 static void rc_throttle(struct tty_struct * tty)
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

