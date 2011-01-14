From: akpm@linux-foundation.org
Subject: [merged] thp-pte-alloc-trans-splitting.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:57 -0800
Message-ID: <201101142249.p0EMnlGe005323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753860Ab1ANWuA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: pte alloc trans splitting
has been removed from the -mm tree.  Its filename was
     thp-pte-alloc-trans-splitting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: pte alloc trans splitting
From: Andrea Arcangeli <aarcange@redhat.com>

pte alloc routines must wait for split_huge_page if the pmd is not present
and not null (i.e.  pmd_trans_splitting).  The additional branches are
optimized away at compile time by pmd_trans_splitting if the config option
is off.  However we must pass the vma down in order to know the anon_vma
lock to wait for.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/pgd.c           |    2 +-
 arch/ia64/mm/hugetlbpage.c  |    2 +-
 arch/sh/mm/hugetlbpage.c    |    2 +-
 arch/sparc/mm/generic_32.c  |    2 +-
 arch/sparc/mm/generic_64.c  |    2 +-
 arch/sparc/mm/hugetlbpage.c |    2 +-
 arch/um/kernel/skas/mmu.c   |    2 +-
 arch/x86/kernel/tboot.c     |    2 +-
 include/linux/mm.h          |   15 +++++++++------
 mm/memory.c                 |   19 +++++++++++++------
 mm/mremap.c                 |    8 +++++---
 11 files changed, 35 insertions(+), 23 deletions(-)

diff -puN arch/arm/mm/pgd.c~thp-pte-alloc-trans-splitting arch/arm/mm/pgd.c
--- a/arch/arm/mm/pgd.c~thp-pte-alloc-trans-splitting
+++ a/arch/arm/mm/pgd.c
@@ -50,7 +50,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 		if (!new_pmd)
 			goto no_pmd;
 
-		new_pte = pte_alloc_map(mm, new_pmd, 0);
+		new_pte = pte_alloc_map(mm, NULL, new_pmd, 0);
 		if (!new_pte)
 			goto no_pte;
 
diff -puN arch/ia64/mm/hugetlbpage.c~thp-pte-alloc-trans-splitting arch/ia64/mm/hugetlbpage.c
--- a/arch/ia64/mm/hugetlbpage.c~thp-pte-alloc-trans-splitting
+++ a/arch/ia64/mm/hugetlbpage.c
@@ -38,7 +38,7 @@ huge_pte_alloc(struct mm_struct *mm, uns
 	if (pud) {
 		pmd = pmd_alloc(mm, pud, taddr);
 		if (pmd)
-			pte = pte_alloc_map(mm, pmd, taddr);
+			pte = pte_alloc_map(mm, NULL, pmd, taddr);
 	}
 	return pte;
 }
diff -puN arch/sh/mm/hugetlbpage.c~thp-pte-alloc-trans-splitting arch/sh/mm/hugetlbpage.c
--- a/arch/sh/mm/hugetlbpage.c~thp-pte-alloc-trans-splitting
+++ a/arch/sh/mm/hugetlbpage.c
@@ -35,7 +35,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 		if (pud) {
 			pmd = pmd_alloc(mm, pud, addr);
 			if (pmd)
-				pte = pte_alloc_map(mm, pmd, addr);
+				pte = pte_alloc_map(mm, NULL, pmd, addr);
 		}
 	}
 
