From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-fix-potential-false-positive-in-__zone_watermark_ok.patch
 added to -mm tree
Date: Thu, 02 Nov 2017 13:36:24 -0700
Message-ID: <59fb81c8.VsfUDHan2MFvVvxX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36768 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934115AbdKBUg1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Nov 2017 16:36:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: fix potential false positive in __zone_watermark_ok
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-potential-false-positive-in-__zone_watermark_ok.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-potential-false-positive-in-__zone_watermark_ok.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-potential-false-positive-in-__zone_watermark_ok.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -3037,9 +3037,6 @@ bool __zone_watermark_ok(struct zone *z,
 		if (!area->nr_free)
 			continue;
 
-		if (alloc_harder)
-			return true;
