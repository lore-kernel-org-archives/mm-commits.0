From: akpm@linux-foundation.org
Subject: [merged] mm-only-set-page-pfmemalloc-when-alloc_no_watermarks-was-used.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:15:51 -0700
Message-ID: <20120801201552.424625C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:62405 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab2HAUPy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:15:54 -0400
Received: by mail-ey0-f202.google.com with SMTP id o12so293269eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:15:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, a.p.zijlstra@chello.nl, cl@linux.com, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: only set page->pfmemalloc when ALLOC_NO_WATERMARKS was used
has been removed from the -mm tree.  Its filename was
     mm-only-set-page-pfmemalloc-when-alloc_no_watermarks-was-used.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: only set page->pfmemalloc when ALLOC_NO_WATERMARKS was used

__alloc_pages_slowpath() is called when the number of free pages is below
the low watermark.  If the caller is entitled to use ALLOC_NO_WATERMARKS
then the page will be marked page->pfmemalloc.  This protects more pages
than are strictly necessary as we only need to protect pages allocated
below the min watermark (the pfmemalloc reserves).

This patch only sets page->pfmemalloc when ALLOC_NO_WATERMARKS was
required to allocate the page.

[rientjes@google.com: David noticed the problem during review]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Miller <davem@davemloft.net>
Cc: Neil Brown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff -puN mm/page_alloc.c~mm-only-set-page-pfmemalloc-when-alloc_no_watermarks-was-used mm/page_alloc.c
--- a/mm/page_alloc.c~mm-only-set-page-pfmemalloc-when-alloc_no_watermarks-was-used
+++ a/mm/page_alloc.c
@@ -2116,8 +2116,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 
 		page = get_page_from_freelist(gfp_mask, nodemask,
 				order, zonelist, high_zoneidx,
-				alloc_flags, preferred_zone,
-				migratetype);
+				alloc_flags & ~ALLOC_NO_WATERMARKS,
+				preferred_zone, migratetype);
 		if (page) {
 			preferred_zone->compact_considered = 0;
 			preferred_zone->compact_defer_shift = 0;
@@ -2209,8 +2209,8 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 retry:
 	page = get_page_from_freelist(gfp_mask, nodemask, order,
 					zonelist, high_zoneidx,
-					alloc_flags, preferred_zone,
-					migratetype);
+					alloc_flags & ~ALLOC_NO_WATERMARKS,
+					preferred_zone, migratetype);
 
 	/*
 	 * If an allocation failed after direct reclaim, it could be because
@@ -2381,8 +2381,17 @@ rebalance:
 		page = __alloc_pages_high_priority(gfp_mask, order,
 				zonelist, high_zoneidx, nodemask,
 				preferred_zone, migratetype);
-		if (page)
+		if (page) {
+			/*
+			 * page->pfmemalloc is set when ALLOC_NO_WATERMARKS was
+			 * necessary to allocate the page. The expectation is
+			 * that the caller is taking steps that will free more
+			 * memory. The caller should avoid the page being used
+			 * for !PFMEMALLOC purposes.
+			 */
+			page->pfmemalloc = true;
 			goto got_pg;
+		}
 	}
 
 	/* Atomic allocations - we can't balance anything */
@@ -2499,14 +2508,6 @@ nopage:
 	warn_alloc_failed(gfp_mask, order, NULL);
 	return page;
 got_pg:
-	/*
-	 * page->pfmemalloc is set when the caller had PFMEMALLOC set, is
-	 * been OOM killed or specified __GFP_MEMALLOC. The expectation is
-	 * that the caller is taking steps that will free more memory. The
-	 * caller should avoid the page being used for !PFMEMALLOC purposes.
-	 */
-	page->pfmemalloc = !!(alloc_flags & ALLOC_NO_WATERMARKS);
