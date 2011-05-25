From: akpm@linux-foundation.org
Subject: [merged] powerpc-mmu_gather-rework.patch removed from -mm tree
Date: Wed, 25 May 2011 13:28:08 -0700
Message-ID: <201105252026.p4PKQVUW014499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754084Ab1EYU1u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:27:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, hughd@google.com, jdike@addtoit.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lethal@linu


The patch titled
     powerpc: mmu_gather rework
has been removed from the -mm tree.  Its filename was
     powerpc-mmu_gather-rework.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: mmu_gather rework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Fix up powerpc to the new mmu_gather stuff.

PPC has an extra batching queue to RCU free the actual pagetable
allocations, use the ARCH extentions for that for now.

For the ppc64_tlb_batch, which tracks the vaddrs to unhash from the
hardware hash-table, keep using per-cpu arrays but flush on context switch
and use a TLF bit to track the lazy_mmu state.

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

 arch/powerpc/include/asm/pgalloc.h     |    4 ++--
 arch/powerpc/include/asm/thread_info.h |    2 ++
 arch/powerpc/include/asm/tlb.h         |   10 ++++++++++
 arch/powerpc/kernel/process.c          |   23 ++++++++++++++++++++++-
 arch/powerpc/mm/pgtable.c              |   14 ++++----------
 arch/powerpc/mm/tlb_hash32.c           |    2 +-
 arch/powerpc/mm/tlb_hash64.c           |    6 ++++--
 arch/powerpc/mm/tlb_nohash.c           |    2 +-
 8 files changed, 46 insertions(+), 17 deletions(-)

diff -puN arch/powerpc/include/asm/pgalloc.h~powerpc-mmu_gather-rework arch/powerpc/include/asm/pgalloc.h
--- a/arch/powerpc/include/asm/pgalloc.h~powerpc-mmu_gather-rework
+++ a/arch/powerpc/include/asm/pgalloc.h
@@ -32,13 +32,13 @@ static inline void pte_free(struct mm_st
 
 #ifdef CONFIG_SMP
 extern void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift);
-extern void pte_free_finish(void);
+extern void pte_free_finish(struct mmu_gather *tlb);
 #else /* CONFIG_SMP */
 static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift)
 {
 	pgtable_free(table, shift);
 }
