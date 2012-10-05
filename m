From: akpm@linux-foundation.org
Subject: + sparc64-eliminate-pte-table-memory-wastage.patch added to -mm tree
Date: Fri, 05 Oct 2012 15:00:54 -0700
Message-ID: <20121005220054.992E4100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:52758 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964797Ab2JEWAz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 18:00:55 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so249614vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 15:00:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, aarcange@redhat.com, gerald.schaefer@de.ibm.com, hannes@cmpxchg.org


The patch titled
     Subject: sparc64: Eliminate PTE table memory wastage.
has been added to the -mm tree.  Its filename is
     sparc64-eliminate-pte-table-memory-wastage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Miller <davem@davemloft.net>
Subject: sparc64: Eliminate PTE table memory wastage.

We've split up the PTE tables so that they take up half a page instead of
a full page.  This is in order to facilitate transparent huge page
support, which works much better if our PMDs cover 4MB instead of 8MB.

What we do is have a one-behind cache for PTE table allocations in the
mm struct.

This logic triggers only on allocations.  For example, we don't try to
keep track of free'd up page table blocks in the style that the s390 port
does.

There were only two slightly annoying aspects to this change:

1) Changing pgtable_t to be a "pte_t *".  There's all of this special
   logic in the TLB free paths that needed adjustments, as did the
   PMD populate interfaces.

2) init_new_context() needs to zap the pointer, since the mm struct
   just gets copied from the parent on fork.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/mmu_64.h     |    1 
 arch/sparc/include/asm/page_64.h    |    2 
 arch/sparc/include/asm/pgalloc_64.h |   54 ++-----------
 arch/sparc/mm/init_64.c             |  101 ++++++++++++++++++++++++++
 arch/sparc/mm/tsb.c                 |    9 ++
 5 files changed, 123 insertions(+), 44 deletions(-)

diff -puN arch/sparc/include/asm/mmu_64.h~sparc64-eliminate-pte-table-memory-wastage arch/sparc/include/asm/mmu_64.h
--- a/arch/sparc/include/asm/mmu_64.h~sparc64-eliminate-pte-table-memory-wastage
+++ a/arch/sparc/include/asm/mmu_64.h
@@ -93,6 +93,7 @@ typedef struct {
 	spinlock_t		lock;
 	unsigned long		sparc64_ctx_val;
 	unsigned long		huge_pte_count;
+	struct page		*pgtable_page;
 	struct tsb_config	tsb_block[MM_NUM_TSBS];
 	struct hv_tsb_descr	tsb_descr[MM_NUM_TSBS];
 } mm_context_t;
diff -puN arch/sparc/include/asm/page_64.h~sparc64-eliminate-pte-table-memory-wastage arch/sparc/include/asm/page_64.h
--- a/arch/sparc/include/asm/page_64.h~sparc64-eliminate-pte-table-memory-wastage
+++ a/arch/sparc/include/asm/page_64.h
@@ -86,7 +86,7 @@ typedef unsigned long pgprot_t;
 
 #endif /* (STRICT_MM_TYPECHECKS) */
 
-typedef struct page *pgtable_t;
+typedef pte_t *pgtable_t;
 
 #define TASK_UNMAPPED_BASE	(test_thread_flag(TIF_32BIT) ? \
 				 (_AC(0x0000000070000000,UL)) : \
diff -puN arch/sparc/include/asm/pgalloc_64.h~sparc64-eliminate-pte-table-memory-wastage arch/sparc/include/asm/pgalloc_64.h
--- a/arch/sparc/include/asm/pgalloc_64.h~sparc64-eliminate-pte-table-memory-wastage
+++ a/arch/sparc/include/asm/pgalloc_64.h
@@ -38,51 +38,20 @@ static inline void pmd_free(struct mm_st
 	kmem_cache_free(pgtable_cache, pmd);
 }
 
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
-					  unsigned long address)
-{
-	return (pte_t *)__get_free_page(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO);
-}
-
-static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
-					unsigned long address)
-{
-	struct page *page;
-	pte_t *pte;
-
-	pte = pte_alloc_one_kernel(mm, address);
-	if (!pte)
-		return NULL;
-	page = virt_to_page(pte);
-	pgtable_page_ctor(page);
-	return page;
-}
-
-static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
-{
-	free_page((unsigned long)pte);
-}
-
-static inline void pte_free(struct mm_struct *mm, pgtable_t ptepage)
-{
-	pgtable_page_dtor(ptepage);
-	__free_page(ptepage);
-}
+extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
+				   unsigned long address);
+extern pgtable_t pte_alloc_one(struct mm_struct *mm,
+			       unsigned long address);
+extern void pte_free_kernel(struct mm_struct *mm, pte_t *pte);
+extern void pte_free(struct mm_struct *mm, pgtable_t ptepage);
 
 #define pmd_populate_kernel(MM, PMD, PTE)	pmd_set(PMD, PTE)
-#define pmd_populate(MM,PMD,PTE_PAGE)		\
-	pmd_populate_kernel(MM,PMD,page_address(PTE_PAGE))
-#define pmd_pgtable(pmd) pmd_page(pmd)
+#define pmd_populate(MM, PMD, PTE)		pmd_set(PMD, PTE)
+#define pmd_pgtable(PMD)			((pte_t *)__pmd_page(PMD))
 
 #define check_pgt_cache()	do { } while (0)
 
-static inline void pgtable_free(void *table, bool is_page)
-{
-	if (is_page)
-		free_page((unsigned long)table);
-	else
-		kmem_cache_free(pgtable_cache, table);
-}
+extern void pgtable_free(void *table, bool is_page);
 
 #ifdef CONFIG_SMP
 
