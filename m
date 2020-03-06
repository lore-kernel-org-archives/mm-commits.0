From: akpm@linux-foundation.org
Subject: +
 mm-micro-optimisation-save-two-branches-on-hot-page-allocation-path.patch
 added to -mm tree
Date: Thu, 05 Mar 2020 20:08:05 -0800
Message-ID: <20200306040805.WL3v-pupP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbgCFEIH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Mar 2020 23:08:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mateusznosek0@gmail.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: mm, pagealloc: micro-optimisation: save two branches on hot page allocation path
has been added to the -mm tree.  Its filename is
     mm-micro-optimisation-save-two-branches-on-hot-page-allocation-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-micro-optimisation-save-two-branches-on-hot-page-allocation-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-micro-optimisation-save-two-branches-on-hot-page-allocation-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm, pagealloc: micro-optimisation: save two branches on hot page allocation path

This patch makes ALLOC_KSWAPD equal to __GFP_KSWAPD_RECLAIM (cast to int).

Thanks to that code like:
    if (gfp_mask & __GFP_KSWAPD_RECLAIM)
	    alloc_flags |= ALLOC_KSWAPD;
can be changed to:
    alloc_flags |= (__force int) (gfp_mask &__GFP_KSWAPD_RECLAIM);
Thanks to this one branch less is generated in the assembly.

In case of ALLOC_KSWAPD flag two branches are saved, first one in code
that always executes in the beginning of page allocation and the second
one in loop in page allocator slowpath.

Link: http://lkml.kernel.org/r/20200304162118.14784-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    2 +-
 mm/page_alloc.c |   22 ++++++++++++++--------
 2 files changed, 15 insertions(+), 9 deletions(-)

--- a/mm/internal.h~mm-micro-optimisation-save-two-branches-on-hot-page-allocation-path
+++ a/mm/internal.h
@@ -532,7 +532,7 @@ unsigned long reclaim_clean_pages_from_l
 #else
 #define ALLOC_NOFRAGMENT	  0x0
 #endif
-#define ALLOC_KSWAPD		0x200 /* allow waking of kswapd */
+#define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 
 enum ttu_flags;
 struct tlbflush_unmap_batch;
--- a/mm/page_alloc.c~mm-micro-optimisation-save-two-branches-on-hot-page-allocation-path
+++ a/mm/page_alloc.c
@@ -3537,10 +3537,13 @@ static bool zone_allows_reclaim(struct z
 static inline unsigned int
 alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
 {
-	unsigned int alloc_flags = 0;
+	unsigned int alloc_flags;
 
-	if (gfp_mask & __GFP_KSWAPD_RECLAIM)
-		alloc_flags |= ALLOC_KSWAPD;
+	/*
+	 * __GFP_KSWAPD_RECLAIM is assumed to be the same as ALLOC_KSWAPD
+	 * to save a branch.
+	 */
+	alloc_flags = (__force int) (gfp_mask & __GFP_KSWAPD_RECLAIM);
 
 #ifdef CONFIG_ZONE_DMA32
 	if (!zone)
@@ -4176,8 +4179,13 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 {
 	unsigned int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
 
-	/* __GFP_HIGH is assumed to be the same as ALLOC_HIGH to save a branch. */
+	/*
+	 * __GFP_HIGH is assumed to be the same as ALLOC_HIGH
+	 * and __GFP_KSWAPD_RECLAIM is assumed to be the same as ALLOC_KSWAPD
+	 * to save two branches.
+	 */
 	BUILD_BUG_ON(__GFP_HIGH != (__force gfp_t) ALLOC_HIGH);
+	BUILD_BUG_ON(__GFP_KSWAPD_RECLAIM != (__force gfp_t) ALLOC_KSWAPD);
 
 	/*
 	 * The caller may dip into page reserves a bit more if the caller
@@ -4185,7 +4193,8 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
 	 * set both ALLOC_HARDER (__GFP_ATOMIC) and ALLOC_HIGH (__GFP_HIGH).
 	 */
-	alloc_flags |= (__force int) (gfp_mask & __GFP_HIGH);
+	alloc_flags |= (__force int)
+		(gfp_mask & (__GFP_HIGH | __GFP_KSWAPD_RECLAIM));
 
 	if (gfp_mask & __GFP_ATOMIC) {
 		/*
@@ -4202,9 +4211,6 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	} else if (unlikely(rt_task(current)) && !in_interrupt())
 		alloc_flags |= ALLOC_HARDER;
 
-	if (gfp_mask & __GFP_KSWAPD_RECLAIM)
-		alloc_flags |= ALLOC_KSWAPD;
