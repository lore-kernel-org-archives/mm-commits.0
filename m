Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC89C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 04:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241138AbiDSEVc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 00:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238655AbiDSEVb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 00:21:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58CC2BB20
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 21:18:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47FD261170
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 04:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FD6C385AC;
        Tue, 19 Apr 2022 04:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650341929;
        bh=QV1+uvqDJQiXZ8jTEkyhNAtJLB4DThUPnMYyOD8jczY=;
        h=Date:To:From:Subject:From;
        b=r8pCOhYm1jamRpFDd/rnLtYEI4QRVGrj+WlMwfmdVWHp0o1GxChQSquojwkE8vzHg
         xtp+ktMA9tKmdMUiHacDe908FUXoxngTLLSU4f+ph6N6Mdv/IKOIHNY8VW7S10ulmG
         RKHQZPuPLLlnpE7Crm6SZLf6a69lYZIVObgNYJhA=
Date:   Mon, 18 Apr 2022 21:18:48 -0700
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-comment-for-isolate_lru_pages.patch added to -mm tree
Message-Id: <20220419041849.95FD6C385AC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: fix comment for isolate_lru_pages
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-comment-for-isolate_lru_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-fix-comment-for-isolate_lru_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-fix-comment-for-isolate_lru_pages.patch

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
Subject: mm/vmscan: fix comment for isolate_lru_pages

Since commit 791b48b64232 ("mm: vmscan: scan until it finds eligible
pages"), splicing any skipped pages to the tail of the LRU list won't put
the system at risk of premature OOM but will waste lots of cpu cycles. 
Correct the comment accordingly.

Link: https://lkml.kernel.org/r/20220416025231.8082-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-fix-comment-for-isolate_lru_pages
+++ a/mm/vmscan.c
@@ -2152,8 +2152,8 @@ move:
 	 * Splice any skipped pages to the start of the LRU list. Note that
 	 * this disrupts the LRU order when reclaiming for lower zones but
 	 * we cannot splice to the tail. If we did then the SWAP_CLUSTER_MAX
-	 * scanning would soon rescan the same pages to skip and put the
-	 * system at risk of premature OOM.
+	 * scanning would soon rescan the same pages to skip and waste lots
+	 * of cpu cycles.
 	 */
 	if (!list_empty(&pages_skipped)) {
 		int zid;
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
mm-vmscan-fix-comment-for-isolate_lru_pages.patch
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
mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch

