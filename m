Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3054C47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiLAAEd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiLAADI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:03:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D748C690
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C46B461E69
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B21C433D7;
        Thu,  1 Dec 2022 00:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852881;
        bh=LK1rOIIaeOmlZx+g9wnNXvQJPS1gsHukNLqQ3+SPh8M=;
        h=Date:To:From:Subject:From;
        b=syWe9Kcc0VsNGX/EPW0/GJQ9hFO0xarEcYf3x2YzRmZlTWVh244Bfx+dTXusaHHW5
         3Vl+B9TgSF7OzMybbk52kmMp7WYg/PzMyJEhrkVwkk8bXGVhX6pEW0FZaH+XF6uiCW
         J0yxr9ew8nOH0aCR9+tuGYua7lrs7V3HsGELX3j8=
Date:   Wed, 30 Nov 2022 16:01:20 -0800
To:     mm-commits@vger.kernel.org, nadav.amit@gmail.com, hughd@google.com,
        hannes@cmpxchg.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed.patch removed from -mm tree
Message-Id: <20221201000121.03B21C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: delay page_remove_rmap() until after the TLB has been flushed
has been removed from the -mm tree.  Its filename was
     mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: mm: delay page_remove_rmap() until after the TLB has been flushed
Date: Wed, 9 Nov 2022 12:30:51 -0800

When we remove a page table entry, we are very careful to only free the
page after we have flushed the TLB, because other CPUs could still be
using the page through stale TLB entries until after the flush.

However, we have removed the rmap entry for that page early, which means
that functions like folio_mkclean() would end up not serializing with the
page table lock because the page had already been made invisible to rmap.

And that is a problem, because while the TLB entry exists, we could end up
with the following situation:

 (a) one CPU could come in and clean it, never seeing our mapping of the
     page

 (b) another CPU could continue to use the stale and dirty TLB entry and
     continue to write to said page

resulting in a page that has been dirtied, but then marked clean again,
all while another CPU might have dirtied it some more.

End result: possibly lost dirty data.

This extends our current TLB gather infrastructure to optionally track a
"should I do a delayed page_remove_rmap() for this page after flushing the
TLB".  It uses the newly introduced 'encoded page pointer' to do that
without having to keep separate data around.

Note, this is complicated by a couple of issues:

 - we want to delay the rmap removal, but not past the page table lock,
   because that simplifies the memcg accounting

 - only SMP configurations want to delay TLB flushing, since on UP
   there are obviously no remote TLBs to worry about, and the page
   table lock means there are no preemption issues either

 - s390 has its own mmu_gather model that doesn't delay TLB flushing,
   and as a result also does not want the delayed rmap. As such, we can
   treat S390 like the UP case and use a common fallback for the "no
   delays" case.

 - we can track an enormous number of pages in our mmu_gather structure,
   with MAX_GATHER_BATCH_COUNT batches of MAX_TABLE_BATCH pages each,
   all set up to be approximately 10k pending pages.

   We do not want to have a huge number of batched pages that we then
   need to check for delayed rmap handling inside the page table lock.

Particularly that last point results in a noteworthy detail, where the
normal page batch gathering is limited once we have delayed rmaps pending,
in such a way that only the last batch (the so-called "active batch") in
the mmu_gather structure can have any delayed entries.

NOTE!  While the "possibly lost dirty data" sounds catastrophic, for this
all to happen you need to have a user thread doing either madvise() with
MADV_DONTNEED or a full re-mmap() of the area concurrently with another
thread continuing to use said mapping.

So arguably this is about user space doing crazy things, but from a VM
consistency standpoint it's better if we track the dirty bit properly even
when user space goes off the rails.

[akpm@linux-foundation.org: fix UP build, per Linus]
Link: https://lore.kernel.org/all/B88D3073-440A-41C7-95F4-895D3F657EF2@gmail.com/
Link: https://lkml.kernel.org/r/20221109203051.1835763-4-torvalds@linux-foundation.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hugh Dickins <hughd@google.com>
Reported-by: Nadav Amit <nadav.amit@gmail.com>
Tested-by: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/tlb.h |    3 +++
 include/asm-generic/tlb.h   |   31 +++++++++++++++++++++++++++++--
 mm/memory.c                 |   23 +++++++++++++++++------
 mm/mmu_gather.c             |   33 +++++++++++++++++++++++++++++++++
 4 files changed, 82 insertions(+), 8 deletions(-)

--- a/arch/s390/include/asm/tlb.h~mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed
+++ a/arch/s390/include/asm/tlb.h
@@ -41,6 +41,9 @@ static inline bool __tlb_remove_page_siz
  * Release the page cache reference for a pte removed by
  * tlb_ptep_clear_flush. In both flush modes the tlb for a page cache page
  * has already been freed, so just do free_page_and_swap_cache.
+ *
+ * s390 doesn't delay rmap removal, so there is nothing encoded in
+ * the page pointer.
  */
 static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
 					  struct encoded_page *page,
