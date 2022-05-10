Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BF3C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbiEJEQf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236151AbiEJEPq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:15:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB53AF1E3
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0137BB81AE7
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AF3C385A6;
        Tue, 10 May 2022 04:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155886;
        bh=PRK6EQ9I5ZcGIlMCmVIZeGH7/LiEulmPMfn+0sYc+DU=;
        h=Date:To:From:Subject:From;
        b=UPQ7fDYTFTzcKGEC4XORlK06Cg9HglvrrZh3DC5yPuf7KYrWkz+kIOWsPIQtJ2TF0
         EeoHwweN0foq3Hp3Sn/SwyHXpRDoeK159LvKdY5kiqcb1jDdvZqpuDKwAuHluvp7rA
         tud1zDdGk8TO875R7bqRJDyeH5QB0XCBZRmYAwGY=
Date:   Mon, 09 May 2022 21:11:26 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        songmuchun@bytedance.com, baolin.wang@linux.alibaba.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migration-use-helper-function-vma_lookup-in-add_page_for_migration.patch removed from -mm tree
Message-Id: <20220510041126.A0AF3C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migration: use helper function vma_lookup() in add_page_for_migration
has been removed from the -mm tree.  Its filename was
     mm-migration-use-helper-function-vma_lookup-in-add_page_for_migration.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/migration: use helper function vma_lookup() in add_page_for_migration

We could use helper function vma_lookup() to lookup the needed vma to
simplify the code.

Link: https://lkml.kernel.org/r/20220318111709.60311-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-migration-use-helper-function-vma_lookup-in-add_page_for_migration
+++ a/mm/migrate.c
@@ -1604,8 +1604,8 @@ static int add_page_for_migration(struct
 
 	mmap_read_lock(mm);
 	err = -EFAULT;
-	vma = find_vma(mm, addr);
-	if (!vma || addr < vma->vm_start || !vma_migratable(vma))
+	vma = vma_lookup(mm, addr);
+	if (!vma || !vma_migratable(vma))
 		goto out;
 
 	/* FOLL_DUMP to ignore special (like zero) pages */
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

