From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-enhance-compaction-finish-condition.patch
 removed from -mm tree
Date: Wed, 15 Apr 2015 12:09:39 -0700
Message-ID: <552eb773.Z+cPHX54cqAw1JbU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148AbbDOTJk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:09:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: enhance compaction finish condition
has been removed from the -mm tree.  Its filename was
     mm-compaction-enhance-compaction-finish-condition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: enhance compaction finish condition

Compaction has anti fragmentation algorithm.  It is that freepage should
be more than pageblock order to finish the compaction if we don't find any
freepage in requested migratetype buddy list.  This is for mitigating
fragmentation, but, there is a lack of migratetype consideration and it is
too excessive compared to page allocator's anti fragmentation algorithm.

Not considering migratetype would cause premature finish of compaction. 
For example, if allocation request is for unmovable migratetype, freepage
with CMA migratetype doesn't help that allocation and compaction should
not be stopped.  But, current logic regards this situation as compaction
is no longer needed, so finish the compaction.

Secondly, condition is too excessive compared to page allocator's logic. 
We can steal freepage from other migratetype and change pageblock
migratetype on more relaxed conditions in page allocator.  This is
designed to prevent fragmentation and we can use it here.  Imposing hard
constraint only to the compaction doesn't help much in this case since
page allocator would cause fragmentation again.

To solve these problems, this patch borrows anti fragmentation logic from
page allocator.  It will reduce premature compaction finish in some cases
and reduce excessive compaction work.

stress-highalloc test in mmtests with non movable order 7 allocation shows
considerable increase of compaction success rate.

Compaction success rate (Compaction success * 100 / Compaction stalls, %)
31.82 : 42.20

I tested it on non-reboot 5 runs stress-highalloc benchmark and found that
there is no more degradation on allocation success rate than before.  That
roughly means that this patch doesn't result in more fragmentations.

Vlastimil suggests additional idea that we only test for fallbacks when
migration scanner has scanned a whole pageblock.  It looked good for
fragmentation because chance of stealing increase due to making more free
pages in certain pageblock.  So, I tested it, but, it results in decreased
compaction success rate, roughly 38.00.  I guess the reason that if system
is low memory condition, watermark check could be failed due to not enough
order 0 free page and so, sometimes, we can't reach a fallback check
although migrate_pfn is aligned to pageblock_nr_pages.  I can insert code
to cope with this situation but it makes code more complicated so I don't
include his idea at this patch.

[akpm@linux-foundation.org: fix CONFIG_CMA=n build]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   15 +++++++++++++--
 mm/internal.h   |    2 ++
 mm/page_alloc.c |   19 ++++++++++++++-----
 3 files changed, 29 insertions(+), 7 deletions(-)

diff -puN mm/compaction.c~mm-compaction-enhance-compaction-finish-condition mm/compaction.c
--- a/mm/compaction.c~mm-compaction-enhance-compaction-finish-condition
+++ a/mm/compaction.c
@@ -1174,13 +1174,24 @@ static int __compact_finished(struct zon
 	/* Direct compactor: Is a suitable page free? */
 	for (order = cc->order; order < MAX_ORDER; order++) {
 		struct free_area *area = &zone->free_area[order];
+		bool can_steal;
 
 		/* Job done if page is free of the right migratetype */
 		if (!list_empty(&area->free_list[migratetype]))
 			return COMPACT_PARTIAL;
 
-		/* Job done if allocation would set block type */
-		if (order >= pageblock_order && area->nr_free)
+#ifdef CONFIG_CMA
+		/* MIGRATE_MOVABLE can fallback on MIGRATE_CMA */
+		if (migratetype == MIGRATE_MOVABLE &&
+			!list_empty(&area->free_list[MIGRATE_CMA]))
+			return COMPACT_PARTIAL;
+#endif
+		/*
+		 * Job done if allocation would steal freepages from
+		 * other migratetype buddy lists.
+		 */
+		if (find_suitable_fallback(area, order, migratetype,
+						true, &can_steal) != -1)
 			return COMPACT_PARTIAL;
 	}
 
diff -puN mm/internal.h~mm-compaction-enhance-compaction-finish-condition mm/internal.h
--- a/mm/internal.h~mm-compaction-enhance-compaction-finish-condition
+++ a/mm/internal.h
@@ -200,6 +200,8 @@ isolate_freepages_range(struct compact_c
 unsigned long
 isolate_migratepages_range(struct compact_control *cc,
 			   unsigned long low_pfn, unsigned long end_pfn);
+int find_suitable_fallback(struct free_area *area, unsigned int order,
+			int migratetype, bool only_stealable, bool *can_steal);
 
 #endif
 
diff -puN mm/page_alloc.c~mm-compaction-enhance-compaction-finish-condition mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-enhance-compaction-finish-condition
+++ a/mm/page_alloc.c
@@ -1194,9 +1194,14 @@ static void steal_suitable_fallback(stru
 		set_pageblock_migratetype(page, start_type);
 }
 
-/* Check whether there is a suitable fallback freepage with requested order. */
-static int find_suitable_fallback(struct free_area *area, unsigned int order,
-					int migratetype, bool *can_steal)
+/*
+ * Check whether there is a suitable fallback freepage with requested order.
+ * If only_stealable is true, this function returns fallback_mt only if
+ * we can steal other freepages all together. This would help to reduce
+ * fragmentation due to mixed migratetype pages in one pageblock.
+ */
+int find_suitable_fallback(struct free_area *area, unsigned int order,
+			int migratetype, bool only_stealable, bool *can_steal)
 {
 	int i;
 	int fallback_mt;
@@ -1216,7 +1221,11 @@ static int find_suitable_fallback(struct
 		if (can_steal_fallback(order, migratetype))
 			*can_steal = true;
 
-		return fallback_mt;
+		if (!only_stealable)
+			return fallback_mt;
+
+		if (*can_steal)
+			return fallback_mt;
 	}
 
 	return -1;
@@ -1238,7 +1247,7 @@ __rmqueue_fallback(struct zone *zone, un
 				--current_order) {
 		area = &(zone->free_area[current_order]);
 		fallback_mt = find_suitable_fallback(area, current_order,
-				start_migratetype, &can_steal);
+				start_migratetype, false, &can_steal);
 		if (fallback_mt == -1)
 			continue;
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
slub-bulk-allocation-from-per-cpu-partial-pages.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
mm-compaction-reset-compaction-scanner-positions.patch
hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure.patch
hugetlbfs-add-minimum-size-accounting-to-subpools.patch
hugetlbfs-accept-subpool-min_size-mount-option-and-setup-accordingly.patch
hugetlbfs-document-min_size-mount-option-and-cleanup.patch
mm-vmalloc-fix-possible-exhaustion-of-vmalloc-space-caused-by-vm_map_ram-allocator.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-vmalloc-get-rid-of-dirty-bitmap-inside-vmap_block-structure.patch
mm-cma-add-trace-events-for-cma-allocations-and-freeings.patch
mm-cma-add-trace-events-for-cma-allocations-and-freeings-fix.patch
mm-cma-add-functions-to-get-region-pages-counters.patch
mm-cma-add-functions-to-get-region-pages-counters-fix.patch
mm-cma-add-functions-to-get-region-pages-counters-fix-2.patch
mm-cma-add-functions-to-get-region-pages-counters-fix-3.patch
mm-cma_debugc-remove-blank-lines-before-define_simple_attribute.patch
zsmalloc-decouple-handle-and-object.patch
zsmalloc-factor-out-obj_.patch
zsmalloc-support-compaction.patch
zsmalloc-adjust-zs_almost_full.patch
zram-support-compaction.patch
zsmalloc-record-handle-in-page-private-for-huge-object.patch
zsmalloc-add-fullness-into-stat.patch
zsmalloc-zsmalloc-documentation.patch

