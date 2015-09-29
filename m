From: akpm@linux-foundation.org
Subject: + mm-page_alloc-remove-migrate_reserve.patch added to -mm tree
Date: Tue, 29 Sep 2015 14:09:38 -0700
Message-ID: <560afe12.S97vAxWD5YqgRC7s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbbI2VJl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 17:09:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, cl@linux.com, hannes@cmpxchg.org, mhocko@suse.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: remove MIGRATE_RESERVE
has been added to the -mm tree.  Its filename is
     mm-page_alloc-remove-migrate_reserve.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-remove-migrate_reserve.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-remove-migrate_reserve.patch

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
Subject: mm, page_alloc: remove MIGRATE_RESERVE

MIGRATE_RESERVE preserves an old property of the buddy allocator that
existed prior to fragmentation avoidance -- min_free_kbytes worth of pages
tended to remain contiguous until the only alternative was to fail the
allocation.  At the time it was discovered that high-order atomic
allocations relied on this property so MIGRATE_RESERVE was introduced.  A
later patch will introduce an alternative MIGRATE_HIGHATOMIC so this patch
deletes MIGRATE_RESERVE and supporting code so it'll be easier to review. 
Note that this patch in isolation may look like a false regression if
someone was bisecting high-order atomic allocation failures.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   10 --
 mm/huge_memory.c       |    2 
 mm/page_alloc.c        |  148 ++-------------------------------------
 mm/vmstat.c            |    1 
 4 files changed, 11 insertions(+), 150 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-remove-migrate_reserve include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-remove-migrate_reserve
+++ a/include/linux/mmzone.h
@@ -39,8 +39,6 @@ enum {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
 	MIGRATE_RECLAIMABLE,
-	MIGRATE_PCPTYPES,	/* the number of types on the pcp lists */
-	MIGRATE_RESERVE = MIGRATE_PCPTYPES,
 #ifdef CONFIG_CMA
 	/*
 	 * MIGRATE_CMA migration type is designed to mimic the way
@@ -63,6 +61,8 @@ enum {
 	MIGRATE_TYPES
 };
 
+#define MIGRATE_PCPTYPES (MIGRATE_RECLAIMABLE+1)
+
 #ifdef CONFIG_CMA
 #  define is_migrate_cma(migratetype) unlikely((migratetype) == MIGRATE_CMA)
 #else
@@ -429,12 +429,6 @@ struct zone {
 
 	const char		*name;
 
-	/*
-	 * Number of MIGRATE_RESERVE page block. To maintain for just
-	 * optimization. Protected by zone->lock.
-	 */
-	int			nr_migrate_reserve_block;
-
 #ifdef CONFIG_MEMORY_ISOLATION
 	/*
 	 * Number of isolated pageblock. It is used to solve incorrect
diff -puN mm/huge_memory.c~mm-page_alloc-remove-migrate_reserve mm/huge_memory.c
--- a/mm/huge_memory.c~mm-page_alloc-remove-migrate_reserve
+++ a/mm/huge_memory.c
@@ -146,7 +146,7 @@ static void set_recommended_min_free_kby
 	for_each_populated_zone(zone)
 		nr_zones++;
 
-	/* Make sure at least 2 hugepages are free for MIGRATE_RESERVE */
+	/* Ensure 2 pageblocks are free to assist fragmentation avoidance */
 	recommended_min = pageblock_nr_pages * nr_zones * 2;
 
 	/*
diff -puN mm/page_alloc.c~mm-page_alloc-remove-migrate_reserve mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-migrate_reserve
+++ a/mm/page_alloc.c
@@ -817,7 +817,6 @@ static void free_pcppages_bulk(struct zo
 			if (unlikely(has_isolate_pageblock(zone)))
 				mt = get_pageblock_migratetype(page);
 
-			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, page_to_pfn(page), zone, 0, mt);
 			trace_mm_page_pcpu_drain(page, 0, mt);
 		} while (--to_free && --batch_free && !list_empty(list));
@@ -1417,15 +1416,14 @@ struct page *__rmqueue_smallest(struct z
  * the free lists for the desirable migrate type are depleted
  */
 static int fallbacks[MIGRATE_TYPES][4] = {
-	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE,     MIGRATE_RESERVE },
-	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE,     MIGRATE_RESERVE },
-	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE,   MIGRATE_RESERVE },
+	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE,   MIGRATE_TYPES },
+	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE,   MIGRATE_TYPES },
+	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE, MIGRATE_TYPES },
 #ifdef CONFIG_CMA
