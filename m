From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-add-more-arch-defined-huge_pte-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:47:12 -0700
Message-ID: <20130430184712.BCB3631C2B9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:50631 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778Ab3D3SrP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:47:15 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so75639veb.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:47:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerald.schaefer@de.ibm.com, benh@kernel.crashing.org, cmetcalf@tilera.com, davem@davemloft.net, dhillf@gmail.com, fenghua.yu@intel.com, heiko.carstens@de.ibm.com, hpa@zytor.com, hughd@google.com, lethal@linux-sh.org, mgorman@suse.de, mhocko@suse.cz, mingo@redhat.com, paulus@samba.org, ralf@linux-mips.org, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: add more arch-defined huge_pte functions
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-more-arch-defined-huge_pte-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: mm/hugetlb: add more arch-defined huge_pte functions

Commit abf09bed3c "s390/mm: implement software dirty bits" introduced
another difference in the pte layout vs. the pmd layout on s390,
thoroughly breaking the s390 support for hugetlbfs. This requires
replacing some more pte_xxx functions in mm/hugetlbfs.c with a
huge_pte_xxx version.

This patch introduces those huge_pte_xxx functions and their
generic implementation in asm-generic/hugetlb.h, which will now be
included on all architectures supporting hugetlbfs apart from s390.
This change will be a no-op for those architectures.

[akpm@linux-foundation.org: fix warning]
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>	[for !s390 parts]
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/hugetlb.h    |    1 
 arch/mips/include/asm/hugetlb.h    |    1 
 arch/powerpc/include/asm/hugetlb.h |    1 
 arch/s390/include/asm/hugetlb.h    |   56 +++++++++++++++
 arch/s390/include/asm/pgtable.h    |   95 +++++++++++----------------
 arch/s390/mm/hugetlbpage.c         |    2 
 arch/sh/include/asm/hugetlb.h      |    1 
 arch/sparc/include/asm/hugetlb.h   |    1 
 arch/tile/include/asm/hugetlb.h    |    1 
 arch/x86/include/asm/hugetlb.h     |    1 
 include/asm-generic/hugetlb.h      |   40 +++++++++++
 mm/hugetlb.c                       |   24 +++---
 12 files changed, 156 insertions(+), 68 deletions(-)

diff -puN arch/ia64/include/asm/hugetlb.h~mm-hugetlb-add-more-arch-defined-huge_pte-functions arch/ia64/include/asm/hugetlb.h
--- a/arch/ia64/include/asm/hugetlb.h~mm-hugetlb-add-more-arch-defined-huge_pte-functions
+++ a/arch/ia64/include/asm/hugetlb.h
@@ -2,6 +2,7 @@
 #define _ASM_IA64_HUGETLB_H
 
 #include <asm/page.h>
+#include <asm-generic/hugetlb.h>
 
 
 void hugetlb_free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
diff -puN arch/mips/include/asm/hugetlb.h~mm-hugetlb-add-more-arch-defined-huge_pte-functions arch/mips/include/asm/hugetlb.h
--- a/arch/mips/include/asm/hugetlb.h~mm-hugetlb-add-more-arch-defined-huge_pte-functions
+++ a/arch/mips/include/asm/hugetlb.h
@@ -10,6 +10,7 @@
 #define __ASM_HUGETLB_H
 
 #include <asm/page.h>
