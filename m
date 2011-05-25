From: akpm@linux-foundation.org
Subject: [merged] um-mmu_gather-rework.patch removed from -mm tree
Date: Wed, 25 May 2011 13:28:30 -0700
Message-ID: <201105252026.p4PKQr2W014520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755109Ab1EYU2T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:28:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, hughd@google.com, jdike@addtoit.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lethal@linu


The patch titled
     um: mmu_gather rework
has been removed from the -mm tree.  Its filename was
     um-mmu_gather-rework.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: mmu_gather rework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Fix up the um mmu_gather code to conform to the new API.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/tlb.h |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff -puN arch/um/include/asm/tlb.h~um-mmu_gather-rework arch/um/include/asm/tlb.h
--- a/arch/um/include/asm/tlb.h~um-mmu_gather-rework
+++ a/arch/um/include/asm/tlb.h
@@ -22,9 +22,6 @@ struct mmu_gather {
 	unsigned int		fullmm; /* non-zero means full mm flush */
 };
 
-/* Users of the generic TLB shootdown code must declare this storage space. */
-DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 static inline void __tlb_remove_tlb_entry(struct mmu_gather *tlb, pte_t *ptep,
 					  unsigned long address)
 {
@@ -47,27 +44,20 @@ static inline void init_tlb_gather(struc
 	}
 }
 
-/* tlb_gather_mmu
- *	Return a pointer to an initialized struct mmu_gather.
- */
-static inline struct mmu_gather *
-tlb_gather_mmu(struct mm_struct *mm, unsigned int full_mm_flush)
+static inline void
+tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int full_mm_flush)
 {
-	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
-
 	tlb->mm = mm;
 	tlb->fullmm = full_mm_flush;
 
 	init_tlb_gather(tlb);
-
-	return tlb;
 }
 
 extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 			       unsigned long end);
 
 static inline void
-tlb_flush_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
+tlb_flush_mmu(struct mmu_gather *tlb)
 {
 	if (!tlb->need_flush)
 		return;
@@ -83,12 +73,10 @@ tlb_flush_mmu(struct mmu_gather *tlb, un
 static inline void
 tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 {
-	tlb_flush_mmu(tlb, start, end);
+	tlb_flush_mmu(tlb);
 
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
-
-	put_cpu_var(mmu_gathers);
 }
 
 /* tlb_remove_page
@@ -96,11 +84,16 @@ tlb_finish_mmu(struct mmu_gather *tlb, u
  *	while handling the additional races in SMP caused by other CPUs
  *	caching valid mappings in their TLBs.
  */
-static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
 	tlb->need_flush = 1;
 	free_page_and_swap_cache(page);
-	return;
+	return 1; /* avoid calling tlb_flush_mmu */
+}
+
+static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	__tlb_remove_page(tlb, page);
 }
 
 /**
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
linux-next.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch

