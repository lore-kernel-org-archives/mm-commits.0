From: akpm@linux-foundation.org
Subject: - bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:34:55 -0700
Message-ID: <200710162034.l9GKYt4D015004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48728 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966213AbXJPVt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:49:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     Bias the location of pages freed for min_free_kbytes in the same MAX_ORDER_NR_PAGES blocks
has been removed from the -mm tree.  Its filename was
     bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Bias the location of pages freed for min_free_kbytes in the same MAX_ORDER_NR_PAGES blocks
From: Mel Gorman <mel@csn.ul.ie>

The standard buddy allocator always favours the smallest block of pages. 
The effect of this is that the pages free to satisfy min_free_kbytes tends
to be preserved since boot time at the same location of memory ffor a very
long time and as a contiguous block.  When an administrator sets the
reserve at 16384 at boot time, it tends to be the same MAX_ORDER blocks
that remain free.  This allows the occasional high atomic allocation to
succeed up until the point the blocks are split.  In practice, it is
difficult to split these blocks but when they do split, the benefit of
having min_free_kbytes for contiguous blocks disappears.  Additionally,
increasing min_free_kbytes once the system has been running for some time
has no guarantee of creating contiguous blocks.

On the other hand, CONFIG_PAGE_GROUP_BY_MOBILITY favours splitting large
blocks when there are no free pages of the appropriate type available.  A
side-effect of this is that all blocks in memory tends to be used up and
the contiguous free blocks from boot time are not preserved like in the
vanilla allocator.  This can cause a problem if a new caller is unwilling
to reclaim or does not reclaim for long enough.

A failure scenario was found for a wireless network device allocating
order-1 atomic allocations but the allocations were not intense or frequent
enough for a whole block of pages to be preserved for MIGRATE_HIGHALLOC. 
This was reproduced on a desktop by booting with mem=256mb, forcing the
driver to allocate at order-1, running a bittorrent client (downloading a
debian ISO) and building a kernel with -j2.

This patch addresses the problem on the desktop machine booted with
mem=256mb.  It works by setting aside a reserve of MAX_ORDER_NR_PAGES
blocks, the number of which depends on the value of min_free_kbytes.  These
blocks are only fallen back to when there is no other free pages.  Then the
smallest possible page is used just like the normal buddy allocator instead
of the largest possible page to preserve contiguous pages The pages in free
lists in the reserve blocks are never taken for another migrate type.  The
results is that even if min_free_kbytes is set to a low value, contiguous
blocks will be preserved in the MIGRATE_RESERVE blocks.

This works better than the vanilla allocator because if min_free_kbytes is
increased, a new reserve block will be chosen based on the location of
reclaimable pages and the block will free up as contiguous pages.  In the
vanilla allocator, no effort is made to target a block of pages to free as
contiguous pages and min_free_kbytes pages are scattered randomly.

This effect has been observed on the test machine.  min_free_kbytes was set
initially low but it was kept as a contiguous free block within
MIGRATE_RESERVE.  min_free_kbytes was then set to a higher value and over a
period of time, the free blocks were within the reserve and coalescing. 
How long it takes to free up depends on how quickly LRU is rotating. 
Amusingly, this means that more activity will free the blocks faster.

This mechanism potentially replaces MIGRATE_HIGHALLOC as it may be more
effective than grouping contiguous free pages together.  It all depends on
whether the number of active atomic high allocations exceeds
min_free_kbytes or not.  If the number of active allocations exceeds
min_free_kbytes, it's worth it but maybe in that situation, min_free_kbytes
should be set higher.  Once there are no more reports of allocation
failures, a patch will be submitted that backs out MIGRATE_HIGHALLOC and
see if the reports stay missing.

Credit to Mariusz Kozlowski for discovering the problem, describing the
failure scenario and testing patches and scenarios.

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h          |    4 
 include/linux/pageblock-flags.h |    2 
 mm/page_alloc.c                 |  138 +++++++++++++++++++++++-------
 3 files changed, 114 insertions(+), 30 deletions(-)

diff -puN include/linux/mmzone.h~bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks include/linux/mmzone.h
--- a/include/linux/mmzone.h~bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks
+++ a/include/linux/mmzone.h
@@ -38,12 +38,14 @@
 #define MIGRATE_RECLAIMABLE   1
 #define MIGRATE_MOVABLE       2
 #define MIGRATE_HIGHATOMIC    3
-#define MIGRATE_TYPES         4
+#define MIGRATE_RESERVE       4
+#define MIGRATE_TYPES         5
 #else
 #define MIGRATE_UNMOVABLE     0
 #define MIGRATE_UNRECLAIMABLE 0
 #define MIGRATE_MOVABLE       0
 #define MIGRATE_HIGHATOMIC    0
+#define MIGRATE_RESERVE       0
 #define MIGRATE_TYPES         1
 #endif
 
diff -puN include/linux/pageblock-flags.h~bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks include/linux/pageblock-flags.h
--- a/include/linux/pageblock-flags.h~bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks
+++ a/include/linux/pageblock-flags.h
@@ -31,7 +31,7 @@
 
 /* Bit indices that affect a whole block of pages */
 enum pageblock_bits {
-	PB_range(PB_migrate, 2), /* 2 bits required for migrate types */
+	PB_range(PB_migrate, 3), /* 3 bits required for migrate types */
 	NR_PAGEBLOCK_BITS
 };
 
diff -puN mm/page_alloc.c~bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks mm/page_alloc.c
--- a/mm/page_alloc.c~bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks
+++ a/mm/page_alloc.c
@@ -687,16 +687,48 @@ static int prep_new_page(struct page *pa
 	return 0;
 }
 
