From: akpm@linux-foundation.org
Subject: [merged] xtensa-use-buddy-allocator-for-pte-table.patch removed
 from -mm tree
Date: Fri, 15 Nov 2013 12:08:46 -0800
Message-ID: <52867f4e.J0K6encW2+1dSaMI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3KOUIr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jcmvbkbc@gmail.com, chris@zankel.net, kirill.shutemov@linux.intel.com

Subject: [merged] xtensa-use-buddy-allocator-for-pte-table.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,chris@zankel.net,jcmvbkbc@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:46 -0800


The patch titled
     Subject: Re: xtensa: use buddy allocator for PTE table
has been removed from the -mm tree.  Its filename was
     xtensa-use-buddy-allocator-for-pte-table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: xtensa: use buddy allocator for PTE table

At the moment xtensa uses slab allocator for PTE table.  It doesn't work
with enabled split page table lock: slab uses page->slab_cache and
page->first_page for its pages.  These fields share stroage with
page->ptl.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Chris Zankel <chris@zankel.net>
Acked-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/pgalloc.h |   20 ++++++++++++--------
 arch/xtensa/include/asm/pgtable.h |    3 +--
 arch/xtensa/mm/mmu.c              |   20 --------------------
 3 files changed, 13 insertions(+), 30 deletions(-)

diff -puN arch/xtensa/include/asm/pgalloc.h~xtensa-use-buddy-allocator-for-pte-table arch/xtensa/include/asm/pgalloc.h
--- a/arch/xtensa/include/asm/pgalloc.h~xtensa-use-buddy-allocator-for-pte-table
+++ a/arch/xtensa/include/asm/pgalloc.h
@@ -38,14 +38,18 @@ static inline void pgd_free(struct mm_st
 	free_page((unsigned long)pgd);
 }
 
-/* Use a slab cache for the pte pages (see also sparc64 implementation) */
-
-extern struct kmem_cache *pgtable_cache;
-
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					 unsigned long address)
 {
-	return kmem_cache_alloc(pgtable_cache, GFP_KERNEL|__GFP_REPEAT);
+	pte_t *ptep;
+	int i;
+
+	ptep = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT);
+	if (!ptep)
+		return NULL;
+	for (i = 0; i < 1024; i++)
+		pte_clear(NULL, 0, ptep + i);
+	return ptep;
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
@@ -59,7 +63,7 @@ static inline pgtable_t pte_alloc_one(st
 		return NULL;
 	page = virt_to_page(pte);
 	if (!pgtable_page_ctor(page)) {
-		kmem_cache_free(pgtable_cache, pte);
+		__free_page(page);
 		return NULL;
 	}
 	return page;
@@ -67,13 +71,13 @@ static inline pgtable_t pte_alloc_one(st
 
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
-	kmem_cache_free(pgtable_cache, pte);
+	free_page((unsigned long)pte);
 }
 
 static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
 {
 	pgtable_page_dtor(pte);
-	kmem_cache_free(pgtable_cache, page_address(pte));
+	__free_page(pte);
 }
 #define pmd_pgtable(pmd) pmd_page(pmd)
 
diff -puN arch/xtensa/include/asm/pgtable.h~xtensa-use-buddy-allocator-for-pte-table arch/xtensa/include/asm/pgtable.h
--- a/arch/xtensa/include/asm/pgtable.h~xtensa-use-buddy-allocator-for-pte-table
+++ a/arch/xtensa/include/asm/pgtable.h
@@ -220,12 +220,11 @@ extern unsigned long empty_zero_page[102
 #ifdef CONFIG_MMU
 extern pgd_t swapper_pg_dir[PAGE_SIZE/sizeof(pgd_t)];
 extern void paging_init(void);
-extern void pgtable_cache_init(void);
 #else
 # define swapper_pg_dir NULL
 static inline void paging_init(void) { }
-static inline void pgtable_cache_init(void) { }
 #endif
+static inline void pgtable_cache_init(void) { }
 
 /*
  * The pmd contains the kernel virtual address of the pte page.
diff -puN arch/xtensa/mm/mmu.c~xtensa-use-buddy-allocator-for-pte-table arch/xtensa/mm/mmu.c
--- a/arch/xtensa/mm/mmu.c~xtensa-use-buddy-allocator-for-pte-table
+++ a/arch/xtensa/mm/mmu.c
@@ -50,23 +50,3 @@ void __init init_mmu(void)
 	 */
 	set_ptevaddr_register(PGTABLE_START);
 }
-
-struct kmem_cache *pgtable_cache __read_mostly;
-
-static void pgd_ctor(void *addr)
-{
-	pte_t *ptep = (pte_t *)addr;
-	int i;
-
-	for (i = 0; i < 1024; i++, ptep++)
-		pte_clear(NULL, 0, ptep);
-
-}
