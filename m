From: akpm@linux-foundation.org
Subject: + mm-page_alloc-fix-watermark-check-in-__zone_watermark_ok.patch added to -mm tree
Date: Thu, 09 May 2013 13:02:36 -0700
Message-ID: <20130509200236.7DB8231C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:41756 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3EIUCh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 16:02:37 -0400
Received: by mail-yh0-f73.google.com with SMTP id a41so329005yho.0
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 13:02:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: t.stanislaws@samsung.com, b.zolnierkie@samsung.com, kyungmin.park@samsung.com, mel@csn.ul.ie, minchan@kernel.org


The patch titled
     Subject: mm/page_alloc.c: fix watermark check in __zone_watermark_ok()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-watermark-check-in-__zone_watermark_ok.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: mm/page_alloc.c: fix watermark check in __zone_watermark_ok()

The watermark check consists of two sub-checks.  The first one is:

	if (free_pages <= min + lowmem_reserve)
		return false;

The check assures that there is minimal amount of RAM in the zone.  If CMA
is used then the free_pages is reduced by the number of free pages in CMA
prior to the over-mentioned check.

	if (!(alloc_flags & ALLOC_CMA))
		free_pages -= zone_page_state(z, NR_FREE_CMA_PAGES);

This prevents the zone from being drained from pages available for
non-movable allocations.

The second check prevents the zone from getting too fragmented.

	for (o = 0; o < order; o++) {
		free_pages -= z->free_area[o].nr_free << o;
		min >>= 1;
		if (free_pages <= min)
			return false;
	}

The field z->free_area[o].nr_free is equal to the number of free pages
including free CMA pages.  Therefore the CMA pages are subtracted twice. 
This may cause a false positive fail of __zone_watermark_ok() if the CMA
area gets strongly fragmented.  In such a case there are many 0-order free
pages located in CMA.  Those pages are subtracted twice therefore they
will quickly drain free_pages during the check against fragmentation.  The
test fails even though there are many free non-cma pages in the zone.

This patch fixes this issue by subtracting CMA pages only for a purpose of
(free_pages <= min + lowmem_reserve) check.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-fix-watermark-check-in-__zone_watermark_ok mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fix-watermark-check-in-__zone_watermark_ok
+++ a/mm/page_alloc.c
@@ -1628,6 +1628,7 @@ static bool __zone_watermark_ok(struct z
 	long min = mark;
 	long lowmem_reserve = z->lowmem_reserve[classzone_idx];
 	int o;
+	long free_cma = 0;
 
 	free_pages -= (1 << order) - 1;
 	if (alloc_flags & ALLOC_HIGH)
@@ -1637,9 +1638,10 @@ static bool __zone_watermark_ok(struct z
 #ifdef CONFIG_CMA
 	/* If allocation can't use CMA areas don't use free CMA pages */
 	if (!(alloc_flags & ALLOC_CMA))
-		free_pages -= zone_page_state(z, NR_FREE_CMA_PAGES);
+		free_cma = zone_page_state(z, NR_FREE_CMA_PAGES);
 #endif
-	if (free_pages <= min + lowmem_reserve)
+
+	if (free_pages - free_cma <= min + lowmem_reserve)
 		return false;
 	for (o = 0; o < order; o++) {
 		/* At the next order, this order's pages become unavailable */
_

Patches currently in -mm which might be from t.stanislaws@samsung.com are

origin.patch
mm-page_alloc-fix-watermark-check-in-__zone_watermark_ok.patch

