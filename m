Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8697C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76C2F22D07
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781370;
	bh=5fd7DQcn4eXmY2ykRrT4G89HhfeTLw9r6xnI1VlvRCU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=uT/DBKcRbA4hOyEo0kfPMeFmxk7cfKIW6fkU6SDZy/bLD8+agIcE09z2lutW2gbo7
	 iJKUg0P//rCJpeix3ehU9of6bnEuCHChgKvh1ENps3SOfcARMZYgYnUMZQhWAuyXH4
	 gea4/OcCYwTpYRXSYQp9URuk0Y1841TLLG64KAaY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgHGGWu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:22:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgHGGWu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:22:50 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CB7C22D00;
        Fri,  7 Aug 2020 06:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781369;
        bh=5fd7DQcn4eXmY2ykRrT4G89HhfeTLw9r6xnI1VlvRCU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GaEPC3TU4KRRzapq6i7XJ3Y01cPUNQVuQvRpMlC64RkiZT3F0+iE85Udk9QrD9Gcr
         ywYHdBkcLBRePsck12NuBEvM0sS4sxpVwvF/uDIXfZNPYQeeu9spz9mms4C3ZfLULs
         3bMz4dyBns2Wp8GoMnpr9b1IBUr1wxcymxrwE07w=
Date:   Thu, 06 Aug 2020 23:22:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     abdhalee@linux.vnet.ibm.com, akpm@linux-foundation.org,
        arnd@arndb.de, christophe.leroy@csgroup.eu, geert@linux-m68k.org,
        jcmvbkbc@gmail.com, joro@8bytes.org, jroedel@suse.de,
        linux-mm@kvack.org, luto@kernel.org, mm-commits@vger.kernel.org,
        penberg@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        rppt@linux.ibm.com, sathnaga@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, shorne@gmail.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 101/163] asm-generic: pgalloc: provide generic
 pgd_free()
Message-ID: <20200807062247.fTrAYwgx5%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: asm-generic: pgalloc: provide generic pgd_free()

Most architectures define pgd_free() as a wrapper for free_page().

Provide a generic version in asm-generic/pgalloc.h and enable its use for
most architectures.

Link: http://lkml.kernel.org/r/20200627143453.31835-7-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>	[m68k]
Reviewed-by: Pekka Enberg <penberg@kernel.org>
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
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/pgalloc.h      |    6 ------
 arch/arm/include/asm/pgalloc.h        |    1 +
 arch/arm64/include/asm/pgalloc.h      |    1 +
 arch/csky/include/asm/pgalloc.h       |    7 +------
 arch/hexagon/include/asm/pgalloc.h    |    7 +------
 arch/ia64/include/asm/pgalloc.h       |    5 -----
 arch/m68k/include/asm/sun3_pgalloc.h  |    7 +------
 arch/microblaze/include/asm/pgalloc.h |    6 ------
 arch/mips/include/asm/pgalloc.h       |    5 -----
 arch/nds32/mm/mm-nds32.c              |    2 ++
 arch/nios2/include/asm/pgalloc.h      |    7 +------
 arch/parisc/include/asm/pgalloc.h     |    1 +
 arch/riscv/include/asm/pgalloc.h      |    5 -----
 arch/sh/include/asm/pgalloc.h         |    1 +
 arch/um/include/asm/pgalloc.h         |    1 -
 arch/um/kernel/mem.c                  |    5 -----
 arch/x86/include/asm/pgalloc.h        |    1 +
 arch/xtensa/include/asm/pgalloc.h     |    5 -----
 include/asm-generic/pgalloc.h         |    7 +++++++
 19 files changed, 18 insertions(+), 62 deletions(-)

