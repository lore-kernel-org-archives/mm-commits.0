From: akpm@linux-foundation.org
Subject: + mm-unify-some-pmd_-functions-fix.patch added to -mm tree
Date: Wed, 28 Jan 2009 16:24:19 -0800
Message-ID: <200901290024.n0T0OKej010115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765217AbZA2A0p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jan 2009 19:26:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: righi.andrea@gmail.com, benh@kernel.crashing.org, davem@davemloft.net, grundler@parisc-linux.org, heiko.carstens@de.ibm.com, hpa@zytor.com, ink@jurassic.park.msu.ru, jdike@addtoit.com, kyle@mcmartin.ca, lethal@linux-sh.org, mingo@elte.hu, ralf@linux-mips.org, rmk@arm.linux.org.uk, rth@twiddle.net, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     mm: unify some pmd_*() functions fix
has been added to the -mm tree.  Its filename is
     mm-unify-some-pmd_-functions-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: unify some pmd_*() functions fix
From: Andrea Righi <righi.andrea@gmail.com>

Also unify implementations of pmd_*() functions in arch/*.

This patch must be applied on top of mm-unify-some-pmd_-functions.patch.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/pgalloc.h      |    2 ++
 arch/arm/include/asm/pgalloc.h        |    3 +--
 arch/ia64/include/asm/pgalloc.h       |    2 ++
 arch/mips/include/asm/pgalloc.h       |   13 ++-----------
 arch/parisc/include/asm/pgalloc.h     |    5 +++--
 arch/powerpc/include/asm/pgalloc-32.h |    9 ---------
 arch/powerpc/include/asm/pgalloc-64.h |    2 ++
 arch/s390/include/asm/pgalloc.h       |    3 +--
 arch/sh/include/asm/pgalloc.h         |    8 --------
 arch/sparc/include/asm/pgalloc_64.h   |    2 ++
 arch/um/include/asm/pgalloc.h         |    1 +
 arch/um/include/asm/pgtable-3level.h  |    1 +
 arch/x86/include/asm/pgalloc.h        |    3 +++
 13 files changed, 20 insertions(+), 34 deletions(-)

diff -puN arch/alpha/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix arch/alpha/include/asm/pgalloc.h
--- a/arch/alpha/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix
+++ a/arch/alpha/include/asm/pgalloc.h
@@ -43,12 +43,14 @@ pmd_alloc_one(struct mm_struct *mm, unsi
 	pmd_t *ret = (pmd_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
 	return ret;
 }
+#define pmd_alloc_one pmd_alloc_one
 
 static inline void
 pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
 	free_page((unsigned long)pmd);
 }
+#define pmd_free pmd_free
 
 static inline pte_t *
 pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
diff -puN arch/arm/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix arch/arm/include/asm/pgalloc.h
--- a/arch/arm/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix
+++ a/arch/arm/include/asm/pgalloc.h
@@ -26,8 +26,7 @@
 /*
  * Since we have only two-level page tables, these are trivial
  */
-#define pmd_alloc_one(mm,addr)		({ BUG(); ((pmd_t *)2); })
-#define pmd_free(mm, pmd)		do { } while (0)
+#define pmd_alloc_one	pmd_alloc_one_bug
 #define pgd_populate(mm,pmd,pte)	BUG()
 
 extern pgd_t *get_pgd_slow(struct mm_struct *mm);
diff -puN arch/ia64/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix arch/ia64/include/asm/pgalloc.h
--- a/arch/ia64/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix
+++ a/arch/ia64/include/asm/pgalloc.h
@@ -61,11 +61,13 @@ static inline pmd_t *pmd_alloc_one(struc
 {
 	return quicklist_alloc(0, GFP_KERNEL, NULL);
 }
+#define pmd_alloc_one pmd_alloc_one
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
 	quicklist_free(0, NULL, pmd);
 }
+#define pmd_free pmd_free
 
 #define __pmd_free_tlb(tlb, pmd)	pmd_free((tlb)->mm, pmd)
 
diff -puN arch/mips/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix arch/mips/include/asm/pgalloc.h
--- a/arch/mips/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix
+++ a/arch/mips/include/asm/pgalloc.h
@@ -104,17 +104,6 @@ do {							\
 	tlb_remove_page((tlb), pte);			\
 } while (0)
 
-#ifdef CONFIG_32BIT
-
-/*
- * allocating and freeing a pmd is trivial: the 1-entry pmd is
- * inside the pgd, so has no extra memory associated with it.
- */
-#define pmd_free(mm, x)			do { } while (0)
-#define __pmd_free_tlb(tlb, x)		do { } while (0)
-
-#endif
-
 #ifdef CONFIG_64BIT
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
@@ -126,11 +115,13 @@ static inline pmd_t *pmd_alloc_one(struc
 		pmd_init((unsigned long)pmd, (unsigned long)invalid_pte_table);
 	return pmd;
 }
+#define pmd_alloc_one pmd_alloc_one
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
 	free_pages((unsigned long)pmd, PMD_ORDER);
 }
+#define pmd_free pmd_free
 
 #define __pmd_free_tlb(tlb, x)	pmd_free((tlb)->mm, x)
 
diff -puN arch/parisc/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix arch/parisc/include/asm/pgalloc.h
--- a/arch/parisc/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix
+++ a/arch/parisc/include/asm/pgalloc.h
@@ -69,6 +69,7 @@ static inline pmd_t *pmd_alloc_one(struc
 		memset(pmd, 0, PAGE_SIZE<<PMD_ORDER);
 	return pmd;
 }
+#define pmd_alloc_one pmd_alloc_one
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
@@ -80,6 +81,7 @@ static inline void pmd_free(struct mm_st
 #endif
 	free_pages((unsigned long)pmd, PMD_ORDER);
 }
+#define pmd_free pmd_free
 
 #else
 
@@ -90,8 +92,7 @@ static inline void pmd_free(struct mm_st
  * inside the pgd, so has no extra memory associated with it.
  */
 
-#define pmd_alloc_one(mm, addr)		({ BUG(); ((pmd_t *)2); })
-#define pmd_free(mm, x)			do { } while (0)
+#define pmd_alloc_one	pmd_alloc_one_bug
 #define pgd_populate(mm, pmd, pte)	BUG()
 
 #endif
diff -puN arch/powerpc/include/asm/pgalloc-32.h~mm-unify-some-pmd_-functions-fix arch/powerpc/include/asm/pgalloc-32.h
--- a/arch/powerpc/include/asm/pgalloc-32.h~mm-unify-some-pmd_-functions-fix
+++ a/arch/powerpc/include/asm/pgalloc-32.h
@@ -10,15 +10,6 @@ extern void __bad_pte(pmd_t *pmd);
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
 
-/*
- * We don't have any real pmd's, and this code never triggers because
- * the pgd will always be present..
- */
-/* #define pmd_alloc_one(mm,address)       ({ BUG(); ((pmd_t *)2); }) */
-#define pmd_free(mm, x) 		do { } while (0)
-#define __pmd_free_tlb(tlb,x)		do { } while (0)
-/* #define pgd_populate(mm, pmd, pte)      BUG() */
-
 #ifndef CONFIG_BOOKE
 #define pmd_populate_kernel(mm, pmd, pte)	\
 		(pmd_val(*(pmd)) = __pa(pte) | _PMD_PRESENT)
diff -puN arch/powerpc/include/asm/pgalloc-64.h~mm-unify-some-pmd_-functions-fix arch/powerpc/include/asm/pgalloc-64.h
--- a/arch/powerpc/include/asm/pgalloc-64.h~mm-unify-some-pmd_-functions-fix
+++ a/arch/powerpc/include/asm/pgalloc-64.h
@@ -81,11 +81,13 @@ static inline pmd_t *pmd_alloc_one(struc
 	return kmem_cache_alloc(pgtable_cache[PMD_CACHE_NUM],
 				GFP_KERNEL|__GFP_REPEAT);
 }
+#define pmd_alloc_one pmd_alloc_one
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
 	kmem_cache_free(pgtable_cache[PMD_CACHE_NUM], pmd);
 }
