From: akpm@linux-foundation.org
Subject: - stallion-prepare-for-bkl-push-down.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:06 -0700
Message-ID: <200805010928.m419S6eo030553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757651AbYEAJ21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     stallion: Prepare for BKL push down
has been removed from the -mm tree.  Its filename was
     stallion-prepare-for-bkl-push-down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: stallion: Prepare for BKL push down
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Remove broken softcar functions, wrap ioctl handler in BKL

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/stallion.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff -puN drivers/char/stallion.c~stallion-prepare-for-bkl-push-down drivers/char/stallion.c
--- a/drivers/char/stallion.c~stallion-prepare-for-bkl-push-down
+++ a/drivers/char/stallion.c
@@ -1273,18 +1273,9 @@ static int stl_ioctl(struct tty_struct *
 
 	rc = 0;
 
+	lock_kernel();
+
 	switch (cmd) {
-	case TIOCGSOFTCAR:
-		rc = put_user(((tty->termios->c_cflag & CLOCAL) ? 1 : 0),
-			(unsigned __user *) argp);
-		break;
-	case TIOCSSOFTCAR:
-		if (get_user(ival, (unsigned int __user *) arg))
-			return -EFAULT;
-		tty->termios->c_cflag =
-				(tty->termios->c_cflag & ~CLOCAL) |
-				(ival ? CLOCAL : 0);
-		break;
 	case TIOCGSERIAL:
 		rc = stl_getserial(portp, argp);
 		break;
@@ -1308,7 +1299,7 @@ static int stl_ioctl(struct tty_struct *
 		rc = -ENOIOCTLCMD;
 		break;
 	}
