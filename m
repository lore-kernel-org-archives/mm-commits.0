From: akpm@linux-foundation.org
Subject: [merged]
 thp-remove-unused-vma-parameter-from-khugepaged_alloc_page.patch removed
 from -mm tree
Date: Mon, 09 Nov 2015 11:44:44 -0800
Message-ID: <5640f7ac.IlDcgRxTLwCUeJ7H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57129 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbbKIToo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:44:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: atomlin@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: remove unused vma parameter from khugepaged_alloc_page
has been removed from the -mm tree.  Its filename was
     thp-remove-unused-vma-parameter-from-khugepaged_alloc_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Aaron Tomlin <atomlin@redhat.com>
Subject: thp: remove unused vma parameter from khugepaged_alloc_page

The "vma" parameter to khugepaged_alloc_page() is unused.  It has to
remain unused or the drop read lock 'map_sem' optimisation introduce by
commit 8b1645685acf ("mm, THP: don't hold mmap_sem in khugepaged when
allocating THP") wouldn't be safe.  So let's remove it.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/huge_memory.c~thp-remove-unused-vma-parameter-from-khugepaged_alloc_page mm/huge_memory.c
--- a/mm/huge_memory.c~thp-remove-unused-vma-parameter-from-khugepaged_alloc_page
+++ a/mm/huge_memory.c
@@ -2413,8 +2413,7 @@ static bool khugepaged_prealloc_page(str
 
 static struct page *
 khugepaged_alloc_page(struct page **hpage, gfp_t gfp, struct mm_struct *mm,
-		       struct vm_area_struct *vma, unsigned long address,
-		       int node)
+		       unsigned long address, int node)
 {
 	VM_BUG_ON_PAGE(*hpage, *hpage);
 
@@ -2481,8 +2480,7 @@ static bool khugepaged_prealloc_page(str
 
 static struct page *
 khugepaged_alloc_page(struct page **hpage, gfp_t gfp, struct mm_struct *mm,
-		       struct vm_area_struct *vma, unsigned long address,
-		       int node)
+		       unsigned long address, int node)
 {
 	up_read(&mm->mmap_sem);
 	VM_BUG_ON(!*hpage);
@@ -2530,7 +2528,7 @@ static void collapse_huge_page(struct mm
 		__GFP_THISNODE;
 
 	/* release the mmap_sem read lock. */
-	new_page = khugepaged_alloc_page(hpage, gfp, mm, vma, address, node);
+	new_page = khugepaged_alloc_page(hpage, gfp, mm, address, node);
 	if (!new_page)
 		return;
 
_

Patches currently in -mm which might be from atomlin@redhat.com are


