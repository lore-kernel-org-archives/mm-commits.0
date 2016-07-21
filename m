From: akpm@linux-foundation.org
Subject: + mm-remove-reclaim-and-compaction-retry-approximations.patch
 added to -mm tree
Date: Thu, 21 Jul 2016 14:09:26 -0700
Message-ID: <57913a06.lg8eWx1/7xGKjn7Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbcGUVJ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jul 2016 17:09:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, mhocko@suse.cz, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove reclaim and compaction retry approximations
has been added to the -mm tree.  Its filename is
     mm-remove-reclaim-and-compaction-retry-approximations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-reclaim-and-compaction-retry-approximations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-reclaim-and-compaction-retry-approximations.patch

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
Subject: mm: remove reclaim and compaction retry approximations

If per-zone LRU accounting is available then there is no point
approximating whether reclaim and compaction should retry based on pgdat
statistics.  This is effectively a revert of "mm, vmstat: remove zone and
node double accounting by approximating retries" with the difference that
inactive/active stats are still available.  This preserves the history of
why the approximation was retried and why it had to be reverted to handle
OOM kills on 32-bit systems.

Link: http://lkml.kernel.org/r/1469110261-7365-4-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 
 include/linux/swap.h   |    1 
 mm/compaction.c        |   20 ---------------
 mm/migrate.c           |    2 +
 mm/page-writeback.c    |    5 +++
 mm/page_alloc.c        |   49 +++++++--------------------------------
 mm/vmscan.c            |   18 ++++++++++++++
 mm/vmstat.c            |    1 
 8 files changed, 39 insertions(+), 58 deletions(-)

diff -puN include/linux/mmzone.h~mm-remove-reclaim-and-compaction-retry-approximations include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-remove-reclaim-and-compaction-retry-approximations
+++ a/include/linux/mmzone.h
@@ -116,6 +116,7 @@ enum zone_stat_item {
 	NR_ZONE_INACTIVE_FILE,
 	NR_ZONE_ACTIVE_FILE,
 	NR_ZONE_UNEVICTABLE,
+	NR_ZONE_WRITE_PENDING,	/* Count of dirty, writeback and unstable pages */
 	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
 	NR_SLAB_RECLAIMABLE,
 	NR_SLAB_UNRECLAIMABLE,
diff -puN include/linux/swap.h~mm-remove-reclaim-and-compaction-retry-approximations include/linux/swap.h
--- a/include/linux/swap.h~mm-remove-reclaim-and-compaction-retry-approximations
+++ a/include/linux/swap.h
@@ -307,6 +307,7 @@ extern void lru_cache_add_active_or_unev
 						struct vm_area_struct *vma);
 
 /* linux/mm/vmscan.c */
+extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long pgdat_reclaimable_pages(struct pglist_data *pgdat);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
diff -puN mm/compaction.c~mm-remove-reclaim-and-compaction-retry-approximations mm/compaction.c
--- a/mm/compaction.c~mm-remove-reclaim-and-compaction-retry-approximations
+++ a/mm/compaction.c
@@ -1438,11 +1438,6 @@ bool compaction_zonelist_suitable(struct
 {
 	struct zone *zone;
 	struct zoneref *z;
-	pg_data_t *last_pgdat = NULL;
-
-	/* Do not retry compaction for zone-constrained allocations */
-	if (ac->high_zoneidx < ZONE_NORMAL)
-		return false;
 
 	/*
 	 * Make sure at least one zone would pass __compaction_suitable if we continue
@@ -1453,27 +1448,14 @@ bool compaction_zonelist_suitable(struct
 		unsigned long available;
 		enum compact_result compact_result;
 
-		if (last_pgdat == zone->zone_pgdat)
-			continue;
-
-		/*
-		 * This over-estimates the number of pages available for
-		 * reclaim/compaction but walking the LRU would take too
-		 * long. The consequences are that compaction may retry
-		 * longer than it should for a zone-constrained allocation
-		 * request.
-		 */
-		last_pgdat = zone->zone_pgdat;
-		available = pgdat_reclaimable_pages(zone->zone_pgdat) / order;
-
 		/*
 		 * Do not consider all the reclaimable memory because we do not
 		 * want to trash just for a single high order allocation which
 		 * is even not guaranteed to appear even if __compaction_suitable
 		 * is happy about the watermark check.
 		 */
+		available = zone_reclaimable_pages(zone) / order;
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
-		available = min(zone->managed_pages, available);
 		compact_result = __compaction_suitable(zone, order, alloc_flags,
 				ac_classzone_idx(ac), available);
 		if (compact_result != COMPACT_SKIPPED &&
diff -puN mm/migrate.c~mm-remove-reclaim-and-compaction-retry-approximations mm/migrate.c
--- a/mm/migrate.c~mm-remove-reclaim-and-compaction-retry-approximations
+++ a/mm/migrate.c
@@ -513,7 +513,9 @@ int migrate_page_move_mapping(struct add
 		}
 		if (dirty && mapping_cap_account_dirty(mapping)) {
 			__dec_node_state(oldzone->zone_pgdat, NR_FILE_DIRTY);
+			__dec_zone_state(oldzone, NR_ZONE_WRITE_PENDING);
 			__inc_node_state(newzone->zone_pgdat, NR_FILE_DIRTY);
+			__inc_zone_state(newzone, NR_ZONE_WRITE_PENDING);
 		}
 	}
 	local_irq_enable();
diff -puN mm/page-writeback.c~mm-remove-reclaim-and-compaction-retry-approximations mm/page-writeback.c
--- a/mm/page-writeback.c~mm-remove-reclaim-and-compaction-retry-approximations
+++ a/mm/page-writeback.c
@@ -2462,6 +2462,7 @@ void account_page_dirtied(struct page *p
 
 		mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_DIRTY);
 		__inc_node_page_state(page, NR_FILE_DIRTY);
+		__inc_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 		__inc_node_page_state(page, NR_DIRTIED);
 		__inc_wb_stat(wb, WB_RECLAIMABLE);
 		__inc_wb_stat(wb, WB_DIRTIED);
@@ -2483,6 +2484,7 @@ void account_page_cleaned(struct page *p
 	if (mapping_cap_account_dirty(mapping)) {
 		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_DIRTY);
 		dec_node_page_state(page, NR_FILE_DIRTY);
+		dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 		dec_wb_stat(wb, WB_RECLAIMABLE);
 		task_io_account_cancelled_write(PAGE_SIZE);
 	}
@@ -2739,6 +2741,7 @@ int clear_page_dirty_for_io(struct page
 		if (TestClearPageDirty(page)) {
 			mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_DIRTY);
 			dec_node_page_state(page, NR_FILE_DIRTY);
+			dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 			dec_wb_stat(wb, WB_RECLAIMABLE);
 			ret = 1;
 		}
@@ -2785,6 +2788,7 @@ int test_clear_page_writeback(struct pag
 	if (ret) {
 		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
 		dec_node_page_state(page, NR_WRITEBACK);
+		dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 		inc_node_page_state(page, NR_WRITTEN);
 	}
 	unlock_page_memcg(page);
@@ -2839,6 +2843,7 @@ int __test_set_page_writeback(struct pag
 	if (!ret) {
 		mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
 		inc_node_page_state(page, NR_WRITEBACK);
+		inc_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 	}
 	unlock_page_memcg(page);
 	return ret;
diff -puN mm/page_alloc.c~mm-remove-reclaim-and-compaction-retry-approximations mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-reclaim-and-compaction-retry-approximations
+++ a/mm/page_alloc.c
@@ -3402,7 +3402,6 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 {
 	struct zone *zone;
 	struct zoneref *z;
-	pg_data_t *current_pgdat = NULL;
 
 	/*
 	 * Make sure we converge to OOM if we cannot make any progress
@@ -3412,15 +3411,6 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 		return false;
 
 	/*
-	 * Blindly retry lowmem allocation requests that are often ignored by
-	 * the OOM killer up to MAX_RECLAIM_RETRIES as we not have a reliable
-	 * and fast means of calculating reclaimable, dirty and writeback pages
-	 * in eligible zones.
-	 */
-	if (ac->high_zoneidx < ZONE_NORMAL)
-		goto out;
-
-	/*
 	 * Keep reclaiming pages while there is a chance this will lead somewhere.
 	 * If none of the target zones can satisfy our allocation request even
 	 * if all reclaimable pages are considered then we are screwed and have
@@ -3430,38 +3420,18 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 					ac->nodemask) {
 		unsigned long available;
 		unsigned long reclaimable;
-		int zid;
-
-		if (current_pgdat == zone->zone_pgdat)
-			continue;
 
-		current_pgdat = zone->zone_pgdat;
-		available = reclaimable = pgdat_reclaimable_pages(current_pgdat);
+		available = reclaimable = zone_reclaimable_pages(zone);
 		available -= DIV_ROUND_UP(no_progress_loops * available,
 					  MAX_RECLAIM_RETRIES);
-
-		/* Account for all free pages on eligible zones */
-		for (zid = 0; zid <= zone_idx(zone); zid++) {
-			struct zone *acct_zone = &current_pgdat->node_zones[zid];
-
-			available += zone_page_state_snapshot(acct_zone, NR_FREE_PAGES);
-		}
+		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
 
 		/*
 		 * Would the allocation succeed if we reclaimed the whole
-		 * available? This is approximate because there is no
-		 * accurate count of reclaimable pages per zone.
+		 * available?
 		 */
-		for (zid = 0; zid <= zone_idx(zone); zid++) {
-			struct zone *check_zone = &current_pgdat->node_zones[zid];
-			unsigned long estimate;
-
-			estimate = min(check_zone->managed_pages, available);
-			if (!__zone_watermark_ok(check_zone, order,
-					min_wmark_pages(check_zone), ac_classzone_idx(ac),
-					alloc_flags, estimate))
-				continue;
-
+		if (__zone_watermark_ok(zone, order, min_wmark_pages(zone),
+				ac_classzone_idx(ac), alloc_flags, available)) {
 			/*
 			 * If we didn't make any progress and have a lot of
 			 * dirty + writeback pages then we should wait for
@@ -3471,16 +3441,15 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 			if (!did_some_progress) {
 				unsigned long write_pending;
 
-				write_pending =
-					node_page_state(current_pgdat, NR_WRITEBACK) +
-					node_page_state(current_pgdat, NR_FILE_DIRTY);
+				write_pending = zone_page_state_snapshot(zone,
+							NR_ZONE_WRITE_PENDING);
 
 				if (2 * write_pending > reclaimable) {
 					congestion_wait(BLK_RW_ASYNC, HZ/10);
 					return true;
 				}
 			}
-out:
+
 			/*
 			 * Memory allocation/reclaim might be called from a WQ
 			 * context and the current implementation of the WQ
@@ -4361,6 +4330,7 @@ void show_free_areas(unsigned int filter
 			" active_file:%lukB"
 			" inactive_file:%lukB"
 			" unevictable:%lukB"
+			" writepending:%lukB"
 			" present:%lukB"
 			" managed:%lukB"
 			" mlocked:%lukB"
@@ -4383,6 +4353,7 @@ void show_free_areas(unsigned int filter
 			K(zone_page_state(zone, NR_ZONE_ACTIVE_FILE)),
 			K(zone_page_state(zone, NR_ZONE_INACTIVE_FILE)),
 			K(zone_page_state(zone, NR_ZONE_UNEVICTABLE)),
+			K(zone_page_state(zone, NR_ZONE_WRITE_PENDING)),
 			K(zone->present_pages),
 			K(zone->managed_pages),
 			K(zone_page_state(zone, NR_MLOCK)),
diff -puN mm/vmscan.c~mm-remove-reclaim-and-compaction-retry-approximations mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-reclaim-and-compaction-retry-approximations
+++ a/mm/vmscan.c
@@ -194,6 +194,24 @@ static bool sane_reclaim(struct scan_con
 }
 #endif
 
+/*
+ * This misses isolated pages which are not accounted for to save counters.
+ * As the data only determines if reclaim or compaction continues, it is
+ * not expected that isolated pages will be a dominating factor.
+ */
+unsigned long zone_reclaimable_pages(struct zone *zone)
+{
+	unsigned long nr;
+
+	nr = zone_page_state_snapshot(zone, NR_ZONE_INACTIVE_FILE) +
+		zone_page_state_snapshot(zone, NR_ZONE_ACTIVE_FILE);
+	if (get_nr_swap_pages() > 0)
+		nr += zone_page_state_snapshot(zone, NR_ZONE_INACTIVE_ANON) +
+			zone_page_state_snapshot(zone, NR_ZONE_ACTIVE_ANON);
+
+	return nr;
+}
+
 unsigned long pgdat_reclaimable_pages(struct pglist_data *pgdat)
 {
 	unsigned long nr;
diff -puN mm/vmstat.c~mm-remove-reclaim-and-compaction-retry-approximations mm/vmstat.c
--- a/mm/vmstat.c~mm-remove-reclaim-and-compaction-retry-approximations
+++ a/mm/vmstat.c
@@ -926,6 +926,7 @@ const char * const vmstat_text[] = {
 	"nr_inactive_file",
 	"nr_active_file",
 	"nr_unevictable",
+	"nr_zone_write_pending",
 	"nr_mlock",
 	"nr_slab_reclaimable",
 	"nr_slab_unreclaimable",
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

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
mm-vmscan-make-shrink_node-decisions-more-node-centric-fix.patch
mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes.patch
mm-workingset-make-working-set-detection-node-aware.patch
mm-page_alloc-consider-dirtyable-memory-in-terms-of-nodes.patch
mm-move-page-mapped-accounting-to-the-node.patch
mm-rename-nr_anon_pages-to-nr_anon_mapped.patch
mm-move-most-file-based-accounting-to-the-node.patch
mm-move-most-file-based-accounting-to-the-node-fix.patch
mm-move-vmscan-writes-and-file-write-accounting-to-the-node.patch
mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone.patch
mm-page_alloc-wake-kswapd-based-on-the-highest-eligible-zone.patch
mm-convert-zone_reclaim-to-node_reclaim.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-shrink_node.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-compaction_ready.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-compaction_ready-fix.patch
mm-vmscan-avoid-passing-in-remaining-unnecessarily-to-prepare_kswapd_sleep.patch
mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit.patch
mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit-fix.patch
mm-vmscan-add-classzone-information-to-tracepoints.patch
mm-page_alloc-remove-fair-zone-allocation-policy.patch
mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch
mm-vmstat-replace-__count_zone_vm_events-with-a-zone-id-equivalent.patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim.patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim-fix.patch
mm-vmstat-print-node-based-stats-in-zoneinfo-file.patch
mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries.patch
mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries-fix.patch
mm-pagevec-release-reacquire-lru_lock-on-pgdat-change.patch
mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg.patch
mm-vmscan-remove-redundant-check-in-shrink_zones.patch
mm-vmscan-release-reacquire-lru_lock-on-pgdat-change.patch
mm-vmscan-release-reacquire-lru_lock-on-pgdat-change-fix.patch
mm-vmscan-remove-highmem_file_pages.patch
mm-remove-reclaim-and-compaction-retry-approximations.patch
mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch

