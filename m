From: akpm@linux-foundation.org
Subject: + dont-group-high-order-atomic-allocations.patch added to -mm tree
Date: Thu, 19 Apr 2007 20:33:09 -0700
Message-ID: <200704200333.l3K3X9D3006059@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595AbXDTDdr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 23:33:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org


The patch titled
     don't group high order atomic allocations
has been added to the -mm tree.  Its filename is
     dont-group-high-order-atomic-allocations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: don't group high order atomic allocations
From: Mel Gorman <mel@csn.ul.ie>

Grouping high-order atomic allocations together was intended to allow
bursty users of atomic allocations to work such as e1000 in situations
where their preallocated buffers were depleted.  This did not work in at
least one case with a wireless network adapter needing order-1 allocations
frequently.  To resolve that, the free pages used for min_free_kbytes were
moved to separate contiguous blocks with the patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.

It is felt that keeping the free pages in the same contiguous blocks should
be sufficient for bursty short-lived high-order atomic allocations to
succeed, maybe even with the e1000.  Even if there is a failure, increasing
the value of min_free_kbytes will free pages as contiguous bloks in
contrast to the standard buddy allocator which makes no attempt to keep the
minimum number of free pages contiguous.

This patch backs out grouping high order atomic allocations together to
determine if it is really needed or not.  If a new report comes in about
high-order atomic allocations failing, the feature can be reintroduced to
determine if it fixes the problem or not.  As a side-effect, this patch
reduces by 1 the number of bits required to track the mobility type of
pages within a MAX_ORDER_NR_PAGES block.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h          |    5 +---
 include/linux/pageblock-flags.h |    2 -
 mm/page_alloc.c                 |   33 ++++--------------------------
 3 files changed, 8 insertions(+), 32 deletions(-)

diff -puN include/linux/mmzone.h~dont-group-high-order-atomic-allocations include/linux/mmzone.h
--- a/include/linux/mmzone.h~dont-group-high-order-atomic-allocations
+++ a/include/linux/mmzone.h
@@ -28,9 +28,8 @@
 #define MIGRATE_UNMOVABLE     0
 #define MIGRATE_RECLAIMABLE   1
 #define MIGRATE_MOVABLE       2
-#define MIGRATE_HIGHATOMIC    3
-#define MIGRATE_RESERVE       4
-#define MIGRATE_TYPES         5
+#define MIGRATE_RESERVE       3
+#define MIGRATE_TYPES         4
 
 #define for_each_migratetype_order(order, type) \
 	for (order = 0; order < MAX_ORDER; order++) \
diff -puN include/linux/pageblock-flags.h~dont-group-high-order-atomic-allocations include/linux/pageblock-flags.h
--- a/include/linux/pageblock-flags.h~dont-group-high-order-atomic-allocations
+++ a/include/linux/pageblock-flags.h
@@ -31,7 +31,7 @@
 
 /* Bit indices that affect a whole block of pages */
 enum pageblock_bits {
-	PB_range(PB_migrate, 3), /* 3 bits required for migrate types */
+	PB_range(PB_migrate, 2), /* 2 bits required for migrate types */
 	NR_PAGEBLOCK_BITS
 };
 
diff -puN mm/page_alloc.c~dont-group-high-order-atomic-allocations mm/page_alloc.c
--- a/mm/page_alloc.c~dont-group-high-order-atomic-allocations
+++ a/mm/page_alloc.c
@@ -167,11 +167,6 @@ static inline int allocflags_to_migratet
 	if (unlikely(page_group_by_mobility_disabled))
 		return MIGRATE_UNMOVABLE;
 
-	/* Cluster high-order atomic allocations together */
-	if (unlikely(order > 0) &&
-			(!(gfp_flags & __GFP_WAIT) || in_interrupt()))
-		return MIGRATE_HIGHATOMIC;
-
 	/* Cluster based on mobility */
 	return (((gfp_flags & __GFP_MOVABLE) != 0) << 1) |
 		((gfp_flags & __GFP_RECLAIMABLE) != 0);
@@ -690,11 +685,10 @@ static struct page *__rmqueue_smallest(s
  * the free lists for the desirable migrate type are depleted
  */
 static int fallbacks[MIGRATE_TYPES][MIGRATE_TYPES-1] = {
-	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE,   MIGRATE_HIGHATOMIC, MIGRATE_RESERVE },
-	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE,   MIGRATE_HIGHATOMIC, MIGRATE_RESERVE },
-	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE, MIGRATE_HIGHATOMIC, MIGRATE_RESERVE },
-	[MIGRATE_HIGHATOMIC]  = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE, MIGRATE_MOVABLE,    MIGRATE_RESERVE },
-	[MIGRATE_RESERVE]     = { MIGRATE_RESERVE,     MIGRATE_RESERVE,   MIGRATE_RESERVE,    MIGRATE_RESERVE }, /* Never used */
+	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE,   MIGRATE_RESERVE },
+	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE,   MIGRATE_RESERVE },
+	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE, MIGRATE_RESERVE },
+	[MIGRATE_RESERVE]     = { MIGRATE_RESERVE,     MIGRATE_RESERVE,   MIGRATE_RESERVE }, /* Never used */
 };
 
 /*
@@ -788,9 +782,7 @@ static struct page *__rmqueue_fallback(s
 	int current_order;
 	struct page *page;
 	int migratetype, i;
-	int nonatomic_fallback_atomic = 0;
 
-retry:
 	/* Find the largest possible block of pages in the other list */
 	for (current_order = MAX_ORDER-1; current_order >= order;
 						--current_order) {
@@ -800,14 +792,6 @@ retry:
 			/* MIGRATE_RESERVE handled later if necessary */
 			if (migratetype == MIGRATE_RESERVE)
 				continue;
-			/*
-			 * Make it hard to fallback to blocks used for
-			 * high-order atomic allocations
-			 */
-			if (migratetype == MIGRATE_HIGHATOMIC &&
-				start_migratetype != MIGRATE_UNMOVABLE &&
-				!nonatomic_fallback_atomic)
-				continue;
 
 			area = &(zone->free_area[current_order]);
 			if (list_empty(&area->free_list[migratetype]))
@@ -833,8 +817,7 @@ retry:
 								start_migratetype);
 
 				/* Claim the whole block if over half of it is free */
-				if ((pages << current_order) >= (1 << (MAX_ORDER-2)) &&
-						migratetype != MIGRATE_HIGHATOMIC)
+				if ((pages << current_order) >= (1 << (MAX_ORDER-2)))
 					set_pageblock_migratetype(page,
 								start_migratetype);
 
@@ -856,12 +839,6 @@ retry:
 		}
 	}
 
-	/* Allow fallback to high-order atomic blocks if memory is that low */
-	if (!nonatomic_fallback_atomic) {
-		nonatomic_fallback_atomic = 1;
-		goto retry;
-	}
-
 	/* Use MIGRATE_RESERVE rather than fail an allocation */
 	return __rmqueue_smallest(zone, order, MIGRATE_RESERVE);
 }
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
dont-group-high-order-atomic-allocations.patch
do-not-disable-interrupts-when-reading-min_free_kbytes.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
