From: akpm@linux-foundation.org
Subject: + hugetlb-make-unmap_ref_private-multi-size-aware.patch added to -mm tree
Date: Thu, 06 Nov 2008 14:26:59 -0800
Message-ID: <200811062226.mA6MQxqa023584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807AbYKFW10 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 17:27:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, kniht@linux.vnet.ibm.com, mel@csn.ul.ie


The patch titled
     hugetlb: make unmap_ref_private multi-size-aware
has been added to the -mm tree.  Its filename is
     hugetlb-make-unmap_ref_private-multi-size-aware.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: make unmap_ref_private multi-size-aware
From: Adam Litke <agl@us.ibm.com>

Oops.  Part of the hugetlb private reservation code was not fully converted to
use hstates.  When a huge page must be unmapped from VMAs due to a failed COW,
HPAGE_SIZE is used in the call to unmap_hugepage_range() regardless of the page
size being used.  This works if the VMA is using the default huge page size.
Otherwise we might unmap too much, too little, or trigger a BUG_ON.  Rare but
serious -- fix it.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Cc: Jon Tollefson <kniht@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-make-unmap_ref_private-multi-size-aware mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-make-unmap_ref_private-multi-size-aware
+++ a/mm/hugetlb.c
@@ -1796,6 +1796,7 @@ void unmap_hugepage_range(struct vm_area
 static int unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 				struct page *page, unsigned long address)
 {
+	struct hstate *h = hstate_vma(vma);
 	struct vm_area_struct *iter_vma;
 	struct address_space *mapping;
 	struct prio_tree_iter iter;
@@ -1805,7 +1806,7 @@ static int unmap_ref_private(struct mm_s
 	 * vm_pgoff is in PAGE_SIZE units, hence the different calculation
 	 * from page cache lookup which is in HPAGE_SIZE units.
 	 */
-	address = address & huge_page_mask(hstate_vma(vma));
+	address = address & huge_page_mask(h);
 	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT)
 		+ (vma->vm_pgoff >> PAGE_SHIFT);
 	mapping = (struct address_space *)page_private(page);
@@ -1824,7 +1825,7 @@ static int unmap_ref_private(struct mm_s
 		 */
 		if (!is_vma_resv_set(iter_vma, HPAGE_RESV_OWNER))
 			unmap_hugepage_range(iter_vma,
-				address, address + HPAGE_SIZE,
+				address, address + huge_page_size(h),
 				page);
 	}
 
_

Patches currently in -mm which might be from agl@us.ibm.com are

hugetlb-make-unmap_ref_private-multi-size-aware.patch

