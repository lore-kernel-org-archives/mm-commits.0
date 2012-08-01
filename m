From: akpm@linux-foundation.org
Subject: [merged] mm-have-order-0-compaction-start-off-where-it-left.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:14:11 -0700
Message-ID: <20120801201412.378A15C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:53643 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945Ab2HAUOP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:14:15 -0400
Received: by lagr15 with SMTP id r15so343830lag.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:14:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, jaschut@sandia.gov, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: have order > 0 compaction start off where it left
has been removed from the -mm tree.  Its filename was
     mm-have-order-0-compaction-start-off-where-it-left.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm: have order > 0 compaction start off where it left

Order > 0 compaction stops when enough free pages of the correct page
order have been coalesced.  When doing subsequent higher order
allocations, it is possible for compaction to be invoked many times.

However, the compaction code always starts out looking for things to
compact at the start of the zone, and for free pages to compact things to
at the end of the zone.

This can cause quadratic behaviour, with isolate_freepages starting at the
end of the zone each time, even though previous invocations of the
compaction code already filled up all free memory on that end of the zone.

This can cause isolate_freepages to take enormous amounts of CPU with
certain workloads on larger memory systems.

The obvious solution is to have isolate_freepages remember where it left
off last time, and continue at that point the next time it gets invoked
for an order > 0 compaction.  This could cause compaction to fail if
cc->free_pfn and cc->migrate_pfn are close together initially, in that
case we restart from the end of the zone and try once more.

Forced full (order == -1) compactions are left alone.

[akpm@linux-foundation.org: checkpatch fixes]
[akpm@linux-foundation.org: s/laste/last/, use 80 cols]
Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Jim Schutt <jaschut@sandia.gov>
Tested-by: Jim Schutt <jaschut@sandia.gov>
Cc: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 ++
 mm/compaction.c        |   63 +++++++++++++++++++++++++++++++++++----
 mm/internal.h          |    6 +++
 mm/page_alloc.c        |    5 +++
 4 files changed, 73 insertions(+), 5 deletions(-)

