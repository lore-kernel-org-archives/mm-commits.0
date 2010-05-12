From: akpm@linux-foundation.org
Subject: [merged] rmap-remove-anon_vma-check-in-page_address_in_vma.patch removed from -mm tree
Date: Wed, 12 May 2010 10:58:31 -0400
Message-ID: <201005121759.o4CHxx6h011542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308Ab0ELSAi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 14:00:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, andi@firstfloor.org, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     rmap: remove anon_vma check in page_address_in_vma()
has been removed from the -mm tree.  Its filename was
     rmap-remove-anon_vma-check-in-page_address_in_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rmap: remove anon_vma check in page_address_in_vma()
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Currently page_address_in_vma() compares vma->anon_vma and
page_anon_vma(page) for parameter check, but in 2.6.34 a vma can have
multiple anon_vmas with anon_vma_chain, so current check does not work. 
(For anonymous page shared by multiple processes, some verified (page,vma)
pairs return -EFAULT wrongly.)

We can go to checking all anon_vmas in the "same_vma" chain, but it needs
to meet lock requirement.  Instead, we can remove anon_vma check safely
because page_address_in_vma() assumes that page and vma are already
checked to belong to the identical process.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/rmap.c~rmap-remove-anon_vma-check-in-page_address_in_vma mm/rmap.c
--- a/mm/rmap.c~rmap-remove-anon_vma-check-in-page_address_in_vma
+++ a/mm/rmap.c
@@ -336,14 +336,13 @@ vma_address(struct page *page, struct vm
 
 /*
  * At what user virtual address is page expected in vma?
- * checking that the page matches the vma.
+ * Caller should check the page is actually part of the vma.
  */
 unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
 {
-	if (PageAnon(page)) {
-		if (vma->anon_vma != page_anon_vma(page))
-			return -EFAULT;
-	} else if (page->mapping && !(vma->vm_flags & VM_NONLINEAR)) {
+	if (PageAnon(page))
+		;
+	else if (page->mapping && !(vma->vm_flags & VM_NONLINEAR)) {
 		if (!vma->vm_file ||
 		    vma->vm_file->f_mapping != page->mapping)
 			return -EFAULT;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mincore-cleanups.patch
mincore-break-do_mincore-into-logical-pieces.patch
mincore-pass-ranges-as-startend-address-pairs.patch
mincore-do-nested-page-table-walks.patch
pagemap-add-ifdefs-config_hugetlb_page-on-code-walking-hugetlb-vma.patch

