From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-fair-zone-allocator-policy-v2-fix.patch removed from -mm tree
Date: Wed, 11 Sep 2013 13:54:19 -0700
Message-ID: <5230d87b.qImtWkNZI58p40EU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3IKUyV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 16:54:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, riel@redhat.com, paul.bollee@gmail.com, mgorman@suse.de, aarcange@redhat.com, hannes@cmpxchg.org

Subject: [folded-merged] mm-page_alloc-fair-zone-allocator-policy-v2-fix.patch removed from -mm tree
To: hannes@cmpxchg.org,aarcange@redhat.com,mgorman@suse.de,paul.bollee@gmail.com,riel@redhat.com,zcalusic@bitsync.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 13:54:19 -0700


The patch titled
     Subject: mm: page_alloc: use vmstats for fair zone allocation batching
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fair-zone-allocator-policy-v2-fix.patch

This patch was dropped because it was folded into mm-page_alloc-fair-zone-allocator-policy.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: use vmstats for fair zone allocation batching

Avoid dirtying the same cache line with every single page allocation by
making the fair per-zone allocation batch a vmstat item, which will turn
it into batched percpu counters on SMP.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zlatko Calusic <zcalusic@bitsync.net>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Paul Bolle <paul.bollee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/page_alloc.c        |   21 ++++++++++++---------
 mm/vmstat.c            |    1 +
 3 files changed, 14 insertions(+), 10 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-fair-zone-allocator-policy-v2-fix include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-fair-zone-allocator-policy-v2-fix
+++ a/include/linux/mmzone.h
@@ -105,6 +105,7 @@ struct zone_padding {
 enum zone_stat_item {
 	/* First 128 byte cacheline (assuming 64 bit words) */
 	NR_FREE_PAGES,
+	NR_ALLOC_BATCH,
 	NR_LRU_BASE,
 	NR_INACTIVE_ANON = NR_LRU_BASE, /* must match order of LRU_[IN]ACTIVE */
 	NR_ACTIVE_ANON,		/*  "     "     "   "       "         */
@@ -352,7 +353,6 @@ struct zone {
 	 * free areas of different sizes
 	 */
 	spinlock_t		lock;
-	int			alloc_batch;
 	int                     all_unreclaimable; /* All pages pinned */
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 	/* Set to true when the PG_migrate_skip bits should be cleared */
diff -puN mm/page_alloc.c~mm-page_alloc-fair-zone-allocator-policy-v2-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fair-zone-allocator-policy-v2-fix
+++ a/mm/page_alloc.c
@@ -1551,6 +1551,7 @@ again:
 					  get_pageblock_migratetype(page));
 	}
 
+	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
 	zone_statistics(preferred_zone, zone, gfp_flags);
 	local_irq_restore(flags);
@@ -1924,7 +1925,7 @@ zonelist_scan:
 		 * fairness round-robin cycle of this zonelist.
 		 */
 		if (alloc_flags & ALLOC_WMARK_LOW) {
-			if (zone->alloc_batch <= 0)
+			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
 				continue;
 			if (zone_reclaim_mode &&
 			    !zone_local(preferred_zone, zone))
@@ -2036,8 +2037,7 @@ this_zone_full:
 		goto zonelist_scan;
 	}
 
-	if (page) {
-		zone->alloc_batch -= 1U << order;
+	if (page)
 		/*
 		 * page->pfmemalloc is set when ALLOC_NO_WATERMARKS was
 		 * necessary to allocate the page. The expectation is
@@ -2046,7 +2046,6 @@ this_zone_full:
 		 * for !PFMEMALLOC purposes.
 		 */
 		page->pfmemalloc = !!(alloc_flags & ALLOC_NO_WATERMARKS);
-	}
 
 	return page;
 }
@@ -2397,8 +2396,10 @@ static void prepare_slowpath(gfp_t gfp_m
 		 */
 		if (zone_reclaim_mode && !zone_local(preferred_zone, zone))
 			continue;
-		zone->alloc_batch = high_wmark_pages(zone) -
-			low_wmark_pages(zone);
+		mod_zone_page_state(zone, NR_ALLOC_BATCH,
+				    high_wmark_pages(zone) -
+				    low_wmark_pages(zone) -
+				    zone_page_state(zone, NR_ALLOC_BATCH));
 	}
 }
 
@@ -4798,7 +4799,7 @@ static void __paginginit free_area_init_
 		zone->zone_pgdat = pgdat;
 
 		/* For bootup, initialized properly in watermark setup */
-		zone->alloc_batch = zone->managed_pages;
+		mod_zone_page_state(zone, NR_ALLOC_BATCH, zone->managed_pages);
 
 		zone_pcp_init(zone);
 		lruvec_init(&zone->lruvec);
@@ -5571,8 +5572,10 @@ static void __setup_per_zone_wmarks(void
 		zone->watermark[WMARK_LOW]  = min_wmark_pages(zone) + (tmp >> 2);
 		zone->watermark[WMARK_HIGH] = min_wmark_pages(zone) + (tmp >> 1);
 
-		zone->alloc_batch = high_wmark_pages(zone) -
-			low_wmark_pages(zone);
+		__mod_zone_page_state(zone, NR_ALLOC_BATCH,
+				      high_wmark_pages(zone) -
+				      low_wmark_pages(zone) -
+				      zone_page_state(zone, NR_ALLOC_BATCH));
 
 		setup_zone_migrate_reserve(zone);
 		spin_unlock_irqrestore(&zone->lock, flags);
diff -puN mm/vmstat.c~mm-page_alloc-fair-zone-allocator-policy-v2-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-page_alloc-fair-zone-allocator-policy-v2-fix
+++ a/mm/vmstat.c
@@ -703,6 +703,7 @@ static void walk_zones_in_node(struct se
 const char * const vmstat_text[] = {
 	/* Zoned VM counters */
 	"nr_free_pages",
+	"nr_alloc_batch",
 	"nr_inactive_anon",
 	"nr_active_anon",
 	"nr_inactive_file",
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-kill-one-if-loop-in-__free_pages_bootmem.patch
mm-vmscan-fix-numa-reclaim-balance-problem-in-kswapd.patch
mm-page_alloc-rearrange-watermark-checking-in-get_page_from_freelist.patch
mm-page_alloc-fair-zone-allocator-policy.patch
mm-page_alloc-fair-zone-allocator-policy-v2-fix-2.patch
mm-revert-page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch
mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization.patch
mm-move-pgtable-related-functions-to-right-place.patch
swap-clean-up-ifdef-in-page_mapping.patch
mm-vmalloc-remove-useless-variable-in-vmap_block.patch
mm-vmalloc-use-well-defined-find_last_bit-func.patch
kmemcg-dont-allocate-extra-memory-for-root-memcg_cache_params-v2.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp.patch
mm-putback_lru_page-remove-unnecessary-call-to-page_lru_base_type.patch
mm-munlock-remove-unnecessary-call-to-lru_add_drain.patch
mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec.patch
mm-munlock-batch-nr_mlock-zone-state-updates.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch
mm-munlock-remove-redundant-get_page-put_page-pair-on-the-fast-path.patch
mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask.patch
mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask-v3.patch
mm-vmscan-fix-do_try_to_free_pages-livelock.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2.patch
mm-sparse-introduce-alloc_usemap_and_memmap.patch
mm-writeback-make-writeback_inodes_wb-static.patch
mm-vmalloc-use-wrapper-function-get_vm_area_size-to-caculate-size-of-vm-area.patch
memcg-fix-multiple-large-threshold-notifications.patch

