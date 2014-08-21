From: akpm@linux-foundation.org
Subject: + mm-rename-allocflags_to_migratetype-for-clarity.patch added to
 -mm tree
Date: Thu, 21 Aug 2014 15:22:10 -0700
Message-ID: <53f67112.CT+oE179kfHWi8id%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:44525 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbaHUWWL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Aug 2014 18:22:11 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so2681564pde.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2014 15:22:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, vbabka@suse.cz, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename allocflags_to_migratetype for clarity
has been added to the -mm tree.  Its filename is
     mm-rename-allocflags_to_migratetype-for-clarity.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rename-allocflags_to_migratetype-for-clarity.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-allocflags_to_migratetype-for-clarity.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1245,7 +1245,7 @@ static unsigned long compact_zone_order(
 		.nr_freepages = 0,
 		.nr_migratepages = 0,
 		.order = order,
-		.migratetype = allocflags_to_migratetype(gfp_mask),
+		.migratetype = gfpflags_to_migratetype(gfp_mask),
 		.zone = zone,
 		.mode = mode,
 	};
@@ -1297,7 +1297,7 @@ unsigned long try_to_compact_pages(struc
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

x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
memory-hotplug-add-sysfs-zones_online_to-attribute.patch
mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

