From: akpm@linux-foundation.org
Subject: + writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone.patch added to -mm tree
Date: Thu, 16 Sep 2010 15:28:47 -0700
Message-ID: <201009162228.o8GMSlBV017356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756850Ab0IPWjJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 18:39:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, axboe@kernel.dk, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     writeback: do not sleep on the congestion queue if there are no congested BDIs or if significant congestion is not being encountered in the current zone
has been added to the -mm tree.  Its filename is
     writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone.patch

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
Subject: writeback: do not sleep on the congestion queue if there are no congested BDIs or if significant congestion is not being encountered in the current zone
From: Mel Gorman <mel@csn.ul.ie>

If wait_iff_congested() is called with no BDI congested, the function
simply calls cond_resched().  In the event there is significant writeback
happening in the zone that is being reclaimed, this can be a poor decision
as reclaim would succeed once writeback was completed.  Without any
backoff logic, younger clean pages can be reclaimed resulting in more
reclaim overall and poor performance.

This patch tracks how many pages backed by a congested BDI were found
during scanning.  If all the dirty pages encountered on a list isolated
from the LRU belong to a congested BDI, the zone is marked congested until
the zone reaches the high watermark.  wait_iff_congested() then checks
both the number of congested BDIs and if the current zone is one that has
encounted congestion recently, it will sleep on the congestion queue. 
Otherwise it will call cond_reched() to yield the processor if necessary.

The end result is that waiting on the congestion queue is avoided when
necessary but when significant congestion is being encountered, reclaimers
and page allocators will back off.

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

 include/linux/backing-dev.h |    2 
 include/linux/mmzone.h      |    8 +++
 mm/backing-dev.c            |   23 ++++++---
 mm/page_alloc.c             |    4 -
 mm/vmscan.c                 |   83 +++++++++++++++++++++++++++++-----
 5 files changed, 98 insertions(+), 22 deletions(-)

diff -puN include/linux/backing-dev.h~writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone
+++ a/include/linux/backing-dev.h
@@ -285,7 +285,7 @@ enum {
 void clear_bdi_congested(struct backing_dev_info *bdi, int sync);
 void set_bdi_congested(struct backing_dev_info *bdi, int sync);
 long congestion_wait(int sync, long timeout);
-long wait_iff_congested(int sync, long timeout);
+long wait_iff_congested(struct zone *zone, int sync, long timeout);
 
 static inline bool bdi_cap_writeback_dirty(struct backing_dev_info *bdi)
 {
diff -puN include/linux/mmzone.h~writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone include/linux/mmzone.h
--- a/include/linux/mmzone.h~writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone
+++ a/include/linux/mmzone.h
@@ -423,6 +423,9 @@ struct zone {
 typedef enum {
 	ZONE_RECLAIM_LOCKED,		/* prevents concurrent reclaim */
 	ZONE_OOM_LOCKED,		/* zone is in OOM killer zonelist */
+	ZONE_CONGESTED,			/* zone has many dirty pages backed by
+					 * a congested BDI
+					 */
 } zone_flags_t;
 
 static inline void zone_set_flag(struct zone *zone, zone_flags_t flag)
@@ -440,6 +443,11 @@ static inline void zone_clear_flag(struc
 	clear_bit(flag, &zone->flags);
 }
 
+static inline int zone_is_reclaim_congested(const struct zone *zone)
+{
+	return test_bit(ZONE_CONGESTED, &zone->flags);
+}
+
 static inline int zone_is_reclaim_locked(const struct zone *zone)
 {
 	return test_bit(ZONE_RECLAIM_LOCKED, &zone->flags);
diff -puN mm/backing-dev.c~writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone mm/backing-dev.c
--- a/mm/backing-dev.c~writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone
+++ a/mm/backing-dev.c
@@ -782,29 +782,36 @@ EXPORT_SYMBOL(congestion_wait);
 
 /**
  * wait_iff_congested - Conditionally wait for a backing_dev to become uncongested or a zone to complete writes
+ * @zone: A zone to check if it is heavily congested
  * @sync: SYNC or ASYNC IO
  * @timeout: timeout in jiffies
  *
- * In the event of a congested backing_dev (any backing_dev), this waits for up
- * to @timeout jiffies for either a BDI to exit congestion of the given @sync
- * queue.
+ * In the event of a congested backing_dev (any backing_dev) and the given
+ * @zone has experienced recent congestion, this waits for up to @timeout
+ * jiffies for either a BDI to exit congestion of the given @sync queue
+ * or a write to complete.
  *
- * If there is no congestion, then cond_resched() is called to yield the
- * processor if necessary but otherwise does not sleep.
+ * In the absense of zone congestion, cond_resched() is called to yield
+ * the processor if necessary but otherwise does not sleep.
  *
  * The return value is 0 if the sleep is for the full timeout. Otherwise,
  * it is the number of jiffies that were still remaining when the function
  * returned. return_value == timeout implies the function did not sleep.
  */
-long wait_iff_congested(int sync, long timeout)
+long wait_iff_congested(struct zone *zone, int sync, long timeout)
 {
 	long ret;
 	unsigned long start = jiffies;
 	DEFINE_WAIT(wait);
 	wait_queue_head_t *wqh = &congestion_wqh[sync];
 
-	/* If there is no congestion, yield if necessary instead of sleeping */
-	if (atomic_read(&nr_bdi_congested[sync]) == 0) {
+	/*
+	 * If there is no congestion, or heavy congestion is not being
+	 * encountered in the current zone, yield if necessary instead
+	 * of sleeping on the congestion queue
+	 */
+	if (atomic_read(&nr_bdi_congested[sync]) == 0 ||
+			!zone_is_reclaim_congested(zone)) {
 		cond_resched();
 
 		/* In case we scheduled, work out time remaining */
diff -puN mm/page_alloc.c~writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone mm/page_alloc.c
--- a/mm/page_alloc.c~writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone
+++ a/mm/page_alloc.c
@@ -1907,7 +1907,7 @@ __alloc_pages_high_priority(gfp_t gfp_ma
 			preferred_zone, migratetype);
 
 		if (!page && gfp_mask & __GFP_NOFAIL)
-			wait_iff_congested(BLK_RW_ASYNC, HZ/50);
+			wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/50);
 	} while (!page && (gfp_mask & __GFP_NOFAIL));
 
 	return page;
@@ -2095,7 +2095,7 @@ rebalance:
 	pages_reclaimed += did_some_progress;
 	if (should_alloc_retry(gfp_mask, order, pages_reclaimed)) {
 		/* Wait for some write requests to complete then retry */
-		wait_iff_congested(BLK_RW_ASYNC, HZ/50);
+		wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/50);
 		goto rebalance;
 	}
 
diff -puN mm/vmscan.c~writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone mm/vmscan.c
--- a/mm/vmscan.c~writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone
+++ a/mm/vmscan.c
@@ -311,20 +311,30 @@ static inline int is_page_cache_freeable
 	return page_count(page) - page_has_private(page) == 2;
 }
 
-static int may_write_to_queue(struct backing_dev_info *bdi,
+enum bdi_queue_status {
+	QUEUEWRITE_DENIED,
+	QUEUEWRITE_CONGESTED,
+	QUEUEWRITE_ALLOWED,
+};
+
+static enum bdi_queue_status may_write_to_queue(struct backing_dev_info *bdi,
 			      struct scan_control *sc)
 {
+	enum bdi_queue_status ret = QUEUEWRITE_DENIED;
+
 	if (current->flags & PF_SWAPWRITE)
-		return 1;
+		return QUEUEWRITE_ALLOWED;
 	if (!bdi_write_congested(bdi))
-		return 1;
+		return QUEUEWRITE_ALLOWED;
+	else
+		ret = QUEUEWRITE_CONGESTED;
 	if (bdi == current->backing_dev_info)
-		return 1;
+		return QUEUEWRITE_ALLOWED;
 
 	/* lumpy reclaim for hugepage often need a lot of write */
 	if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
-		return 1;
-	return 0;
+		return QUEUEWRITE_ALLOWED;
+	return ret;
 }
 
 /*
@@ -352,6 +362,8 @@ static void handle_write_error(struct ad
 typedef enum {
 	/* failed to write page out, page is locked */
 	PAGE_KEEP,
+	/* failed to write page out due to congestion, page is locked */
+	PAGE_KEEP_CONGESTED,
 	/* move page to the active list, page is locked */
 	PAGE_ACTIVATE,
 	/* page has been sent to the disk successfully, page is unlocked */
@@ -401,9 +413,14 @@ static pageout_t pageout(struct page *pa
 	}
 	if (mapping->a_ops->writepage == NULL)
 		return PAGE_ACTIVATE;
-	if (!may_write_to_queue(mapping->backing_dev_info, sc)) {
+	switch (may_write_to_queue(mapping->backing_dev_info, sc)) {
+	case QUEUEWRITE_CONGESTED:
+		return PAGE_KEEP_CONGESTED;
+	case QUEUEWRITE_DENIED:
 		disable_lumpy_reclaim_mode(sc);
 		return PAGE_KEEP;
+	case QUEUEWRITE_ALLOWED:
+		;
 	}
 
 	if (clear_page_dirty_for_io(page)) {
@@ -681,11 +698,14 @@ static noinline_for_stack void free_page
  * shrink_page_list() returns the number of reclaimed pages
  */
 static unsigned long shrink_page_list(struct list_head *page_list,
+				      struct zone *zone,
 				      struct scan_control *sc)
 {
 	LIST_HEAD(ret_pages);
 	LIST_HEAD(free_pages);
 	int pgactivate = 0;
+	unsigned long nr_dirty = 0;
+	unsigned long nr_congested = 0;
 	unsigned long nr_reclaimed = 0;
 
 	cond_resched();
@@ -705,6 +725,7 @@ static unsigned long shrink_page_list(st
 			goto keep;
 
 		VM_BUG_ON(PageActive(page));
+		VM_BUG_ON(page_zone(page) != zone);
 
 		sc->nr_scanned++;
 
@@ -782,6 +803,8 @@ static unsigned long shrink_page_list(st
 		}
 
 		if (PageDirty(page)) {
+			nr_dirty++;
+
 			if (references == PAGEREF_RECLAIM_CLEAN)
 				goto keep_locked;
 			if (!may_enter_fs)
@@ -791,6 +814,8 @@ static unsigned long shrink_page_list(st
 
 			/* Page is dirty, try to write it out here */
 			switch (pageout(page, mapping, sc)) {
+			case PAGE_KEEP_CONGESTED:
+				nr_congested++;
 			case PAGE_KEEP:
 				goto keep_locked;
 			case PAGE_ACTIVATE:
@@ -902,6 +927,15 @@ keep_lumpy:
 		VM_BUG_ON(PageLRU(page) || PageUnevictable(page));
 	}
 
+	/*
+	 * Tag a zone as congested if all the dirty pages encountered were
+	 * backed by a congested BDI. In this case, reclaimers should just
+	 * back off and wait for congestion to clear because further reclaim
+	 * will encounter the same problem
+	 */
+	if (nr_dirty == nr_congested)
+		zone_set_flag(zone, ZONE_CONGESTED);
+
 	free_page_list(&free_pages);
 
 	list_splice(&ret_pages, page_list);
@@ -1386,12 +1420,12 @@ shrink_inactive_list(unsigned long nr_to
 
 	spin_unlock_irq(&zone->lru_lock);
 
-	nr_reclaimed = shrink_page_list(&page_list, sc);
+	nr_reclaimed = shrink_page_list(&page_list, zone, sc);
 
 	/* Check if we should syncronously wait for writeback */
 	if (should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
 		set_lumpy_reclaim_mode(priority, sc, true);
-		nr_reclaimed += shrink_page_list(&page_list, sc);
+		nr_reclaimed += shrink_page_list(&page_list, zone, sc);
 	}
 
 	local_irq_disable();
@@ -1985,8 +2019,26 @@ static unsigned long do_try_to_free_page
 
 		/* Take a nap, wait for some writeback to complete */
 		if (!sc->hibernation_mode && sc->nr_scanned &&
-		    priority < DEF_PRIORITY - 2)
-			congestion_wait(BLK_RW_ASYNC, HZ/10);
+		    priority < DEF_PRIORITY - 2) {
+			struct zone *active_zone = NULL;
+			unsigned long max_writeback = 0;
+			for_each_zone_zonelist(zone, z, zonelist,
+					gfp_zone(sc->gfp_mask)) {
+				unsigned long writeback;
+
+				/* Initialise for first zone */
+				if (active_zone == NULL)
+					active_zone = zone;
+
+				writeback = zone_page_state(zone, NR_WRITEBACK);
+				if (writeback > max_writeback) {
+					max_writeback = writeback;
+					active_zone = zone;
+				}
+			}
+
+			wait_iff_congested(active_zone, BLK_RW_ASYNC, HZ/10);
+		}
 	}
 
 out:
@@ -2285,6 +2337,15 @@ loop_again:
 				if (!zone_watermark_ok(zone, order,
 					    min_wmark_pages(zone), end_zone, 0))
 					has_under_min_watermark_zone = 1;
+			} else {
+				/*
+				 * If a zone reaches its high watermark,
+				 * consider it to be no longer congested. It's
+				 * possible there are dirty pages backed by
+				 * congested BDIs but as pressure is relieved,
+				 * spectulatively avoid congestion waits
+				 */
+				zone_clear_flag(zone, ZONE_CONGESTED);
 			}
 
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

