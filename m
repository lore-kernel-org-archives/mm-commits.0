From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-remove-fair-zone-allocation-policy.patch
 removed from -mm tree
Date: Fri, 29 Jul 2016 11:55:28 -0700
Message-ID: <579ba6a0.Oyo/IdEwC2yLbN3R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37390 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbcG2Sz3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:55:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: remove fair zone allocation policy
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-fair-zone-allocation-policy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: remove fair zone allocation policy

The fair zone allocation policy interleaves allocation requests between
zones to avoid an age inversion problem whereby new pages are reclaimed to
balance a zone.  Reclaim is now node-based so this should no longer be an
issue and the fair zone allocation policy is not free.  This patch removes
it.

Link: http://lkml.kernel.org/r/1467970510-21195-30-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 --
 mm/internal.h          |    1 
 mm/page_alloc.c        |   75 ---------------------------------------
 mm/vmstat.c            |    4 --
 4 files changed, 2 insertions(+), 83 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-remove-fair-zone-allocation-policy include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-remove-fair-zone-allocation-policy
+++ a/include/linux/mmzone.h
@@ -110,7 +110,6 @@ struct zone_padding {
 enum zone_stat_item {
 	/* First 128 byte cacheline (assuming 64 bit words) */
 	NR_FREE_PAGES,
-	NR_ALLOC_BATCH,
 	NR_ZONE_LRU_BASE, /* Used only for compaction and reclaim retry */
 	NR_ZONE_LRU_ANON = NR_ZONE_LRU_BASE,
 	NR_ZONE_LRU_FILE,
@@ -516,10 +515,6 @@ struct zone {
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 } ____cacheline_internodealigned_in_smp;
 
-enum zone_flags {
-	ZONE_FAIR_DEPLETED,		/* fair zone policy batch depleted */
-};
-
 enum pgdat_flags {
 	PGDAT_CONGESTED,		/* pgdat has many dirty pages backed by
 					 * a congested BDI
diff -puN mm/internal.h~mm-page_alloc-remove-fair-zone-allocation-policy mm/internal.h
--- a/mm/internal.h~mm-page_alloc-remove-fair-zone-allocation-policy
+++ a/mm/internal.h
@@ -467,7 +467,6 @@ unsigned long reclaim_clean_pages_from_l
 #define ALLOC_HIGH		0x20 /* __GFP_HIGH set */
 #define ALLOC_CPUSET		0x40 /* check for correct cpuset */
 #define ALLOC_CMA		0x80 /* allow allocations from CMA areas */
-#define ALLOC_FAIR		0x100 /* fair zone allocation */
 
 enum ttu_flags;
 struct tlbflush_unmap_batch;
diff -puN mm/page_alloc.c~mm-page_alloc-remove-fair-zone-allocation-policy mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-fair-zone-allocation-policy
+++ a/mm/page_alloc.c
@@ -2587,7 +2587,6 @@ struct page *buffered_rmqueue(struct zon
 			else
 				page = list_first_entry(list, struct page, lru);
 
-			__dec_zone_state(zone, NR_ALLOC_BATCH);
 			list_del(&page->lru);
 			pcp->count--;
 
@@ -2613,15 +2612,10 @@ struct page *buffered_rmqueue(struct zon
 		spin_unlock(&zone->lock);
 		if (!page)
 			goto failed;
-		__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
 		__mod_zone_freepage_state(zone, -(1 << order),
 					  get_pcppage_migratetype(page));
 	}
 
-	if (atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]) <= 0 &&
-	    !test_bit(ZONE_FAIR_DEPLETED, &zone->flags))
-		set_bit(ZONE_FAIR_DEPLETED, &zone->flags);
-
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
 	zone_statistics(preferred_zone, zone, gfp_flags);
 	local_irq_restore(flags);
@@ -2832,40 +2826,18 @@ bool zone_watermark_ok_safe(struct zone
 }
 
 #ifdef CONFIG_NUMA
-static bool zone_local(struct zone *local_zone, struct zone *zone)
-{
-	return local_zone->node == zone->node;
-}
-
 static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
 {
 	return node_distance(zone_to_nid(local_zone), zone_to_nid(zone)) <
 				RECLAIM_DISTANCE;
 }
 #else	/* CONFIG_NUMA */
-static bool zone_local(struct zone *local_zone, struct zone *zone)
-{
-	return true;
-}
-
 static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
 {
 	return true;
 }
 #endif	/* CONFIG_NUMA */
 
-static void reset_alloc_batches(struct zone *preferred_zone)
-{
-	struct zone *zone = preferred_zone->zone_pgdat->node_zones;
-
-	do {
-		mod_zone_page_state(zone, NR_ALLOC_BATCH,
-			high_wmark_pages(zone) - low_wmark_pages(zone) -
-			atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]));
-		clear_bit(ZONE_FAIR_DEPLETED, &zone->flags);
-	} while (zone++ != preferred_zone);
-}
-
 /*
  * get_page_from_freelist goes through the zonelist trying to allocate
  * a page.
@@ -2876,10 +2848,6 @@ get_page_from_freelist(gfp_t gfp_mask, u
 {
 	struct zoneref *z = ac->preferred_zoneref;
 	struct zone *zone;
-	bool fair_skipped = false;
-	bool apply_fair = (alloc_flags & ALLOC_FAIR);
-
-zonelist_scan:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
 	 * See also __cpuset_node_allowed() comment in kernel/cpuset.c.
@@ -2894,23 +2862,6 @@ zonelist_scan:
 			!__cpuset_zone_allowed(zone, gfp_mask))
 				continue;
 		/*
-		 * Distribute pages in proportion to the individual
-		 * zone size to ensure fair page aging.  The zone a
-		 * page was allocated in should have no effect on the
-		 * time the page has in memory before being reclaimed.
-		 */
-		if (apply_fair) {
-			if (test_bit(ZONE_FAIR_DEPLETED, &zone->flags)) {
-				fair_skipped = true;
-				continue;
-			}
-			if (!zone_local(ac->preferred_zoneref->zone, zone)) {
-				if (fair_skipped)
-					goto reset_fair;
-				apply_fair = false;
-			}
-		}
-		/*
 		 * When allocating a page cache page for writing, we
 		 * want to get it from a node that is within its dirty
 		 * limit, such that no single node holds more than its
@@ -2981,23 +2932,6 @@ try_this_zone:
 		}
 	}
 
-	/*
-	 * The first pass makes sure allocations are spread fairly within the
-	 * local node.  However, the local node might have free pages left
-	 * after the fairness batches are exhausted, and remote zones haven't
-	 * even been considered yet.  Try once more without fairness, and
-	 * include remote zones now, before entering the slowpath and waking
-	 * kswapd: prefer spilling to a remote zone over swapping locally.
-	 */
-	if (fair_skipped) {
-reset_fair:
-		apply_fair = false;
-		fair_skipped = false;
-		reset_alloc_batches(ac->preferred_zoneref->zone);
-		z = ac->preferred_zoneref;
-		goto zonelist_scan;
-	}
-
 	return NULL;
 }
 
