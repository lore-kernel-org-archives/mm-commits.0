From: akpm@linux-foundation.org
Subject: + cma-fix-watermark-checking-fix.patch added to -mm tree
Date: Mon, 24 Sep 2012 14:32:02 -0700
Message-ID: <20120924213202.C7E17100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:39739 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2IXVcE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Sep 2012 17:32:04 -0400
Received: by vcbfy27 with SMTP id fy27so816500vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 24 Sep 2012 14:32:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: b.zolnierkie@samsung.com, hughd@google.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org


The patch titled
     Subject: cma: fix watermark checking cleanup
has been added to the -mm tree.  Its filename is
     cma-fix-watermark-checking-fix.patch

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
@@ -233,21 +233,6 @@ enum zone_watermarks {
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
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-fix-counting-of-isolated-pages.patch
cma-count-free-cma-pages.patch
cma-count-free-cma-pages-fix.patch
cma-fix-watermark-checking.patch
cma-fix-watermark-checking-fix.patch

