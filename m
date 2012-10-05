From: akpm@linux-foundation.org
Subject: + sparc64-document-pgd-and-pmd-layout.patch added to -mm tree
Date: Fri, 05 Oct 2012 15:00:58 -0700
Message-ID: <20121005220058.71DF7100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:39861 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964797Ab2JEWA7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 18:00:59 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so249615qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 15:00:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, aarcange@redhat.com, gerald.schaefer@de.ibm.com, hannes@cmpxchg.org


The patch titled
     Subject: sparc64: Document PGD and PMD layout.
has been added to the -mm tree.  Its filename is
     sparc64-document-pgd-and-pmd-layout.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Miller <davem@davemloft.net>
Subject: sparc64: Document PGD and PMD layout.

We're going to be messing around with the PMD interpretation and layout
for the sake of transparent huge pages, so we better clearly document what
we're starting with.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_64.h |   16 ++++++++++++----
 arch/sparc/include/asm/tsb.h        |    8 ++++----
 2 files changed, 16 insertions(+), 8 deletions(-)

diff -puN arch/sparc/include/asm/pgtable_64.h~sparc64-document-pgd-and-pmd-layout arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~sparc64-document-pgd-and-pmd-layout
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -63,6 +63,14 @@
 #error Page table parameters do not cover virtual address space properly.
 #endif
 
+/* PMDs point to PTE tables which are 4K aligned.  */
+#define PMD_PADDR	_AC(0xfffffffe,UL)
+#define PMD_PADDR_SHIFT	_AC(11,UL)
+
+/* PGDs point to PMD tables which are 8K aligned.  */
+#define PGD_PADDR	_AC(0xfffffffc,UL)
+#define PGD_PADDR_SHIFT	_AC(11,UL)
+
 #ifndef __ASSEMBLY__
 
 #include <linux/sched.h>
@@ -581,14 +589,14 @@ static inline unsigned long pte_special(
 }
 
 #define pmd_set(pmdp, ptep)	\
-	(pmd_val(*(pmdp)) = (__pa((unsigned long) (ptep)) >> 11UL))
+	(pmd_val(*(pmdp)) = (__pa((unsigned long) (ptep)) >> PMD_PADDR_SHIFT))
 #define pud_set(pudp, pmdp)	\
-	(pud_val(*(pudp)) = (__pa((unsigned long) (pmdp)) >> 11UL))
+	(pud_val(*(pudp)) = (__pa((unsigned long) (pmdp)) >> PGD_PADDR_SHIFT))
 #define __pmd_page(pmd)		\
-	((unsigned long) __va((((unsigned long)pmd_val(pmd))<<11UL)))
+	((unsigned long) __va((((unsigned long)pmd_val(pmd))<<PMD_PADDR_SHIFT)))
 #define pmd_page(pmd) 			virt_to_page((void *)__pmd_page(pmd))
 #define pud_page_vaddr(pud)		\
-	((unsigned long) __va((((unsigned long)pud_val(pud))<<11UL)))
+	((unsigned long) __va((((unsigned long)pud_val(pud))<<PGD_PADDR_SHIFT)))
 #define pud_page(pud) 			virt_to_page((void *)pud_page_vaddr(pud))
 #define pmd_none(pmd)			(!pmd_val(pmd))
 #define pmd_bad(pmd)			(0)
diff -puN arch/sparc/include/asm/tsb.h~sparc64-document-pgd-and-pmd-layout arch/sparc/include/asm/tsb.h
--- a/arch/sparc/include/asm/tsb.h~sparc64-document-pgd-and-pmd-layout
+++ a/arch/sparc/include/asm/tsb.h
@@ -147,13 +147,13 @@ extern struct tsb_phys_patch_entry __tsb
 	brz,pn		REG1, FAIL_LABEL; \
 	 sllx		VADDR, 64 - (PMD_SHIFT + PMD_BITS), REG2; \
 	srlx		REG2, 64 - PAGE_SHIFT, REG2; \
-	sllx		REG1, 11, REG1; \
+	sllx		REG1, PGD_PADDR_SHIFT, REG1; \
 	andn		REG2, 0x3, REG2; \
 	lduwa		[REG1 + REG2] ASI_PHYS_USE_EC, REG1; \
 	brz,pn		REG1, FAIL_LABEL; \
 	 sllx		VADDR, 64 - PMD_SHIFT, REG2; \
 	srlx		REG2, 64 - (PAGE_SHIFT - 1), REG2; \
-	sllx		REG1, 11, REG1; \
+	sllx		REG1, PMD_PADDR_SHIFT, REG1; \
 	andn		REG2, 0x7, REG2; \
 	add		REG1, REG2, REG1;
 
@@ -172,13 +172,13 @@ extern struct tsb_phys_patch_entry __tsb
 	brz,pn		REG1, FAIL_LABEL; \
 	 sllx		VADDR, 64 - (PMD_SHIFT + PMD_BITS), REG2; \
 	srlx		REG2, 64 - PAGE_SHIFT, REG2; \
-	sllx		REG1, 11, REG1; \
+	sllx		REG1, PGD_PADDR_SHIFT, REG1; \
 	andn		REG2, 0x3, REG2; \
 	lduwa		[REG1 + REG2] ASI_PHYS_USE_EC, REG1; \
 	brz,pn		REG1, FAIL_LABEL; \
 	 sllx		VADDR, 64 - PMD_SHIFT, REG2; \
 	srlx		REG2, 64 - (PAGE_SHIFT - 1), REG2; \
-	sllx		REG1, 11, REG1; \
+	sllx		REG1, PMD_PADDR_SHIFT, REG1; \
 	andn		REG2, 0x7, REG2; \
 	add		REG1, REG2, REG1;
 
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
linux-next.patch
kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option.patch
kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option.patch
kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option.patch
kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry.patch
atomic-implement-generic-atomic_dec_if_positive.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
sparc64-only-support-4mb-huge-pages-and-8kb-base-pages.patch
sparc64-halve-the-size-of-pte-tables.patch
sparc64-eliminate-pte-table-memory-wastage.patch
sparc64-document-pgd-and-pmd-layout.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch
mm-thp-use-more-portable-pmd-clearing-sequenece-in-zap_huge_pmd.patch
sparc64-support-transparent-huge-pages.patch
compat-generic-compat_sys_sched_rr_get_interval-implementation.patch

