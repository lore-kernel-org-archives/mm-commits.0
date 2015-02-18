From: akpm@linux-foundation.org
Subject: + mm-compaction-enhance-compaction-finish-condition.patch added
 to -mm tree
Date: Wed, 18 Feb 2015 15:10:01 -0800
Message-ID: <54e51bc9.A/S14VgYqmA692qK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbbBRXKD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 18:10:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: enhance compaction finish condition
has been added to the -mm tree.  Its filename is
     mm-compaction-enhance-compaction-finish-condition.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-enhance-compaction-finish-condition.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-enhance-compaction-finish-condition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   14 ++++++++++++--
 mm/internal.h   |    2 ++
 mm/page_alloc.c |   19 ++++++++++++++-----
 3 files changed, 28 insertions(+), 7 deletions(-)

diff -puN mm/compaction.c~mm-compaction-enhance-compaction-finish-condition mm/compaction.c
--- a/mm/compaction.c~mm-compaction-enhance-compaction-finish-condition
+++ a/mm/compaction.c
@@ -1174,13 +1174,23 @@ static int __compact_finished(struct zon
 	/* Direct compactor: Is a suitable page free? */
 	for (order = cc->order; order < MAX_ORDER; order++) {
 		struct free_area *area = &zone->free_area[order];
+		bool can_steal;
 
 		/* Job done if page is free of the right migratetype */
 		if (!list_empty(&area->free_list[migratetype]))
 			return COMPACT_PARTIAL;
 
-		/* Job done if allocation would set block type */
-		if (order >= pageblock_order && area->nr_free)
+		/* MIGRATE_MOVABLE can fallback on MIGRATE_CMA */
+		if (migratetype == MIGRATE_MOVABLE &&
+			!list_empty(&area->free_list[MIGRATE_CMA]))
+			return COMPACT_PARTIAL;
+
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
mm-nommu-fix-memory-leak.patch
zram-use-proper-type-to-update-max_used_pages.patch
mm-cma-debugfs-interface.patch
mm-cma-allocation-trigger.patch
mm-cma-release-trigger.patch
mm-cma-allocation-trigger-fix.patch
mm-cma-change-fallback-behaviour-for-cma-freepage.patch
mm-page_alloc-factor-out-fallback-freepage-checking.patch
mm-compaction-enhance-compaction-finish-condition.patch

