From: akpm@linux-foundation.org
Subject: [merged]
 khugepaged-move-up_readmmap_sem-out-of-khugepaged_alloc_page.patch removed
 from -mm tree
Date: Wed, 27 Jul 2016 12:03:02 -0700
Message-ID: <57990566.srWZCmUxUNFbufrY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342AbcG0TDD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:03:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: move up_read(mmap_sem) out of khugepaged_alloc_page()
has been removed from the -mm tree.  Its filename was
     khugepaged-move-up_readmmap_sem-out-of-khugepaged_alloc_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: khugepaged: move up_read(mmap_sem) out of khugepaged_alloc_page()

Both variants of khugepaged_alloc_page() do up_read(&mm->mmap_sem)
first: no point keep it inside the function.

Link: http://lkml.kernel.org/r/1466021202-61880-33-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff -puN mm/khugepaged.c~khugepaged-move-up_readmmap_sem-out-of-khugepaged_alloc_page mm/khugepaged.c
--- a/mm/khugepaged.c~khugepaged-move-up_readmmap_sem-out-of-khugepaged_alloc_page
+++ a/mm/khugepaged.c
@@ -739,19 +739,10 @@ static bool khugepaged_prealloc_page(str
 }
 
 static struct page *
-khugepaged_alloc_page(struct page **hpage, gfp_t gfp, struct mm_struct *mm,
-		       unsigned long address, int node)
+khugepaged_alloc_page(struct page **hpage, gfp_t gfp, int node)
 {
 	VM_BUG_ON_PAGE(*hpage, *hpage);
 
-	/*
-	 * Before allocating the hugepage, release the mmap_sem read lock.
-	 * The allocation can take potentially a long time if it involves
-	 * sync compaction, and we do not need to hold the mmap_sem during
-	 * that. We will recheck the vma after taking it again in write mode.
-	 */
-	up_read(&mm->mmap_sem);
-
 	*hpage = __alloc_pages_node(node, gfp, HPAGE_PMD_ORDER);
 	if (unlikely(!*hpage)) {
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
@@ -812,10 +803,8 @@ static bool khugepaged_prealloc_page(str
 }
 
 static struct page *
-khugepaged_alloc_page(struct page **hpage, gfp_t gfp, struct mm_struct *mm,
-		       unsigned long address, int node)
+khugepaged_alloc_page(struct page **hpage, gfp_t gfp, int node)
 {
-	up_read(&mm->mmap_sem);
 	VM_BUG_ON(!*hpage);
 
 	return  *hpage;
@@ -936,8 +925,14 @@ static void collapse_huge_page(struct mm
 	/* Only allocate from the target node */
 	gfp = alloc_hugepage_khugepaged_gfpmask() | __GFP_OTHER_NODE | __GFP_THISNODE;
 
-	/* release the mmap_sem read lock. */
-	new_page = khugepaged_alloc_page(hpage, gfp, mm, address, node);
+	/*
+	 * Before allocating the hugepage, release the mmap_sem read lock.
+	 * The allocation can take potentially a long time if it involves
+	 * sync compaction, and we do not need to hold the mmap_sem during
+	 * that. We will recheck the vma after taking it again in write mode.
+	 */
+	up_read(&mm->mmap_sem);
+	new_page = khugepaged_alloc_page(hpage, gfp, node);
 	if (!new_page) {
 		result = SCAN_ALLOC_HUGE_PAGE_FAIL;
 		goto out_nolock;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


