From: akpm@linux-foundation.org
Subject: - sx-prepare-for-bkl-pushdown.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:08 -0700
Message-ID: <200805010928.m419S8CA030556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757755AbYEAJ23 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     sx: prepare for BKL pushdown
has been removed from the -mm tree.  Its filename was
     sx-prepare-for-bkl-pushdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sx: prepare for BKL pushdown
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Wrap the ioctl handler, and in this case the break handler also in the
BKL. Remove bogus softcar handlers.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sx.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff -puN drivers/char/sx.c~sx-prepare-for-bkl-pushdown drivers/char/sx.c
--- a/drivers/char/sx.c~sx-prepare-for-bkl-pushdown
+++ a/drivers/char/sx.c
@@ -1844,6 +1844,7 @@ static void sx_break(struct tty_struct *
 	int rv;
 
 	func_enter();
+	lock_kernel();
 
 	if (flag)
 		rv = sx_send_command(port, HS_START, -1, HS_IDLE_BREAK);
@@ -1852,7 +1853,7 @@ static void sx_break(struct tty_struct *
 	if (rv != 1)
 		printk(KERN_ERR "sx: couldn't send break (%x).\n",
 			read_sx_byte(port->board, CHAN_OFFSET(port, hi_hstat)));
-
+	unlock_kernel();
 	func_exit();
 }
 
@@ -1888,23 +1889,12 @@ static int sx_ioctl(struct tty_struct *t
 	int rc;
 	struct sx_port *port = tty->driver_data;
 	void __user *argp = (void __user *)arg;
-	int ival;
 
 	/* func_enter2(); */
 
 	rc = 0;
+	lock_kernel();
 	switch (cmd) {
-	case TIOCGSOFTCAR:
-		rc = put_user(((tty->termios->c_cflag & CLOCAL) ? 1 : 0),
-				(unsigned __user *)argp);
-		break;
-	case TIOCSSOFTCAR:
-		if ((rc = get_user(ival, (unsigned __user *)argp)) == 0) {
-			tty->termios->c_cflag =
-				(tty->termios->c_cflag & ~CLOCAL) |
-				(ival ? CLOCAL : 0);
-		}
-		break;
 	case TIOCGSERIAL:
 		rc = gs_getserial(&port->gs, argp);
 		break;
@@ -1915,6 +1905,7 @@ static int sx_ioctl(struct tty_struct *t
 		rc = -ENOIOCTLCMD;
 		break;
 	}
+	unlock_kernel();
 
 	/* func_exit(); */
 	return rc;
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

