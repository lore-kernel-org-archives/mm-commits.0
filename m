From: akpm@linux-foundation.org
Subject: [merged] mm-document-do_fault_around-feature.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 12:53:33 -0700
Message-ID: <5390cabd.hU9TlaooLOeH/xez%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaFETxd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:53:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com

Subject: [merged] mm-document-do_fault_around-feature.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:53:33 -0700


The patch titled
     Subject: mm: document do_fault_around() feature
has been removed from the -mm tree.  Its filename was
     mm-document-do_fault_around-feature.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: document do_fault_around() feature

Some clarification on how faultaround works.

[akpm@linux-foundation.org: tweak comment text]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff -puN mm/memory.c~mm-document-do_fault_around-feature mm/memory.c
--- a/mm/memory.c~mm-document-do_fault_around-feature
+++ a/mm/memory.c
@@ -2760,6 +2760,10 @@ void do_set_pte(struct vm_area_struct *v
 
 static unsigned long fault_around_bytes = 65536;
 
+/*
+ * fault_around_pages() and fault_around_mask() round down fault_around_bytes
+ * to nearest page order. It's what do_fault_around() expects to see.
+ */
 static inline unsigned long fault_around_pages(void)
 {
 	return rounddown_pow_of_two(fault_around_bytes) / PAGE_SIZE;
@@ -2801,6 +2805,29 @@ static int __init fault_around_debugfs(v
 late_initcall(fault_around_debugfs);
 #endif
 
+/*
+ * do_fault_around() tries to map few pages around the fault address. The hope
+ * is that the pages will be needed soon and this will lower the number of
+ * faults to handle.
+ *
+ * It uses vm_ops->map_pages() to map the pages, which skips the page if it's
+ * not ready to be mapped: not up-to-date, locked, etc.
+ *
+ * This function is called with the page table lock taken. In the split ptlock
+ * case the page table lock only protects only those entries which belong to
+ * the page table corresponding to the fault address.
+ *
+ * This function doesn't cross the VMA boundaries, in order to call map_pages()
+ * only once.
+ *
+ * fault_around_pages() defines how many pages we'll try to map.
+ * do_fault_around() expects it to return a power of two less than or equal to
+ * PTRS_PER_PTE.
+ *
+ * The virtual address of the area that we map is naturally aligned to the
+ * fault_around_pages() value (and therefore to page order).  This way it's
+ * easier to guarantee that we don't cross page table boundaries.
+ */
 static void do_fault_around(struct vm_area_struct *vma, unsigned long address,
 		pte_t *pte, pgoff_t pgoff, unsigned int flags)
 {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-prom-pid-clear_refs-avoid-split_huge_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
mm-mark-remap_file_pages-syscall-as-deprecated.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

