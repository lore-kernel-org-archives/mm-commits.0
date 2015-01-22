From: akpm@linux-foundation.org
Subject: + pagewalk-add-walk_page_vma.patch added to -mm tree
Date: Thu, 22 Jan 2015 15:31:12 -0800
Message-ID: <54c18840.SNvPVLeviXIAlr4s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbbAVXbN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jan 2015 18:31:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, benh@kernel.crashing.org, dave.hansen@intel.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pagewalk: add walk_page_vma()
has been added to the -mm tree.  Its filename is
     pagewalk-add-walk_page_vma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pagewalk-add-walk_page_vma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pagewalk-add-walk_page_vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: pagewalk: add walk_page_vma()

Introduce walk_page_vma(), which is useful for the callers which want to
walk over a given vma.  It's used by later patches.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 mm/pagewalk.c      |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff -puN include/linux/mm.h~pagewalk-add-walk_page_vma include/linux/mm.h
--- a/include/linux/mm.h~pagewalk-add-walk_page_vma
+++ a/include/linux/mm.h
@@ -1192,6 +1192,7 @@ struct mm_walk {
 
 int walk_page_range(unsigned long addr, unsigned long end,
 		struct mm_walk *walk);
+int walk_page_vma(struct vm_area_struct *vma, struct mm_walk *walk);
 void free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 int copy_page_range(struct mm_struct *dst, struct mm_struct *src,
diff -puN mm/pagewalk.c~pagewalk-add-walk_page_vma mm/pagewalk.c
--- a/mm/pagewalk.c~pagewalk-add-walk_page_vma
+++ a/mm/pagewalk.c
@@ -272,3 +272,21 @@ int walk_page_range(unsigned long start,
 	} while (start = next, start < end);
 	return err;
 }
+
+int walk_page_vma(struct vm_area_struct *vma, struct mm_walk *walk)
+{
+	int err;
+
+	if (!walk->mm)
+		return -EINVAL;
+
+	VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));
+	VM_BUG_ON(!vma);
+	walk->vma = vma;
+	err = walk_page_test(vma->vm_start, vma->vm_end, walk);
+	if (err > 0)
+		return 0;
+	if (err < 0)
+		return err;
+	return __walk_page_range(vma->vm_start, vma->vm_end, walk);
+}
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch
mm-add-kpf_zero_page-flag-for-proc-kpageflags.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
revert-mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch
pagewalk-improve-vma-handling.patch
pagewalk-add-walk_page_vma.patch
smaps-remove-mem_size_stats-vma-and-use-walk_page_vma.patch
clear_refs-remove-clear_refs_private-vma-and-introduce-clear_refs_test_walk.patch
pagemap-use-walk-vma-instead-of-calling-find_vma.patch
numa_maps-fix-typo-in-gather_hugetbl_stats.patch
numa_maps-remove-numa_maps-vma.patch
memcg-cleanup-preparation-for-page-table-walk.patch
arch-powerpc-mm-subpage-protc-use-walk-vma-and-walk_page_vma.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-proc-pid-clear_refs-avoid-split_huge_page.patch
mincore-apply-page-table-walker-on-do_mincore.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

