From: akpm@linux-foundation.org
Subject: [patch 079/123] mm: THP page cache support for ppc64
Date: Mon, 12 Dec 2016 16:44:32 -0800
Message-ID: <584f4470.aLWlyACWim/pPtok%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41558 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932282AbcLMAoe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:44:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, bsingharora@gmail.com, kirill.shutemov@linux.intel.com, mikey@neuling.org, mpe@ellerman.id.au, paulus@samba.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm: THP page cache support for ppc64

Add arch specific callback in the generic THP page cache code that will
deposit and withdarw preallocated page table.  Archs like ppc64 use this
preallocated table to store the hash pte slot information.

Testing:
kernel build of the patch series on tmpfs mounted with option huge=always

The related thp stat:
thp_fault_alloc 72939
thp_fault_fallback 60547
thp_collapse_alloc 603
thp_collapse_alloc_failed 0
thp_file_alloc 253763
thp_file_mapped 4251
thp_split_page 51518
thp_split_page_failed 1
thp_deferred_split_page 73566
thp_split_pmd 665
thp_zero_page_alloc 3
thp_zero_page_alloc_failed 0

[akpm@linux-foundation.org: remove unneeded parentheses, per Kirill]
Link: http://lkml.kernel.org/r/20161113150025.17942-2-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/pgtable.h |   10 ++
 include/asm-generic/pgtable.h                |    3 
 mm/Kconfig                                   |    6 -
 mm/huge_memory.c                             |   17 ++++
 mm/khugepaged.c                              |   21 +++++
 mm/memory.c                                  |   60 ++++++++++++++---
 6 files changed, 100 insertions(+), 17 deletions(-)

diff -puN arch/powerpc/include/asm/book3s/64/pgtable.h~mm-thp-page-cache-support-for-ppc64 arch/powerpc/include/asm/book3s/64/pgtable.h
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-thp-page-cache-support-for-ppc64
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1021,6 +1021,16 @@ static inline int pmd_move_must_withdraw
 	 */
 	return true;
 }
+
+
+#define arch_needs_pgtable_deposit arch_needs_pgtable_deposit
+static inline bool arch_needs_pgtable_deposit(void)
+{
+	if (radix_enabled())
+		return false;
+	return true;
+}
+
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_POWERPC_BOOK3S_64_PGTABLE_H_ */
diff -puN include/asm-generic/pgtable.h~mm-thp-page-cache-support-for-ppc64 include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-thp-page-cache-support-for-ppc64
+++ a/include/asm-generic/pgtable.h
@@ -652,6 +652,9 @@ static inline pmd_t pmd_read_atomic(pmd_
 }
 #endif
 
+#ifndef arch_needs_pgtable_deposit
+#define arch_needs_pgtable_deposit() (false)
+#endif
 /*
  * This function is meant to be used by sites walking pagetables with
  * the mmap_sem hold in read mode to protect against MADV_DONTNEED and
diff -puN mm/Kconfig~mm-thp-page-cache-support-for-ppc64 mm/Kconfig
--- a/mm/Kconfig~mm-thp-page-cache-support-for-ppc64
+++ a/mm/Kconfig
@@ -447,13 +447,9 @@ choice
 	  benefit.
 endchoice
 
-#
-# We don't deposit page tables on file THP mapping,
-# but Power makes use of them to address MMU quirk.
-#
 config	TRANSPARENT_HUGE_PAGECACHE
 	def_bool y
-	depends on TRANSPARENT_HUGEPAGE && !PPC
+	depends on TRANSPARENT_HUGEPAGE
 
 #
 # UP and nommu archs use km based percpu allocator
diff -puN mm/huge_memory.c~mm-thp-page-cache-support-for-ppc64 mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-page-cache-support-for-ppc64
+++ a/mm/huge_memory.c
@@ -1380,6 +1380,15 @@ out_unlocked:
 	return ret;
 }
 
+static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
+{
+	pgtable_t pgtable;
+
+	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
+	pte_free(mm, pgtable);
+	atomic_long_dec(&mm->nr_ptes);
+}
+
 int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
@@ -1421,6 +1430,8 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 			atomic_long_dec(&tlb->mm->nr_ptes);
 			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 		} else {
+			if (arch_needs_pgtable_deposit())
+				zap_deposited_table(tlb->mm, pmd);
 			add_mm_counter(tlb->mm, MM_FILEPAGES, -HPAGE_PMD_NR);
 		}
 		spin_unlock(ptl);
@@ -1607,6 +1618,12 @@ static void __split_huge_pmd_locked(stru
 
 	if (!vma_is_anonymous(vma)) {
 		_pmd = pmdp_huge_clear_flush_notify(vma, haddr, pmd);
+		/*
+		 * We are going to unmap this huge page. So
+		 * just go ahead and zap it
+		 */
+		if (arch_needs_pgtable_deposit())
+			zap_deposited_table(mm, pmd);
 		if (vma_is_dax(vma))
 			return;
 		page = pmd_page(_pmd);
diff -puN mm/khugepaged.c~mm-thp-page-cache-support-for-ppc64 mm/khugepaged.c
--- a/mm/khugepaged.c~mm-thp-page-cache-support-for-ppc64
+++ a/mm/khugepaged.c
@@ -1242,6 +1242,7 @@ static void retract_page_tables(struct a
 	struct vm_area_struct *vma;
 	unsigned long addr;
 	pmd_t *pmd, _pmd;
+	bool deposited = false;
 
 	i_mmap_lock_write(mapping);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
@@ -1266,10 +1267,26 @@ static void retract_page_tables(struct a
 			spinlock_t *ptl = pmd_lock(vma->vm_mm, pmd);
 			/* assume page table is clear */
 			_pmd = pmdp_collapse_flush(vma, addr, pmd);
+			/*
+			 * now deposit the pgtable for arch that need it
+			 * otherwise free it.
+			 */
+			if (arch_needs_pgtable_deposit()) {
+				/*
+				 * The deposit should be visibile only after
+				 * collapse is seen by others.
+				 */
+				smp_wmb();
+				pgtable_trans_huge_deposit(vma->vm_mm, pmd,
+							   pmd_pgtable(_pmd));
+				deposited = true;
+			}
 			spin_unlock(ptl);
 			up_write(&vma->vm_mm->mmap_sem);
-			atomic_long_dec(&vma->vm_mm->nr_ptes);
-			pte_free(vma->vm_mm, pmd_pgtable(_pmd));
+			if (!deposited) {
+				atomic_long_dec(&vma->vm_mm->nr_ptes);
+				pte_free(vma->vm_mm, pmd_pgtable(_pmd));
+			}
 		}
 	}
 	i_mmap_unlock_write(mapping);
diff -puN mm/memory.c~mm-thp-page-cache-support-for-ppc64 mm/memory.c
--- a/mm/memory.c~mm-thp-page-cache-support-for-ppc64
+++ a/mm/memory.c
@@ -2935,6 +2935,19 @@ static inline bool transhuge_vma_suitabl
 	return true;
 }
 
