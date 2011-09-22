From: akpm@google.com
Subject: [merged] mm-clean-up-clearing-of-bdi_pending-bit-in-bdi_forker_thread.patch removed from -mm tree
Date: Thu, 22 Sep 2011 14:00:51 -0700
Message-ID: <201109222100.p8ML0pPo005938@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:11103 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1IVVBo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Sep 2011 17:01:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clean up clearing of BDI_pending bit in bdi_forker_thread()
has been removed from the -mm tree.  Its filename was
     mm-clean-up-clearing-of-bdi_pending-bit-in-bdi_forker_thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: clean up clearing of BDI_pending bit in bdi_forker_thread()

bdi_forker_thread() clears BDI_pending bit at the end of the main loop. 
However clearing of this bit must not be done in some cases which is
handled by calling 'continue' from switch statement.  That's kind of
unusual construct and without a good reason so change the function into
more intuitive code flow.

Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 mm/backing-dev.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff -puN mm/backing-dev.c~mm-clean-up-clearing-of-bdi_pending-bit-in-bdi_forker_thread mm/backing-dev.c
--- a/mm/backing-dev.c~mm-clean-up-clearing-of-bdi_pending-bit-in-bdi_forker_thread
+++ a/mm/backing-dev.c
@@ -359,6 +359,17 @@ static unsigned long bdi_longest_inactiv
 	return max(5UL * 60 * HZ, interval);
 }
 
+/*
+ * Clear pending bit and wakeup anybody waiting for flusher thread creation or
+ * shutdown
+ */
+static void bdi_clear_pending(struct backing_dev_info *bdi)
+{
+	clear_bit(BDI_pending, &bdi->state);
+	smp_mb__after_clear_bit();
+	wake_up_bit(&bdi->state, BDI_pending);
+}
+
 static int bdi_forker_thread(void *ptr)
 {
 	struct bdi_writeback *me = ptr;
@@ -469,11 +480,13 @@ static int bdi_forker_thread(void *ptr)
 				spin_unlock_bh(&bdi->wb_lock);
 				wake_up_process(task);
 			}
+			bdi_clear_pending(bdi);
 			break;
 
 		case KILL_THREAD:
 			__set_current_state(TASK_RUNNING);
 			kthread_stop(task);
+			bdi_clear_pending(bdi);
 			break;
 
 		case NO_ACTION:
@@ -489,16 +502,8 @@ static int bdi_forker_thread(void *ptr)
 			else
 				schedule_timeout(msecs_to_jiffies(dirty_writeback_interval * 10));
 			try_to_freeze();
-			/* Back to the main loop */
-			continue;
+			break;
 		}
