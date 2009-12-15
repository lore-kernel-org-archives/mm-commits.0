From: akpm@linux-foundation.org
Subject: [merged] vmscan-kill-scswap_cluster_max.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:53:06 -0800
Message-ID: <200912152153.nBFLr6xa015247@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761231AbZLOVxu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:53:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: kill sc.swap_cluster_max
has been removed from the -mm tree.  Its filename was
     vmscan-kill-scswap_cluster_max.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: kill sc.swap_cluster_max
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Now, All caller of reclaim use swap_cluster_max as SWAP_CLUSTER_MAX. 
Then, we can remove it perfectly.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff -puN mm/vmscan.c~vmscan-kill-scswap_cluster_max mm/vmscan.c
--- a/mm/vmscan.c~vmscan-kill-scswap_cluster_max
+++ a/mm/vmscan.c
@@ -71,12 +71,6 @@ struct scan_control {
 	/* Can pages be swapped as part of reclaim? */
 	int may_swap;
 
-	/* This context's SWAP_CLUSTER_MAX. If freeing memory for
-	 * suspend, we effectively ignore SWAP_CLUSTER_MAX.
-	 * In this context, it doesn't matter that we scan the
-	 * whole list at once. */
-	int swap_cluster_max;
-
 	int swappiness;
 
 	int all_unreclaimable;
@@ -1137,7 +1131,7 @@ static unsigned long shrink_inactive_lis
 		unsigned long nr_anon;
 		unsigned long nr_file;
 
-		nr_taken = sc->isolate_pages(sc->swap_cluster_max,
+		nr_taken = sc->isolate_pages(SWAP_CLUSTER_MAX,
 			     &page_list, &nr_scan, sc->order, mode,
 				zone, sc->mem_cgroup, 0, file);
 
@@ -1572,15 +1566,14 @@ static void get_scan_ratio(struct zone *
  * until we collected @swap_cluster_max pages to scan.
  */
 static unsigned long nr_scan_try_batch(unsigned long nr_to_scan,
-				       unsigned long *nr_saved_scan,
-				       unsigned long swap_cluster_max)
+				       unsigned long *nr_saved_scan)
 {
 	unsigned long nr;
 
 	*nr_saved_scan += nr_to_scan;
 	nr = *nr_saved_scan;
 
-	if (nr >= swap_cluster_max)
+	if (nr >= SWAP_CLUSTER_MAX)
 		*nr_saved_scan = 0;
 	else
 		nr = 0;
@@ -1599,7 +1592,6 @@ static void shrink_zone(int priority, st
 	unsigned long percent[2];	/* anon @ 0; file @ 1 */
 	enum lru_list l;
 	unsigned long nr_reclaimed = sc->nr_reclaimed;
-	unsigned long swap_cluster_max = sc->swap_cluster_max;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 	int noswap = 0;
@@ -1622,15 +1614,15 @@ static void shrink_zone(int priority, st
 			scan = (scan * percent[file]) / 100;
 		}
 		nr[l] = nr_scan_try_batch(scan,
-					  &reclaim_stat->nr_saved_scan[l],
-					  swap_cluster_max);
+					  &reclaim_stat->nr_saved_scan[l]);
 	}
 
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
 		for_each_evictable_lru(l) {
 			if (nr[l]) {
-				nr_to_scan = min(nr[l], swap_cluster_max);
+				nr_to_scan = min_t(unsigned long,
+						   nr[l], SWAP_CLUSTER_MAX);
 				nr[l] -= nr_to_scan;
 
 				nr_reclaimed += shrink_list(l, nr_to_scan,
@@ -1838,7 +1830,6 @@ unsigned long try_to_free_pages(struct z
 	struct scan_control sc = {
 		.gfp_mask = gfp_mask,
 		.may_writepage = !laptop_mode,
-		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.may_unmap = 1,
 		.may_swap = 1,
@@ -1863,7 +1854,6 @@ unsigned long mem_cgroup_shrink_node_zon
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
 		.may_swap = !noswap,
-		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.swappiness = swappiness,
 		.order = 0,
 		.mem_cgroup = mem,
@@ -1897,7 +1887,6 @@ unsigned long try_to_free_mem_cgroup_pag
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
 		.may_swap = !noswap,
-		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.swappiness = swappiness,
 		.order = 0,
@@ -1969,7 +1958,6 @@ static unsigned long balance_pgdat(pg_da
 		.gfp_mask = GFP_KERNEL,
 		.may_unmap = 1,
 		.may_swap = 1,
-		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		/*
 		 * kswapd doesn't want to be bailed out while reclaim. because
 		 * we want to put equal scanning pressure on each zone.
@@ -2354,7 +2342,6 @@ unsigned long shrink_all_memory(unsigned
 		.may_swap = 1,
 		.may_unmap = 1,
 		.may_writepage = 1,
-		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.nr_to_reclaim = nr_to_reclaim,
 		.hibernation_mode = 1,
 		.swappiness = vm_swappiness,
@@ -2539,7 +2526,6 @@ static int __zone_reclaim(struct zone *z
 		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
 		.may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
 		.may_swap = 1,
-		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.nr_to_reclaim = max_t(unsigned long, nr_pages,
 				       SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mm-introduce-coredump-parameter-structure.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

