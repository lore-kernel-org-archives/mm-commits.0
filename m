From: akpm@linux-foundation.org
Subject: + memcg-fix-get_scan_count-for-small-targets.patch added to -mm tree
Date: Wed, 04 May 2011 14:16:13 -0700
Message-ID: <201105042116.p44LGDfJ014753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751961Ab1EDVRG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 May 2011 17:17:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, nishimura@mxp.nes.nec.co.jp, yinghan@google.com


The patch titled
     memcg: fix get_scan_count() for small targets
has been added to the -mm tree.  Its filename is
     memcg-fix-get_scan_count-for-small-targets.patch

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
Subject: memcg: fix get_scan_count() for small targets
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

During memory reclaim we determine the number of pages to be scanned per
zone as

	(anon + file) >> priority.
Assume
	scan = (anon + file) >> priority.

If scan < SWAP_CLUSTER_MAX, the scan will be skipped for this time and
priority gets higher.  This has some problems.

  1. This increases priority as 1 without any scan.
     To do scan in this priority, amount of pages should be larger than 512M.
     If pages>>priority < SWAP_CLUSTER_MAX, it's recorded and scan will be
     batched, later. (But we lose 1 priority.)
     If memory size is below 16M, pages >> priority is 0 and no scan in
     DEF_PRIORITY forever.

  2. If zone->all_unreclaimabe==true, it's scanned only when priority==0.
     So, x86's ZONE_DMA will never be recoverred until the user of pages
     frees memory by itself.

  3. With memcg, the limit of memory can be small. When using small memcg,
     it gets priority < DEF_PRIORITY-2 very easily and need to call
     wait_iff_congested().
     For doing scan before priorty=9, 64MB of memory should be used.

Then, this patch tries to scan SWAP_CLUSTER_MAX of pages in force...when

  1. the target is enough small.
  2. it's kswapd or memcg reclaim.

Then we can avoid rapid priority drop and may be able to recover
all_unreclaimable in a small zones.  And this patch removes nr_saved_scan.
 This will allow scanning in this priority even when pages >> priority is
very small.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Ying Han <yinghan@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 ---
 mm/page_alloc.c        |    4 --
 mm/vmscan.c            |   60 +++++++++++++++++++++------------------
 3 files changed, 34 insertions(+), 35 deletions(-)

diff -puN include/linux/mmzone.h~memcg-fix-get_scan_count-for-small-targets include/linux/mmzone.h
--- a/include/linux/mmzone.h~memcg-fix-get_scan_count-for-small-targets
+++ a/include/linux/mmzone.h
@@ -273,11 +273,6 @@ struct zone_reclaim_stat {
 	 */
 	unsigned long		recent_rotated[2];
 	unsigned long		recent_scanned[2];
-
-	/*
-	 * accumulated for batching
-	 */
-	unsigned long		nr_saved_scan[NR_LRU_LISTS];
 };
 
 struct zone {
diff -puN mm/page_alloc.c~memcg-fix-get_scan_count-for-small-targets mm/page_alloc.c
--- a/mm/page_alloc.c~memcg-fix-get_scan_count-for-small-targets
+++ a/mm/page_alloc.c
@@ -4334,10 +4334,8 @@ static void __paginginit free_area_init_
 		zone->zone_pgdat = pgdat;
 
 		zone_pcp_init(zone);
-		for_each_lru(l) {
+		for_each_lru(l)
 			INIT_LIST_HEAD(&zone->lru[l].list);
-			zone->reclaim_stat.nr_saved_scan[l] = 0;
-		}
 		zone->reclaim_stat.recent_rotated[0] = 0;
 		zone->reclaim_stat.recent_rotated[1] = 0;
 		zone->reclaim_stat.recent_scanned[0] = 0;
diff -puN mm/vmscan.c~memcg-fix-get_scan_count-for-small-targets mm/vmscan.c
--- a/mm/vmscan.c~memcg-fix-get_scan_count-for-small-targets
+++ a/mm/vmscan.c
@@ -1707,26 +1707,6 @@ static unsigned long shrink_list(enum lr
 }
 
 /*
- * Smallish @nr_to_scan's are deposited in @nr_saved_scan,
- * until we collected @swap_cluster_max pages to scan.
- */
-static unsigned long nr_scan_try_batch(unsigned long nr_to_scan,
-				       unsigned long *nr_saved_scan)
-{
-	unsigned long nr;
-
-	*nr_saved_scan += nr_to_scan;
-	nr = *nr_saved_scan;
-
-	if (nr >= SWAP_CLUSTER_MAX)
-		*nr_saved_scan = 0;
-	else
-		nr = 0;
-
-	return nr;
-}
-
-/*
  * Determine how aggressively the anon and file LRU lists should be
  * scanned.  The relative value of each set of LRU lists is determined
  * by looking at the fraction of the pages scanned we did rotate back
@@ -1744,6 +1724,22 @@ static void get_scan_count(struct zone *
 	u64 fraction[2], denominator;
 	enum lru_list l;
 	int noswap = 0;
+	int force_scan = 0;
+
+
+	anon  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_ANON) +
+		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
+	file  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_FILE) +
+		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_FILE);
+
+	if (((anon + file) >> priority) < SWAP_CLUSTER_MAX) {
+		/* kswapd does zone balancing and need to scan this zone */
+		if (scanning_global_lru(sc) && current_is_kswapd())
+			force_scan = 1;
+		/* memcg may have small limit and need to avoid priority drop */
+		if (!scanning_global_lru(sc))
+			force_scan = 1;
+	}
 
 	/* If we have no swap space, do not bother scanning anon pages. */
 	if (!sc->may_swap || (nr_swap_pages <= 0)) {
@@ -1754,11 +1750,6 @@ static void get_scan_count(struct zone *
 		goto out;
 	}
 
-	anon  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_ANON) +
-		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
-	file  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_FILE) +
-		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_FILE);
-
 	if (scanning_global_lru(sc)) {
 		free  = zone_page_state(zone, NR_FREE_PAGES);
 		/* If we have very few page cache pages,
@@ -1825,8 +1816,23 @@ out:
 			scan >>= priority;
 			scan = div64_u64(scan * fraction[file], denominator);
 		}
-		nr[l] = nr_scan_try_batch(scan,
-					  &reclaim_stat->nr_saved_scan[l]);
+
+		/*
+		 * If zone is small or memcg is small, nr[l] can be 0.
+		 * This results no-scan on this priority and priority drop down.
+		 * For global direct reclaim, it can visit next zone and tend
+		 * not to have problems. For global kswapd, it's for zone
+		 * balancing and it need to scan a small amounts. When using
+		 * memcg, priority drop can cause big latency. So, it's better
+		 * to scan small amount. See may_noscan above.
+		 */
+		if (!scan && force_scan) {
+			if (file)
+				scan = SWAP_CLUSTER_MAX;
+			else if (!noswap)
+				scan = SWAP_CLUSTER_MAX;
+		}
+		nr[l] = scan;
 	}
 }
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-remove-unused-zone_idx-variable-from-set_migratetype_isolate.patch
mm-increase-reclaim_distance-to-30.patch
mm-introduce-wait_on_page_locked_killable.patch
x86mm-make-pagefault-killable.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
mm-convert-vma-vm_flags-to-64-bit.patch
mm-add-__nocast-attribute-to-vm_flags.patch
fremap-convert-vm_flags-to-unsigned-long-long.patch
procfs-convert-vm_flags-to-unsigned-long-long.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch
mm-mmu_gather-rework.patch
powerpc-mmu_gather-rework.patch
sparc-mmu_gather-rework.patch
s390-mmu_gather-rework.patch
arm-mmu_gather-rework.patch
sh-mmu_gather-rework.patch
ia64-mmu_gather-rework.patch
um-mmu_gather-rework.patch
mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage.patch
mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code.patch
mm-extended-batches-for-generic-mmu_gather.patch
lockdep-mutex-provide-mutex_lock_nest_lock.patch
mm-remove-i_mmap_lock-lockbreak.patch
mm-convert-i_mmap_lock-to-a-mutex.patch
mm-revert-page_lock_anon_vma-lock-annotation.patch
mm-improve-page_lock_anon_vma-comment.patch
mm-use-refcounts-for-page_lock_anon_vma.patch
mm-convert-anon_vma-lock-to-a-mutex.patch
mm-optimize-page_lock_anon_vma-fast-path.patch
mem-hotplug-call-isolate_lru_page-with-elevated-refcount.patch
mem-hwpoison-fix-page-refcount-around-isolate_lru_page.patch
mm-strictly-require-elevated-page-refcount-in-isolate_lru_page.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
mm-fail-gfp_dma-allocations-when-zone_dma-is-not-configured.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim-v2.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
memcg-remove-pointless-next_mz-nullification-in-mem_cgroup_soft_limit_reclaim.patch
memcg-mark-init_section_page_cgroup-properly.patch
memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length.patch
memcg-move-page-freeing-code-out-of-lock.patch
maintainers-add-mm-page_cgroupc-into-memcg-subsystem.patch
memcg-reclaim-memory-from-nodes-in-round-robin.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
memcg-fix-get_scan_count-for-small-targets.patch

