From: akpm@linux-foundation.org
Subject: [merged] vmscan-cleanup-the-scan-batching-code.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:34:56 -0700
Message-ID: <200906171834.n5HIYuU4000943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758215AbZFQSfc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:35:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, npiggin@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: cleanup the scan batching code
has been removed from the -mm tree.  Its filename was
     vmscan-cleanup-the-scan-batching-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: cleanup the scan batching code
From: Wu Fengguang <fengguang.wu@intel.com>

The vmscan batching logic is twisting.  Move it into a standalone function
nr_scan_try_batch() and document it.  No behavior change.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 ++--
 mm/page_alloc.c        |    2 +-
 mm/vmscan.c            |   39 ++++++++++++++++++++++++++++-----------
 mm/vmstat.c            |    8 ++++----
 4 files changed, 35 insertions(+), 18 deletions(-)

diff -puN include/linux/mmzone.h~vmscan-cleanup-the-scan-batching-code include/linux/mmzone.h
--- a/include/linux/mmzone.h~vmscan-cleanup-the-scan-batching-code
+++ a/include/linux/mmzone.h
@@ -334,9 +334,9 @@ struct zone {
 
 	/* Fields commonly accessed by the page reclaim scanner */
 	spinlock_t		lru_lock;	
-	struct {
+	struct zone_lru {
 		struct list_head list;
-		unsigned long nr_scan;
+		unsigned long nr_saved_scan;	/* accumulated for batching */
 	} lru[NR_LRU_LISTS];
 
 	struct zone_reclaim_stat reclaim_stat;
diff -puN mm/page_alloc.c~vmscan-cleanup-the-scan-batching-code mm/page_alloc.c
--- a/mm/page_alloc.c~vmscan-cleanup-the-scan-batching-code
+++ a/mm/page_alloc.c
@@ -3657,7 +3657,7 @@ static void __paginginit free_area_init_
 		zone_pcp_init(zone);
 		for_each_lru(l) {
 			INIT_LIST_HEAD(&zone->lru[l].list);
-			zone->lru[l].nr_scan = 0;
+			zone->lru[l].nr_saved_scan = 0;
 		}
 		zone->reclaim_stat.recent_rotated[0] = 0;
 		zone->reclaim_stat.recent_rotated[1] = 0;
diff -puN mm/vmscan.c~vmscan-cleanup-the-scan-batching-code mm/vmscan.c
--- a/mm/vmscan.c~vmscan-cleanup-the-scan-batching-code
+++ a/mm/vmscan.c
@@ -1492,6 +1492,26 @@ static void get_scan_ratio(struct zone *
 	percent[1] = 100 - percent[0];
 }
 
+/*
+ * Smallish @nr_to_scan's are deposited in @nr_saved_scan,
+ * until we collected @swap_cluster_max pages to scan.
+ */
+static unsigned long nr_scan_try_batch(unsigned long nr_to_scan,
+				       unsigned long *nr_saved_scan,
+				       unsigned long swap_cluster_max)
+{
+	unsigned long nr;
+
+	*nr_saved_scan += nr_to_scan;
+	nr = *nr_saved_scan;
+
+	if (nr >= swap_cluster_max)
+		*nr_saved_scan = 0;
+	else
+		nr = 0;
+
+	return nr;
+}
 
 /*
  * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
@@ -1517,14 +1537,11 @@ static void shrink_zone(int priority, st
 			scan >>= priority;
 			scan = (scan * percent[file]) / 100;
 		}
-		if (scanning_global_lru(sc)) {
-			zone->lru[l].nr_scan += scan;
-			nr[l] = zone->lru[l].nr_scan;
-			if (nr[l] >= swap_cluster_max)
-				zone->lru[l].nr_scan = 0;
-			else
-				nr[l] = 0;
-		} else
+		if (scanning_global_lru(sc))
+			nr[l] = nr_scan_try_batch(scan,
+						  &zone->lru[l].nr_saved_scan,
+						  swap_cluster_max);
+		else
 			nr[l] = scan;
 	}
 
@@ -2124,11 +2141,11 @@ static void shrink_all_zones(unsigned lo
 						l == LRU_ACTIVE_FILE))
 				continue;
 
-			zone->lru[l].nr_scan += (lru_pages >> prio) + 1;
-			if (zone->lru[l].nr_scan >= nr_pages || pass > 3) {
+			zone->lru[l].nr_saved_scan += (lru_pages >> prio) + 1;
+			if (zone->lru[l].nr_saved_scan >= nr_pages || pass > 3) {
 				unsigned long nr_to_scan;
 
-				zone->lru[l].nr_scan = 0;
+				zone->lru[l].nr_saved_scan = 0;
 				nr_to_scan = min(nr_pages, lru_pages);
 				nr_reclaimed += shrink_list(l, nr_to_scan, zone,
 								sc, prio);
diff -puN mm/vmstat.c~vmscan-cleanup-the-scan-batching-code mm/vmstat.c
--- a/mm/vmstat.c~vmscan-cleanup-the-scan-batching-code
+++ a/mm/vmstat.c
@@ -718,10 +718,10 @@ static void zoneinfo_show_print(struct s
 		   low_wmark_pages(zone),
 		   high_wmark_pages(zone),
 		   zone->pages_scanned,
-		   zone->lru[LRU_ACTIVE_ANON].nr_scan,
-		   zone->lru[LRU_INACTIVE_ANON].nr_scan,
-		   zone->lru[LRU_ACTIVE_FILE].nr_scan,
-		   zone->lru[LRU_INACTIVE_FILE].nr_scan,
+		   zone->lru[LRU_ACTIVE_ANON].nr_saved_scan,
+		   zone->lru[LRU_INACTIVE_ANON].nr_saved_scan,
+		   zone->lru[LRU_ACTIVE_FILE].nr_saved_scan,
+		   zone->lru[LRU_INACTIVE_FILE].nr_saved_scan,
 		   zone->spanned_pages,
 		   zone->present_pages);
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch

