From: akpm@linux-foundation.org
Subject: +
 mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries.patch added to -mm tree
Date: Fri, 08 Jul 2016 13:34:21 -0700
Message-ID: <57800e4d.RkCmvOSx2R04lmoX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbcGHUeW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 16:34:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmstat: remove zone and node double accounting by approximating retries
has been added to the -mm tree.  Its filename is
     mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmstat: remove zone and node double accounting by approximating retries

The number of LRU pages, dirty pages and writeback pages must be accounted
for on both zones and nodes because of the reclaim retry logic, compaction
retry logic and highmem calculations all depending on per-zone stats.

Many lowmem allocations are immune from OOM kill due to a check in
__alloc_pages_may_oom for (ac->high_zoneidx < ZONE_NORMAL) since commit
03668b3ceb0c ("oom: avoid oom killer for lowmem allocations"). The exception
is costly high-order allocations or allocations that cannot fail. If the
__alloc_pages_may_oom avoids OOM-kill for low-order lowmem allocations
then it would fall through to __alloc_pages_direct_compact.

This patch will blindly retry reclaim for zone-constrained allocations
in should_reclaim_retry up to MAX_RECLAIM_RETRIES. This is not ideal but
without per-zone stats there are not many alternatives. The impact it that
zone-constrained allocations may delay before considering the OOM killer.

As there is no guarantee enough memory can ever be freed to satisfy
compaction, this patch avoids retrying compaction for zone-contrained
allocations.

In combination, that means that the per-node stats can be used when deciding
whether to continue reclaim using a rough approximation.  While it is
possible this will make the wrong decision on occasion, it will not infinite
loop as the number of reclaim attempts is capped by MAX_RECLAIM_RETRIES.

The final step is calculating the number of dirtyable highmem pages. As
those calculations only care about the global count of file pages in
highmem. This patch uses a global counter used instead of per-zone stats
as it is sufficient.

In combination, this allows the per-zone LRU and dirty state counters to
be removed.

Suggested by: Michal Hocko <mhocko@kernel.org>
Link: http://lkml.kernel.org/r/1467970510-21195-35-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   24 ++++++++++++++++--
 include/linux/mmzone.h    |    4 ---
 include/linux/swap.h      |    1 
 mm/compaction.c           |   20 ++++++++++++++-
 mm/migrate.c              |    2 -
 mm/page-writeback.c       |   13 +++------
 mm/page_alloc.c           |   47 +++++++++++++++++++++++++++++-------
 mm/vmscan.c               |   16 ------------
 mm/vmstat.c               |    3 --
 9 files changed, 84 insertions(+), 46 deletions(-)

diff -puN include/linux/mm_inline.h~mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries
+++ a/include/linux/mm_inline.h
@@ -4,6 +4,26 @@
 #include <linux/huge_mm.h>
 #include <linux/swap.h>
 
+#ifdef CONFIG_HIGHMEM
+extern atomic_t highmem_file_pages;
+
+static inline void acct_highmem_file_pages(int zid, enum lru_list lru,
+							int nr_pages)
+{
+	if (is_highmem_idx(zid) && is_file_lru(lru)) {
+		if (nr_pages > 0)
+			atomic_add(nr_pages, &highmem_file_pages);
+		else
+			atomic_sub(nr_pages, &highmem_file_pages);
+	}
+}
+#else
+static inline void acct_highmem_file_pages(int zid, enum lru_list lru,
+							int nr_pages)
+{
+}
+#endif
+
 /**
  * page_is_file_cache - should the page be on a file LRU or anon LRU?
  * @page: the page to test
@@ -29,9 +49,7 @@ static __always_inline void __update_lru
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
 	__mod_node_page_state(pgdat, NR_LRU_BASE + lru, nr_pages);
-	__mod_zone_page_state(&pgdat->node_zones[zid],
-		NR_ZONE_LRU_BASE + !!is_file_lru(lru),
-		nr_pages);
+	acct_highmem_file_pages(zid, lru, nr_pages);
 }
 
 static __always_inline void update_lru_size(struct lruvec *lruvec,
diff -puN include/linux/mmzone.h~mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries
+++ a/include/linux/mmzone.h
@@ -110,10 +110,6 @@ struct zone_padding {
 enum zone_stat_item {
 	/* First 128 byte cacheline (assuming 64 bit words) */
 	NR_FREE_PAGES,
