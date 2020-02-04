From: akpm@linux-foundation.org
Subject: [merged]
 asm-generic-tlb-provide-mmu_gather_table_free.patch removed from -mm tree
Date: Tue, 04 Feb 2020 10:42:17 -0800
Message-ID: <20200204184217.wojM18RqT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727482AbgBDSmT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:42:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, peterz@infradead.org


The patch titled
     Subject: asm-generic/tlb: provide MMU_GATHER_TABLE_FREE
has been removed from the -mm tree.  Its filename was
     asm-generic-tlb-provide-mmu_gather_table_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Zijlstra <peterz@infradead.org>
Subject: asm-generic/tlb: provide MMU_GATHER_TABLE_FREE

As described in the comment, the correct order for freeing pages is:

 1) unhook page
 2) TLB invalidate page
 3) free page

This order equally applies to page directories.

Currently there are two correct options:

 - use tlb_remove_page(), when all page directores are full pages and
   there are no futher contraints placed by things like software
   walkers (HAVE_FAST_GUP).

 - use MMU_GATHER_RCU_TABLE_FREE and tlb_remove_table() when the
   architecture does not do IPI based TLB invalidate and has
   HAVE_FAST_GUP (or software TLB fill).

This however leaves architectures that don't have page based directories
but don't need RCU in a bind.  For those, provide MMU_GATHER_TABLE_FREE,
which provides the independent batching for directories without the
additional RCU freeing.

Link: http://lkml.kernel.org/r/20200116064531.483522-10-aneesh.kumar@linux.ibm.com
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig               |    5 +
 arch/arm/include/asm/tlb.h |    4 -
 include/asm-generic/tlb.h  |   72 ++++++++++-----------
 mm/mmu_gather.c            |  120 +++++++++++++++++++++++++----------
 4 files changed, 130 insertions(+), 71 deletions(-)

