From: akpm@linux-foundation.org
Subject: + mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch added to -mm
 tree
Date: Tue, 15 Dec 2015 16:17:18 -0800
Message-ID: <5670ad8e.7jbq3EuIVLdJ1FgP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727AbbLPART (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:17:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, aarcange@redhat.com, dave.hansen@linux.intel.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, peterz@infradead.org, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax: dax-pmd vs thp-pmd vs hugetlbfs-pmd
has been added to the -mm tree.  Its filename is
     mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm, dax: dax-pmd vs thp-pmd vs hugetlbfs-pmd

A dax-huge-page mapping while it uses some thp helpers is ultimately not a
transparent huge page.  The distinction is especially important in the
get_user_pages() path.  pmd_devmap() is used to distinguish dax-pmds from
pmd_huge() and pmd_trans_huge() which have slightly different semantics.

Explicitly mark the pmd_trans_huge() helpers that dax needs by adding
pmd_devmap() checks.

Also, before we introduce usages of pmd_pfn() in common code, include a
definition for archs that have not needed it to date.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/pgtable.h      |    1 
 arch/sh/include/asm/pgtable-3level.h |    1 
 arch/x86/include/asm/pgtable.h       |    8 +++++-
 include/asm-generic/pgtable.h        |    4 +++
 include/linux/huge_mm.h              |    3 +-
 include/linux/mm.h                   |    4 +++
 mm/huge_memory.c                     |   33 ++++++++++++++-----------
 mm/memory.c                          |    8 +++---
 mm/mprotect.c                        |    5 ++-
 mm/pgtable-generic.c                 |    2 -
 10 files changed, 46 insertions(+), 23 deletions(-)

diff -puN arch/ia64/include/asm/pgtable.h~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd arch/ia64/include/asm/pgtable.h
--- a/arch/ia64/include/asm/pgtable.h~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd
+++ a/arch/ia64/include/asm/pgtable.h
@@ -273,6 +273,7 @@ extern unsigned long VMALLOC_END;
 #define pmd_clear(pmdp)			(pmd_val(*(pmdp)) = 0UL)
 #define pmd_page_vaddr(pmd)		((unsigned long) __va(pmd_val(pmd) & _PFN_MASK))
 #define pmd_page(pmd)			virt_to_page((pmd_val(pmd) + PAGE_OFFSET))
+#define pmd_pfn(pmd)			(pmd_val(pmd) >> PAGE_SHIFT)
 
 #define pud_none(pud)			(!pud_val(pud))
 #define pud_bad(pud)			(!ia64_phys_addr_valid(pud_val(pud)))
diff -puN arch/sh/include/asm/pgtable-3level.h~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd arch/sh/include/asm/pgtable-3level.h
--- a/arch/sh/include/asm/pgtable-3level.h~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd
+++ a/arch/sh/include/asm/pgtable-3level.h
@@ -29,6 +29,7 @@
 
 typedef struct { unsigned long long pmd; } pmd_t;
 #define pmd_val(x)	((x).pmd)
+#define pmd_pfn(x)	((pmd_val(x) & PMD_MASK) >> PAGE_SHIFT)
 #define __pmd(x)	((pmd_t) { (x) } )
 
 static inline unsigned long pud_page_vaddr(pud_t pud)
diff -puN arch/x86/include/asm/pgtable.h~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd
+++ a/arch/x86/include/asm/pgtable.h
@@ -167,7 +167,13 @@ static inline int pmd_large(pmd_t pte)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline int pmd_trans_huge(pmd_t pmd)
 {
-	return pmd_val(pmd) & _PAGE_PSE;
+	return (pmd_val(pmd) & (_PAGE_PSE|_PAGE_DEVMAP)) == _PAGE_PSE;
+}
+
+#define pmd_devmap pmd_devmap
+static inline int pmd_devmap(pmd_t pmd)
+{
+	return !!(pmd_val(pmd) & _PAGE_DEVMAP);
 }
 
 static inline int has_transparent_hugepage(void)
diff -puN include/asm-generic/pgtable.h~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd
+++ a/include/asm-generic/pgtable.h
@@ -616,6 +616,10 @@ static inline int pmd_trans_huge(pmd_t p
 {
 	return 0;
 }
+static inline int pmd_devmap(pmd_t pmd)
+{
+	return 0;
+}
 #ifndef __HAVE_ARCH_PMD_WRITE
 static inline int pmd_write(pmd_t pmd)
 {
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
 
diff -puN include/linux/mm.h~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd include/linux/mm.h
--- a/include/linux/mm.h~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd
+++ a/include/linux/mm.h
@@ -1944,6 +1944,10 @@ static inline void pgtable_pmd_page_dtor
 #define pte_devmap(x) (0)
 #endif
 
+#ifndef pmd_devmap
+#define pmd_devmap(x) (0)
+#endif
+
 static inline spinlock_t *pmd_lock(struct mm_struct *mm, pmd_t *pmd)
 {
 	spinlock_t *ptl = pmd_lockptr(mm, pmd);
diff -puN mm/huge_memory.c~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd mm/huge_memory.c
--- a/mm/huge_memory.c~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd
+++ a/mm/huge_memory.c
@@ -1023,7 +1023,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 
 	ret = -EAGAIN;
 	pmd = *src_pmd;
-	if (unlikely(!pmd_trans_huge(pmd))) {
+	if (unlikely(!pmd_trans_huge(pmd) && !pmd_devmap(pmd))) {
 		pte_free(dst_mm, pgtable);
 		goto out_unlock;
 	}
@@ -1046,17 +1046,20 @@ int copy_huge_pmd(struct mm_struct *dst_
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
@@ -1744,7 +1747,7 @@ bool __pmd_trans_huge_lock(pmd_t *pmd, s
 		spinlock_t **ptl)
 {
 	*ptl = pmd_lock(vma->vm_mm, pmd);
-	if (likely(pmd_trans_huge(*pmd)))
+	if (likely(pmd_trans_huge(*pmd) || pmd_devmap(*pmd)))
 		return true;
 	spin_unlock(*ptl);
 	return false;
@@ -2861,7 +2864,7 @@ static void __split_huge_pmd_locked(stru
 	VM_BUG_ON(haddr & ~HPAGE_PMD_MASK);
 	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
 	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PMD_SIZE, vma);
-	VM_BUG_ON(!pmd_trans_huge(*pmd));
+	VM_BUG_ON(!pmd_trans_huge(*pmd) && !pmd_devmap(*pmd));
 
 	count_vm_event(THP_SPLIT_PMD);
 
@@ -2974,11 +2977,13 @@ void __split_huge_pmd(struct vm_area_str
 
 	mmu_notifier_invalidate_range_start(mm, haddr, haddr + HPAGE_PMD_SIZE);
 	ptl = pmd_lock(mm, pmd);
-	if (unlikely(!pmd_trans_huge(*pmd)))
+	if (unlikely(!pmd_trans_huge(*pmd) && !pmd_devmap(*pmd)))
 		goto out;
-	page = pmd_page(*pmd);
 	__split_huge_pmd_locked(vma, pmd, haddr, false);
-	if (PageMlocked(page))
+
+	if (pmd_trans_huge(*pmd))
+		page = pmd_page(*pmd);
+	if (page && PageMlocked(page))
 		get_page(page);
 	else
 		page = NULL;
@@ -3011,7 +3016,7 @@ static void split_huge_pmd_address(struc
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
@@ -949,7 +949,7 @@ static inline int copy_pmd_range(struct
 	src_pmd = pmd_offset(src_pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		if (pmd_trans_huge(*src_pmd)) {
+		if (pmd_trans_huge(*src_pmd) || pmd_devmap(*src_pmd)) {
 			int err;
 			VM_BUG_ON(next-addr != HPAGE_PMD_SIZE);
 			err = copy_huge_pmd(dst_mm, src_mm,
@@ -1176,7 +1176,7 @@ static inline unsigned long zap_pmd_rang
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		if (pmd_trans_huge(*pmd)) {
+		if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE) {
 #ifdef CONFIG_DEBUG_VM
 				if (!rwsem_is_locked(&tlb->mm->mmap_sem)) {
@@ -3374,7 +3374,7 @@ static int __handle_mm_fault(struct mm_s
 		int ret;
 
 		barrier();
-		if (pmd_trans_huge(orig_pmd)) {
+		if (pmd_trans_huge(orig_pmd) || pmd_devmap(orig_pmd)) {
 			unsigned int dirty = flags & FAULT_FLAG_WRITE;
 
 			if (pmd_protnone(orig_pmd))
@@ -3403,7 +3403,7 @@ static int __handle_mm_fault(struct mm_s
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

scatterlist-fix-sg_phys-masking.patch
pmem-dax-clean-up-clear_pmem.patch
dax-increase-granularity-of-dax_clear_blocks-operations.patch
dax-guarantee-page-aligned-results-from-bdev_direct_access.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic-v3.patch
um-kill-pfn_t.patch
kvm-rename-pfn_t-to-kvm_pfn_t.patch
mm-dax-pmem-introduce-pfn_t.patch
mm-dax-pmem-introduce-pfn_t-v3.patch
mm-introduce-find_dev_pagemap.patch
x86-mm-introduce-vmem_altmap-to-augment-vmemmap_populate.patch
libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch
avr32-convert-to-asm-generic-memory_modelh.patch
hugetlb-fix-compile-error-on-tile.patch
frv-fix-compiler-warning-from-definition-of-__pmd.patch
x86-mm-introduce-_page_devmap.patch
mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch
mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch
list-introduce-list_del_poison.patch
libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch
mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch
mm-x86-get_user_pages-for-dax-mappings.patch
dax-provide-diagnostics-for-pmd-mapping-failures.patch
dax-re-enable-dax-pmd-mappings.patch

