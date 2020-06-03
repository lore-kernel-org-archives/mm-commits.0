From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 037/131] mm,page_alloc,cma: conditionally prefer
 cma pageblocks for movable allocations
Date: Wed, 03 Jun 2020 15:58:42 -0700
Message-ID: <20200603225842.xxpO4hJHh%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCW6p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:58:45 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, cai@lca.pw, guro@fb.com, js1304@gmail.com, linux-mm@kvack.org, mgorman@techsingularity.net, minchan@kernel.org, mm-commits@vger.kernel.org, riel@surriel.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Roman Gushchin <guro@fb.com>
Subject: mm,page_alloc,cma: conditionally prefer cma pageblocks for movable allocations

Currently a cma area is barely used by the page allocator because it's
used only as a fallback from movable, however kswapd tries hard to make
sure that the fallback path isn't used.

This results in a system evicting memory and pushing data into swap, while
lots of CMA memory is still available.  This happens despite the fact that
alloc_contig_range is perfectly capable of moving any movable allocations
out of the way of an allocation.

To effectively use the cma area let's alter the rules: if the zone has
more free cma pages than the half of total free pages in the zone, use cma
pageblocks first and fallback to movable blocks in the case of failure.

[guro@fb.com: ifdef the cma-specific code]
  Link: http://lkml.kernel.org/r/20200311225832.GA178154@carbon.DHCP.thefacebook.com
Link: http://lkml.kernel.org/r/20200306150102.3e77354b@imladris.surriel.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
Co-developed-by: Rik van Riel <riel@surriel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/mm/page_alloc.c~mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations
+++ a/mm/page_alloc.c
@@ -2752,6 +2752,20 @@ __rmqueue(struct zone *zone, unsigned in
 {
 	struct page *page;
 
+#ifdef CONFIG_CMA
+	/*
+	 * Balance movable allocations between regular and CMA areas by
+	 * allocating from CMA when over half of the zone's free memory
+	 * is in the CMA area.
+	 */
+	if (migratetype == MIGRATE_MOVABLE &&
+	    zone_page_state(zone, NR_FREE_CMA_PAGES) >
+	    zone_page_state(zone, NR_FREE_PAGES) / 2) {
+		page = __rmqueue_cma_fallback(zone, order);
+		if (page)
+			return page;
+	}
+#endif
 retry:
 	page = __rmqueue_smallest(zone, order, migratetype);
 	if (unlikely(!page)) {
_