--- a/arch/arm/include/asm/tlb.h~asm-generic-tlb-provide-mmu_gather_table_free
+++ a/arch/arm/include/asm/tlb.h
@@ -37,10 +37,6 @@ static inline void __tlb_remove_table(vo
 
 #include <asm-generic/tlb.h>
 
-#ifndef CONFIG_MMU_GATHER_RCU_TABLE_FREE
-#define tlb_remove_table(tlb, entry) tlb_remove_page(tlb, entry)
-#endif
-
 static inline void
 __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte, unsigned long addr)
 {
--- a/arch/Kconfig~asm-generic-tlb-provide-mmu_gather_table_free
+++ a/arch/Kconfig
@@ -393,8 +393,12 @@ config HAVE_ARCH_JUMP_LABEL
 config HAVE_ARCH_JUMP_LABEL_RELATIVE
 	bool
 
+config MMU_GATHER_TABLE_FREE
+	bool
+
 config MMU_GATHER_RCU_TABLE_FREE
 	bool
+	select MMU_GATHER_TABLE_FREE
 
 config MMU_GATHER_PAGE_SIZE
 	bool
@@ -404,6 +408,7 @@ config MMU_GATHER_NO_RANGE
 
 config MMU_GATHER_NO_GATHER
 	bool
+	depends on MMU_GATHER_TABLE_FREE
 
 config ARCH_HAVE_NMI_SAFE_CMPXCHG
 	bool
--- a/include/asm-generic/tlb.h~asm-generic-tlb-provide-mmu_gather_table_free
+++ a/include/asm-generic/tlb.h
@@ -56,6 +56,15 @@
  *    Defaults to flushing at tlb_end_vma() to reset the range; helps when
  *    there's large holes between the VMAs.
  *
+ *  - tlb_remove_table()
+ *
+ *    tlb_remove_table() is the basic primitive to free page-table directories
+ *    (__p*_free_tlb()).  In it's most primitive form it is an alias for
+ *    tlb_remove_page() below, for when page directories are pages and have no
+ *    additional constraints.
+ *
+ *    See also MMU_GATHER_TABLE_FREE and MMU_GATHER_RCU_TABLE_FREE.
+ *
  *  - tlb_remove_page() / __tlb_remove_page()
  *  - tlb_remove_page_size() / __tlb_remove_page_size()
  *
@@ -129,17 +138,24 @@
  *  This might be useful if your architecture has size specific TLB
  *  invalidation instructions.
  *
- *  MMU_GATHER_RCU_TABLE_FREE
+ *  MMU_GATHER_TABLE_FREE
  *
  *  This provides tlb_remove_table(), to be used instead of tlb_remove_page()
- *  for page directores (__p*_free_tlb()). This provides separate freeing of
- *  the page-table pages themselves in a semi-RCU fashion (see comment below).
- *  Useful if your architecture doesn't use IPIs for remote TLB invalidates
- *  and therefore doesn't naturally serialize with software page-table walkers.
+ *  for page directores (__p*_free_tlb()).
+ *
+ *  Useful if your architecture has non-page page directories.
  *
  *  When used, an architecture is expected to provide __tlb_remove_table()
  *  which does the actual freeing of these pages.
  *
+ *  MMU_GATHER_RCU_TABLE_FREE
+ *
+ *  Like MMU_GATHER_TABLE_FREE, and adds semi-RCU semantics to the free (see
+ *  comment below).
+ *
+ *  Useful if your architecture doesn't use IPIs for remote TLB invalidates
+ *  and therefore doesn't naturally serialize with software page-table walkers.
+ *
  *  MMU_GATHER_NO_RANGE
  *
  *  Use this if your architecture lacks an efficient flush_tlb_range().
@@ -155,37 +171,12 @@
  *  various ptep_get_and_clear() functions.
  */
 
-#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
-/*
- * Semi RCU freeing of the page directories.
- *
- * This is needed by some architectures to implement software pagetable walkers.
- *
- * gup_fast() and other software pagetable walkers do a lockless page-table
- * walk and therefore needs some synchronization with the freeing of the page
- * directories. The chosen means to accomplish that is by disabling IRQs over
- * the walk.
- *
- * Architectures that use IPIs to flush TLBs will then automagically DTRT,
- * since we unlink the page, flush TLBs, free the page. Since the disabling of
- * IRQs delays the completion of the TLB flush we can never observe an already
- * freed page.
- *
- * Architectures that do not have this (PPC) need to delay the freeing by some
- * other means, this is that means.
- *
- * What we do is batch the freed directory pages (tables) and RCU free them.
- * We use the sched RCU variant, as that guarantees that IRQ/preempt disabling
- * holds off grace periods.
- *
- * However, in order to batch these pages we need to allocate storage, this
- * allocation is deep inside the MM code and can thus easily fail on memory
- * pressure. To guarantee progress we fall back to single table freeing, see
- * the implementation of tlb_remove_table_one().
- *
- */
+#ifdef CONFIG_MMU_GATHER_TABLE_FREE
+
 struct mmu_table_batch {
+#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
 	struct rcu_head		rcu;
+#endif
 	unsigned int		nr;
 	void			*tables[0];
 };
@@ -195,6 +186,17 @@ struct mmu_table_batch {
 
 extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
 
+#else /* !CONFIG_MMU_GATHER_HAVE_TABLE_FREE */
+
+/*
+ * Without MMU_GATHER_TABLE_FREE the architecture is assumed to have page based
+ * page directories and we can use the normal page batching to free them.
+ */
+#define tlb_remove_table(tlb, page) tlb_remove_page((tlb), (page))
+
+#endif /* CONFIG_MMU_GATHER_TABLE_FREE */
+
+#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
 /*
  * This allows an architecture that does not use the linux page-tables for
  * hardware to skip the TLBI when freeing page tables.
@@ -248,7 +250,7 @@ extern bool __tlb_remove_page_size(struc
 struct mmu_gather {
 	struct mm_struct	*mm;
 
-#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
+#ifdef CONFIG_MMU_GATHER_TABLE_FREE
 	struct mmu_table_batch	*batch;
 #endif
 
--- a/mm/mmu_gather.c~asm-generic-tlb-provide-mmu_gather_table_free
+++ a/mm/mmu_gather.c
@@ -91,56 +91,106 @@ bool __tlb_remove_page_size(struct mmu_g
 
 #endif /* MMU_GATHER_NO_GATHER */
 
-#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
+#ifdef CONFIG_MMU_GATHER_TABLE_FREE
 
-/*
- * See the comment near struct mmu_table_batch.
- */
+static void __tlb_remove_table_free(struct mmu_table_batch *batch)
+{
+	int i;
+
+	for (i = 0; i < batch->nr; i++)
+		__tlb_remove_table(batch->tables[i]);
+
+	free_page((unsigned long)batch);
+}
+
+#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
 
 /*
- * If we want tlb_remove_table() to imply TLB invalidates.
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
  */
-static inline void tlb_table_invalidate(struct mmu_gather *tlb)
-{
-	if (tlb_needs_table_invalidate()) {
-		/*
-		 * Invalidate page-table caches used by hardware walkers. Then
-		 * we still need to RCU-sched wait while freeing the pages
-		 * because software walkers can still be in-flight.
-		 */
-		tlb_flush_mmu_tlbonly(tlb);
-	}
-}
 
 static void tlb_remove_table_smp_sync(void *arg)
 {
 	/* Simply deliver the interrupt */
 }
 
-static void tlb_remove_table_one(void *table)
+static void tlb_remove_table_sync_one(void)
 {
 	/*
 	 * This isn't an RCU grace period and hence the page-tables cannot be
 	 * assumed to be actually RCU-freed.
 	 *
 	 * It is however sufficient for software page-table walkers that rely on
-	 * IRQ disabling. See the comment near struct mmu_table_batch.
+	 * IRQ disabling.
 	 */
 	smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
-	__tlb_remove_table(table);
 }
 
 static void tlb_remove_table_rcu(struct rcu_head *head)
 {
-	struct mmu_table_batch *batch;
-	int i;
+	__tlb_remove_table_free(container_of(head, struct mmu_table_batch, rcu));
+}
 
-	batch = container_of(head, struct mmu_table_batch, rcu);
+static void tlb_remove_table_free(struct mmu_table_batch *batch)
+{
+	call_rcu(&batch->rcu, tlb_remove_table_rcu);
+}
 
-	for (i = 0; i < batch->nr; i++)
-		__tlb_remove_table(batch->tables[i]);
+#else /* !CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
-	free_page((unsigned long)batch);
+static void tlb_remove_table_sync_one(void) { }
+
+static void tlb_remove_table_free(struct mmu_table_batch *batch)
+{
+	__tlb_remove_table_free(batch);
+}
+
+#endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
+
+/*
+ * If we want tlb_remove_table() to imply TLB invalidates.
+ */
+static inline void tlb_table_invalidate(struct mmu_gather *tlb)
+{
+	if (tlb_needs_table_invalidate()) {
+		/*
+		 * Invalidate page-table caches used by hardware walkers. Then
+		 * we still need to RCU-sched wait while freeing the pages
+		 * because software walkers can still be in-flight.
+		 */
+		tlb_flush_mmu_tlbonly(tlb);
+	}
+}
+
+static void tlb_remove_table_one(void *table)
+{
+	tlb_remove_table_sync_one();
+	__tlb_remove_table(table);
 }
 
 static void tlb_table_flush(struct mmu_gather *tlb)
@@ -149,7 +199,7 @@ static void tlb_table_flush(struct mmu_g
 
 	if (*batch) {
 		tlb_table_invalidate(tlb);
-		call_rcu(&(*batch)->rcu, tlb_remove_table_rcu);
+		tlb_remove_table_free(*batch);
 		*batch = NULL;
 	}
 }
@@ -173,13 +223,21 @@ void tlb_remove_table(struct mmu_gather
 		tlb_table_flush(tlb);
 }
 
-#endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
+static inline void tlb_table_init(struct mmu_gather *tlb)
+{
+	tlb->batch = NULL;
+}
+
+#else /* !CONFIG_MMU_GATHER_TABLE_FREE */
+
+static inline void tlb_table_flush(struct mmu_gather *tlb) { }
+static inline void tlb_table_init(struct mmu_gather *tlb) { }
+
+#endif /* CONFIG_MMU_GATHER_TABLE_FREE */
 
 static void tlb_flush_mmu_free(struct mmu_gather *tlb)
 {
-#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
 	tlb_table_flush(tlb);
-#endif
 #ifndef CONFIG_MMU_GATHER_NO_GATHER
 	tlb_batch_pages_flush(tlb);
 #endif
@@ -220,9 +278,7 @@ void tlb_gather_mmu(struct mmu_gather *t
 	tlb->batch_count = 0;
 #endif
 
-#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
-	tlb->batch = NULL;
-#endif
+	tlb_table_init(tlb);
 #ifdef CONFIG_MMU_GATHER_PAGE_SIZE
 	tlb->page_size = 0;
 #endif
_

Patches currently in -mm which might be from peterz@infradead.org are
