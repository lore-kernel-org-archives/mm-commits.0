From: akpm@linux-foundation.org
Subject: [merged] mm-fix-huge-zero-page-accounting-in-smaps-report.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:57:33 -0800
Message-ID: <5489e91d.TKDxjUY7QvfUKpN5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45408 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406AbaLKS5e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, fengguang.wu@intel.com, yfw.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix huge zero page accounting in smaps report
has been removed from the -mm tree.  Its filename was
     mm-fix-huge-zero-page-accounting-in-smaps-report.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm: fix huge zero page accounting in smaps report

As a small zero page, huge zero page should not be accounted in smaps
report as normal page.

For small pages we rely on vm_normal_page() to filter out zero page, but
vm_normal_page() is not designed to handle pmds.  We only get here due
hackish cast pmd to pte in smaps_pte_range() -- pte and pmd format is not
necessary compatible on each and every architecture.

Let's add separate codepath to handle pmds.  follow_trans_huge_pmd() will
detect huge zero page for us.

We would need pmd_dirty() helper to do this properly.  The patch adds it
to THP-enabled architectures which don't yet have one.

[akpm@linux-foundation.org: use do_div to fix 32-bit build]
Signed-off-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: Fengwei Yin <yfw.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h         |    1 
 arch/powerpc/include/asm/pgtable-ppc64.h |    1 
 arch/sparc/include/asm/pgtable_64.h      |    7 +
 arch/x86/include/asm/pgtable.h           |    5 +
 fs/proc/task_mmu.c                       |  104 +++++++++++++--------
 5 files changed, 82 insertions(+), 36 deletions(-)

