Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D80C43217
	for <mm-commits@archiver.kernel.org>; Fri,  4 Nov 2022 22:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiKDWxt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Nov 2022 18:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiKDWxS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Nov 2022 18:53:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063864E409
        for <mm-commits@vger.kernel.org>; Fri,  4 Nov 2022 15:52:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85EB9B8301B
        for <mm-commits@vger.kernel.org>; Fri,  4 Nov 2022 22:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3EBC4314F;
        Fri,  4 Nov 2022 22:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667602362;
        bh=IKosJy/clSXoMJ9xOwk+jZCtwis+H2AH0AexetJJeV8=;
        h=Date:To:From:Subject:From;
        b=aqxc9W3R4TxiTorzDDBs0VZKZfSO0txbPhfZQZe/QCWCuD8ZqoYKGPslha6d2srqv
         pClUGZIypWyVBdkowxo7MkVN8LRQXJyY2g1HKjCEHanWa3iT/C1uq5ZxKpdj4Ll0tl
         2OL8Ny4OonId/xFrWaBnX5rsMoWimR6ZoOv/ykxA=
Date:   Fri, 04 Nov 2022 15:52:41 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, svens@linux.ibm.com,
        peterz@infradead.org, npiggin@gmail.com, nadav.amit@gmail.com,
        jhubbard@nvidia.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, borntraeger@linux.ibm.com,
        aneesh.kumar@linux.ibm.com, agordeev@linux.ibm.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-delay-rmap-removal-until-after-tlb-flush.patch added to mm-unstable branch
Message-Id: <20221104225242.1B3EBC4314F@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: delay rmap removal until after TLB flush
has been added to the -mm mm-unstable branch.  Its filename is
     mm-delay-rmap-removal-until-after-tlb-flush.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-delay-rmap-removal-until-after-tlb-flush.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: mm: delay rmap removal until after TLB flush
Date: Sat Oct 29 11:45:07 2022 -0700

When we remove a page table entry, we are very careful to only free the
page after we have flushed the TLB, because other CPUs could still be
using the page through stale TLB entries until after the flush.

However, we have removed the rmap entry for that page early, which means
that functions like folio_mkclean() would end up not serializing with the
page table lock because the page had already been made invisible to rmap.

And that is a problem, because while the TLB entry exists, we could end up
with the following situation:

 (a) one CPU could come in and clean it, never seeing our mapping of
     the page

 (b) another CPU could continue to use the stale and dirty TLB entry
     and continue to write to said page

resulting in a page that has been dirtied, but then marked clean again,
all while another CPU might have dirtied it some more.

End result: possibly lost dirty data.

This commit uses the same old TLB gather array that we use to delay the
freeing of the page to also say 'remove from rmap after flush', so that we
can keep the rmap entries alive until all TLB entries have been flushed.

It might be worth noting that this means that the page_zap_pte_rmap() is
now called outside the page table lock.  That was never mutual exclusion
(since the same page could be mapped under multiple different page
tables), but it does mean that it needs to use the more careful version of
dec_lruvec_page_state() that doesn't depend on being called in a
non-preemptable context.

NOTE!  While the "possibly lost dirty data" sounds catastrophic, for this
all to happen you need to have a user thread doing either madvise() with
MADV_DONTNEED or a full re-mmap() of the area concurrently with another
thread continuing to use said mapping.

So arguably this is about user space doing crazy things, but from a VM
consistency standpoint it's better if we track the dirty bit properly even
when user space goes off the rails.

Reported-by: Nadav Amit <nadav.amit@gmail.com>
Link: https://lore.kernel.org/all/B88D3073-440A-41C7-95F4-895D3F657EF2@gmail.com/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com> # s390
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar <aneesh.kumar@linux.ibm.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/tlb.h |   10 ++++++--
 include/asm-generic/tlb.h   |   39 ++++++++++++++++++++++++++-----
 mm/memory.c                 |    5 ----
 mm/mmu_gather.c             |   42 ++++++++++++++++++++++++++++++----
 mm/rmap.c                   |    4 ---
 5 files changed, 81 insertions(+), 19 deletions(-)

--- a/arch/s390/include/asm/tlb.h~mm-delay-rmap-removal-until-after-tlb-flush
+++ a/arch/s390/include/asm/tlb.h
@@ -25,7 +25,8 @@
 void __tlb_remove_table(void *_table);
 static inline void tlb_flush(struct mmu_gather *tlb);
 static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
-					  struct page *page, int page_size);
+					  struct page *page, int page_size,
+					  unsigned int flags);
 
 #define tlb_flush tlb_flush
 #define pte_free_tlb pte_free_tlb
