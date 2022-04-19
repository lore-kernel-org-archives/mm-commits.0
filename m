Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52270C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 04:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238825AbiDSENJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 00:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiDSENJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 00:13:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34291B7AE
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 21:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BC95B81190
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 04:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD12C385A5;
        Tue, 19 Apr 2022 04:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650341425;
        bh=Zri1NgVmOWB6fHKcucDNu+jrzdZY0deTpKMw5jzpgxU=;
        h=Date:To:From:Subject:From;
        b=zmGhr2qBdAaUB+RQVMtHG4MgjhyId2x8j+7L5hYkaxdmqL7dQx/MoNJ51TkABamAx
         Qcw8CT8AT4akRAmL16EuAwRQnj4DQBLTuezuBEnP+8ePkvto+Z/oGgn4oZ7Ji1Aq9J
         M5w5BGPT7HNOsw2XHz8T3Tleq4AeE//8T5mh86eI=
Date:   Mon, 18 Apr 2022 21:10:24 -0700
To:     mm-commits@vger.kernel.org, mhocko@suse.com, hughd@google.com,
        hannes@cmpxchg.org, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-fix-potential-pte_unmap_unlock-pte-error.patch added to -mm tree
Message-Id: <20220419041025.2DD12C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: fix potential pte_unmap_unlock pte error
has been added to the -mm tree.  Its filename is
     mm-madvise-fix-potential-pte_unmap_unlock-pte-error.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-fix-potential-pte_unmap_unlock-pte-error.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-fix-potential-pte_unmap_unlock-pte-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/madvise: fix potential pte_unmap_unlock pte error

We can't assume pte_offset_map_lock will return same orig_pte value. So
it's necessary to reacquire the orig_pte or pte_unmap_unlock will unmap
the stale pte.

Link: https://lkml.kernel.org/r/20220416081416.23304-1-linmiaohe@huawei.com
Fixes: 9c276cc65a58 ("mm: introduce MADV_COLD")
Fixes: 854e9ed09ded ("mm: support madvise(MADV_FREE)")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/madvise.c~mm-madvise-fix-potential-pte_unmap_unlock-pte-error
+++ a/mm/madvise.c
@@ -437,12 +437,12 @@ regular_page:
 			if (split_huge_page(page)) {
 				unlock_page(page);
 				put_page(page);
-				pte_offset_map_lock(mm, pmd, addr, &ptl);
+				orig_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
 				break;
 			}
 			unlock_page(page);
 			put_page(page);
-			pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+			orig_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
 			pte--;
 			addr -= PAGE_SIZE;
 			continue;
@@ -653,12 +653,12 @@ static int madvise_free_pte_range(pmd_t
 			if (split_huge_page(page)) {
 				unlock_page(page);
 				put_page(page);
-				pte_offset_map_lock(mm, pmd, addr, &ptl);
+				orig_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
 				goto out;
 			}
 			unlock_page(page);
 			put_page(page);
-			pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+			orig_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
 			pte--;
 			addr -= PAGE_SIZE;
 			continue;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-shmem-make-shmem_init-return-void.patch
mm-memcg-remove-unneeded-nr_scanned.patch
mm-mmapc-use-helper-mlock_future_check.patch
mm-mremap-use-helper-mlock_future_check.patch
mm-mremap-avoid-unneeded-do_munmap-call.patch
mm-memory-failurec-minor-cleanup-for-hwpoisonhandlable.patch
mm-memory-failurec-dissolve-truncated-hugetlb-page.patch
mm-vmscan-remove-obsolete-comment-in-get_scan_count.patch
mm-vmscan-fix-comment-for-current_may_throttle.patch
mm-z3fold-declare-z3fold_mount-with-__init.patch
mm-z3fold-remove-obsolete-comment-in-z3fold_alloc.patch
mm-z3fold-minor-clean-up-for-z3fold_free.patch
mm-z3fold-remove-unneeded-page_mapcount_reset-and-clearpageprivate.patch
mm-z3fold-remove-confusing-local-variable-l-reassignment.patch
mm-z3fold-move-decrement-of-pool-pages_nr-into-__release_z3fold_page.patch
mm-z3fold-remove-redundant-list_del_init-of-zhdr-buddy-in-z3fold_free.patch
mm-z3fold-remove-unneeded-page_headless-check-in-free_handle.patch
mm-compaction-use-helper-isolation_suitable.patch
drivers-base-nodec-fix-compaction-sysfs-file-leak.patch
mm-migration-remove-unneeded-local-variable-mapping_locked.patch
mm-migration-remove-unneeded-local-variable-page_lru.patch
mm-migration-use-helper-function-vma_lookup-in-add_page_for_migration.patch
mm-migration-use-helper-macro-min-in-do_pages_stat.patch
mm-migration-avoid-unneeded-nodemask_t-initialization.patch
mm-migration-remove-some-duplicated-codes-in-migrate_pages.patch
mm-migration-fix-potential-page-refcounts-leak-in-migrate_pages.patch
mm-migration-fix-potential-invalid-node-access-for-reclaim-based-migration.patch
mm-migration-fix-possible-do_pages_stat_array-racing-with-memory-offline.patch
mm-madvise-fix-potential-pte_unmap_unlock-pte-error.patch
mm-compaction-remove-unneeded-return-value-of-kcompactd_run.patch
mm-compaction-remove-unneeded-pfn-update.patch
mm-compaction-remove-unneeded-assignment-to-isolate_start_pfn.patch
mm-compaction-clean-up-comment-for-sched-contention.patch
mm-compaction-clean-up-comment-about-suitable-migration-target-recheck.patch
mm-compaction-use-compact_cluster_max-in-compactionc.patch
mm-compaction-use-helper-compound_nr-in-isolate_migratepages_block.patch
mm-compaction-clean-up-comment-about-async-compaction-in-isolate_migratepages.patch
mm-compaction-avoid-possible-null-pointer-dereference-in-kcompactd_cpu_online.patch
mm-compaction-make-compaction_zonelist_suitable-return-false-when-compact_success.patch
mm-compaction-simplify-the-code-in-__compact_finished.patch
mm-compaction-make-sure-highest-is-above-the-min_pfn.patch

