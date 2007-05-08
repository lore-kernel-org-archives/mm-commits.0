From: akpm@linux-foundation.org
Subject: - mm-remove-gcc-workaround.patch removed from -mm tree
Date: Mon, 07 May 2007 17:01:51 -0700
Message-ID: <200705080001.l4801pC3008800@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967312AbXEHABz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:01:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: remove gcc workaround
has been removed from the -mm tree.  Its filename was
     mm-remove-gcc-workaround.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: remove gcc workaround
From: Nick Piggin <npiggin@suse.de>

Minimum gcc version is 3.2 now.  However, with likely profiling, even
modern gcc versions cannot always eliminate the call.

Replace the placeholder functions with the more conventional empty static
inlines, which should be optimal for everyone.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   18 ++++++++++++++++++
 mm/memory.c        |   12 ------------
 2 files changed, 18 insertions(+), 12 deletions(-)

diff -puN include/linux/mm.h~mm-remove-gcc-workaround include/linux/mm.h
--- a/include/linux/mm.h~mm-remove-gcc-workaround
+++ a/include/linux/mm.h
@@ -850,8 +850,26 @@ static inline int vma_wants_writenotify(
 
 extern pte_t *FASTCALL(get_locked_pte(struct mm_struct *mm, unsigned long addr, spinlock_t **ptl));
 
+#ifdef __PAGETABLE_PUD_FOLDED
+static inline int __pud_alloc(struct mm_struct *mm, pgd_t *pgd,
+						unsigned long address)
+{
+	return 0;
+}
+#else
 int __pud_alloc(struct mm_struct *mm, pgd_t *pgd, unsigned long address);
+#endif
+
+#ifdef __PAGETABLE_PMD_FOLDED
+static inline int __pmd_alloc(struct mm_struct *mm, pud_t *pud,
+						unsigned long address)
+{
+	return 0;
+}
+#else
 int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address);
+#endif
+
 int __pte_alloc(struct mm_struct *mm, pmd_t *pmd, unsigned long address);
 int __pte_alloc_kernel(pmd_t *pmd, unsigned long address);
 
diff -puN mm/memory.c~mm-remove-gcc-workaround mm/memory.c
--- a/mm/memory.c~mm-remove-gcc-workaround
+++ a/mm/memory.c
@@ -2633,12 +2633,6 @@ int __pud_alloc(struct mm_struct *mm, pg
 	spin_unlock(&mm->page_table_lock);
 	return 0;
 }
-#else
-/* Workaround for gcc 2.96 */
-int __pud_alloc(struct mm_struct *mm, pgd_t *pgd, unsigned long address)
-{
-	return 0;
-}
 #endif /* __PAGETABLE_PUD_FOLDED */
 
 #ifndef __PAGETABLE_PMD_FOLDED
@@ -2667,12 +2661,6 @@ int __pmd_alloc(struct mm_struct *mm, pu
 	spin_unlock(&mm->page_table_lock);
 	return 0;
 }
-#else
-/* Workaround for gcc 2.96 */
-int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
-{
-	return 0;
-}
 #endif /* __PAGETABLE_PMD_FOLDED */
 
 int make_pages_present(unsigned long addr, unsigned long end)
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-more-rmap-checking.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-document-fault_data-and-flags.patch
exec-fix-remove_arg_zero.patch
as-fix-antic_expire-check.patch
futex-restartable-futex_wait.patch
