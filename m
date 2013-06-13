From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-fix-watermark-check-in-__zone_watermark_ok.patch removed from -mm tree
Date: Thu, 13 Jun 2013 11:58:02 -0700
Message-ID: <51ba163a.xnZZrPS/WUCSFcOO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37121 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab3FMS6D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:58:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, minchan@kernel.org, mel@csn.ul.ie, m.szyprowski@samsung.com, lauraa@codeaurora.org, kyungmin.park@samsung.com, b.zolnierkie@samsung.com, t.stanislaws@samsung.com

Subject: [merged] mm-page_alloc-fix-watermark-check-in-__zone_watermark_ok.patch removed from -mm tree
To: t.stanislaws@samsung.com,b.zolnierkie@samsung.com,kyungmin.park@samsung.com,lauraa@codeaurora.org,m.szyprowski@samsung.com,mel@csn.ul.ie,minchan@kernel.org,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:58:02 -0700


The patch titled
     Subject: mm/page_alloc.c: fix watermark check in __zone_watermark_ok()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-watermark-check-in-__zone_watermark_ok.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Laura said:

  We were observing allocation failures of higher order pages (order 5 =
  128K typically) under tight memory conditions resulting in driver
  failure.  The output from the page allocation failure showed plenty of
  free pages of the appropriate order/type/zone and mostly CMA pages in
  the lower orders.

  For full disclosure, we still observed some page allocation failures
  even after applying the patch but the number was drastically reduced and
  those failures were attributed to fragmentation/other system issues.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Tested-by: Laura Abbott <lauraa@codeaurora.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: <stable@vger.kernel.org>	[3.7+]
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

