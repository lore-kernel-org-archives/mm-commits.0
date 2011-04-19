From: akpm@linux-foundation.org
Subject: + arm-mmu_gather-rework.patch added to -mm tree
Date: Tue, 19 Apr 2011 13:10:11 -0700
Message-ID: <201104192010.p3JKAB7r020485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931Ab1DSUL1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Apr 2011 16:11:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, hughd@google.com, jdike@addtoit.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lethal@linux-sh.org, mel@csn.ul.ie, namhyung@gmail.com, npiggin@kernel.dk, richard@nod.at, rmk@arm.linux.org.uk, schwidefsky@de.ibm.com, tony.luck@intel.com


The patch titled
     arm: mmu_gather rework
has been added to the -mm tree.  Its filename is
     arm-mmu_gather-rework.patch

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
Subject: arm: mmu_gather rework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Fix up the arm mmu_gather code to conform to the new API.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
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

 arch/arm/include/asm/tlb.h |   53 ++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 16 deletions(-)

diff -puN arch/arm/include/asm/tlb.h~arm-mmu_gather-rework arch/arm/include/asm/tlb.h
--- a/arch/arm/include/asm/tlb.h~arm-mmu_gather-rework
+++ a/arch/arm/include/asm/tlb.h
@@ -41,12 +41,12 @@
  */
 #if defined(CONFIG_SMP) || defined(CONFIG_CPU_32v7)
 #define tlb_fast_mode(tlb)	0
-#define FREE_PTE_NR		500
 #else
 #define tlb_fast_mode(tlb)	1
-#define FREE_PTE_NR		0
 #endif
 
+#define MMU_GATHER_BUNDLE	8
+
 /*
  * TLB handling.  This allows us to remove pages from the page
  * tables, and efficiently handle the TLB issues.
@@ -58,7 +58,9 @@ struct mmu_gather {
 	unsigned long		range_start;
 	unsigned long		range_end;
 	unsigned int		nr;
-	struct page		*pages[FREE_PTE_NR];
+	unsigned int		max;
+	struct page		**pages;
+	struct page		*local[MMU_GATHER_BUNDLE];
 };
 
 DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
@@ -97,26 +99,37 @@ static inline void tlb_add_flush(struct 
 	}
 }
 
+static inline void __tlb_alloc_page(struct mmu_gather *tlb)
+{
+	unsigned long addr = __get_free_pages(GFP_NOWAIT | __GFP_NOWARN, 0);
+
+	if (addr) {
+		tlb->pages = (void *)addr;
+		tlb->max = PAGE_SIZE / sizeof(struct page *);
+	}
+}
+
 static inline void tlb_flush_mmu(struct mmu_gather *tlb)
 {
 	tlb_flush(tlb);
 	if (!tlb_fast_mode(tlb)) {
 		free_pages_and_swap_cache(tlb->pages, tlb->nr);
 		tlb->nr = 0;
+		if (tlb->pages == tlb->local)
+			__tlb_alloc_page(tlb);
 	}
 }
 
-static inline struct mmu_gather *
-tlb_gather_mmu(struct mm_struct *mm, unsigned int full_mm_flush)
+static inline void
+tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int fullmm)
 {
-	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
-
 	tlb->mm = mm;
-	tlb->fullmm = full_mm_flush;
+	tlb->fullmm = fullmm;
 	tlb->vma = NULL;
+	tlb->max = ARRAY_SIZE(tlb->local);
+	tlb->pages = tlb->local;
 	tlb->nr = 0;
-
-	return tlb;
+	__tlb_alloc_page(tlb);
 }
 
 static inline void
@@ -127,7 +140,8 @@ tlb_finish_mmu(struct mmu_gather *tlb, u
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
 
-	put_cpu_var(mmu_gathers);
+	if (tlb->pages != tlb->local)
+		free_pages((unsigned long)tlb->pages, 0);
 }
 
 /*
@@ -162,15 +176,22 @@ tlb_end_vma(struct mmu_gather *tlb, stru
 		tlb_flush(tlb);
 }
 
-static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
 	if (tlb_fast_mode(tlb)) {
 		free_page_and_swap_cache(page);
-	} else {
-		tlb->pages[tlb->nr++] = page;
-		if (tlb->nr >= FREE_PTE_NR)
-			tlb_flush_mmu(tlb);
+		return 1; /* avoid calling tlb_flush_mmu */
 	}
+
+	tlb->pages[tlb->nr++] = page;
+	VM_BUG_ON(tlb->nr > tlb->max);
+	return tlb->max - tlb->nr;
+}
+
+static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	if (!__tlb_remove_page(tlb, page))
+		tlb_flush_mmu(tlb);
 }
 
 static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
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

