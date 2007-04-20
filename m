From: akpm@linux-foundation.org
Subject: + remove-page_group_by_mobility.patch added to -mm tree
Date: Thu, 19 Apr 2007 20:32:01 -0700
Message-ID: <200704200332.l3K3W1sO006039@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752361AbXDTDcm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 23:32:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org


The patch titled
     remove PAGE_GROUP_BY_MOBILITY
has been added to the -mm tree.  Its filename is
     remove-page_group_by_mobility.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove PAGE_GROUP_BY_MOBILITY
From: Mel Gorman <mel@csn.ul.ie>

Grouping pages by mobility can be disabled at compile-time. This was
considered undesirable by a number of people. However, in the current stack of
patches, it is not a simple case of just dropping the configurable patch as it
would cause merge conflicts.  This patch backs out the configuration option.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    9 --------
 init/Kconfig           |   13 ------------
 mm/page_alloc.c        |   42 +--------------------------------------
 3 files changed, 2 insertions(+), 62 deletions(-)

diff -puN include/linux/mmzone.h~remove-page_group_by_mobility include/linux/mmzone.h
--- a/include/linux/mmzone.h~remove-page_group_by_mobility
+++ a/include/linux/mmzone.h
@@ -25,21 +25,12 @@
 #endif
 #define MAX_ORDER_NR_PAGES (1 << (MAX_ORDER - 1))
 
-#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 #define MIGRATE_UNMOVABLE     0
 #define MIGRATE_RECLAIMABLE   1
 #define MIGRATE_MOVABLE       2
 #define MIGRATE_HIGHATOMIC    3
 #define MIGRATE_RESERVE       4
 #define MIGRATE_TYPES         5
-#else
-#define MIGRATE_UNMOVABLE     0
-#define MIGRATE_UNRECLAIMABLE 0
-#define MIGRATE_MOVABLE       0
-#define MIGRATE_HIGHATOMIC    0
-#define MIGRATE_RESERVE       0
-#define MIGRATE_TYPES         1
-#endif
 
 #define for_each_migratetype_order(order, type) \
 	for (order = 0; order < MAX_ORDER; order++) \
diff -puN init/Kconfig~remove-page_group_by_mobility init/Kconfig
--- a/init/Kconfig~remove-page_group_by_mobility
+++ a/init/Kconfig
@@ -547,19 +547,6 @@ config SLOB
 	default !SLAB
 	bool
 
-config PAGE_GROUP_BY_MOBILITY
-	bool "Group pages based on their mobility in the page allocator"
-	def_bool y
-	help
-	  The standard allocator will fragment memory over time which means
-	  that high order allocations will fail even if kswapd is running. If
-	  this option is set, the allocator will try and group page types
-	  based on their ability to migrate or reclaim. This is a best effort
-	  attempt at lowering fragmentation which a few workloads care about.
-	  The loss is a more complex allocator that may perform slower. If
-	  you are interested in working with large pages, say Y and set
-	  /proc/sys/vm/min_free_bytes to 16374. Otherwise say N
-
 menu "Loadable module support"
 
 config MODULES
diff -puN mm/page_alloc.c~remove-page_group_by_mobility mm/page_alloc.c
--- a/mm/page_alloc.c~remove-page_group_by_mobility
+++ a/mm/page_alloc.c
@@ -144,7 +144,6 @@ static unsigned long __initdata dma_rese
   EXPORT_SYMBOL(movable_zone);
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 
-#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 int page_group_by_mobility_disabled __read_mostly;
 
 static inline int get_pageblock_migratetype(struct page *page)
@@ -178,22 +177,6 @@ static inline int allocflags_to_migratet
 		((gfp_flags & __GFP_RECLAIMABLE) != 0);
 }
 
