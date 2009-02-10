From: akpm@linux-foundation.org
Subject: [withdrawn] mm-unify-some-pmd_-functions.patch removed from -mm tree
Date: Tue, 10 Feb 2009 13:26:59 -0800
Message-ID: <200902102126.n1ALQxvI010245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755413AbZBJV2L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 16:28:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: righi.andrea@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, takata@linux-m32r.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     mm: unify some pmd_*() functions
has been removed from the -mm tree.  Its filename was
     mm-unify-some-pmd_-functions.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: unify some pmd_*() functions
From: Andrea Righi <righi.andrea@gmail.com>

Unify all the identical implementations of pmd_free(), __pmd_free_tlb(),
pmd_alloc_one(), pmd_addr_end() in include/asm-generic/pgtable-nopmd.h

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/pgalloc.h              |    2 
 arch/arm/include/asm/pgalloc.h                |    3 -
 arch/ia64/include/asm/pgalloc.h               |    2 
 arch/m68k/include/asm/motorola_pgalloc.h      |    4 +
 arch/m68k/include/asm/sun3_pgalloc.h          |   11 ---
 arch/mips/include/asm/pgalloc.h               |   13 ----
 arch/parisc/include/asm/pgalloc.h             |    5 +
 arch/powerpc/include/asm/pgalloc-32.h         |    9 ---
 arch/powerpc/include/asm/pgalloc-64.h         |    2 
 arch/sh/include/asm/pgalloc.h                 |    8 --
 arch/sparc/include/asm/pgalloc_64.h           |    2 
 arch/um/include/asm/pgalloc.h                 |    1 
 arch/um/include/asm/pgtable-3level.h          |    1 
 arch/x86/include/asm/pgalloc.h                |    3 +
 include/asm-frv/pgalloc.h                     |    9 ---
 include/asm-generic/pgtable-nopmd-functions.h |   48 ++++++++++++++++
 include/asm-generic/pgtable-nopmd.h           |   17 -----
 include/asm-m32r/pgalloc.h                    |    9 ---
 18 files changed, 76 insertions(+), 73 deletions(-)

diff -puN arch/m68k/include/asm/motorola_pgalloc.h~mm-unify-some-pmd_-functions arch/m68k/include/asm/motorola_pgalloc.h
--- a/arch/m68k/include/asm/motorola_pgalloc.h~mm-unify-some-pmd_-functions
+++ a/arch/m68k/include/asm/motorola_pgalloc.h
@@ -67,17 +67,19 @@ static inline pmd_t *pmd_alloc_one(struc
 {
 	return get_pointer_table();
 }
+#define pmd_alloc_one pmd_alloc_one
 
 static inline int pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
 	return free_pointer_table(pmd);
 }
+#define pmd_free pmd_free
 
 static inline int __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 {
 	return free_pointer_table(pmd);
 }
-
+#define __pmd_free_tlb __pmd_free_tlb
 
 static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
diff -puN arch/m68k/include/asm/sun3_pgalloc.h~mm-unify-some-pmd_-functions arch/m68k/include/asm/sun3_pgalloc.h
--- a/arch/m68k/include/asm/sun3_pgalloc.h~mm-unify-some-pmd_-functions
+++ a/arch/m68k/include/asm/sun3_pgalloc.h
@@ -10,6 +10,7 @@
 #ifndef _SUN3_PGALLOC_H
 #define _SUN3_PGALLOC_H
 
+#include <asm-generic/pgtable-nopmd-functions.h>
 #include <asm/tlb.h>
 
 /* FIXME - when we get this compiling */
@@ -18,8 +19,7 @@
 
 extern const char bad_pmd_string[];
 
-#define pmd_alloc_one(mm,address)       ({ BUG(); ((pmd_t *)2); })
-
+#define pmd_alloc_one pmd_alloc_one_bug
 
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
@@ -75,13 +75,6 @@ static inline void pmd_populate(struct m
 }
 #define pmd_pgtable(pmd) pmd_page(pmd)
 
-/*
- * allocating and freeing a pmd is trivial: the 1-entry pmd is
- * inside the pgd, so has no extra memory associated with it.
- */
-#define pmd_free(mm, x)			do { } while (0)
-#define __pmd_free_tlb(tlb, x)		do { } while (0)
-
 static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
         free_page((unsigned long) pgd);
