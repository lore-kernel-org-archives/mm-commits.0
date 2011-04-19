From: akpm@linux-foundation.org
Subject: + mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code.patch added to -mm tree
Date: Tue, 19 Apr 2011 13:10:27 -0700
Message-ID: <201104192010.p3JKARaB020500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478Ab1DSULV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Apr 2011 16:11:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, hughd@google.com, jdike@addtoit.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lethal@linux-sh.org, mel@csn.ul.ie, namhyung@gmail.com, npiggin@kernel.dk, richard@nod.at, rmk@arm.linux.org.uk, schwidefsky@de.ibm.com, tony.luck@intel.com


The patch titled
     mm, powerpc: move the RCU page-table freeing into generic code
has been added to the -mm tree.  Its filename is
     mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code.patch

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
Subject: mm, powerpc: move the RCU page-table freeing into generic code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

In case other architectures require RCU freed page-tables to implement
gup_fast() and software filled hashes and similar things, provide the
means to do so by moving the logic into generic code.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Requested-by: David Miller <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
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

 arch/Kconfig                       |    3 
 arch/powerpc/Kconfig               |    1 
 arch/powerpc/include/asm/pgalloc.h |   21 ++++-
 arch/powerpc/include/asm/tlb.h     |   10 --
 arch/powerpc/mm/pgtable.c          |   98 ---------------------------
 arch/powerpc/mm/tlb_hash32.c       |    3 
 arch/powerpc/mm/tlb_hash64.c       |    3 
 arch/powerpc/mm/tlb_nohash.c       |    3 
 include/asm-generic/tlb.h          |   56 ++++++++++++++-
 mm/memory.c                        |   77 +++++++++++++++++++++
 10 files changed, 150 insertions(+), 125 deletions(-)

diff -puN arch/Kconfig~mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code arch/Kconfig
--- a/arch/Kconfig~mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code
+++ a/arch/Kconfig
@@ -175,4 +175,7 @@ config HAVE_ARCH_JUMP_LABEL
 config HAVE_ARCH_MUTEX_CPU_RELAX
 	bool
 
+config HAVE_RCU_TABLE_FREE
+	bool
+
 source "kernel/gcov/Kconfig"
diff -puN arch/powerpc/Kconfig~mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code
+++ a/arch/powerpc/Kconfig
@@ -140,6 +140,7 @@ config PPC
 	select IRQ_PER_CPU
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
+	select HAVE_RCU_TABLE_FREE if SMP
 
 config EARLY_PRINTK
 	bool
diff -puN arch/powerpc/include/asm/pgalloc.h~mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code arch/powerpc/include/asm/pgalloc.h
--- a/arch/powerpc/include/asm/pgalloc.h~mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code
+++ a/arch/powerpc/include/asm/pgalloc.h
@@ -31,14 +31,29 @@ static inline void pte_free(struct mm_st
 #endif
 
 #ifdef CONFIG_SMP
-extern void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift);
-extern void pte_free_finish(struct mmu_gather *tlb);
+struct mmu_gather;
+extern void tlb_remove_table(struct mmu_gather *, void *);
+
+static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, int shift)
+{
+	unsigned long pgf = (unsigned long)table;
+	BUG_ON(shift > MAX_PGTABLE_INDEX_SIZE);
+	pgf |= shift;
+	tlb_remove_table(tlb, (void *)pgf);
+}
+
+static inline void __tlb_remove_table(void *_table)
+{
+	void *table = (void *)((unsigned long)_table & ~MAX_PGTABLE_INDEX_SIZE);
+	unsigned shift = (unsigned long)_table & MAX_PGTABLE_INDEX_SIZE;
+
+	pgtable_free(table, shift);
+}
 #else /* CONFIG_SMP */
 static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift)
 {
 	pgtable_free(table, shift);
 }
