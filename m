From: akpm@linux-foundation.org
Subject: - isicom-prepare-for-lock_kernel-push-down.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:52 -0700
Message-ID: <200805010927.m419RquX030454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755608AbYEAJ2N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     isicom: prepare for lock_kernel push down
has been removed from the -mm tree.  Its filename was
     isicom-prepare-for-lock_kernel-push-down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isicom: prepare for lock_kernel push down
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Again lock the bits we can't trivially prove are safe without the BKL and
remove the broken TIOCS/GSOFTCAR handler.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff -puN drivers/char/isicom.c~isicom-prepare-for-lock_kernel-push-down drivers/char/isicom.c
--- a/drivers/char/isicom.c~isicom-prepare-for-lock_kernel-push-down
+++ a/drivers/char/isicom.c
@@ -1258,6 +1258,8 @@ static int isicom_set_serial_info(struct
 	if (copy_from_user(&newinfo, info, sizeof(newinfo)))
 		return -EFAULT;
 
+	lock_kernel();
+
 	reconfig_port = ((port->flags & ASYNC_SPD_MASK) !=
 		(newinfo.flags & ASYNC_SPD_MASK));
 
@@ -1265,8 +1267,10 @@ static int isicom_set_serial_info(struct
 		if ((newinfo.close_delay != port->close_delay) ||
 				(newinfo.closing_wait != port->closing_wait) ||
 				((newinfo.flags & ~ASYNC_USR_MASK) !=
-				(port->flags & ~ASYNC_USR_MASK)))
+				(port->flags & ~ASYNC_USR_MASK))) {
+			unlock_kernel();
 			return -EPERM;
+		}
 		port->flags = ((port->flags & ~ ASYNC_USR_MASK) |
 				(newinfo.flags & ASYNC_USR_MASK));
 	}
@@ -1282,6 +1286,7 @@ static int isicom_set_serial_info(struct
 		isicom_config_port(port);
 		spin_unlock_irqrestore(&port->card->card_lock, flags);
 	}
+	unlock_kernel();
 	return 0;
 }
 
@@ -1290,6 +1295,7 @@ static int isicom_get_serial_info(struct
 {
 	struct serial_struct out_info;
 
+	lock_kernel();
 	memset(&out_info, 0, sizeof(out_info));
 /*	out_info.type = ? */
 	out_info.line = port - isi_ports;
@@ -1299,6 +1305,7 @@ static int isicom_get_serial_info(struct
 /*	out_info.baud_base = ? */
 	out_info.close_delay = port->close_delay;
 	out_info.closing_wait = port->closing_wait;
+	unlock_kernel();
 	if (copy_to_user(info, &out_info, sizeof(out_info)))
 		return -EFAULT;
 	return 0;
@@ -1331,19 +1338,6 @@ static int isicom_ioctl(struct tty_struc
 		tty_wait_until_sent(tty, 0);
 		isicom_send_break(port, arg ? arg * (HZ/10) : HZ/4);
 		return 0;
-
-	case TIOCGSOFTCAR:
-		return put_user(C_CLOCAL(tty) ? 1 : 0,
-				(unsigned long __user *)argp);
-
-	case TIOCSSOFTCAR:
-		if (get_user(arg, (unsigned long __user *) argp))
-			return -EFAULT;
-		tty->termios->c_cflag =
-			((tty->termios->c_cflag & ~CLOCAL) |
-			(arg ? CLOCAL : 0));
-		return 0;
