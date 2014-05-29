From: akpm@linux-foundation.org
Subject: + mm-document-do_fault_around-feature.patch added to -mm tree
Date: Thu, 29 May 2014 15:54:26 -0700
Message-ID: <5387baa2.Czwl6UPUGKH/Ut+w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaE2Wy1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 May 2014 18:54:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com

Subject: + mm-document-do_fault_around-feature.patch added to -mm tree
To: kirill.shutemov@linux.intel.com
From: akpm@linux-foundation.org
Date: Thu, 29 May 2014 15:54:26 -0700


The patch titled
     Subject: mm: document do_fault_around() feature
has been added to the -mm tree.  Its filename is
     mm-document-do_fault_around-feature.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-document-do_fault_around-feature.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-document-do_fault_around-feature.patch

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
Subject: mm: document do_fault_around() feature

Some clarification on how faultaround works.

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
+ * is that the pages will be needed soon and this would lower the number of
+ * faults to handle.
+ *
+ * It uses vm_ops->map_pages() to map the pages, which skips the page if it's
+ * not ready to be mapped: not up-to-date, locked, etc.
+ *
+ * This function is called with the page table lock taken. In the split ptlock
+ * case the page table lock only protects only those entries which belong to
+ * page table corresponding to the fault address.
+ *
+ * This function don't cross the VMA boundaries in order to call map_pages()
+ * only once.
+ *
+ * fault_around_pages() defines how many pages we'll try to map.
+ * do_fault_around() expects it to be power of two and less or equal to
+ * PTRS_PER_PTE.
+ *
+ * The virtual address of the area that we map is naturally aligned to the
+ * fault_around_pages() (and therefore to page order). This way it's easier to
+ * guarantee that we don't cross the page table boundaries.
+ */
 static void do_fault_around(struct vm_area_struct *vma, unsigned long address,
 		pte_t *pte, pgoff_t pgoff, unsigned int flags)
 {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

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
thp-consolidate-assert-checks-in-__split_huge_page.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-move-get_user_pages-related-code-to-separate-file.patch
mm-extract-in_gate_area-case-from-__get_user_pages.patch
mm-cleanup-follow_page_mask.patch
mm-extract-code-to-fault-in-a-page-from-__get_user_pages.patch
mm-cleanup-__get_user_pages.patch
mm-rmapc-make-page_referenced_one-and-try_to_unmap_one-static.patch
mm-update-comment-for-default_max_map_count.patch
mm-update-comment-for-default_max_map_count-fix.patch
mm-fix-typo-in-comment-in-do_fault_around.patch
mm-prom-pid-clear_refs-avoid-split_huge_page.patch
mm-nominate-faultaround-area-in-bytes-rather-then-page-order.patch
mm-document-do_fault_around-feature.patch
mm-document-do_fault_around-feature-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-userc-drop-unused-field-files-from-user_struct.patch
linux-next.patch
mm-mark-remap_file_pages-syscall-as-deprecated.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

