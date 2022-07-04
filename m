Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C744C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbiGDBLK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbiGDBKO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:10:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9FC617D
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26696B80BD1
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB05C341C6;
        Mon,  4 Jul 2022 01:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897010;
        bh=1D+1ratw6b36upeTV6wgfLpgWukBAprfCJ3AcgdprYg=;
        h=Date:To:From:Subject:From;
        b=tq8n/aft3scAuButl1sLO42MnadJQ4OPYwrnRyHLa5t7g585bSQDvMB76bfhgbqVB
         s7x8p90tF7Ww6MN7Wdt5dZtPDgQKAWYQGtc4mIplyDdRkN/K8/qFY2CirPKiJB/twu
         YAWl9hkyoaP8gm30E/9BmqaHH6mSUF21K3T0j0Zs=
Date:   Sun, 03 Jul 2022 18:10:10 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-convert-reclaim_pages-to-use-a-folio.patch removed from -mm tree
Message-Id: <20220704011010.9AB05C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: convert reclaim_pages() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-vmscan-convert-reclaim_pages-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/vmscan: convert reclaim_pages() to use a folio
Date: Fri, 17 Jun 2022 16:42:48 +0100

Remove a few hidden calls to compound_head, saving 76 bytes of text.

Link: https://lkml.kernel.org/r/20220617154248.700416-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-convert-reclaim_pages-to-use-a-folio
+++ a/mm/vmscan.c
@@ -2619,34 +2619,33 @@ static unsigned int reclaim_page_list(st
 	return nr_reclaimed;
 }
 
-unsigned long reclaim_pages(struct list_head *page_list)
+unsigned long reclaim_pages(struct list_head *folio_list)
 {
 	int nid;
 	unsigned int nr_reclaimed = 0;
-	LIST_HEAD(node_page_list);
-	struct page *page;
+	LIST_HEAD(node_folio_list);
 	unsigned int noreclaim_flag;
 
-	if (list_empty(page_list))
+	if (list_empty(folio_list))
 		return nr_reclaimed;
 
 	noreclaim_flag = memalloc_noreclaim_save();
 
-	nid = page_to_nid(lru_to_page(page_list));
+	nid = folio_nid(lru_to_folio(folio_list));
 	do {
-		page = lru_to_page(page_list);
+		struct folio *folio = lru_to_folio(folio_list);
 
-		if (nid == page_to_nid(page)) {
-			ClearPageActive(page);
-			list_move(&page->lru, &node_page_list);
+		if (nid == folio_nid(folio)) {
+			folio_clear_active(folio);
+			list_move(&folio->lru, &node_folio_list);
 			continue;
 		}
 
-		nr_reclaimed += reclaim_page_list(&node_page_list, NODE_DATA(nid));
-		nid = page_to_nid(lru_to_page(page_list));
-	} while (!list_empty(page_list));
+		nr_reclaimed += reclaim_page_list(&node_folio_list, NODE_DATA(nid));
+		nid = folio_nid(lru_to_folio(folio_list));
+	} while (!list_empty(folio_list));
 
-	nr_reclaimed += reclaim_page_list(&node_page_list, NODE_DATA(nid));
+	nr_reclaimed += reclaim_page_list(&node_folio_list, NODE_DATA(nid));
 
 	memalloc_noreclaim_restore(noreclaim_flag);
 
_

Patches currently in -mm which might be from willy@infradead.org are

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

