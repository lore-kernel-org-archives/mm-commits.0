From: akpm@linux-foundation.org
Subject: + mm-remove-gcc-workaround.patch added to -mm tree
Date: Wed, 21 Feb 2007 16:51:01 -0800
Message-ID: <200702220051.l1M0p1S4031948@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60198 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932774AbXBVAvF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 19:51:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm: remove gcc workaround
has been added to the -mm tree.  Its filename is
     mm-remove-gcc-workaround.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2684,12 +2684,6 @@ int __pud_alloc(struct mm_struct *mm, pg
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
@@ -2718,12 +2712,6 @@ int __pmd_alloc(struct mm_struct *mm, pu
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

git-block.patch
mm-remove-gcc-workaround.patch
