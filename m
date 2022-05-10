Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E0EC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236064AbiEJESF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236035AbiEJERA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:17:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585B42438DA
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:12:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 966EB61737
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED71BC385C5;
        Tue, 10 May 2022 04:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155943;
        bh=FrDU5a3SS36u5BrUFs/3HaiLVjzIwjmAeKSoPmJAilU=;
        h=Date:To:From:Subject:From;
        b=Usg5euNiu5LV/4PyIgYdAp3QKESpbjO9XzFc2z20e71WJDBO7xPHB8OU5ogSYL8q3
         aASw/s8ZolxWSZqZOSHk5jgOgUUo9wdv8qgC239ryeZUp07/Uw50BroH6ooefoU5jw
         Jzg+lLpLjyjqUQ3tjhwf/VMf/Ue1d6j+plns+Apw=
Date:   Mon, 09 May 2022 21:12:22 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, pintu@codeaurora.org,
        david@redhat.com, charante@codeaurora.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-use-compact_cluster_max-in-compactionc.patch removed from -mm tree
Message-Id: <20220510041222.ED71BC385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: use COMPACT_CLUSTER_MAX in compaction.c
has been removed from the -mm tree.  Its filename was
     mm-compaction-use-compact_cluster_max-in-compactionc.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: compaction: use COMPACT_CLUSTER_MAX in compaction.c

Always use COMPACT_CLUSTER_MAX here as we're doing the compaction.  Minor
improvements in readability.

Link: https://lkml.kernel.org/r/20220418141253.24298-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Charan Teja Kalla <charante@codeaurora.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Pintu Kumar <pintu@codeaurora.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/compaction.c~mm-compaction-use-compact_cluster_max-in-compactionc
+++ a/mm/compaction.c
@@ -573,7 +573,7 @@ static unsigned long isolate_freepages_b
 		 * contention, to give chance to IRQs. Abort if fatal signal
 		 * pending.
 		 */
-		if (!(blockpfn % SWAP_CLUSTER_MAX)
+		if (!(blockpfn % COMPACT_CLUSTER_MAX)
 		    && compact_unlock_should_abort(&cc->zone->lock, flags,
 								&locked, cc))
 			break;
@@ -862,7 +862,7 @@ isolate_migratepages_block(struct compac
 		 * contention, to give chance to IRQs. Abort completely if
 		 * a fatal signal is pending.
 		 */
-		if (!(low_pfn % SWAP_CLUSTER_MAX)) {
+		if (!(low_pfn % COMPACT_CLUSTER_MAX)) {
 			if (locked) {
 				unlock_page_lruvec_irqrestore(locked, flags);
 				locked = NULL;
@@ -1614,7 +1614,7 @@ static void isolate_freepages(struct com
 		 * This can iterate a massively long zone without finding any
 		 * suitable migration targets, so periodically check resched.
 		 */
-		if (!(block_start_pfn % (SWAP_CLUSTER_MAX * pageblock_nr_pages)))
+		if (!(block_start_pfn % (COMPACT_CLUSTER_MAX * pageblock_nr_pages)))
 			cond_resched();
 
 		page = pageblock_pfn_to_page(block_start_pfn, block_end_pfn,
@@ -1921,7 +1921,7 @@ static isolate_migrate_t isolate_migrate
 		 * many pageblocks unsuitable, so periodically check if we
 		 * need to schedule.
 		 */
-		if (!(low_pfn % (SWAP_CLUSTER_MAX * pageblock_nr_pages)))
+		if (!(low_pfn % (COMPACT_CLUSTER_MAX * pageblock_nr_pages)))
 			cond_resched();
 
 		page = pageblock_pfn_to_page(block_start_pfn,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch
mm-migration-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-vmscan-take-min_slab_pages-into-account-when-try-to-call-shrink_node.patch
mm-vmscan-add-a-comment-about-madv_free-pages-check-in-folio_check_dirty_writeback.patch
mm-vmscan-introduce-helper-function-reclaim_page_list.patch
mm-vmscan-take-all-base-pages-of-thp-into-account-when-race-with-speculative-reference.patch
mm-vmscan-remove-obsolete-comment-in-kswapd_run.patch
mm-vmscan-use-helper-folio_is_file_lru.patch
mm-vmscan-use-helper-folio_is_file_lru-fix.patch
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

