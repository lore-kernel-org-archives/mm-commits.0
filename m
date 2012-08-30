From: akpm@linux-foundation.org
Subject: + thp-s390-thp-splitting-backend-for-s390.patch added to -mm tree
Date: Thu, 30 Aug 2012 12:55:07 -0700
Message-ID: <20120830195507.E2C245C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:65236 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab2H3TzK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Aug 2012 15:55:10 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so118382wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 30 Aug 2012 12:55:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerald.schaefer@de.ibm.com, aarcange@redhat.com, ak@linux.intel.com, dhillf@gmail.com, heiko.carstens@de.ibm.com, hughd@google.com, schwidefsky@de.ibm.com


The patch titled
     Subject: thp, s390: thp splitting backend for s390
has been added to the -mm tree.  Its filename is
     thp-s390-thp-splitting-backend-for-s390.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: thp, s390: thp splitting backend for s390

This patch is part of the architecture backend for thp on s390.  It
provides the functions related to thp splitting, including serialization
against gup.  Unlike other archs, pmdp_splitting_flush() cannot use a tlb
flushing operation to serialize against gup on s390, because that wouldn't
be stopped by the disabled IRQs.  So instead, smp_call_function() is
called with an empty function, which will have the expected effect.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h |   13 +++++++++++++
 arch/s390/mm/gup.c              |   11 ++++++++++-
 arch/s390/mm/pgtable.c          |   18 ++++++++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff -puN arch/s390/include/asm/pgtable.h~thp-s390-thp-splitting-backend-for-s390 arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~thp-s390-thp-splitting-backend-for-s390
+++ a/arch/s390/include/asm/pgtable.h
@@ -347,6 +347,8 @@ extern struct page *vmemmap;
 
 #define _SEGMENT_ENTRY_LARGE	0x400	/* STE-format control, large page   */
 #define _SEGMENT_ENTRY_CO	0x100	/* change-recording override   */
+#define _SEGMENT_ENTRY_SPLIT_BIT 0	/* THP splitting bit number */
+#define _SEGMENT_ENTRY_SPLIT	(1UL << _SEGMENT_ENTRY_SPLIT_BIT)
 
 /* Page status table bits for virtualization */
 #define RCP_ACC_BITS	0xf000000000000000UL
@@ -506,6 +508,10 @@ static inline int pmd_bad(pmd_t pmd)
 	return (pmd_val(pmd) & mask) != _SEGMENT_ENTRY;
 }
 
+#define __HAVE_ARCH_PMDP_SPLITTING_FLUSH
+extern void pmdp_splitting_flush(struct vm_area_struct *vma,
+				 unsigned long addr, pmd_t *pmdp);
+
 static inline int pte_none(pte_t pte)
 {
 	return (pte_val(pte) & _PAGE_INVALID) && !(pte_val(pte) & _PAGE_SWT);
@@ -1159,6 +1165,13 @@ static inline pmd_t *pmd_offset(pud_t *p
 #define pte_offset_map(pmd, address) pte_offset_kernel(pmd, address)
 #define pte_unmap(pte) do { } while (0)
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline int pmd_trans_splitting(pmd_t pmd)
+{
+	return pmd_val(pmd) & _SEGMENT_ENTRY_SPLIT;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
 /*
  * 31 bit swap entry format:
  * A page-table entry has some bits we have to treat in a special way.
diff -puN arch/s390/mm/gup.c~thp-s390-thp-splitting-backend-for-s390 arch/s390/mm/gup.c
--- a/arch/s390/mm/gup.c~thp-s390-thp-splitting-backend-for-s390
+++ a/arch/s390/mm/gup.c
@@ -115,7 +115,16 @@ static inline int gup_pmd_range(pud_t *p
 		pmd = *pmdp;
 		barrier();
 		next = pmd_addr_end(addr, end);
-		if (pmd_none(pmd))
+		/*
+		 * The pmd_trans_splitting() check below explains why
+		 * pmdp_splitting_flush() has to serialize with
+		 * smp_call_function() against our disabled IRQs, to stop
+		 * this gup-fast code from running while we set the
+		 * splitting bit in the pmd. Returning zero will take
+		 * the slow path that will call wait_split_huge_page()
+		 * if the pmd is still in splitting state.
+		 */
+		if (pmd_none(pmd) || pmd_trans_splitting(pmd))
 			return 0;
 		if (unlikely(pmd_huge(pmd))) {
 			if (!gup_huge_pmd(pmdp, pmd, addr, next,
diff -puN arch/s390/mm/pgtable.c~thp-s390-thp-splitting-backend-for-s390 arch/s390/mm/pgtable.c
--- a/arch/s390/mm/pgtable.c~thp-s390-thp-splitting-backend-for-s390
+++ a/arch/s390/mm/pgtable.c
@@ -866,3 +866,21 @@ bool kernel_page_present(struct page *pa
 	return cc == 0;
 }
 #endif /* CONFIG_HIBERNATION && CONFIG_DEBUG_PAGEALLOC */
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static void pmdp_splitting_flush_sync(void *arg)
+{
+	/* Simply deliver the interrupt */
+}
+
+void pmdp_splitting_flush(struct vm_area_struct *vma, unsigned long address,
+			  pmd_t *pmdp)
+{
+	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+	if (!test_and_set_bit(_SEGMENT_ENTRY_SPLIT_BIT,
+			      (unsigned long *) pmdp)) {
+		/* need to serialize against gup-fast (IRQ disabled) */
+		smp_call_function(pmdp_splitting_flush_sync, NULL, 1);
+	}
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

linux-next.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

