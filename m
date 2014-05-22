From: akpm@linux-foundation.org
Subject: + mm-prom-pid-clear_refs-avoid-split_huge_page.patch added to -mm tree
Date: Thu, 22 May 2014 11:10:06 -0700
Message-ID: <537e3d7e.v+k6u+zid1XeVfT1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaEVSKH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 May 2014 14:10:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, n-horiguchi@ah.jp.nec.com, gorcunov@gmail.com, dave.hansen@intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: + mm-prom-pid-clear_refs-avoid-split_huge_page.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,dave.hansen@intel.com,gorcunov@gmail.com,n-horiguchi@ah.jp.nec.com,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Thu, 22 May 2014 11:10:06 -0700


The patch titled
     Subject: mm: /proc/pid/clear_refs: avoid split_huge_page()
has been added to the -mm tree.  Its filename is
     mm-prom-pid-clear_refs-avoid-split_huge_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-prom-pid-clear_refs-avoid-split_huge_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-prom-pid-clear_refs-avoid-split_huge_page.patch

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
Subject: mm: /proc/pid/clear_refs: avoid split_huge_page()

Currently pagewalker splits all THP pages on any clear_refs request.  It's
not necessary.  We can handle this on PMD level.

One side effect is that soft dirty will potentially see more dirty memory,
since we will mark whole THP page dirty at once.

Sanity checked with CRIU test suite. More testing is required.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   58 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-prom-pid-clear_refs-avoid-split_huge_page fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-prom-pid-clear_refs-avoid-split_huge_page
+++ a/fs/proc/task_mmu.c
@@ -702,10 +702,10 @@ struct clear_refs_private {
 	enum clear_refs_types type;
 };
 
+#ifdef CONFIG_MEM_SOFT_DIRTY
 static inline void clear_soft_dirty(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *pte)
 {
-#ifdef CONFIG_MEM_SOFT_DIRTY
 	/*
 	 * The soft-dirty tracker uses #PF-s to catch writes
 	 * to pages, so write-protect the pte as well. See the
@@ -724,9 +724,35 @@ static inline void clear_soft_dirty(stru
 	}
 
 	set_pte_at(vma->vm_mm, addr, pte, ptent);
-#endif
 }
 
+static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmdp)
+{
+	pmd_t pmd = *pmdp;
+
+	pmd = pmd_wrprotect(pmd);
+	pmd = pmd_clear_flags(pmd, _PAGE_SOFT_DIRTY);
+
+	if (vma->vm_flags & VM_SOFTDIRTY)
+		vma->vm_flags &= ~VM_SOFTDIRTY;
+
+	set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
+}
+
+#else
+
+static inline void clear_soft_dirty(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *pte)
+{
+}
+
+static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmdp)
+{
+}
+#endif
+
 static int clear_refs_pte(pte_t *pte, unsigned long addr,
 				unsigned long end, struct mm_walk *walk)
 {
@@ -749,6 +775,33 @@ static int clear_refs_pte(pte_t *pte, un
 	return 0;
 }
 
+static int clear_refs_pmd(pmd_t *pmd, unsigned long addr,
+				unsigned long end, struct mm_walk *walk)
+{
+	struct clear_refs_private *cp = walk->private;
+	struct vm_area_struct *vma = walk->vma;
+	struct page *page;
+	spinlock_t *ptl;
+
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) != 1)
+		return 0;
+	if (cp->type == CLEAR_REFS_SOFT_DIRTY) {
+		clear_soft_dirty_pmd(vma, addr, pmd);
+		goto out;
+	}
+
+	page = pmd_page(*pmd);
+
+	/* Clear accessed and referenced bits. */
+	pmdp_test_and_clear_young(vma, addr, pmd);
+	ClearPageReferenced(page);
+out:
+	spin_unlock(ptl);
+	/* handled as pmd, no need to call clear_refs_pte() */
+	walk->skip = 1;
+	return 0;
+}
+
 static int clear_refs_test_walk(unsigned long start, unsigned long end,
 				struct mm_walk *walk)
 {
@@ -812,6 +865,7 @@ static ssize_t clear_refs_write(struct f
 		};
 		struct mm_walk clear_refs_walk = {
 			.pte_entry = clear_refs_pte,
+			.pmd_entry = clear_refs_pmd,
 			.test_walk = clear_refs_test_walk,
 			.mm = mm,
 			.private = &cp,
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

pagewalk-update-page-table-walker-core.patch
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
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-userc-drop-unused-field-files-from-user_struct.patch
linux-next.patch
mm-mark-remap_file_pages-syscall-as-deprecated.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

