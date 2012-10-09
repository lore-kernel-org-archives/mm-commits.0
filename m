From: akpm@linux-foundation.org
Subject: [merged] sparc64-document-pgd-and-pmd-layout.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:15:33 -0700
Message-ID: <20121009181534.2D2AA20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:38366 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865Ab2JISPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:15:37 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so309410lah.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:15:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, aarcange@redhat.com, gerald.schaefer@de.ibm.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc64: Document PGD and PMD layout.
has been removed from the -mm tree.  Its filename was
     sparc64-document-pgd-and-pmd-layout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
compat-generic-compat_sys_sched_rr_get_interval-implementation.patch

