From: akpm@linux-foundation.org
Subject: [to-be-updated] thp-s390-architecture-backend-for-thp-on-s390.patch removed from -mm tree
Date: Thu, 06 Sep 2012 13:52:01 -0700
Message-ID: <20120906205201.C9EE51E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:45075 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933119Ab2IFUwC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2012 16:52:02 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so202424qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 06 Sep 2012 13:52:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerald.schaefer@de.ibm.com, aarcange@redhat.com, ak@linux.intel.com, dhillf@gmail.com, heiko.carstens@de.ibm.com, hughd@google.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp, s390: architecture backend for thp on s390
has been removed from the -mm tree.  Its filename was
     thp-s390-architecture-backend-for-thp-on-s390.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: thp, s390: architecture backend for thp on s390

This implements the architecture backend for transparent hugepages on
s390.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/hugetlb.h |   18 --
 arch/s390/include/asm/pgtable.h |  189 ++++++++++++++++++++++++++++++
 arch/s390/include/asm/setup.h   |    5 
 arch/s390/include/asm/tlb.h     |    1 
 arch/s390/kernel/early.c        |    2 
 arch/s390/mm/pgtable.c          |   22 +++
 mm/Kconfig                      |    2 
 7 files changed, 220 insertions(+), 19 deletions(-)

diff -puN arch/s390/include/asm/hugetlb.h~thp-s390-architecture-backend-for-thp-on-s390 arch/s390/include/asm/hugetlb.h
--- a/arch/s390/include/asm/hugetlb.h~thp-s390-architecture-backend-for-thp-on-s390
+++ a/arch/s390/include/asm/hugetlb.h
@@ -88,23 +88,6 @@ static inline void __pmd_csp(pmd_t *pmdp
 		"	csp %1,%3"
 		: "=m" (*pmdp)
 		: "d" (reg2), "d" (reg3), "d" (reg4), "m" (*pmdp) : "cc");
-	pmd_val(*pmdp) = _SEGMENT_ENTRY_INV | _SEGMENT_ENTRY;
-}
-
-static inline void __pmd_idte(unsigned long address, pmd_t *pmdp)
-{
-	unsigned long sto = (unsigned long) pmdp -
-				pmd_index(address) * sizeof(pmd_t);
-
-	if (!(pmd_val(*pmdp) & _SEGMENT_ENTRY_INV)) {
-		asm volatile(
-			"	.insn	rrf,0xb98e0000,%2,%3,0,0"
-			: "=m" (*pmdp)
-			: "m" (*pmdp), "a" (sto),
-			  "a" ((address & HPAGE_MASK))
-		);
-	}
-	pmd_val(*pmdp) = _SEGMENT_ENTRY_INV | _SEGMENT_ENTRY;
 }
 
 static inline void huge_ptep_invalidate(struct mm_struct *mm,
@@ -116,6 +99,7 @@ static inline void huge_ptep_invalidate(
 		__pmd_idte(address, pmdp);
 	else
 		__pmd_csp(pmdp);
+	pmd_val(*pmdp) = _SEGMENT_ENTRY_INV | _SEGMENT_ENTRY;
 }
 
 #define huge_ptep_set_access_flags(__vma, __addr, __ptep, __entry, __dirty) \
diff -puN arch/s390/include/asm/pgtable.h~thp-s390-architecture-backend-for-thp-on-s390 arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~thp-s390-architecture-backend-for-thp-on-s390
+++ a/arch/s390/include/asm/pgtable.h
@@ -350,6 +350,10 @@ extern struct page *vmemmap;
 #define _SEGMENT_ENTRY_SPLIT_BIT 0	/* THP splitting bit number */
 #define _SEGMENT_ENTRY_SPLIT	(1UL << _SEGMENT_ENTRY_SPLIT_BIT)
 
+/* Set of bits not changed in pmd_modify */
+#define _SEGMENT_CHG_MASK	(_SEGMENT_ENTRY_ORIGIN | _SEGMENT_ENTRY_LARGE \
+				 | _SEGMENT_ENTRY_SPLIT | _SEGMENT_ENTRY_CO)
+
 /* Page status table bits for virtualization */
 #define RCP_ACC_BITS	0xf000000000000000UL
 #define RCP_FP_BIT	0x0800000000000000UL
@@ -512,6 +516,26 @@ static inline int pmd_bad(pmd_t pmd)
 extern void pmdp_splitting_flush(struct vm_area_struct *vma,
 				 unsigned long addr, pmd_t *pmdp);
 
