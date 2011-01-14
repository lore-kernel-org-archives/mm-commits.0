From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:44:53 -0800
Message-ID: <201101142247.p0EMlhM6005027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872Ab1ANWsI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:48:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aarcange@redhat.com, apw@shadowen.org, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: vmscan: convert lumpy_mode into a bitmask
has been removed from the -mm tree.  Its filename was
     mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmscan: convert lumpy_mode into a bitmask
From: Mel Gorman <mel@csn.ul.ie>

Currently lumpy_mode is an enum and determines if lumpy reclaim is off,
syncronous or asyncronous.  In preparation for using compaction instead of
lumpy reclaim, this patch converts the flags into a bitmap.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |    6 ++--
 mm/vmscan.c                   |   46 +++++++++++++++++++-------------
 2 files changed, 31 insertions(+), 21 deletions(-)

diff -puN include/trace/events/vmscan.h~mm-vmscan-convert-lumpy_mode-into-a-bitmask include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~mm-vmscan-convert-lumpy_mode-into-a-bitmask
+++ a/include/trace/events/vmscan.h
@@ -25,13 +25,13 @@
 
 #define trace_reclaim_flags(page, sync) ( \
 	(page_is_file_cache(page) ? RECLAIM_WB_FILE : RECLAIM_WB_ANON) | \
-	(sync == LUMPY_MODE_SYNC ? RECLAIM_WB_SYNC : RECLAIM_WB_ASYNC)   \
+	(sync & LUMPY_MODE_SYNC ? RECLAIM_WB_SYNC : RECLAIM_WB_ASYNC)   \
 	)
 
 #define trace_shrink_flags(file, sync) ( \
-	(sync == LUMPY_MODE_SYNC ? RECLAIM_WB_MIXED : \
+	(sync & LUMPY_MODE_SYNC ? RECLAIM_WB_MIXED : \
 			(file ? RECLAIM_WB_FILE : RECLAIM_WB_ANON)) |  \
-	(sync == LUMPY_MODE_SYNC ? RECLAIM_WB_SYNC : RECLAIM_WB_ASYNC) \
+	(sync & LUMPY_MODE_SYNC ? RECLAIM_WB_SYNC : RECLAIM_WB_ASYNC) \
 	)
 
 TRACE_EVENT(mm_vmscan_kswapd_sleep,
diff -puN mm/vmscan.c~mm-vmscan-convert-lumpy_mode-into-a-bitmask mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-convert-lumpy_mode-into-a-bitmask
+++ a/mm/vmscan.c
@@ -51,11 +51,20 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/vmscan.h>
 
-enum lumpy_mode {
-	LUMPY_MODE_NONE,
-	LUMPY_MODE_ASYNC,
-	LUMPY_MODE_SYNC,
-};
+/*
+ * lumpy_mode determines how the inactive list is shrunk
+ * LUMPY_MODE_SINGLE: Reclaim only order-0 pages
+ * LUMPY_MODE_ASYNC:  Do not block
+ * LUMPY_MODE_SYNC:   Allow blocking e.g. call wait_on_page_writeback
+ * LUMPY_MODE_CONTIGRECLAIM: For high-order allocations, take a reference
+ *			page from the LRU and reclaim all pages within a
+ *			naturally aligned range
+ */
+typedef unsigned __bitwise__ lumpy_mode;
+#define LUMPY_MODE_SINGLE		((__force lumpy_mode)0x01u)
+#define LUMPY_MODE_ASYNC		((__force lumpy_mode)0x02u)
+#define LUMPY_MODE_SYNC			((__force lumpy_mode)0x04u)
+#define LUMPY_MODE_CONTIGRECLAIM	((__force lumpy_mode)0x08u)
 
 struct scan_control {
 	/* Incremented by the number of inactive pages that were scanned */
@@ -88,7 +97,7 @@ struct scan_control {
 	 * Intend to reclaim enough continuous memory rather than reclaim
 	 * enough amount of memory. i.e, mode for high order allocation.
 	 */
-	enum lumpy_mode lumpy_reclaim_mode;
+	lumpy_mode lumpy_reclaim_mode;
 
 	/* Which cgroup do we reclaim from */
 	struct mem_cgroup *mem_cgroup;
@@ -274,13 +283,13 @@ unsigned long shrink_slab(unsigned long 
 static void set_lumpy_reclaim_mode(int priority, struct scan_control *sc,
 				   bool sync)
 {
-	enum lumpy_mode mode = sync ? LUMPY_MODE_SYNC : LUMPY_MODE_ASYNC;
+	lumpy_mode syncmode = sync ? LUMPY_MODE_SYNC : LUMPY_MODE_ASYNC;
 
 	/*
 	 * Some reclaim have alredy been failed. No worth to try synchronous
 	 * lumpy reclaim.
 	 */
-	if (sync && sc->lumpy_reclaim_mode == LUMPY_MODE_NONE)
+	if (sync && sc->lumpy_reclaim_mode & LUMPY_MODE_SINGLE)
 		return;
 
 	/*
@@ -288,17 +297,18 @@ static void set_lumpy_reclaim_mode(int p
 	 * trouble getting a small set of contiguous pages, we
 	 * will reclaim both active and inactive pages.
 	 */
+	sc->lumpy_reclaim_mode = LUMPY_MODE_CONTIGRECLAIM;
 	if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
-		sc->lumpy_reclaim_mode = mode;
+		sc->lumpy_reclaim_mode |= syncmode;
 	else if (sc->order && priority < DEF_PRIORITY - 2)
-		sc->lumpy_reclaim_mode = mode;
+		sc->lumpy_reclaim_mode |= syncmode;
 	else
-		sc->lumpy_reclaim_mode = LUMPY_MODE_NONE;
+		sc->lumpy_reclaim_mode = LUMPY_MODE_SINGLE | LUMPY_MODE_ASYNC;
 }
 
 static void disable_lumpy_reclaim_mode(struct scan_control *sc)
 {
-	sc->lumpy_reclaim_mode = LUMPY_MODE_NONE;
+	sc->lumpy_reclaim_mode = LUMPY_MODE_SINGLE | LUMPY_MODE_ASYNC;
 }
 
 static inline int is_page_cache_freeable(struct page *page)
@@ -429,7 +439,7 @@ static pageout_t pageout(struct page *pa
 		 * first attempt to free a range of pages fails.
 		 */
 		if (PageWriteback(page) &&
-		    sc->lumpy_reclaim_mode == LUMPY_MODE_SYNC)
+		    (sc->lumpy_reclaim_mode & LUMPY_MODE_SYNC))
 			wait_on_page_writeback(page);
 
 		if (!PageWriteback(page)) {
@@ -622,7 +632,7 @@ static enum page_references page_check_r
 	referenced_page = TestClearPageReferenced(page);
 
 	/* Lumpy reclaim - ignore references */
-	if (sc->lumpy_reclaim_mode != LUMPY_MODE_NONE)
+	if (sc->lumpy_reclaim_mode & LUMPY_MODE_CONTIGRECLAIM)
 		return PAGEREF_RECLAIM;
 
 	/*
@@ -739,7 +749,7 @@ static unsigned long shrink_page_list(st
 			 * for any page for which writeback has already
 			 * started.
 			 */
-			if (sc->lumpy_reclaim_mode == LUMPY_MODE_SYNC &&
+			if ((sc->lumpy_reclaim_mode & LUMPY_MODE_SYNC) &&
 			    may_enter_fs)
 				wait_on_page_writeback(page);
 			else {
@@ -1324,7 +1334,7 @@ static inline bool should_reclaim_stall(
 		return false;
 
 	/* Only stall on lumpy reclaim */
-	if (sc->lumpy_reclaim_mode == LUMPY_MODE_NONE)
+	if (sc->lumpy_reclaim_mode & LUMPY_MODE_SINGLE)
 		return false;
 
 	/* If we have relaimed everything on the isolated list, no stall */
@@ -1375,7 +1385,7 @@ shrink_inactive_list(unsigned long nr_to
 	if (scanning_global_lru(sc)) {
 		nr_taken = isolate_pages_global(nr_to_scan,
 			&page_list, &nr_scanned, sc->order,
-			sc->lumpy_reclaim_mode == LUMPY_MODE_NONE ?
+			sc->lumpy_reclaim_mode & LUMPY_MODE_SINGLE ?
 					ISOLATE_INACTIVE : ISOLATE_BOTH,
 			zone, 0, file);
 		zone->pages_scanned += nr_scanned;
@@ -1388,7 +1398,7 @@ shrink_inactive_list(unsigned long nr_to
 	} else {
 		nr_taken = mem_cgroup_isolate_pages(nr_to_scan,
 			&page_list, &nr_scanned, sc->order,
-			sc->lumpy_reclaim_mode == LUMPY_MODE_NONE ?
+			sc->lumpy_reclaim_mode & LUMPY_MODE_SINGLE ?
 					ISOLATE_INACTIVE : ISOLATE_BOTH,
 			zone, sc->mem_cgroup,
 			0, file);
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