diff -puN arch/sparc/mm/generic_32.c~thp-pte-alloc-trans-splitting arch/sparc/mm/generic_32.c
--- a/arch/sparc/mm/generic_32.c~thp-pte-alloc-trans-splitting
+++ a/arch/sparc/mm/generic_32.c
@@ -50,7 +50,7 @@ static inline int io_remap_pmd_range(str
 		end = PGDIR_SIZE;
 	offset -= address;
 	do {
-		pte_t * pte = pte_alloc_map(mm, pmd, address);
+		pte_t *pte = pte_alloc_map(mm, NULL, pmd, address);
 		if (!pte)
 			return -ENOMEM;
 		io_remap_pte_range(mm, pte, address, end - address, address + offset, prot, space);
diff -puN arch/sparc/mm/generic_64.c~thp-pte-alloc-trans-splitting arch/sparc/mm/generic_64.c
--- a/arch/sparc/mm/generic_64.c~thp-pte-alloc-trans-splitting
+++ a/arch/sparc/mm/generic_64.c
@@ -92,7 +92,7 @@ static inline int io_remap_pmd_range(str
 		end = PGDIR_SIZE;
 	offset -= address;
 	do {
-		pte_t * pte = pte_alloc_map(mm, pmd, address);
+		pte_t *pte = pte_alloc_map(mm, NULL, pmd, address);
 		if (!pte)
 			return -ENOMEM;
 		io_remap_pte_range(mm, pte, address, end - address, address + offset, prot, space);
diff -puN arch/sparc/mm/hugetlbpage.c~thp-pte-alloc-trans-splitting arch/sparc/mm/hugetlbpage.c
--- a/arch/sparc/mm/hugetlbpage.c~thp-pte-alloc-trans-splitting
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -214,7 +214,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 	if (pud) {
 		pmd = pmd_alloc(mm, pud, addr);
 		if (pmd)
-			pte = pte_alloc_map(mm, pmd, addr);
+			pte = pte_alloc_map(mm, NULL, pmd, addr);
 	}
 	return pte;
 }
diff -puN arch/um/kernel/skas/mmu.c~thp-pte-alloc-trans-splitting arch/um/kernel/skas/mmu.c
--- a/arch/um/kernel/skas/mmu.c~thp-pte-alloc-trans-splitting
+++ a/arch/um/kernel/skas/mmu.c
@@ -31,7 +31,7 @@ static int init_stub_pte(struct mm_struc
 	if (!pmd)
 		goto out_pmd;
 
-	pte = pte_alloc_map(mm, pmd, proc);
+	pte = pte_alloc_map(mm, NULL, pmd, proc);
 	if (!pte)
 		goto out_pte;
 
diff -puN arch/x86/kernel/tboot.c~thp-pte-alloc-trans-splitting arch/x86/kernel/tboot.c
--- a/arch/x86/kernel/tboot.c~thp-pte-alloc-trans-splitting
+++ a/arch/x86/kernel/tboot.c
@@ -133,7 +133,7 @@ static int map_tboot_page(unsigned long 
 	pmd = pmd_alloc(&tboot_mm, pud, vaddr);
 	if (!pmd)
 		return -1;
-	pte = pte_alloc_map(&tboot_mm, pmd, vaddr);
+	pte = pte_alloc_map(&tboot_mm, NULL, pmd, vaddr);
 	if (!pte)
 		return -1;
 	set_pte_at(&tboot_mm, vaddr, pte, pfn_pte(pfn, prot));
diff -puN include/linux/mm.h~thp-pte-alloc-trans-splitting include/linux/mm.h
--- a/include/linux/mm.h~thp-pte-alloc-trans-splitting
+++ a/include/linux/mm.h
@@ -1131,7 +1131,8 @@ static inline int __pmd_alloc(struct mm_
 int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address);
 #endif
 
-int __pte_alloc(struct mm_struct *mm, pmd_t *pmd, unsigned long address);
+int __pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
+		pmd_t *pmd, unsigned long address);
 int __pte_alloc_kernel(pmd_t *pmd, unsigned long address);
 
 /*
@@ -1200,16 +1201,18 @@ static inline void pgtable_page_dtor(str
 	pte_unmap(pte);					\
 } while (0)
 
-#define pte_alloc_map(mm, pmd, address)			\
-	((unlikely(!pmd_present(*(pmd))) && __pte_alloc(mm, pmd, address))? \
-		NULL: pte_offset_map(pmd, address))
+#define pte_alloc_map(mm, vma, pmd, address)				\
+	((unlikely(pmd_none(*(pmd))) && __pte_alloc(mm, vma,	\
+							pmd, address))?	\
+	 NULL: pte_offset_map(pmd, address))
 
 #define pte_alloc_map_lock(mm, pmd, address, ptlp)	\
-	((unlikely(!pmd_present(*(pmd))) && __pte_alloc(mm, pmd, address))? \
+	((unlikely(pmd_none(*(pmd))) && __pte_alloc(mm, NULL,	\
+							pmd, address))?	\
 		NULL: pte_offset_map_lock(mm, pmd, address, ptlp))
 
 #define pte_alloc_kernel(pmd, address)			\
-	((unlikely(!pmd_present(*(pmd))) && __pte_alloc_kernel(pmd, address))? \
+	((unlikely(pmd_none(*(pmd))) && __pte_alloc_kernel(pmd, address))? \
 		NULL: pte_offset_kernel(pmd, address))
 
 extern void free_area_init(unsigned long * zones_size);
diff -puN mm/memory.c~thp-pte-alloc-trans-splitting mm/memory.c
--- a/mm/memory.c~thp-pte-alloc-trans-splitting
+++ a/mm/memory.c
@@ -394,9 +394,11 @@ void free_pgtables(struct mmu_gather *tl
 	}
 }
 
-int __pte_alloc(struct mm_struct *mm, pmd_t *pmd, unsigned long address)
+int __pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
+		pmd_t *pmd, unsigned long address)
 {
 	pgtable_t new = pte_alloc_one(mm, address);
+	int wait_split_huge_page;
 	if (!new)
 		return -ENOMEM;
 
@@ -416,14 +418,18 @@ int __pte_alloc(struct mm_struct *mm, pm
 	smp_wmb(); /* Could be smp_wmb__xxx(before|after)_spin_lock */
 
 	spin_lock(&mm->page_table_lock);
-	if (!pmd_present(*pmd)) {	/* Has another populated it ? */
+	wait_split_huge_page = 0;
+	if (likely(pmd_none(*pmd))) {	/* Has another populated it ? */
 		mm->nr_ptes++;
 		pmd_populate(mm, pmd, new);
 		new = NULL;
-	}
+	} else if (unlikely(pmd_trans_splitting(*pmd)))
+		wait_split_huge_page = 1;
 	spin_unlock(&mm->page_table_lock);
 	if (new)
 		pte_free(mm, new);
+	if (wait_split_huge_page)
+		wait_split_huge_page(vma->anon_vma, pmd);
 	return 0;
 }
 
@@ -436,10 +442,11 @@ int __pte_alloc_kernel(pmd_t *pmd, unsig
 	smp_wmb(); /* See comment in __pte_alloc */
 
 	spin_lock(&init_mm.page_table_lock);
-	if (!pmd_present(*pmd)) {	/* Has another populated it ? */
+	if (likely(pmd_none(*pmd))) {	/* Has another populated it ? */
 		pmd_populate_kernel(&init_mm, pmd, new);
 		new = NULL;
-	}
+	} else
+		VM_BUG_ON(pmd_trans_splitting(*pmd));
 	spin_unlock(&init_mm.page_table_lock);
 	if (new)
 		pte_free_kernel(&init_mm, new);
@@ -3253,7 +3260,7 @@ int handle_mm_fault(struct mm_struct *mm
 	pmd = pmd_alloc(mm, pud, address);
 	if (!pmd)
 		return VM_FAULT_OOM;
-	pte = pte_alloc_map(mm, pmd, address);
+	pte = pte_alloc_map(mm, vma, pmd, address);
 	if (!pte)
 		return VM_FAULT_OOM;
 
diff -puN mm/mremap.c~thp-pte-alloc-trans-splitting mm/mremap.c
--- a/mm/mremap.c~thp-pte-alloc-trans-splitting
+++ a/mm/mremap.c
@@ -47,7 +47,8 @@ static pmd_t *get_old_pmd(struct mm_stru
 	return pmd;
 }
 
-static pmd_t *alloc_new_pmd(struct mm_struct *mm, unsigned long addr)
+static pmd_t *alloc_new_pmd(struct mm_struct *mm, struct vm_area_struct *vma,
+			    unsigned long addr)
 {
 	pgd_t *pgd;
 	pud_t *pud;
@@ -62,7 +63,8 @@ static pmd_t *alloc_new_pmd(struct mm_st
 	if (!pmd)
 		return NULL;
 
-	if (!pmd_present(*pmd) && __pte_alloc(mm, pmd, addr))
+	VM_BUG_ON(pmd_trans_huge(*pmd));
+	if (pmd_none(*pmd) && __pte_alloc(mm, vma, pmd, addr))
 		return NULL;
 
 	return pmd;
@@ -147,7 +149,7 @@ unsigned long move_page_tables(struct vm
 		old_pmd = get_old_pmd(vma->vm_mm, old_addr);
 		if (!old_pmd)
 			continue;
-		new_pmd = alloc_new_pmd(vma->vm_mm, new_addr);
+		new_pmd = alloc_new_pmd(vma->vm_mm, vma, new_addr);
 		if (!new_pmd)
 			break;
 		next = (new_addr + PMD_SIZE) & PMD_MASK;
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

