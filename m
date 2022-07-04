Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66841CCA481
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbiGDBLO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbiGDBKi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:10:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA306302
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 736CDB803F6
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14644C341C6;
        Mon,  4 Jul 2022 01:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897024;
        bh=Iuh+k3ZOS59cmZGIOGayUGbZnaJxSqu/gskuD2rgdCY=;
        h=Date:To:From:Subject:From;
        b=j6ubdhePHg+v9Y7txJZbFW83mTc5rm7KaBWjOsYMrcl+QVhrPXASnp8cj4U7BT3Fv
         XL8wdy2HXRLpk6aGJ/SVwnGwAMicEOAJH1/BYFck/wqXoBALA2YhaAUXjNsAUJ/EBc
         bqPLyi5TeIij47ld0QCiSz408KecCp5cjHiFlM8s=
Date:   Sun, 03 Jul 2022 18:10:23 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-make-__pagevec_lru_add-static.patch removed from -mm tree
Message-Id: <20220704011024.14644C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: make __pagevec_lru_add static
has been removed from the -mm tree.  Its filename was
     mm-swap-make-__pagevec_lru_add-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/swap: make __pagevec_lru_add static
Date: Fri, 17 Jun 2022 18:50:01 +0100

__pagevec_lru_add has no callers outside swap.c, so make it static,
and move it to a more logical position in the file.

Link: https://lkml.kernel.org/r/20220617175020.717127-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    1 
 mm/swap.c               |  126 +++++++++++++++++++-------------------
 2 files changed, 63 insertions(+), 64 deletions(-)

--- a/include/linux/pagevec.h~mm-swap-make-__pagevec_lru_add-static
+++ a/include/linux/pagevec.h
@@ -26,7 +26,6 @@ struct pagevec {
 };
 
 void __pagevec_release(struct pagevec *pvec);
-void __pagevec_lru_add(struct pagevec *pvec);
 unsigned pagevec_lookup_range(struct pagevec *pvec,
 			      struct address_space *mapping,
 			      pgoff_t *start, pgoff_t end);
--- a/mm/swap.c~mm-swap-make-__pagevec_lru_add-static
+++ a/mm/swap.c
@@ -228,6 +228,69 @@ static bool pagevec_add_and_need_flush(s
 
 typedef void (*move_fn_t)(struct lruvec *lruvec, struct folio *folio);
 
+static void __pagevec_lru_add_fn(struct folio *folio, struct lruvec *lruvec)
+{
+	int was_unevictable = folio_test_clear_unevictable(folio);
+	long nr_pages = folio_nr_pages(folio);
+
+	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
+
+	folio_set_lru(folio);
+	/*
+	 * Is an smp_mb__after_atomic() still required here, before
+	 * folio_evictable() tests PageMlocked, to rule out the possibility
+	 * of stranding an evictable folio on an unevictable LRU?  I think
+	 * not, because __munlock_page() only clears PageMlocked while the LRU
+	 * lock is held.
+	 *
+	 * (That is not true of __page_cache_release(), and not necessarily
+	 * true of release_pages(): but those only clear PageMlocked after
+	 * put_page_testzero() has excluded any other users of the page.)
+	 */
+	if (folio_evictable(folio)) {
+		if (was_unevictable)
+			__count_vm_events(UNEVICTABLE_PGRESCUED, nr_pages);
+	} else {
+		folio_clear_active(folio);
+		folio_set_unevictable(folio);
+		/*
+		 * folio->mlock_count = !!folio_test_mlocked(folio)?
+		 * But that leaves __mlock_page() in doubt whether another
+		 * actor has already counted the mlock or not.  Err on the
+		 * safe side, underestimate, let page reclaim fix it, rather
+		 * than leaving a page on the unevictable LRU indefinitely.
+		 */
+		folio->mlock_count = 0;
+		if (!was_unevictable)
+			__count_vm_events(UNEVICTABLE_PGCULLED, nr_pages);
+	}
+
+	lruvec_add_folio(lruvec, folio);
+	trace_mm_lru_insertion(folio);
+}
+
+/*
+ * Add the passed pages to the LRU, then drop the caller's refcount
+ * on them.  Reinitialises the caller's pagevec.
+ */
+static void __pagevec_lru_add(struct pagevec *pvec)
+{
+	int i;
+	struct lruvec *lruvec = NULL;
+	unsigned long flags = 0;
+
+	for (i = 0; i < pagevec_count(pvec); i++) {
+		struct folio *folio = page_folio(pvec->pages[i]);
+
+		lruvec = folio_lruvec_relock_irqsave(folio, lruvec, &flags);
+		__pagevec_lru_add_fn(folio, lruvec);
+	}
+	if (lruvec)
+		unlock_page_lruvec_irqrestore(lruvec, flags);
+	release_pages(pvec->pages, pvec->nr);
+	pagevec_reinit(pvec);
+}
+
 static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 {
 	int i;
@@ -1036,69 +1099,6 @@ void __pagevec_release(struct pagevec *p
 }
 EXPORT_SYMBOL(__pagevec_release);
 
-static void __pagevec_lru_add_fn(struct folio *folio, struct lruvec *lruvec)
-{
-	int was_unevictable = folio_test_clear_unevictable(folio);
-	long nr_pages = folio_nr_pages(folio);
-
-	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
-
-	folio_set_lru(folio);
-	/*
-	 * Is an smp_mb__after_atomic() still required here, before
-	 * folio_evictable() tests PageMlocked, to rule out the possibility
-	 * of stranding an evictable folio on an unevictable LRU?  I think
-	 * not, because __munlock_page() only clears PageMlocked while the LRU
-	 * lock is held.
-	 *
-	 * (That is not true of __page_cache_release(), and not necessarily
-	 * true of release_pages(): but those only clear PageMlocked after
-	 * put_page_testzero() has excluded any other users of the page.)
-	 */
-	if (folio_evictable(folio)) {
-		if (was_unevictable)
-			__count_vm_events(UNEVICTABLE_PGRESCUED, nr_pages);
-	} else {
-		folio_clear_active(folio);
-		folio_set_unevictable(folio);
-		/*
-		 * folio->mlock_count = !!folio_test_mlocked(folio)?
-		 * But that leaves __mlock_page() in doubt whether another
-		 * actor has already counted the mlock or not.  Err on the
-		 * safe side, underestimate, let page reclaim fix it, rather
-		 * than leaving a page on the unevictable LRU indefinitely.
-		 */
-		folio->mlock_count = 0;
-		if (!was_unevictable)
-			__count_vm_events(UNEVICTABLE_PGCULLED, nr_pages);
-	}
-
-	lruvec_add_folio(lruvec, folio);
-	trace_mm_lru_insertion(folio);
-}
-
-/*
- * Add the passed pages to the LRU, then drop the caller's refcount
- * on them.  Reinitialises the caller's pagevec.
- */
-void __pagevec_lru_add(struct pagevec *pvec)
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
 /**
  * folio_batch_remove_exceptionals() - Prune non-folios from a batch.
  * @fbatch: The batch to prune
_

Patches currently in -mm which might be from willy@infradead.org are

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

