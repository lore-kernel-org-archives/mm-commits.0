From: akpm@linux-foundation.org
Subject: + vmscan-kill-scswap_cluster_max.patch added to -mm tree
Date: Thu, 12 Nov 2009 13:50:42 -0800
Message-ID: <200911122150.nACLogoQ019946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274AbZKLVvL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 16:51:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     vmscan: kill sc.swap_cluster_max
has been added to the -mm tree.  Its filename is
     vmscan-kill-scswap_cluster_max.patch

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
 
@@ -1576,15 +1570,14 @@ static void get_scan_ratio(struct zone *
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
@@ -1603,7 +1596,6 @@ static void shrink_zone(int priority, st
 	unsigned long percent[2];	/* anon @ 0; file @ 1 */
 	enum lru_list l;
 	unsigned long nr_reclaimed = sc->nr_reclaimed;
-	unsigned long swap_cluster_max = sc->swap_cluster_max;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 	int noswap = 0;
@@ -1626,15 +1618,15 @@ static void shrink_zone(int priority, st
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
@@ -1842,7 +1834,6 @@ unsigned long try_to_free_pages(struct z
 	struct scan_control sc = {
 		.gfp_mask = gfp_mask,
 		.may_writepage = !laptop_mode,
-		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.may_unmap = 1,
 		.may_swap = 1,
@@ -1867,7 +1858,6 @@ unsigned long mem_cgroup_shrink_node_zon
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
 		.may_swap = !noswap,
-		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.swappiness = swappiness,
 		.order = 0,
 		.mem_cgroup = mem,
@@ -1901,7 +1891,6 @@ unsigned long try_to_free_mem_cgroup_pag
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
 		.may_swap = !noswap,
-		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.swappiness = swappiness,
 		.order = 0,
@@ -1967,7 +1956,6 @@ static unsigned long balance_pgdat(pg_da
 		.gfp_mask = GFP_KERNEL,
 		.may_unmap = 1,
 		.may_swap = 1,
-		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		/*
 		 * kswapd doesn't want to be bailed out while reclaim. because
 		 * we want to put equal scanning pressure on each zone.
@@ -2348,7 +2336,6 @@ unsigned long shrink_all_memory(unsigned
 		.may_swap = 1,
 		.may_unmap = 1,
 		.may_writepage = 1,
-		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.nr_to_reclaim = nr_to_reclaim,
 		.hibernation_mode = 1,
 		.swappiness = vm_swappiness,
@@ -2533,7 +2520,6 @@ static int __zone_reclaim(struct zone *z
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
page-allocator-always-wake-kswapd-when-restarting-an-allocation-attempt-after-direct-reclaim-failed.patch
page-allocator-do-not-allow-interrupts-to-use-alloc_harder.patch
linux-next.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place.patch
rmap-simplify-try_to_unmap_file.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch
vmscan-take-order-into-consideration-when-deciding-if-kswapd-is-in-trouble.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
mm-add-numa-node-symlink-for-memory-section-in-sysfs.patch
mm-refactor-register_cpu_under_node.patch
mm-refactor-unregister_cpu_under_node.patch
mm-add-numa-node-symlink-for-cpu-devices-in-sysfs.patch
documentation-abi-sys-devices-system-cpu-cpu-node.patch
vmscan-separate-scswap_cluster_max-and-scnr_max_reclaim.patch
vmscan-kill-hibernation-specific-reclaim-logic-and-unify-it.patch
vmscan-zone_reclaim-dont-use-insane-swap_cluster_max.patch
vmscan-kill-scswap_cluster_max.patch
vmscan-make-consistent-of-reclaim-bale-out-between-do_try_to_free_page-and-shrink_zone.patch
lib-introduce-strim.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

