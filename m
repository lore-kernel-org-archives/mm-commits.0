From: akpm@linux-foundation.org
Subject: - cyclades-prepare-for-relaxed-locking-in-callers.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:45 -0700
Message-ID: <200805010927.m419RjMX030445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035AbYEAJ2T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, john@stoffel.org, mm-commits@vger.kernel.org


The patch titled
     cyclades: Prepare for relaxed locking in callers
has been removed from the -mm tree.  Its filename was
     cyclades-prepare-for-relaxed-locking-in-callers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cyclades: Prepare for relaxed locking in callers
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Basically wrap it in lock_kernel where it is hard to prove the locking is
ok.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: "John Stoffel" <john@stoffel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff -puN drivers/char/cyclades.c~cyclades-prepare-for-relaxed-locking-in-callers drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~cyclades-prepare-for-relaxed-locking-in-callers
+++ a/drivers/char/cyclades.c
@@ -3464,6 +3464,8 @@ static int cy_tiocmget(struct tty_struct
 	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
 		return -ENODEV;
 
+	lock_kernel();
+
 	card = info->card;
 	channel = info->line - card->first_line;
 	if (!IS_CYC_Z(*card)) {
@@ -3506,10 +3508,12 @@ static int cy_tiocmget(struct tty_struct
 				((lstatus & C_RS_CTS) ? TIOCM_CTS : 0);
 		} else {
 			result = 0;
+			unlock_kernel();
 			return -ENODEV;
 		}
 
 	}
+	unlock_kernel();
 	return result;
 }				/* cy_tiomget */
 
@@ -3880,6 +3884,7 @@ cy_ioctl(struct tty_struct *tty, struct 
 	printk(KERN_DEBUG "cyc:cy_ioctl ttyC%d, cmd = %x arg = %lx\n",
 		info->line, cmd, arg);
 #endif
+	lock_kernel();
 
 	switch (cmd) {
 	case CYGETMON:
@@ -3988,47 +3993,47 @@ cy_ioctl(struct tty_struct *tty, struct 
 		p_cuser = argp;
 		ret_val = put_user(cnow.cts, &p_cuser->cts);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.dsr, &p_cuser->dsr);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.rng, &p_cuser->rng);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.dcd, &p_cuser->dcd);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.rx, &p_cuser->rx);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.tx, &p_cuser->tx);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.frame, &p_cuser->frame);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.overrun, &p_cuser->overrun);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.parity, &p_cuser->parity);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.brk, &p_cuser->brk);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.buf_overrun, &p_cuser->buf_overrun);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = 0;
 		break;
 	default:
 		ret_val = -ENOIOCTLCMD;
 	}
+	unlock_kernel();
 
 #ifdef CY_DEBUG_OTHER
 	printk(KERN_DEBUG "cyc:cy_ioctl done\n");
 #endif
