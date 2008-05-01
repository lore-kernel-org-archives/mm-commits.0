From: akpm@linux-foundation.org
Subject: - serial167-prepare-to-push-bkl-down-into-drivers.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:02 -0700
Message-ID: <200805010928.m419S2ON030542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757509AbYEAJ2X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     serial167: prepare to push BKL down into drivers
has been removed from the -mm tree.  Its filename was
     serial167-prepare-to-push-bkl-down-into-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial167: prepare to push BKL down into drivers
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Kill the softcar handlers again, wrap the ioctl handler in the BKL

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/serial167.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff -puN drivers/char/serial167.c~serial167-prepare-to-push-bkl-down-into-drivers drivers/char/serial167.c
--- a/drivers/char/serial167.c~serial167-prepare-to-push-bkl-down-into-drivers
+++ a/drivers/char/serial167.c
@@ -1539,6 +1539,8 @@ cy_ioctl(struct tty_struct *tty, struct 
 	printk("cy_ioctl %s, cmd = %x arg = %lx\n", tty->name, cmd, arg);	/* */
 #endif
 
+	lock_kernel();
+
 	switch (cmd) {
 	case CYGETMON:
 		ret_val = get_mon_info(info, argp);
@@ -1584,18 +1586,6 @@ cy_ioctl(struct tty_struct *tty, struct 
 		break;
 
 /* The following commands are incompletely implemented!!! */
-	case TIOCGSOFTCAR:
-		ret_val =
-		    put_user(C_CLOCAL(tty) ? 1 : 0,
-			     (unsigned long __user *)argp);
-		break;
-	case TIOCSSOFTCAR:
-		ret_val = get_user(val, (unsigned long __user *)argp);
-		if (ret_val)
-			break;
-		tty->termios->c_cflag =
-		    ((tty->termios->c_cflag & ~CLOCAL) | (val ? CLOCAL : 0));
-		break;
 	case TIOCGSERIAL:
 		ret_val = get_serial_info(info, argp);
 		break;
@@ -1605,6 +1595,7 @@ cy_ioctl(struct tty_struct *tty, struct 
 	default:
 		ret_val = -ENOIOCTLCMD;
 	}
+	unlock_kernel();
 
 #ifdef SERIAL_DEBUG_OTHER
 	printk("cy_ioctl done\n");
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