+#define pmd_free pmd_free
 
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long address)
diff -puN arch/s390/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix arch/s390/include/asm/pgalloc.h
--- a/arch/s390/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix
+++ a/arch/s390/include/asm/pgalloc.h
@@ -63,8 +63,7 @@ static inline unsigned long pgd_entry_ty
 #define pud_alloc_one(mm,address)		({ BUG(); ((pud_t *)2); })
 #define pud_free(mm, x)				do { } while (0)
 
-#define pmd_alloc_one(mm,address)		({ BUG(); ((pmd_t *)2); })
-#define pmd_free(mm, x)				do { } while (0)
+#define pmd_alloc_one	pmd_alloc_one_bug
 
 #define pgd_populate(mm, pgd, pud)		BUG()
 #define pgd_populate_kernel(mm, pgd, pud)	BUG()
diff -puN arch/sh/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix arch/sh/include/asm/pgalloc.h
--- a/arch/sh/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix
+++ a/arch/sh/include/asm/pgalloc.h
@@ -79,14 +79,6 @@ do {							\
 	tlb_remove_page((tlb), (pte));			\
 } while (0)
 
-/*
- * allocating and freeing a pmd is trivial: the 1-entry pmd is
- * inside the pgd, so has no extra memory associated with it.
- */
-
-#define pmd_free(mm, x)			do { } while (0)
-#define __pmd_free_tlb(tlb,x)		do { } while (0)
-
 static inline void check_pgt_cache(void)
 {
 	quicklist_trim(QUICK_PGD, NULL, 25, 16);
diff -puN arch/sparc/include/asm/pgalloc_64.h~mm-unify-some-pmd_-functions-fix arch/sparc/include/asm/pgalloc_64.h
--- a/arch/sparc/include/asm/pgalloc_64.h~mm-unify-some-pmd_-functions-fix
+++ a/arch/sparc/include/asm/pgalloc_64.h
@@ -30,11 +30,13 @@ static inline pmd_t *pmd_alloc_one(struc
 {
 	return quicklist_alloc(0, GFP_KERNEL, NULL);
 }
+#define pmd_alloc_one pmd_alloc_one
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
 	quicklist_free(0, NULL, pmd);
 }
+#define pmd_free pmd_free
 
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long address)
diff -puN arch/um/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix arch/um/include/asm/pgalloc.h
--- a/arch/um/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix
+++ a/arch/um/include/asm/pgalloc.h
@@ -52,6 +52,7 @@ static inline void pmd_free(struct mm_st
 {
 	free_page((unsigned long)pmd);
 }
+#define pmd_free pmd_free
 
 #define __pmd_free_tlb(tlb,x)   tlb_remove_page((tlb),virt_to_page(x))
 #endif
diff -puN arch/um/include/asm/pgtable-3level.h~mm-unify-some-pmd_-functions-fix arch/um/include/asm/pgtable-3level.h
--- a/arch/um/include/asm/pgtable-3level.h~mm-unify-some-pmd_-functions-fix
+++ a/arch/um/include/asm/pgtable-3level.h
@@ -80,6 +80,7 @@ static inline void pgd_mkuptodate(pgd_t 
 
 struct mm_struct;
 extern pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address);
+#define pmd_alloc_one pmd_alloc_one
 
 static inline void pud_clear (pud_t *pud)
 {
diff -puN arch/x86/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix arch/x86/include/asm/pgalloc.h
--- a/arch/x86/include/asm/pgalloc.h~mm-unify-some-pmd_-functions-fix
+++ a/arch/x86/include/asm/pgalloc.h
@@ -71,14 +71,17 @@ static inline pmd_t *pmd_alloc_one(struc
 {
 	return (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
 }
+#define pmd_alloc_one pmd_alloc_one
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
 	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
 	free_page((unsigned long)pmd);
 }
+#define pmd_free pmd_free
 
 extern void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
+#define __pmd_free_tlb __pmd_free_tlb
 
 #ifdef CONFIG_X86_PAE
 extern void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd);
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

fbmem-copy_from-to_user-with-mutex-held-v3.patch
mm-unify-some-pmd_-functions.patch
mm-unify-some-pmd_-functions-fix.patch

