Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E205DC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 23:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235537AbiFQXOc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 19:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235634AbiFQXOX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 19:14:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA215DE6D
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 16:14:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C086161698
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 23:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259E9C3411B;
        Fri, 17 Jun 2022 23:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655507661;
        bh=p9i5mr7PyuuZOPH3OV2P2skBOJr8fWKmKQBEKvJA/Eo=;
        h=Date:To:From:Subject:From;
        b=VmlhwL5cQM3vlL47z+pMeNHMhlv6ybcLwctZrCCUJ+cvnrjDU+vEL7E+OqUbZPmQh
         Px4bjxe1rfnt654KoE7U8vUs7bdpq6laWFF9XuNmeYiadQobtN76GIAD5KItmc1L2O
         mw77NY6IVze3BQUY5nawnCVG7leWgmctU+hMH6jQ=
Date:   Fri, 17 Jun 2022 16:14:20 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-convert-lru_add-to-a-folio_batch.patch added to mm-unstable branch
Message-Id: <20220617231421.259E9C3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: convert lru_add to a folio_batch
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-convert-lru_add-to-a-folio_batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-convert-lru_add-to-a-folio_batch.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/swap: convert lru_add to a folio_batch
Date: Fri, 17 Jun 2022 18:50:02 +0100

When adding folios to the LRU for the first time, the LRU flag will
already be clear, so skip the test-and-clear part of moving from one
LRU to another.

Removes 285 bytes from kernel text, mostly due to removing
__pagevec_lru_add().

Link: https://lkml.kernel.org/r/20220617175020.717127-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   75 ++++++++++++++++++----------------------------------
 1 file changed, 26 insertions(+), 49 deletions(-)

--- a/mm/swap.c~mm-swap-convert-lru_add-to-a-folio_batch
+++ a/mm/swap.c
@@ -61,7 +61,7 @@ static DEFINE_PER_CPU(struct lru_rotate,
  */
 struct lru_pvecs {
 	local_lock_t lock;
-	struct pagevec lru_add;
+	struct folio_batch lru_add;
 	struct pagevec lru_deactivate_file;
 	struct pagevec lru_deactivate;
 	struct pagevec lru_lazyfree;
@@ -228,14 +228,13 @@ static bool pagevec_add_and_need_flush(s
 
 typedef void (*move_fn_t)(struct lruvec *lruvec, struct folio *folio);
 
-static void __pagevec_lru_add_fn(struct folio *folio, struct lruvec *lruvec)
+static void lru_add_fn(struct lruvec *lruvec, struct folio *folio)
 {
 	int was_unevictable = folio_test_clear_unevictable(folio);
 	long nr_pages = folio_nr_pages(folio);
 
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
-	folio_set_lru(folio);
 	/*
 	 * Is an smp_mb__after_atomic() still required here, before
 	 * folio_evictable() tests PageMlocked, to rule out the possibility
@@ -269,28 +268,6 @@ static void __pagevec_lru_add_fn(struct
 	trace_mm_lru_insertion(folio);
 }
 
-/*
- * Add the passed pages to the LRU, then drop the caller's refcount
- * on them.  Reinitialises the caller's pagevec.
- */
-static void __pagevec_lru_add(struct pagevec *pvec)
-{
-	int i;
-	struct lruvec *lruvec = NULL;
-	unsigned long flags = 0;
-
-	for (i = 0; i < pagevec_count(pvec); i++) {
-		struct folio *folio = page_folio(pvec->pages[i]);
-
-		lruvec = folio_lruvec_relock_irqsave(folio, lruvec, &flags);
-		__pagevec_lru_add_fn(folio, lruvec);
-	}
-	if (lruvec)
-		unlock_page_lruvec_irqrestore(lruvec, flags);
-	release_pages(pvec->pages, pvec->nr);
-	pagevec_reinit(pvec);
-}
-
 static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 {
 	int i;
@@ -301,7 +278,7 @@ static void folio_batch_move_lru(struct
 		struct folio *folio = fbatch->folios[i];
 
 		/* block memcg migration while the folio moves between lru */
-		if (!folio_test_clear_lru(folio))
+		if (move_fn != lru_add_fn && !folio_test_clear_lru(folio))
 			continue;
 
 		lruvec = folio_lruvec_relock_irqsave(folio, lruvec, &flags);
@@ -473,26 +450,26 @@ static void folio_activate(struct folio
 
 static void __lru_cache_activate_folio(struct folio *folio)
 {
-	struct pagevec *pvec;
+	struct folio_batch *fbatch;
 	int i;
 
 	local_lock(&lru_pvecs.lock);
-	pvec = this_cpu_ptr(&lru_pvecs.lru_add);
+	fbatch = this_cpu_ptr(&lru_pvecs.lru_add);
 
 	/*
-	 * Search backwards on the optimistic assumption that the page being
-	 * activated has just been added to this pagevec. Note that only
-	 * the local pagevec is examined as a !PageLRU page could be in the
+	 * Search backwards on the optimistic assumption that the folio being
+	 * activated has just been added to this batch. Note that only
+	 * the local batch is examined as a !LRU folio could be in the
 	 * process of being released, reclaimed, migrated or on a remote
-	 * pagevec that is currently being drained. Furthermore, marking
-	 * a remote pagevec's page PageActive potentially hits a race where
-	 * a page is marked PageActive just after it is added to the inactive
+	 * batch that is currently being drained. Furthermore, marking
+	 * a remote batch's folio active potentially hits a race where
+	 * a folio is marked active just after it is added to the inactive
 	 * list causing accounting errors and BUG_ON checks to trigger.
 	 */
-	for (i = pagevec_count(pvec) - 1; i >= 0; i--) {
-		struct page *pagevec_page = pvec->pages[i];
+	for (i = folio_batch_count(fbatch) - 1; i >= 0; i--) {
+		struct folio *batch_folio = fbatch->folios[i];
 
-		if (pagevec_page == &folio->page) {
+		if (batch_folio == folio) {
 			folio_set_active(folio);
 			break;
 		}
@@ -551,16 +528,16 @@ EXPORT_SYMBOL(folio_mark_accessed);
  */
 void folio_add_lru(struct folio *folio)
 {
-	struct pagevec *pvec;
+	struct folio_batch *fbatch;
 
-	VM_BUG_ON_FOLIO(folio_test_active(folio) && folio_test_unevictable(folio), folio);
+	VM_BUG_ON_FOLIO(folio_test_active(folio) &&
+			folio_test_unevictable(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
 	folio_get(folio);
 	local_lock(&lru_pvecs.lock);
-	pvec = this_cpu_ptr(&lru_pvecs.lru_add);
-	if (pagevec_add_and_need_flush(pvec, &folio->page))
-		__pagevec_lru_add(pvec);
+	fbatch = this_cpu_ptr(&lru_pvecs.lru_add);
+	folio_batch_add_and_move(fbatch, folio, lru_add_fn);
 	local_unlock(&lru_pvecs.lock);
 }
 EXPORT_SYMBOL(folio_add_lru);
@@ -691,11 +668,11 @@ static void lru_lazyfree_fn(struct page
  */
 void lru_add_drain_cpu(int cpu)
 {
-	struct folio_batch *fbatch;
-	struct pagevec *pvec = &per_cpu(lru_pvecs.lru_add, cpu);
+	struct folio_batch *fbatch = &per_cpu(lru_pvecs.lru_add, cpu);
+	struct pagevec *pvec;
 
-	if (pagevec_count(pvec))
-		__pagevec_lru_add(pvec);
+	if (folio_batch_count(fbatch))
+		folio_batch_move_lru(fbatch, lru_add_fn);
 
 	fbatch = &per_cpu(lru_rotate.fbatch, cpu);
 	/* Disabling interrupts below acts as a compiler barrier. */
@@ -920,7 +897,7 @@ static inline void __lru_add_drain_all(b
 	for_each_online_cpu(cpu) {
 		struct work_struct *work = &per_cpu(lru_add_drain_work, cpu);
 
-		if (pagevec_count(&per_cpu(lru_pvecs.lru_add, cpu)) ||
+		if (folio_batch_count(&per_cpu(lru_pvecs.lru_add, cpu)) ||
 		    data_race(folio_batch_count(&per_cpu(lru_rotate.fbatch, cpu))) ||
 		    pagevec_count(&per_cpu(lru_pvecs.lru_deactivate_file, cpu)) ||
 		    pagevec_count(&per_cpu(lru_pvecs.lru_deactivate, cpu)) ||
@@ -1084,8 +1061,8 @@ EXPORT_SYMBOL(release_pages);
  * OK from a correctness point of view but is inefficient - those pages may be
  * cache-warm and we want to give them back to the page allocator ASAP.
  *
- * So __pagevec_release() will drain those queues here.  __pagevec_lru_add()
- * and __pagevec_lru_add_active() call release_pages() directly to avoid
+ * So __pagevec_release() will drain those queues here.
+ * folio_batch_move_lru() calls folios_put() directly to avoid
  * mutual recursion.
  */
 void __pagevec_release(struct pagevec *pvec)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch
mm-vmscan-convert-reclaim_clean_pages_from_list-to-folios.patch
mm-vmscan-convert-isolate_lru_pages-to-use-a-folio.patch
mm-vmscan-convert-move_pages_to_lru-to-use-a-folio.patch
mm-vmscan-convert-shrink_active_list-to-use-a-folio.patch
mm-vmscan-convert-reclaim_pages-to-use-a-folio.patch
mm-add-folios_put.patch
mm-swap-add-folio_batch_move_lru.patch
mm-swap-make-__pagevec_lru_add-static.patch
mm-swap-convert-lru_add-to-a-folio_batch.patch
mm-swap-convert-lru_deactivate_file-to-a-folio_batch.patch
mm-swap-convert-lru_deactivate-to-a-folio_batch.patch
mm-swap-convert-lru_lazyfree-to-a-folio_batch.patch
mm-swap-convert-activate_page-to-a-folio_batch.patch
mm-swap-rename-lru_pvecs-to-cpu_fbatches.patch
mm-swap-pull-the-cpu-conditional-out-of-__lru_add_drain_all.patch
mm-swap-optimise-lru_add_drain_cpu.patch
mm-swap-convert-try_to_free_swap-to-use-a-folio.patch
mm-swap-convert-release_pages-to-use-a-folio-internally.patch
mm-swap-convert-put_pages_list-to-use-folios.patch
mm-swap-convert-__put_page-to-__folio_put.patch
mm-swap-convert-__put_single_page-to-__folio_put_small.patch
mm-swap-convert-__put_compound_page-to-__folio_put_large.patch
mm-swap-convert-__page_cache_release-to-use-a-folio.patch
mm-convert-destroy_compound_page-to-destroy_large_folio.patch
mm-convert-page_swap_flags-to-folio_swap_flags.patch
mm-swap-convert-delete_from_swap_cache-to-take-a-folio.patch
mm-swap-convert-__delete_from_swap_cache-to-a-folio.patch

