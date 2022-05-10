Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4735DC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236213AbiEJEQa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236148AbiEJEPq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:15:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015BDA6222
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5393F615DA
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A870CC385C5;
        Tue, 10 May 2022 04:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155887;
        bh=3xLDrjKuqjpCqyOUHtfrRgPfFndwxOp5i5bXj2HjMYQ=;
        h=Date:To:From:Subject:From;
        b=wgl1eTpVtE7/Nkw6YtgoeB0Qbaa759bMB1eAwpv3LlrGLNg0WD+bKfBMpYSg3WgYW
         7KuOQSlUJzMaEdQr9smlpZQHUwLDt/GPrBjuvHLK0AqOBTuFCmws/IEBJT66oX2Y2O
         aZa2/1UROurEfHaGpAYarIYDEn/gwYJuUZCdNSBE=
Date:   Mon, 09 May 2022 21:11:27 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        songmuchun@bytedance.com, baolin.wang@linux.alibaba.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migration-use-helper-macro-min-in-do_pages_stat.patch removed from -mm tree
Message-Id: <20220510041127.A870CC385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migration: use helper macro min in do_pages_stat
has been removed from the -mm tree.  Its filename was
     mm-migration-use-helper-macro-min-in-do_pages_stat.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/migration: use helper macro min in do_pages_stat

We could use helper macro min to help set the chunk_nr to simplify the
code.

Link: https://lkml.kernel.org/r/20220318111709.60311-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/migrate.c~mm-migration-use-helper-macro-min-in-do_pages_stat
+++ a/mm/migrate.c
@@ -1842,16 +1842,12 @@ static int do_pages_stat(struct mm_struc
 			 const void __user * __user *pages,
 			 int __user *status)
 {
-#define DO_PAGES_STAT_CHUNK_NR 16
+#define DO_PAGES_STAT_CHUNK_NR 16UL
 	const void __user *chunk_pages[DO_PAGES_STAT_CHUNK_NR];
 	int chunk_status[DO_PAGES_STAT_CHUNK_NR];
 
 	while (nr_pages) {
-		unsigned long chunk_nr;
-
-		chunk_nr = nr_pages;
-		if (chunk_nr > DO_PAGES_STAT_CHUNK_NR)
-			chunk_nr = DO_PAGES_STAT_CHUNK_NR;
+		unsigned long chunk_nr = min(nr_pages, DO_PAGES_STAT_CHUNK_NR);
 
 		if (in_compat_syscall()) {
 			if (get_compat_pages_array(chunk_pages, pages,
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