@@ -3746,7 +3680,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 {
 	struct page *page;
 	unsigned int cpuset_mems_cookie;
-	unsigned int alloc_flags = ALLOC_WMARK_LOW|ALLOC_FAIR;
+	unsigned int alloc_flags = ALLOC_WMARK_LOW;
 	gfp_t alloc_mask = gfp_mask; /* The gfp_t that was actually used for allocation */
 	struct alloc_context ac = {
 		.high_zoneidx = gfp_zone(gfp_mask),
@@ -5958,9 +5892,6 @@ static void __paginginit free_area_init_
 		zone_seqlock_init(zone);
 		zone_pcp_init(zone);
 
-		/* For bootup, initialized properly in watermark setup */
-		mod_zone_page_state(zone, NR_ALLOC_BATCH, zone->managed_pages);
-
 		if (!size)
 			continue;
 
@@ -6808,10 +6739,6 @@ static void __setup_per_zone_wmarks(void
 		zone->watermark[WMARK_LOW]  = min_wmark_pages(zone) + tmp;
 		zone->watermark[WMARK_HIGH] = min_wmark_pages(zone) + tmp * 2;
 
-		__mod_zone_page_state(zone, NR_ALLOC_BATCH,
-			high_wmark_pages(zone) - low_wmark_pages(zone) -
-			atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]));
-
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
 
diff -puN mm/vmstat.c~mm-page_alloc-remove-fair-zone-allocation-policy mm/vmstat.c
--- a/mm/vmstat.c~mm-page_alloc-remove-fair-zone-allocation-policy
+++ a/mm/vmstat.c
@@ -921,7 +921,6 @@ int fragmentation_index(struct zone *zon
 const char * const vmstat_text[] = {
 	/* enum zone_stat_item countes */
 	"nr_free_pages",
-	"nr_alloc_batch",
 	"nr_zone_anon_lru",
 	"nr_zone_file_lru",
 	"nr_zone_write_pending",
@@ -1632,10 +1631,9 @@ int vmstat_refresh(struct ctl_table *tab
 		val = atomic_long_read(&vm_zone_stat[i]);
 		if (val < 0) {
 			switch (i) {
-			case NR_ALLOC_BATCH:
 			case NR_PAGES_SCANNED:
 				/*
-				 * These are often seen to go negative in
+				 * This is often seen to go negative in
 				 * recent kernels, but not to go permanently
 				 * negative.  Whilst it would be nicer not to
 				 * have exceptions, rooting them out would be
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


