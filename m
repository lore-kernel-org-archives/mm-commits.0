From: akpm@linux-foundation.org
Subject: + cma-fix-watermark-checking.patch added to -mm tree
Date: Wed, 19 Sep 2012 12:51:51 -0700
Message-ID: <20120919195152.AD4775C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:63979 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab2ISTv4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Sep 2012 15:51:56 -0400
Received: by eaac1 with SMTP id c1so85719eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Sep 2012 12:51:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: b.zolnierkie@samsung.com, hughd@google.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org


The patch titled
     Subject: cma: fix watermark checking
has been added to the -mm tree.  Its filename is
     cma-fix-watermark-checking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: cma: fix watermark checking

* Add ALLOC_CMA alloc flag and pass it to [__]zone_watermark_ok()
  (from Minchan Kim).

* During watermark check decrease available free pages number by
  free CMA pages number if necessary (unmovable allocations cannot
  use pages from CMA areas).

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   15 +++++++++++++++
 mm/compaction.c        |    8 +++++++-
 mm/page_alloc.c        |   30 ++++++++++++++----------------
 3 files changed, 36 insertions(+), 17 deletions(-)

diff -puN include/linux/mmzone.h~cma-fix-watermark-checking include/linux/mmzone.h
--- a/include/linux/mmzone.h~cma-fix-watermark-checking
+++ a/include/linux/mmzone.h
@@ -233,6 +233,21 @@ enum zone_watermarks {
 #define low_wmark_pages(z) (z->watermark[WMARK_LOW])
 #define high_wmark_pages(z) (z->watermark[WMARK_HIGH])
 
+/* The ALLOC_WMARK bits are used as an index to zone->watermark */
+#define ALLOC_WMARK_MIN		WMARK_MIN
+#define ALLOC_WMARK_LOW		WMARK_LOW
+#define ALLOC_WMARK_HIGH	WMARK_HIGH
+#define ALLOC_NO_WATERMARKS	0x04 /* don't check watermarks at all */
+
+/* Mask to get the watermark bits */
+#define ALLOC_WMARK_MASK	(ALLOC_NO_WATERMARKS-1)
+
+#define ALLOC_HARDER		0x10 /* try to alloc harder */
+#define ALLOC_HIGH		0x20 /* __GFP_HIGH set */
+#define ALLOC_CPUSET		0x40 /* check for correct cpuset */
+
+#define ALLOC_CMA		0x80
+
 struct per_cpu_pages {
 	int count;		/* number of pages in the list */
 	int high;		/* high watermark, emptying needed */
diff -puN mm/compaction.c~cma-fix-watermark-checking mm/compaction.c
--- a/mm/compaction.c~cma-fix-watermark-checking
+++ a/mm/compaction.c
@@ -934,6 +934,7 @@ unsigned long try_to_compact_pages(struc
 	struct zoneref *z;
 	struct zone *zone;
 	int rc = COMPACT_SKIPPED;
+	int alloc_flags = 0;
 
 	/* Check if the GFP flags allow compaction */
 	if (!order || !may_enter_fs || !may_perform_io)
@@ -941,6 +942,10 @@ unsigned long try_to_compact_pages(struc
 
 	count_vm_event(COMPACTSTALL);
 
+#ifdef CONFIG_CMA
+	if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
+		alloc_flags |= ALLOC_CMA;
+#endif
 	/* Compact each zone in the list */
 	for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
 								nodemask) {
@@ -951,7 +956,8 @@ unsigned long try_to_compact_pages(struc
 		rc = max(status, rc);
 
 		/* If a normal allocation would succeed, stop compacting */
-		if (zone_watermark_ok(zone, order, low_wmark_pages(zone), 0, 0))
+		if (zone_watermark_ok(zone, order, low_wmark_pages(zone), 0,
+				      alloc_flags))
 			break;
 	}
 
diff -puN mm/page_alloc.c~cma-fix-watermark-checking mm/page_alloc.c
--- a/mm/page_alloc.c~cma-fix-watermark-checking
+++ a/mm/page_alloc.c
@@ -1540,19 +1540,6 @@ failed:
 	return NULL;
 }
 
-/* The ALLOC_WMARK bits are used as an index to zone->watermark */
-#define ALLOC_WMARK_MIN		WMARK_MIN
-#define ALLOC_WMARK_LOW		WMARK_LOW
-#define ALLOC_WMARK_HIGH	WMARK_HIGH
-#define ALLOC_NO_WATERMARKS	0x04 /* don't check watermarks at all */
-
-/* Mask to get the watermark bits */
-#define ALLOC_WMARK_MASK	(ALLOC_NO_WATERMARKS-1)
-
-#define ALLOC_HARDER		0x10 /* try to alloc harder */
-#define ALLOC_HIGH		0x20 /* __GFP_HIGH set */
-#define ALLOC_CPUSET		0x40 /* check for correct cpuset */
-
 #ifdef CONFIG_FAIL_PAGE_ALLOC
 
 static struct {
@@ -1647,7 +1634,10 @@ static bool __zone_watermark_ok(struct z
 		min -= min / 2;
 	if (alloc_flags & ALLOC_HARDER)
 		min -= min / 4;
-
+#ifdef CONFIG_CMA
+	if (!(alloc_flags & ALLOC_CMA))
+		free_pages -= zone_page_state(z, NR_FREE_CMA_PAGES);
+#endif
 	if (free_pages <= min + lowmem_reserve)
 		return false;
 	for (o = 0; o < order; o++) {
@@ -2361,7 +2351,10 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 				 unlikely(test_thread_flag(TIF_MEMDIE))))
 			alloc_flags |= ALLOC_NO_WATERMARKS;
 	}
-
+#ifdef CONFIG_CMA
+	if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
+		alloc_flags |= ALLOC_CMA;
+#endif
 	return alloc_flags;
 }
 
@@ -2586,6 +2579,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	struct page *page = NULL;
 	int migratetype = allocflags_to_migratetype(gfp_mask);
 	unsigned int cpuset_mems_cookie;
+	int alloc_flags = ALLOC_WMARK_LOW|ALLOC_CPUSET;
 
 	gfp_mask &= gfp_allowed_mask;
 
@@ -2614,9 +2608,13 @@ retry_cpuset:
 	if (!preferred_zone)
 		goto out;
 
+#ifdef CONFIG_CMA
+	if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
+		alloc_flags |= ALLOC_CMA;
+#endif
 	/* First allocation attempt */
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
-			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET,
+			zonelist, high_zoneidx, alloc_flags,
 			preferred_zone, migratetype);
 	if (unlikely(!page))
 		page = __alloc_pages_slowpath(gfp_mask, order,
_

Patches currently in -mm which might be from b.zolnierkie@samsung.com are

mm-fix-tracing-in-free_pcppages_bulk.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-fix-counting-of-isolated-pages.patch
cma-count-free-cma-pages.patch
cma-count-free-cma-pages-fix.patch
cma-fix-watermark-checking.patch

