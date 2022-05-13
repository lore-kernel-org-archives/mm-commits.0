Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D538C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:22:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383711AbiEMTW3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383722AbiEMTWP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FA036B66
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4A926225A
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16234C34113;
        Fri, 13 May 2022 19:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469694;
        bh=pupt4BrwzHzkGqMJ5MX0QRmn9v5AclLKhpikOyS2rQs=;
        h=Date:To:From:Subject:From;
        b=saBRHpfnWZUaO/4YqcQiw5VKODA7T1uZBgUx2+R4+WX4qEWy/tAWtJch6YXe74JUX
         t7vp7ev5wRqy4SbThV70B1a3kKsDNKWf2BO3E3I2YvtZCFBE0WI93EexBygTTZrZBf
         UwYu6uaqOlou2qtCO2inEyEL360F7QDQE/RrIG0M=
Date:   Fri, 13 May 2022 12:21:33 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        osalvador@suse.de, iamjoonsoo.kim@lge.com, hch@lst.de,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-introduce-helper-function-reclaim_page_list.patch removed from -mm tree
Message-Id: <20220513192134.16234C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: introduce helper function reclaim_page_list()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-introduce-helper-function-reclaim_page_list.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmscan: introduce helper function reclaim_page_list()

Introduce helper function reclaim_page_list() to eliminate the duplicated
code of doing shrink_page_list() and putback_lru_page.  Also we can
separate node reclaim from node page list operation this way.  No
functional change intended.

Link: https://lkml.kernel.org/r/20220425111232.23182-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   50 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-introduce-helper-function-reclaim_page_list
+++ a/mm/vmscan.c
@@ -2536,14 +2536,12 @@ static void shrink_active_list(unsigned
 			nr_deactivate, nr_rotated, sc->priority, file);
 }
 
-unsigned long reclaim_pages(struct list_head *page_list)
+static unsigned int reclaim_page_list(struct list_head *page_list,
+				      struct pglist_data *pgdat)
 {
-	int nid = NUMA_NO_NODE;
-	unsigned int nr_reclaimed = 0;
-	LIST_HEAD(node_page_list);
 	struct reclaim_stat dummy_stat;
-	struct page *page;
-	unsigned int noreclaim_flag;
+	unsigned int nr_reclaimed;
+	struct folio *folio;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
 		.may_writepage = 1,
@@ -2552,6 +2550,24 @@ unsigned long reclaim_pages(struct list_
 		.no_demotion = 1,
 	};
 
+	nr_reclaimed = shrink_page_list(page_list, pgdat, &sc, &dummy_stat, false);
+	while (!list_empty(page_list)) {
+		folio = lru_to_folio(page_list);
+		list_del(&folio->lru);
+		folio_putback_lru(folio);
+	}
+
+	return nr_reclaimed;
+}
+
+unsigned long reclaim_pages(struct list_head *page_list)
+{
+	int nid = NUMA_NO_NODE;
+	unsigned int nr_reclaimed = 0;
+	LIST_HEAD(node_page_list);
+	struct page *page;
+	unsigned int noreclaim_flag;
+
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	while (!list_empty(page_list)) {
@@ -2565,28 +2581,12 @@ unsigned long reclaim_pages(struct list_
 			continue;
 		}
 
-		nr_reclaimed += shrink_page_list(&node_page_list,
-						NODE_DATA(nid),
-						&sc, &dummy_stat, false);
-		while (!list_empty(&node_page_list)) {
-			page = lru_to_page(&node_page_list);
-			list_del(&page->lru);
-			putback_lru_page(page);
-		}
-
+		nr_reclaimed += reclaim_page_list(&node_page_list, NODE_DATA(nid));
 		nid = NUMA_NO_NODE;
 	}
 
-	if (!list_empty(&node_page_list)) {
-		nr_reclaimed += shrink_page_list(&node_page_list,
-						NODE_DATA(nid),
-						&sc, &dummy_stat, false);
-		while (!list_empty(&node_page_list)) {
-			page = lru_to_page(&node_page_list);
-			list_del(&page->lru);
-			putback_lru_page(page);
-		}
-	}
+	if (!list_empty(&node_page_list))
+		nr_reclaimed += reclaim_page_list(&node_page_list, NODE_DATA(nid));
 
 	memalloc_noreclaim_restore(noreclaim_flag);
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-z3fold-fix-sheduling-while-atomic.patch
mm-z3fold-fix-possible-null-pointer-dereferencing.patch
mm-z3fold-remove-buggy-use-of-stale-list-for-allocation.patch
mm-z3fold-throw-warning-on-failure-of-trylock_page-in-z3fold_alloc.patch
revert-mm-z3foldc-allow-__gfp_highmem-in-z3fold_alloc.patch
mm-z3fold-put-z3fold-page-back-into-unbuddied-list-when-reclaim-or-migration-fails.patch
mm-z3fold-always-clear-page_claimed-under-z3fold-page-lock.patch
mm-z3fold-fix-z3fold_reclaim_page-races-with-z3fold_free.patch
mm-z3fold-fix-z3fold_page_migrate-races-with-z3fold_map.patch
mm-swap-use-helper-is_swap_pte-in-swap_vma_readahead.patch
mm-swap-use-helper-macro-__attr_rw.patch
mm-swap-fold-__swap_info_get-into-its-sole-caller.patch
mm-swap-remove-unneeded-return-value-of-free_swap_slot.patch
mm-swap-print-bad-swap-offset-entry-in-get_swap_device.patch
mm-swap-remove-buggy-cache-nr-check-in-refill_swap_slots_cache.patch
mm-swap-remove-unneeded-p-=-null-check-in-__swap_duplicate.patch
mm-swap-make-page_swapcount-and-__lru_add_drain_all.patch
mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes.patch
mm-swap-add-helper-swap_offset_available.patch
mm-swap-fix-the-obsolete-comment-for-swp_type_shift.patch
mm-swap-clean-up-the-comment-of-find_next_to_unuse.patch
mm-swap-fix-the-comment-of-get_kernel_pages.patch
mm-swap-fix-comment-about-swap-extent.patch

