From: akpm@linux-foundation.org
Subject: + group-high-order-atomic-allocations.patch added to -mm tree
Date: Fri, 02 Mar 2007 13:41:43 -0800
Message-ID: <200703022141.l22Lfhx0019779@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42064 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030198AbXCBVls (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 16:41:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie


The patch titled
     Group high-order atomic allocations
has been added to the -mm tree.  Its filename is
     group-high-order-atomic-allocations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Group high-order atomic allocations
From: Mel Gorman <mel@csn.ul.ie>

In rare cases, the kernel needs to allocate a high-order block of pages
without sleeping.  For example, this is the case with e1000 cards configured
to use jumbo frames.  Migrating or reclaiming pages in this situation is not
an option.

This patch groups these allocations together as much as possible by adding a
new MIGRATE_TYPE.  The MIGRATE_HIGHATOMIC type are exactly what they sound
like.  Care is taken that pages of other migrate types do not use the same
blocks as high-order atomic allocations.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 +++-
 mm/page_alloc.c        |   36 ++++++++++++++++++++++++++++++------
 2 files changed, 33 insertions(+), 7 deletions(-)

diff -puN include/linux/mmzone.h~group-high-order-atomic-allocations include/linux/mmzone.h
--- a/include/linux/mmzone.h~group-high-order-atomic-allocations
+++ a/include/linux/mmzone.h
@@ -29,11 +29,13 @@
 #define MIGRATE_UNMOVABLE     0
 #define MIGRATE_RECLAIMABLE   1
 #define MIGRATE_MOVABLE       2
-#define MIGRATE_TYPES         3
+#define MIGRATE_HIGHATOMIC    3
+#define MIGRATE_TYPES         4
 #else
 #define MIGRATE_UNMOVABLE     0
 #define MIGRATE_UNRECLAIMABLE 0
 #define MIGRATE_MOVABLE       0
+#define MIGRATE_HIGHATOMIC    0
 #define MIGRATE_TYPES         1
 #endif
 
diff -puN mm/page_alloc.c~group-high-order-atomic-allocations mm/page_alloc.c
--- a/mm/page_alloc.c~group-high-order-atomic-allocations
+++ a/mm/page_alloc.c
@@ -148,10 +148,16 @@ static void set_pageblock_migratetype(st
 					PB_migrate, PB_migrate_end);
 }
 
-static inline int gfpflags_to_migratetype(gfp_t gfp_flags)
+static inline int allocflags_to_migratetype(gfp_t gfp_flags, int order)
 {
 	WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
 
+	/* Cluster high-order atomic allocations together */
+	if (unlikely(order > 0) &&
+			(!(gfp_flags & __GFP_WAIT) || in_interrupt()))
+		return MIGRATE_HIGHATOMIC;
+
+	/* Cluster based on mobility */
 	return (((gfp_flags & __GFP_MOVABLE) != 0) << 1) |
 		((gfp_flags & __GFP_RECLAIMABLE) != 0);
 }
@@ -166,7 +172,7 @@ static void set_pageblock_migratetype(st
 {
 }
 
-static inline int gfpflags_to_migratetype(gfp_t gfp_flags)
+static inline int allocflags_to_migratetype(gfp_t gfp_flags, int order)
 {
 	return MIGRATE_UNMOVABLE;
 }
@@ -666,9 +672,10 @@ static int prep_new_page(struct page *pa
  * the free lists for the desirable migrate type are depleted
  */
 static int fallbacks[MIGRATE_TYPES][MIGRATE_TYPES-1] = {
-	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE   },
-	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE   },
-	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE },
+	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE,  MIGRATE_HIGHATOMIC },
+	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE,  MIGRATE_HIGHATOMIC },
+	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE,MIGRATE_HIGHATOMIC },
+	[MIGRATE_HIGHATOMIC]  = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE,MIGRATE_MOVABLE},
 };
 
 /*
@@ -736,13 +743,24 @@ static struct page *__rmqueue_fallback(s
 	int current_order;
 	struct page *page;
 	int migratetype, i;
+	int nonatomic_fallback_atomic = 0;
 
+retry:
 	/* Find the largest possible block of pages in the other list */
 	for (current_order = MAX_ORDER-1; current_order >= order;
 						--current_order) {
 		for (i = 0; i < MIGRATE_TYPES - 1; i++) {
 			migratetype = fallbacks[start_migratetype][i];
 
+			/*
+			 * Make it hard to fallback to blocks used for
+			 * high-order atomic allocations
+			 */
+			if (migratetype == MIGRATE_HIGHATOMIC &&
+				start_migratetype != MIGRATE_UNMOVABLE &&
+				!nonatomic_fallback_atomic)
+				continue;
+
 			area = &(zone->free_area[current_order]);
 			if (list_empty(&area->free_list[migratetype]))
 				continue;
@@ -775,6 +793,12 @@ static struct page *__rmqueue_fallback(s
 		}
 	}
 
+	/* Allow fallback to high-order atomic blocks if memory is that low */
+	if (!nonatomic_fallback_atomic) {
+		nonatomic_fallback_atomic = 1;
+		goto retry;
+	}
+
 	return NULL;
 }
 #else
@@ -1074,7 +1098,7 @@ static struct page *buffered_rmqueue(str
 	struct page *page;
 	int cold = !!(gfp_flags & __GFP_COLD);
 	int cpu;
-	int migratetype = gfpflags_to_migratetype(gfp_flags);
+	int migratetype = allocflags_to_migratetype(gfp_flags, order);
 
 again:
 	cpu  = get_cpu();
_

Patches currently in -mm which might be from mel@csn.ul.ie are

add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
x86-specify-amount-of-kernel-memory-at-boot-time.patch
ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch
x86_64-specify-amount-of-kernel-memory-at-boot-time.patch
ia64-specify-amount-of-kernel-memory-at-boot-time.patch
add-documentation-for-additional-boot-parameter-and-sysctl.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