+#include <asm-generic/hugetlb.h>
 
 
 static inline int is_hugepage_only_range(struct mm_struct *mm,
diff -puN arch/powerpc/include/asm/hugetlb.h~mm-hugetlb-add-more-arch-defined-huge_pte-functions arch/powerpc/include/asm/hugetlb.h
--- a/arch/powerpc/include/asm/hugetlb.h~mm-hugetlb-add-more-arch-defined-huge_pte-functions
+++ a/arch/powerpc/include/asm/hugetlb.h
@@ -3,6 +3,7 @@
 
 #ifdef CONFIG_HUGETLB_PAGE
 #include <asm/page.h>
+#include <asm-generic/hugetlb.h>
 
 extern struct kmem_cache *hugepte_cache;
 
diff -puN arch/s390/include/asm/hugetlb.h~mm-hugetlb-add-more-arch-defined-huge_pte-functions arch/s390/include/asm/hugetlb.h
--- a/arch/s390/include/asm/hugetlb.h~mm-hugetlb-add-more-arch-defined-huge_pte-functions
+++ a/arch/s390/include/asm/hugetlb.h
@@ -114,7 +114,7 @@ static inline pte_t huge_ptep_get_and_cl
 #define huge_ptep_set_wrprotect(__mm, __addr, __ptep)			\
 ({									\
 	pte_t __pte = huge_ptep_get(__ptep);				\
-	if (pte_write(__pte)) {						\
+	if (huge_pte_write(__pte)) {					\
 		huge_ptep_invalidate(__mm, __addr, __ptep);		\
 		set_huge_pte_at(__mm, __addr, __ptep,			\
 				huge_pte_wrprotect(__pte));		\
@@ -127,4 +127,58 @@ static inline void huge_ptep_clear_flush
 	huge_ptep_invalidate(vma->vm_mm, address, ptep);
 }
 
+static inline pte_t mk_huge_pte(struct page *page, pgprot_t pgprot)
+{
+	pte_t pte;
+	pmd_t pmd;
+
+	pmd = mk_pmd_phys(page_to_phys(page), pgprot);
+	pte_val(pte) = pmd_val(pmd);
+	return pte;
+}
+
+static inline int huge_pte_write(pte_t pte)
+{
+	pmd_t pmd;
+
+	pmd_val(pmd) = pte_val(pte);
+	return pmd_write(pmd);
+}
+
+static inline int huge_pte_dirty(pte_t pte)
+{
+	/* No dirty bit in the segment table entry. */
+	return 0;
+}
+
+static inline pte_t huge_pte_mkwrite(pte_t pte)
+{
+	pmd_t pmd;
+
+	pmd_val(pmd) = pte_val(pte);
+	pte_val(pte) = pmd_val(pmd_mkwrite(pmd));
+	return pte;
+}
+
+static inline pte_t huge_pte_mkdirty(pte_t pte)
+{
+	/* No dirty bit in the segment table entry. */
+	return pte;
+}
+
+static inline pte_t huge_pte_modify(pte_t pte, pgprot_t newprot)
+{
+	pmd_t pmd;
+
+	pmd_val(pmd) = pte_val(pte);
+	pte_val(pte) = pmd_val(pmd_modify(pmd, newprot));
+	return pte;
+}
+
+static inline void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
+				  pte_t *ptep)
+{
+	pmd_clear((pmd_t *) ptep);
+}
+
 #endif /* _ASM_S390_HUGETLB_H */
diff -puN arch/s390/include/asm/pgtable.h~mm-hugetlb-add-more-arch-defined-huge_pte-functions arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~mm-hugetlb-add-more-arch-defined-huge_pte-functions
+++ a/arch/s390/include/asm/pgtable.h
@@ -424,6 +424,13 @@ extern unsigned long MODULES_END;
 #define __S110	PAGE_RW
 #define __S111	PAGE_RW
 
+/*
+ * Segment entry (large page) protection definitions.
+ */
+#define SEGMENT_NONE	__pgprot(_HPAGE_TYPE_NONE)
+#define SEGMENT_RO	__pgprot(_HPAGE_TYPE_RO)
+#define SEGMENT_RW	__pgprot(_HPAGE_TYPE_RW)
+
 static inline int mm_exclusive(struct mm_struct *mm)
 {
 	return likely(mm == current->active_mm &&
@@ -914,26 +921,6 @@ static inline pte_t pte_mkspecial(pte_t
 #ifdef CONFIG_HUGETLB_PAGE
 static inline pte_t pte_mkhuge(pte_t pte)
 {
-	/*
-	 * PROT_NONE needs to be remapped from the pte type to the ste type.
-	 * The HW invalid bit is also different for pte and ste. The pte
-	 * invalid bit happens to be the same as the ste _SEGMENT_ENTRY_LARGE
-	 * bit, so we don't have to clear it.
-	 */
-	if (pte_val(pte) & _PAGE_INVALID) {
-		if (pte_val(pte) & _PAGE_SWT)
-			pte_val(pte) |= _HPAGE_TYPE_NONE;
-		pte_val(pte) |= _SEGMENT_ENTRY_INV;
-	}
-	/*
-	 * Clear SW pte bits, there are no SW bits in a segment table entry.
-	 */
-	pte_val(pte) &= ~(_PAGE_SWT | _PAGE_SWX | _PAGE_SWC |
-			  _PAGE_SWR | _PAGE_SWW);
-	/*
-	 * Also set the change-override bit because we don't need dirty bit
-	 * tracking for hugetlbfs pages.
-	 */
 	pte_val(pte) |= (_SEGMENT_ENTRY_LARGE | _SEGMENT_ENTRY_CO);
 	return pte;
 }
@@ -1278,31 +1265,7 @@ static inline void __pmd_idte(unsigned l
 	}
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-
-#define SEGMENT_NONE	__pgprot(_HPAGE_TYPE_NONE)
-#define SEGMENT_RO	__pgprot(_HPAGE_TYPE_RO)
-#define SEGMENT_RW	__pgprot(_HPAGE_TYPE_RW)
-
-#define __HAVE_ARCH_PGTABLE_DEPOSIT
-extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pgtable_t pgtable);
-
-#define __HAVE_ARCH_PGTABLE_WITHDRAW
-extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm);
-
-static inline int pmd_trans_splitting(pmd_t pmd)
-{
-	return pmd_val(pmd) & _SEGMENT_ENTRY_SPLIT;
-}
-
-static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
-			      pmd_t *pmdp, pmd_t entry)
-{
-	if (!(pmd_val(entry) & _SEGMENT_ENTRY_INV) && MACHINE_HAS_EDAT1)
-		pmd_val(entry) |= _SEGMENT_ENTRY_CO;
-	*pmdp = entry;
-}
-
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLB_PAGE)
 static inline unsigned long massage_pgprot_pmd(pgprot_t pgprot)
 {
 	/*
@@ -1323,10 +1286,11 @@ static inline pmd_t pmd_modify(pmd_t pmd
 	return pmd;
 }
 
-static inline pmd_t pmd_mkhuge(pmd_t pmd)
+static inline pmd_t mk_pmd_phys(unsigned long physpage, pgprot_t pgprot)
 {
-	pmd_val(pmd) |= _SEGMENT_ENTRY_LARGE;
-	return pmd;
+	pmd_t __pmd;
+	pmd_val(__pmd) = physpage + massage_pgprot_pmd(pgprot);
+	return __pmd;
 }
 
 static inline pmd_t pmd_mkwrite(pmd_t pmd)
@@ -1336,6 +1300,34 @@ static inline pmd_t pmd_mkwrite(pmd_t pm
 		pmd_val(pmd) &= ~_SEGMENT_ENTRY_RO;
 	return pmd;
 }
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLB_PAGE */
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+
+#define __HAVE_ARCH_PGTABLE_DEPOSIT
+extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pgtable_t pgtable);
+
+#define __HAVE_ARCH_PGTABLE_WITHDRAW
+extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm);
+
+static inline int pmd_trans_splitting(pmd_t pmd)
+{
+	return pmd_val(pmd) & _SEGMENT_ENTRY_SPLIT;
+}
+
+static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
+			      pmd_t *pmdp, pmd_t entry)
+{
+	if (!(pmd_val(entry) & _SEGMENT_ENTRY_INV) && MACHINE_HAS_EDAT1)
+		pmd_val(entry) |= _SEGMENT_ENTRY_CO;
+	*pmdp = entry;
+}
+
+static inline pmd_t pmd_mkhuge(pmd_t pmd)
+{
+	pmd_val(pmd) |= _SEGMENT_ENTRY_LARGE;
+	return pmd;
+}
 
 static inline pmd_t pmd_wrprotect(pmd_t pmd)
 {
@@ -1432,13 +1424,6 @@ static inline void pmdp_set_wrprotect(st
 	}
 }
 
