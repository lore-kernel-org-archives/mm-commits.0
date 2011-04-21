From: akpm@linux-foundation.org
Subject: + mm-uninline-large-generic-tlbh-functions.patch added to -mm tree
Date: Wed, 20 Apr 2011 17:11:38 -0700
Message-ID: <201104210011.p3L0BcbB003333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752097Ab1DUALr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 20:11:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, akpm@linux-foundation.org, hughd@google.com


The patch titled
     mm: uninline large generic tlb.h functions
has been added to the -mm tree.  Its filename is
     mm-uninline-large-generic-tlbh-functions.patch

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
Subject: mm: uninline large generic tlb.h functions
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Some of these functions have grown beyond inline sanity, move them
out-of-line.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Requested-by: Andrew Morton <akpm@linux-foundation.org>
Requested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |  135 +++---------------------------------
 mm/memory.c               |  124 ++++++++++++++++++++++++++++++++-
 2 files changed, 135 insertions(+), 124 deletions(-)

diff -puN include/asm-generic/tlb.h~mm-uninline-large-generic-tlbh-functions include/asm-generic/tlb.h
--- a/include/asm-generic/tlb.h~mm-uninline-large-generic-tlbh-functions
+++ a/include/asm-generic/tlb.h
@@ -96,134 +96,25 @@ struct mmu_gather {
 	struct page		*__pages[MMU_GATHER_BUNDLE];
 };
 
-/*
- * For UP we don't need to worry about TLB flush
- * and page free order so much..
- */
-#ifdef CONFIG_SMP
-  #define tlb_fast_mode(tlb) (tlb->fast_mode)
-#else
-  #define tlb_fast_mode(tlb) 1
-#endif
+#define HAVE_GENERIC_MMU_GATHER
 
-static inline int tlb_next_batch(struct mmu_gather *tlb)
+static inline int tlb_fast_mode(struct mmu_gather *tlb)
 {
-	struct mmu_gather_batch *batch;
-
-	batch = tlb->active;
-	if (batch->next) {
-		tlb->active = batch->next;
-		return 1;
-	}
-
-	batch = (void *)__get_free_pages(GFP_NOWAIT | __GFP_NOWARN, 0);
-	if (!batch)
-		return 0;
-
-	batch->next = NULL;
-	batch->nr   = 0;
-	batch->max  = MAX_GATHER_BATCH;
-
-	tlb->active->next = batch;
-	tlb->active = batch;
-
+#ifdef CONFIG_SMP
+	return tlb->fast_mode;
+#else
+	/*
+	 * For UP we don't need to worry about TLB flush
+	 * and page free order so much..
+	 */
 	return 1;
-}
-
-/* tlb_gather_mmu
- *	Called to initialize an (on-stack) mmu_gather structure for page-table
- *	tear-down from @mm. The @fullmm argument is used when @mm is without
- *	users and we're going to destroy the full address space (exit/execve).
- */
-static inline void
-tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, bool fullmm)
-{
-	tlb->mm = mm;
-
-	tlb->fullmm     = fullmm;
-	tlb->need_flush = 0;
-	tlb->fast_mode  = (num_possible_cpus() == 1);
-	tlb->local.next = NULL;
-	tlb->local.nr   = 0;
-	tlb->local.max  = ARRAY_SIZE(tlb->__pages);
-	tlb->active     = &tlb->local;
-
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
-	tlb->batch = NULL;
 #endif
 }
 
-static inline void
-tlb_flush_mmu(struct mmu_gather *tlb)
-{
-	struct mmu_gather_batch *batch;
-
-	if (!tlb->need_flush)
-		return;
-	tlb->need_flush = 0;
-	tlb_flush(tlb);
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
-	tlb_table_flush(tlb);
-#endif
-
-	if (tlb_fast_mode(tlb))
-		return;
-
-	for (batch = &tlb->local; batch; batch = batch->next) {
-		free_pages_and_swap_cache(batch->pages, batch->nr);
-		batch->nr = 0;
-	}
-	tlb->active = &tlb->local;
-}
-
-/* tlb_finish_mmu
- *	Called at the end of the shootdown operation to free up any resources
- *	that were required.
- */
-static inline void
-tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
-{
-	struct mmu_gather_batch *batch, *next;
-
-	tlb_flush_mmu(tlb);
-
-	/* keep the page table cache within bounds */
-	check_pgt_cache();
-
-	for (batch = tlb->local.next; batch; batch = next) {
-		next = batch->next;
-		free_pages((unsigned long)batch, 0);
-	}
-	tlb->local.next = NULL;
-}
-
-/* __tlb_remove_page
- *	Must perform the equivalent to __free_pte(pte_get_and_clear(ptep)), while
- *	handling the additional races in SMP caused by other CPUs caching valid
- *	mappings in their TLBs. Returns the number of free page slots left.
- *	When out of page slots we must call tlb_flush_mmu().
- */
-static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
-{
-	struct mmu_gather_batch *batch;
-
-	tlb->need_flush = 1;
-
-	if (tlb_fast_mode(tlb)) {
-		free_page_and_swap_cache(page);
-		return 1; /* avoid calling tlb_flush_mmu() */
-	}
-
-	batch = tlb->active;
-	batch->pages[batch->nr++] = page;
-	VM_BUG_ON(batch->nr > batch->max);
-	if (batch->nr == batch->max) {
-		if (!tlb_next_batch(tlb))
-			return 0;
-	}
-
-	return batch->max - batch->nr;
-}
+void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, bool fullmm);
+void tlb_flush_mmu(struct mmu_gather *tlb);
+void tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end);
+int __tlb_remove_page(struct mmu_gather *tlb, struct page *page);
 
 /* tlb_remove_page
  *	Similar to __tlb_remove_page but will call tlb_flush_mmu() itself when
diff -puN mm/memory.c~mm-uninline-large-generic-tlbh-functions mm/memory.c
--- a/mm/memory.c~mm-uninline-large-generic-tlbh-functions
+++ a/mm/memory.c
@@ -182,7 +182,7 @@ void sync_mm_rss(struct task_struct *tas
 {
 	__sync_task_rss_stat(task, mm);
 }
-#else
+#else /* SPLIT_RSS_COUNTING */
 
 #define inc_mm_counter_fast(mm, member) inc_mm_counter(mm, member)
 #define dec_mm_counter_fast(mm, member) dec_mm_counter(mm, member)
