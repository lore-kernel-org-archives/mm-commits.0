From: akpm@linux-foundation.org
Subject: [merged] mm-rename-allocflags_to_migratetype-for-clarity.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:19:49 -0700
Message-ID: <543c17c5.3bg5wzx0gpwaDghQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbaJMSTt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:19:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, vbabka@suse.cz, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename allocflags_to_migratetype for clarity
has been removed from the -mm tree.  Its filename was
     mm-rename-allocflags_to_migratetype-for-clarity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm: rename allocflags_to_migratetype for clarity

The page allocator has gfp flags (like __GFP_WAIT) and alloc flags (like
ALLOC_CPUSET) that have separate semantics.

The function allocflags_to_migratetype() actually takes gfp flags, not
alloc flags, and returns a migratetype.  Rename it to
gfpflags_to_migratetype().

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 mm/compaction.c     |    4 ++--
 mm/page_alloc.c     |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/gfp.h~mm-rename-allocflags_to_migratetype-for-clarity include/linux/gfp.h
--- a/include/linux/gfp.h~mm-rename-allocflags_to_migratetype-for-clarity
+++ a/include/linux/gfp.h
@@ -156,7 +156,7 @@ struct vm_area_struct;
 #define GFP_DMA32	__GFP_DMA32
 
 /* Convert GFP flags to their corresponding migrate type */
-static inline int allocflags_to_migratetype(gfp_t gfp_flags)
+static inline int gfpflags_to_migratetype(const gfp_t gfp_flags)
 {
 	WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
 
diff -puN mm/compaction.c~mm-rename-allocflags_to_migratetype-for-clarity mm/compaction.c
--- a/mm/compaction.c~mm-rename-allocflags_to_migratetype-for-clarity
+++ a/mm/compaction.c
@@ -1242,7 +1242,7 @@ static unsigned long compact_zone_order(
 		.nr_freepages = 0,
 		.nr_migratepages = 0,
 		.order = order,
-		.migratetype = allocflags_to_migratetype(gfp_mask),
+		.migratetype = gfpflags_to_migratetype(gfp_mask),
 		.zone = zone,
 		.mode = mode,
 	};
@@ -1294,7 +1294,7 @@ unsigned long try_to_compact_pages(struc
 		return COMPACT_SKIPPED;
 
 #ifdef CONFIG_CMA
-	if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
+	if (gfpflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
 		alloc_flags |= ALLOC_CMA;
 #endif
 	/* Compact each zone in the list */
diff -puN mm/page_alloc.c~mm-rename-allocflags_to_migratetype-for-clarity mm/page_alloc.c
--- a/mm/page_alloc.c~mm-rename-allocflags_to_migratetype-for-clarity
+++ a/mm/page_alloc.c
@@ -2523,7 +2523,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 			alloc_flags |= ALLOC_NO_WATERMARKS;
 	}
 #ifdef CONFIG_CMA
-	if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
+	if (gfpflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
 		alloc_flags |= ALLOC_CMA;
 #endif
 	return alloc_flags;
@@ -2786,7 +2786,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	struct zone *preferred_zone;
 	struct zoneref *preferred_zoneref;
 	struct page *page = NULL;
-	int migratetype = allocflags_to_migratetype(gfp_mask);
+	int migratetype = gfpflags_to_migratetype(gfp_mask);
 	unsigned int cpuset_mems_cookie;
 	int alloc_flags = ALLOC_WMARK_LOW|ALLOC_CPUSET|ALLOC_FAIR;
 	int classzone_idx;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

