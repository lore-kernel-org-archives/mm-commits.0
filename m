Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98F9AC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 20:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355359AbiELUSm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 16:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244169AbiELUSm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 16:18:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3B613CA16
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 13:18:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 879AEB827F5
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 20:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E97C34100;
        Thu, 12 May 2022 20:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652386718;
        bh=zY15C2KBTqvkgngqtzrfB9d5zP6EwYs0clC03pL2h1A=;
        h=Date:To:From:Subject:From;
        b=ZW4gEF1N4d0mVdovAxh/B8i/fy0clbz8Y8Z1cebJdHaweU97kiQD38Hg51NBBm4bc
         3HVhnaQhuQ4Y7wnXkJpQEIxs7r0/7su7WU6xr/O7eJawgs7jkLakFk+Xrz5NNzW1Tl
         O4QWT/CgsAPIREbZGE+QI/1W1ZkPWyfssVKgemOM=
Date:   Thu, 12 May 2022 13:18:37 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        songmuchun@bytedance.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, mgorman@techsingularity.net, hch@lst.de,
        dhowells@redhat.com, david@redhat.com, cl@linux.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-migration-reduce-the-rcu-lock-duration.patch removed from -mm tree
Message-Id: <20220512201838.42E97C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migration: reduce the rcu lock duration
has been removed from the -mm tree.  Its filename was
     mm-migration-reduce-the-rcu-lock-duration.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/migration: reduce the rcu lock duration

Patch series "A few cleanup and fixup patches for migration", v2.

This series contains a few patches to remove unneeded lock page and
PageMovable check, reduce the rcu lock duration.  Also we fix potential
pte_unmap on an not mapped pte.  More details can be found in the
respective changelogs.


This patch (of 4):

rcu_read_lock is required by grabbing the task refcount but it's not
needed for ptrace_may_access.  So we could release the rcu lock after task
refcount is successfully grabbed to reduce the rcu holding time.

Link: https://lkml.kernel.org/r/20220425132723.34824-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220425132723.34824-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Huang Ying <ying.huang@intel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/migrate.c~mm-migration-reduce-the-rcu-lock-duration
+++ a/mm/migrate.c
@@ -1902,17 +1902,16 @@ static struct mm_struct *find_mm_struct(
 		return ERR_PTR(-ESRCH);
 	}
 	get_task_struct(task);
+	rcu_read_unlock();
 
 	/*
 	 * Check if this process has the right to modify the specified
 	 * process. Use the regular "ptrace_may_access()" checks.
 	 */
 	if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS)) {
-		rcu_read_unlock();
 		mm = ERR_PTR(-EPERM);
 		goto out;
 	}
-	rcu_read_unlock();
 
 	mm = ERR_PTR(security_task_movememory(task));
 	if (IS_ERR(mm))
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch
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

