From: akpm@linux-foundation.org
Subject: + mm-use-aligned-zone-start-for-pfn_to_bitidx-calculation.patch added to -mm tree
Date: Mon, 07 Jan 2013 14:31:45 -0800
Message-ID: <20130107223145.E7C28100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:33798 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab3AGWbr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 17:31:47 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so2144377vcd.3
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 14:31:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lauraa@codeaurora.org, mgorman@suse.de


The patch titled
     Subject: mm: use aligned zone start for pfn_to_bitidx calculation
has been added to the -mm tree.  Its filename is
     mm-use-aligned-zone-start-for-pfn_to_bitidx-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Acked-by: Mel Gorman <mgorman@suse.de>
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

mm-use-aligned-zone-start-for-pfn_to_bitidx-calculation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch

