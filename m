Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAAB1C11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:21:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C155D61CFF
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhF2AX6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:23:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231996AbhF2AX5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:23:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DC2A61CF4;
        Tue, 29 Jun 2021 00:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624926090;
        bh=vEA03EFyWy9fc4CdnR8AY9VtOgI9fEeQnzxV3gvOSXg=;
        h=Date:From:To:Subject:From;
        b=x7DHqtOOxF0jCSGMCIRO+GC5sapg4jxVH28/EzCaZ+CrNnr0I8uoMNSLimwuWC/jl
         il2Pm2lhzfSeDQxQw4uIvLbysUvGOgaRflFRxh8azUivxVLBvfRHXDQ09lguXs6f6+
         G7oP96EsM6GOWORVuP4k7emcoTNNH9HjlikBoHoQ=
Date:   Mon, 28 Jun 2021 17:21:30 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [folded-merged]
 mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix-2.patch
 removed from -mm tree
Message-ID: <20210629002130.Zv9AXdQN7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: fold scan_swap_map() into the only caller get_swap_page_of_type()
has been removed from the -mm tree.  Its filename was
     mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix-2.patch

This patch was dropped because it was folded into mm-swapfile-move-get_swap_page_of_type-under-config_hibernation.patch

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile: fold scan_swap_map() into the only caller get_swap_page_of_type()

We should fold scan_swap_map() into the only caller
get_swap_page_of_type() and update the comments referring to it to make
the code more succinct.

Link: https://lkml.kernel.org/r/20210527120328.3935132-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   57 +++++++++++++++---------------------------------
 1 file changed, 18 insertions(+), 39 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix-2
+++ a/mm/swapfile.c
@@ -453,10 +453,10 @@ static void swap_cluster_schedule_discar
 		unsigned int idx)
 {
 	/*
-	 * If scan_swap_map() can't find a free cluster, it will check
+	 * If scan_swap_map_slots() can't find a free cluster, it will check
 	 * si->swap_map directly. To make sure the discarding cluster isn't
-	 * taken by scan_swap_map(), mark the swap entries bad (occupied). It
-	 * will be cleared after discard
+	 * taken by scan_swap_map_slots(), mark the swap entries bad (occupied).
+	 * It will be cleared after discard
 	 */
 	memset(si->swap_map + idx * SWAPFILE_CLUSTER,
 			SWAP_MAP_BAD, SWAPFILE_CLUSTER);
@@ -589,7 +589,7 @@ static void dec_cluster_info_page(struct
 }
 
 /*
- * It's possible scan_swap_map() uses a free cluster in the middle of free
+ * It's possible scan_swap_map_slots() uses a free cluster in the middle of free
  * cluster list. Avoiding such abuse to avoid list corruption.
  */
 static bool
@@ -1099,14 +1099,14 @@ start_over:
 nextsi:
 		/*
 		 * if we got here, it's likely that si was almost full before,
-		 * and since scan_swap_map() can drop the si->lock, multiple
-		 * callers probably all tried to get a page from the same si
-		 * and it filled up before we could get one; or, the si filled
-		 * up between us dropping swap_avail_lock and taking si->lock.
-		 * Since we dropped the swap_avail_lock, the swap_avail_head
-		 * list may have been modified; so if next is still in the
-		 * swap_avail_head list then try it, otherwise start over
-		 * if we have not gotten any slots.
+		 * and since scan_swap_map_slots() can drop the si->lock,
+		 * multiple callers probably all tried to get a page from the
+		 * same si and it filled up before we could get one; or, the si
+		 * filled up between us dropping swap_avail_lock and taking
+		 * si->lock. Since we dropped the swap_avail_lock, the
+		 * swap_avail_head list may have been modified; so if next is
+		 * still in the swap_avail_head list then try it, otherwise
+		 * start over if we have not gotten any slots.
 		 */
 		if (plist_node_empty(&next->avail_lists[node]))
 			goto start_over;
@@ -1774,42 +1774,21 @@ int free_swap_and_cache(swp_entry_t entr
 
 #ifdef CONFIG_HIBERNATION
 
-static unsigned long scan_swap_map(struct swap_info_struct *si,
-				   unsigned char usage)
-{
-	swp_entry_t entry;
-	int n_ret;
-
-	n_ret = scan_swap_map_slots(si, usage, 1, &entry);
-
-	if (n_ret)
-		return swp_offset(entry);
-	else
-		return 0;
-
-}
-
 swp_entry_t get_swap_page_of_type(int type)
 {
 	struct swap_info_struct *si = swap_type_to_swap_info(type);
-	pgoff_t offset;
+	swp_entry_t entry = {0};
 
 	if (!si)
 		goto fail;
 
+	/* This is called for allocating swap entry, not cache */
 	spin_lock(&si->lock);
-	if (si->flags & SWP_WRITEOK) {
-		/* This is called for allocating swap entry, not cache */
-		offset = scan_swap_map(si, 1);
-		if (offset) {
-			atomic_long_dec(&nr_swap_pages);
-			spin_unlock(&si->lock);
-			return swp_entry(type, offset);
-		}
-	}
+	if ((si->flags & SWP_WRITEOK) && scan_swap_map_slots(si, 1, 1, &entry))
+		atomic_long_dec(&nr_swap_pages);
 	spin_unlock(&si->lock);
 fail:
-	return (swp_entry_t) {0};
+	return entry;
 }
 
 /*
@@ -2649,7 +2628,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	spin_lock(&p->lock);
 	drain_mmlist();
 
-	/* wait for anyone still in scan_swap_map */
+	/* wait for anyone still in scan_swap_map_slots */
 	p->highest_bit = 0;		/* cuts scans short */
 	while (p->flags >= SWP_SCANNING) {
 		spin_unlock(&p->lock);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-use-percpu_ref-to-serialize-against-concurrent-swapoff.patch
swap-fix-do_swap_page-race-with-swapoff.patch
mm-swap-remove-confusing-checking-for-non_swap_entry-in-swap_ra_info.patch
mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation.patch
mm-swap-remove-unused-local-variable-nr_shadows.patch
mm-swap_slotsc-delete-meaningless-forward-declarations.patch
mm-huge_memoryc-remove-dedicated-macro-hpage_cache_index_mask.patch
mm-huge_memoryc-use-page-deferred_list.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4.patch
mm-huge_memoryc-remove-unnecessary-tlb_remove_page_size-for-huge-zero-pmd.patch
mm-huge_memoryc-dont-discard-hugepage-if-other-processes-are-mapping-it.patch
mm-workingset-define-macro-workingset_shift.patch
mm-z3fold-define-macro-nchunks-as-total_chunks-zhdr_chunks.patch
mm-z3fold-avoid-possible-underflow-in-z3fold_alloc.patch
mm-z3fold-remove-magic-number-in-z3fold_create_pool.patch
mm-z3fold-remove-unused-function-handle_to_z3fold_header.patch
mm-z3fold-fix-potential-memory-leak-in-z3fold_destroy_pool.patch
mm-z3fold-use-release_z3fold_page_locked-to-release-locked-z3fold-page.patch
mm-zbud-reuse-unbuddied-as-buddied-in-zbud_pool.patch
mm-zbud-dont-export-any-zbud-api.patch
mm-zbud-dont-export-any-zbud-api-fix.patch
mm-zswapc-remove-unused-function-zswap_debugfs_exit.patch
mm-zswapc-avoid-unnecessary-copy-in-at-map-time.patch
mm-zswapc-fix-two-bugs-in-zswap_writeback_entry.patch
mm-zsmallocc-remove-confusing-code-in-obj_free.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch
mm-zsmallocc-improve-readability-for-async_free_zspage.patch