-	[MIGRATE_CMA]         = { MIGRATE_RESERVE }, /* Never used */
+	[MIGRATE_CMA]         = { MIGRATE_TYPES }, /* Never used */
 #endif
-	[MIGRATE_RESERVE]     = { MIGRATE_RESERVE }, /* Never used */
 #ifdef CONFIG_MEMORY_ISOLATION
-	[MIGRATE_ISOLATE]     = { MIGRATE_RESERVE }, /* Never used */
+	[MIGRATE_ISOLATE]     = { MIGRATE_TYPES }, /* Never used */
 #endif
 };
 
@@ -1598,7 +1596,7 @@ int find_suitable_fallback(struct free_a
 	*can_steal = false;
 	for (i = 0;; i++) {
 		fallback_mt = fallbacks[migratetype][i];
-		if (fallback_mt == MIGRATE_RESERVE)
+		if (fallback_mt == MIGRATE_TYPES)
 			break;
 
 		if (list_empty(&area->free_list[fallback_mt]))
@@ -1676,25 +1674,13 @@ static struct page *__rmqueue(struct zon
 {
 	struct page *page;
 
-retry_reserve:
 	page = __rmqueue_smallest(zone, order, migratetype);
-
-	if (unlikely(!page) && migratetype != MIGRATE_RESERVE) {
+	if (unlikely(!page)) {
 		if (migratetype == MIGRATE_MOVABLE)
 			page = __rmqueue_cma_fallback(zone, order);
 
 		if (!page)
 			page = __rmqueue_fallback(zone, order, migratetype);
-
-		/*
-		 * Use MIGRATE_RESERVE rather than fail an allocation. goto
-		 * is used because __rmqueue_smallest is an inline function
-		 * and we want just one call site
-		 */
-		if (!page) {
-			migratetype = MIGRATE_RESERVE;
-			goto retry_reserve;
-		}
 	}
 
 	trace_mm_page_alloc_zone_locked(page, order, migratetype);
@@ -3491,7 +3477,6 @@ static void show_migration_types(unsigne
 		[MIGRATE_UNMOVABLE]	= 'U',
 		[MIGRATE_RECLAIMABLE]	= 'E',
 		[MIGRATE_MOVABLE]	= 'M',
-		[MIGRATE_RESERVE]	= 'R',
 #ifdef CONFIG_CMA
 		[MIGRATE_CMA]		= 'C',
 #endif
@@ -4302,120 +4287,6 @@ static inline unsigned long wait_table_b
 }
 
 /*
- * Check if a pageblock contains reserved pages
- */
-static int pageblock_is_reserved(unsigned long start_pfn, unsigned long end_pfn)
-{
-	unsigned long pfn;
-
-	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
-		if (!pfn_valid_within(pfn) || PageReserved(pfn_to_page(pfn)))
-			return 1;
-	}
-	return 0;
-}
-
-/*
- * Mark a number of pageblocks as MIGRATE_RESERVE. The number
- * of blocks reserved is based on min_wmark_pages(zone). The memory within
- * the reserve will tend to store contiguous free pages. Setting min_free_kbytes
- * higher will lead to a bigger reserve which will get freed as contiguous
- * blocks as reclaim kicks in
- */
-static void setup_zone_migrate_reserve(struct zone *zone)
-{
-	unsigned long start_pfn, pfn, end_pfn, block_end_pfn;
-	struct page *page;
-	unsigned long block_migratetype;
-	int reserve;
-	int old_reserve;
-
-	/*
-	 * Get the start pfn, end pfn and the number of blocks to reserve
-	 * We have to be careful to be aligned to pageblock_nr_pages to
-	 * make sure that we always check pfn_valid for the first page in
-	 * the block.
-	 */
-	start_pfn = zone->zone_start_pfn;
-	end_pfn = zone_end_pfn(zone);
-	start_pfn = roundup(start_pfn, pageblock_nr_pages);
-	reserve = roundup(min_wmark_pages(zone), pageblock_nr_pages) >>
-							pageblock_order;
-
-	/*
-	 * Reserve blocks are generally in place to help high-order atomic
-	 * allocations that are short-lived. A min_free_kbytes value that
-	 * would result in more than 2 reserve blocks for atomic allocations
-	 * is assumed to be in place to help anti-fragmentation for the
-	 * future allocation of hugepages at runtime.
-	 */
-	reserve = min(2, reserve);
-	old_reserve = zone->nr_migrate_reserve_block;
-
-	/* When memory hot-add, we almost always need to do nothing */
-	if (reserve == old_reserve)
-		return;
-	zone->nr_migrate_reserve_block = reserve;
-
-	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
-		if (!early_page_nid_uninitialised(pfn, zone_to_nid(zone)))
-			return;
-
-		if (!pfn_valid(pfn))
-			continue;
-		page = pfn_to_page(pfn);
-
-		/* Watch out for overlapping nodes */
-		if (page_to_nid(page) != zone_to_nid(zone))
-			continue;
-
-		block_migratetype = get_pageblock_migratetype(page);
-
-		/* Only test what is necessary when the reserves are not met */
-		if (reserve > 0) {
-			/*
-			 * Blocks with reserved pages will never free, skip
-			 * them.
-			 */
-			block_end_pfn = min(pfn + pageblock_nr_pages, end_pfn);
-			if (pageblock_is_reserved(pfn, block_end_pfn))
-				continue;
-
-			/* If this block is reserved, account for it */
-			if (block_migratetype == MIGRATE_RESERVE) {
-				reserve--;
-				continue;
-			}
-
-			/* Suitable for reserving if this block is movable */
-			if (block_migratetype == MIGRATE_MOVABLE) {
-				set_pageblock_migratetype(page,
-							MIGRATE_RESERVE);
-				move_freepages_block(zone, page,
-							MIGRATE_RESERVE);
-				reserve--;
-				continue;
-			}
-		} else if (!old_reserve) {
-			/*
-			 * At boot time we don't need to scan the whole zone
-			 * for turning off MIGRATE_RESERVE.
-			 */
-			break;
-		}
-
-		/*
-		 * If the reserve is met and this is a previous reserved block,
-		 * take it back
-		 */
-		if (block_migratetype == MIGRATE_RESERVE) {
-			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
-			move_freepages_block(zone, page, MIGRATE_MOVABLE);
-		}
-	}
-}
-
-/*
  * Initially all pages are reserved - free ones are freed
  * up by free_all_bootmem() once the early boot process is
  * done. Non-atomic initialization, single-pass.
@@ -4454,9 +4325,7 @@ void __meminit memmap_init_zone(unsigned
 		 * movable at startup. This will force kernel allocations
 		 * to reserve their blocks rather than leaking throughout
 		 * the address space during boot when many long-lived
-		 * kernel allocations are made. Later some blocks near
-		 * the start are marked MIGRATE_RESERVE by
-		 * setup_zone_migrate_reserve()
+		 * kernel allocations are made.
 		 *
 		 * bitmap is created for zone's valid pfn range. but memmap
 		 * can be created for invalid pages (for alignment)
@@ -6010,7 +5879,6 @@ static void __setup_per_zone_wmarks(void
 			high_wmark_pages(zone) - low_wmark_pages(zone) -
 			atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]));
 
-		setup_zone_migrate_reserve(zone);
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
 
diff -puN mm/vmstat.c~mm-page_alloc-remove-migrate_reserve mm/vmstat.c
--- a/mm/vmstat.c~mm-page_alloc-remove-migrate_reserve
+++ a/mm/vmstat.c
@@ -901,7 +901,6 @@ static char * const migratetype_names[MI
 	"Unmovable",
 	"Reclaimable",
 	"Movable",
-	"Reserve",
 #ifdef CONFIG_CMA
 	"CMA",
 #endif
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-hugetlbfs-skip-shared-vmas-when-unmapping-private-pages-to-satisfy-a-fault.patch
mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe.patch
mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing.patch
mm-page_alloc-remove-unnecessary-taking-of-a-seqlock-when-cpusets-are-disabled.patch
mm-page_alloc-use-masks-and-shifts-when-converting-gfp-flags-to-migrate-types.patch
mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim.patch
mm-page_alloc-delete-the-zonelist_cache.patch
mm-page_alloc-remove-migrate_reserve.patch
mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch

