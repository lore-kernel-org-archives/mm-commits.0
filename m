From: akpm@linux-foundation.org
Subject: + vmscan-separate-scswap_cluster_max-and-scnr_max_reclaim.patch added to -mm tree
Date: Thu, 12 Nov 2009 13:50:33 -0800
Message-ID: <200911122150.nACLoYRB019575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754283AbZKLVvY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 16:51:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     vmscan: separate sc.swap_cluster_max and sc.nr_max_reclaim
has been added to the -mm tree.  Its filename is
     vmscan-separate-scswap_cluster_max-and-scnr_max_reclaim.patch

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
 
@@ -1599,6 +1602,7 @@ static void shrink_zone(int priority, st
 	enum lru_list l;
 	unsigned long nr_reclaimed = sc->nr_reclaimed;
 	unsigned long swap_cluster_max = sc->swap_cluster_max;
+	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 	int noswap = 0;
 
@@ -1643,8 +1647,7 @@ static void shrink_zone(int priority, st
 		 * with multiple processes reclaiming pages, the total
 		 * freeing target can get unreasonably large.
 		 */
-		if (nr_reclaimed > swap_cluster_max &&
-			priority < DEF_PRIORITY && !current_is_kswapd())
+		if (nr_reclaimed > nr_to_reclaim && priority < DEF_PRIORITY)
 			break;
 	}
 
@@ -1742,6 +1745,7 @@ static unsigned long do_try_to_free_page
 	struct zoneref *z;
 	struct zone *zone;
 	enum zone_type high_zoneidx = gfp_zone(sc->gfp_mask);
+	unsigned long writeback_threshold;
 
 	delayacct_freepages_start();
 
@@ -1777,7 +1781,7 @@ static unsigned long do_try_to_free_page
 			}
 		}
 		total_scanned += sc->nr_scanned;
-		if (sc->nr_reclaimed >= sc->swap_cluster_max) {
+		if (sc->nr_reclaimed >= sc->nr_to_reclaim) {
 			ret = sc->nr_reclaimed;
 			goto out;
 		}
@@ -1789,8 +1793,8 @@ static unsigned long do_try_to_free_page
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
@@ -1836,6 +1840,7 @@ unsigned long try_to_free_pages(struct z
 		.gfp_mask = gfp_mask,
 		.may_writepage = !laptop_mode,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
+		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.may_unmap = 1,
 		.may_swap = 1,
 		.swappiness = vm_swappiness,
@@ -1894,6 +1899,7 @@ unsigned long try_to_free_mem_cgroup_pag
 		.may_unmap = 1,
 		.may_swap = !noswap,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
+		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.swappiness = swappiness,
 		.order = 0,
 		.mem_cgroup = mem_cont,
@@ -1959,6 +1965,11 @@ static unsigned long balance_pgdat(pg_da
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
@@ -2624,7 +2635,9 @@ static int __zone_reclaim(struct zone *z
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