--- a/include/asm-generic/tlb.h~mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed
+++ a/include/asm-generic/tlb.h
@@ -263,6 +263,28 @@ struct mmu_gather_batch {
 extern bool __tlb_remove_page_size(struct mmu_gather *tlb,
 				   struct encoded_page *page,
 				   int page_size);
+
+#ifdef CONFIG_SMP
+/*
+ * This both sets 'delayed_rmap', and returns true. It would be an inline
+ * function, except we define it before the 'struct mmu_gather'.
+ */
+#define tlb_delay_rmap(tlb) (((tlb)->delayed_rmap = 1), true)
+extern void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma);
+#endif
+
+#endif
+
+/*
+ * We have a no-op version of the rmap removal that doesn't
+ * delay anything. That is used on S390, which flushes remote
+ * TLBs synchronously, and on UP, which doesn't have any
+ * remote TLBs to flush and is not preemptible due to this
+ * all happening under the page table lock.
+ */
+#ifndef tlb_delay_rmap
+#define tlb_delay_rmap(tlb) (false)
+static inline void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma) { }
 #endif
 
 /*
@@ -296,6 +318,11 @@ struct mmu_gather {
 	unsigned int		freed_tables : 1;
 
 	/*
+	 * Do we have pending delayed rmap removals?
+	 */
+	unsigned int		delayed_rmap : 1;
+
+	/*
 	 * at which levels have we cleared entries?
 	 */
 	unsigned int		cleared_ptes : 1;
@@ -440,9 +467,9 @@ static inline void tlb_remove_page_size(
 		tlb_flush_mmu(tlb);
 }
 
-static inline bool __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+static __always_inline bool __tlb_remove_page(struct mmu_gather *tlb, struct page *page, unsigned int flags)
 {
-	return __tlb_remove_page_size(tlb, encode_page(page, 0), PAGE_SIZE);
+	return __tlb_remove_page_size(tlb, encode_page(page, flags), PAGE_SIZE);
 }
 
 /* tlb_remove_page
--- a/mm/memory.c~mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed
+++ a/mm/memory.c
@@ -1374,6 +1374,8 @@ again:
 			break;
 
 		if (pte_present(ptent)) {
+			unsigned int delay_rmap;
+
 			page = vm_normal_page(vma, addr, ptent);
 			if (unlikely(!should_zap_page(details, page)))
 				continue;
@@ -1385,20 +1387,26 @@ again:
 			if (unlikely(!page))
 				continue;
 
+			delay_rmap = 0;
 			if (!PageAnon(page)) {
 				if (pte_dirty(ptent)) {
-					force_flush = 1;
 					set_page_dirty(page);
+					if (tlb_delay_rmap(tlb)) {
+						delay_rmap = 1;
+						force_flush = 1;
+					}
 				}
 				if (pte_young(ptent) &&
 				    likely(!(vma->vm_flags & VM_SEQ_READ)))
 					mark_page_accessed(page);
 			}
 			rss[mm_counter(page)]--;
-			page_remove_rmap(page, vma, false);
-			if (unlikely(page_mapcount(page) < 0))
-				print_bad_pte(vma, addr, ptent, page);
-			if (unlikely(__tlb_remove_page(tlb, page))) {
+			if (!delay_rmap) {
+				page_remove_rmap(page, vma, false);
+				if (unlikely(page_mapcount(page) < 0))
+					print_bad_pte(vma, addr, ptent, page);
+			}
+			if (unlikely(__tlb_remove_page(tlb, page, delay_rmap))) {
 				force_flush = 1;
 				addr += PAGE_SIZE;
 				break;
@@ -1455,8 +1463,11 @@ again:
 	arch_leave_lazy_mmu_mode();
 
 	/* Do the actual TLB flush before dropping ptl */
-	if (force_flush)
+	if (force_flush) {
 		tlb_flush_mmu_tlbonly(tlb);
+		if (tlb->delayed_rmap)
+			tlb_flush_rmaps(tlb, vma);
+	}
 	pte_unmap_unlock(start_pte, ptl);
 
 	/*
--- a/mm/mmu_gather.c~mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed
+++ a/mm/mmu_gather.c
@@ -9,6 +9,7 @@
 #include <linux/rcupdate.h>
 #include <linux/smp.h>
 #include <linux/swap.h>
+#include <linux/rmap.h>
 
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
@@ -19,6 +20,10 @@ static bool tlb_next_batch(struct mmu_ga
 {
 	struct mmu_gather_batch *batch;
 
+	/* No more batching if we have delayed rmaps pending */
+	if (tlb->delayed_rmap)
+		return false;
+
 	batch = tlb->active;
 	if (batch->next) {
 		tlb->active = batch->next;
@@ -43,6 +48,33 @@ static bool tlb_next_batch(struct mmu_ga
 	return true;
 }
 
+#ifdef CONFIG_SMP
+/**
+ * tlb_flush_rmaps - do pending rmap removals after we have flushed the TLB
+ * @tlb: the current mmu_gather
+ *
+ * Note that because of how tlb_next_batch() above works, we will
+ * never start new batches with pending delayed rmaps, so we only
+ * need to walk through the current active batch.
+ */
+void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma)
+{
+	struct mmu_gather_batch *batch;
+
+	batch = tlb->active;
+	for (int i = 0; i < batch->nr; i++) {
+		struct encoded_page *enc = batch->encoded_pages[i];
+
+		if (encoded_page_flags(enc)) {
+			struct page *page = encoded_page_ptr(enc);
+			page_remove_rmap(page, vma, false);
+		}
+	}
+
+	tlb->delayed_rmap = 0;
+}
+#endif
+
 static void tlb_batch_pages_flush(struct mmu_gather *tlb)
 {
 	struct mmu_gather_batch *batch;
@@ -284,6 +316,7 @@ static void __tlb_gather_mmu(struct mmu_
 	tlb->active     = &tlb->local;
 	tlb->batch_count = 0;
 #endif
+	tlb->delayed_rmap = 0;
 
 	tlb_table_init(tlb);
 #ifdef CONFIG_MMU_GATHER_PAGE_SIZE
_

Patches currently in -mm which might be from torvalds@linux-foundation.org are


