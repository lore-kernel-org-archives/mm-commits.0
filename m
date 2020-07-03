From: akpm@linux-foundation.org
Subject: +
 xtensa-switch-to-generic-version-of-pte-allocation.patch added to -mm tree
Date: Thu, 02 Jul 2020 21:21:35 -0700
Message-ID: <20200703042135.e0eJ_kjvK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgGCEVh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 00:21:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abdhalee@linux.vnet.ibm.com, arnd@arndb.de, christophe.leroy@csgroup.eu, geert@linux-m68k.org, jcmvbkbc@gmail.com, joro@8bytes.org, jroedel@suse.de, luto@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org, peterz@infradead.org, rostedt@goodmis.org, rppt@linux.ibm.com, sathnaga@linux.vnet.ibm.com, sfr@canb.auug.org.au, shorne@gmail.com, willy@infradead.org


The patch titled
     Subject: xtensa: switch to generic version of pte allocation
has been added to the -mm tree.  Its filename is
     xtensa-switch-to-generic-version-of-pte-allocation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/xtensa-switch-to-generic-version-of-pte-allocation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/xtensa-switch-to-generic-version-of-pte-allocation.patch

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
Subject: xtensa: switch to generic version of pte allocation

xtensa clears PTEs during allocation of the page tables and pte_clear()
sets the PTE to a non-zero value.  Splitting ptes_clear() helper out of
pte_alloc_one() and pte_alloc_one_kernel() allows reuse of base generic
allocation methods (__pte_alloc_one() and __pte_alloc_one_kernel()) and
the common GFP mask for page table allocations.

The pte_free() and pte_free_kernel() implementations on xtensa are
identical to the generic ones and can be dropped.

Link: http://lkml.kernel.org/r/20200627143453.31835-4-rppt@kernel.org
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

 arch/xtensa/include/asm/pgalloc.h |   41 ++++++++++++----------------
 1 file changed, 19 insertions(+), 22 deletions(-)

--- a/arch/xtensa/include/asm/pgalloc.h~xtensa-switch-to-generic-version-of-pte-allocation
+++ a/arch/xtensa/include/asm/pgalloc.h
@@ -8,9 +8,14 @@
 #ifndef _XTENSA_PGALLOC_H
 #define _XTENSA_PGALLOC_H
 
+#ifdef CONFIG_MMU
 #include <linux/highmem.h>
 #include <linux/slab.h>
 
+#define __HAVE_ARCH_PTE_ALLOC_ONE_KERNEL
+#define __HAVE_ARCH_PTE_ALLOC_ONE
+#include <asm-generic/pgalloc.h>
+
 /*
  * Allocating and freeing a pmd is trivial: the 1-entry pmd is
  * inside the pgd, so has no extra memory associated with it.
@@ -33,45 +38,37 @@ static inline void pgd_free(struct mm_st
 	free_page((unsigned long)pgd);
 }
 
+static inline void ptes_clear(pte_t *ptep)
+{
+	int i;
+
+	for (i = 0; i < PTRS_PER_PTE; i++)
+		pte_clear(NULL, 0, ptep + i);
+}
+
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
 {
 	pte_t *ptep;
-	int i;
 
-	ptep = (pte_t *)__get_free_page(GFP_KERNEL);
+	ptep = (pte_t *)__pte_alloc_one_kernel(mm);
 	if (!ptep)
 		return NULL;
-	for (i = 0; i < 1024; i++)
-		pte_clear(NULL, 0, ptep + i);
+	ptes_clear(ptep);
 	return ptep;
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm)
 {
-	pte_t *pte;
 	struct page *page;
 
-	pte = pte_alloc_one_kernel(mm);
-	if (!pte)
-		return NULL;
-	page = virt_to_page(pte);
-	if (!pgtable_pte_page_ctor(page)) {
-		__free_page(page);
+	page = __pte_alloc_one(mm, GFP_PGTABLE_USER);
+	if (!page)
 		return NULL;
-	}
+	ptes_clear(page_address(page));
 	return page;
 }
 
-static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
-{
-	free_page((unsigned long)pte);
-}