-	NR_ZONE_LRU_BASE, /* Used only for compaction and reclaim retry */
-	NR_ZONE_LRU_ANON = NR_ZONE_LRU_BASE,
-	NR_ZONE_LRU_FILE,
-	NR_ZONE_WRITE_PENDING,	/* Count of dirty, writeback and unstable pages */
 	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
 	NR_SLAB_RECLAIMABLE,
 	NR_SLAB_UNRECLAIMABLE,
diff -puN include/linux/swap.h~mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries include/linux/swap.h
--- a/include/linux/swap.h~mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries
+++ a/include/linux/swap.h
@@ -307,7 +307,6 @@ extern void lru_cache_add_active_or_unev
 						struct vm_area_struct *vma);
 
 /* linux/mm/vmscan.c */
-extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long pgdat_reclaimable_pages(struct pglist_data *pgdat);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
diff -puN mm/compaction.c~mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries mm/compaction.c
--- a/mm/compaction.c~mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries
+++ a/mm/compaction.c
@@ -1439,6 +1439,11 @@ bool compaction_zonelist_suitable(struct
 {
 	struct zone *zone;
 	struct zoneref *z;
+	pg_data_t *last_pgdat = NULL;
+
+	/* Do not retry compaction for zone-constrained allocations */
+	if (ac->high_zoneidx < ZONE_NORMAL)
+		return false;
 
 	/*
 	 * Make sure at least one zone would pass __compaction_suitable if we continue
@@ -1449,14 +1454,27 @@ bool compaction_zonelist_suitable(struct
 		unsigned long available;
 		enum compact_result compact_result;
 
+		if (last_pgdat == zone->zone_pgdat)
+			continue;
+
+		/*
+		 * This over-estimates the number of pages available for
+		 * reclaim/compaction but walking the LRU would take too
+		 * long. The consequences are that compaction may retry
+		 * longer than it should for a zone-constrained allocation
+		 * request.
+		 */
+		last_pgdat = zone->zone_pgdat;
+		available = pgdat_reclaimable_pages(zone->zone_pgdat) / order;
+
 		/*
 		 * Do not consider all the reclaimable memory because we do not
 		 * want to trash just for a single high order allocation which
 		 * is even not guaranteed to appear even if __compaction_suitable
 		 * is happy about the watermark check.
 		 */
-		available = zone_reclaimable_pages(zone) / order;
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
+		available = min(zone->managed_pages, available);
 		compact_result = __compaction_suitable(zone, order, alloc_flags,
 				ac_classzone_idx(ac), available);
 		if (compact_result != COMPACT_SKIPPED &&
diff -puN mm/migrate.c~mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries mm/migrate.c
--- a/mm/migrate.c~mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries
+++ a/mm/migrate.c
@@ -513,9 +513,7 @@ int migrate_page_move_mapping(struct add
 		}
 		if (dirty && mapping_cap_account_dirty(mapping)) {
 			__dec_node_state(oldzone->zone_pgdat, NR_FILE_DIRTY);
-			__dec_zone_state(oldzone, NR_ZONE_WRITE_PENDING);
 			__inc_node_state(newzone->zone_pgdat, NR_FILE_DIRTY);
-			__dec_zone_state(newzone, NR_ZONE_WRITE_PENDING);
 		}
 	}
 	local_irq_enable();
diff -puN mm/page-writeback.c~mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries mm/page-writeback.c
--- a/mm/page-writeback.c~mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries
+++ a/mm/page-writeback.c
@@ -299,6 +299,9 @@ static unsigned long node_dirtyable_memo
 
 	return nr_pages;
 }
+#ifdef CONFIG_HIGHMEM
+atomic_t highmem_file_pages;
+#endif
 
 static unsigned long highmem_dirtyable_memory(unsigned long total)
 {
@@ -306,18 +309,17 @@ static unsigned long highmem_dirtyable_m
 	int node;
 	unsigned long x = 0;
 	int i;
+	unsigned long dirtyable = atomic_read(&highmem_file_pages);
 
 	for_each_node_state(node, N_HIGH_MEMORY) {
 		for (i = ZONE_NORMAL + 1; i < MAX_NR_ZONES; i++) {
 			struct zone *z;
-			unsigned long dirtyable;
 
 			if (!is_highmem_idx(i))
 				continue;
 
 			z = &NODE_DATA(node)->node_zones[i];
-			dirtyable = zone_page_state(z, NR_FREE_PAGES) +
-				zone_page_state(z, NR_ZONE_LRU_FILE);
+			dirtyable += zone_page_state(z, NR_FREE_PAGES);
 
 			/* watch for underflows */
 			dirtyable -= min(dirtyable, high_wmark_pages(z));
@@ -2460,7 +2462,6 @@ void account_page_dirtied(struct page *p
 
 		mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_DIRTY);
 		__inc_node_page_state(page, NR_FILE_DIRTY);
-		__inc_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 		__inc_node_page_state(page, NR_DIRTIED);
 		__inc_wb_stat(wb, WB_RECLAIMABLE);
 		__inc_wb_stat(wb, WB_DIRTIED);
@@ -2482,7 +2483,6 @@ void account_page_cleaned(struct page *p
 	if (mapping_cap_account_dirty(mapping)) {
 		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_DIRTY);
 		dec_node_page_state(page, NR_FILE_DIRTY);
-		dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 		dec_wb_stat(wb, WB_RECLAIMABLE);
 		task_io_account_cancelled_write(PAGE_SIZE);
 	}
@@ -2739,7 +2739,6 @@ int clear_page_dirty_for_io(struct page
 		if (TestClearPageDirty(page)) {
 			mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_DIRTY);
 			dec_node_page_state(page, NR_FILE_DIRTY);
-			dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 			dec_wb_stat(wb, WB_RECLAIMABLE);
 			ret = 1;
 		}
@@ -2786,7 +2785,6 @@ int test_clear_page_writeback(struct pag
 	if (ret) {
 		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
 		dec_node_page_state(page, NR_WRITEBACK);
-		dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 		inc_node_page_state(page, NR_WRITTEN);
 	}
 	unlock_page_memcg(page);
@@ -2841,7 +2839,6 @@ int __test_set_page_writeback(struct pag
 	if (!ret) {
 		mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
 		inc_node_page_state(page, NR_WRITEBACK);
-		inc_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 	}
 	unlock_page_memcg(page);
 	return ret;
diff -puN mm/page_alloc.c~mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries mm/page_alloc.c
--- a/mm/page_alloc.c~mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries
+++ a/mm/page_alloc.c
@@ -3402,6 +3402,7 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 {
 	struct zone *zone;
 	struct zoneref *z;
+	pg_data_t *current_pgdat = NULL;
 
 	/*
 	 * Make sure we converge to OOM if we cannot make any progress
@@ -3411,6 +3412,15 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 		return false;
 
 	/*
+	 * Blindly retry lowmem allocation requests that are often ignored by
+	 * the OOM killer up to MAX_RECLAIM_RETRIES as we not have a reliable
+	 * and fast means of calculating reclaimable, dirty and writeback pages
+	 * in eligible zones.
+	 */
+	if (ac->high_zoneidx < ZONE_NORMAL)
+		goto out;
+
+	/*
 	 * Keep reclaiming pages while there is a chance this will lead somewhere.
 	 * If none of the target zones can satisfy our allocation request even
 	 * if all reclaimable pages are considered then we are screwed and have
@@ -3420,18 +3430,38 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 					ac->nodemask) {
 		unsigned long available;
 		unsigned long reclaimable;
+		int zid;
+
+		if (current_pgdat == zone->zone_pgdat)
+			continue;
 
-		available = reclaimable = zone_reclaimable_pages(zone);
+		current_pgdat = zone->zone_pgdat;
+		available = reclaimable = pgdat_reclaimable_pages(current_pgdat);
 		available -= DIV_ROUND_UP(no_progress_loops * available,
 					  MAX_RECLAIM_RETRIES);
-		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
+
+		/* Account for all free pages on eligible zones */
+		for (zid = 0; zid <= zone_idx(zone); zid++) {
+			struct zone *acct_zone = &current_pgdat->node_zones[zid];
+
+			available += zone_page_state_snapshot(acct_zone, NR_FREE_PAGES);
+		}
 
 		/*
 		 * Would the allocation succeed if we reclaimed the whole
-		 * available?
+		 * available? This is approximate because there is no
+		 * accurate count of reclaimable pages per zone.
 		 */
-		if (__zone_watermark_ok(zone, order, min_wmark_pages(zone),
-				ac_classzone_idx(ac), alloc_flags, available)) {
+		for (zid = 0; zid <= zone_idx(zone); zid++) {
+			struct zone *check_zone = &current_pgdat->node_zones[zid];
+			unsigned long estimate;
+
+			estimate = min(check_zone->managed_pages, available);
+			if (!__zone_watermark_ok(check_zone, order,
+					min_wmark_pages(check_zone), ac_classzone_idx(ac),
+					alloc_flags, estimate))
+				continue;
+
 			/*
 			 * If we didn't make any progress and have a lot of
 			 * dirty + writeback pages then we should wait for
@@ -3441,15 +3471,16 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 			if (!did_some_progress) {
 				unsigned long write_pending;
 
-				write_pending = zone_page_state_snapshot(zone,
-							NR_ZONE_WRITE_PENDING);
+				write_pending =
+					node_page_state(current_pgdat, NR_WRITEBACK) +
+					node_page_state(current_pgdat, NR_FILE_DIRTY);
 
 				if (2 * write_pending > reclaimable) {
 					congestion_wait(BLK_RW_ASYNC, HZ/10);
 					return true;
 				}
 			}
-
+out:
 			/*
 			 * Memory allocation/reclaim might be called from a WQ
 			 * context and the current implementation of the WQ
diff -puN mm/vmscan.c~mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries mm/vmscan.c
--- a/mm/vmscan.c~mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries
+++ a/mm/vmscan.c
@@ -194,22 +194,6 @@ static bool sane_reclaim(struct scan_con
 }
 #endif
 
-/*
- * This misses isolated pages which are not accounted for to save counters.
- * As the data only determines if reclaim or compaction continues, it is
- * not expected that isolated pages will be a dominating factor.
- */
-unsigned long zone_reclaimable_pages(struct zone *zone)
-{
-	unsigned long nr;
-
-	nr = zone_page_state_snapshot(zone, NR_ZONE_LRU_FILE);
-	if (get_nr_swap_pages() > 0)
-		nr += zone_page_state_snapshot(zone, NR_ZONE_LRU_ANON);
-
-	return nr;
-}
-
 unsigned long pgdat_reclaimable_pages(struct pglist_data *pgdat)
 {
 	unsigned long nr;
diff -puN mm/vmstat.c~mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries
+++ a/mm/vmstat.c
@@ -921,9 +921,6 @@ int fragmentation_index(struct zone *zon
 const char * const vmstat_text[] = {
 	/* enum zone_stat_item countes */
 	"nr_free_pages",
-	"nr_zone_anon_lru",
-	"nr_zone_file_lru",
-	"nr_zone_write_pending",
 	"nr_mlock",
 	"nr_slab_reclaimable",
 	"nr_slab_unreclaimable",
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-meminit-always-return-a-valid-node-from-early_pfn_to_nid.patch
mm-meminit-ensure-node-is-online-before-checking-whether-pages-are-uninitialised.patch
mm-meminit-remove-early_page_nid_uninitialised.patch
mm-vmstat-add-infrastructure-for-per-node-vmstats.patch
mm-vmscan-move-lru_lock-to-the-node.patch
mm-vmscan-move-lru-lists-to-node.patch
mm-mmzone-clarify-the-usage-of-zone-padding.patch
mm-vmscan-begin-reclaiming-pages-on-a-per-node-basis.patch
mm-vmscan-have-kswapd-only-scan-based-on-the-highest-requested-zone.patch
mm-vmscan-make-kswapd-reclaim-in-terms-of-nodes.patch
mm-vmscan-remove-balance-gap.patch
mm-vmscan-simplify-the-logic-deciding-whether-kswapd-sleeps.patch
mm-vmscan-by-default-have-direct-reclaim-only-shrink-once-per-node.patch
mm-vmscan-remove-duplicate-logic-clearing-node-congestion-and-dirty-state.patch
mm-vmscan-do-not-reclaim-from-kswapd-if-there-is-any-eligible-zone.patch
mm-vmscan-make-shrink_node-decisions-more-node-centric.patch
mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes.patch
mm-workingset-make-working-set-detection-node-aware.patch
mm-page_alloc-consider-dirtyable-memory-in-terms-of-nodes.patch
mm-move-page-mapped-accounting-to-the-node.patch
mm-rename-nr_anon_pages-to-nr_anon_mapped.patch
mm-move-most-file-based-accounting-to-the-node.patch
mm-move-vmscan-writes-and-file-write-accounting-to-the-node.patch
mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone.patch
mm-page_alloc-wake-kswapd-based-on-the-highest-eligible-zone.patch
mm-convert-zone_reclaim-to-node_reclaim.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-shrink_node.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-compaction_ready.patch
mm-vmscan-avoid-passing-in-remaining-unnecessarily-to-prepare_kswapd_sleep.patch
mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit.patch
mm-vmscan-add-classzone-information-to-tracepoints.patch
mm-page_alloc-remove-fair-zone-allocation-policy.patch
mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch
mm-vmstat-replace-__count_zone_vm_events-with-a-zone-id-equivalent.patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim.patch
mm-vmstat-print-node-based-stats-in-zoneinfo-file.patch
mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries.patch

