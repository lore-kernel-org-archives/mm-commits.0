From: akpm@linux-foundation.org
Subject: [merged] page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:33:56 -0700
Message-ID: <200906171833.n5HIXueu032425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759777AbZFQSeg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, Lee.Schermerhorn@hp.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, penberg@cs.h


The patch titled
     page allocator: remove a branch by assuming __GFP_HIGH == ALLOC_HIGH
has been removed from the -mm tree.  Its filename was
     page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: remove a branch by assuming __GFP_HIGH == ALLOC_HIGH
From: Mel Gorman <mel@csn.ul.ie>

Allocations that specify __GFP_HIGH get the ALLOC_HIGH flag.  If these
flags are equal to each other, we can eliminate a branch.

[akpm@linux-foundation.org: Suggested the hack]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high
+++ a/mm/page_alloc.c
@@ -1616,14 +1616,16 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
 
+	/* __GFP_HIGH is assumed to be the same as ALLOC_HIGH to save a branch. */
+	BUILD_BUG_ON(__GFP_HIGH != ALLOC_HIGH);
+
 	/*
 	 * The caller may dip into page reserves a bit more if the caller
 	 * cannot run direct reclaim, or if the caller has realtime scheduling
 	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
 	 * set both ALLOC_HARDER (!wait) and ALLOC_HIGH (__GFP_HIGH).
 	 */
-	if (gfp_mask & __GFP_HIGH)
-		alloc_flags |= ALLOC_HIGH;
+	alloc_flags |= (gfp_mask & __GFP_HIGH);
 
 	if (!wait) {
 		alloc_flags |= ALLOC_HARDER;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
add-debugging-aid-for-memory-initialisation-problems.patch