@@ -113,11 +82,10 @@ static inline void pgtable_free_tlb(stru
 }
 #endif /* !CONFIG_SMP */
 
-static inline void __pte_free_tlb(struct mmu_gather *tlb, struct page *ptepage,
+static inline void __pte_free_tlb(struct mmu_gather *tlb, pte_t *pte,
 				  unsigned long address)
 {
-	pgtable_page_dtor(ptepage);
-	pgtable_free_tlb(tlb, page_address(ptepage), true);
+	pgtable_free_tlb(tlb, pte, true);
 }
 
 #define __pmd_free_tlb(tlb, pmd, addr)		      \
diff -puN arch/sparc/mm/init_64.c~sparc64-eliminate-pte-table-memory-wastage arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~sparc64-eliminate-pte-table-memory-wastage
+++ a/arch/sparc/mm/init_64.c
@@ -2467,3 +2467,104 @@ void __flush_tlb_all(void)
 	__asm__ __volatile__("wrpr	%0, 0, %%pstate"
 			     : : "r" (pstate));
 }
+
+static pte_t *get_from_cache(struct mm_struct *mm)
+{
+	struct page *page;
+	pte_t *ret;
+
+	spin_lock(&mm->page_table_lock);
+	page = mm->context.pgtable_page;
+	ret = NULL;
+	if (page) {
+		void *p = page_address(page);
+
+		mm->context.pgtable_page = NULL;
+
+		ret = (pte_t *) (p + (PAGE_SIZE / 2));
+	}
+	spin_unlock(&mm->page_table_lock);
+
+	return ret;
+}
+
+static struct page *__alloc_for_cache(struct mm_struct *mm)
+{
+	struct page *page = alloc_page(GFP_KERNEL | __GFP_NOTRACK |
+				       __GFP_REPEAT | __GFP_ZERO);
+
+	if (page) {
+		spin_lock(&mm->page_table_lock);
+		if (!mm->context.pgtable_page) {
+			atomic_set(&page->_count, 2);
+			mm->context.pgtable_page = page;
+		}
+		spin_unlock(&mm->page_table_lock);
+	}
+	return page;
+}
+
+pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
+			    unsigned long address)
+{
+	struct page *page;
+	pte_t *pte;
+
+	pte = get_from_cache(mm);
+	if (pte)
+		return pte;
+
+	page = __alloc_for_cache(mm);
+	if (page)
+		pte = (pte_t *) page_address(page);
+
+	return pte;
+}
+
+pgtable_t pte_alloc_one(struct mm_struct *mm,
+			unsigned long address)
+{
+	struct page *page;
+	pte_t *pte;
+
+	pte = get_from_cache(mm);
+	if (pte)
+		return pte;
+
+	page = __alloc_for_cache(mm);
+	if (page) {
+		pgtable_page_ctor(page);
+		pte = (pte_t *) page_address(page);
+	}
+
+	return pte;
+}
+
+void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+{
+	struct page *page = virt_to_page(pte);
+	if (put_page_testzero(page))
+		free_hot_cold_page(page, 0);
+}
+
+static void __pte_free(pgtable_t pte)
+{
+	struct page *page = virt_to_page(pte);
+	if (put_page_testzero(page)) {
+		pgtable_page_dtor(page);
+		free_hot_cold_page(page, 0);
+	}
+}
+
+void pte_free(struct mm_struct *mm, pgtable_t pte)
+{
+	__pte_free(pte);
+}
+
+void pgtable_free(void *table, bool is_page)
+{
+	if (is_page)
+		__pte_free(table);
+	else
+		kmem_cache_free(pgtable_cache, table);
+}
diff -puN arch/sparc/mm/tsb.c~sparc64-eliminate-pte-table-memory-wastage arch/sparc/mm/tsb.c
--- a/arch/sparc/mm/tsb.c~sparc64-eliminate-pte-table-memory-wastage
+++ a/arch/sparc/mm/tsb.c
@@ -445,6 +445,8 @@ int init_new_context(struct task_struct 
 	mm->context.huge_pte_count = 0;
 #endif
 
+	mm->context.pgtable_page = NULL;
+
 	/* copy_mm() copies over the parent's mm_struct before calling
 	 * us, so we need to zero out the TSB pointer or else tsb_grow()
 	 * will be confused and think there is an older TSB to free up.
@@ -483,10 +485,17 @@ static void tsb_destroy_one(struct tsb_c
 void destroy_context(struct mm_struct *mm)
 {
 	unsigned long flags, i;
+	struct page *page;
 
 	for (i = 0; i < MM_NUM_TSBS; i++)
 		tsb_destroy_one(&mm->context.tsb_block[i]);
 
+	page = mm->context.pgtable_page;
+	if (page && put_page_testzero(page)) {
+		pgtable_page_dtor(page);
+		free_hot_cold_page(page, 0);
+	}
+
 	spin_lock_irqsave(&ctx_alloc_lock, flags);
 
 	if (CTX_VALID(mm->context)) {
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
linux-next.patch
kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option.patch
kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option.patch
kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option.patch
kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry.patch
atomic-implement-generic-atomic_dec_if_positive.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
sparc64-only-support-4mb-huge-pages-and-8kb-base-pages.patch
sparc64-halve-the-size-of-pte-tables.patch
sparc64-eliminate-pte-table-memory-wastage.patch
sparc64-document-pgd-and-pmd-layout.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch
mm-thp-use-more-portable-pmd-clearing-sequenece-in-zap_huge_pmd.patch
sparc64-support-transparent-huge-pages.patch
compat-generic-compat_sys_sched_rr_get_interval-implementation.patch