-static inline pmd_t mk_pmd_phys(unsigned long physpage, pgprot_t pgprot)
-{
-	pmd_t __pmd;
-	pmd_val(__pmd) = physpage + massage_pgprot_pmd(pgprot);
-	return __pmd;
-}
-
 #define pfn_pmd(pfn, pgprot)	mk_pmd_phys(__pa((pfn) << PAGE_SHIFT), (pgprot))
 #define mk_pmd(page, pgprot)	pfn_pmd(page_to_pfn(page), (pgprot))
 
diff -puN arch/s390/mm/hugetlbpage.c~mm-hugetlb-add-more-arch-defined-huge_pte-functions arch/s390/mm/hugetlbpage.c
--- a/arch/s390/mm/hugetlbpage.c~mm-hugetlb-add-more-arch-defined-huge_pte-functions
+++ a/arch/s390/mm/hugetlbpage.c
@@ -39,7 +39,7 @@ int arch_prepare_hugepage(struct page *p
 	if (!ptep)
 		return -ENOMEM;
 
-	pte = mk_pte(page, PAGE_RW);
+	pte_val(pte) = addr;
 	for (i = 0; i < PTRS_PER_PTE; i++) {
 		set_pte_at(&init_mm, addr + i * PAGE_SIZE, ptep + i, pte);
 		pte_val(pte) += PAGE_SIZE;
diff -puN arch/sh/include/asm/hugetlb.h~mm-hugetlb-add-more-arch-defined-huge_pte-functions arch/sh/include/asm/hugetlb.h
--- a/arch/sh/include/asm/hugetlb.h~mm-hugetlb-add-more-arch-defined-huge_pte-functions
+++ a/arch/sh/include/asm/hugetlb.h
@@ -3,6 +3,7 @@
 
 #include <asm/cacheflush.h>
 #include <asm/page.h>
+#include <asm-generic/hugetlb.h>
 
 
 static inline int is_hugepage_only_range(struct mm_struct *mm,
diff -puN arch/sparc/include/asm/hugetlb.h~mm-hugetlb-add-more-arch-defined-huge_pte-functions arch/sparc/include/asm/hugetlb.h
--- a/arch/sparc/include/asm/hugetlb.h~mm-hugetlb-add-more-arch-defined-huge_pte-functions
+++ a/arch/sparc/include/asm/hugetlb.h
@@ -2,6 +2,7 @@
 #define _ASM_SPARC64_HUGETLB_H
 
 #include <asm/page.h>
+#include <asm-generic/hugetlb.h>
 
 
 void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
diff -puN arch/tile/include/asm/hugetlb.h~mm-hugetlb-add-more-arch-defined-huge_pte-functions arch/tile/include/asm/hugetlb.h
--- a/arch/tile/include/asm/hugetlb.h~mm-hugetlb-add-more-arch-defined-huge_pte-functions
+++ a/arch/tile/include/asm/hugetlb.h
@@ -16,6 +16,7 @@
 #define _ASM_TILE_HUGETLB_H
 
 #include <asm/page.h>
+#include <asm-generic/hugetlb.h>
 
 
 static inline int is_hugepage_only_range(struct mm_struct *mm,
diff -puN arch/x86/include/asm/hugetlb.h~mm-hugetlb-add-more-arch-defined-huge_pte-functions arch/x86/include/asm/hugetlb.h
--- a/arch/x86/include/asm/hugetlb.h~mm-hugetlb-add-more-arch-defined-huge_pte-functions
+++ a/arch/x86/include/asm/hugetlb.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_HUGETLB_H
 
 #include <asm/page.h>
+#include <asm-generic/hugetlb.h>
 
 
 static inline int is_hugepage_only_range(struct mm_struct *mm,
diff -puN /dev/null include/asm-generic/hugetlb.h
--- /dev/null
+++ a/include/asm-generic/hugetlb.h
@@ -0,0 +1,40 @@
+#ifndef _ASM_GENERIC_HUGETLB_H
+#define _ASM_GENERIC_HUGETLB_H
+
+static inline pte_t mk_huge_pte(struct page *page, pgprot_t pgprot)
+{
+	return mk_pte(page, pgprot);
+}
+
+static inline int huge_pte_write(pte_t pte)
+{
+	return pte_write(pte);
+}
+
+static inline int huge_pte_dirty(pte_t pte)
+{
+	return pte_dirty(pte);
+}
+
+static inline pte_t huge_pte_mkwrite(pte_t pte)
+{
+	return pte_mkwrite(pte);
+}
+
+static inline pte_t huge_pte_mkdirty(pte_t pte)
+{
+	return pte_mkdirty(pte);
+}
+
+static inline pte_t huge_pte_modify(pte_t pte, pgprot_t newprot)
+{
+	return pte_modify(pte, newprot);
+}
+
+static inline void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
+				  pte_t *ptep)
+{
+	pte_clear(mm, addr, ptep);
+}
+
+#endif /* _ASM_GENERIC_HUGETLB_H */
diff -puN mm/hugetlb.c~mm-hugetlb-add-more-arch-defined-huge_pte-functions mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-add-more-arch-defined-huge_pte-functions
+++ a/mm/hugetlb.c
@@ -2247,10 +2247,11 @@ static pte_t make_huge_pte(struct vm_are
 	pte_t entry;
 
 	if (writable) {
-		entry =
-		    pte_mkwrite(pte_mkdirty(mk_pte(page, vma->vm_page_prot)));
+		entry = huge_pte_mkwrite(huge_pte_mkdirty(mk_huge_pte(page,
+					 vma->vm_page_prot)));
 	} else {
-		entry = huge_pte_wrprotect(mk_pte(page, vma->vm_page_prot));
+		entry = huge_pte_wrprotect(mk_huge_pte(page,
+					   vma->vm_page_prot));
 	}
 	entry = pte_mkyoung(entry);
 	entry = pte_mkhuge(entry);
@@ -2264,7 +2265,7 @@ static void set_huge_ptep_writable(struc
 {
 	pte_t entry;
 
-	entry = pte_mkwrite(pte_mkdirty(huge_ptep_get(ptep)));
+	entry = huge_pte_mkwrite(huge_pte_mkdirty(huge_ptep_get(ptep)));
 	if (huge_ptep_set_access_flags(vma, address, ptep, entry, 1))
 		update_mmu_cache(vma, address, ptep);
 }
@@ -2379,7 +2380,7 @@ again:
 		 * HWPoisoned hugepage is already unmapped and dropped reference
 		 */
 		if (unlikely(is_hugetlb_entry_hwpoisoned(pte))) {
-			pte_clear(mm, address, ptep);
+			huge_pte_clear(mm, address, ptep);
 			continue;
 		}
 
@@ -2403,7 +2404,7 @@ again:
 
 		pte = huge_ptep_get_and_clear(mm, address, ptep);
 		tlb_remove_tlb_entry(tlb, ptep, address);
-		if (pte_dirty(pte))
+		if (huge_pte_dirty(pte))
 			set_page_dirty(page);
 
 		page_remove_rmap(page);
@@ -2856,7 +2857,7 @@ int hugetlb_fault(struct mm_struct *mm,
 	 * page now as it is used to determine if a reservation has been
 	 * consumed.
 	 */
-	if ((flags & FAULT_FLAG_WRITE) && !pte_write(entry)) {
+	if ((flags & FAULT_FLAG_WRITE) && !huge_pte_write(entry)) {
 		if (vma_needs_reservation(h, vma, address) < 0) {
 			ret = VM_FAULT_OOM;
 			goto out_mutex;
@@ -2886,12 +2887,12 @@ int hugetlb_fault(struct mm_struct *mm,
 
 
 	if (flags & FAULT_FLAG_WRITE) {
-		if (!pte_write(entry)) {
+		if (!huge_pte_write(entry)) {
 			ret = hugetlb_cow(mm, vma, address, ptep, entry,
 							pagecache_page);
 			goto out_page_table_lock;
 		}
-		entry = pte_mkdirty(entry);
+		entry = huge_pte_mkdirty(entry);
 	}
 	entry = pte_mkyoung(entry);
 	if (huge_ptep_set_access_flags(vma, address, ptep, entry,
@@ -2972,7 +2973,8 @@ long follow_hugetlb_page(struct mm_struc
 		 * directly from any kind of swap entries.
 		 */
 		if (absent || is_swap_pte(huge_ptep_get(pte)) ||
-		    ((flags & FOLL_WRITE) && !pte_write(huge_ptep_get(pte)))) {
+		    ((flags & FOLL_WRITE) &&
+		      !huge_pte_write(huge_ptep_get(pte)))) {
 			int ret;
 
 			spin_unlock(&mm->page_table_lock);
@@ -3042,7 +3044,7 @@ unsigned long hugetlb_change_protection(
 		}
 		if (!huge_pte_none(huge_ptep_get(ptep))) {
 			pte = huge_ptep_get_and_clear(mm, address, ptep);
-			pte = pte_mkhuge(pte_modify(pte, newprot));
+			pte = pte_mkhuge(huge_pte_modify(pte, newprot));
 			pte = arch_make_huge_pte(pte, vma, NULL, 0);
 			set_huge_pte_at(mm, address, ptep, pte);
 			pages++;
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

origin.patch

