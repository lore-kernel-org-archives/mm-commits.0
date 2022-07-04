Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C65C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbiGDBLj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbiGDBKw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:10:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFBD6346
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58DF1B80BEB
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0352EC341C6;
        Mon,  4 Jul 2022 01:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897029;
        bh=w97d9zeNkF0bKshlA0ZdvlF9kOvFeo9Uv0oixBvCudc=;
        h=Date:To:From:Subject:From;
        b=PMkvlBMysIWn2MiCMdo36WiOiTdREWPDI+9MzYSGzFsk/8Qy0sdHgdyVdMITVTjBJ
         Df0AsfcLEINRHDs3jxoDjCsy0+eLr7iH8IgFkOcuCpo6XlS/ULTm7uu6FRoyT7sjt8
         bY0dtWaCeBGf8LXb4W/+cjyxC/sKZVFnF5Fo+PzQ=
Date:   Sun, 03 Jul 2022 18:10:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-convert-activate_page-to-a-folio_batch.patch removed from -mm tree
Message-Id: <20220704011029.0352EC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: convert activate_page to a folio_batch
has been removed from the -mm tree.  Its filename was
     mm-swap-convert-activate_page-to-a-folio_batch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/swap: convert activate_page to a folio_batch
Date: Fri, 17 Jun 2022 18:50:06 +0100

Rename it to just 'activate', saving 696 bytes of text from removals
of compound_page() and the pagevec_lru_move_fn() infrastructure.
Inline need_activate_page_drain() into its only caller.

Link: https://lkml.kernel.org/r/20220617175020.717127-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   81 ++++++++++------------------------------------------
 1 file changed, 16 insertions(+), 65 deletions(-)

--- a/mm/swap.c~mm-swap-convert-activate_page-to-a-folio_batch
+++ a/mm/swap.c
@@ -66,7 +66,7 @@ struct lru_pvecs {
 	struct folio_batch lru_deactivate;
 	struct folio_batch lru_lazyfree;
 #ifdef CONFIG_SMP
-	struct pagevec activate_page;
+	struct folio_batch activate;
 #endif
 };
 static DEFINE_PER_CPU(struct lru_pvecs, lru_pvecs) = {
@@ -188,44 +188,6 @@ int get_kernel_pages(const struct kvec *
 }
 EXPORT_SYMBOL_GPL(get_kernel_pages);
 
-static void pagevec_lru_move_fn(struct pagevec *pvec,
-	void (*move_fn)(struct page *page, struct lruvec *lruvec))
-{
-	int i;
-	struct lruvec *lruvec = NULL;
-	unsigned long flags = 0;
-
-	for (i = 0; i < pagevec_count(pvec); i++) {
-		struct page *page = pvec->pages[i];
-		struct folio *folio = page_folio(page);
-
-		/* block memcg migration during page moving between lru */
-		if (!TestClearPageLRU(page))
-			continue;
-
-		lruvec = folio_lruvec_relock_irqsave(folio, lruvec, &flags);
-		(*move_fn)(page, lruvec);
-
-		SetPageLRU(page);
-	}
-	if (lruvec)
-		unlock_page_lruvec_irqrestore(lruvec, flags);
-	release_pages(pvec->pages, pvec->nr);
-	pagevec_reinit(pvec);
-}
-
-/* return true if pagevec needs to drain */
-static bool pagevec_add_and_need_flush(struct pagevec *pvec, struct page *page)
-{
-	bool ret = false;
-
-	if (!pagevec_add(pvec, page) || PageCompound(page) ||
-			lru_cache_disabled())
-		ret = true;
-
-	return ret;
-}
-
 typedef void (*move_fn_t)(struct lruvec *lruvec, struct folio *folio);
 
 static void lru_add_fn(struct lruvec *lruvec, struct folio *folio)
@@ -380,7 +342,7 @@ void lru_note_cost_folio(struct folio *f
 			folio_nr_pages(folio));
 }
 
-static void __folio_activate(struct folio *folio, struct lruvec *lruvec)
+static void folio_activate_fn(struct lruvec *lruvec, struct folio *folio)
 {
 	if (!folio_test_active(folio) && !folio_test_unevictable(folio)) {
 		long nr_pages = folio_nr_pages(folio);
@@ -397,41 +359,30 @@ static void __folio_activate(struct foli
 }
 
 #ifdef CONFIG_SMP
-static void __activate_page(struct page *page, struct lruvec *lruvec)
-{
-	return __folio_activate(page_folio(page), lruvec);
-}
-
-static void activate_page_drain(int cpu)
+static void folio_activate_drain(int cpu)
 {
-	struct pagevec *pvec = &per_cpu(lru_pvecs.activate_page, cpu);
-
-	if (pagevec_count(pvec))
-		pagevec_lru_move_fn(pvec, __activate_page);
-}
+	struct folio_batch *fbatch = &per_cpu(lru_pvecs.activate, cpu);
 
-static bool need_activate_page_drain(int cpu)
-{
-	return pagevec_count(&per_cpu(lru_pvecs.activate_page, cpu)) != 0;
+	if (folio_batch_count(fbatch))
+		folio_batch_move_lru(fbatch, folio_activate_fn);
 }
 
 static void folio_activate(struct folio *folio)
 {
 	if (folio_test_lru(folio) && !folio_test_active(folio) &&
 	    !folio_test_unevictable(folio)) {
-		struct pagevec *pvec;
+		struct folio_batch *fbatch;
 
 		folio_get(folio);
 		local_lock(&lru_pvecs.lock);
-		pvec = this_cpu_ptr(&lru_pvecs.activate_page);
-		if (pagevec_add_and_need_flush(pvec, &folio->page))
-			pagevec_lru_move_fn(pvec, __activate_page);
+		fbatch = this_cpu_ptr(&lru_pvecs.activate);
+		folio_batch_add_and_move(fbatch, folio, folio_activate_fn);
 		local_unlock(&lru_pvecs.lock);
 	}
 }
 
 #else
-static inline void activate_page_drain(int cpu)
+static inline void folio_activate_drain(int cpu)
 {
 }
 
@@ -441,7 +392,7 @@ static void folio_activate(struct folio
 
 	if (folio_test_clear_lru(folio)) {
 		lruvec = folio_lruvec_lock_irq(folio);
-		__folio_activate(folio, lruvec);
+		folio_activate_fn(lruvec, folio);
 		unlock_page_lruvec_irq(lruvec);
 		folio_set_lru(folio);
 	}
@@ -500,9 +451,9 @@ void folio_mark_accessed(struct folio *f
 		 */
 	} else if (!folio_test_active(folio)) {
 		/*
-		 * If the page is on the LRU, queue it for activation via
-		 * lru_pvecs.activate_page. Otherwise, assume the page is on a
-		 * pagevec, mark it active and it'll be moved to the active
+		 * If the folio is on the LRU, queue it for activation via
+		 * lru_pvecs.activate. Otherwise, assume the folio is in a
+		 * folio_batch, mark it active and it'll be moved to the active
 		 * LRU on the next drain.
 		 */
 		if (folio_test_lru(folio))
@@ -697,7 +648,7 @@ void lru_add_drain_cpu(int cpu)
 	if (folio_batch_count(fbatch))
 		folio_batch_move_lru(fbatch, lru_lazyfree_fn);
 
-	activate_page_drain(cpu);
+	folio_activate_drain(cpu);
 }
 
 /**
@@ -901,7 +852,7 @@ static inline void __lru_add_drain_all(b
 		    folio_batch_count(&per_cpu(lru_pvecs.lru_deactivate_file, cpu)) ||
 		    folio_batch_count(&per_cpu(lru_pvecs.lru_deactivate, cpu)) ||
 		    folio_batch_count(&per_cpu(lru_pvecs.lru_lazyfree, cpu)) ||
-		    need_activate_page_drain(cpu) ||
+		    folio_batch_count(&per_cpu(lru_pvecs.activate, cpu)) ||
 		    need_mlock_page_drain(cpu) ||
 		    has_bh_in_lru(cpu, NULL)) {
 			INIT_WORK(work, lru_add_drain_per_cpu);
_

Patches currently in -mm which might be from willy@infradead.org are

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
mips-rename-pmd_order-to-pmd_table_order.patch

