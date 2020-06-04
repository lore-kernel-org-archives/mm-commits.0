From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mmpage=5Falloccma-conditionally-prefer-cma-pageblocks-for-m?=
 =?US-ASCII?Q?ovable-allocations.patch?= removed from -mm tree
Date: Thu, 04 Jun 2020 10:17:55 -0700
Message-ID: <20200604171755.9H3wB9K0u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729999AbgFDRR4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:17:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, cai@lca.pw, guro@fb.com, js1304@gmail.com, mgorman@techsingularity.net, minchan@kernel.org, mm-commits@vger.kernel.org, riel@surriel.com, vbabka@suse.cz


The patch titled
     Subject: mm,page_alloc,cma: conditionally prefer cma pageblocks for movable allocations
has been removed from the -mm tree.  Its filename was
     mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from guro@fb.com are
