Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42241C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbiGDBLF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232728AbiGDBKN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:10:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10CF462E7
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFAEDB80BD1
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FCCC341C7;
        Mon,  4 Jul 2022 01:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897006;
        bh=qg1EnvEsj7VxZnDcJAlNVRsANK3t06P5Uv4SifO9kSg=;
        h=Date:To:From:Subject:From;
        b=leqgikkdIksK9heL9nG88NwfqUC2cj28KtPpBrpcn5PeCokvd4eC3D9kCqJ0NU8Ce
         CYPxpqg2bAy0oEVuuxuWDIcilYJKC1r+66jgA0hoT0b7DAVveJNezRBLPmNp+V+B0e
         KFqf4B+oXI5VxHzh1+aqPf3jBSVvOdgHFUSvj7ZU=
Date:   Sun, 03 Jul 2022 18:10:05 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-convert-reclaim_clean_pages_from_list-to-folios.patch removed from -mm tree
Message-Id: <20220704011006.55FCCC341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: convert reclaim_clean_pages_from_list() to folios
has been removed from the -mm tree.  Its filename was
     mm-vmscan-convert-reclaim_clean_pages_from_list-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/vmscan: convert reclaim_clean_pages_from_list() to folios
Date: Fri, 17 Jun 2022 16:42:44 +0100

Patch series "nvert much of vmscan to folios"

vmscan always operates on folios since it puts the pages on the LRU list. 
Switching all of these functions from pages to folios saves 1483 bytes of
text from removing all the baggage around calling compound_page() and
similar functions.


This patch (of 5):

This is a straightforward conversion which removes several hidden calls
to compound_head, saving 330 bytes of kernel text.

Link: https://lkml.kernel.org/r/20220617154248.700416-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20220617154248.700416-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    6 ++++++
 mm/vmscan.c                |   22 +++++++++++-----------
 2 files changed, 17 insertions(+), 11 deletions(-)

--- a/include/linux/page-flags.h~mm-vmscan-convert-reclaim_clean_pages_from_list-to-folios
+++ a/include/linux/page-flags.h
@@ -670,6 +670,12 @@ static __always_inline bool PageAnon(str
 	return folio_test_anon(page_folio(page));
 }
 
+static __always_inline bool __folio_test_movable(const struct folio *folio)
+{
+	return ((unsigned long)folio->mapping & PAGE_MAPPING_FLAGS) ==
+			PAGE_MAPPING_MOVABLE;
+}
+
 static __always_inline int __PageMovable(struct page *page)
 {
 	return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) ==
--- a/mm/vmscan.c~mm-vmscan-convert-reclaim_clean_pages_from_list-to-folios
+++ a/mm/vmscan.c
@@ -2041,7 +2041,7 @@ keep:
 }
 
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
-					    struct list_head *page_list)
+					    struct list_head *folio_list)
 {
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
@@ -2049,16 +2049,16 @@ unsigned int reclaim_clean_pages_from_li
 	};
 	struct reclaim_stat stat;
 	unsigned int nr_reclaimed;
-	struct page *page, *next;
-	LIST_HEAD(clean_pages);
+	struct folio *folio, *next;
+	LIST_HEAD(clean_folios);
 	unsigned int noreclaim_flag;
 
-	list_for_each_entry_safe(page, next, page_list, lru) {
-		if (!PageHuge(page) && page_is_file_lru(page) &&
-		    !PageDirty(page) && !__PageMovable(page) &&
-		    !PageUnevictable(page)) {
-			ClearPageActive(page);
-			list_move(&page->lru, &clean_pages);
+	list_for_each_entry_safe(folio, next, folio_list, lru) {
+		if (!folio_test_hugetlb(folio) && folio_is_file_lru(folio) &&
+		    !folio_test_dirty(folio) && !__folio_test_movable(folio) &&
+		    !folio_test_unevictable(folio)) {
+			folio_clear_active(folio);
+			list_move(&folio->lru, &clean_folios);
 		}
 	}
 
@@ -2069,11 +2069,11 @@ unsigned int reclaim_clean_pages_from_li
 	 * change in the future.
 	 */
 	noreclaim_flag = memalloc_noreclaim_save();
-	nr_reclaimed = shrink_page_list(&clean_pages, zone->zone_pgdat, &sc,
+	nr_reclaimed = shrink_page_list(&clean_folios, zone->zone_pgdat, &sc,
 					&stat, true);
 	memalloc_noreclaim_restore(noreclaim_flag);
 
-	list_splice(&clean_pages, page_list);
+	list_splice(&clean_folios, folio_list);
 	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE,
 			    -(long)nr_reclaimed);
 	/*
_

Patches currently in -mm which might be from willy@infradead.org are

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

