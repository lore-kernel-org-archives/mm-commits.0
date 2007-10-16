From: akpm@linux-foundation.org
Subject: - group-high-order-atomic-allocations.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:34:44 -0700
Message-ID: <200710162034.l9GKYiuN014969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52913 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965464AbXJPVjz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:39:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Group high-order atomic allocations
has been removed from the -mm tree.  Its filename was
     group-high-order-atomic-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -37,11 +37,13 @@
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
@@ -170,10 +170,16 @@ static void set_pageblock_migratetype(st
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
@@ -188,7 +194,7 @@ static void set_pageblock_migratetype(st
 {
 }
 
-static inline int gfpflags_to_migratetype(gfp_t gfp_flags)
+static inline int allocflags_to_migratetype(gfp_t gfp_flags, int order)
 {
 	return MIGRATE_UNMOVABLE;
 }
@@ -679,9 +685,10 @@ static int prep_new_page(struct page *pa
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
@@ -758,13 +765,24 @@ static struct page *__rmqueue_fallback(s
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
@@ -797,6 +815,12 @@ static struct page *__rmqueue_fallback(s
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
@@ -1058,7 +1082,7 @@ static struct page *buffered_rmqueue(str
 	struct page *page;
 	int cold = !!(gfp_flags & __GFP_COLD);
 	int cpu;
-	int migratetype = gfpflags_to_migratetype(gfp_flags);
+	int migratetype = allocflags_to_migratetype(gfp_flags, order);
 
 again:
 	cpu  = get_cpu();
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