+/*
+ * Go through the free lists for the given migratetype and remove
+ * the smallest available page from the freelists
+ */
+static struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
+						int migratetype)
+{
+	unsigned int current_order;
+	struct free_area * area;
+	struct page *page;
+
+	/* Find a page of the appropriate size in the preferred list */
+	for (current_order = order; current_order < MAX_ORDER; ++current_order) {
+		area = &(zone->free_area[current_order]);
+		if (list_empty(&area->free_list[migratetype]))
+			continue;
+
+		page = list_entry(area->free_list[migratetype].next,
+							struct page, lru);
+		list_del(&page->lru);
+		rmv_page_order(page);
+		area->nr_free--;
+		__mod_zone_page_state(zone, NR_FREE_PAGES, - (1UL << order));
+		expand(zone, page, order, current_order, area, migratetype);
+		return page;
+	}
+
+	return NULL;
+}
+
+
 #ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 /*
  * This array describes the order lists are fallen back to when
  * the free lists for the desirable migrate type are depleted
  */
 static int fallbacks[MIGRATE_TYPES][MIGRATE_TYPES-1] = {
-	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE,  MIGRATE_HIGHATOMIC },
-	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE,  MIGRATE_HIGHATOMIC },
-	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE,MIGRATE_HIGHATOMIC },
-	[MIGRATE_HIGHATOMIC]  = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE,MIGRATE_MOVABLE},
+	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE,   MIGRATE_HIGHATOMIC, MIGRATE_RESERVE },
+	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE,   MIGRATE_HIGHATOMIC, MIGRATE_RESERVE },
+	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE, MIGRATE_HIGHATOMIC, MIGRATE_RESERVE },
+	[MIGRATE_HIGHATOMIC]  = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE, MIGRATE_MOVABLE,    MIGRATE_RESERVE },
+	[MIGRATE_RESERVE]     = { MIGRATE_RESERVE,     MIGRATE_RESERVE,   MIGRATE_RESERVE,    MIGRATE_RESERVE }, /* Never used */
 };
 
 /*
@@ -799,6 +831,9 @@ retry:
 		for (i = 0; i < MIGRATE_TYPES - 1; i++) {
 			migratetype = fallbacks[start_migratetype][i];
 
+			/* MIGRATE_RESERVE handled later if necessary */
+			if (migratetype == MIGRATE_RESERVE)
+				continue;
 			/*
 			 * Make it hard to fallback to blocks used for
 			 * high-order atomic allocations
@@ -861,7 +896,8 @@ retry:
 		goto retry;
 	}
 
-	return NULL;
+	/* Use MIGRATE_RESERVE rather than fail an allocation */
+	return __rmqueue_smallest(zone, order, MIGRATE_RESERVE);
 }
 #else
 static struct page *__rmqueue_fallback(struct zone *zone, int order,
@@ -871,36 +907,19 @@ static struct page *__rmqueue_fallback(s
 }
 #endif /* CONFIG_PAGE_GROUP_BY_MOBILITY */
 
-/* 
+/*
  * Do the hard work of removing an element from the buddy allocator.
  * Call me with the zone->lock already held.
  */
 static struct page *__rmqueue(struct zone *zone, unsigned int order,
 						int migratetype)
 {
-	struct free_area * area;
-	unsigned int current_order;
 	struct page *page;
 
-	/* Find a page of the appropriate size in the preferred list */
-	for (current_order = order; current_order < MAX_ORDER; ++current_order) {
-		area = &(zone->free_area[current_order]);
-		if (list_empty(&area->free_list[migratetype]))
-			continue;
-
-		page = list_entry(area->free_list[migratetype].next,
-							struct page, lru);
-		list_del(&page->lru);
-		rmv_page_order(page);
-		area->nr_free--;
-		__mod_zone_page_state(zone, NR_FREE_PAGES, - (1UL << order));
-		expand(zone, page, order, current_order, area, migratetype);
-		goto got_page;
-	}
-
-	page = __rmqueue_fallback(zone, order, migratetype);
+	page = __rmqueue_smallest(zone, order, migratetype);
 
-got_page:
+	if (unlikely(!page))
+		page = __rmqueue_fallback(zone, order, migratetype);
 
 	return page;
 }
@@ -2506,6 +2525,65 @@ static inline unsigned long wait_table_b
 
 #define LONG_ALIGN(x) (((x)+(sizeof(long))-1)&~((sizeof(long))-1))
 
+#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
+/*
+ * Mark a number of MAX_ORDER_NR_PAGES blocks as MIGRATE_RESERVE. The number
+ * of blocks reserved is based on zone->pages_min. The memory within the
+ * reserve will tend to store contiguous free pages. Setting min_free_kbytes
+ * higher will lead to a bigger reserve which will get freed as contiguous
+ * blocks as reclaim kicks in
+ */
+static void setup_zone_migrate_reserve(struct zone *zone)
+{
+	unsigned long start_pfn, pfn, end_pfn;
+	struct page *page;
+	unsigned long reserve, block_migratetype;
+
+	/* Get the start pfn, end pfn and the number of blocks to reserve */
+	start_pfn = zone->zone_start_pfn;
+	end_pfn = start_pfn + zone->spanned_pages;
+	reserve = roundup(zone->pages_min, MAX_ORDER_NR_PAGES) >> (MAX_ORDER-1);
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn += MAX_ORDER_NR_PAGES) {
+		if (!pfn_valid(pfn))
+			continue;
+		page = pfn_to_page(pfn);
+
+		/* Blocks with reserved pages will never free, skip them. */
+		if (PageReserved(page))
+			continue;
+
+		block_migratetype = get_pageblock_migratetype(page);
+
+		/* If this block is reserved, account for it */
+		if (reserve > 0 && block_migratetype == MIGRATE_RESERVE) {
+			reserve--;
+			continue;
+		}
+
+		/* Suitable for reserving if this block is movable */
+		if (reserve > 0 && block_migratetype == MIGRATE_MOVABLE) {
+			set_pageblock_migratetype(page, MIGRATE_RESERVE);
+			move_freepages_block(zone, page, MIGRATE_RESERVE);
+			reserve--;
+			continue;
+		}
+
+		/*
+		 * If the reserve is met and this is a previous reserved block,
+		 * take it back
+		 */
+		if (block_migratetype == MIGRATE_RESERVE) {
+			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+			move_freepages_block(zone, page, MIGRATE_MOVABLE);
+		}
+	}
+}
+#else
+static inline void setup_zone_migrate_reserve(struct zone *zone)
+{
+}
+#endif /* CONFIG_PAGE_GROUP_BY_MOBILITY */
 /*
  * Initially all pages are reserved - free ones are freed
  * up by free_all_bootmem() once the early boot process is
@@ -2541,9 +2619,12 @@ void __meminit memmap_init_zone(unsigned
 		 * movable at startup. This will force kernel allocations
 		 * to reserve their blocks rather than leaking throughout
 		 * the address space during boot when many long-lived
-		 * kernel allocations are made
+		 * kernel allocations are made. Later some blocks near
+		 * the start are marked MIGRATE_RESERVE by
+		 * setup_zone_migrate_reserve()
 		 */
-		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+		if ((pfn & (MAX_ORDER_NR_PAGES-1)))
+			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 
 		INIT_LIST_HEAD(&page->lru);
 #ifdef WANT_PAGE_VIRTUAL
@@ -4078,6 +4159,7 @@ void setup_per_zone_pages_min(void)
 
 		zone->pages_low   = zone->pages_min + (tmp >> 2);
 		zone->pages_high  = zone->pages_min + (tmp >> 1);
+		setup_zone_migrate_reserve(zone);
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 	}
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
