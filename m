From: akpm@linux-foundation.org
Subject: [merged] mm-use-aligned-zone-start-for-pfn_to_bitidx-calculation.patch removed from -mm tree
Date: Mon, 14 Jan 2013 12:38:31 -0800
Message-ID: <20130114203832.519D620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:40206 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758753Ab3ANUif (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 15:38:35 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so290059bkc.5
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 12:38:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lauraa@codeaurora.org, mgorman@suse.de, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use aligned zone start for pfn_to_bitidx calculation
has been removed from the -mm tree.  Its filename was
     mm-use-aligned-zone-start-for-pfn_to_bitidx-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laura Abbott <lauraa@codeaurora.org>
Subject: mm: use aligned zone start for pfn_to_bitidx calculation

The current calculation in pfn_to_bitidx assumes that (pfn -
zone->zone_start_pfn) >> pageblock_order will return the same bit for all
pfn in a pageblock.  If zone_start_pfn is not aligned to
pageblock_nr_pages, this may not always be correct.

Consider the following with pageblock order = 10, zone start 2MB:

pfn     | pfn - zone start | (pfn - zone start) >> page block order
----------------------------------------------------------------
0x26000 | 0x25e00	   |  0x97
0x26100 | 0x25f00	   |  0x97
0x26200 | 0x26000	   |  0x98
0x26300 | 0x26100	   |  0x98

This means that calling {get,set}_pageblock_migratetype on a single page
will not set the migratetype for the full block.  Fix this by rounding
down zone_start_pfn when doing the bitidx calculation.

For our use case, the effects of this bug were mostly tied to the fact
that CMA allocations would either take a long time or fail to happen. 
Depending on the driver using CMA, this could result in anything from
visual glitches to application failures.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-use-aligned-zone-start-for-pfn_to_bitidx-calculation mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-aligned-zone-start-for-pfn_to_bitidx-calculation
+++ a/mm/page_alloc.c
@@ -5604,7 +5604,7 @@ static inline int pfn_to_bitidx(struct z
 	pfn &= (PAGES_PER_SECTION-1);
 	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 #else
-	pfn = pfn - zone->zone_start_pfn;
+	pfn = pfn - round_down(zone->zone_start_pfn, pageblock_nr_pages);
 	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 #endif /* CONFIG_SPARSEMEM */
 }
_

Patches currently in -mm which might be from lauraa@codeaurora.org are

origin.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch

