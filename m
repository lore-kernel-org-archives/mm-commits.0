From: akpm@linux-foundation.org
Subject: + mm-unify-some-pmd_-functions.patch added to -mm tree
Date: Tue, 27 Jan 2009 17:40:24 -0800
Message-ID: <200901280140.n0S1eOVD031805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930AbZA1BlQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 20:41:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: righi.andrea@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, takata@linux-m32r.org, zippel@linux-m68k.org


The patch titled
     mm: unify some pmd_*() functions
has been added to the -mm tree.  Its filename is
     mm-unify-some-pmd_-functions.patch

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

 arch/m68k/include/asm/motorola_pgalloc.h |    4 +-
 arch/m68k/include/asm/sun3_pgalloc.h     |   10 -----
 include/asm-frv/pgalloc.h                |    9 -----
 include/asm-generic/pgtable-nopmd.h      |   36 ++++++++++++++++++---
 include/asm-m32r/pgalloc.h               |    9 -----
 5 files changed, 37 insertions(+), 31 deletions(-)

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
@@ -18,8 +18,7 @@
 
 extern const char bad_pmd_string[];
 
-#define pmd_alloc_one(mm,address)       ({ BUG(); ((pmd_t *)2); })
-
+#define pmd_alloc_one pmd_alloc_one_bug
 
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
@@ -75,13 +74,6 @@ static inline void pmd_populate(struct m
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
@@ -4,6 +4,7 @@
 #ifndef __ASSEMBLY__
 
 #include <asm-generic/pgtable-nopud.h>
+#include <asm/bug.h>
 
 struct mm_struct;
 
@@ -54,15 +55,40 @@ static inline pmd_t * pmd_offset(pud_t *
 /*
  * allocating and freeing a pmd is trivial: the 1-entry pmd is
  * inside the pud, so has no extra memory associated with it.
+ * (In the PAE case we free the pmds as part of the pgd.)
  */
-#define pmd_alloc_one(mm, address)		NULL
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
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
 }
-#define __pmd_free_tlb(tlb, x)			do { } while (0)
-
-#undef  pmd_addr_end
-#define pmd_addr_end(addr, end)			(end)
+#define pmd_free pmd_free
+#endif
+#ifndef __pmd_free_tlb
+struct mmu_gather;
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
 
 #endif /* __ASSEMBLY__ */
 
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
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

fbmem-copy_from-to_user-with-mutex-held-v3.patch
mm-unify-some-pmd_-functions.patch