+#define  __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
+extern int pmdp_set_access_flags(struct vm_area_struct *vma,
+				 unsigned long address, pmd_t *pmdp,
+				 pmd_t entry, int dirty);
+
+#define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
+extern int pmdp_clear_flush_young(struct vm_area_struct *vma,
+				  unsigned long address, pmd_t *pmdp);
+
+#define __HAVE_ARCH_PMD_WRITE
+static inline int pmd_write(pmd_t pmd)
+{
+	return (pmd_val(pmd) & _SEGMENT_ENTRY_RO) == 0;
+}
+
+static inline int pmd_young(pmd_t pmd)
+{
+	return 0;
+}
+
 static inline int pte_none(pte_t pte)
 {
 	return (pte_val(pte) & _PAGE_INVALID) && !(pte_val(pte) & _PAGE_SWT);
@@ -1165,6 +1189,22 @@ static inline pmd_t *pmd_offset(pud_t *p
 #define pte_offset_map(pmd, address) pte_offset_kernel(pmd, address)
 #define pte_unmap(pte) do { } while (0)
 
+static inline void __pmd_idte(unsigned long address, pmd_t *pmdp)
+{
+	unsigned long sto = (unsigned long) pmdp -
+			    pmd_index(address) * sizeof(pmd_t);
+
+	if (!(pmd_val(*pmdp) & _SEGMENT_ENTRY_INV)) {
+		asm volatile(
+			"	.insn	rrf,0xb98e0000,%2,%3,0,0"
+			: "=m" (*pmdp)
+			: "m" (*pmdp), "a" (sto),
+			  "a" ((address & HPAGE_MASK))
+			: "cc"
+		);
+	}
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_PGTABLE_DEPOSIT
 extern void pgtable_deposit(struct mm_struct *mm, pgtable_t pgtable);
@@ -1176,6 +1216,155 @@ static inline int pmd_trans_splitting(pm
 {
 	return pmd_val(pmd) & _SEGMENT_ENTRY_SPLIT;
 }
+
+static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
+			      pmd_t *pmdp, pmd_t entry)
+{
+	*pmdp = entry;
+}
+
+static inline unsigned long massage_pgprot_pmd(pgprot_t pgprot)
+{
+	unsigned long pgprot_pmd = 0;
+
+	if (pgprot_val(pgprot) & _PAGE_INVALID) {
+		if (pgprot_val(pgprot) & _PAGE_SWT)
+			pgprot_pmd |= _HPAGE_TYPE_NONE;
+		pgprot_pmd |= _SEGMENT_ENTRY_INV;
+	}
+	if (pgprot_val(pgprot) & _PAGE_RO)
+		pgprot_pmd |= _SEGMENT_ENTRY_RO;
+	return pgprot_pmd;
+}
+
+static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
+{
+	pmd_val(pmd) &= _SEGMENT_CHG_MASK;
+	pmd_val(pmd) |= massage_pgprot_pmd(newprot);
+	return pmd;
+}
+
+static inline pmd_t pmd_mkhuge(pmd_t pmd)
+{
+	pmd_val(pmd) |= _SEGMENT_ENTRY_LARGE;
+	return pmd;
+}
+
+static inline pmd_t pmd_mkwrite(pmd_t pmd)
+{
+	pmd_val(pmd) &= ~_SEGMENT_ENTRY_RO;
+	return pmd;
+}
+
+static inline pmd_t pmd_wrprotect(pmd_t pmd)
+{
+	pmd_val(pmd) |= _SEGMENT_ENTRY_RO;
+	return pmd;
+}
+
+static inline pmd_t pmd_mkdirty(pmd_t pmd)
+{
+	/* No dirty bit in the segment table entry. */
+	return pmd;
+}
+
+static inline pmd_t pmd_mkold(pmd_t pmd)
+{
+	/* No referenced bit in the segment table entry. */
+	return pmd;
+}
+
+static inline pmd_t pmd_mkyoung(pmd_t pmd)
+{
+	/* No referenced bit in the segment table entry. */
+	return pmd;
+}
+
+#define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
+static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
+					    unsigned long address, pmd_t *pmdp)
+{
+	unsigned long pmd_addr = pmd_val(*pmdp) & HPAGE_MASK;
+	long tmp, rc;
+	int counter;
+
+	rc = 0;
+	if (MACHINE_HAS_RRBM) {
+		counter = PTRS_PER_PTE >> 6;
+		asm volatile(
+			"0:	.insn	rre,0xb9ae0000,%0,%3\n"	/* rrbm */
+			"	ogr	%1,%0\n"
+			"	la	%3,0(%4,%3)\n"
+			"	brct	%2,0b\n"
+			: "=d" (tmp), "+d" (rc), "+d" (counter), "+a" (pmd_addr)
+			: "a" (64 * 4096UL) : "cc");
+		rc = !!rc;
+	} else {
+		counter = PTRS_PER_PTE;
+		asm volatile(
+			"0:	rrbe	0,%2\n"
+			"	la	%2,0(%3,%2)\n"
+			"	brc	12,1f\n"
+			"	lhi	%0,1\n"
+			"1:	brct	%1,0b\n"
+			: "+d" (rc), "+d" (counter), "+a" (pmd_addr)
+			: "a" (4096UL) : "cc");
+	}
+	return rc;
+}
+
+#define __HAVE_ARCH_PMDP_GET_AND_CLEAR
+static inline pmd_t pmdp_get_and_clear(struct mm_struct *mm,
+				       unsigned long address, pmd_t *pmdp)
+{
+	pmd_t pmd = *pmdp;
+
+	__pmd_idte(address, pmdp);
+	pmd_clear(pmdp);
+	return pmd;
+}
+
+#define __HAVE_ARCH_PMDP_CLEAR_FLUSH
+static inline pmd_t pmdp_clear_flush(struct vm_area_struct *vma,
+				     unsigned long address, pmd_t *pmdp)
+{
+	return pmdp_get_and_clear(vma->vm_mm, address, pmdp);
+}
+
+#define __HAVE_ARCH_PMDP_INVALIDATE
+static inline void pmdp_invalidate(struct vm_area_struct *vma,
+				   unsigned long address, pmd_t *pmdp)
+{
+	__pmd_idte(address, pmdp);
+}
+
+static inline pmd_t mk_pmd_phys(unsigned long physpage, pgprot_t pgprot)
+{
+	pmd_t __pmd;
+	pmd_val(__pmd) = physpage + massage_pgprot_pmd(pgprot);
+	return __pmd;
+}
+
+#define pfn_pmd(pfn, pgprot)	mk_pmd_phys(__pa((pfn) << PAGE_SHIFT),(pgprot))
+#define mk_pmd(page, pgprot)	pfn_pmd(page_to_pfn(page), (pgprot))
+
+static inline int pmd_trans_huge(pmd_t pmd)
+{
+	return pmd_val(pmd) & _SEGMENT_ENTRY_LARGE;
+}
+
+static inline int has_transparent_hugepage(void)
+{
+	return MACHINE_HAS_HPAGE ? 1 : 0;
+}
+
+static inline unsigned long pmd_pfn(pmd_t pmd)
+{
+	if (pmd_trans_huge(pmd))
+		return pmd_val(pmd) >> HPAGE_SHIFT;
+	else
+		return pmd_val(pmd) >> PAGE_SHIFT;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 /*
diff -puN arch/s390/include/asm/setup.h~thp-s390-architecture-backend-for-thp-on-s390 arch/s390/include/asm/setup.h
--- a/arch/s390/include/asm/setup.h~thp-s390-architecture-backend-for-thp-on-s390
+++ a/arch/s390/include/asm/setup.h
@@ -81,6 +81,7 @@ extern unsigned int addressing_mode;
 #define MACHINE_FLAG_SPP	(1UL << 13)
 #define MACHINE_FLAG_TOPOLOGY	(1UL << 14)
 #define MACHINE_FLAG_TE		(1UL << 15)
+#define MACHINE_FLAG_RRBM	(1UL << 16)
 
 #define MACHINE_IS_VM		(S390_lowcore.machine_flags & MACHINE_FLAG_VM)
 #define MACHINE_IS_KVM		(S390_lowcore.machine_flags & MACHINE_FLAG_KVM)
@@ -99,7 +100,8 @@ extern unsigned int addressing_mode;
 #define MACHINE_HAS_PFMF	(0)
 #define MACHINE_HAS_SPP		(0)
 #define MACHINE_HAS_TOPOLOGY	(0)
-#define MACHINE_HAS_TE		      (0)
+#define MACHINE_HAS_TE		(0)
+#define MACHINE_HAS_RRBM	(0)
 #else /* CONFIG_64BIT */
 #define MACHINE_HAS_IEEE	(1)
 #define MACHINE_HAS_CSP		(1)
@@ -112,6 +114,7 @@ extern unsigned int addressing_mode;
 #define MACHINE_HAS_SPP		(S390_lowcore.machine_flags & MACHINE_FLAG_SPP)
 #define MACHINE_HAS_TOPOLOGY	(S390_lowcore.machine_flags & MACHINE_FLAG_TOPOLOGY)
 #define MACHINE_HAS_TE		(S390_lowcore.machine_flags & MACHINE_FLAG_TE)
+#define MACHINE_HAS_RRBM	(S390_lowcore.machine_flags & MACHINE_FLAG_RRBM)
 #endif /* CONFIG_64BIT */
 
 #define ZFCPDUMP_HSA_SIZE	(32UL<<20)
diff -puN arch/s390/include/asm/tlb.h~thp-s390-architecture-backend-for-thp-on-s390 arch/s390/include/asm/tlb.h
--- a/arch/s390/include/asm/tlb.h~thp-s390-architecture-backend-for-thp-on-s390
+++ a/arch/s390/include/asm/tlb.h
@@ -137,6 +137,7 @@ static inline void pud_free_tlb(struct m
 #define tlb_start_vma(tlb, vma)			do { } while (0)
 #define tlb_end_vma(tlb, vma)			do { } while (0)
 #define tlb_remove_tlb_entry(tlb, ptep, addr)	do { } while (0)
+#define tlb_remove_pmd_tlb_entry(tlb, pmdp, addr)	do { } while (0)
 #define tlb_migrate_finish(mm)			do { } while (0)
 
 #endif /* _S390_TLB_H */
diff -puN arch/s390/kernel/early.c~thp-s390-architecture-backend-for-thp-on-s390 arch/s390/kernel/early.c
--- a/arch/s390/kernel/early.c~thp-s390-architecture-backend-for-thp-on-s390
+++ a/arch/s390/kernel/early.c
@@ -372,6 +372,8 @@ static __init void detect_machine_facili
 		S390_lowcore.machine_flags |= MACHINE_FLAG_SPP;
 	if (test_facility(50) && test_facility(73))
 		S390_lowcore.machine_flags |= MACHINE_FLAG_TE;
+	if (test_facility(66))
+		S390_lowcore.machine_flags |= MACHINE_FLAG_RRBM;
 #endif
 }
 
diff -puN arch/s390/mm/pgtable.c~thp-s390-architecture-backend-for-thp-on-s390 arch/s390/mm/pgtable.c
--- a/arch/s390/mm/pgtable.c~thp-s390-architecture-backend-for-thp-on-s390
+++ a/arch/s390/mm/pgtable.c
@@ -898,6 +898,28 @@ bool kernel_page_present(struct page *pa
 #endif /* CONFIG_HIBERNATION && CONFIG_DEBUG_PAGEALLOC */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+int pmdp_clear_flush_young(struct vm_area_struct *vma, unsigned long address,
+			   pmd_t *pmdp)
+{
+	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+	/* No need to flush TLB
+	 * On s390 reference bits are in storage key and never in TLB */
+	return pmdp_test_and_clear_young(vma, address, pmdp);
+}
+
+int pmdp_set_access_flags(struct vm_area_struct *vma,
+			  unsigned long address, pmd_t *pmdp,
+			  pmd_t entry, int dirty)
+{
+	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+
+	if (pmd_same(*pmdp, entry))
+		return 0;
+	pmdp_invalidate(vma, address, pmdp);
+	set_pmd_at(vma->vm_mm, address, pmdp, entry);
+	return 1;
+}
+
 static void pmdp_splitting_flush_sync(void *arg)
 {
 	/* Simply deliver the interrupt */
diff -puN mm/Kconfig~thp-s390-architecture-backend-for-thp-on-s390 mm/Kconfig
--- a/mm/Kconfig~thp-s390-architecture-backend-for-thp-on-s390
+++ a/mm/Kconfig
@@ -318,7 +318,7 @@ config NOMMU_INITIAL_TRIM_EXCESS
 
 config TRANSPARENT_HUGEPAGE
 	bool "Transparent Hugepage Support"
-	depends on X86 && MMU
+	depends on (X86 || (S390 && 64BIT)) && MMU
 	select COMPACTION
 	help
 	  Transparent Hugepages allows the kernel to use huge pages and
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch

