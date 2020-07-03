From: akpm@linux-foundation.org
Subject: +
 asm-generic-pgalloc-provide-generic-pud_alloc_one-and-pud_free_one.patch
 added to -mm tree
Date: Thu, 02 Jul 2020 21:21:43 -0700
Message-ID: <20200703042143.Auyd_G3bq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgGCEVp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 00:21:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abdhalee@linux.vnet.ibm.com, arnd@arndb.de, christophe.leroy@csgroup.eu, geert@linux-m68k.org, jcmvbkbc@gmail.com, joro@8bytes.org, jroedel@suse.de, luto@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org, peterz@infradead.org, rostedt@goodmis.org, rppt@linux.ibm.com, sathnaga@linux.vnet.ibm.com, sfr@canb.auug.org.au, shorne@gmail.com, willy@infradead.org


The patch titled
     Subject: asm-generic: pgalloc: provide generic pud_alloc_one() and pud_free_one()
has been added to the -mm tree.  Its filename is
     asm-generic-pgalloc-provide-generic-pud_alloc_one-and-pud_free_one.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/asm-generic-pgalloc-provide-generic-pud_alloc_one-and-pud_free_one.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/asm-generic-pgalloc-provide-generic-pud_alloc_one-and-pud_free_one.patch

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
Subject: asm-generic: pgalloc: provide generic pud_alloc_one() and pud_free_one()

Several architectures define pud_alloc_one() as a wrapper for
__get_free_page() and pud_free() as a wrapper for free_page().

Provide a generic implementation in asm-generic/pgalloc.h and use it where
appropriate.

Link: http://lkml.kernel.org/r/20200627143453.31835-6-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
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
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgalloc.h |   11 ----------
 arch/ia64/include/asm/pgalloc.h  |    9 --------
 arch/mips/include/asm/pgalloc.h  |    6 -----
 arch/x86/include/asm/pgalloc.h   |   15 --------------
 include/asm-generic/pgalloc.h    |   30 +++++++++++++++++++++++++++++
 5 files changed, 31 insertions(+), 40 deletions(-)

--- a/arch/arm64/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pud_alloc_one-and-pud_free_one
+++ a/arch/arm64/include/asm/pgalloc.h
@@ -37,17 +37,6 @@ static inline void __pud_populate(pud_t
 
 #if CONFIG_PGTABLE_LEVELS > 3
 
-static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
-{
-	return (pud_t *)__get_free_page(GFP_PGTABLE_USER);
-}
-
-static inline void pud_free(struct mm_struct *mm, pud_t *pudp)
-{
-	BUG_ON((unsigned long)pudp & (PAGE_SIZE-1));
-	free_page((unsigned long)pudp);
-}
-
 static inline void __p4d_populate(p4d_t *p4dp, phys_addr_t pudp, p4dval_t prot)
 {
 	set_p4d(p4dp, __p4d(__phys_to_p4d_val(pudp) | prot));
--- a/arch/ia64/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pud_alloc_one-and-pud_free_one
+++ a/arch/ia64/include/asm/pgalloc.h
@@ -41,15 +41,6 @@ p4d_populate(struct mm_struct *mm, p4d_t
 	p4d_val(*p4d_entry) = __pa(pud);
 }
 
-static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
-{
-	return (pud_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
-}
-
-static inline void pud_free(struct mm_struct *mm, pud_t *pud)
-{
-	free_page((unsigned long)pud);
-}
 #define __pud_free_tlb(tlb, pud, address)	pud_free((tlb)->mm, pud)
 #endif /* CONFIG_PGTABLE_LEVELS == 4 */
 
--- a/arch/mips/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pud_alloc_one-and-pud_free_one
+++ a/arch/mips/include/asm/pgalloc.h
@@ -14,6 +14,7 @@
 #include <linux/sched.h>
 
 #define __HAVE_ARCH_PMD_ALLOC_ONE
+#define __HAVE_ARCH_PUD_ALLOC_ONE
 #include <asm-generic/pgalloc.h>
 
 static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
@@ -87,11 +88,6 @@ static inline pud_t *pud_alloc_one(struc
 	return pud;
 }
 
-static inline void pud_free(struct mm_struct *mm, pud_t *pud)
-{
-	free_pages((unsigned long)pud, PUD_ORDER);
-}
-
 static inline void p4d_populate(struct mm_struct *mm, p4d_t *p4d, pud_t *pud)
 {
 	set_p4d(p4d, __p4d((unsigned long)pud));
--- a/arch/x86/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-pud_alloc_one-and-pud_free_one
+++ a/arch/x86/include/asm/pgalloc.h
@@ -123,21 +123,6 @@ static inline void p4d_populate_safe(str
 	set_p4d_safe(p4d, __p4d(_PAGE_TABLE | __pa(pud)));
 }
 
-static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
-{
-	gfp_t gfp = GFP_KERNEL_ACCOUNT;
-
-	if (mm == &init_mm)
-		gfp &= ~__GFP_ACCOUNT;
-	return (pud_t *)get_zeroed_page(gfp);
-}
-
-static inline void pud_free(struct mm_struct *mm, pud_t *pud)
-{
-	BUG_ON((unsigned long)pud & (PAGE_SIZE-1));
-	free_page((unsigned long)pud);
-}
-
 extern void ___pud_free_tlb(struct mmu_gather *tlb, pud_t *pud);
 
 static inline void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud,
--- a/include/asm-generic/pgalloc.h~asm-generic-pgalloc-provide-generic-pud_alloc_one-and-pud_free_one
+++ a/include/asm-generic/pgalloc.h
@@ -145,6 +145,36 @@ static inline void pmd_free(struct mm_st
 
 #endif /* CONFIG_PGTABLE_LEVELS > 2 */
 
+#if CONFIG_PGTABLE_LEVELS > 3
+
+#ifndef __HAVE_ARCH_PUD_FREE
+/**
+ * pud_alloc_one - allocate a page for PUD-level page table
+ * @mm: the mm_struct of the current context
+ *
+ * Allocates a page using %GFP_PGTABLE_USER for user context and
+ * %GFP_PGTABLE_KERNEL for kernel context.
+ *
+ * Return: pointer to the allocated memory or %NULL on error
+ */
+static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
+{
+	gfp_t gfp = GFP_PGTABLE_USER;
+
+	if (mm == &init_mm)
+		gfp = GFP_PGTABLE_KERNEL;
+	return (pud_t *)get_zeroed_page(gfp);
+}
+#endif
+
+static inline void pud_free(struct mm_struct *mm, pud_t *pud)
+{
+	BUG_ON((unsigned long)pud & (PAGE_SIZE-1));
+	free_page((unsigned long)pud);
+}
+
+#endif /* CONFIG_PGTABLE_LEVELS > 3 */
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
