Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E894C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D12B32076C
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027072;
	bh=n3QZWrHeTC65PfgsReqZEXlecvSXw0BApEXsFE2zW2M=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=AWJXZCgvhu1AWfEhih73vjFxQ8jBGcIrAusj6b+QvmJStaiJAGshyWvkXJHXyAhYc
	 pi1LaM0FRvGqXGw4o4YhrjJ4gyXDrW43h8sui5sVuXwTd1oEBFCePgMlxQ1ov2rF2Q
	 /QQ3rUkpVwCrGoVzFeqZZYGiNqEXZDWB6cDlGC1M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgHJChw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJChw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:37:52 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE97C2075D;
        Mon, 10 Aug 2020 02:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027071;
        bh=n3QZWrHeTC65PfgsReqZEXlecvSXw0BApEXsFE2zW2M=;
        h=Date:From:To:Subject:From;
        b=keK77XA6jGtVxm14lnYoZQpBAFQztmdtAf8JuTPkzpKCzRqjl/S5bUTCoq7M5PMX8
         W1pjsNBe4Ii74EGNOjOHd6lYL4NVZ49UUfF5snfXez1+aJB2aahUSL1ROuo0SpA20O
         EOLxCBJk+LuEwFxigVCphLxdrYTBIJVusea1Dn3A=
Date:   Sun, 09 Aug 2020 19:37:50 -0700
From:   akpm@linux-foundation.org
To:     abdhalee@linux.vnet.ibm.com, arnd@arndb.de,
        christophe.leroy@csgroup.eu, geert@linux-m68k.org,
        jcmvbkbc@gmail.com, joro@8bytes.org, jroedel@suse.de,
        luto@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, rppt@linux.ibm.com,
        sathnaga@linux.vnet.ibm.com, sfr@canb.auug.org.au,
        shorne@gmail.com, willy@infradead.org
Subject:  [merged]
 asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one.patch
 removed from -mm tree
Message-ID: <20200810023750.oJDs2PUyD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: asm-generic: pgalloc: provide generic pmd_alloc_one() and pmd_free_one()
has been removed from the -mm tree.  Its filename was
     asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: asm-generic: pgalloc: provide generic pmd_alloc_one() and pmd_free_one()

For most architectures that support >2 levels of page tables,
pmd_alloc_one() is a wrapper for __get_free_pages(), sometimes with
__GFP_ZERO and sometimes followed by memset(0) instead.

More elaborate versions on arm64 and x86 account memory for the user page
tables and call to pgtable_pmd_page_ctor() as the part of PMD page
initialization.

Move the arm64 version to include/asm-generic/pgalloc.h and use the
generic version on several architectures.

The pgtable_pmd_page_ctor() is a NOP when ARCH_ENABLE_SPLIT_PMD_PTLOCK is
not enabled, so there is no functional change for most architectures
except of the addition of __GFP_ACCOUNT for allocation of user page
tables.

The pmd_free() is a wrapper for free_page() in all the cases, so no
functional change here.

Link: http://lkml.kernel.org/r/20200627143453.31835-5-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/pgalloc.h     |   15 --------
 arch/arm/include/asm/pgalloc.h       |   11 ------
 arch/arm64/include/asm/pgalloc.h     |   27 ---------------
 arch/ia64/include/asm/pgalloc.h      |   10 -----
 arch/mips/include/asm/pgalloc.h      |    8 +---
 arch/parisc/include/asm/pgalloc.h    |   11 +-----
 arch/riscv/include/asm/pgalloc.h     |   13 -------
 arch/sh/include/asm/pgalloc.h        |    3 +
 arch/um/include/asm/pgalloc.h        |    8 ----
 arch/um/include/asm/pgtable-3level.h |    3 -
 arch/um/kernel/mem.c                 |   12 ------
 arch/x86/include/asm/pgalloc.h       |   26 ---------------
 include/asm-generic/pgalloc.h        |   43 +++++++++++++++++++++++++
 13 files changed, 55 insertions(+), 135 deletions(-)

