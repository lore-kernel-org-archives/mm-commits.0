From: akpm@linux-foundation.org
Subject: + s390-mmu_gather-rework.patch added to -mm tree
Date: Tue, 19 Apr 2011 13:10:08 -0700
Message-ID: <201104192010.p3JKA9uN020482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478Ab1DSULJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Apr 2011 16:11:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, hughd@google.com, jdike@addtoit.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lethal@linux-sh.org, mel@csn.ul.ie, namhyung@gmail.com, npiggin@kernel.dk, richard@nod.at, rmk@arm.linux.org.uk, schwidefsky@de.ibm.com, tony.luck@intel.com


The patch titled
     s390: mmu_gather rework
has been added to the -mm tree.  Its filename is
     s390-mmu_gather-rework.patch

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
Subject: s390: mmu_gather rework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Adapt the stand-alone s390 mmu_gather implementation to the new
preemptible mmu_gather interface.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Tony Luck <tony.luck@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/tlb.h |   62 ++++++++++++++++++++--------------
 1 file changed, 37 insertions(+), 25 deletions(-)

diff -puN arch/s390/include/asm/tlb.h~s390-mmu_gather-rework arch/s390/include/asm/tlb.h
--- a/arch/s390/include/asm/tlb.h~s390-mmu_gather-rework
+++ a/arch/s390/include/asm/tlb.h
@@ -29,65 +29,77 @@
 #include <asm/smp.h>
 #include <asm/tlbflush.h>
 
-#ifndef CONFIG_SMP
-#define TLB_NR_PTRS	1
-#else
-#define TLB_NR_PTRS	508
-#endif
-
 struct mmu_gather {
 	struct mm_struct *mm;
 	unsigned int fullmm;
 	unsigned int nr_ptes;
 	unsigned int nr_pxds;
-	void *array[TLB_NR_PTRS];
+	unsigned int max;
+	void **array;
+	void *local[8];
 };
 
-DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
-
-static inline struct mmu_gather *tlb_gather_mmu(struct mm_struct *mm,
-						unsigned int full_mm_flush)
+static inline void __tlb_alloc_page(struct mmu_gather *tlb)
 {
-	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
+	unsigned long addr = __get_free_pages(GFP_NOWAIT | __GFP_NOWARN, 0);
 
+	if (addr) {
+		tlb->array = (void *) addr;
+		tlb->max = PAGE_SIZE / sizeof(void *);
+	}
+}
+
+static inline void tlb_gather_mmu(struct mmu_gather *tlb,
+				  struct mm_struct *mm,
+				  unsigned int full_mm_flush)
+{
 	tlb->mm = mm;
+	tlb->max = ARRAY_SIZE(tlb->local);
+	tlb->array = tlb->local;
 	tlb->fullmm = full_mm_flush;
-	tlb->nr_ptes = 0;
-	tlb->nr_pxds = TLB_NR_PTRS;
 	if (tlb->fullmm)
 		__tlb_flush_mm(mm);
-	return tlb;
+	else
+		__tlb_alloc_page(tlb);
+	tlb->nr_ptes = 0;
+	tlb->nr_pxds = tlb->max;
 }
 
-static inline void tlb_flush_mmu(struct mmu_gather *tlb,
-				 unsigned long start, unsigned long end)
+static inline void tlb_flush_mmu(struct mmu_gather *tlb)
 {
-	if (!tlb->fullmm && (tlb->nr_ptes > 0 || tlb->nr_pxds < TLB_NR_PTRS))
+	if (!tlb->fullmm && (tlb->nr_ptes > 0 || tlb->nr_pxds < tlb->max))
 		__tlb_flush_mm(tlb->mm);
 	while (tlb->nr_ptes > 0)
 		page_table_free_rcu(tlb->mm, tlb->array[--tlb->nr_ptes]);
-	while (tlb->nr_pxds < TLB_NR_PTRS)
+	while (tlb->nr_pxds < tlb->max)
 		crst_table_free_rcu(tlb->mm, tlb->array[tlb->nr_pxds++]);
 }
 
 static inline void tlb_finish_mmu(struct mmu_gather *tlb,
 				  unsigned long start, unsigned long end)
 {
-	tlb_flush_mmu(tlb, start, end);
+	tlb_flush_mmu(tlb);
 
 	rcu_table_freelist_finish();
 
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
 
-	put_cpu_var(mmu_gathers);
+	if (tlb->array != tlb->local)
+		free_pages((unsigned long) tlb->array, 0);
 }
 
 /*
  * Release the page cache reference for a pte removed by
- * tlb_ptep_clear_flush. In both flush modes the tlb fo a page cache page
+ * tlb_ptep_clear_flush. In both flush modes the tlb for a page cache page
  * has already been freed, so just do free_page_and_swap_cache.
  */
+static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	free_page_and_swap_cache(page);
+	return 1; /* avoid calling tlb_flush_mmu */
+}
+
 static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
 	free_page_and_swap_cache(page);
@@ -103,7 +115,7 @@ static inline void pte_free_tlb(struct m
 	if (!tlb->fullmm) {
 		tlb->array[tlb->nr_ptes++] = pte;
 		if (tlb->nr_ptes >= tlb->nr_pxds)
-			tlb_flush_mmu(tlb, 0, 0);
+			tlb_flush_mmu(tlb);
 	} else
 		page_table_free(tlb->mm, (unsigned long *) pte);
 }
@@ -124,7 +136,7 @@ static inline void pmd_free_tlb(struct m
 	if (!tlb->fullmm) {
 		tlb->array[--tlb->nr_pxds] = pmd;
 		if (tlb->nr_ptes >= tlb->nr_pxds)
-			tlb_flush_mmu(tlb, 0, 0);
+			tlb_flush_mmu(tlb);
 	} else
 		crst_table_free(tlb->mm, (unsigned long *) pmd);
 #endif
@@ -146,7 +158,7 @@ static inline void pud_free_tlb(struct m
 	if (!tlb->fullmm) {
 		tlb->array[--tlb->nr_pxds] = pud;
 		if (tlb->nr_ptes >= tlb->nr_pxds)
-			tlb_flush_mmu(tlb, 0, 0);
+			tlb_flush_mmu(tlb);
 	} else
 		crst_table_free(tlb->mm, (unsigned long *) pud);
 #endif
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

linux-next.patch
net-convert-%p-usage-to-%pk.patch
mm-mmu_gather-rework.patch
mm-mmu_gather-rework-fix.patch
powerpc-mmu_gather-rework.patch
sparc-mmu_gather-rework.patch
s390-mmu_gather-rework.patch
arm-mmu_gather-rework.patch
sh-mmu_gather-rework.patch
ia64-mmu_gather-rework.patch
um-mmu_gather-rework.patch
mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage.patch
mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code.patch
mm-extended-batches-for-generic-mmu_gather.patch
lockdep-mutex-provide-mutex_lock_nest_lock.patch
mm-remove-i_mmap_lock-lockbreak.patch
mm-convert-i_mmap_lock-to-a-mutex.patch
mm-revert-page_lock_anon_vma-lock-annotation.patch
mm-improve-page_lock_anon_vma-comment.patch
mm-use-refcounts-for-page_lock_anon_vma.patch
mm-convert-anon_vma-lock-to-a-mutex.patch
mm-optimize-page_lock_anon_vma-fast-path.patch

