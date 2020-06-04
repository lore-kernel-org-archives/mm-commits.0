From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix.patch
 removed from -mm tree
Date: Thu, 04 Jun 2020 14:39:28 -0700
Message-ID: <20200604213928.ipDFS4866%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbgFDVj3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 17:39:29 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, charante@codeaurora.org, mm-commits@vger.kernel.org, vinmenon@codeaurora.org


The patch titled
     Subject: mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix.patch

This patch was dropped because it was folded into mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix

fix comment grammar, reflow comment

Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix
+++ a/mm/page_alloc.c
@@ -3748,11 +3748,11 @@ retry:
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
 		/*
 		 * Allow GFP_ATOMIC order-0 allocations to exclude the
-		 * zone->watermark_boost in its watermark calculations.
-		 * We rely on the ALLOC_ flags set for GFP_ATOMIC
-		 * requests in gfp_to_alloc_flags() for this. Reason not to
-		 * use the GFP_ATOMIC directly is that we want to fall back
-		 * to slow path thus wake up kswapd.
+		 * zone->watermark_boost in their watermark calculations.
+		 * We rely on the ALLOC_ flags set for GFP_ATOMIC requests in
+		 * gfp_to_alloc_flags() for this.  Reason not to use the
+		 * GFP_ATOMIC directly is that we want to fall back to slow path
+		 * thus wake up kswapd.
 		 */
 		if (unlikely(!order && !(alloc_flags & ALLOC_WMARK_MASK) &&
 		     (alloc_flags & (ALLOC_HARDER | ALLOC_HIGH)))) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations.patch
arch-kunmap-remove-duplicate-kunmap-implementations-fix.patch
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
