From: akpm@linux-foundation.org
Subject: + mm-introduce-do_read_fault.patch added to -mm tree
Date: Mon, 10 Feb 2014 14:54:08 -0800
Message-ID: <52f95890.6hBY92soXZwtm0SH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbaBJWyJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 17:54:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, matthew.r.wilcox@intel.com, dave.hansen@linux.intel.com, ak@linux.intel.com, kirill.shutemov@linux.intel.com

Subject: + mm-introduce-do_read_fault.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,ak@linux.intel.com,dave.hansen@linux.intel.com,matthew.r.wilcox@intel.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 14:54:08 -0800


The patch titled
     Subject: mm: introduce do_read_fault()
has been added to the -mm tree.  Its filename is
     mm-introduce-do_read_fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-do_read_fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-do_read_fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: introduce do_read_fault()

Introduce do_read_fault().  The function does what do_fault() does for
read page faults.

Unlike do_fault(), do_read_fault() is pretty clean and straightforward.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff -puN mm/memory.c~mm-introduce-do_read_fault mm/memory.c
--- a/mm/memory.c~mm-introduce-do_read_fault
+++ a/mm/memory.c
@@ -3317,6 +3317,43 @@ static int __do_fault(struct vm_area_str
 	return ret;
 }
 
+static int do_read_fault(struct mm_struct *mm, struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmd,
+		pgoff_t pgoff, unsigned int flags, pte_t orig_pte)
+{
+	struct page *fault_page;
+	spinlock_t *ptl;
+	pte_t entry, *pte;
+	int ret;
+
+	ret = __do_fault(vma, address, pgoff, flags, &fault_page);
+	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
+		return ret;
+
+	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
+	if (unlikely(!pte_same(*pte, orig_pte))) {
+		pte_unmap_unlock(pte, ptl);
+		unlock_page(fault_page);
+		page_cache_release(fault_page);
+		return ret;
+	}
+
+	flush_icache_page(vma, fault_page);
+	entry = mk_pte(fault_page, vma->vm_page_prot);
+	if (pte_file(orig_pte) && pte_file_soft_dirty(orig_pte))
+		pte_mksoft_dirty(entry);
+	inc_mm_counter_fast(mm, MM_FILEPAGES);
+	page_add_file_rmap(fault_page);
+	set_pte_at(mm, address, pte, entry);
+
+	/* no need to invalidate: a not-present page won't be cached */
+	update_mmu_cache(vma, address, pte);
+	pte_unmap_unlock(pte, ptl);
+	unlock_page(fault_page);
+
+	return ret;
+}
+
 /*
  * do_fault() tries to create a new page mapping. It aggressively
  * tries to share with existing pages, but makes a separate copy if
@@ -3510,6 +3547,9 @@ static int do_linear_fault(struct mm_str
 			- vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 
 	pte_unmap(page_table);
+	if (!(flags & FAULT_FLAG_WRITE))
+		return do_read_fault(mm, vma, address, pmd, pgoff, flags,
+				orig_pte);
 	return do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
 
@@ -3542,6 +3582,9 @@ static int do_nonlinear_fault(struct mm_
 	}
 
 	pgoff = pte_to_pgoff(orig_pte);
+	if (!(flags & FAULT_FLAG_WRITE))
+		return do_read_fault(mm, vma, address, pmd, pgoff, flags,
+				orig_pte);
 	return do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-hwpoison-release-page-on-pagehwpoison-in-__do_fault.patch
mm-rename-__do_fault-do_fault.patch
mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
mm-introduce-do_read_fault.patch
mm-introduce-do_cow_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch
mm-consolidate-code-to-setup-pte.patch

