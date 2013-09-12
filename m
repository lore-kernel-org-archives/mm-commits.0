From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:43:23 -0700
Message-ID: <5232195b.oix/HXus9L83Intu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3ILTnY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, minchan@kernel.org, mgorman@suse.de, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com

Subject: [merged] mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,hannes@cmpxchg.org,mgorman@suse.de,minchan@kernel.org,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:23 -0700


The patch titled
     Subject: mm, page_alloc: add unlikely macro to help compiler optimization
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, page_alloc: add unlikely macro to help compiler optimization

We rarely allocate a page with ALLOC_NO_WATERMARKS and it is used in slow
path.  For helping compiler optimization, add unlikely macro to
ALLOC_NO_WATERMARKS checking.

This patch doesn't have any effect now, because gcc already optimize this
properly.  But we cannot assume that gcc always does right and nobody
re-evaluate if gcc do proper optimization with their change, for example,
it is not optimized properly on v3.10.  So adding compiler hint here is
reasonable.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization
+++ a/mm/page_alloc.c
@@ -1909,7 +1909,7 @@ zonelist_scan:
 			!cpuset_zone_allowed_softwall(zone, gfp_mask))
 				continue;
 		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
-		if (alloc_flags & ALLOC_NO_WATERMARKS)
+		if (unlikely(alloc_flags & ALLOC_NO_WATERMARKS))
 			goto try_this_zone;
 		/*
 		 * Distribute pages in proportion to the individual
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch

