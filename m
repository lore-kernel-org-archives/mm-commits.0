From: akpm@linux-foundation.org
Subject: + mm-unify-some-pmd_-functions-and-move-them-in-a-distinct-include.patch added to -mm tree
Date: Mon, 02 Feb 2009 15:45:13 -0800
Message-ID: <200902022345.n12NjDrj023203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129AbZBBXp7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 18:45:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: righi.andrea@gmail.com, geert@linux-m68k.org


The patch titled
     mm: unify some pmd_*() functions and move them in a distinct include
has been added to the -mm tree.  Its filename is
     mm-unify-some-pmd_-functions-and-move-them-in-a-distinct-include.patch

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
Subject: mm: unify some pmd_*() functions and move them in a distinct include
From: Andrea Righi <righi.andrea@gmail.com>

Use a distinct include file for unified pmd_* functions to resolve
potential include hell conditions.

Also fix a build error on m68k/sun3 architecture.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/sun3_pgalloc.h          |    2 
 include/asm-generic/pgtable-nopmd-functions.h |   48 ++++++++++++++++
 include/asm-generic/pgtable-nopmd.h           |   41 -------------
 3 files changed, 50 insertions(+), 41 deletions(-)

diff -puN arch/m68k/include/asm/sun3_pgalloc.h~mm-unify-some-pmd_-functions-and-move-them-in-a-distinct-include arch/m68k/include/asm/sun3_pgalloc.h
--- a/arch/m68k/include/asm/sun3_pgalloc.h~mm-unify-some-pmd_-functions-and-move-them-in-a-distinct-include
+++ a/arch/m68k/include/asm/sun3_pgalloc.h
@@ -10,8 +10,8 @@
 #ifndef _SUN3_PGALLOC_H
 #define _SUN3_PGALLOC_H
 
+#include <asm-generic/pgtable-nopmd-functions.h>
 #include <asm/tlb.h>
-#include <asm-generic/pgtable-nopmd.h>
 
 /* FIXME - when we get this compiling */
 /* erm, now that it's compiling, what do we do with it? */
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
diff -puN include/asm-generic/pgtable-nopmd.h~mm-unify-some-pmd_-functions-and-move-them-in-a-distinct-include include/asm-generic/pgtable-nopmd.h
--- a/include/asm-generic/pgtable-nopmd.h~mm-unify-some-pmd_-functions-and-move-them-in-a-distinct-include
+++ a/include/asm-generic/pgtable-nopmd.h
@@ -4,10 +4,9 @@
 #ifndef __ASSEMBLY__
 
 #include <asm-generic/pgtable-nopud.h>
+#include <asm-generic/pgtable-nopmd-functions.h>
 #include <asm/bug.h>
 
-struct mm_struct;
-
 #define __PAGETABLE_PMD_FOLDED
 
 /*
@@ -52,44 +51,6 @@ static inline pmd_t * pmd_offset(pud_t *
 #define pud_page(pud)				(pmd_page((pmd_t){ pud }))
 #define pud_page_vaddr(pud)			(pmd_page_vaddr((pmd_t){ pud }))
 
-/*
- * allocating and freeing a pmd is trivial: the 1-entry pmd is
- * inside the pud, so has no extra memory associated with it.
- * (In the PAE case we free the pmds as part of the pgd.)
- */
-#ifndef pmd_alloc_one
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	return NULL;
-}
-#define pmd_alloc_one pmd_alloc_one
-#endif
-static inline pmd_t *pmd_alloc_one_bug(struct mm_struct *mm, unsigned long addr)
-{
-	BUG();
-	return (pmd_t *)(2);
-}
-#ifndef pmd_free
-static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
-{
-}
-#define pmd_free pmd_free
-#endif
-#ifndef __pmd_free_tlb
-struct mmu_gather;
-static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
-{
-}
-#define __pmd_free_tlb __pmd_free_tlb
-#endif
-#ifndef pmd_addr_end
-static inline unsigned long pmd_addr_end(unsigned long addr, unsigned long end)
-{
-	return end;
-}
-#define pmd_addr_end pmd_addr_end
-#endif