-static inline void pte_free_finish(struct mmu_gather *tlb) { }
 #endif /* !CONFIG_SMP */
 
 static inline void __pte_free_tlb(struct mmu_gather *tlb, struct page *ptepage,
diff -puN arch/powerpc/include/asm/tlb.h~mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code arch/powerpc/include/asm/tlb.h
--- a/arch/powerpc/include/asm/tlb.h~mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code
+++ a/arch/powerpc/include/asm/tlb.h
@@ -28,16 +28,6 @@
 #define tlb_start_vma(tlb, vma)	do { } while (0)
 #define tlb_end_vma(tlb, vma)	do { } while (0)
 
-#define HAVE_ARCH_MMU_GATHER 1
-
-struct pte_freelist_batch;
-
-struct arch_mmu_gather {
-	struct pte_freelist_batch *batch;
-};
-
-#define ARCH_MMU_GATHER_INIT (struct arch_mmu_gather){ .batch = NULL, }
-
 extern void tlb_flush(struct mmu_gather *tlb);
 
 /* Get the generic bits... */
diff -puN arch/powerpc/mm/pgtable.c~mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code arch/powerpc/mm/pgtable.c
--- a/arch/powerpc/mm/pgtable.c~mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code
+++ a/arch/powerpc/mm/pgtable.c
@@ -33,104 +33,6 @@
 
 #include "mmu_decl.h"
 
-#ifdef CONFIG_SMP
-
-/*
- * Handle batching of page table freeing on SMP. Page tables are
- * queued up and send to be freed later by RCU in order to avoid
- * freeing a page table page that is being walked without locks
- */
-
-static unsigned long pte_freelist_forced_free;
-
-struct pte_freelist_batch
-{
-	struct rcu_head	rcu;
-	unsigned int	index;
-	unsigned long	tables[0];
-};
-
-#define PTE_FREELIST_SIZE \
-	((PAGE_SIZE - sizeof(struct pte_freelist_batch)) \
-	  / sizeof(unsigned long))
-
-static void pte_free_smp_sync(void *arg)
-{
-	/* Do nothing, just ensure we sync with all CPUs */
-}
-
-/* This is only called when we are critically out of memory
- * (and fail to get a page in pte_free_tlb).
- */
-static void pgtable_free_now(void *table, unsigned shift)
-{
-	pte_freelist_forced_free++;
-
-	smp_call_function(pte_free_smp_sync, NULL, 1);
-
-	pgtable_free(table, shift);
-}
-
-static void pte_free_rcu_callback(struct rcu_head *head)
-{
-	struct pte_freelist_batch *batch =
-		container_of(head, struct pte_freelist_batch, rcu);
-	unsigned int i;
-
-	for (i = 0; i < batch->index; i++) {
-		void *table = (void *)(batch->tables[i] & ~MAX_PGTABLE_INDEX_SIZE);
-		unsigned shift = batch->tables[i] & MAX_PGTABLE_INDEX_SIZE;
-
-		pgtable_free(table, shift);
-	}
-
-	free_page((unsigned long)batch);
-}
-
-static void pte_free_submit(struct pte_freelist_batch *batch)
-{
-	call_rcu_sched(&batch->rcu, pte_free_rcu_callback);
-}
-
-void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift)
-{
-	struct pte_freelist_batch **batchp = &tlb->arch.batch;
-	unsigned long pgf;
-
-	if (atomic_read(&tlb->mm->mm_users) < 2) {
-		pgtable_free(table, shift);
-		return;
-	}
-
-	if (*batchp == NULL) {
-		*batchp = (struct pte_freelist_batch *)__get_free_page(GFP_ATOMIC);
-		if (*batchp == NULL) {
-			pgtable_free_now(table, shift);
-			return;
-		}
-		(*batchp)->index = 0;
-	}
-	BUG_ON(shift > MAX_PGTABLE_INDEX_SIZE);
-	pgf = (unsigned long)table | shift;
-	(*batchp)->tables[(*batchp)->index++] = pgf;
-	if ((*batchp)->index == PTE_FREELIST_SIZE) {
-		pte_free_submit(*batchp);
-		*batchp = NULL;
-	}
-}
-
-void pte_free_finish(struct mmu_gather *tlb)
-{
-	struct pte_freelist_batch **batchp = &tlb->arch.batch;
-
-	if (*batchp == NULL)
-		return;
-	pte_free_submit(*batchp);
-	*batchp = NULL;
-}
-
-#endif /* CONFIG_SMP */
-
 static inline int is_exec_fault(void)
 {
 	return current->thread.regs && TRAP(current->thread.regs) == 0x400;
diff -puN arch/powerpc/mm/tlb_hash32.c~mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code arch/powerpc/mm/tlb_hash32.c
--- a/arch/powerpc/mm/tlb_hash32.c~mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code
+++ a/arch/powerpc/mm/tlb_hash32.c
@@ -71,9 +71,6 @@ void tlb_flush(struct mmu_gather *tlb)
 		 */
 		_tlbia();
 	}