-static inline void pte_free_finish(void) { }
+static inline void pte_free_finish(struct mmu_gather *tlb) { }
 #endif /* !CONFIG_SMP */
 
 static inline void __pte_free_tlb(struct mmu_gather *tlb, struct page *ptepage,
diff -puN arch/powerpc/include/asm/thread_info.h~powerpc-mmu_gather-rework arch/powerpc/include/asm/thread_info.h
--- a/arch/powerpc/include/asm/thread_info.h~powerpc-mmu_gather-rework
+++ a/arch/powerpc/include/asm/thread_info.h
@@ -139,10 +139,12 @@ static inline struct thread_info *curren
 #define TLF_NAPPING		0	/* idle thread enabled NAP mode */
 #define TLF_SLEEPING		1	/* suspend code enabled SLEEP mode */
 #define TLF_RESTORE_SIGMASK	2	/* Restore signal mask in do_signal */
+#define TLF_LAZY_MMU		3	/* tlb_batch is active */
 
 #define _TLF_NAPPING		(1 << TLF_NAPPING)
 #define _TLF_SLEEPING		(1 << TLF_SLEEPING)
 #define _TLF_RESTORE_SIGMASK	(1 << TLF_RESTORE_SIGMASK)
+#define _TLF_LAZY_MMU		(1 << TLF_LAZY_MMU)
 
 #ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1
diff -puN arch/powerpc/include/asm/tlb.h~powerpc-mmu_gather-rework arch/powerpc/include/asm/tlb.h
--- a/arch/powerpc/include/asm/tlb.h~powerpc-mmu_gather-rework
+++ a/arch/powerpc/include/asm/tlb.h
@@ -28,6 +28,16 @@
 #define tlb_start_vma(tlb, vma)	do { } while (0)
 #define tlb_end_vma(tlb, vma)	do { } while (0)
 
+#define HAVE_ARCH_MMU_GATHER 1
+
+struct pte_freelist_batch;
+
+struct arch_mmu_gather {
+	struct pte_freelist_batch *batch;
+};
+
+#define ARCH_MMU_GATHER_INIT (struct arch_mmu_gather){ .batch = NULL, }
+
 extern void tlb_flush(struct mmu_gather *tlb);
 
 /* Get the generic bits... */
diff -puN arch/powerpc/kernel/process.c~powerpc-mmu_gather-rework arch/powerpc/kernel/process.c
--- a/arch/powerpc/kernel/process.c~powerpc-mmu_gather-rework
+++ a/arch/powerpc/kernel/process.c
@@ -395,6 +395,9 @@ struct task_struct *__switch_to(struct t
 	struct thread_struct *new_thread, *old_thread;
 	unsigned long flags;
 	struct task_struct *last;
+#ifdef CONFIG_PPC_BOOK3S_64
+	struct ppc64_tlb_batch *batch;
+#endif
 
 #ifdef CONFIG_SMP
 	/* avoid complexity of lazy save/restore of fpu
@@ -513,7 +516,17 @@ struct task_struct *__switch_to(struct t
 		old_thread->accum_tb += (current_tb - start_tb);
 		new_thread->start_tb = current_tb;
 	}
-#endif
+#endif /* CONFIG_PPC64 */
+
+#ifdef CONFIG_PPC_BOOK3S_64
+	batch = &__get_cpu_var(ppc64_tlb_batch);
+	if (batch->active) {
+		current_thread_info()->local_flags |= _TLF_LAZY_MMU;
+		if (batch->index)
+			__flush_tlb_pending(batch);
+		batch->active = 0;
+	}
+#endif /* CONFIG_PPC_BOOK3S_64 */
 
 	local_irq_save(flags);
 
@@ -528,6 +541,14 @@ struct task_struct *__switch_to(struct t
 	hard_irq_disable();
 	last = _switch(old_thread, new_thread);
 
+#ifdef CONFIG_PPC_BOOK3S_64
+	if (current_thread_info()->local_flags & _TLF_LAZY_MMU) {
+		current_thread_info()->local_flags &= ~_TLF_LAZY_MMU;
+		batch = &__get_cpu_var(ppc64_tlb_batch);
+		batch->active = 1;
+	}
+#endif /* CONFIG_PPC_BOOK3S_64 */
+
 	local_irq_restore(flags);
 
 	return last;
diff -puN arch/powerpc/mm/pgtable.c~powerpc-mmu_gather-rework arch/powerpc/mm/pgtable.c
--- a/arch/powerpc/mm/pgtable.c~powerpc-mmu_gather-rework
+++ a/arch/powerpc/mm/pgtable.c
@@ -33,8 +33,6 @@
 
 #include "mmu_decl.h"
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 #ifdef CONFIG_SMP
 
 /*
@@ -43,7 +41,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_ga
  * freeing a page table page that is being walked without locks
  */
 
-static DEFINE_PER_CPU(struct pte_freelist_batch *, pte_freelist_cur);
 static unsigned long pte_freelist_forced_free;
 
 struct pte_freelist_batch
@@ -97,12 +94,10 @@ static void pte_free_submit(struct pte_f
 
 void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift)
 {
-	/* This is safe since tlb_gather_mmu has disabled preemption */
-	struct pte_freelist_batch **batchp = &__get_cpu_var(pte_freelist_cur);
+	struct pte_freelist_batch **batchp = &tlb->arch.batch;
 	unsigned long pgf;
 
-	if (atomic_read(&tlb->mm->mm_users) < 2 ||
-	    cpumask_equal(mm_cpumask(tlb->mm), cpumask_of(smp_processor_id()))){
+	if (atomic_read(&tlb->mm->mm_users) < 2) {
 		pgtable_free(table, shift);
 		return;
 	}
@@ -124,10 +119,9 @@ void pgtable_free_tlb(struct mmu_gather 
 	}
 }
 
-void pte_free_finish(void)
+void pte_free_finish(struct mmu_gather *tlb)
 {
-	/* This is safe since tlb_gather_mmu has disabled preemption */
-	struct pte_freelist_batch **batchp = &__get_cpu_var(pte_freelist_cur);
+	struct pte_freelist_batch **batchp = &tlb->arch.batch;
 
 	if (*batchp == NULL)
 		return;
diff -puN arch/powerpc/mm/tlb_hash32.c~powerpc-mmu_gather-rework arch/powerpc/mm/tlb_hash32.c
--- a/arch/powerpc/mm/tlb_hash32.c~powerpc-mmu_gather-rework
+++ a/arch/powerpc/mm/tlb_hash32.c
@@ -73,7 +73,7 @@ void tlb_flush(struct mmu_gather *tlb)
 	}
 
 	/* Push out batch of freed page tables */
-	pte_free_finish();
+	pte_free_finish(tlb);
 }
 
 /*
diff -puN arch/powerpc/mm/tlb_hash64.c~powerpc-mmu_gather-rework arch/powerpc/mm/tlb_hash64.c
--- a/arch/powerpc/mm/tlb_hash64.c~powerpc-mmu_gather-rework
+++ a/arch/powerpc/mm/tlb_hash64.c
@@ -155,7 +155,7 @@ void __flush_tlb_pending(struct ppc64_tl
 
 void tlb_flush(struct mmu_gather *tlb)
 {
-	struct ppc64_tlb_batch *tlbbatch = &__get_cpu_var(ppc64_tlb_batch);
+	struct ppc64_tlb_batch *tlbbatch = &get_cpu_var(ppc64_tlb_batch);
 
 	/* If there's a TLB batch pending, then we must flush it because the
 	 * pages are going to be freed and we really don't want to have a CPU
@@ -164,8 +164,10 @@ void tlb_flush(struct mmu_gather *tlb)
 	if (tlbbatch->index)
 		__flush_tlb_pending(tlbbatch);
 
+	put_cpu_var(ppc64_tlb_batch);
+
 	/* Push out batch of freed page tables */
-	pte_free_finish();
+	pte_free_finish(tlb);
 }
 
 /**
diff -puN arch/powerpc/mm/tlb_nohash.c~powerpc-mmu_gather-rework arch/powerpc/mm/tlb_nohash.c
--- a/arch/powerpc/mm/tlb_nohash.c~powerpc-mmu_gather-rework
+++ a/arch/powerpc/mm/tlb_nohash.c
@@ -301,7 +301,7 @@ void tlb_flush(struct mmu_gather *tlb)
 	flush_tlb_mm(tlb->mm);
 
 	/* Push out batch of freed page tables */
-	pte_free_finish();
+	pte_free_finish(tlb);
 }
 
 /*
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
linux-next.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch

