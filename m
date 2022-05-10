Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DA0C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:12:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbiEJEQ0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236044AbiEJEPp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:15:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EAE70918
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FF9561736
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61ED6C385A6;
        Tue, 10 May 2022 04:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155882;
        bh=IEcLdH5+bwrLDPsy7BIkDBd5sjoTmDyl2oQoShrtrfo=;
        h=Date:To:From:Subject:From;
        b=omEp6336HF/D7LNX8kUQebNR1GX4f8rRj+pb9nDbjDvaiXtzw9+0LFKX9b82zBebN
         mE1uVZIWdAN0r6eicg/dRGy/DE80SX0zrshFUiig9GBj2tVwwBDH/kfOBKi7SMaA9v
         8wC/5vuZcF61Yl15vfh1Z1vWgCskseALIqI3w95M=
Date:   Mon, 09 May 2022 21:11:21 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, shy828301@gmail.com,
        rientjes@google.com, mhocko@suse.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-clean-up-the-code-logic-in-queue_pages_pte_range.patch removed from -mm tree
Message-Id: <20220510041122.61ED6C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mempolicy: clean up the code logic in queue_pages_pte_range
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-clean-up-the-code-logic-in-queue_pages_pte_range.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mempolicy: clean up the code logic in queue_pages_pte_range

Since commit e5947d23edd8 ("mm: mempolicy: don't have to split pmd for
huge zero page"), THP is never splited in queue_pages_pmd.  Thus 2 is
never returned now.  We can remove such unnecessary ret != 2 check and
clean up the relevant comment.  Minor improvements in readability.

Link: https://lkml.kernel.org/r/20220419122234.45083-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-clean-up-the-code-logic-in-queue_pages_pte_range
+++ a/mm/mempolicy.c
@@ -440,12 +440,11 @@ static inline bool queue_pages_required(
 }
 
 /*
- * queue_pages_pmd() has four possible return values:
+ * queue_pages_pmd() has three possible return values:
  * 0 - pages are placed on the right node or queued successfully, or
  *     special page is met, i.e. huge zero page.
  * 1 - there is unmovable page, and MPOL_MF_MOVE* & MPOL_MF_STRICT were
  *     specified.
- * 2 - THP was split.
  * -EIO - is migration entry or only MPOL_MF_STRICT was specified and an
  *        existing page was already on a node that does not follow the
  *        policy.
@@ -507,18 +506,13 @@ static int queue_pages_pte_range(pmd_t *
 	struct page *page;
 	struct queue_pages *qp = walk->private;
 	unsigned long flags = qp->flags;
-	int ret;
 	bool has_unmovable = false;
 	pte_t *pte, *mapped_pte;
 	spinlock_t *ptl;
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
-	if (ptl) {
-		ret = queue_pages_pmd(pmd, ptl, addr, end, walk);
-		if (ret != 2)
-			return ret;
-	}
-	/* THP was split, fall through to pte walk */
+	if (ptl)
+		return queue_pages_pmd(pmd, ptl, addr, end, walk);
 
 	if (pmd_trans_unstable(pmd))
 		return 0;
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

