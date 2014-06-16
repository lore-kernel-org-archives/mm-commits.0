From: akpm@linux-foundation.org
Subject: [nacked] mm-prom-pid-clear_refs-avoid-split_huge_page.patch
 removed from -mm tree
Date: Mon, 16 Jun 2014 16:32:24 -0700
Message-ID: <539f7e88.nG/PZc5og3R4D+B8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbaFPXcZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 19:32:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, n-horiguchi@ah.jp.nec.com, gorcunov@gmail.com, dave.hansen@intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com


The patch titled
     Subject: mm: /proc/pid/clear_refs: avoid split_huge_page()
has been removed from the -mm tree.  Its filename was
     mm-prom-pid-clear_refs-avoid-split_huge_page.patch

This patch was dropped because it was nacked

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
@@ -708,10 +708,10 @@ struct clear_refs_private {
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
@@ -730,9 +730,35 @@ static inline void clear_soft_dirty(stru
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
@@ -755,6 +781,33 @@ static int clear_refs_pte(pte_t *pte, un
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
@@ -818,6 +871,7 @@ static ssize_t clear_refs_write(struct f
 		};
 		struct mm_walk clear_refs_walk = {
 			.pte_entry = clear_refs_pte,
+			.pmd_entry = clear_refs_pmd,
 			.test_walk = clear_refs_test_walk,
 			.mm = mm,
 			.private = &cp,
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