@@ -191,7 +191,127 @@ static void check_sync_rss_stat(struct t
 {
 }
 
+#endif /* SPLIT_RSS_COUNTING */
+
+#ifdef HAVE_GENERIC_MMU_GATHER
+
+static int tlb_next_batch(struct mmu_gather *tlb)
+{
+	struct mmu_gather_batch *batch;
+
+	batch = tlb->active;
+	if (batch->next) {
+		tlb->active = batch->next;
+		return 1;
+	}
+
+	batch = (void *)__get_free_pages(GFP_NOWAIT | __GFP_NOWARN, 0);
+	if (!batch)
+		return 0;
+
+	batch->next = NULL;
+	batch->nr   = 0;
+	batch->max  = MAX_GATHER_BATCH;
+
+	tlb->active->next = batch;
+	tlb->active = batch;
+
+	return 1;
+}
+
+/* tlb_gather_mmu
+ *	Called to initialize an (on-stack) mmu_gather structure for page-table
+ *	tear-down from @mm. The @fullmm argument is used when @mm is without
+ *	users and we're going to destroy the full address space (exit/execve).
+ */
+void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, bool fullmm)
+{
+	tlb->mm = mm;
+
+	tlb->fullmm     = fullmm;
+	tlb->need_flush = 0;
+	tlb->fast_mode  = (num_possible_cpus() == 1);
+	tlb->local.next = NULL;
+	tlb->local.nr   = 0;
+	tlb->local.max  = ARRAY_SIZE(tlb->__pages);
+	tlb->active     = &tlb->local;
+
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+	tlb->batch = NULL;
 #endif
+}
+
+void tlb_flush_mmu(struct mmu_gather *tlb)
+{
+	struct mmu_gather_batch *batch;
+
+	if (!tlb->need_flush)
+		return;
+	tlb->need_flush = 0;
+	tlb_flush(tlb);
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+	tlb_table_flush(tlb);
+#endif
+
+	if (tlb_fast_mode(tlb))
+		return;
+
+	for (batch = &tlb->local; batch; batch = batch->next) {
+		free_pages_and_swap_cache(batch->pages, batch->nr);
+		batch->nr = 0;
+	}
+	tlb->active = &tlb->local;
+}
+
+/* tlb_finish_mmu
+ *	Called at the end of the shootdown operation to free up any resources
+ *	that were required.
+ */
+void tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
+{
+	struct mmu_gather_batch *batch, *next;
+
+	tlb_flush_mmu(tlb);
+
+	/* keep the page table cache within bounds */
+	check_pgt_cache();
+
+	for (batch = tlb->local.next; batch; batch = next) {
+		next = batch->next;
+		free_pages((unsigned long)batch, 0);
+	}
+	tlb->local.next = NULL;
+}
+
+/* __tlb_remove_page
+ *	Must perform the equivalent to __free_pte(pte_get_and_clear(ptep)), while
+ *	handling the additional races in SMP caused by other CPUs caching valid
+ *	mappings in their TLBs. Returns the number of free page slots left.
+ *	When out of page slots we must call tlb_flush_mmu().
+ */
+int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	struct mmu_gather_batch *batch;
+
+	tlb->need_flush = 1;
+
+	if (tlb_fast_mode(tlb)) {
+		free_page_and_swap_cache(page);
+		return 1; /* avoid calling tlb_flush_mmu() */
+	}
+
+	batch = tlb->active;
+	batch->pages[batch->nr++] = page;
+	if (batch->nr == batch->max) {
+		if (!tlb_next_batch(tlb))
+			return 0;
+	}
+	VM_BUG_ON(batch->nr > batch->max);
+
+	return batch->max - batch->nr;
+}
+
+#endif /* HAVE_GENERIC_MMU_GATHER */
 
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE
 
@@ -268,7 +388,7 @@ void tlb_remove_table(struct mmu_gather 
 		tlb_table_flush(tlb);
 }
 
-#endif
+#endif /* CONFIG_HAVE_RCU_TABLE_FREE */
 
 /*
  * If a p?d_bad entry is found while walking page tables, report
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
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
mm-uninline-large-generic-tlbh-functions.patch