@@ -36,14 +37,19 @@ static inline bool __tlb_remove_page_siz
 #include <asm/tlbflush.h>
 #include <asm-generic/tlb.h>
 
+void page_zap_pte_rmap(struct page *);
+
 /*
  * Release the page cache reference for a pte removed by
  * tlb_ptep_clear_flush. In both flush modes the tlb for a page cache page
  * has already been freed, so just do free_page_and_swap_cache.
  */
 static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
-					  struct page *page, int page_size)
+					  struct page *page, int page_size,
+					  unsigned int flags)
 {
+	if (flags & TLB_ZAP_RMAP)
+		page_zap_pte_rmap(page);
 	free_page_and_swap_cache(page);
 	return false;
 }
--- a/include/asm-generic/tlb.h~mm-delay-rmap-removal-until-after-tlb-flush
+++ a/include/asm-generic/tlb.h
@@ -73,7 +73,8 @@
  *    __tlb_remove_page_size() is the basic primitive that queues a page for
  *    freeing. __tlb_remove_page() assumes PAGE_SIZE. Both will return a
  *    boolean indicating if the queue is (now) full and a call to
- *    tlb_flush_mmu() is required.
+ *    tlb_flush_mmu() is required. They take a 'flags' parameter that
+ *    states whether the rmap of the page should be removed after TLB flush.
  *
  *    tlb_remove_page() and tlb_remove_page_size() imply the call to
  *    tlb_flush_mmu() when required and has no return value.
@@ -187,6 +188,7 @@
  *  This is useful if your architecture already flushes TLB entries in the
  *  various ptep_get_and_clear() functions.
  */
+#define TLB_ZAP_RMAP 1ul
 
 #ifdef CONFIG_MMU_GATHER_TABLE_FREE
 
