From: akpm@linux-foundation.org
Subject: [merged] ia64-mmu_gather-rework.patch removed from -mm tree
Date: Wed, 25 May 2011 13:28:23 -0700
Message-ID: <201105252026.p4PKQl0h014517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114Ab1EYU2Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:28:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, hughd@google.com, jdike@addtoit.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lethal@linu


The patch titled
     ia64: mmu_gather rework
has been removed from the -mm tree.  Its filename was
     ia64-mmu_gather-rework.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: mmu_gather rework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Fix up the ia64 mmu_gather code to conform to the new API.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Tony Luck <tony.luck@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/tlb.h |   66 +++++++++++++++++++++++-----------
 1 file changed, 46 insertions(+), 20 deletions(-)

diff -puN arch/ia64/include/asm/tlb.h~ia64-mmu_gather-rework arch/ia64/include/asm/tlb.h
--- a/arch/ia64/include/asm/tlb.h~ia64-mmu_gather-rework
+++ a/arch/ia64/include/asm/tlb.h
@@ -47,21 +47,27 @@
 #include <asm/machvec.h>
 
 #ifdef CONFIG_SMP
-# define FREE_PTE_NR		2048
 # define tlb_fast_mode(tlb)	((tlb)->nr == ~0U)
 #else
-# define FREE_PTE_NR		0
 # define tlb_fast_mode(tlb)	(1)
 #endif
 
+/*
+ * If we can't allocate a page to make a big batch of page pointers
+ * to work on, then just handle a few from the on-stack structure.
+ */
+#define	IA64_GATHER_BUNDLE	8
+
 struct mmu_gather {
 	struct mm_struct	*mm;
 	unsigned int		nr;		/* == ~0U => fast mode */
+	unsigned int		max;
 	unsigned char		fullmm;		/* non-zero means full mm flush */
 	unsigned char		need_flush;	/* really unmapped some PTEs? */
 	unsigned long		start_addr;
 	unsigned long		end_addr;
-	struct page 		*pages[FREE_PTE_NR];
+	struct page		**pages;
+	struct page		*local[IA64_GATHER_BUNDLE];
 };
 
 struct ia64_tr_entry {
@@ -90,9 +96,6 @@ extern struct ia64_tr_entry *ia64_idtrs[
 #define RR_RID_MASK	0x00000000ffffff00L
 #define RR_TO_RID(val) 	((val >> 8) & 0xffffff)
 
-/* Users of the generic TLB shootdown code must declare this storage space. */
-DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 /*
  * Flush the TLB for address range START to END and, if not in fast mode, release the
  * freed pages that where gathered up to this point.
@@ -147,15 +150,23 @@ ia64_tlb_flush_mmu (struct mmu_gather *t
 	}
 }
 
-/*
- * Return a pointer to an initialized struct mmu_gather.
- */
-static inline struct mmu_gather *
-tlb_gather_mmu (struct mm_struct *mm, unsigned int full_mm_flush)
+static inline void __tlb_alloc_page(struct mmu_gather *tlb)
 {
-	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
+	unsigned long addr = __get_free_pages(GFP_NOWAIT | __GFP_NOWARN, 0);
 
+	if (addr) {
+		tlb->pages = (void *)addr;
+		tlb->max = PAGE_SIZE / sizeof(void *);
+	}
+}
+
+
+static inline void
+tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int full_mm_flush)
+{
 	tlb->mm = mm;
+	tlb->max = ARRAY_SIZE(tlb->local);
+	tlb->pages = tlb->local;
 	/*
 	 * Use fast mode if only 1 CPU is online.
 	 *
@@ -172,7 +183,6 @@ tlb_gather_mmu (struct mm_struct *mm, un
 	tlb->nr = (num_online_cpus() == 1) ? ~0U : 0;
 	tlb->fullmm = full_mm_flush;
 	tlb->start_addr = ~0UL;
-	return tlb;
 }
 
 /*
@@ -180,7 +190,7 @@ tlb_gather_mmu (struct mm_struct *mm, un
  * collected.
  */
 static inline void
-tlb_finish_mmu (struct mmu_gather *tlb, unsigned long start, unsigned long end)
+tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 {
 	/*
 	 * Note: tlb->nr may be 0 at this point, so we can't rely on tlb->start_addr and
@@ -191,7 +201,8 @@ tlb_finish_mmu (struct mmu_gather *tlb, 
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
 
-	put_cpu_var(mmu_gathers);
+	if (tlb->pages != tlb->local)
+		free_pages((unsigned long)tlb->pages, 0);
 }
 
 /*
@@ -199,18 +210,33 @@ tlb_finish_mmu (struct mmu_gather *tlb, 
  * must be delayed until after the TLB has been flushed (see comments at the beginning of
  * this file).
  */
-static inline void
-tlb_remove_page (struct mmu_gather *tlb, struct page *page)
+static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
 	tlb->need_flush = 1;
 
 	if (tlb_fast_mode(tlb)) {
 		free_page_and_swap_cache(page);
-		return;
+		return 1; /* avoid calling tlb_flush_mmu */
 	}
+
+	if (!tlb->nr && tlb->pages == tlb->local)
+		__tlb_alloc_page(tlb);
+
 	tlb->pages[tlb->nr++] = page;
-	if (tlb->nr >= FREE_PTE_NR)
-		ia64_tlb_flush_mmu(tlb, tlb->start_addr, tlb->end_addr);
+	VM_BUG_ON(tlb->nr > tlb->max);
+
+	return tlb->max - tlb->nr;
+}
+
+static inline void tlb_flush_mmu(struct mmu_gather *tlb)
+{
+	ia64_tlb_flush_mmu(tlb, tlb->start_addr, tlb->end_addr);
+}
+
+static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	if (!__tlb_remove_page(tlb, page))
+		tlb_flush_mmu(tlb);
 }
 
 /*
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
linux-next.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch

