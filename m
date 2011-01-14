From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:45:03 -0800
Message-ID: <201101142247.p0EMlr9f005050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753058Ab1ANWsj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:48:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aarcange@redhat.com, apw@shadowen.org, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: vmscan: rename lumpy_mode to reclaim_mode
has been removed from the -mm tree.  Its filename was
     mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmscan: rename lumpy_mode to reclaim_mode
From: Mel Gorman <mel@csn.ul.ie>

With compaction being used instead of lumpy reclaim, the name lumpy_mode
and associated variables is a bit misleading.  Rename lumpy_mode to
reclaim_mode which is a better fit.  There is no functional change.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |    6 +-
 mm/vmscan.c                   |   70 ++++++++++++++++----------------
 2 files changed, 38 insertions(+), 38 deletions(-)

diff -puN include/trace/events/vmscan.h~mm-vmscan-rename-lumpy_mode-to-reclaim_mode include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~mm-vmscan-rename-lumpy_mode-to-reclaim_mode
+++ a/include/trace/events/vmscan.h
@@ -25,13 +25,13 @@
 
 #define trace_reclaim_flags(page, sync) ( \
 	(page_is_file_cache(page) ? RECLAIM_WB_FILE : RECLAIM_WB_ANON) | \
-	(sync & LUMPY_MODE_SYNC ? RECLAIM_WB_SYNC : RECLAIM_WB_ASYNC)   \
+	(sync & RECLAIM_MODE_SYNC ? RECLAIM_WB_SYNC : RECLAIM_WB_ASYNC)   \
 	)
 
 #define trace_shrink_flags(file, sync) ( \
-	(sync & LUMPY_MODE_SYNC ? RECLAIM_WB_MIXED : \
+	(sync & RECLAIM_MODE_SYNC ? RECLAIM_WB_MIXED : \
 			(file ? RECLAIM_WB_FILE : RECLAIM_WB_ANON)) |  \
-	(sync & LUMPY_MODE_SYNC ? RECLAIM_WB_SYNC : RECLAIM_WB_ASYNC) \
+	(sync & RECLAIM_MODE_SYNC ? RECLAIM_WB_SYNC : RECLAIM_WB_ASYNC) \
 	)
 
 TRACE_EVENT(mm_vmscan_kswapd_sleep,
diff -puN mm/vmscan.c~mm-vmscan-rename-lumpy_mode-to-reclaim_mode mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-rename-lumpy_mode-to-reclaim_mode
+++ a/mm/vmscan.c
@@ -53,22 +53,22 @@
 #include <trace/events/vmscan.h>
 
 /*
- * lumpy_mode determines how the inactive list is shrunk
- * LUMPY_MODE_SINGLE: Reclaim only order-0 pages
- * LUMPY_MODE_ASYNC:  Do not block
- * LUMPY_MODE_SYNC:   Allow blocking e.g. call wait_on_page_writeback
- * LUMPY_MODE_CONTIGRECLAIM: For high-order allocations, take a reference
+ * reclaim_mode determines how the inactive list is shrunk
+ * RECLAIM_MODE_SINGLE: Reclaim only order-0 pages
+ * RECLAIM_MODE_ASYNC:  Do not block
+ * RECLAIM_MODE_SYNC:   Allow blocking e.g. call wait_on_page_writeback
+ * RECLAIM_MODE_LUMPYRECLAIM: For high-order allocations, take a reference
  *			page from the LRU and reclaim all pages within a
  *			naturally aligned range
- * LUMPY_MODE_COMPACTION: For high-order allocations, reclaim a number of
+ * RECLAIM_MODE_COMPACTION: For high-order allocations, reclaim a number of
  *			order-0 pages and then compact the zone
  */
-typedef unsigned __bitwise__ lumpy_mode;
-#define LUMPY_MODE_SINGLE		((__force lumpy_mode)0x01u)
-#define LUMPY_MODE_ASYNC		((__force lumpy_mode)0x02u)
-#define LUMPY_MODE_SYNC			((__force lumpy_mode)0x04u)
-#define LUMPY_MODE_CONTIGRECLAIM	((__force lumpy_mode)0x08u)
-#define LUMPY_MODE_COMPACTION		((__force lumpy_mode)0x10u)
+typedef unsigned __bitwise__ reclaim_mode_t;
+#define RECLAIM_MODE_SINGLE		((__force reclaim_mode_t)0x01u)
+#define RECLAIM_MODE_ASYNC		((__force reclaim_mode_t)0x02u)
+#define RECLAIM_MODE_SYNC		((__force reclaim_mode_t)0x04u)
+#define RECLAIM_MODE_LUMPYRECLAIM	((__force reclaim_mode_t)0x08u)
+#define RECLAIM_MODE_COMPACTION		((__force reclaim_mode_t)0x10u)
 
 struct scan_control {
 	/* Incremented by the number of inactive pages that were scanned */
@@ -101,7 +101,7 @@ struct scan_control {
 	 * Intend to reclaim enough continuous memory rather than reclaim
 	 * enough amount of memory. i.e, mode for high order allocation.
 	 */
-	lumpy_mode lumpy_reclaim_mode;
+	reclaim_mode_t reclaim_mode;
 
 	/* Which cgroup do we reclaim from */
 	struct mem_cgroup *mem_cgroup;
@@ -284,10 +284,10 @@ unsigned long shrink_slab(unsigned long 
 	return ret;
 }
 
-static void set_lumpy_reclaim_mode(int priority, struct scan_control *sc,
+static void set_reclaim_mode(int priority, struct scan_control *sc,
 				   bool sync)
 {
-	lumpy_mode syncmode = sync ? LUMPY_MODE_SYNC : LUMPY_MODE_ASYNC;
+	reclaim_mode_t syncmode = sync ? RECLAIM_MODE_SYNC : RECLAIM_MODE_ASYNC;
 
 	/*
 	 * Initially assume we are entering either lumpy reclaim or
@@ -295,9 +295,9 @@ static void set_lumpy_reclaim_mode(int p
 	 * sync mode or just reclaim order-0 pages later.
 	 */
 	if (COMPACTION_BUILD)
-		sc->lumpy_reclaim_mode = LUMPY_MODE_COMPACTION;
+		sc->reclaim_mode = RECLAIM_MODE_COMPACTION;
 	else
-		sc->lumpy_reclaim_mode = LUMPY_MODE_CONTIGRECLAIM;
+		sc->reclaim_mode = RECLAIM_MODE_LUMPYRECLAIM;
 
 	/*
 	 * Avoid using lumpy reclaim or reclaim/compaction if possible by
@@ -305,16 +305,16 @@ static void set_lumpy_reclaim_mode(int p
 	 * under memory pressure
 	 */
 	if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
-		sc->lumpy_reclaim_mode |= syncmode;
+		sc->reclaim_mode |= syncmode;
 	else if (sc->order && priority < DEF_PRIORITY - 2)
-		sc->lumpy_reclaim_mode |= syncmode;
+		sc->reclaim_mode |= syncmode;
 	else
-		sc->lumpy_reclaim_mode = LUMPY_MODE_SINGLE | LUMPY_MODE_ASYNC;
+		sc->reclaim_mode = RECLAIM_MODE_SINGLE | RECLAIM_MODE_ASYNC;
 }
 
-static void disable_lumpy_reclaim_mode(struct scan_control *sc)
+static void reset_reclaim_mode(struct scan_control *sc)
 {
-	sc->lumpy_reclaim_mode = LUMPY_MODE_SINGLE | LUMPY_MODE_ASYNC;
+	sc->reclaim_mode = RECLAIM_MODE_SINGLE | RECLAIM_MODE_ASYNC;
 }
 
 static inline int is_page_cache_freeable(struct page *page)
@@ -445,7 +445,7 @@ static pageout_t pageout(struct page *pa
 		 * first attempt to free a range of pages fails.
 		 */
 		if (PageWriteback(page) &&
-		    (sc->lumpy_reclaim_mode & LUMPY_MODE_SYNC))
+		    (sc->reclaim_mode & RECLAIM_MODE_SYNC))
 			wait_on_page_writeback(page);
 
 		if (!PageWriteback(page)) {
@@ -453,7 +453,7 @@ static pageout_t pageout(struct page *pa
 			ClearPageReclaim(page);
 		}
 		trace_mm_vmscan_writepage(page,
-			trace_reclaim_flags(page, sc->lumpy_reclaim_mode));
+			trace_reclaim_flags(page, sc->reclaim_mode));
 		inc_zone_page_state(page, NR_VMSCAN_WRITE);
 		return PAGE_SUCCESS;
 	}
@@ -638,7 +638,7 @@ static enum page_references page_check_r
 	referenced_page = TestClearPageReferenced(page);
 
 	/* Lumpy reclaim - ignore references */
-	if (sc->lumpy_reclaim_mode & LUMPY_MODE_CONTIGRECLAIM)
+	if (sc->reclaim_mode & RECLAIM_MODE_LUMPYRECLAIM)
 		return PAGEREF_RECLAIM;
 
 	/*
@@ -755,7 +755,7 @@ static unsigned long shrink_page_list(st
 			 * for any page for which writeback has already
 			 * started.
 			 */
-			if ((sc->lumpy_reclaim_mode & LUMPY_MODE_SYNC) &&
+			if ((sc->reclaim_mode & RECLAIM_MODE_SYNC) &&
 			    may_enter_fs)
 				wait_on_page_writeback(page);
 			else {
@@ -911,7 +911,7 @@ cull_mlocked:
 			try_to_free_swap(page);
 		unlock_page(page);
 		putback_lru_page(page);
-		disable_lumpy_reclaim_mode(sc);
+		reset_reclaim_mode(sc);
 		continue;
 
 activate_locked:
@@ -924,7 +924,7 @@ activate_locked:
 keep_locked:
 		unlock_page(page);
 keep:
-		disable_lumpy_reclaim_mode(sc);
+		reset_reclaim_mode(sc);
 keep_lumpy:
 		list_add(&page->lru, &ret_pages);
 		VM_BUG_ON(PageLRU(page) || PageUnevictable(page));
@@ -1340,7 +1340,7 @@ static inline bool should_reclaim_stall(
 		return false;
 
 	/* Only stall on lumpy reclaim */
-	if (sc->lumpy_reclaim_mode & LUMPY_MODE_SINGLE)
+	if (sc->reclaim_mode & RECLAIM_MODE_SINGLE)
 		return false;
 
 	/* If we have relaimed everything on the isolated list, no stall */
@@ -1384,14 +1384,14 @@ shrink_inactive_list(unsigned long nr_to
 			return SWAP_CLUSTER_MAX;
 	}
 
-	set_lumpy_reclaim_mode(priority, sc, false);
+	set_reclaim_mode(priority, sc, false);
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
 
 	if (scanning_global_lru(sc)) {
 		nr_taken = isolate_pages_global(nr_to_scan,
 			&page_list, &nr_scanned, sc->order,
-			sc->lumpy_reclaim_mode & LUMPY_MODE_CONTIGRECLAIM ?
+			sc->reclaim_mode & RECLAIM_MODE_LUMPYRECLAIM ?
 					ISOLATE_BOTH : ISOLATE_INACTIVE,
 			zone, 0, file);
 		zone->pages_scanned += nr_scanned;
@@ -1404,7 +1404,7 @@ shrink_inactive_list(unsigned long nr_to
 	} else {
 		nr_taken = mem_cgroup_isolate_pages(nr_to_scan,
 			&page_list, &nr_scanned, sc->order,
-			sc->lumpy_reclaim_mode & LUMPY_MODE_CONTIGRECLAIM ?
+			sc->reclaim_mode & RECLAIM_MODE_LUMPYRECLAIM ?
 					ISOLATE_BOTH : ISOLATE_INACTIVE,
 			zone, sc->mem_cgroup,
 			0, file);
@@ -1427,7 +1427,7 @@ shrink_inactive_list(unsigned long nr_to
 
 	/* Check if we should syncronously wait for writeback */
 	if (should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
-		set_lumpy_reclaim_mode(priority, sc, true);
+		set_reclaim_mode(priority, sc, true);
 		nr_reclaimed += shrink_page_list(&page_list, zone, sc);
 	}
 
@@ -1442,7 +1442,7 @@ shrink_inactive_list(unsigned long nr_to
 		zone_idx(zone),
 		nr_scanned, nr_reclaimed,
 		priority,
-		trace_shrink_flags(file, sc->lumpy_reclaim_mode));
+		trace_shrink_flags(file, sc->reclaim_mode));
 	return nr_reclaimed;
 }
 
@@ -1836,7 +1836,7 @@ static inline bool should_continue_recla
 	unsigned long inactive_lru_pages;
 
 	/* If not in reclaim/compaction mode, stop */
-	if (!(sc->lumpy_reclaim_mode & LUMPY_MODE_COMPACTION))
+	if (!(sc->reclaim_mode & RECLAIM_MODE_COMPACTION))
 		return false;
 
 	/*
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
thp-add-pagetranscompound.patch
add-debugging-aid-for-memory-initialisation-problems.patch