@@ -238,11 +240,36 @@ extern void tlb_remove_table(struct mmu_
  */
 #define MMU_GATHER_BUNDLE	8
 
+/*
+ * Fake type for an encoded page with flag bits in the low bits.
+ *
+ * Right now just one bit, but we could have more depending on the
+ * alignment of 'struct page'.
+ */
+struct encoded_page;
+#define ENCODE_PAGE_BITS (TLB_ZAP_RMAP)
+
+static inline struct encoded_page *encode_page(struct page *page, unsigned long flags)
+{
+	flags &= ENCODE_PAGE_BITS;
+	return (struct encoded_page *)(flags | (unsigned long)page);
+}
+
+static inline bool encoded_page_flags(struct encoded_page *page)
+{
+	return ENCODE_PAGE_BITS & (unsigned long)page;
+}
+
+static inline struct page *encoded_page_ptr(struct encoded_page *page)
+{
+	return (struct page *)(~ENCODE_PAGE_BITS & (unsigned long)page);
+}
+
 struct mmu_gather_batch {
 	struct mmu_gather_batch	*next;
 	unsigned int		nr;
 	unsigned int		max;
-	struct page		*pages[];
+	struct encoded_page	*encoded_pages[];
 };
 
 #define MAX_GATHER_BATCH	\
@@ -257,7 +284,7 @@ struct mmu_gather_batch {
 #define MAX_GATHER_BATCH_COUNT	(10000UL/MAX_GATHER_BATCH)
 
 extern bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
-				   int page_size);
+				   int page_size, unsigned int flags);
 #endif
 
 /*
@@ -431,13 +458,13 @@ static inline void tlb_flush_mmu_tlbonly
 static inline void tlb_remove_page_size(struct mmu_gather *tlb,
 					struct page *page, int page_size)
 {
-	if (__tlb_remove_page_size(tlb, page, page_size))
+	if (__tlb_remove_page_size(tlb, page, page_size, 0))
 		tlb_flush_mmu(tlb);
 }
 
-static inline bool __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+static inline bool __tlb_remove_page(struct mmu_gather *tlb, struct page *page, unsigned int flags)
 {
-	return __tlb_remove_page_size(tlb, page, PAGE_SIZE);
+	return __tlb_remove_page_size(tlb, page, PAGE_SIZE, flags);
 }
 
 /* tlb_remove_page
--- a/mm/memory.c~mm-delay-rmap-removal-until-after-tlb-flush
+++ a/mm/memory.c
@@ -1403,12 +1403,9 @@ again:
 				    likely(!(vma->vm_flags & VM_SEQ_READ)))
 					mark_page_accessed(page);
 			}
-			page_zap_pte_rmap(page);
 			munlock_vma_page(page, vma, false);
 			rss[mm_counter(page)]--;
-			if (unlikely(page_mapcount(page) < 0))
-				print_bad_pte(vma, addr, ptent, page);
-			if (unlikely(__tlb_remove_page(tlb, page))) {
+			if (unlikely(__tlb_remove_page(tlb, page, TLB_ZAP_RMAP))) {
 				force_flush = 1;
 				addr += PAGE_SIZE;
 				break;
--- a/mm/mmu_gather.c~mm-delay-rmap-removal-until-after-tlb-flush
+++ a/mm/mmu_gather.c
@@ -9,6 +9,7 @@
 #include <linux/rcupdate.h>
 #include <linux/smp.h>
 #include <linux/swap.h>
+#include <linux/rmap.h>
 
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
@@ -43,12 +44,44 @@ static bool tlb_next_batch(struct mmu_ga
 	return true;
 }
 
+/*
+ * We get an 'encoded page' array, which has page pointers with
+ * encoded flags in the low bits of the array.
+ *
+ * The TLB has been flushed, now we need to react to the flag bits
+ * the 'struct page', clean the array in-place, and then free the
+ * pages and their swap cache.
+ */
+static void clean_and_free_pages_and_swap_cache(struct encoded_page **pages, unsigned int nr)
+{
+	for (unsigned int i = 0; i < nr; i++) {
+		struct encoded_page *encoded = pages[i];
+		unsigned int flags = encoded_page_flags(encoded);
+		if (flags) {
+			/* Clean the flagged pointer in-place */
+			struct page *page = encoded_page_ptr(encoded);
+			pages[i] = encode_page(page, 0);
+
+			/* The flag bit being set means that we should zap the rmap */
+			page_zap_pte_rmap(page);
+			VM_WARN_ON_ONCE_PAGE(page_mapcount(page) < 0, page);
+		}
+	}
+
+	/*
+	 * Now all entries have been un-encoded, and changed to plain
+	 * page pointers, so we can cast the 'encoded_page' array to
+	 * a plain page array and free them
+	 */
+	free_pages_and_swap_cache((struct page **)pages, nr);
+}
+
 static void tlb_batch_pages_flush(struct mmu_gather *tlb)
 {
 	struct mmu_gather_batch *batch;
 
 	for (batch = &tlb->local; batch && batch->nr; batch = batch->next) {
-		struct page **pages = batch->pages;
+		struct encoded_page **pages = batch->encoded_pages;
 
 		do {
 			/*
@@ -56,7 +89,7 @@ static void tlb_batch_pages_flush(struct
 			 */
 			unsigned int nr = min(512U, batch->nr);
 
-			free_pages_and_swap_cache(pages, nr);
+			clean_and_free_pages_and_swap_cache(pages, nr);
 			pages += nr;
 			batch->nr -= nr;
 
@@ -77,11 +110,12 @@ static void tlb_batch_list_free(struct m
 	tlb->local.next = NULL;
 }
 
-bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page, int page_size)
+bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page, int page_size, unsigned int flags)
 {
 	struct mmu_gather_batch *batch;
 
 	VM_BUG_ON(!tlb->end);
+	VM_BUG_ON(flags & ~ENCODE_PAGE_BITS);
 
 #ifdef CONFIG_MMU_GATHER_PAGE_SIZE
 	VM_WARN_ON(tlb->page_size != page_size);
@@ -92,7 +126,7 @@ bool __tlb_remove_page_size(struct mmu_g
 	 * Add the page and check if we are full. If so
 	 * force a flush.
 	 */
-	batch->pages[batch->nr++] = page;
+	batch->encoded_pages[batch->nr++] = encode_page(page, flags);
 	if (batch->nr == batch->max) {
 		if (!tlb_next_batch(tlb))
 			return true;
--- a/mm/rmap.c~mm-delay-rmap-removal-until-after-tlb-flush
+++ a/mm/rmap.c
@@ -1422,8 +1422,6 @@ static void page_remove_anon_compound_rm
  * separately.
  *
  * This allows for a much simpler calling convention and code.
- *
- * The caller holds the pte lock.
  */
 void page_zap_pte_rmap(struct page *page)
 {
@@ -1431,7 +1429,7 @@ void page_zap_pte_rmap(struct page *page
 		return;
 
 	lock_page_memcg(page);
-	__dec_lruvec_page_state(page,
+	dec_lruvec_page_state(page,
 		PageAnon(page) ? NR_ANON_MAPPED : NR_FILE_MAPPED);
 	unlock_page_memcg(page);
 }
_

Patches currently in -mm which might be from torvalds@linux-foundation.org are

mm-introduce-simplified-versions-of-page_remove_rmap.patch
mm-inline-simpler-case-of-page_remove_file_rmap.patch
mm-re-unify-the-simplified-page_zap__rmap-function.patch
mm-delay-rmap-removal-until-after-tlb-flush.patch

