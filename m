From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix.patch
 added to -mm tree
Date: Wed, 30 Sep 2015 14:04:03 -0700
Message-ID: <560c4e43.ZU/2H6ybIa8WTJGz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663AbbI3VEE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 17:04:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, cl@linux.com, hannes@cmpxchg.org, mhocko@suse.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, vitalywool@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: only enforce watermarks for order-0 allocations -fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2332,7 +2332,7 @@ static bool __zone_watermark_ok(struct z
 {
 	long min = mark;
 	int o;
-	const bool alloc_harder = (alloc_flags & ALLOC_HARDER);
+	const int alloc_harder = (alloc_flags & ALLOC_HARDER);
 
 	/* free_pages may go negative - that's OK */
 	free_pages -= (1 << order) - 1;
@@ -2356,14 +2356,19 @@ static bool __zone_watermark_ok(struct z
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

mm-hugetlbfs-skip-shared-vmas-when-unmapping-private-pages-to-satisfy-a-fault.patch
mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe.patch
mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing.patch
mm-page_alloc-remove-unnecessary-taking-of-a-seqlock-when-cpusets-are-disabled.patch
mm-page_alloc-use-masks-and-shifts-when-converting-gfp-flags-to-migrate-types.patch
mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim.patch
mm-page_alloc-delete-the-zonelist_cache.patch
mm-page_alloc-remove-migrate_reserve.patch
mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand.patch
mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand-fix.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix.patch
mm-page_alloc-hide-some-GFP-internals-and-document-the-bit-and-flag-combinations.patch

