From: akpm@linux-foundation.org
Subject: +
 page_alloc-consider-highatomic-reserve-in-watermark-fast-v5.patch added to
 -mm tree
Date: Wed, 24 Jun 2020 15:15:20 -0700
Message-ID: <20200624221520.KgxjA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388232AbgFXWPV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 18:15:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ytk.lee@samsung.com, vbabka@suse.cz, minchan@kernel.org, mgorman@techsingularity.net, hannes@cmpxchg.org, bhe@redhat.com, jaewon31.kim@samsung.com


The patch titled
     Subject: page_alloc-consider-highatomic-reserve-in-watermark-fast-v5
has been added to the -mm tree.  Its filename is
     page_alloc-consider-highatomic-reserve-in-watermark-fast-v5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/page_alloc-consider-highatomic-reserve-in-watermark-fast-v5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/page_alloc-consider-highatomic-reserve-in-watermark-fast-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: page_alloc-consider-highatomic-reserve-in-watermark-fast-v5

remove redundant code for high-order

Link: http://lkml.kernel.org/r/20200623035242.27232-1-jaewon31.kim@samsung.com
Reported-by: Yong-Taek Lee <ytk.lee@samsung.com>
Suggested-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~page_alloc-consider-highatomic-reserve-in-watermark-fast-v5
+++ a/mm/page_alloc.c
@@ -3592,18 +3592,18 @@ static inline bool zone_watermark_fast(s
 				unsigned int alloc_flags)
 {
 	long free_pages;
-	long unusable_free;
 
 	free_pages = zone_page_state(z, NR_FREE_PAGES);
-	unusable_free = __zone_watermark_unusable_free(z, order, alloc_flags);
 
 	/*
 	 * Fast check for order-0 only. If this fails then the reserves
 	 * need to be calculated.
 	 */
 	if (!order) {
-		long fast_free = free_pages - unusable_free;
+		long fast_free;
 
+		fast_free = free_pages;
+		fast_free -= __zone_watermark_unusable_free(z, 0, alloc_flags);
 		if (fast_free > mark + z->lowmem_reserve[highest_zoneidx])
 			return true;
 	}
_

Patches currently in -mm which might be from jaewon31.kim@samsung.com are

page_alloc-consider-highatomic-reserve-in-watermark-fast.patch
page_alloc-consider-highatomic-reserve-in-watermark-fast-v5.patch
