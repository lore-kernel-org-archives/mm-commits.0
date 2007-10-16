From: akpm@linux-foundation.org
Subject: - dont-group-high-order-atomic-allocations.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:35:00 -0700
Message-ID: <200710162035.l9GKZ0ME015010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52127 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966215AbXJPVtF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:49:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     don't group high order atomic allocations
has been removed from the -mm tree.  Its filename was
     dont-group-high-order-atomic-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 mm/page_alloc.c                 |   37 +++++-------------------------
 3 files changed, 10 insertions(+), 34 deletions(-)

diff -puN include/linux/mmzone.h~dont-group-high-order-atomic-allocations include/linux/mmzone.h
--- a/include/linux/mmzone.h~dont-group-high-order-atomic-allocations
+++ a/include/linux/mmzone.h
@@ -36,9 +36,8 @@
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
@@ -174,18 +174,13 @@ static void set_pageblock_migratetype(st
 					PB_migrate, PB_migrate_end);
 }
 
-static inline int allocflags_to_migratetype(gfp_t gfp_flags, int order)
+static inline int allocflags_to_migratetype(gfp_t gfp_flags)
 {
 	WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
 
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
@@ -706,11 +701,10 @@ static struct page *__rmqueue_smallest(s
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
@@ -804,9 +798,7 @@ static struct page *__rmqueue_fallback(s
 	int current_order;
 	struct page *page;
 	int migratetype, i;
-	int nonatomic_fallback_atomic = 0;
 
-retry:
 	/* Find the largest possible block of pages in the other list */
 	for (current_order = MAX_ORDER-1; current_order >= order;
 						--current_order) {
@@ -816,14 +808,6 @@ retry:
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
@@ -849,8 +833,7 @@ retry:
 								start_migratetype);
 
 				/* Claim the whole block if over half of it is free */
-				if ((pages << current_order) >= (1 << (MAX_ORDER-2)) &&
-						migratetype != MIGRATE_HIGHATOMIC)
+				if ((pages << current_order) >= (1 << (MAX_ORDER-2)))
 					set_pageblock_migratetype(page,
 								start_migratetype);
 
@@ -872,12 +855,6 @@ retry:
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
@@ -1112,7 +1089,7 @@ static struct page *buffered_rmqueue(str
 	struct page *page;
 	int cold = !!(gfp_flags & __GFP_COLD);
 	int cpu;
-	int migratetype = allocflags_to_migratetype(gfp_flags, order);
+	int migratetype = allocflags_to_migratetype(gfp_flags);
 
 again:
 	cpu  = get_cpu();
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
