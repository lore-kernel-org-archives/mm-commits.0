From: akpm@linux-foundation.org
Subject: [folded-dropped] cma-fix-watermark-checking-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:09:15 -0700
Message-ID: <20121008230916.1030C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:44752 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab2JHXJR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:09:17 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so449896yhl.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:09:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: b.zolnierkie@samsung.com, hughd@google.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cma: fix watermark checking cleanup
has been removed from the -mm tree.  Its filename was
     cma-fix-watermark-checking-fix.patch

This patch was dropped because it was folded into cma-fix-watermark-checking.patch

------------------------------------------------------
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: cma: fix watermark checking cleanup

Changes:
* document ALLOC_CMA
* add comment to __zone_watermark_ok()
* move ALLOC_* defines to mm/internal.h

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   15 ---------------
 mm/internal.h          |   14 ++++++++++++++
 mm/page_alloc.c        |    1 +
 3 files changed, 15 insertions(+), 15 deletions(-)

diff -puN include/linux/mmzone.h~cma-fix-watermark-checking-fix include/linux/mmzone.h
--- a/include/linux/mmzone.h~cma-fix-watermark-checking-fix
+++ a/include/linux/mmzone.h
@@ -232,21 +232,6 @@ enum zone_watermarks {
 #define low_wmark_pages(z) (z->watermark[WMARK_LOW])
 #define high_wmark_pages(z) (z->watermark[WMARK_HIGH])
 
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
-#define ALLOC_CMA		0x80
-
 struct per_cpu_pages {
 	int count;		/* number of pages in the list */
 	int high;		/* high watermark, emptying needed */
diff -puN mm/internal.h~cma-fix-watermark-checking-fix mm/internal.h
--- a/mm/internal.h~cma-fix-watermark-checking-fix
+++ a/mm/internal.h
@@ -358,4 +358,18 @@ extern unsigned long vm_mmap_pgoff(struc
 extern void set_pageblock_order(void);
 unsigned long reclaim_clean_pages_from_list(struct zone *zone,
 					    struct list_head *page_list);
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
+#define ALLOC_CMA		0x80 /* allow allocations from CMA areas */
+
 #endif	/* __MM_INTERNAL_H */
diff -puN mm/page_alloc.c~cma-fix-watermark-checking-fix mm/page_alloc.c
--- a/mm/page_alloc.c~cma-fix-watermark-checking-fix
+++ a/mm/page_alloc.c
@@ -1635,6 +1635,7 @@ static bool __zone_watermark_ok(struct z
 	if (alloc_flags & ALLOC_HARDER)
 		min -= min / 4;
 #ifdef CONFIG_CMA
+	/* If allocation can't use CMA areas don't use free CMA pages */
 	if (!(alloc_flags & ALLOC_CMA))
 		free_pages -= zone_page_state(z, NR_FREE_CMA_PAGES);
 #endif
_

Patches currently in -mm which might be from b.zolnierkie@samsung.com are

mm-fix-tracing-in-free_pcppages_bulk.patch
cma-fix-counting-of-isolated-pages.patch
cma-count-free-cma-pages.patch
cma-fix-watermark-checking.patch
mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-3.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix3.patch
cma-migrate-mlocked-pages.patch
cma-migrate-mlocked-pages-fix.patch
cma-decrease-ccnr_migratepages-after-reclaiming-pagelist.patch

