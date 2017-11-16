From: akpm@linux-foundation.org
Subject: [patch 117/131] mm, page_alloc: fix potential false
 positive in __zone_watermark_ok
Date: Wed, 15 Nov 2017 17:38:30 -0800
Message-ID: <20171116013830.xiBYLRszJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40532 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933675AbdKPBic (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:38:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, riel@redhat.com, rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: fix potential false positive in __zone_watermark_ok

Since 97a16fc82a7c ("mm, page_alloc: only enforce watermarks for order-0
allocations"), __zone_watermark_ok() check for high-order allocations will
shortcut per-migratetype free list checks for ALLOC_HARDER allocations,
and return true as long as there's free page of any migratetype.  The
intention is that ALLOC_HARDER can allocate from MIGRATE_HIGHATOMIC free
lists, while normal allocations can't.

However, as a side effect, the watermark check will then also return true
when there are pages only on the MIGRATE_ISOLATE list, or (prior to CMA
conversion to ZONE_MOVABLE) on the MIGRATE_CMA list.  Since the allocation
cannot actually obtain isolated pages, and might not be able to obtain CMA
pages, this can result in a false positive.

The condition should be rare and perhaps the outcome is not a fatal one. 
Still, it's better if the watermark check is correct.  There also
shouldn't be a performance tradeoff here.

Link: http://lkml.kernel.org/r/20171102125001.23708-1-vbabka@suse.cz
Fixes: 97a16fc82a7c ("mm, page_alloc: only enforce watermarks for order-0 allocations")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-fix-potential-false-positive-in-__zone_watermark_ok mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fix-potential-false-positive-in-__zone_watermark_ok
+++ a/mm/page_alloc.c
@@ -3041,9 +3041,6 @@ bool __zone_watermark_ok(struct zone *z,
 		if (!area->nr_free)
 			continue;
 
-		if (alloc_harder)
-			return true;
