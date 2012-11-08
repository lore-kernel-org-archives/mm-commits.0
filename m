From: akpm@linux-foundation.org
Subject: + mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page.patch added to -mm tree
Date: Thu, 08 Nov 2012 12:24:12 -0800
Message-ID: <20121108202413.A62735C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:64554 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab2KHUYR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2012 15:24:17 -0500
Received: by mail-la0-f74.google.com with SMTP id j13so206200lah.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Nov 2012 12:24:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.szyprowski@samsung.com, arnd@arndb.de, b.zolnierkie@samsung.com, kyungmin.park@samsung.com, mel@csn.ul.ie, mina86@mina86.com, minchan@kernel.org


The patch titled
     Subject: mm: cma: skip watermarks check for already isolated blocks in split_free_page()
has been added to the -mm tree.  Its filename is
     mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: mm: cma: skip watermarks check for already isolated blocks in split_free_page()

Since commit 2139cbe627b8 ("cma: fix counting of isolated pages") free
pages in isolated pageblocks are not accounted to NR_FREE_PAGES counters,
so watermarks check is not required if one operates on a free page in
isolated pageblock.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page
+++ a/mm/page_alloc.c
@@ -1394,10 +1394,12 @@ int capture_free_page(struct page *page,
 	zone = page_zone(page);
 	order = page_order(page);
 
-	/* Obey watermarks as if the page was being allocated */
-	watermark = low_wmark_pages(zone) + (1 << order);
-	if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
-		return 0;
+	if (get_pageblock_migratetype(page) != MIGRATE_ISOLATE) {
+		/* Obey watermarks as if the page was being allocated */
+		watermark = low_wmark_pages(zone) + (1 << order);
+		if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
+			return 0;
+	}
 
 	/* Remove page from free list */
 	list_del(&page->lru);
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page.patch
mm-cma-remove-watermark-hacks.patch