-
-	/* Push out batch of freed page tables */
-	pte_free_finish(tlb);
 }
 
 /*
diff -puN arch/powerpc/mm/tlb_hash64.c~mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code arch/powerpc/mm/tlb_hash64.c
--- a/arch/powerpc/mm/tlb_hash64.c~mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code
+++ a/arch/powerpc/mm/tlb_hash64.c
@@ -165,9 +165,6 @@ void tlb_flush(struct mmu_gather *tlb)
 		__flush_tlb_pending(tlbbatch);
 
 	put_cpu_var(ppc64_tlb_batch);
-
-	/* Push out batch of freed page tables */
-	pte_free_finish(tlb);
 }
 
 /**
diff -puN arch/powerpc/mm/tlb_nohash.c~mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code arch/powerpc/mm/tlb_nohash.c
--- a/arch/powerpc/mm/tlb_nohash.c~mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code
+++ a/arch/powerpc/mm/tlb_nohash.c
@@ -299,9 +299,6 @@ EXPORT_SYMBOL(flush_tlb_range);
 void tlb_flush(struct mmu_gather *tlb)
 {
 	flush_tlb_mm(tlb->mm);
-
-	/* Push out batch of freed page tables */
-	pte_free_finish(tlb);
 }
 
 /*
diff -puN include/asm-generic/tlb.h~mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code include/asm-generic/tlb.h
--- a/include/asm-generic/tlb.h~mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code
+++ a/include/asm-generic/tlb.h
@@ -29,6 +29,49 @@
   #define tlb_fast_mode(tlb) 1
 #endif
 
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+/*
+ * Semi RCU freeing of the page directories.
+ *
+ * This is needed by some architectures to implement software pagetable walkers.
+ *
+ * gup_fast() and other software pagetable walkers do a lockless page-table
+ * walk and therefore needs some synchronization with the freeing of the page
+ * directories. The chosen means to accomplish that is by disabling IRQs over
+ * the walk.
+ *
+ * Architectures that use IPIs to flush TLBs will then automagically DTRT,
+ * since we unlink the page, flush TLBs, free the page. Since the disabling of
+ * IRQs delays the completion of the TLB flush we can never observe an already
+ * freed page.
+ *
+ * Architectures that do not have this (PPC) need to delay the freeing by some
+ * other means, this is that means.
+ *
+ * What we do is batch the freed directory pages (tables) and RCU free them.
+ * We use the sched RCU variant, as that guarantees that IRQ/preempt disabling
+ * holds off grace periods.
+ *
+ * However, in order to batch these pages we need to allocate storage, this
+ * allocation is deep inside the MM code and can thus easily fail on memory
+ * pressure. To guarantee progress we fall back to single table freeing, see
+ * the implementation of tlb_remove_table_one().
+ *
+ */
+struct mmu_table_batch {
+	struct rcu_head		rcu;
+	unsigned int		nr;
+	void			*tables[0];
+};
+
+#define MAX_TABLE_BATCH		\
+	((PAGE_SIZE - sizeof(struct mmu_table_batch)) / sizeof(void *))
+
+extern void tlb_table_flush(struct mmu_gather *tlb);
+extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
+
+#endif
+
 /*
  * If we can't allocate a page to make a big batch of page pointers
  * to work on, then just handle a few from the on-stack structure.
@@ -40,13 +83,13 @@
  */
 struct mmu_gather {
 	struct mm_struct	*mm;
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+	struct mmu_table_batch	*batch;
+#endif
 	unsigned int		nr;	/* set to ~0U means fast mode */
 	unsigned int		max;	/* nr < max */
 	unsigned int		need_flush;/* Really unmapped some ptes? */
 	unsigned int		fullmm; /* non-zero means full mm flush */
-#ifdef HAVE_ARCH_MMU_GATHER
-	struct arch_mmu_gather	arch;
-#endif
 	struct page		**pages;
 	struct page		*local[MMU_GATHER_BUNDLE];
 };
