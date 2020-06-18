From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-skip-watermark_boost-for-atomic-order-0-allocations-fix.patch
 added to -mm tree
Date: Wed, 17 Jun 2020 17:13:16 -0700
Message-ID: <20200618001316.SSbvx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726815AbgFRANS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 20:13:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vinmenon@codeaurora.org, mgorman@techsingularity.net, charante@codeaurora.org


The patch titled
     Subject: mm, page_alloc: skip ->watermark_boost for atomic order-0 allocations-fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-skip-watermark_boost-for-atomic-order-0-allocations-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-skip-watermark_boost-for-atomic-order-0-allocations-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-skip-watermark_boost-for-atomic-order-0-allocations-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Charan Teja Kalla <charante@codeaurora.org>
Subject: mm, page_alloc: skip ->watermark_boost for atomic order-0 allocations-fix

fix suggested by Mel Gorman

Link: http://lkml.kernel.org/r/31556793-57b1-1c21-1a9d-22674d9bd938@codeaurora.org
Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-skip-watermark_boost-for-atomic-order-0-allocations-fix
+++ a/mm/page_alloc.c
@@ -3580,7 +3580,7 @@ bool zone_watermark_ok(struct zone *z, u
 
 static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
 				unsigned long mark, int highest_zoneidx,
-				unsigned int alloc_flags)
+				unsigned int alloc_flags, gfp_t gfp_mask)
 {
 	long free_pages = zone_page_state(z, NR_FREE_PAGES);
 	long cma_pages = 0;
@@ -3602,8 +3602,23 @@ static inline bool zone_watermark_fast(s
 				mark + z->lowmem_reserve[highest_zoneidx])
 		return true;
 
-	return __zone_watermark_ok(z, order, mark, highest_zoneidx, alloc_flags,
-					free_pages);
+	if (__zone_watermark_ok(z, order, mark, highest_zoneidx, alloc_flags,
+					free_pages))
+		return true;
+	/*
+	 * Ignore watermark boosting for GFP_ATOMIC order-0 allocations
+	 * when checking the min watermark. The min watermark is the
+	 * point where boosting is ignored so that kswapd is woken up
+	 * when below the low watermark.
+	 */
+	if (unlikely(!order && (gfp_mask & __GFP_ATOMIC) && z->watermark_boost
+		&& ((alloc_flags & ALLOC_WMARK_MASK) == WMARK_MIN))) {
+		mark = z->_watermark[WMARK_MIN];
+		return __zone_watermark_ok(z, order, mark, highest_zoneidx,
+					alloc_flags, free_pages);
+	}
+
+	return false;
 }
 
 bool zone_watermark_ok_safe(struct zone *z, unsigned int order,
@@ -3746,20 +3761,9 @@ retry:
 		}
 
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
-		/*
-		 * Allow GFP_ATOMIC order-0 allocations to exclude the
-		 * zone->watermark_boost in their watermark calculations.
-		 * We rely on the ALLOC_ flags set for GFP_ATOMIC requests in
-		 * gfp_to_alloc_flags() for this.  Reason not to use the
-		 * GFP_ATOMIC directly is that we want to fall back to slow path
-		 * thus wake up kswapd.
-		 */
-		if (unlikely(!order && !(alloc_flags & ALLOC_WMARK_MASK) &&
-		     (alloc_flags & (ALLOC_HARDER | ALLOC_HIGH)))) {
-			mark = zone->_watermark[WMARK_MIN];
-		}
 		if (!zone_watermark_fast(zone, order, mark,
-				       ac->highest_zoneidx, alloc_flags)) {
+				       ac->highest_zoneidx, alloc_flags,
+				       gfp_mask)) {
 			int ret;
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
_

Patches currently in -mm which might be from charante@codeaurora.org are

mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations.patch
mm-page_alloc-skip-watermark_boost-for-atomic-order-0-allocations-fix.patch
