Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3994C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236033AbiEJER6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236130AbiEJERD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:17:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092615DA45
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:12:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98B5861746
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F338EC385C2;
        Tue, 10 May 2022 04:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155948;
        bh=RWzmoBKfGT7fiulGflqenu7gN1R8tKxsUhRtScMXe6I=;
        h=Date:To:From:Subject:From;
        b=i19hDuLUD91ZJgKmlPpWViLSFiR1JzJbpTxK8x2YNrnxaH4xz0Y5i928nLgS9Zifb
         LRRm6tWTEPCpYNDqyS0marMpG248ir/gRRmant8qEnVwKHHLGWFTPDJdIubHsLuJnb
         8U34v0YwPJJAXPYbuoX2AcSVIgFtk3OJZ1pOLbug=
Date:   Mon, 09 May 2022 21:12:27 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, pintu@codeaurora.org,
        david@redhat.com, charante@codeaurora.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-simplify-the-code-in-__compact_finished.patch removed from -mm tree
Message-Id: <20220510041227.F338EC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: simplify the code in __compact_finished
has been removed from the -mm tree.  Its filename was
     mm-compaction-simplify-the-code-in-__compact_finished.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: compaction: simplify the code in __compact_finished

Since commit efe771c7603b ("mm, compaction: always finish scanning of a
full pageblock"), compaction will always finish scanning a pageblock.  And
migrate_pfn is assured to align with pageblock_nr_pages when we reach
here.  So we will always return COMPACT_SUCCESS if a suitable fallback is
found due to the below IS_ALIGNED check of migrate_pfn.  Simplify the code
to make this clear and improve the readability.  No functional change
intended.

Link: https://lkml.kernel.org/r/20220418141253.24298-12-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Charan Teja Kalla <charante@codeaurora.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Pintu Kumar <pintu@codeaurora.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

--- a/mm/compaction.c~mm-compaction-simplify-the-code-in-__compact_finished
+++ a/mm/compaction.c
@@ -2134,29 +2134,16 @@ static enum compact_result __compact_fin
 		 * other migratetype buddy lists.
 		 */
 		if (find_suitable_fallback(area, order, migratetype,
-						true, &can_steal) != -1) {
-
-			/* movable pages are OK in any pageblock */
-			if (migratetype == MIGRATE_MOVABLE)
-				return COMPACT_SUCCESS;
-
+						true, &can_steal) != -1)
 			/*
-			 * We are stealing for a non-movable allocation. Make
-			 * sure we finish compacting the current pageblock
-			 * first so it is as free as possible and we won't
-			 * have to steal another one soon. This only applies
-			 * to sync compaction, as async compaction operates
-			 * on pageblocks of the same migratetype.
+			 * Movable pages are OK in any pageblock. If we are
+			 * stealing for a non-movable allocation, make sure
+			 * we finish compacting the current pageblock first
+			 * (which is assured by the above migrate_pfn align
+			 * check) so it is as free as possible and we won't
+			 * have to steal another one soon.
 			 */
-			if (cc->mode == MIGRATE_ASYNC ||
-					IS_ALIGNED(cc->migrate_pfn,
-							pageblock_nr_pages)) {
-				return COMPACT_SUCCESS;
-			}
-
-			ret = COMPACT_CONTINUE;
-			break;
-		}
+			return COMPACT_SUCCESS;
 	}
 
 out:
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

