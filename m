Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC102CCA47C
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbiGDBLM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbiGDBKi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:10:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE9C633F
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE71C61305
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B447C341C7;
        Mon,  4 Jul 2022 01:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897027;
        bh=GvAq213AXW8MiClCNhcY8tOIQbyxZnQ63CjZ8soZWRY=;
        h=Date:To:From:Subject:From;
        b=r2MtZWg5xdrmqJNvrqmH9oDuTHwsUOUF4H8XMDmmDu+ezaeyiARAJ25Op8XT0mAtu
         39hG0Lpx92RJM9jGrcnRvb21hiYt1f8VQ0LxtOvjZOZwI3fQwE2t8rjYM1e/d99V0p
         EYsLWcVb0lBEId4NFTppPJWmm90tp5sS2lyyFpCk=
Date:   Sun, 03 Jul 2022 18:10:26 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-convert-lru_deactivate-to-a-folio_batch.patch removed from -mm tree
Message-Id: <20220704011027.0B447C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: convert lru_deactivate to a folio_batch
has been removed from the -mm tree.  Its filename was
     mm-swap-convert-lru_deactivate-to-a-folio_batch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/swap: convert lru_deactivate to a folio_batch
Date: Fri, 17 Jun 2022 18:50:04 +0100

Using folios instead of pages shrinks deactivate_page() and
lru_deactivate_fn() by 778 bytes between them.

Link: https://lkml.kernel.org/r/20220617175020.717127-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

--- a/mm/swap.c~mm-swap-convert-lru_deactivate-to-a-folio_batch
+++ a/mm/swap.c
@@ -63,7 +63,7 @@ struct lru_pvecs {
 	local_lock_t lock;
 	struct folio_batch lru_add;
 	struct folio_batch lru_deactivate_file;
-	struct pagevec lru_deactivate;
+	struct folio_batch lru_deactivate;
 	struct pagevec lru_lazyfree;
 #ifdef CONFIG_SMP
 	struct pagevec activate_page;
@@ -623,15 +623,15 @@ static void lru_deactivate_file_fn(struc
 	}
 }
 
-static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec)
+static void lru_deactivate_fn(struct lruvec *lruvec, struct folio *folio)
 {
-	if (PageActive(page) && !PageUnevictable(page)) {
-		int nr_pages = thp_nr_pages(page);
+	if (folio_test_active(folio) && !folio_test_unevictable(folio)) {
+		long nr_pages = folio_nr_pages(folio);
 
-		del_page_from_lru_list(page, lruvec);
-		ClearPageActive(page);
-		ClearPageReferenced(page);
-		add_page_to_lru_list(page, lruvec);
+		lruvec_del_folio(lruvec, folio);
+		folio_clear_active(folio);
+		folio_clear_referenced(folio);
+		lruvec_add_folio(lruvec, folio);
 
 		__count_vm_events(PGDEACTIVATE, nr_pages);
 		__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE,
@@ -690,9 +690,9 @@ void lru_add_drain_cpu(int cpu)
 	if (folio_batch_count(fbatch))
 		folio_batch_move_lru(fbatch, lru_deactivate_file_fn);
 
-	pvec = &per_cpu(lru_pvecs.lru_deactivate, cpu);
-	if (pagevec_count(pvec))
-		pagevec_lru_move_fn(pvec, lru_deactivate_fn);
+	fbatch = &per_cpu(lru_pvecs.lru_deactivate, cpu);
+	if (folio_batch_count(fbatch))
+		folio_batch_move_lru(fbatch, lru_deactivate_fn);
 
 	pvec = &per_cpu(lru_pvecs.lru_lazyfree, cpu);
 	if (pagevec_count(pvec))
@@ -736,14 +736,16 @@ void deactivate_file_folio(struct folio
  */
 void deactivate_page(struct page *page)
 {
-	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
-		struct pagevec *pvec;
+	struct folio *folio = page_folio(page);
 
+	if (folio_test_lru(folio) && folio_test_active(folio) &&
+	    !folio_test_unevictable(folio)) {
+		struct folio_batch *fbatch;
+
+		folio_get(folio);
 		local_lock(&lru_pvecs.lock);
-		pvec = this_cpu_ptr(&lru_pvecs.lru_deactivate);
-		get_page(page);
-		if (pagevec_add_and_need_flush(pvec, page))
-			pagevec_lru_move_fn(pvec, lru_deactivate_fn);
+		fbatch = this_cpu_ptr(&lru_pvecs.lru_deactivate);
+		folio_batch_add_and_move(fbatch, folio, lru_deactivate_fn);
 		local_unlock(&lru_pvecs.lock);
 	}
 }
@@ -896,7 +898,7 @@ static inline void __lru_add_drain_all(b
 		if (folio_batch_count(&per_cpu(lru_pvecs.lru_add, cpu)) ||
 		    data_race(folio_batch_count(&per_cpu(lru_rotate.fbatch, cpu))) ||
 		    folio_batch_count(&per_cpu(lru_pvecs.lru_deactivate_file, cpu)) ||
-		    pagevec_count(&per_cpu(lru_pvecs.lru_deactivate, cpu)) ||
+		    folio_batch_count(&per_cpu(lru_pvecs.lru_deactivate, cpu)) ||
 		    pagevec_count(&per_cpu(lru_pvecs.lru_lazyfree, cpu)) ||
 		    need_activate_page_drain(cpu) ||
 		    need_mlock_page_drain(cpu) ||
_

Patches currently in -mm which might be from willy@infradead.org are

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

