From: akpm@linux-foundation.org
Subject: [patch 024/127] mm, compaction: require only min watermarks for
 non-costly orders
Date: Fri, 07 Oct 2016 16:58:00 -0700
Message-ID: <57f83688.g1RgbLaTnrrvIZ7h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38925 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbcJGX6B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:58:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, iamjoonsoo.kim@lge.com, lstoakes@gmail.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: require only min watermarks for non-costly orders

The __compaction_suitable() function checks the low watermark plus a
compact_gap() gap to decide if there's enough free memory to perform
compaction.  Then __isolate_free_page uses low watermark check to decide
if particular free page can be isolated.  In the latter case, using low
watermark is needlessly pessimistic, as the free page isolations are only
temporary.  For __compaction_suitable() the higher watermark makes sense
for high-order allocations where more freepages increase the chance of
success, and we can typically fail with some order-0 fallback when the
system is struggling to reach that watermark.  But for low-order
allocation, forming the page should not be that hard.  So using low
watermark here might just prevent compaction from even trying, and
eventually lead to OOM killer even if we are above min watermarks.

So after this patch, we use min watermark for non-costly orders in
__compaction_suitable(), and for all orders in __isolate_free_page().

[vbabka@suse.cz: clarify __isolate_free_page() comment]
 Link: http://lkml.kernel.org/r/7ae4baec-4eca-e70b-2a69-94bea4fb19fa@suse.cz
Link: http://lkml.kernel.org/r/20160810091226.6709-11-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 +++++-
 mm/page_alloc.c |    9 +++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff -puN mm/compaction.c~mm-compaction-require-only-min-watermarks-for-non-costly-orders mm/compaction.c
--- a/mm/compaction.c~mm-compaction-require-only-min-watermarks-for-non-costly-orders
+++ a/mm/compaction.c
@@ -1399,10 +1399,14 @@ static enum compact_result __compaction_
 	 * isolation. We however do use the direct compactor's classzone_idx to
 	 * skip over zones where lowmem reserves would prevent allocation even
 	 * if compaction succeeds.
+	 * For costly orders, we require low watermark instead of min for
+	 * compaction to proceed to increase its chances.
 	 * ALLOC_CMA is used, as pages in CMA pageblocks are considered
 	 * suitable migration targets
 	 */
-	watermark = low_wmark_pages(zone) + compact_gap(order);
+	watermark = (order > PAGE_ALLOC_COSTLY_ORDER) ?
+				low_wmark_pages(zone) : min_wmark_pages(zone);
+	watermark += compact_gap(order);
 	if (!__zone_watermark_ok(zone, 0, watermark, classzone_idx,
 						ALLOC_CMA, wmark_target))
 		return COMPACT_SKIPPED;
diff -puN mm/page_alloc.c~mm-compaction-require-only-min-watermarks-for-non-costly-orders mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-require-only-min-watermarks-for-non-costly-orders
+++ a/mm/page_alloc.c
@@ -2489,8 +2489,13 @@ int __isolate_free_page(struct page *pag
 	mt = get_pageblock_migratetype(page);
 
 	if (!is_migrate_isolate(mt)) {
-		/* Obey watermarks as if the page was being allocated */
-		watermark = low_wmark_pages(zone) + (1 << order);
+		/*
+		 * Obey watermarks as if the page was being allocated. We can
+		 * emulate a high-order watermark check with a raised order-0
+		 * watermark, because we already know our high-order page
+		 * exists.
+		 */
+		watermark = min_wmark_pages(zone) + (1UL << order);
 		if (!zone_watermark_ok(zone, 0, watermark, 0, ALLOC_CMA))
 			return 0;
 
_
