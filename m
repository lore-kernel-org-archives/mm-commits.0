From: akpm@linux-foundation.org
Subject: [patch 060/101] mm: remove reclaim and compaction retry
 approximations
Date: Thu, 28 Jul 2016 15:47:31 -0700
Message-ID: <579a8b83.L90IGfJ+VZmoo4RB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbcG1Wrd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:47:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, hannes@cmpxchg.org, mhocko@suse.cz, minchan@kernel.org, vbabka@suse.cz

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
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Minchan Kim <minchan@kernel.org>
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
 	 * Keep reclaiming pages while there is a chance this will lead
 	 * somewhere.  If none of the target zones can satisfy our allocation
 	 * request even if all reclaimable pages are considered then we are
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
 	"nr_zone_inactive_file",
 	"nr_zone_active_file",
 	"nr_zone_unevictable",
+	"nr_zone_write_pending",
 	"nr_mlock",
 	"nr_slab_reclaimable",
 	"nr_slab_unreclaimable",
_
