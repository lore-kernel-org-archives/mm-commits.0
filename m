From: akpm@linux-foundation.org
Subject: + mm-extended-batches-for-generic-mmu_gather.patch added to -mm tree
Date: Tue, 19 Apr 2011 13:10:29 -0700
Message-ID: <201104192010.p3JKAUmH020503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931Ab1DSULW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Apr 2011 16:11:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, hughd@google.com, jdike@addtoit.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lethal@linux-sh.org, mel@csn.ul.ie, namhyung@gmail.com, npiggin@kernel.dk, richard@nod.at, rmk@arm.linux.org.uk, schwidefsky@de.ibm.com, tony.luck@intel.com


The patch titled
     mm: Extended batches for generic mmu_gather
has been added to the -mm tree.  Its filename is
     mm-extended-batches-for-generic-mmu_gather.patch

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
Subject: mm: Extended batches for generic mmu_gather
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Instead of using a single batch (the small on-stack, or an allocated
page), try and extend the batch every time it runs out and only flush once
either the extend fails or we're done.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Requested-by: Nick Piggin <npiggin@kernel.dk>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |  129 +++++++++++++++++++++++-------------
 1 file changed, 83 insertions(+), 46 deletions(-)

diff -puN include/asm-generic/tlb.h~mm-extended-batches-for-generic-mmu_gather include/asm-generic/tlb.h
--- a/include/asm-generic/tlb.h~mm-extended-batches-for-generic-mmu_gather
+++ a/include/asm-generic/tlb.h
@@ -19,16 +19,6 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
-/*
- * For UP we don't need to worry about TLB flush
- * and page free order so much..
- */
-#ifdef CONFIG_SMP
-  #define tlb_fast_mode(tlb) ((tlb)->nr == ~0U)
-#else
-  #define tlb_fast_mode(tlb) 1
-#endif
-
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE
 /*
  * Semi RCU freeing of the page directories.
@@ -78,6 +68,16 @@ extern void tlb_remove_table(struct mmu_
  */
 #define MMU_GATHER_BUNDLE	8
 
+struct mmu_gather_batch {
+	struct mmu_gather_batch	*next;
+	unsigned int		nr;
+	unsigned int		max;
+	struct page		*pages[0];
+};
+
+#define MAX_GATHER_BATCH	\
+	((PAGE_SIZE - sizeof(struct mmu_gather_batch)) / sizeof(void *))
+
 /* struct mmu_gather is an opaque type used by the mm code for passing around
  * any data needed by arch specific code for tlb_remove_page.
  */
@@ -86,22 +86,48 @@ struct mmu_gather {
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE
 	struct mmu_table_batch	*batch;
 #endif
-	unsigned int		nr;	/* set to ~0U means fast mode */
-	unsigned int		max;	/* nr < max */
-	unsigned int		need_flush;/* Really unmapped some ptes? */
-	unsigned int		fullmm; /* non-zero means full mm flush */
-	struct page		**pages;
-	struct page		*local[MMU_GATHER_BUNDLE];
+	unsigned int		need_flush : 1,	/* Did free PTEs */
+				fast_mode  : 1; /* No batching   */
+
+	unsigned int		fullmm;
+
+	struct mmu_gather_batch *active;
+	struct mmu_gather_batch	local;
+	struct page		*__pages[MMU_GATHER_BUNDLE];
 };
 
-static inline void __tlb_alloc_page(struct mmu_gather *tlb)
+/*
+ * For UP we don't need to worry about TLB flush
+ * and page free order so much..
+ */
+#ifdef CONFIG_SMP
+  #define tlb_fast_mode(tlb) (tlb->fast_mode)
+#else
+  #define tlb_fast_mode(tlb) 1
+#endif
+
+static inline int tlb_next_batch(struct mmu_gather *tlb)
 {
-	unsigned long addr = __get_free_pages(GFP_NOWAIT | __GFP_NOWARN, 0);
+	struct mmu_gather_batch *batch;
 
-	if (addr) {
-		tlb->pages = (void *)addr;
-		tlb->max = PAGE_SIZE / sizeof(struct page *);
+	batch = tlb->active;
+	if (batch->next) {
+		tlb->active = batch->next;
+		return 1;
 	}
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
 }
 
 /* tlb_gather_mmu
@@ -114,16 +140,13 @@ tlb_gather_mmu(struct mmu_gather *tlb, s
 {
 	tlb->mm = mm;
 
-	tlb->max = ARRAY_SIZE(tlb->local);
-	tlb->pages = tlb->local;
-
-	if (num_online_cpus() > 1) {
-		tlb->nr = 0;
-		__tlb_alloc_page(tlb);
-	} else /* Use fast mode if only one CPU is online */
-		tlb->nr = ~0U;
-
-	tlb->fullmm = fullmm;
+	tlb->fullmm     = fullmm;
+	tlb->need_flush = 0;
+	tlb->fast_mode  = (num_possible_cpus() == 1);
+	tlb->local.next = NULL;
+	tlb->local.nr   = 0;
+	tlb->local.max  = ARRAY_SIZE(tlb->__pages);
+	tlb->active     = &tlb->local;
 
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE
 	tlb->batch = NULL;
@@ -133,6 +156,8 @@ tlb_gather_mmu(struct mmu_gather *tlb, s
 static inline void
 tlb_flush_mmu(struct mmu_gather *tlb)
 {
+	struct mmu_gather_batch *batch;
+
 	if (!tlb->need_flush)
 		return;
 	tlb->need_flush = 0;
@@ -140,17 +165,15 @@ tlb_flush_mmu(struct mmu_gather *tlb)
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE
 	tlb_table_flush(tlb);
 #endif
-	if (!tlb_fast_mode(tlb)) {
-		free_pages_and_swap_cache(tlb->pages, tlb->nr);
-		tlb->nr = 0;
-		/*
-		 * If we are using the local on-stack array of pages for MMU
-		 * gather, try allocating an off-stack array again as we have
-		 * recently freed pages.
-		 */
-		if (tlb->pages == tlb->local)
-			__tlb_alloc_page(tlb);
+
+	if (tlb_fast_mode(tlb))
+		return;
+
+	for (batch = &tlb->local; batch; batch = batch->next) {
+		free_pages_and_swap_cache(batch->pages, batch->nr);
+		batch->nr = 0;
 	}
+	tlb->active = &tlb->local;
 }
 
 /* tlb_finish_mmu
@@ -160,13 +183,18 @@ tlb_flush_mmu(struct mmu_gather *tlb)
 static inline void
 tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 {
+	struct mmu_gather_batch *batch, *next;
+
 	tlb_flush_mmu(tlb);
 
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
 
-	if (tlb->pages != tlb->local)
-		free_pages((unsigned long)tlb->pages, 0);
+	for (batch = tlb->local.next; batch; batch = next) {
+		next = batch->next;
+		free_pages((unsigned long)batch, 0);
+	}
+	tlb->local.next = NULL;
 }
 
 /* __tlb_remove_page
@@ -177,15 +205,24 @@ tlb_finish_mmu(struct mmu_gather *tlb, u
  */
 static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
+	struct mmu_gather_batch *batch;
+
 	tlb->need_flush = 1;
+
 	if (tlb_fast_mode(tlb)) {
 		free_page_and_swap_cache(page);
 		return 1; /* avoid calling tlb_flush_mmu() */
 	}
-	tlb->pages[tlb->nr++] = page;
-	VM_BUG_ON(tlb->nr > tlb->max);
 
-	return tlb->max - tlb->nr;
+	batch = tlb->active;
+	batch->pages[batch->nr++] = page;
+	VM_BUG_ON(batch->nr > batch->max);
+	if (batch->nr == batch->max) {
+		if (!tlb_next_batch(tlb))
+			return 0;
+	}
+
+	return batch->max - batch->nr;
 }
 
 /* tlb_remove_page
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

