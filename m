From: akpm@linux-foundation.org
Subject: [merged] mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:13:48 -0800
Message-ID: <569e98fc.lmnT4k8nDxfelydF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbcASUNt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, aarcange@redhat.com, dave@sr71.net, kirill.shutemov@linux.intel.com, mgorman@suse.de, peterz@infradead.org, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax: dax-pmd vs thp-pmd vs hugetlbfs-pmd
has been removed from the -mm tree.  Its filename was
     mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm, dax: dax-pmd vs thp-pmd vs hugetlbfs-pmd

A dax-huge-page mapping while it uses some thp helpers is ultimately not a
transparent huge page.  The distinction is especially important in the
get_user_pages() path.  pmd_devmap() is used to distinguish dax-pmds from
pmd_huge() and pmd_trans_huge() which have slightly different semantics.

Explicitly mark the pmd_trans_huge() helpers that dax needs by adding
pmd_devmap() checks.

[kirill.shutemov@linux.intel.com: fix regression in handling mlocked pages in  __split_huge_pmd()]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    9 ++++++-
 include/linux/huge_mm.h        |    5 ++--
 include/linux/mm.h             |    7 +++++
 mm/huge_memory.c               |   38 +++++++++++++++++--------------
 mm/memory.c                    |    8 +++---
 mm/mprotect.c                  |    5 ++--
 mm/pgtable-generic.c           |    2 -
 7 files changed, 47 insertions(+), 27 deletions(-)

diff -puN arch/x86/include/asm/pgtable.h~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd
+++ a/arch/x86/include/asm/pgtable.h
@@ -164,13 +164,20 @@ static inline int pmd_large(pmd_t pte)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline int pmd_trans_huge(pmd_t pmd)
 {
-	return pmd_val(pmd) & _PAGE_PSE;
+	return (pmd_val(pmd) & (_PAGE_PSE|_PAGE_DEVMAP)) == _PAGE_PSE;
 }
 
 static inline int has_transparent_hugepage(void)
 {
 	return cpu_has_pse;
 }
+
+#ifdef __HAVE_ARCH_PTE_DEVMAP
+static inline int pmd_devmap(pmd_t pmd)
+{
+	return !!(pmd_val(pmd) & _PAGE_DEVMAP);
+}
+#endif
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static inline pte_t pte_set_flags(pte_t pte, pteval_t set)
diff -puN include/linux/huge_mm.h~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd
+++ a/include/linux/huge_mm.h
@@ -104,7 +104,8 @@ void __split_huge_pmd(struct vm_area_str
 #define split_huge_pmd(__vma, __pmd, __address)				\
 	do {								\
 		pmd_t *____pmd = (__pmd);				\
-		if (pmd_trans_huge(*____pmd))				\
+		if (pmd_trans_huge(*____pmd)				\
+					|| pmd_devmap(*____pmd))	\
 			__split_huge_pmd(__vma, __pmd, __address);	\
 	}  while (0)
 
@@ -124,7 +125,7 @@ static inline bool pmd_trans_huge_lock(p
 		spinlock_t **ptl)
 {
 	VM_BUG_ON_VMA(!rwsem_is_locked(&vma->vm_mm->mmap_sem), vma);
-	if (pmd_trans_huge(*pmd))
+	if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd))
 		return __pmd_trans_huge_lock(pmd, vma, ptl);
 	else
 		return false;
diff -puN include/linux/mm.h~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd include/linux/mm.h
--- a/include/linux/mm.h~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd
+++ a/include/linux/mm.h
@@ -329,6 +329,13 @@ struct inode;
 #define page_private(page)		((page)->private)
 #define set_page_private(page, v)	((page)->private = (v))
 
+#if !defined(__HAVE_ARCH_PTE_DEVMAP) || !defined(CONFIG_TRANSPARENT_HUGEPAGE)
+static inline int pmd_devmap(pmd_t pmd)
+{
+	return 0;
+}
+#endif
+
 /*
  * FIXME: take this include out, include page-flags.h in
  * files which need it (119 of them)
diff -puN mm/huge_memory.c~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd mm/huge_memory.c
--- a/mm/huge_memory.c~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd
+++ a/mm/huge_memory.c
@@ -995,7 +995,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 
 	ret = -EAGAIN;
 	pmd = *src_pmd;
-	if (unlikely(!pmd_trans_huge(pmd))) {
+	if (unlikely(!pmd_trans_huge(pmd) && !pmd_devmap(pmd))) {
 		pte_free(dst_mm, pgtable);
 		goto out_unlock;
 	}
@@ -1018,17 +1018,20 @@ int copy_huge_pmd(struct mm_struct *dst_
 		goto out_unlock;
 	}
 
-	src_page = pmd_page(pmd);
-	VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
-	get_page(src_page);
-	page_dup_rmap(src_page, true);
-	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
+	if (pmd_trans_huge(pmd)) {
+		/* thp accounting separate from pmd_devmap accounting */
+		src_page = pmd_page(pmd);
+		VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
+		get_page(src_page);
+		page_dup_rmap(src_page, true);
+		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
+		atomic_long_inc(&dst_mm->nr_ptes);
+		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
+	}
 
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
 	pmd = pmd_mkold(pmd_wrprotect(pmd));
-	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
-	atomic_long_inc(&dst_mm->nr_ptes);
 
 	ret = 0;
 out_unlock:
@@ -1716,7 +1719,7 @@ bool __pmd_trans_huge_lock(pmd_t *pmd, s
 		spinlock_t **ptl)
 {
 	*ptl = pmd_lock(vma->vm_mm, pmd);
-	if (likely(pmd_trans_huge(*pmd)))
+	if (likely(pmd_trans_huge(*pmd) || pmd_devmap(*pmd)))
 		return true;
 	spin_unlock(*ptl);
 	return false;
@@ -2788,7 +2791,7 @@ static void __split_huge_pmd_locked(stru
 	VM_BUG_ON(haddr & ~HPAGE_PMD_MASK);
 	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
 	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PMD_SIZE, vma);
-	VM_BUG_ON(!pmd_trans_huge(*pmd));
+	VM_BUG_ON(!pmd_trans_huge(*pmd) && !pmd_devmap(*pmd));
 
 	count_vm_event(THP_SPLIT_PMD);
 
@@ -2901,14 +2904,15 @@ void __split_huge_pmd(struct vm_area_str
 
 	mmu_notifier_invalidate_range_start(mm, haddr, haddr + HPAGE_PMD_SIZE);
 	ptl = pmd_lock(mm, pmd);
-	if (unlikely(!pmd_trans_huge(*pmd)))
+	if (pmd_trans_huge(*pmd)) {
+		page = pmd_page(*pmd);
+		if (PageMlocked(page))
+			get_page(page);
+		else
+			page = NULL;
+	} else if (!pmd_devmap(*pmd))
 		goto out;
-	page = pmd_page(*pmd);
 	__split_huge_pmd_locked(vma, pmd, haddr, false);
-	if (PageMlocked(page))
-		get_page(page);
-	else
-		page = NULL;
 out:
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(mm, haddr, haddr + HPAGE_PMD_SIZE);
@@ -2938,7 +2942,7 @@ static void split_huge_pmd_address(struc
 		return;
 
 	pmd = pmd_offset(pud, address);
-	if (!pmd_present(*pmd) || !pmd_trans_huge(*pmd))
+	if (!pmd_present(*pmd) || (!pmd_trans_huge(*pmd) && !pmd_devmap(*pmd)))
 		return;
 	/*
 	 * Caller holds the mmap_sem write mode, so a huge pmd cannot
diff -puN mm/memory.c~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd mm/memory.c
--- a/mm/memory.c~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd
+++ a/mm/memory.c
@@ -950,7 +950,7 @@ static inline int copy_pmd_range(struct
 	src_pmd = pmd_offset(src_pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		if (pmd_trans_huge(*src_pmd)) {
+		if (pmd_trans_huge(*src_pmd) || pmd_devmap(*src_pmd)) {
 			int err;
 			VM_BUG_ON(next-addr != HPAGE_PMD_SIZE);
 			err = copy_huge_pmd(dst_mm, src_mm,
@@ -1177,7 +1177,7 @@ static inline unsigned long zap_pmd_rang
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		if (pmd_trans_huge(*pmd)) {
+		if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE) {
 #ifdef CONFIG_DEBUG_VM
 				if (!rwsem_is_locked(&tlb->mm->mmap_sem)) {
@@ -3375,7 +3375,7 @@ static int __handle_mm_fault(struct mm_s
 		int ret;
 
 		barrier();
-		if (pmd_trans_huge(orig_pmd)) {
+		if (pmd_trans_huge(orig_pmd) || pmd_devmap(orig_pmd)) {
 			unsigned int dirty = flags & FAULT_FLAG_WRITE;
 
 			if (pmd_protnone(orig_pmd))
@@ -3404,7 +3404,7 @@ static int __handle_mm_fault(struct mm_s
 	    unlikely(__pte_alloc(mm, vma, pmd, address)))
 		return VM_FAULT_OOM;
 	/* if an huge pmd materialized from under us just retry later */
-	if (unlikely(pmd_trans_huge(*pmd)))
+	if (unlikely(pmd_trans_huge(*pmd) || pmd_devmap(*pmd)))
 		return 0;
 	/*
 	 * A regular pmd is established and it can't morph into a huge pmd
diff -puN mm/mprotect.c~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd mm/mprotect.c
--- a/mm/mprotect.c~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd
+++ a/mm/mprotect.c
@@ -149,7 +149,8 @@ static inline unsigned long change_pmd_r
 		unsigned long this_pages;
 
 		next = pmd_addr_end(addr, end);
-		if (!pmd_trans_huge(*pmd) && pmd_none_or_clear_bad(pmd))
+		if (!pmd_trans_huge(*pmd) && !pmd_devmap(*pmd)
+				&& pmd_none_or_clear_bad(pmd))
 			continue;
 
 		/* invoke the mmu notifier if the pmd is populated */
@@ -158,7 +159,7 @@ static inline unsigned long change_pmd_r
 			mmu_notifier_invalidate_range_start(mm, mni_start, end);
 		}
 
-		if (pmd_trans_huge(*pmd)) {
+		if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
 				split_huge_pmd(vma, pmd, addr);
 			else {
diff -puN mm/pgtable-generic.c~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd
+++ a/mm/pgtable-generic.c
@@ -132,7 +132,7 @@ pmd_t pmdp_huge_clear_flush(struct vm_ar
 {
 	pmd_t pmd;
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-	VM_BUG_ON(!pmd_trans_huge(*pmdp));
+	VM_BUG_ON(!pmd_trans_huge(*pmdp) && !pmd_devmap(*pmdp));
 	pmd = pmdp_huge_get_and_clear(vma->vm_mm, address, pmdp);
 	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return pmd;
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dax-add-support-for-fsync-sync-v6-fix.patch