-#else
-static inline int get_pageblock_migratetype(struct page *page)
-{
-	return MIGRATE_UNMOVABLE;
-}
-
-static void set_pageblock_migratetype(struct page *page, int migratetype)
-{
-}
-
-static inline int allocflags_to_migratetype(gfp_t gfp_flags, int order)
-{
-	return MIGRATE_UNMOVABLE;
-}
-#endif /* CONFIG_PAGE_GROUP_BY_MOBILITY */
-
 #ifdef CONFIG_DEBUG_VM
 static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 {
@@ -702,7 +685,6 @@ static struct page *__rmqueue_smallest(s
 }
 
 
-#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 /*
  * This array describes the order lists are fallen back to when
  * the free lists for the desirable migrate type are depleted
@@ -734,7 +716,7 @@ int move_freepages(struct zone *zone,
 	 * CONFIG_HOLES_IN_ZONE is set. This bug check is probably redundant
 	 * anyway as we check zone boundaries in move_freepages_block().
 	 * Remove at a later date when no bug reports exist related to
-	 * CONFIG_PAGE_GROUP_BY_MOBILITY
+	 * grouping pages by mobility
 	 */
 	BUG_ON(page_zone(start_page) != page_zone(end_page));
 #endif
@@ -883,13 +865,6 @@ retry:
 	/* Use MIGRATE_RESERVE rather than fail an allocation */
 	return __rmqueue_smallest(zone, order, MIGRATE_RESERVE);
 }
-#else
-static struct page *__rmqueue_fallback(struct zone *zone, int order,
-						int start_migratetype)
-{
-	return NULL;
-}
-#endif /* CONFIG_PAGE_GROUP_BY_MOBILITY */
 
 /*
  * Do the hard work of removing an element from the buddy allocator.
@@ -1055,7 +1030,6 @@ void mark_free_pages(struct zone *zone)
 }
 #endif /* CONFIG_PM */
 
-#if defined(CONFIG_PM) || defined(CONFIG_PAGE_GROUP_BY_MOBILITY)
 /*
  * Spill all of this CPU's per-cpu pages back into the buddy allocator.
  */
@@ -1086,9 +1060,6 @@ void drain_all_local_pages(void)
 
 	smp_call_function(smp_drain_local_pages, NULL, 0, 1);
 }
-#else
-void drain_all_local_pages(void) {}
-#endif /* CONFIG_PM || CONFIG_PAGE_GROUP_BY_MOBILITY */
 
 /*
  * Free a 0-order page
@@ -1179,7 +1150,6 @@ again:
 				goto failed;
 		}
 
-#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 		/* Find a page of the appropriate migrate type */
 		list_for_each_entry(page, &pcp->list, lru)
 			if (page_private(page) == migratetype)
@@ -1191,9 +1161,6 @@ again:
 					pcp->batch, &pcp->list, migratetype);
 			page = list_entry(pcp->list.next, struct page, lru);
 		}
-#else
-		page = list_entry(pcp->list.next, struct page, lru);
-#endif /* CONFIG_PAGE_GROUP_BY_MOBILITY */
 
 		list_del(&page->lru);
 		pcp->count--;
@@ -2269,7 +2236,6 @@ static inline unsigned long wait_table_b
 
 #define LONG_ALIGN(x) (((x)+(sizeof(long))-1)&~((sizeof(long))-1))
 
-#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 /*
  * Mark a number of MAX_ORDER_NR_PAGES blocks as MIGRATE_RESERVE. The number
  * of blocks reserved is based on zone->pages_min. The memory within the
@@ -2323,11 +2289,7 @@ static void setup_zone_migrate_reserve(s
 		}
 	}
 }
-#else
-static inline void setup_zone_migrate_reserve(struct zone *zone)
-{
-}
-#endif /* CONFIG_PAGE_GROUP_BY_MOBILITY */
+
 /*
  * Initially all pages are reserved - free ones are freed
  * up by free_all_bootmem() once the early boot process is
_

Patches currently in -mm which might be from mel@csn.ul.ie are

add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
add-a-configure-option-to-group-pages-by-mobility-speedup.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
move-free-pages-between-lists-on-steal-fix.patch
move-free-pages-between-lists-on-steal-fix-2.patch
move-free-pages-between-lists-on-steal-avoid-unsafe-use-of-struct-pages-in-move_freepages-when-config_holes_in_zone-is-set.patch
move-free-pages-between-lists-on-steal-do-not-cross-section-boundary-when-moving-pages-between-mobility-lists.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
x86-specify-amount-of-kernel-memory-at-boot-time.patch
ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch
x86_64-specify-amount-of-kernel-memory-at-boot-time.patch
ia64-specify-amount-of-kernel-memory-at-boot-time.patch
ia64-specify-amount-of-kernel-memory-at-boot-time-fix.patch
add-documentation-for-additional-boot-parameter-and-sysctl.patch
lumpy-reclaim-v4.patch
lumpy-back-out-removal-of-active-check-in-isolate_lru_pages.patch
lumpy-only-count-taken-pages-as-scanned.patch
add-pfn_valid_within-helper-for-sub-max_order-hole-detection.patch
anti-fragmentation-switch-over-to-pfn_valid_within.patch
lumpy-move-to-using-pfn_valid_within.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy-fix.patch
remove-page_group_by_mobility.patch
do-not-disable-interrupts-when-reading-min_free_kbytes.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