diff -puN include/linux/mmzone.h~mm-have-order-0-compaction-start-off-where-it-left include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-have-order-0-compaction-start-off-where-it-left
+++ a/include/linux/mmzone.h
@@ -368,6 +368,10 @@ struct zone {
 	 */
 	spinlock_t		lock;
 	int                     all_unreclaimable; /* All pages pinned */
+#if defined CONFIG_COMPACTION || defined CONFIG_CMA
+	/* pfn where the last incremental compaction isolated free pages */
+	unsigned long		compact_cached_free_pfn;
+#endif
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/* see spanned/present_pages for more description */
 	seqlock_t		span_seqlock;
diff -puN mm/compaction.c~mm-have-order-0-compaction-start-off-where-it-left mm/compaction.c
--- a/mm/compaction.c~mm-have-order-0-compaction-start-off-where-it-left
+++ a/mm/compaction.c
@@ -422,6 +422,17 @@ static void isolate_freepages(struct zon
 					pfn -= pageblock_nr_pages) {
 		unsigned long isolated;
 
+		/*
+		 * Skip ahead if another thread is compacting in the area
+		 * simultaneously. If we wrapped around, we can only skip
+		 * ahead if zone->compact_cached_free_pfn also wrapped to
+		 * above our starting point.
+		 */
+		if (cc->order > 0 && (!cc->wrapped ||
+				      zone->compact_cached_free_pfn >
+				      cc->start_free_pfn))
+			pfn = min(pfn, zone->compact_cached_free_pfn);
+
 		if (!pfn_valid(pfn))
 			continue;
 
@@ -461,8 +472,11 @@ static void isolate_freepages(struct zon
 		 * looking for free pages, the search will restart here as
 		 * page migration may have returned some pages to the allocator
 		 */
-		if (isolated)
+		if (isolated) {
 			high_pfn = max(high_pfn, pfn);
+			if (cc->order > 0)
+				zone->compact_cached_free_pfn = high_pfn;
+		}
 	}
 
 	/* split_free_page does not map the pages */
@@ -556,6 +570,20 @@ static isolate_migrate_t isolate_migrate
 	return ISOLATE_SUCCESS;
 }
 
+/*
+ * Returns the start pfn of the last page block in a zone.  This is the starting
+ * point for full compaction of a zone.  Compaction searches for free pages from
+ * the end of each zone, while isolate_freepages_block scans forward inside each
+ * page block.
+ */
+static unsigned long start_free_pfn(struct zone *zone)
+{
+	unsigned long free_pfn;
+	free_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	free_pfn &= ~(pageblock_nr_pages-1);
+	return free_pfn;
+}
+
 static int compact_finished(struct zone *zone,
 			    struct compact_control *cc)
 {
@@ -565,8 +593,26 @@ static int compact_finished(struct zone 
 	if (fatal_signal_pending(current))
 		return COMPACT_PARTIAL;
 
-	/* Compaction run completes if the migrate and free scanner meet */
-	if (cc->free_pfn <= cc->migrate_pfn)
+	/*
+	 * A full (order == -1) compaction run starts at the beginning and
+	 * end of a zone; it completes when the migrate and free scanner meet.
+	 * A partial (order > 0) compaction can start with the free scanner
+	 * at a random point in the zone, and may have to restart.
+	 */
+	if (cc->free_pfn <= cc->migrate_pfn) {
+		if (cc->order > 0 && !cc->wrapped) {
+			/* We started partway through; restart at the end. */
+			unsigned long free_pfn = start_free_pfn(zone);
+			zone->compact_cached_free_pfn = free_pfn;
+			cc->free_pfn = free_pfn;
+			cc->wrapped = 1;
+			return COMPACT_CONTINUE;
+		}
+		return COMPACT_COMPLETE;
+	}
+
+	/* We wrapped around and ended up where we started. */
+	if (cc->wrapped && cc->free_pfn <= cc->start_free_pfn)
 		return COMPACT_COMPLETE;
 
 	/*
@@ -664,8 +710,15 @@ static int compact_zone(struct zone *zon
 
 	/* Setup to move all movable pages to the end of the zone */
 	cc->migrate_pfn = zone->zone_start_pfn;
-	cc->free_pfn = cc->migrate_pfn + zone->spanned_pages;
-	cc->free_pfn &= ~(pageblock_nr_pages-1);
+
+	if (cc->order > 0) {
+		/* Incremental compaction. Start where the last one stopped. */
+		cc->free_pfn = zone->compact_cached_free_pfn;
+		cc->start_free_pfn = cc->free_pfn;
+	} else {
+		/* Order == -1 starts at the end of the zone. */
+		cc->free_pfn = start_free_pfn(zone);
+	}
 
 	migrate_prep_local();
 
diff -puN mm/internal.h~mm-have-order-0-compaction-start-off-where-it-left mm/internal.h
--- a/mm/internal.h~mm-have-order-0-compaction-start-off-where-it-left
+++ a/mm/internal.h
@@ -118,8 +118,14 @@ struct compact_control {
 	unsigned long nr_freepages;	/* Number of isolated free pages */
 	unsigned long nr_migratepages;	/* Number of pages to migrate */
 	unsigned long free_pfn;		/* isolate_freepages search base */
+	unsigned long start_free_pfn;	/* where we started the search */
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
 	bool sync;			/* Synchronous migration */
+	bool wrapped;			/* Order > 0 compactions are
+					   incremental, once free_pfn
+					   and migrate_pfn meet, we restart
+					   from the top of the zone;
+					   remember we wrapped around. */
 
 	int order;			/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
diff -puN mm/page_alloc.c~mm-have-order-0-compaction-start-off-where-it-left mm/page_alloc.c
--- a/mm/page_alloc.c~mm-have-order-0-compaction-start-off-where-it-left
+++ a/mm/page_alloc.c
@@ -4397,6 +4397,11 @@ static void __paginginit free_area_init_
 
 		zone->spanned_pages = size;
 		zone->present_pages = realsize;
+#if defined CONFIG_COMPACTION || defined CONFIG_CMA
+		zone->compact_cached_free_pfn = zone->zone_start_pfn +
+						zone->spanned_pages;
+		zone->compact_cached_free_pfn &= ~(pageblock_nr_pages-1);
+#endif
 #ifdef CONFIG_NUMA
 		zone->node = nid;
 		zone->min_unmapped_pages = (realsize*sysctl_min_unmapped_ratio)
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
linux-next.patch
mm-remove-__gfp_no_kswapd.patch
remove-__gfp_no_kswapd-fixes.patch
remove-__gfp_no_kswapd-fixes-fix.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-performance-and-correctness-test.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch
rbtree-rb_erase-updates-and-comments.patch
rbtree-optimize-fetching-of-sibling-node.patch