--- a/arch/alpha/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pgd_free
+++ a/arch/alpha/include/asm/pgalloc.h
@@ -34,10 +34,4 @@ pud_populate(struct mm_struct *mm, pud_t
 
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 
-static inline void
-pgd_free(struct mm_struct *mm, pgd_t *pgd)
-{
-	free_page((unsigned long)pgd);
-}
-
 #endif /* _ALPHA_PGALLOC_H */
--- a/arch/arm64/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pgd_free
+++ a/arch/arm64/include/asm/pgalloc.h
@@ -13,6 +13,7 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
+#define __HAVE_ARCH_PGD_FREE
 #include <asm-generic/pgalloc.h>
 
 #define PGD_SIZE	(PTRS_PER_PGD * sizeof(pgd_t))
--- a/arch/arm/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pgd_free
+++ a/arch/arm/include/asm/pgalloc.h
@@ -65,6 +65,7 @@ static inline void clean_pte_table(pte_t
 
 #define __HAVE_ARCH_PTE_ALLOC_ONE_KERNEL
 #define __HAVE_ARCH_PTE_ALLOC_ONE
+#define __HAVE_ARCH_PGD_FREE
 #include <asm-generic/pgalloc.h>
 
 static inline pte_t *
--- a/arch/csky/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pgd_free
+++ a/arch/csky/include/asm/pgalloc.h
@@ -9,7 +9,7 @@
 #include <linux/sched.h>
 
 #define __HAVE_ARCH_PTE_ALLOC_ONE_KERNEL
-#include <asm-generic/pgalloc.h>	/* for pte_{alloc,free}_one */
+#include <asm-generic/pgalloc.h>
 
 static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
 					pte_t *pte)
@@ -42,11 +42,6 @@ static inline pte_t *pte_alloc_one_kerne
 	return pte;
 }
 
-static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
-{
-	free_pages((unsigned long)pgd, PGD_ORDER);
-}
-
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *ret;
--- a/arch/hexagon/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pgd_free
+++ a/arch/hexagon/include/asm/pgalloc.h
@@ -11,7 +11,7 @@
 #include <asm/mem-layout.h>
 #include <asm/atomic.h>
 
-#include <asm-generic/pgalloc.h>	/* for pte_{alloc,free}_one */
+#include <asm-generic/pgalloc.h>
 
 extern unsigned long long kmap_generation;
 
@@ -41,11 +41,6 @@ static inline pgd_t *pgd_alloc(struct mm
 	return pgd;
 }
 
-static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
-{
-	free_page((unsigned long) pgd);
-}
-
 static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
 				pgtable_t pte)
 {
--- a/arch/ia64/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pgd_free
+++ a/arch/ia64/include/asm/pgalloc.h
@@ -29,11 +29,6 @@ static inline pgd_t *pgd_alloc(struct mm
 	return (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
 }
 
-static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
-{
-	free_page((unsigned long)pgd);
-}
-
 #if CONFIG_PGTABLE_LEVELS == 4
 static inline void
 p4d_populate(struct mm_struct *mm, p4d_t * p4d_entry, pud_t * pud)
--- a/arch/m68k/include/asm/sun3_pgalloc.h~asm-generic-pgalloc-provide-generic-pgd_free
+++ a/arch/m68k/include/asm/sun3_pgalloc.h
@@ -13,7 +13,7 @@
 
 #include <asm/tlb.h>
 
-#include <asm-generic/pgalloc.h>	/* for pte_{alloc,free}_one */
+#include <asm-generic/pgalloc.h>
 
 extern const char bad_pmd_string[];
 
@@ -40,11 +40,6 @@ static inline void pmd_populate(struct m
  */
 #define pmd_free(mm, x)			do { } while (0)
 
-static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
-{
-        free_page((unsigned long) pgd);
-}
-
 static inline pgd_t * pgd_alloc(struct mm_struct *mm)
 {
      pgd_t *new_pgd;
--- a/arch/microblaze/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pgd_free
+++ a/arch/microblaze/include/asm/pgalloc.h
@@ -28,12 +28,6 @@ static inline pgd_t *get_pgd(void)
 	return (pgd_t *)__get_free_pages(GFP_KERNEL|__GFP_ZERO, 0);
 }
 
-static inline void free_pgd(pgd_t *pgd)
-{
-	free_page((unsigned long)pgd);
-}
-
-#define pgd_free(mm, pgd)	free_pgd(pgd)
 #define pgd_alloc(mm)		get_pgd()
 
 #define pmd_pgtable(pmd)	pmd_page(pmd)
--- a/arch/mips/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pgd_free
+++ a/arch/mips/include/asm/pgalloc.h
@@ -49,11 +49,6 @@ static inline void pud_populate(struct m
 extern void pgd_init(unsigned long page);
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 
-static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
-{
-	free_pages((unsigned long)pgd, PGD_ORDER);
-}
-
 #define __pte_free_tlb(tlb,pte,address)			\
 do {							\
 	pgtable_pte_page_dtor(pte);			\
--- a/arch/nds32/mm/mm-nds32.c~asm-generic-pgalloc-provide-generic-pgd_free
+++ a/arch/nds32/mm/mm-nds32.c
@@ -2,6 +2,8 @@
 // Copyright (C) 2005-2017 Andes Technology Corporation
 
 #include <linux/init_task.h>
+
+#define __HAVE_ARCH_PGD_FREE
 #include <asm/pgalloc.h>
 
 #define FIRST_KERNEL_PGD_NR	(USER_PTRS_PER_PGD)
--- a/arch/nios2/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pgd_free
+++ a/arch/nios2/include/asm/pgalloc.h
@@ -12,7 +12,7 @@
 
 #include <linux/mm.h>
 
-#include <asm-generic/pgalloc.h>	/* for pte_{alloc,free}_one */
+#include <asm-generic/pgalloc.h>
 
 static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
 	pte_t *pte)
@@ -34,11 +34,6 @@ extern void pmd_init(unsigned long page,
 
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 
-static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
-{
-	free_pages((unsigned long)pgd, PGD_ORDER);
-}
-
 #define __pte_free_tlb(tlb, pte, addr)				\
 	do {							\
 		pgtable_pte_page_dtor(pte);			\
--- a/arch/parisc/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pgd_free
+++ a/arch/parisc/include/asm/pgalloc.h
@@ -11,6 +11,7 @@
 #include <asm/cache.h>
 
 #define __HAVE_ARCH_PMD_FREE
+#define __HAVE_ARCH_PGD_FREE
 #include <asm-generic/pgalloc.h>
 
 /* Allocate the top level pgd (page directory)
--- a/arch/riscv/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pgd_free
+++ a/arch/riscv/include/asm/pgalloc.h
@@ -55,11 +55,6 @@ static inline pgd_t *pgd_alloc(struct mm
 	return pgd;
 }
 
-static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
-{
-	free_page((unsigned long)pgd);
-}
-
 #ifndef __PAGETABLE_PMD_FOLDED
 
 #define __pmd_free_tlb(tlb, pmd, addr)  pmd_free((tlb)->mm, pmd)
--- a/arch/sh/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pgd_free
+++ a/arch/sh/include/asm/pgalloc.h
@@ -6,6 +6,7 @@
 
 #define __HAVE_ARCH_PMD_ALLOC_ONE
 #define __HAVE_ARCH_PMD_FREE
+#define __HAVE_ARCH_PGD_FREE
 #include <asm-generic/pgalloc.h>
 
 extern pgd_t *pgd_alloc(struct mm_struct *);
--- a/arch/um/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pgd_free
+++ a/arch/um/include/asm/pgalloc.h
@@ -25,7 +25,6 @@
  * Allocate and free page tables.
  */
 extern pgd_t *pgd_alloc(struct mm_struct *);
-extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
 
 #define __pte_free_tlb(tlb,pte, address)		\
 do {							\
--- a/arch/um/kernel/mem.c~asm-generic-pgalloc-provide-generic-pgd_free
+++ a/arch/um/kernel/mem.c
@@ -196,11 +196,6 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	return pgd;
 }
 
-void pgd_free(struct mm_struct *mm, pgd_t *pgd)
-{
-	free_page((unsigned long) pgd);
-}
-
 void *uml_kmalloc(int size, int flags)
 {
 	return kmalloc(size, flags);
--- a/arch/x86/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pgd_free
+++ a/arch/x86/include/asm/pgalloc.h
@@ -7,6 +7,7 @@
 #include <linux/pagemap.h>
 
 #define __HAVE_ARCH_PTE_ALLOC_ONE
+#define __HAVE_ARCH_PGD_FREE
 #include <asm-generic/pgalloc.h>
 
 static inline int  __paravirt_pgd_alloc(struct mm_struct *mm) { return 0; }
--- a/arch/xtensa/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pgd_free
+++ a/arch/xtensa/include/asm/pgalloc.h
@@ -33,11 +33,6 @@ pgd_alloc(struct mm_struct *mm)
 	return (pgd_t*) __get_free_pages(GFP_KERNEL | __GFP_ZERO, PGD_ORDER);
 }
 
-static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
-{
-	free_page((unsigned long)pgd);
-}
-
 static inline void ptes_clear(pte_t *ptep)
 {
 	int i;
--- a/include/asm-generic/pgalloc.h~asm-generic-pgalloc-provide-generic-pgd_free
+++ a/include/asm-generic/pgalloc.h
@@ -175,6 +175,13 @@ static inline void pud_free(struct mm_st
 
 #endif /* CONFIG_PGTABLE_LEVELS > 3 */
 
+#ifndef __HAVE_ARCH_PGD_FREE
+static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
+{
+	free_page((unsigned long)pgd);
+}
+#endif
+
 #endif /* CONFIG_MMU */
 
 #endif /* __ASM_GENERIC_PGALLOC_H */
_