+static void deposit_prealloc_pte(struct fault_env *fe)
+{
+	struct vm_area_struct *vma = fe->vma;
+
+	pgtable_trans_huge_deposit(vma->vm_mm, fe->pmd, fe->prealloc_pte);
+	/*
+	 * We are going to consume the prealloc table,
+	 * count that as nr_ptes.
+	 */
+	atomic_long_inc(&vma->vm_mm->nr_ptes);
+	fe->prealloc_pte = 0;
+}
+
 static int do_set_pmd(struct fault_env *fe, struct page *page)
 {
 	struct vm_area_struct *vma = fe->vma;
@@ -2949,6 +2962,17 @@ static int do_set_pmd(struct fault_env *
 	ret = VM_FAULT_FALLBACK;
 	page = compound_head(page);
 
+	/*
+	 * Archs like ppc64 need additonal space to store information
+	 * related to pte entry. Use the preallocated table for that.
+	 */
+	if (arch_needs_pgtable_deposit() && !fe->prealloc_pte) {
+		fe->prealloc_pte = pte_alloc_one(vma->vm_mm, fe->address);
+		if (!fe->prealloc_pte)
+			return VM_FAULT_OOM;
+		smp_wmb(); /* See comment in __pte_alloc() */
+	}
+
 	fe->ptl = pmd_lock(vma->vm_mm, fe->pmd);
 	if (unlikely(!pmd_none(*fe->pmd)))
 		goto out;
@@ -2962,6 +2986,11 @@ static int do_set_pmd(struct fault_env *
 
 	add_mm_counter(vma->vm_mm, MM_FILEPAGES, HPAGE_PMD_NR);
 	page_add_file_rmap(page, true);
+	/*
+	 * deposit and withdraw with pmd lock held
+	 */
+	if (arch_needs_pgtable_deposit())
+		deposit_prealloc_pte(fe);
 
 	set_pmd_at(vma->vm_mm, haddr, fe->pmd, entry);
 
@@ -2971,6 +3000,13 @@ static int do_set_pmd(struct fault_env *
 	ret = 0;
 	count_vm_event(THP_FILE_MAPPED);
 out:
+	/*
+	 * If we are going to fallback to pte mapping, do a
+	 * withdraw with pmd lock held.
+	 */
+	if (arch_needs_pgtable_deposit() && ret == VM_FAULT_FALLBACK)
+		fe->prealloc_pte = pgtable_trans_huge_withdraw(vma->vm_mm,
+							       fe->pmd);
 	spin_unlock(fe->ptl);
 	return ret;
 }
@@ -3010,18 +3046,20 @@ int alloc_set_pte(struct fault_env *fe,
 
 		ret = do_set_pmd(fe, page);
 		if (ret != VM_FAULT_FALLBACK)
-			return ret;
+			goto fault_handled;
 	}
 
 	if (!fe->pte) {
 		ret = pte_alloc_one_map(fe);
 		if (ret)
-			return ret;
+			goto fault_handled;
 	}
 
 	/* Re-check under ptl */
-	if (unlikely(!pte_none(*fe->pte)))
-		return VM_FAULT_NOPAGE;
+	if (unlikely(!pte_none(*fe->pte))) {
+		ret = VM_FAULT_NOPAGE;
+		goto fault_handled;
+	}
 
 	flush_icache_page(vma, page);
 	entry = mk_pte(page, vma->vm_page_prot);
@@ -3041,8 +3079,15 @@ int alloc_set_pte(struct fault_env *fe,
 
 	/* no need to invalidate: a not-present page won't be cached */
 	update_mmu_cache(vma, fe->address, fe->pte);
+	ret = 0;
 
-	return 0;
+fault_handled:
+	/* preallocated pagetable is unused: free it */
+	if (fe->prealloc_pte) {
+		pte_free(fe->vma->vm_mm, fe->prealloc_pte);
+		fe->prealloc_pte = 0;
+	}
+	return ret;
 }
 
 static unsigned long fault_around_bytes __read_mostly =
@@ -3141,11 +3186,6 @@ static int do_fault_around(struct fault_
 
 	fe->vma->vm_ops->map_pages(fe, start_pgoff, end_pgoff);
 
-	/* preallocated pagetable is unused: free it */
-	if (fe->prealloc_pte) {
-		pte_free(fe->vma->vm_mm, fe->prealloc_pte);
-		fe->prealloc_pte = 0;
-	}
 	/* Huge page is mapped? Page fault is solved */
 	if (pmd_trans_huge(*fe->pmd)) {
 		ret = VM_FAULT_NOPAGE;
_
