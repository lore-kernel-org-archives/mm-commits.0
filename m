From: akpm@linux-foundation.org
Subject: - char-cyclades-remove-sleep_on.patch removed from -mm tree
Date: Tue, 08 May 2007 19:58:18 -0700
Message-ID: <200705090258.l492wIKs010275@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032430AbXEIC6V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:58:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, remove sleep_on
has been removed from the -mm tree.  Its filename was
     char-cyclades-remove-sleep_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, remove sleep_on
From: Jiri Slaby <jirislaby@gmail.com>

convert to wait_* and completion

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c  |   45 +++++++++++++------------------------
 include/linux/cyclades.h |    2 -
 2 files changed, 17 insertions(+), 30 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-remove-sleep_on drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-remove-sleep_on
+++ a/drivers/char/cyclades.c
@@ -947,7 +947,7 @@ do_softint(struct work_struct *work)
 	tty_wakeup(tty);
 #ifdef Z_WAKE
 	if (test_and_clear_bit(Cy_EVENT_SHUTDOWN_WAKEUP, &info->event))
-		wake_up_interruptible(&info->shutdown_wait);
+		complete(&info->shutdown_wait);
 #endif
 } /* do_softint */
 
@@ -2324,9 +2324,8 @@ block_til_ready(struct tty_struct *tty, 
 	 * until it's done, and then try again.
 	 */
 	if (tty_hung_up_p(filp) || (info->flags & ASYNC_CLOSING)) {
-		if (info->flags & ASYNC_CLOSING) {
-			interruptible_sleep_on(&info->close_wait);
-		}
+		wait_event_interruptible(info->close_wait,
+				!(info->flags & ASYNC_CLOSING));
 		return (info->flags & ASYNC_HUP_NOTIFY) ? -EAGAIN: -ERESTARTSYS;
 	}
 
@@ -2597,8 +2596,8 @@ static int cy_open(struct tty_struct *tt
 	 * If the port is the middle of closing, bail out now
 	 */
 	if (tty_hung_up_p(filp) || (info->flags & ASYNC_CLOSING)) {
-		if (info->flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&info->close_wait);
+		wait_event_interruptible(info->close_wait,
+				!(info->flags & ASYNC_CLOSING));
 		return (info->flags & ASYNC_HUP_NOTIFY) ? -EAGAIN: -ERESTARTSYS;
 	}
 
@@ -2805,7 +2804,7 @@ static void cy_close(struct tty_struct *
 					"ttyC%d was %x\n", info->line, retval);
 			}
 			CY_UNLOCK(info, flags);
-			interruptible_sleep_on(&info->shutdown_wait);
+			wait_for_completion_interruptible(&info->shutdown_wait);
 			CY_LOCK(info, flags);
 		}
 #endif
@@ -4091,32 +4090,20 @@ cy_ioctl(struct tty_struct *tty, struct 
 	case TIOCMIWAIT:
 		CY_LOCK(info, flags);
 		/* note the counters on entry */
-		cprev = info->icount;
+		cnow = info->icount;
 		CY_UNLOCK(info, flags);
-		while (1) {
-			interruptible_sleep_on(&info->delta_msr_wait);
-			/* see if a signal did it */
-			if (signal_pending(current)) {
-				return -ERESTARTSYS;
-			}
-
+		ret_val = wait_event_interruptible(info->delta_msr_wait, ({
+			cprev = cnow;
 			CY_LOCK(info, flags);
 			cnow = info->icount;	/* atomic copy */
 			CY_UNLOCK(info, flags);
 
-			if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
-			    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts) {
-				return -EIO;	/* no change => error */
-			}
-			if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
-			    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
-			    ((arg & TIOCM_CD) && (cnow.dcd != cprev.dcd)) ||
-			    ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts))) {
-				return 0;
-			}
-			cprev = cnow;
-		}
-		/* NOTREACHED */
+			((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
+			((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
+			((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
+			((arg & TIOCM_CTS) && (cnow.cts != cprev.cts));
+		}));
+		break;
 
 		/*
 		 * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
@@ -4534,7 +4521,7 @@ static void __devinit cy_init_card(struc
 		INIT_WORK(&info->tqueue, do_softint);
 		init_waitqueue_head(&info->open_wait);
 		init_waitqueue_head(&info->close_wait);
-		init_waitqueue_head(&info->shutdown_wait);
+		init_completion(&info->shutdown_wait);
 		init_waitqueue_head(&info->delta_msr_wait);
 
 		if (IS_CYC_Z(*cinfo)) {
diff -puN include/linux/cyclades.h~char-cyclades-remove-sleep_on include/linux/cyclades.h
--- a/include/linux/cyclades.h~char-cyclades-remove-sleep_on
+++ a/include/linux/cyclades.h
@@ -588,7 +588,7 @@ struct cyclades_port {
 	struct work_struct	tqueue;
 	wait_queue_head_t       open_wait;
 	wait_queue_head_t       close_wait;
-	wait_queue_head_t       shutdown_wait;
+	struct completion       shutdown_wait;
 	wait_queue_head_t       delta_msr_wait;
 	int throttle;
 };
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
