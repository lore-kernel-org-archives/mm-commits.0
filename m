From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 16:10:14 -0800
Message-ID: <563d4166.KbPDyBSWY1z8TiWb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbbKGAKP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 19:10:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, cl@linux.com, hannes@cmpxchg.org, mhocko@suse.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, vitalywool@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: only enforce watermarks for order-0 allocations -fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix.patch

This patch was dropped because it was folded into mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: only enforce watermarks for order-0 allocations -fix

This patch is updating comments for clarity and converts a bool to an int.
 The code as-is is ok as the compiler is meant to cast it correctly but it
looks odd to people who know the value would be truncated and lost for
other types.

This is a fix to the mmotm patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix
+++ a/mm/page_alloc.c
@@ -2333,7 +2333,7 @@ static bool __zone_watermark_ok(struct z
 {
 	long min = mark;
 	int o;
-	const bool alloc_harder = (alloc_flags & ALLOC_HARDER);
+	const int alloc_harder = (alloc_flags & ALLOC_HARDER);
 
 	/* free_pages may go negative - that's OK */
 	free_pages -= (1 << order) - 1;
@@ -2357,14 +2357,19 @@ static bool __zone_watermark_ok(struct z
 		free_pages -= zone_page_state(z, NR_FREE_CMA_PAGES);
 #endif
 
+	/*
+	 * Check watermarks for an order-0 allocation request. If these
+	 * are not met, then a high-order request also cannot go ahead
+	 * even if a suitable page happened to be free.
+	 */
 	if (free_pages <= min + z->lowmem_reserve[classzone_idx])
 		return false;
 
-	/* order-0 watermarks are ok */
+	/* If this is an order-0 request then the watermark is fine */
 	if (!order)
 		return true;
 
-	/* Check at least one high-order page is free */
+	/* For a high-order request, check at least one suitable page is free */
 	for (o = order; o < MAX_ORDER; o++) {
 		struct free_area *area = &z->free_area[o];
 		int mt;
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe.patch
mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing.patch
mm-page_alloc-remove-unnecessary-taking-of-a-seqlock-when-cpusets-are-disabled.patch
mm-page_alloc-use-masks-and-shifts-when-converting-gfp-flags-to-migrate-types.patch
mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd.patch
mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim.patch
mm-page_alloc-delete-the-zonelist_cache.patch
mm-page_alloc-remove-migrate_reserve.patch
mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch
mm-page_alloc-hide-some-GFP-internals-and-document-the-bit-and-flag-combinations.patch
mm-page_alloc-hide-some-gfp-internals-and-document-the-bit-and-flag-combinations-fix.patch