--- a/arch/alpha/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one
+++ a/arch/alpha/include/asm/pgalloc.h
@@ -5,7 +5,7 @@
 #include <linux/mm.h>
 #include <linux/mmzone.h>
 
-#include <asm-generic/pgalloc.h>	/* for pte_{alloc,free}_one */
+#include <asm-generic/pgalloc.h>
 
 /*      
  * Allocate and free page tables. The xxx_kernel() versions are
@@ -40,17 +40,4 @@ pgd_free(struct mm_struct *mm, pgd_t *pg
 	free_page((unsigned long)pgd);
 }
 
-static inline pmd_t *
-pmd_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	pmd_t *ret = (pmd_t *)__get_free_page(GFP_PGTABLE_USER);
-	return ret;
-}
-
-static inline void
-pmd_free(struct mm_struct *mm, pmd_t *pmd)
-{
-	free_page((unsigned long)pmd);
-}
-
 #endif /* _ALPHA_PGALLOC_H */
--- a/arch/arm64/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one
+++ a/arch/arm64/include/asm/pgalloc.h
@@ -13,37 +13,12 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
-#include <asm-generic/pgalloc.h>	/* for pte_{alloc,free}_one */
+#include <asm-generic/pgalloc.h>
 
 #define PGD_SIZE	(PTRS_PER_PGD * sizeof(pgd_t))
 
 #if CONFIG_PGTABLE_LEVELS > 2
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
-{
-	gfp_t gfp = GFP_PGTABLE_USER;
-	struct page *page;
-
-	if (mm == &init_mm)
-		gfp = GFP_PGTABLE_KERNEL;
-
-	page = alloc_page(gfp);
-	if (!page)
-		return NULL;
-	if (!pgtable_pmd_page_ctor(page)) {
-		__free_page(page);
-		return NULL;
-	}
-	return page_address(page);
-}
-
-static inline void pmd_free(struct mm_struct *mm, pmd_t *pmdp)
-{
-	BUG_ON((unsigned long)pmdp & (PAGE_SIZE-1));
-	pgtable_pmd_page_dtor(virt_to_page(pmdp));
-	free_page((unsigned long)pmdp);
-}
-
 static inline void __pud_populate(pud_t *pudp, phys_addr_t pmdp, pudval_t prot)
 {
 	set_pud(pudp, __pud(__phys_to_pud_val(pmdp) | prot));
--- a/arch/arm/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one
+++ a/arch/arm/include/asm/pgalloc.h
@@ -22,17 +22,6 @@
 
 #ifdef CONFIG_ARM_LPAE
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
-{
-	return (pmd_t *)get_zeroed_page(GFP_KERNEL);
-}
-
-static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
-{
-	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
-	free_page((unsigned long)pmd);
-}
-
 static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
 {
 	set_pud(pud, __pud(__pa(pmd) | PMD_TYPE_TABLE));
--- a/arch/ia64/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one
+++ a/arch/ia64/include/asm/pgalloc.h
@@ -59,16 +59,6 @@ pud_populate(struct mm_struct *mm, pud_t
 	pud_val(*pud_entry) = __pa(pmd);
 }
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
-{
-	return (pmd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
-}
-
-static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
-{
-	free_page((unsigned long)pmd);
-}
-
 #define __pmd_free_tlb(tlb, pmd, address)	pmd_free((tlb)->mm, pmd)
 
 static inline void
--- a/arch/mips/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one
+++ a/arch/mips/include/asm/pgalloc.h
@@ -13,7 +13,8 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 
-#include <asm-generic/pgalloc.h>	/* for pte_{alloc,free}_one */
+#define __HAVE_ARCH_PMD_ALLOC_ONE
+#include <asm-generic/pgalloc.h>
 
 static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
 	pte_t *pte)
@@ -70,11 +71,6 @@ static inline pmd_t *pmd_alloc_one(struc
 	return pmd;
 }
 
-static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
-{
-	free_pages((unsigned long)pmd, PMD_ORDER);
-}
-
 #define __pmd_free_tlb(tlb, x, addr)	pmd_free((tlb)->mm, x)
 
 #endif
--- a/arch/parisc/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one
+++ a/arch/parisc/include/asm/pgalloc.h
@@ -10,7 +10,8 @@
 
 #include <asm/cache.h>
 
-#include <asm-generic/pgalloc.h>	/* for pte_{alloc,free}_one */
+#define __HAVE_ARCH_PMD_FREE
+#include <asm-generic/pgalloc.h>
 
 /* Allocate the top level pgd (page directory)
  *
@@ -65,14 +66,6 @@ static inline void pud_populate(struct m
 			(__u32)(__pa((unsigned long)pmd) >> PxD_VALUE_SHIFT)));
 }
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	pmd_t *pmd = (pmd_t *)__get_free_pages(GFP_KERNEL, PMD_ORDER);
-	if (pmd)
-		memset(pmd, 0, PAGE_SIZE<<PMD_ORDER);
-	return pmd;
-}
-
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
 	if (pmd_flag(*pmd) & PxD_FLAG_ATTACHED) {
--- a/arch/riscv/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one
+++ a/arch/riscv/include/asm/pgalloc.h
@@ -11,7 +11,7 @@
 #include <asm/tlb.h>
 
 #ifdef CONFIG_MMU
-#include <asm-generic/pgalloc.h>	/* for pte_{alloc,free}_one */
+#include <asm-generic/pgalloc.h>
 
 static inline void pmd_populate_kernel(struct mm_struct *mm,
 	pmd_t *pmd, pte_t *pte)
@@ -62,17 +62,6 @@ static inline void pgd_free(struct mm_st
 
 #ifndef __PAGETABLE_PMD_FOLDED
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
-{
-	return (pmd_t *)__get_free_page(
-		GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_ZERO);
-}
-
-static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
-{
-	free_page((unsigned long)pmd);
-}
-
 #define __pmd_free_tlb(tlb, pmd, addr)  pmd_free((tlb)->mm, pmd)
 
 #endif /* __PAGETABLE_PMD_FOLDED */
--- a/arch/sh/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one
+++ a/arch/sh/include/asm/pgalloc.h
@@ -3,6 +3,9 @@
 #define __ASM_SH_PGALLOC_H
 
 #include <asm/page.h>
+
+#define __HAVE_ARCH_PMD_ALLOC_ONE
+#define __HAVE_ARCH_PMD_FREE
 #include <asm-generic/pgalloc.h>
 
 extern pgd_t *pgd_alloc(struct mm_struct *);
--- a/arch/um/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one
+++ a/arch/um/include/asm/pgalloc.h
@@ -10,7 +10,7 @@
 
 #include <linux/mm.h>
 
-#include <asm-generic/pgalloc.h>	/* for pte_{alloc,free}_one */
+#include <asm-generic/pgalloc.h>
 
 #define pmd_populate_kernel(mm, pmd, pte) \
 	set_pmd(pmd, __pmd(_PAGE_TABLE + (unsigned long) __pa(pte)))
@@ -34,12 +34,6 @@ do {							\
 } while (0)
 
 #ifdef CONFIG_3_LEVEL_PGTABLES
-
-static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
-{
-	free_page((unsigned long)pmd);
-}
-
 #define __pmd_free_tlb(tlb,x, address)   tlb_remove_page((tlb),virt_to_page(x))
 #endif
 
--- a/arch/um/include/asm/pgtable-3level.h~asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one
+++ a/arch/um/include/asm/pgtable-3level.h
@@ -78,9 +78,6 @@ static inline void pgd_mkuptodate(pgd_t
 #define set_pmd(pmdptr, pmdval) (*(pmdptr) = (pmdval))
 #endif
 
-struct mm_struct;
-extern pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address);
-
 static inline void pud_clear (pud_t *pud)
 {
 	set_pud(pud, __pud(_PAGE_NEWPAGE));
--- a/arch/um/kernel/mem.c~asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one
+++ a/arch/um/kernel/mem.c
@@ -201,18 +201,6 @@ void pgd_free(struct mm_struct *mm, pgd_
 	free_page((unsigned long) pgd);
 }
 
-#ifdef CONFIG_3_LEVEL_PGTABLES
-pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	pmd_t *pmd = (pmd_t *) __get_free_page(GFP_KERNEL);
-
-	if (pmd)
-		memset(pmd, 0, PAGE_SIZE);
-
-	return pmd;
-}
-#endif
-
 void *uml_kmalloc(int size, int flags)
 {
 	return kmalloc(size, flags);
--- a/arch/x86/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one
+++ a/arch/x86/include/asm/pgalloc.h
@@ -7,7 +7,7 @@
 #include <linux/pagemap.h>
 
 #define __HAVE_ARCH_PTE_ALLOC_ONE
-#include <asm-generic/pgalloc.h>	/* for pte_{alloc,free}_one */
+#include <asm-generic/pgalloc.h>
 
 static inline int  __paravirt_pgd_alloc(struct mm_struct *mm) { return 0; }
 
@@ -86,30 +86,6 @@ static inline void pmd_populate(struct m
 #define pmd_pgtable(pmd) pmd_page(pmd)
 
 #if CONFIG_PGTABLE_LEVELS > 2
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
-{
-	struct page *page;
-	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO;
-
-	if (mm == &init_mm)
-		gfp &= ~__GFP_ACCOUNT;
-	page = alloc_pages(gfp, 0);
-	if (!page)
-		return NULL;
-	if (!pgtable_pmd_page_ctor(page)) {
-		__free_pages(page, 0);
-		return NULL;
-	}
-	return (pmd_t *)page_address(page);
-}
-
-static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
-{
-	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
-	pgtable_pmd_page_dtor(virt_to_page(pmd));
-	free_page((unsigned long)pmd);
-}
-
 extern void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
 
 static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd,
--- a/include/asm-generic/pgalloc.h~asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one
+++ a/include/asm-generic/pgalloc.h
@@ -102,6 +102,49 @@ static inline void pte_free(struct mm_st
 	__free_page(pte_page);
 }
 
+
+#if CONFIG_PGTABLE_LEVELS > 2
+
+#ifndef __HAVE_ARCH_PMD_ALLOC_ONE
+/**
+ * pmd_alloc_one - allocate a page for PMD-level page table
+ * @mm: the mm_struct of the current context
+ *
+ * Allocates a page and runs the pgtable_pmd_page_ctor().
+ * Allocations use %GFP_PGTABLE_USER in user context and
+ * %GFP_PGTABLE_KERNEL in kernel context.
+ *
+ * Return: pointer to the allocated memory or %NULL on error
+ */
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
+{
+	struct page *page;
+	gfp_t gfp = GFP_PGTABLE_USER;
+
+	if (mm == &init_mm)
+		gfp = GFP_PGTABLE_KERNEL;
+	page = alloc_pages(gfp, 0);
+	if (!page)
+		return NULL;
+	if (!pgtable_pmd_page_ctor(page)) {
+		__free_pages(page, 0);
+		return NULL;
+	}
+	return (pmd_t *)page_address(page);
+}
+#endif
+
+#ifndef __HAVE_ARCH_PMD_FREE
+static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
+{
+	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
+	pgtable_pmd_page_dtor(virt_to_page(pmd));
+	free_page((unsigned long)pmd);
+}
+#endif
+
+#endif /* CONFIG_PGTABLE_LEVELS > 2 */
+
 #endif /* CONFIG_MMU */
 
 #endif /* __ASM_GENERIC_PGALLOC_H */
_

Patches currently in -mm which might be from rppt@linux.ibm.com are