@@ -82,8 +125,8 @@ tlb_gather_mmu(struct mmu_gather *tlb, s
 
 	tlb->fullmm = fullmm;
 
-#ifdef HAVE_ARCH_MMU_GATHER
-	tlb->arch = ARCH_MMU_GATHER_INIT;
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+	tlb->batch = NULL;
 #endif
 }
 
@@ -94,6 +137,9 @@ tlb_flush_mmu(struct mmu_gather *tlb)
 		return;
 	tlb->need_flush = 0;
 	tlb_flush(tlb);
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+	tlb_table_flush(tlb);
+#endif
 	if (!tlb_fast_mode(tlb)) {
 		free_pages_and_swap_cache(tlb->pages, tlb->nr);
 		tlb->nr = 0;
diff -puN mm/memory.c~mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code mm/memory.c
--- a/mm/memory.c~mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code
+++ a/mm/memory.c
@@ -193,6 +193,83 @@ static void check_sync_rss_stat(struct t
 
 #endif
 
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+
+/*
+ * See the comment near struct mmu_table_batch.
+ */
+
+static void tlb_remove_table_smp_sync(void *arg)
+{
+	/* Simply deliver the interrupt */
+}
+
+static void tlb_remove_table_one(void *table)
+{
+	/*
+	 * This isn't an RCU grace period and hence the page-tables cannot be
+	 * assumed to be actually RCU-freed.
+	 *
+	 * It is however sufficient for software page-table walkers that rely on
+	 * IRQ disabling. See the comment near struct mmu_table_batch.
+	 */
+	smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
+	__tlb_remove_table(table);
+}
+
+static void tlb_remove_table_rcu(struct rcu_head *head)
+{
+	struct mmu_table_batch *batch;
+	int i;
+
+	batch = container_of(head, struct mmu_table_batch, rcu);
+
+	for (i = 0; i < batch->nr; i++)
+		__tlb_remove_table(batch->tables[i]);
+
+	free_page((unsigned long)batch);
+}
+
+void tlb_table_flush(struct mmu_gather *tlb)
+{
+	struct mmu_table_batch **batch = &tlb->batch;
+
+	if (*batch) {
+		call_rcu_sched(&(*batch)->rcu, tlb_remove_table_rcu);
+		*batch = NULL;
+	}
+}
+
+void tlb_remove_table(struct mmu_gather *tlb, void *table)
+{
+	struct mmu_table_batch **batch = &tlb->batch;
+
+	tlb->need_flush = 1;
+
+	/*
+	 * When there's less then two users of this mm there cannot be a
+	 * concurrent page-table walk.
+	 */
+	if (atomic_read(&tlb->mm->mm_users) < 2) {
+		__tlb_remove_table(table);
+		return;
+	}
+
+	if (*batch == NULL) {
+		*batch = (struct mmu_table_batch *)__get_free_page(GFP_NOWAIT | __GFP_NOWARN);
+		if (*batch == NULL) {
+			tlb_remove_table_one(table);
+			return;
+		}
+		(*batch)->nr = 0;
+	}
+	(*batch)->tables[(*batch)->nr++] = table;
+	if ((*batch)->nr == MAX_TABLE_BATCH)
+		tlb_table_flush(tlb);
+}
+
+#endif
+
 /*
  * If a p?d_bad entry is found while walking page tables, report
  * the error, before resetting entry to p?d_none.  Usually (but
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

