From: akpm@linux-foundation.org
Subject: [merged] vmscan-separate-scswap_cluster_max-and-scnr_max_reclaim.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:52:53 -0800
Message-ID: <200912152152.nBFLqriJ015226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933974AbZLOWQ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:16:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: separate sc.swap_cluster_max and sc.nr_max_reclaim
has been removed from the -mm tree.  Its filename was
     vmscan-separate-scswap_cluster_max-and-scnr_max_reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: separate sc.swap_cluster_max and sc.nr_max_reclaim
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, sc.scap_cluster_max has double meanings.

 1) reclaim batch size as isolate_lru_pages()'s argument
 2) reclaim baling out thresolds

The two meanings pretty unrelated. Thus, Let's separate it.
this patch doesn't change any behavior.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff -puN mm/vmscan.c~vmscan-separate-scswap_cluster_max-and-scnr_max_reclaim mm/vmscan.c
--- a/mm/vmscan.c~vmscan-separate-scswap_cluster_max-and-scnr_max_reclaim
+++ a/mm/vmscan.c
@@ -55,6 +55,9 @@ struct scan_control {
 	/* Number of pages freed so far during a call to shrink_zones() */
 	unsigned long nr_reclaimed;
 
+	/* How many pages shrink_list() should reclaim */
+	unsigned long nr_to_reclaim;
+
 	/* This context's GFP mask */
 	gfp_t gfp_mask;
 
@@ -1595,6 +1598,7 @@ static void shrink_zone(int priority, st
 	enum lru_list l;
 	unsigned long nr_reclaimed = sc->nr_reclaimed;
 	unsigned long swap_cluster_max = sc->swap_cluster_max;
+	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 	int noswap = 0;
 
@@ -1639,8 +1643,7 @@ static void shrink_zone(int priority, st
 		 * with multiple processes reclaiming pages, the total
 		 * freeing target can get unreasonably large.
 		 */
-		if (nr_reclaimed > swap_cluster_max &&
-			priority < DEF_PRIORITY && !current_is_kswapd())
+		if (nr_reclaimed > nr_to_reclaim && priority < DEF_PRIORITY)
 			break;
 	}
 
@@ -1738,6 +1741,7 @@ static unsigned long do_try_to_free_page
 	struct zoneref *z;
 	struct zone *zone;
 	enum zone_type high_zoneidx = gfp_zone(sc->gfp_mask);
+	unsigned long writeback_threshold;
 
 	delayacct_freepages_start();
 
@@ -1773,7 +1777,7 @@ static unsigned long do_try_to_free_page
 			}
 		}
 		total_scanned += sc->nr_scanned;
-		if (sc->nr_reclaimed >= sc->swap_cluster_max) {
+		if (sc->nr_reclaimed >= sc->nr_to_reclaim) {
 			ret = sc->nr_reclaimed;
 			goto out;
 		}
@@ -1785,8 +1789,8 @@ static unsigned long do_try_to_free_page
 		 * that's undesirable in laptop mode, where we *want* lumpy
 		 * writeout.  So in laptop mode, write out the whole world.
 		 */
-		if (total_scanned > sc->swap_cluster_max +
-					sc->swap_cluster_max / 2) {
+		writeback_threshold = sc->nr_to_reclaim + sc->nr_to_reclaim / 2;
+		if (total_scanned > writeback_threshold) {
 			wakeup_flusher_threads(laptop_mode ? 0 : total_scanned);
 			sc->may_writepage = 1;
 		}
@@ -1832,6 +1836,7 @@ unsigned long try_to_free_pages(struct z
 		.gfp_mask = gfp_mask,
 		.may_writepage = !laptop_mode,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
+		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.may_unmap = 1,
 		.may_swap = 1,
 		.swappiness = vm_swappiness,
@@ -1890,6 +1895,7 @@ unsigned long try_to_free_mem_cgroup_pag
 		.may_unmap = 1,
 		.may_swap = !noswap,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
+		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.swappiness = swappiness,
 		.order = 0,
 		.mem_cgroup = mem_cont,
@@ -1961,6 +1967,11 @@ static unsigned long balance_pgdat(pg_da
 		.may_unmap = 1,
 		.may_swap = 1,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
+		/*
+		 * kswapd doesn't want to be bailed out while reclaim. because
+		 * we want to put equal scanning pressure on each zone.
+		 */
+		.nr_to_reclaim = ULONG_MAX,
 		.swappiness = vm_swappiness,
 		.order = order,
 		.mem_cgroup = NULL,
@@ -2630,7 +2641,9 @@ static int __zone_reclaim(struct zone *z
 		.may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
 		.may_swap = 1,
 		.swap_cluster_max = max_t(unsigned long, nr_pages,
-					SWAP_CLUSTER_MAX),
+				       SWAP_CLUSTER_MAX),
+		.nr_to_reclaim = max_t(unsigned long, nr_pages,
+				       SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,
 		.swappiness = vm_swappiness,
 		.order = order,
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mm-introduce-coredump-parameter-structure.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

