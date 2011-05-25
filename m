From: akpm@linux-foundation.org
Subject: [merged] sh-mmu_gather-rework.patch removed from -mm tree
Date: Wed, 25 May 2011 13:28:20 -0700
Message-ID: <201105252026.p4PKQhTF014511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754059Ab1EYU1r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:27:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, hughd@google.com, jdike@addtoit.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lethal@linu


The patch titled
     sh: mmu_gather rework
has been removed from the -mm tree.  Its filename was
     sh-mmu_gather-rework.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sh: mmu_gather rework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Fix up the sh mmu_gather code to conform to the new API.

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

 arch/sh/include/asm/tlb.h |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff -puN arch/sh/include/asm/tlb.h~sh-mmu_gather-rework arch/sh/include/asm/tlb.h
--- a/arch/sh/include/asm/tlb.h~sh-mmu_gather-rework
+++ a/arch/sh/include/asm/tlb.h
@@ -23,8 +23,6 @@ struct mmu_gather {
 	unsigned long		start, end;
 };
 
-DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 static inline void init_tlb_gather(struct mmu_gather *tlb)
 {
 	tlb->start = TASK_SIZE;
@@ -36,17 +34,13 @@ static inline void init_tlb_gather(struc
 	}
 }
 
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
 
 static inline void
@@ -57,8 +51,6 @@ tlb_finish_mmu(struct mmu_gather *tlb, u
 
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
-
-	put_cpu_var(mmu_gathers);
 }
 
 static inline void
@@ -91,7 +83,21 @@ tlb_end_vma(struct mmu_gather *tlb, stru
 	}
 }
 
-#define tlb_remove_page(tlb,page)	free_page_and_swap_cache(page)
+static inline void tlb_flush_mmu(struct mmu_gather *tlb)
+{
+}
+
+static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	free_page_and_swap_cache(page);
+	return 1; /* avoid calling tlb_flush_mmu */
+}
+
+static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	__tlb_remove_page(tlb, page);
+}
+
 #define pte_free_tlb(tlb, ptep, addr)	pte_free((tlb)->mm, ptep)
 #define pmd_free_tlb(tlb, pmdp, addr)	pmd_free((tlb)->mm, pmdp)
 #define pud_free_tlb(tlb, pudp, addr)	pud_free((tlb)->mm, pudp)
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
linux-next.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch

