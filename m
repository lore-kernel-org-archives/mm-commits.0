From: akpm@linux-foundation.org
Subject: + mm-clean-up-clearing-of-bdi_pending-bit-in-bdi_forker_thread.patch added to -mm tree
Date: Wed, 07 Sep 2011 15:19:55 -0700
Message-ID: <201109072219.p87MJt5h023793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757325Ab1IGWUC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Sep 2011 18:20:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, fengguang.wu@intel.com


The patch titled
     mm: clean up clearing of BDI_pending bit in bdi_forker_thread()
has been added to the -mm tree.  Its filename is
     mm-clean-up-clearing-of-bdi_pending-bit-in-bdi_forker_thread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: clean up clearing of BDI_pending bit in bdi_forker_thread()
From: Jan Kara <jack@suse.cz>

bdi_forker_thread() clears BDI_pending bit at the end of the main loop. 
However clearing of this bit must not be done in some cases which is
handled by calling 'continue' from switch statement.  That's kind of
unusual construct and without a good reason so change the function into
more intuitive code flow.

Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
-
-		/*
-		 * Clear pending bit and wakeup anybody waiting to tear us down.
-		 */
-		clear_bit(BDI_pending, &bdi->state);
-		smp_mb__after_clear_bit();
-		wake_up_bit(&bdi->state, BDI_pending);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
mm-clean-up-clearing-of-bdi_pending-bit-in-bdi_forker_thread.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch

