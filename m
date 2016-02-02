From: akpm@linux-foundation.org
Subject: + mm-use-linear_page_index-in-do_fault.patch added to -mm tree
Date: Tue, 02 Feb 2016 14:54:35 -0800
Message-ID: <56b133ab.jeAbCgkroQRr8O0Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbcBBWyg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 17:54:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use linear_page_index() in do_fault()
has been added to the -mm tree.  Its filename is
     mm-use-linear_page_index-in-do_fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-linear_page_index-in-do_fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-linear_page_index-in-do_fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3137,8 +3137,7 @@ static int do_fault(struct mm_struct *mm
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

mm-fix-memory-leak-in-copy_huge_pmd.patch
mm-use-linear_page_index-in-do_fault.patch

