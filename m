From: akpm@linux-foundation.org
Subject: + writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis.patch added to -mm tree
Date: Thu, 16 Sep 2010 15:28:44 -0700
Message-ID: <201009162228.o8GMSiuj017353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756767Ab0IPWit (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 18:38:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, axboe@kernel.dk, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     writeback: do not sleep on the congestion queue if there are no congested BDIs
has been added to the -mm tree.  Its filename is
     writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis.patch

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
Subject: writeback: do not sleep on the congestion queue if there are no congested BDIs
From: Mel Gorman <mel@csn.ul.ie>

If congestion_wait() is called with no BDI congested, the caller will
sleep for the full timeout and this may be an unnecessary sleep.  This
patch adds a wait_iff_congested() that checks congestion and only sleeps
if a BDI is congested else, it calls cond_resched() to ensure the caller
is not hogging the CPU longer than its quota but otherwise will not sleep.

This is aimed at reducing some of the major desktop stalls reported during
IO.  For example, while kswapd is operating, it calls congestion_wait()
but it could just have been reclaiming clean page cache pages with no
congestion.  Without this patch, it would sleep for a full timeout but
after this patch, it'll just call schedule() if it has been on the CPU too
long.  Similar logic applies to direct reclaimers that are not making
enough progress.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h      |    2 -
 include/trace/events/writeback.h |    7 +++
 mm/backing-dev.c                 |   54 +++++++++++++++++++++++++++--
 mm/page_alloc.c                  |    4 +-
 4 files changed, 62 insertions(+), 5 deletions(-)

diff -puN include/linux/backing-dev.h~writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis
+++ a/include/linux/backing-dev.h
@@ -285,7 +285,7 @@ enum {
 void clear_bdi_congested(struct backing_dev_info *bdi, int sync);
 void set_bdi_congested(struct backing_dev_info *bdi, int sync);
 long congestion_wait(int sync, long timeout);
-
+long wait_iff_congested(int sync, long timeout);
 
 static inline bool bdi_cap_writeback_dirty(struct backing_dev_info *bdi)
 {
diff -puN include/trace/events/writeback.h~writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis include/trace/events/writeback.h
--- a/include/trace/events/writeback.h~writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis
+++ a/include/trace/events/writeback.h
@@ -179,6 +179,13 @@ DEFINE_EVENT(writeback_congest_waited_te
 	TP_ARGS(usec_timeout, usec_delayed)
 );
 
+DEFINE_EVENT(writeback_congest_waited_template, writeback_wait_iff_congested,
+
+	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
+
+	TP_ARGS(usec_timeout, usec_delayed)
+);
+
 #endif /* _TRACE_WRITEBACK_H */
 
 /* This part must be outside protection */
diff -puN mm/backing-dev.c~writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis mm/backing-dev.c
--- a/mm/backing-dev.c~writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis
+++ a/mm/backing-dev.c
@@ -727,6 +727,7 @@ static wait_queue_head_t congestion_wqh[
 		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[0]),
 		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[1])
 	};
+static atomic_t nr_bdi_congested[2];
 
 void clear_bdi_congested(struct backing_dev_info *bdi, int sync)
 {
@@ -734,7 +735,8 @@ void clear_bdi_congested(struct backing_
 	wait_queue_head_t *wqh = &congestion_wqh[sync];
 
 	bit = sync ? BDI_sync_congested : BDI_async_congested;
-	clear_bit(bit, &bdi->state);
+	if (test_and_clear_bit(bit, &bdi->state))
+		atomic_dec(&nr_bdi_congested[sync]);
 	smp_mb__after_clear_bit();
 	if (waitqueue_active(wqh))
 		wake_up(wqh);
@@ -746,7 +748,8 @@ void set_bdi_congested(struct backing_de
 	enum bdi_state bit;
 
 	bit = sync ? BDI_sync_congested : BDI_async_congested;
-	set_bit(bit, &bdi->state);
+	if (!test_and_set_bit(bit, &bdi->state))
+		atomic_inc(&nr_bdi_congested[sync]);
 }
 EXPORT_SYMBOL(set_bdi_congested);
 
@@ -777,3 +780,50 @@ long congestion_wait(int sync, long time
 }
 EXPORT_SYMBOL(congestion_wait);
 
+/**
+ * wait_iff_congested - Conditionally wait for a backing_dev to become uncongested or a zone to complete writes
+ * @sync: SYNC or ASYNC IO
+ * @timeout: timeout in jiffies
+ *
+ * In the event of a congested backing_dev (any backing_dev), this waits for up
+ * to @timeout jiffies for either a BDI to exit congestion of the given @sync
+ * queue.
+ *
+ * If there is no congestion, then cond_resched() is called to yield the
+ * processor if necessary but otherwise does not sleep.
+ *
+ * The return value is 0 if the sleep is for the full timeout. Otherwise,
+ * it is the number of jiffies that were still remaining when the function
+ * returned. return_value == timeout implies the function did not sleep.
+ */
+long wait_iff_congested(int sync, long timeout)
+{
+	long ret;
+	unsigned long start = jiffies;
+	DEFINE_WAIT(wait);
+	wait_queue_head_t *wqh = &congestion_wqh[sync];
+
+	/* If there is no congestion, yield if necessary instead of sleeping */
+	if (atomic_read(&nr_bdi_congested[sync]) == 0) {
+		cond_resched();
+
+		/* In case we scheduled, work out time remaining */
+		ret = timeout - (jiffies - start);
+		if (ret < 0)
+			ret = 0;
+
+		goto out;
+	}
+
+	/* Sleep until uncongested or a write happens */
+	prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
+	ret = io_schedule_timeout(timeout);
+	finish_wait(wqh, &wait);
+
+out:
+	trace_writeback_wait_iff_congested(jiffies_to_usecs(timeout),
+					jiffies_to_usecs(jiffies - start));
+
+	return ret;
+}
+EXPORT_SYMBOL(wait_iff_congested);
diff -puN mm/page_alloc.c~writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis mm/page_alloc.c
--- a/mm/page_alloc.c~writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis
+++ a/mm/page_alloc.c
@@ -1907,7 +1907,7 @@ __alloc_pages_high_priority(gfp_t gfp_ma
 			preferred_zone, migratetype);
 
 		if (!page && gfp_mask & __GFP_NOFAIL)
-			congestion_wait(BLK_RW_ASYNC, HZ/50);
+			wait_iff_congested(BLK_RW_ASYNC, HZ/50);
 	} while (!page && (gfp_mask & __GFP_NOFAIL));
 
 	return page;
@@ -2095,7 +2095,7 @@ rebalance:
 	pages_reclaimed += did_some_progress;
 	if (should_alloc_retry(gfp_mask, order, pages_reclaimed)) {
 		/* Wait for some write requests to complete then retry */
-		congestion_wait(BLK_RW_ASYNC, HZ/50);
+		wait_iff_congested(BLK_RW_ASYNC, HZ/50);
 		goto rebalance;
 	}
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

include-linux-pageblock-flagsh-fix-set_pageblock_flags-macro-definiton.patch
mm-compaction-fix-compactpagefailed-counting.patch
memory-hotplug-fix-notifiers-return-value-check.patch
memory-hotplug-unify-is_removable-and-offline-detection-code.patch
mm-fix-typo-in-mmh-when-node_not_in_page_flags.patch
tracing-vmscan-add-trace-events-for-lru-list-shrinking.patch
writeback-account-for-time-spent-congestion_waited.patch
vmscan-synchronous-lumpy-reclaim-should-not-call-congestion_wait.patch
vmscan-narrow-the-scenarios-lumpy-reclaim-uses-synchrounous-reclaim.patch
vmscan-remove-dead-code-in-shrink_inactive_list.patch
vmscan-isolated_lru_pages-stop-neighbour-search-if-neighbour-cannot-be-isolated.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