diff -puN arch/arm64/include/asm/pgtable.h~mm-fix-huge-zero-page-accounting-in-smaps-report arch/arm64/include/asm/pgtable.h
--- a/arch/arm64/include/asm/pgtable.h~mm-fix-huge-zero-page-accounting-in-smaps-report
+++ a/arch/arm64/include/asm/pgtable.h
@@ -279,6 +279,7 @@ void pmdp_splitting_flush(struct vm_area
 #endif /* CONFIG_HAVE_RCU_TABLE_FREE */
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+#define pmd_dirty(pmd)		pte_dirty(pmd_pte(pmd))
 #define pmd_young(pmd)		pte_young(pmd_pte(pmd))
 #define pmd_wrprotect(pmd)	pte_pmd(pte_wrprotect(pmd_pte(pmd)))
 #define pmd_mksplitting(pmd)	pte_pmd(pte_mkspecial(pmd_pte(pmd)))
diff -puN arch/powerpc/include/asm/pgtable-ppc64.h~mm-fix-huge-zero-page-accounting-in-smaps-report arch/powerpc/include/asm/pgtable-ppc64.h
--- a/arch/powerpc/include/asm/pgtable-ppc64.h~mm-fix-huge-zero-page-accounting-in-smaps-report
+++ a/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -467,6 +467,7 @@ static inline pte_t *pmdp_ptep(pmd_t *pm
 }
 
 #define pmd_pfn(pmd)		pte_pfn(pmd_pte(pmd))
+#define pmd_dirty(pmd)		pte_dirty(pmd_pte(pmd))
 #define pmd_young(pmd)		pte_young(pmd_pte(pmd))
 #define pmd_mkold(pmd)		pte_pmd(pte_mkold(pmd_pte(pmd)))
 #define pmd_wrprotect(pmd)	pte_pmd(pte_wrprotect(pmd_pte(pmd)))
diff -puN arch/sparc/include/asm/pgtable_64.h~mm-fix-huge-zero-page-accounting-in-smaps-report arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~mm-fix-huge-zero-page-accounting-in-smaps-report
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -667,6 +667,13 @@ static inline unsigned long pmd_pfn(pmd_
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline unsigned long pmd_dirty(pmd_t pmd)
+{
+	pte_t pte = __pte(pmd_val(pmd));
+
+	return pte_dirty(pte);
+}
+
 static inline unsigned long pmd_young(pmd_t pmd)
 {
 	pte_t pte = __pte(pmd_val(pmd));
diff -puN arch/x86/include/asm/pgtable.h~mm-fix-huge-zero-page-accounting-in-smaps-report arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-fix-huge-zero-page-accounting-in-smaps-report
+++ a/arch/x86/include/asm/pgtable.h
@@ -99,6 +99,11 @@ static inline int pte_young(pte_t pte)
 	return pte_flags(pte) & _PAGE_ACCESSED;
 }
 
+static inline int pmd_dirty(pmd_t pmd)
+{
+	return pmd_flags(pmd) & _PAGE_DIRTY;
+}
+
 static inline int pmd_young(pmd_t pmd)
 {
 	return pmd_flags(pmd) & _PAGE_ACCESSED;
diff -puN fs/proc/task_mmu.c~mm-fix-huge-zero-page-accounting-in-smaps-report fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-fix-huge-zero-page-accounting-in-smaps-report
+++ a/fs/proc/task_mmu.c
@@ -447,58 +447,91 @@ struct mem_size_stats {
 	u64 pss;
 };
 
+static void smaps_account(struct mem_size_stats *mss, struct page *page,
+		unsigned long size, bool young, bool dirty)
+{
+	int mapcount;
 
-static void smaps_pte_entry(pte_t ptent, unsigned long addr,
-		unsigned long ptent_size, struct mm_walk *walk)
+	if (PageAnon(page))
+		mss->anonymous += size;
+
+	mss->resident += size;
+	/* Accumulate the size in pages that have been accessed. */
+	if (young || PageReferenced(page))
+		mss->referenced += size;
+	mapcount = page_mapcount(page);
+	if (mapcount >= 2) {
+		u64 pss_delta;
+
+		if (dirty || PageDirty(page))
+			mss->shared_dirty += size;
+		else
+			mss->shared_clean += size;
+		pss_delta = (u64)size << PSS_SHIFT;
+		do_div(pss_delta, mapcount);
+		mss->pss += pss_delta;
+	} else {
+		if (dirty || PageDirty(page))
+			mss->private_dirty += size;
+		else
+			mss->private_clean += size;
+		mss->pss += (u64)size << PSS_SHIFT;
+	}
+}
+
+static void smaps_pte_entry(pte_t *pte, unsigned long addr,
+		struct mm_walk *walk)
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = mss->vma;
 	pgoff_t pgoff = linear_page_index(vma, addr);
 	struct page *page = NULL;
-	int mapcount;
 
-	if (pte_present(ptent)) {
-		page = vm_normal_page(vma, addr, ptent);
-	} else if (is_swap_pte(ptent)) {
-		swp_entry_t swpent = pte_to_swp_entry(ptent);
+	if (pte_present(*pte)) {
+		page = vm_normal_page(vma, addr, *pte);
+	} else if (is_swap_pte(*pte)) {
+		swp_entry_t swpent = pte_to_swp_entry(*pte);
 
 		if (!non_swap_entry(swpent))
-			mss->swap += ptent_size;
+			mss->swap += PAGE_SIZE;
 		else if (is_migration_entry(swpent))
 			page = migration_entry_to_page(swpent);
-	} else if (pte_file(ptent)) {
-		if (pte_to_pgoff(ptent) != pgoff)
-			mss->nonlinear += ptent_size;
+	} else if (pte_file(*pte)) {
+		if (pte_to_pgoff(*pte) != pgoff)
+			mss->nonlinear += PAGE_SIZE;
 	}
 
 	if (!page)
 		return;
 
-	if (PageAnon(page))
-		mss->anonymous += ptent_size;
-
 	if (page->index != pgoff)
-		mss->nonlinear += ptent_size;
+		mss->nonlinear += PAGE_SIZE;
 
-	mss->resident += ptent_size;
-	/* Accumulate the size in pages that have been accessed. */
-	if (pte_young(ptent) || PageReferenced(page))
-		mss->referenced += ptent_size;
-	mapcount = page_mapcount(page);
-	if (mapcount >= 2) {
-		if (pte_dirty(ptent) || PageDirty(page))
-			mss->shared_dirty += ptent_size;
-		else
-			mss->shared_clean += ptent_size;
-		mss->pss += (ptent_size << PSS_SHIFT) / mapcount;
-	} else {
-		if (pte_dirty(ptent) || PageDirty(page))
-			mss->private_dirty += ptent_size;
-		else
-			mss->private_clean += ptent_size;
-		mss->pss += (ptent_size << PSS_SHIFT);
-	}
+	smaps_account(mss, page, PAGE_SIZE, pte_young(*pte), pte_dirty(*pte));
+}
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
+		struct mm_walk *walk)
+{
+	struct mem_size_stats *mss = walk->private;
+	struct vm_area_struct *vma = mss->vma;
+	struct page *page;
+
+	/* FOLL_DUMP will return -EFAULT on huge zero page */
+	page = follow_trans_huge_pmd(vma, addr, pmd, FOLL_DUMP);
+	if (IS_ERR_OR_NULL(page))
+		return;
+	mss->anonymous_thp += HPAGE_PMD_SIZE;
+	smaps_account(mss, page, HPAGE_PMD_SIZE,
+			pmd_young(*pmd), pmd_dirty(*pmd));
+}
+#else
+static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
+		struct mm_walk *walk)
+{
 }
+#endif
 
 static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			   struct mm_walk *walk)
@@ -509,9 +542,8 @@ static int smaps_pte_range(pmd_t *pmd, u
 	spinlock_t *ptl;
 
 	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
-		smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_PMD_SIZE, walk);
+		smaps_pmd_entry(pmd, addr, walk);
 		spin_unlock(ptl);
-		mss->anonymous_thp += HPAGE_PMD_SIZE;
 		return 0;
 	}
 
@@ -524,7 +556,7 @@ static int smaps_pte_range(pmd_t *pmd, u
 	 */
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE)
-		smaps_pte_entry(*pte, addr, PAGE_SIZE, walk);
+		smaps_pte_entry(pte, addr, walk);
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
 	return 0;
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

