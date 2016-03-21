From: akpm@linux-foundation.org
Subject: [merged] mm-cleanup-pte_alloc-interfaces.patch removed from -mm
 tree
Date: Mon, 21 Mar 2016 11:39:23 -0700
Message-ID: <56f03fdb.k7DoEWgph4kq0fGE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbcCUT4f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dave.hansen@intel.com, sfr@canb.auug.org.au, sudeep.holla@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cleanup *pte_alloc* interfaces
has been removed from the -mm tree.  Its filename was
     mm-cleanup-pte_alloc-interfaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: cleanup *pte_alloc* interfaces

There are few things about *pte_alloc*() helpers worth cleaning up:

 - 'vma' argument is unused, let's drop it;

 - most __pte_alloc() callers do speculative check for pmd_none(),
   before taking ptl: let's introduce pte_alloc() macro which does
   the check.

   The only direct user of __pte_alloc left is userfaultfd, which has
   different expectation about atomicity wrt pmd.

 - pte_alloc_map() and pte_alloc_map_lock() are redefined using
   pte_alloc().

[sudeep.holla@arm.com: fix build for arm64 hugetlbpage]
[sfr@canb.auug.org.au: fix arch/arm/mm/mmu.c some more]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/mmu.c            |    6 +++---
 arch/arm/mm/pgd.c            |    2 +-
 arch/arm64/mm/hugetlbpage.c  |    2 +-
 arch/ia64/mm/hugetlbpage.c   |    2 +-
 arch/metag/mm/hugetlbpage.c  |    2 +-
 arch/parisc/mm/hugetlbpage.c |    2 +-
 arch/sh/mm/hugetlbpage.c     |    2 +-
 arch/sparc/mm/hugetlbpage.c  |    2 +-
 arch/tile/mm/hugetlbpage.c   |    2 +-
 arch/um/kernel/skas/mmu.c    |    2 +-
 arch/unicore32/mm/pgd.c      |    2 +-
 arch/x86/kernel/tboot.c      |    2 +-
 include/linux/mm.h           |   17 ++++++++---------
 mm/memory.c                  |    8 +++-----
 mm/mremap.c                  |    3 +--
 mm/userfaultfd.c             |    3 +--
 16 files changed, 27 insertions(+), 32 deletions(-)

diff -puN arch/arm/mm/mmu.c~mm-cleanup-pte_alloc-interfaces arch/arm/mm/mmu.c
--- a/arch/arm/mm/mmu.c~mm-cleanup-pte_alloc-interfaces
+++ a/arch/arm/mm/mmu.c
@@ -732,7 +732,7 @@ static void *__init late_alloc(unsigned
 	return ptr;
 }
 
-static pte_t * __init pte_alloc(pmd_t *pmd, unsigned long addr,
+static pte_t * __init arm_pte_alloc(pmd_t *pmd, unsigned long addr,
 				unsigned long prot,
 				void *(*alloc)(unsigned long sz))
 {
@@ -747,7 +747,7 @@ static pte_t * __init pte_alloc(pmd_t *p
 static pte_t * __init early_pte_alloc(pmd_t *pmd, unsigned long addr,
 				      unsigned long prot)
 {
-	return pte_alloc(pmd, addr, prot, early_alloc);
+	return arm_pte_alloc(pmd, addr, prot, early_alloc);
 }
 
 static void __init alloc_init_pte(pmd_t *pmd, unsigned long addr,
@@ -756,7 +756,7 @@ static void __init alloc_init_pte(pmd_t
 				  void *(*alloc)(unsigned long sz),
 				  bool ng)
 {
-	pte_t *pte = pte_alloc(pmd, addr, type->prot_l1, alloc);
+	pte_t *pte = arm_pte_alloc(pmd, addr, type->prot_l1, alloc);
 	do {
 		set_pte_ext(pte, pfn_pte(pfn, __pgprot(type->prot_pte)),
 			    ng ? PTE_EXT_NG : 0);
diff -puN arch/arm/mm/pgd.c~mm-cleanup-pte_alloc-interfaces arch/arm/mm/pgd.c
--- a/arch/arm/mm/pgd.c~mm-cleanup-pte_alloc-interfaces
+++ a/arch/arm/mm/pgd.c
@@ -80,7 +80,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 		if (!new_pmd)
 			goto no_pmd;
 
-		new_pte = pte_alloc_map(mm, NULL, new_pmd, 0);
+		new_pte = pte_alloc_map(mm, new_pmd, 0);
 		if (!new_pte)
 			goto no_pte;
 
diff -puN arch/arm64/mm/hugetlbpage.c~mm-cleanup-pte_alloc-interfaces arch/arm64/mm/hugetlbpage.c
--- a/arch/arm64/mm/hugetlbpage.c~mm-cleanup-pte_alloc-interfaces
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -124,7 +124,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 		 * will be no pte_unmap() to correspond with this
 		 * pte_alloc_map().
 		 */
-		pte = pte_alloc_map(mm, NULL, pmd, addr);
+		pte = pte_alloc_map(mm, pmd, addr);
 	} else if (sz == PMD_SIZE) {
 		if (IS_ENABLED(CONFIG_ARCH_WANT_HUGE_PMD_SHARE) &&
 		    pud_none(*pud))
diff -puN arch/ia64/mm/hugetlbpage.c~mm-cleanup-pte_alloc-interfaces arch/ia64/mm/hugetlbpage.c
--- a/arch/ia64/mm/hugetlbpage.c~mm-cleanup-pte_alloc-interfaces
+++ a/arch/ia64/mm/hugetlbpage.c
@@ -38,7 +38,7 @@ huge_pte_alloc(struct mm_struct *mm, uns
 	if (pud) {
 		pmd = pmd_alloc(mm, pud, taddr);
 		if (pmd)
-			pte = pte_alloc_map(mm, NULL, pmd, taddr);
+			pte = pte_alloc_map(mm, pmd, taddr);
 	}
 	return pte;
 }
diff -puN arch/metag/mm/hugetlbpage.c~mm-cleanup-pte_alloc-interfaces arch/metag/mm/hugetlbpage.c
--- a/arch/metag/mm/hugetlbpage.c~mm-cleanup-pte_alloc-interfaces
+++ a/arch/metag/mm/hugetlbpage.c
@@ -67,7 +67,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 	pgd = pgd_offset(mm, addr);
 	pud = pud_offset(pgd, addr);
 	pmd = pmd_offset(pud, addr);
-	pte = pte_alloc_map(mm, NULL, pmd, addr);
+	pte = pte_alloc_map(mm, pmd, addr);
 	pgd->pgd &= ~_PAGE_SZ_MASK;
 	pgd->pgd |= _PAGE_SZHUGE;
 
diff -puN arch/parisc/mm/hugetlbpage.c~mm-cleanup-pte_alloc-interfaces arch/parisc/mm/hugetlbpage.c
--- a/arch/parisc/mm/hugetlbpage.c~mm-cleanup-pte_alloc-interfaces
+++ a/arch/parisc/mm/hugetlbpage.c
@@ -63,7 +63,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 	if (pud) {
 		pmd = pmd_alloc(mm, pud, addr);
 		if (pmd)
-			pte = pte_alloc_map(mm, NULL, pmd, addr);
+			pte = pte_alloc_map(mm, pmd, addr);
 	}
 	return pte;
 }
diff -puN arch/sh/mm/hugetlbpage.c~mm-cleanup-pte_alloc-interfaces arch/sh/mm/hugetlbpage.c
--- a/arch/sh/mm/hugetlbpage.c~mm-cleanup-pte_alloc-interfaces
+++ a/arch/sh/mm/hugetlbpage.c
@@ -35,7 +35,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 		if (pud) {
 			pmd = pmd_alloc(mm, pud, addr);
 			if (pmd)
-				pte = pte_alloc_map(mm, NULL, pmd, addr);
+				pte = pte_alloc_map(mm, pmd, addr);
 		}
 	}
 
diff -puN arch/sparc/mm/hugetlbpage.c~mm-cleanup-pte_alloc-interfaces arch/sparc/mm/hugetlbpage.c
--- a/arch/sparc/mm/hugetlbpage.c~mm-cleanup-pte_alloc-interfaces
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -146,7 +146,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 	if (pud) {
 		pmd = pmd_alloc(mm, pud, addr);
 		if (pmd)
-			pte = pte_alloc_map(mm, NULL, pmd, addr);
+			pte = pte_alloc_map(mm, pmd, addr);
 	}
 	return pte;
 }
diff -puN arch/tile/mm/hugetlbpage.c~mm-cleanup-pte_alloc-interfaces arch/tile/mm/hugetlbpage.c
--- a/arch/tile/mm/hugetlbpage.c~mm-cleanup-pte_alloc-interfaces
+++ a/arch/tile/mm/hugetlbpage.c
@@ -77,7 +77,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 		else {
 			if (sz != PAGE_SIZE << huge_shift[HUGE_SHIFT_PAGE])
 				panic("Unexpected page size %#lx\n", sz);
-			return pte_alloc_map(mm, NULL, pmd, addr);
+			return pte_alloc_map(mm, pmd, addr);
 		}
 	}
 #else
diff -puN arch/um/kernel/skas/mmu.c~mm-cleanup-pte_alloc-interfaces arch/um/kernel/skas/mmu.c
--- a/arch/um/kernel/skas/mmu.c~mm-cleanup-pte_alloc-interfaces
+++ a/arch/um/kernel/skas/mmu.c
@@ -31,7 +31,7 @@ static int init_stub_pte(struct mm_struc
 	if (!pmd)
 		goto out_pmd;
 
-	pte = pte_alloc_map(mm, NULL, pmd, proc);
+	pte = pte_alloc_map(mm, pmd, proc);
 	if (!pte)
 		goto out_pte;
 
diff -puN arch/unicore32/mm/pgd.c~mm-cleanup-pte_alloc-interfaces arch/unicore32/mm/pgd.c
--- a/arch/unicore32/mm/pgd.c~mm-cleanup-pte_alloc-interfaces
+++ a/arch/unicore32/mm/pgd.c
@@ -54,7 +54,7 @@ pgd_t *get_pgd_slow(struct mm_struct *mm
 		if (!new_pmd)
 			goto no_pmd;
 
-		new_pte = pte_alloc_map(mm, NULL, new_pmd, 0);
+		new_pte = pte_alloc_map(mm, new_pmd, 0);
 		if (!new_pte)
 			goto no_pte;
 
diff -puN arch/x86/kernel/tboot.c~mm-cleanup-pte_alloc-interfaces arch/x86/kernel/tboot.c
--- a/arch/x86/kernel/tboot.c~mm-cleanup-pte_alloc-interfaces
+++ a/arch/x86/kernel/tboot.c
@@ -135,7 +135,7 @@ static int map_tboot_page(unsigned long
 	pmd = pmd_alloc(&tboot_mm, pud, vaddr);
 	if (!pmd)
 		return -1;
-	pte = pte_alloc_map(&tboot_mm, NULL, pmd, vaddr);
+	pte = pte_alloc_map(&tboot_mm, pmd, vaddr);
 	if (!pte)
 		return -1;
 	set_pte_at(&tboot_mm, vaddr, pte, pfn_pte(pfn, prot));
diff -puN include/linux/mm.h~mm-cleanup-pte_alloc-interfaces include/linux/mm.h
--- a/include/linux/mm.h~mm-cleanup-pte_alloc-interfaces
+++ a/include/linux/mm.h
@@ -1545,8 +1545,7 @@ static inline void mm_dec_nr_pmds(struct
 }
 #endif
 
-int __pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
-		pmd_t *pmd, unsigned long address);
+int __pte_alloc(struct mm_struct *mm, pmd_t *pmd, unsigned long address);
 int __pte_alloc_kernel(pmd_t *pmd, unsigned long address);
 
 /*
@@ -1672,15 +1671,15 @@ static inline void pgtable_page_dtor(str
 	pte_unmap(pte);					\
 } while (0)
 
-#define pte_alloc_map(mm, vma, pmd, address)				\
-	((unlikely(pmd_none(*(pmd))) && __pte_alloc(mm, vma,	\
-							pmd, address))?	\
-	 NULL: pte_offset_map(pmd, address))
+#define pte_alloc(mm, pmd, address)			\
+	(unlikely(pmd_none(*(pmd))) && __pte_alloc(mm, pmd, address))
+
+#define pte_alloc_map(mm, pmd, address)			\
+	(pte_alloc(mm, pmd, address) ? NULL : pte_offset_map(pmd, address))
 
 #define pte_alloc_map_lock(mm, pmd, address, ptlp)	\
-	((unlikely(pmd_none(*(pmd))) && __pte_alloc(mm, NULL,	\
-							pmd, address))?	\
-		NULL: pte_offset_map_lock(mm, pmd, address, ptlp))
+	(pte_alloc(mm, pmd, address) ?			\
+		 NULL : pte_offset_map_lock(mm, pmd, address, ptlp))
 
 #define pte_alloc_kernel(pmd, address)			\
 	((unlikely(pmd_none(*(pmd))) && __pte_alloc_kernel(pmd, address))? \
diff -puN mm/memory.c~mm-cleanup-pte_alloc-interfaces mm/memory.c
--- a/mm/memory.c~mm-cleanup-pte_alloc-interfaces
+++ a/mm/memory.c
@@ -562,8 +562,7 @@ void free_pgtables(struct mmu_gather *tl
 	}
 }
 
-int __pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
-		pmd_t *pmd, unsigned long address)
+int __pte_alloc(struct mm_struct *mm, pmd_t *pmd, unsigned long address)
 {
 	spinlock_t *ptl;
 	pgtable_t new = pte_alloc_one(mm, address);
@@ -3419,12 +3418,11 @@ static int __handle_mm_fault(struct mm_s
 	}
 
 	/*
-	 * Use __pte_alloc instead of pte_alloc_map, because we can't
+	 * Use pte_alloc() instead of pte_alloc_map, because we can't
 	 * run pte_offset_map on the pmd, if an huge pmd could
 	 * materialize from under us from a different thread.
 	 */
-	if (unlikely(pmd_none(*pmd)) &&
-	    unlikely(__pte_alloc(mm, vma, pmd, address)))
+	if (unlikely(pte_alloc(mm, pmd, address)))
 		return VM_FAULT_OOM;
 	/*
 	 * If a huge pmd materialized under us just retry later.  Use
diff -puN mm/mremap.c~mm-cleanup-pte_alloc-interfaces mm/mremap.c
--- a/mm/mremap.c~mm-cleanup-pte_alloc-interfaces
+++ a/mm/mremap.c
@@ -213,8 +213,7 @@ unsigned long move_page_tables(struct vm
 				continue;
 			VM_BUG_ON(pmd_trans_huge(*old_pmd));
 		}
-		if (pmd_none(*new_pmd) && __pte_alloc(new_vma->vm_mm, new_vma,
-						      new_pmd, new_addr))
+		if (pte_alloc(new_vma->vm_mm, new_pmd, new_addr))
 			break;
 		next = (new_addr + PMD_SIZE) & PMD_MASK;
 		if (extent > next - new_addr)
diff -puN mm/userfaultfd.c~mm-cleanup-pte_alloc-interfaces mm/userfaultfd.c
--- a/mm/userfaultfd.c~mm-cleanup-pte_alloc-interfaces
+++ a/mm/userfaultfd.c
@@ -230,8 +230,7 @@ retry:
 			break;
 		}
 		if (unlikely(pmd_none(dst_pmdval)) &&
-		    unlikely(__pte_alloc(dst_mm, dst_vma, dst_pmd,
-					 dst_addr))) {
+		    unlikely(__pte_alloc(dst_mm, dst_pmd, dst_addr))) {
 			err = -ENOMEM;
 			break;
 		}
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

