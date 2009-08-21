From: akpm@linux-foundation.org
Subject: + mm-do-batched-scans-for-mem_cgroup.patch added to -mm tree
Date: Fri, 21 Aug 2009 16:52:26 -0700
Message-ID: <200908212352.n7LNqRh1007046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752616AbZHUXwp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Aug 2009 19:52:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: do batched scans for mem_cgroup
has been added to the -mm tree.  Its filename is
     mm-do-batched-scans-for-mem_cgroup.patch

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
Subject: mm: do batched scans for mem_cgroup
From: Wu Fengguang <fengguang.wu@intel.com>

For mem_cgroup, shrink_zone() may call shrink_list() with nr_to_scan=1, in
which case shrink_list() _still_ calls isolate_pages() with the much
larger SWAP_CLUSTER_MAX.  It effectively scales up the inactive list scan
rate by up to 32 times.

For example, with 16k inactive pages and DEF_PRIORITY=12, (16k >> 12)=4. 
So when shrink_zone() expects to scan 4 pages in the active/inactive list,
the active list will be scanned 4 pages, while the inactive list will be
(over) scanned SWAP_CLUSTER_MAX=32 pages in effect.  And that could break
the balance between the two lists.

It can further impact the scan of anon active list, due to the anon
active/inactive ratio rebalance logic in balance_pgdat()/shrink_zone():

inactive anon list over scanned => inactive_anon_is_low() == TRUE
                                => shrink_active_list()
                                => active anon list over scanned

So the end result may be

- anon inactive  => over scanned
- anon active    => over scanned (maybe not as much)
- file inactive  => over scanned
- file active    => under scanned (relatively)

The accesses to nr_saved_scan are not lock protected and so not 100%
accurate, however we can tolerate small errors and the resulted small
imbalanced scan rates between zones.

Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 +++++-
 mm/page_alloc.c        |    2 +-
 mm/vmscan.c            |   20 +++++++++++---------
 3 files changed, 17 insertions(+), 11 deletions(-)

diff -puN include/linux/mmzone.h~mm-do-batched-scans-for-mem_cgroup include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-do-batched-scans-for-mem_cgroup
+++ a/include/linux/mmzone.h
@@ -273,6 +273,11 @@ struct zone_reclaim_stat {
 	 */
 	unsigned long		recent_rotated[2];
 	unsigned long		recent_scanned[2];
+
+	/*
+	 * accumulated for batching
+	 */
+	unsigned long		nr_saved_scan[NR_LRU_LISTS];
 };
 
 struct zone {
@@ -327,7 +332,6 @@ struct zone {
 	spinlock_t		lru_lock;	
 	struct zone_lru {
 		struct list_head list;
-		unsigned long nr_saved_scan;	/* accumulated for batching */
 	} lru[NR_LRU_LISTS];
 
 	struct zone_reclaim_stat reclaim_stat;
diff -puN mm/page_alloc.c~mm-do-batched-scans-for-mem_cgroup mm/page_alloc.c
--- a/mm/page_alloc.c~mm-do-batched-scans-for-mem_cgroup
+++ a/mm/page_alloc.c
@@ -3830,7 +3830,7 @@ static void __paginginit free_area_init_
 		zone_pcp_init(zone);
 		for_each_lru(l) {
 			INIT_LIST_HEAD(&zone->lru[l].list);
-			zone->lru[l].nr_saved_scan = 0;
+			zone->reclaim_stat.nr_saved_scan[l] = 0;
 		}
 		zone->reclaim_stat.recent_rotated[0] = 0;
 		zone->reclaim_stat.recent_rotated[1] = 0;
diff -puN mm/vmscan.c~mm-do-batched-scans-for-mem_cgroup mm/vmscan.c
--- a/mm/vmscan.c~mm-do-batched-scans-for-mem_cgroup
+++ a/mm/vmscan.c
@@ -1586,6 +1586,7 @@ static void shrink_zone(int priority, st
 	enum lru_list l;
 	unsigned long nr_reclaimed = sc->nr_reclaimed;
 	unsigned long swap_cluster_max = sc->swap_cluster_max;
+	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 	int noswap = 0;
 
 	/* If we have no swap space, do not bother scanning anon pages. */
@@ -1605,12 +1606,9 @@ static void shrink_zone(int priority, st
 			scan >>= priority;
 			scan = (scan * percent[file]) / 100;
 		}
-		if (scanning_global_lru(sc))
-			nr[l] = nr_scan_try_batch(scan,
-						  &zone->lru[l].nr_saved_scan,
-						  swap_cluster_max);
-		else
-			nr[l] = scan;
+		nr[l] = nr_scan_try_batch(scan,
+					  &reclaim_stat->nr_saved_scan[l],
+					  swap_cluster_max);
 	}
 
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
@@ -2220,6 +2218,7 @@ static void shrink_all_zones(unsigned lo
 {
 	struct zone *zone;
 	unsigned long nr_reclaimed = 0;
+	struct zone_reclaim_stat *reclaim_stat;
 
 	for_each_populated_zone(zone) {
 		enum lru_list l;
@@ -2236,11 +2235,14 @@ static void shrink_all_zones(unsigned lo
 						l == LRU_ACTIVE_FILE))
 				continue;
 
-			zone->lru[l].nr_saved_scan += (lru_pages >> prio) + 1;
-			if (zone->lru[l].nr_saved_scan >= nr_pages || pass > 3) {
+			reclaim_stat = get_reclaim_stat(zone, sc);
+			reclaim_stat->nr_saved_scan[l] +=
+						(lru_pages >> prio) + 1;
+			if (reclaim_stat->nr_saved_scan[l]
+						>= nr_pages || pass > 3) {
 				unsigned long nr_to_scan;
 
-				zone->lru[l].nr_saved_scan = 0;
+				reclaim_stat->nr_saved_scan[l] = 0;
 				nr_to_scan = min(nr_pages, lru_pages);
 				nr_reclaimed += shrink_list(l, nr_to_scan, zone,
 								sc, prio);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
mm-fix-for-infinite-churning-of-mlocked-pages.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
mm-clean-up-page_remove_rmap.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch
mm-vmstat-add-isolate-pages.patch
mm-vmstat-add-isolate-pages-fix.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
mm-balance_dirty_pages-reduce-calls-to-global_page_state-to-reduce-cache-references.patch
mm-do-batched-scans-for-mem_cgroup.patch
documentation-vm-gitignore-add-page-types.patch

