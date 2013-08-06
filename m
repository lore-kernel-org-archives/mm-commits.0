From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization.patch added
 to -mm tree
Date: Tue, 06 Aug 2013 15:13:39 -0700
Message-ID: <52017513.EQozpSoQtEKIZjjY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab3HFWNk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Aug 2013 18:13:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, minchan@kernel.org, mgorman@suse.de, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com

Subject: + mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,hannes@cmpxchg.org,mgorman@suse.de,minchan@kernel.org,riel@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 06 Aug 2013 15:13:39 -0700


The patch titled
     Subject: mm, page_alloc: add unlikely macro to help compiler optimization
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1898,7 +1898,7 @@ zonelist_scan:
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

mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization.patch
mm-move-pgtable-related-functions-to-right-place.patch
swap-clean-up-ifdef-in-page_mapping.patch

