Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56079C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbiEJEQc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236140AbiEJEPq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:15:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75A7986DD
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1701B81AEF
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A2BC385C2;
        Tue, 10 May 2022 04:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155884;
        bh=JUu+a/S681+7rcLcS5xQoNqS+W1jWF1tOAYm/FebLeA=;
        h=Date:To:From:Subject:From;
        b=eeRGDkcfIxp84VnscbT2TG9Re2BEq8kZmkS5z7iqFs8hiiLsfciGdA7OELrfRz5t6
         UcmtXwx2j1wJ6WcYBf5eRDDNSXD60aWLJYaOsS9HGXBgdIeBSpcfMhK0Nyk2v6PvDi
         0xhEsh8qnkRg9bpWApyOkUiHokL1+enF/fzH1WeM=
Date:   Mon, 09 May 2022 21:11:23 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        songmuchun@bytedance.com, baolin.wang@linux.alibaba.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migration-remove-unneeded-local-variable-mapping_locked.patch removed from -mm tree
Message-Id: <20220510041124.89A2BC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migration: remove unneeded local variable mapping_locked
has been removed from the -mm tree.  Its filename was
     mm-migration-remove-unneeded-local-variable-mapping_locked.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/migration: remove unneeded local variable mapping_locked

Patch series "A few cleanup and fixup patches for migration", v2.

This series contains a few patches to remove unneeded variables, jump
label and use helper to simplify the code.  Also we fix some bugs such as
page refcounts leak , invalid node access and so on.  More details can be
found in the respective changelogs.


This patch (of 11):

When mapping_locked is true, TTU_RMAP_LOCKED is always set to ttu.  We can
check ttu instead so mapping_locked can be removed.  And ttu is either 0
or TTU_RMAP_LOCKED now.  Change '|=' to '=' to reflect this.

Link: https://lkml.kernel.org/r/20220318111709.60311-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220318111709.60311-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/migrate.c~mm-migration-remove-unneeded-local-variable-mapping_locked
+++ a/mm/migrate.c
@@ -1230,7 +1230,6 @@ static int unmap_and_move_huge_page(new_
 		goto put_anon;
 
 	if (page_mapped(hpage)) {
-		bool mapping_locked = false;
 		enum ttu_flags ttu = 0;
 
 		if (!PageAnon(hpage)) {
@@ -1244,14 +1243,13 @@ static int unmap_and_move_huge_page(new_
 			if (unlikely(!mapping))
 				goto unlock_put_anon;
 
-			mapping_locked = true;
-			ttu |= TTU_RMAP_LOCKED;
+			ttu = TTU_RMAP_LOCKED;
 		}
 
 		try_to_migrate(src, ttu);
 		page_was_mapped = 1;
 
-		if (mapping_locked)
+		if (ttu & TTU_RMAP_LOCKED)
 			i_mmap_unlock_write(mapping);
 	}
 
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

