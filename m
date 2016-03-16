From: akpm@linux-foundation.org
Subject: [merged] mm-use-linear_page_index-in-do_fault.patch removed from
 -mm tree
Date: Wed, 16 Mar 2016 12:57:00 -0700
Message-ID: <56e9ba8c.HY2apbwNgBB9qkJ4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbcCPT5B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:57:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use linear_page_index() in do_fault()
has been removed from the -mm tree.  Its filename was
     mm-use-linear_page_index-in-do_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: mm: use linear_page_index() in do_fault()

do_fault() assumes that PAGE_SIZE is the same as PAGE_CACHE_SIZE.  Use
linear_page_index() to calculate pgoff in the correct units.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memory.c~mm-use-linear_page_index-in-do_fault mm/memory.c
--- a/mm/memory.c~mm-use-linear_page_index-in-do_fault
+++ a/mm/memory.c
@@ -3124,8 +3124,7 @@ static int do_fault(struct mm_struct *mm
 		unsigned long address, pte_t *page_table, pmd_t *pmd,
 		unsigned int flags, pte_t orig_pte)
 {
-	pgoff_t pgoff = (((address & PAGE_MASK)
-			- vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
+	pgoff_t pgoff = linear_page_index(vma, address);
 
 	pte_unmap(page_table);
 	/* The VMA was not fully populated on mmap() or missing VM_DONTEXPAND */
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are


