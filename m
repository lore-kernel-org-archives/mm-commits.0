From: akpm@linux-foundation.org
Subject: +
 opeinrisc-switch-to-generic-version-of-pte-allocation.patch added to -mm
 tree
Date: Thu, 02 Jul 2020 21:21:32 -0700
Message-ID: <20200703042132.oL1MaTBcr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgGCEVe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 00:21:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abdhalee@linux.vnet.ibm.com, arnd@arndb.de, christophe.leroy@csgroup.eu, geert@linux-m68k.org, jcmvbkbc@gmail.com, joro@8bytes.org, jroedel@suse.de, luto@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org, peterz@infradead.org, rostedt@goodmis.org, rppt@linux.ibm.com, sathnaga@linux.vnet.ibm.com, sfr@canb.auug.org.au, shorne@gmail.com, willy@infradead.org


The patch titled
     Subject: opeinrisc: switch to generic version of pte allocation
has been added to the -mm tree.  Its filename is
     opeinrisc-switch-to-generic-version-of-pte-allocation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/opeinrisc-switch-to-generic-version-of-pte-allocation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/opeinrisc-switch-to-generic-version-of-pte-allocation.patch

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
Subject: opeinrisc: switch to generic version of pte allocation

Replace pte_alloc_one(), pte_free() and pte_free_kernel() with the generic
implementation.  The only actual functional change is the addition of
__GFP_ACCOUT for the allocation of the user page tables.

The pte_alloc_one_kernel() is kept back because its implementation on
openrisc is different than the generic one.

Link: http://lkml.kernel.org/r/20200627143453.31835-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Stafford Horne <shorne@gmail.com>
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
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/include/asm/pgalloc.h |   33 ++------------------------
 1 file changed, 3 insertions(+), 30 deletions(-)

--- a/arch/openrisc/include/asm/pgalloc.h~opeinrisc-switch-to-generic-version-of-pte-allocation
+++ a/arch/openrisc/include/asm/pgalloc.h
@@ -20,6 +20,9 @@
 #include <linux/mm.h>
 #include <linux/memblock.h>
 
+#define __HAVE_ARCH_PTE_ALLOC_ONE_KERNEL
+#include <asm-generic/pgalloc.h>
+
 extern int mem_init_done;
 
 #define pmd_populate_kernel(mm, pmd, pte) \
@@ -61,38 +64,8 @@ extern inline pgd_t *pgd_alloc(struct mm
 }
 #endif
 
-static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
-{
-	free_page((unsigned long)pgd);
-}
-
 extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm);
 
-static inline struct page *pte_alloc_one(struct mm_struct *mm)
-{
-	struct page *pte;
-	pte = alloc_pages(GFP_KERNEL, 0);
-	if (!pte)
-		return NULL;
-	clear_page(page_address(pte));
-	if (!pgtable_pte_page_ctor(pte)) {
-		__free_page(pte);
-		return NULL;
-	}
-	return pte;
-}
-
-static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
-{
-	free_page((unsigned long)pte);
-}
-
-static inline void pte_free(struct mm_struct *mm, struct page *pte)
-{
-	pgtable_pte_page_dtor(pte);
-	__free_page(pte);
-}