diff -puN include/asm-frv/pgalloc.h~mm-unify-some-pmd_-functions include/asm-frv/pgalloc.h
--- a/include/asm-frv/pgalloc.h~mm-unify-some-pmd_-functions
+++ a/include/asm-frv/pgalloc.h
@@ -55,14 +55,7 @@ do {							\
 	tlb_remove_page((tlb),(pte));			\
 } while (0)
 
-/*
- * allocating and freeing a pmd is trivial: the 1-entry pmd is
- * inside the pgd, so has no extra memory associated with it.
- * (In the PAE case we free the pmds as part of the pgd.)
- */
-#define pmd_alloc_one(mm, addr)		({ BUG(); ((pmd_t *) 2); })
-#define pmd_free(mm, x)			do { } while (0)
-#define __pmd_free_tlb(tlb,x)		do { } while (0)
+#define pmd_alloc_one pmd_alloc_one_bug
 
 #endif /* CONFIG_MMU */
 
diff -puN include/asm-generic/pgtable-nopmd.h~mm-unify-some-pmd_-functions include/asm-generic/pgtable-nopmd.h
--- a/include/asm-generic/pgtable-nopmd.h~mm-unify-some-pmd_-functions
+++ a/include/asm-generic/pgtable-nopmd.h
@@ -4,8 +4,8 @@
 #ifndef __ASSEMBLY__
 
 #include <asm-generic/pgtable-nopud.h>
-
-struct mm_struct;
+#include <asm-generic/pgtable-nopmd-functions.h>
+#include <asm/bug.h>
 
 #define __PAGETABLE_PMD_FOLDED
 
@@ -51,19 +51,6 @@ static inline pmd_t * pmd_offset(pud_t *
 #define pud_page(pud)				(pmd_page((pmd_t){ pud }))
 #define pud_page_vaddr(pud)			(pmd_page_vaddr((pmd_t){ pud }))
 
-/*
- * allocating and freeing a pmd is trivial: the 1-entry pmd is
- * inside the pud, so has no extra memory associated with it.
- */
-#define pmd_alloc_one(mm, address)		NULL
-static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
-{
-}
-#define __pmd_free_tlb(tlb, x)			do { } while (0)
-
-#undef  pmd_addr_end
-#define pmd_addr_end(addr, end)			(end)
-
 #endif /* __ASSEMBLY__ */
 
 #endif /* _PGTABLE_NOPMD_H */
diff -puN include/asm-m32r/pgalloc.h~mm-unify-some-pmd_-functions include/asm-m32r/pgalloc.h
--- a/include/asm-m32r/pgalloc.h~mm-unify-some-pmd_-functions
+++ a/include/asm-m32r/pgalloc.h
@@ -60,15 +60,8 @@ static inline void pte_free(struct mm_st
 
 #define __pte_free_tlb(tlb, pte)	pte_free((tlb)->mm, (pte))
 
-/*
- * allocating and freeing a pmd is trivial: the 1-entry pmd is
- * inside the pgd, so has no extra memory associated with it.
- * (In the PAE case we free the pmds as part of the pgd.)
- */
+#define pmd_alloc_one pmd_alloc_one_bug
 
-#define pmd_alloc_one(mm, addr)		({ BUG(); ((pmd_t *)2); })
-#define pmd_free(mm, x)			do { } while (0)
-#define __pmd_free_tlb(tlb, x)		do { } while (0)
 #define pgd_populate(mm, pmd, pte)	BUG()
 
 #define check_pgt_cache()	do { } while (0)
diff -puN arch/alpha/include/asm/pgalloc.h~mm-unify-some-pmd_-functions arch/alpha/include/asm/pgalloc.h
--- a/arch/alpha/include/asm/pgalloc.h~mm-unify-some-pmd_-functions
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
diff -puN arch/arm/include/asm/pgalloc.h~mm-unify-some-pmd_-functions arch/arm/include/asm/pgalloc.h
--- a/arch/arm/include/asm/pgalloc.h~mm-unify-some-pmd_-functions
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
diff -puN arch/ia64/include/asm/pgalloc.h~mm-unify-some-pmd_-functions arch/ia64/include/asm/pgalloc.h
--- a/arch/ia64/include/asm/pgalloc.h~mm-unify-some-pmd_-functions
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
 
diff -puN arch/mips/include/asm/pgalloc.h~mm-unify-some-pmd_-functions arch/mips/include/asm/pgalloc.h
--- a/arch/mips/include/asm/pgalloc.h~mm-unify-some-pmd_-functions
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
 
diff -puN arch/parisc/include/asm/pgalloc.h~mm-unify-some-pmd_-functions arch/parisc/include/asm/pgalloc.h
--- a/arch/parisc/include/asm/pgalloc.h~mm-unify-some-pmd_-functions
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
diff -puN arch/powerpc/include/asm/pgalloc-32.h~mm-unify-some-pmd_-functions arch/powerpc/include/asm/pgalloc-32.h
--- a/arch/powerpc/include/asm/pgalloc-32.h~mm-unify-some-pmd_-functions
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
diff -puN arch/powerpc/include/asm/pgalloc-64.h~mm-unify-some-pmd_-functions arch/powerpc/include/asm/pgalloc-64.h
--- a/arch/powerpc/include/asm/pgalloc-64.h~mm-unify-some-pmd_-functions
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
diff -puN arch/s390/include/asm/pgalloc.h~mm-unify-some-pmd_-functions arch/s390/include/asm/pgalloc.h
diff -puN arch/sh/include/asm/pgalloc.h~mm-unify-some-pmd_-functions arch/sh/include/asm/pgalloc.h
--- a/arch/sh/include/asm/pgalloc.h~mm-unify-some-pmd_-functions
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
diff -puN arch/sparc/include/asm/pgalloc_64.h~mm-unify-some-pmd_-functions arch/sparc/include/asm/pgalloc_64.h
--- a/arch/sparc/include/asm/pgalloc_64.h~mm-unify-some-pmd_-functions
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
diff -puN arch/um/include/asm/pgalloc.h~mm-unify-some-pmd_-functions arch/um/include/asm/pgalloc.h
--- a/arch/um/include/asm/pgalloc.h~mm-unify-some-pmd_-functions
+++ a/arch/um/include/asm/pgalloc.h
@@ -52,6 +52,7 @@ static inline void pmd_free(struct mm_st
 {
 	free_page((unsigned long)pmd);
 }
+#define pmd_free pmd_free
 
 #define __pmd_free_tlb(tlb,x)   tlb_remove_page((tlb),virt_to_page(x))
 #endif
diff -puN arch/um/include/asm/pgtable-3level.h~mm-unify-some-pmd_-functions arch/um/include/asm/pgtable-3level.h
--- a/arch/um/include/asm/pgtable-3level.h~mm-unify-some-pmd_-functions
+++ a/arch/um/include/asm/pgtable-3level.h
@@ -80,6 +80,7 @@ static inline void pgd_mkuptodate(pgd_t 
 
 struct mm_struct;
 extern pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address);
+#define pmd_alloc_one pmd_alloc_one
 
 static inline void pud_clear (pud_t *pud)
 {
diff -puN arch/x86/include/asm/pgalloc.h~mm-unify-some-pmd_-functions arch/x86/include/asm/pgalloc.h
--- a/arch/x86/include/asm/pgalloc.h~mm-unify-some-pmd_-functions
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
diff -puN /dev/null include/asm-generic/pgtable-nopmd-functions.h
--- /dev/null
+++ a/include/asm-generic/pgtable-nopmd-functions.h
@@ -0,0 +1,48 @@
+#ifndef _PGTABLE_NOPMD_FUNCTIONS_H
+#define _PGTABLE_NOPMD_FUNCTIONS_H
+
+#ifndef __ASSEMBLY__
+
+struct mm_struct;
+struct mmu_gather;
+
+/*
+ * allocating and freeing a pmd is trivial: the 1-entry pmd is
+ * inside the pud, so has no extra memory associated with it.
+ * (In the PAE case we free the pmds as part of the pgd.)
+ */
+#ifndef pmd_alloc_one
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
+{
+	return NULL;
+}
+#define pmd_alloc_one pmd_alloc_one
+#endif
+static inline pmd_t *pmd_alloc_one_bug(struct mm_struct *mm, unsigned long addr)
+{
+	BUG();
+	return (pmd_t *)(2);
+}
+#ifndef pmd_free
+static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
+{
+}
+#define pmd_free pmd_free
+#endif
+#ifndef __pmd_free_tlb
+static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
+{
+}
+#define __pmd_free_tlb __pmd_free_tlb
+#endif
+#ifndef pmd_addr_end
+static inline unsigned long pmd_addr_end(unsigned long addr, unsigned long end)
+{
+	return end;
+}
+#define pmd_addr_end pmd_addr_end
+#endif
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _PGTABLE_NOPMD_H */
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

mm-unify-some-pmd_-functions.patch
fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency.patch
fbdev-uninline-lock_fb_info.patch

