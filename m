From: akpm@linux-foundation.org
Subject: + asm-generic-pgalloc-provide-generic-pgd_free.patch
 added to -mm tree
Date: Thu, 02 Jul 2020 21:21:47 -0700
Message-ID: <20200703042147.eFBZJ3b1O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgGCEVt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 00:21:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abdhalee@linux.vnet.ibm.com, arnd@arndb.de, christophe.leroy@csgroup.eu, geert@linux-m68k.org, jcmvbkbc@gmail.com, joro@8bytes.org, jroedel@suse.de, luto@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org, peterz@infradead.org, rostedt@goodmis.org, rppt@linux.ibm.com, sathnaga@linux.vnet.ibm.com, sfr@canb.auug.org.au, shorne@gmail.com, willy@infradead.org


The patch titled
     Subject: asm-generic: pgalloc: provide generic pgd_free()
has been added to the -mm tree.  Its filename is
     asm-generic-pgalloc-provide-generic-pgd_free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/asm-generic-pgalloc-provide-generic-pgd_free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/asm-generic-pgalloc-provide-generic-pgd_free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-remove-unneeded-includes-of-asm-pgalloch.patch
opeinrisc-switch-to-generic-version-of-pte-allocation.patch
xtensa-switch-to-generic-version-of-pte-allocation.patch
asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one.patch
asm-generic-pgalloc-provide-generic-pud_alloc_one-and-pud_free_one.patch
asm-generic-pgalloc-provide-generic-pgd_free.patch
mm-move-lib-ioremapc-to-mm.patch
