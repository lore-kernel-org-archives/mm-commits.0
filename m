From: akpm@linux-foundation.org
Subject: + vmscan-cleanup-the-scan-batching-code.patch added to -mm tree
Date: Mon, 04 May 2009 14:43:33 -0700
Message-ID: <200905042143.n44LhXqs013659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104AbZEDVra (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 17:47:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, npiggin@suse.de, riel@redhat.com


The patch titled
     vmscan: cleanup the scan batching code
has been added to the -mm tree.  Its filename is
     vmscan-cleanup-the-scan-batching-code.patch

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
@@ -326,9 +326,9 @@ struct zone {
 
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
@@ -3729,7 +3729,7 @@ static void __paginginit free_area_init_
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
@@ -1490,6 +1490,26 @@ static void get_scan_ratio(struct zone *
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
@@ -1515,14 +1535,11 @@ static void shrink_zone(int priority, st
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
 
@@ -2119,11 +2136,11 @@ static void shrink_all_zones(unsigned lo
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
@@ -729,10 +729,10 @@ static void zoneinfo_show_print(struct s
 		   zone->pages_low,
 		   zone->pages_high,
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
inotify-use-gfp_nofs-in-kernel_event-to-work-around-a-lockdep-false-positive.patch
inotify-use-gfp_nofs-in-kernel_event-to-work-around-a-lockdep-false-positive-fix.patch
linux-next.patch
readahead-make-mmap_miss-an-unsigned-int.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-one-unnecessary-radix-tree-lookup.patch
readahead-increase-interleaved-readahead-size.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
radix-tree-add-radix_tree_prev_hole.patch
readahead-move-the-random-read-case-to-bottom.patch
readahead-introduce-context-readahead-algorithm.patch
readahead-introduce-context-readahead-algorithm-update.patch
readahead-remove-redundant-test-in-shrink_readahead_size_eio.patch
readahead-enforce-full-sync-mmap-readahead-size.patch
pagemap-document-clarifications.patch
pagemap-documentation-9-more-exported-page-flags.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch
vmscan-cleanup-the-scan-batching-code.patch
vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo.patch

