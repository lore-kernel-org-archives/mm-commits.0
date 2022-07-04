Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 693A5CCA473
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbiGDBLF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbiGDBKN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:10:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8EA62F3
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCF0CB80C73
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A09C341C6;
        Mon,  4 Jul 2022 01:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897007;
        bh=ZOvl8iv3+7jb3V2D4f7iFMFQkJXetLGR4Q0EqCAJnFI=;
        h=Date:To:From:Subject:From;
        b=MLiMcaCP1/zbMU/ld+fGzIm+aTIi35yZSDfse8zuJHOr96e2bwjfa1OOiO+d03/O1
         gXSub0l8lCRUi/tg2m/aNXai0x8WACVozbDcJsiWLBeiUyPhvVz4cw4bt5kKNBSIji
         34on6LdMzkdcPntMk3dzMUObpgIIoz4Qp6QESSxw=
Date:   Sun, 03 Jul 2022 18:10:06 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-convert-isolate_lru_pages-to-use-a-folio.patch removed from -mm tree
Message-Id: <20220704011007.65A09C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: convert isolate_lru_pages() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-vmscan-convert-isolate_lru_pages-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/vmscan: convert isolate_lru_pages() to use a folio
Date: Fri, 17 Jun 2022 16:42:45 +0100

Remove a few hidden calls to compound_head, saving 279 bytes of text.

Link: https://lkml.kernel.org/r/20220617154248.700416-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   66 +++++++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-convert-isolate_lru_pages-to-use-a-folio
+++ a/mm/vmscan.c
@@ -160,17 +160,17 @@ struct scan_control {
 };
 
 #ifdef ARCH_HAS_PREFETCHW
-#define prefetchw_prev_lru_page(_page, _base, _field)			\
+#define prefetchw_prev_lru_folio(_folio, _base, _field)			\
 	do {								\
-		if ((_page)->lru.prev != _base) {			\
-			struct page *prev;				\
+		if ((_folio)->lru.prev != _base) {			\
+			struct folio *prev;				\
 									\
-			prev = lru_to_page(&(_page->lru));		\
+			prev = lru_to_folio(&(_folio->lru));		\
 			prefetchw(&prev->_field);			\
 		}							\
 	} while (0)
 #else
-#define prefetchw_prev_lru_page(_page, _base, _field) do { } while (0)
+#define prefetchw_prev_lru_folio(_folio, _base, _field) do { } while (0)
 #endif
 
 /*
@@ -2139,72 +2139,72 @@ static unsigned long isolate_lru_pages(u
 	unsigned long nr_skipped[MAX_NR_ZONES] = { 0, };
 	unsigned long skipped = 0;
 	unsigned long scan, total_scan, nr_pages;
-	LIST_HEAD(pages_skipped);
+	LIST_HEAD(folios_skipped);
 
 	total_scan = 0;
 	scan = 0;
 	while (scan < nr_to_scan && !list_empty(src)) {
 		struct list_head *move_to = src;
-		struct page *page;
+		struct folio *folio;
 
-		page = lru_to_page(src);
-		prefetchw_prev_lru_page(page, src, flags);
+		folio = lru_to_folio(src);
+		prefetchw_prev_lru_folio(folio, src, flags);
 
-		nr_pages = compound_nr(page);
+		nr_pages = folio_nr_pages(folio);
 		total_scan += nr_pages;
 
-		if (page_zonenum(page) > sc->reclaim_idx) {
-			nr_skipped[page_zonenum(page)] += nr_pages;
-			move_to = &pages_skipped;
+		if (folio_zonenum(folio) > sc->reclaim_idx) {
+			nr_skipped[folio_zonenum(folio)] += nr_pages;
+			move_to = &folios_skipped;
 			goto move;
 		}
 
 		/*
-		 * Do not count skipped pages because that makes the function
-		 * return with no isolated pages if the LRU mostly contains
-		 * ineligible pages.  This causes the VM to not reclaim any
-		 * pages, triggering a premature OOM.
-		 * Account all tail pages of THP.
+		 * Do not count skipped folios because that makes the function
+		 * return with no isolated folios if the LRU mostly contains
+		 * ineligible folios.  This causes the VM to not reclaim any
+		 * folios, triggering a premature OOM.
+		 * Account all pages in a folio.
 		 */
 		scan += nr_pages;
 
-		if (!PageLRU(page))
+		if (!folio_test_lru(folio))
 			goto move;
-		if (!sc->may_unmap && page_mapped(page))
+		if (!sc->may_unmap && folio_mapped(folio))
 			goto move;
 
 		/*
-		 * Be careful not to clear PageLRU until after we're
-		 * sure the page is not being freed elsewhere -- the
-		 * page release code relies on it.
+		 * Be careful not to clear the lru flag until after we're
+		 * sure the folio is not being freed elsewhere -- the
+		 * folio release code relies on it.
 		 */
-		if (unlikely(!get_page_unless_zero(page)))
+		if (unlikely(!folio_try_get(folio)))
 			goto move;
 
-		if (!TestClearPageLRU(page)) {
-			/* Another thread is already isolating this page */
-			put_page(page);
+		if (!folio_test_clear_lru(folio)) {
+			/* Another thread is already isolating this folio */
+			folio_put(folio);
 			goto move;
 		}
 
 		nr_taken += nr_pages;
-		nr_zone_taken[page_zonenum(page)] += nr_pages;
+		nr_zone_taken[folio_zonenum(folio)] += nr_pages;
 		move_to = dst;
 move:
-		list_move(&page->lru, move_to);
+		list_move(&folio->lru, move_to);
 	}
 
 	/*
-	 * Splice any skipped pages to the start of the LRU list. Note that
+	 * Splice any skipped folios to the start of the LRU list. Note that
 	 * this disrupts the LRU order when reclaiming for lower zones but
 	 * we cannot splice to the tail. If we did then the SWAP_CLUSTER_MAX
-	 * scanning would soon rescan the same pages to skip and waste lots
+	 * scanning would soon rescan the same folios to skip and waste lots
 	 * of cpu cycles.
 	 */
-	if (!list_empty(&pages_skipped)) {
+	if (!list_empty(&folios_skipped)) {
 		int zid;
 
-		list_splice(&pages_skipped, src);
+		list_splice(&folios_skipped, src);
 		for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 			if (!nr_skipped[zid])
 				continue;
_

Patches currently in -mm which might be from willy@infradead.org are

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

