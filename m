From: akpm@linux-foundation.org
Subject: - hugetlb-make-unmap_ref_private-multi-size-aware.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:26:23 -0800
Message-ID: <200811132126.mADLQNB1027275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447AbYKMV1F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:27:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agl@us.ibm.com, kniht@linux.vnet.ibm.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     hugetlb: make unmap_ref_private multi-size-aware
has been removed from the -mm tree.  Its filename was
     hugetlb-make-unmap_ref_private-multi-size-aware.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

