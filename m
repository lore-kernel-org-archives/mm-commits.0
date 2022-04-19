Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C869C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 03:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347264AbiDSECG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 00:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347243AbiDSEBx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 00:01:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD22521E00
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 20:59:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E40661168
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 03:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8C7C385A7;
        Tue, 19 Apr 2022 03:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650340751;
        bh=QKDYc8Aib9EW/7+6M3Ke5JqWD+VEKiaQtW5vSh1Mzs8=;
        h=Date:To:From:Subject:From;
        b=zklnzLZwZXGWaHclgp7zdWHOHC1HYU81p8YVFXnNAxeqfwaQgl1aqK/6fDSAhvFHj
         Olo3NMljyxqNNdEXt/KM3jm3+BOCp6oMO45/bZrYJux51X0tgAI9OlKiotpk8EPEiy
         +RG5HrjsqfrmYWj0zmwrvyXlt9bw6M/jQrUDwOas=
Date:   Mon, 18 Apr 2022 20:59:11 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, pintu@codeaurora.org,
        david@redhat.com, charante@codeaurora.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-clean-up-comment-about-async-compaction-in-isolate_migratepages.patch added to -mm tree
Message-Id: <20220419035911.9B8C7C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: clean up comment about async compaction in isolate_migratepages
has been added to the -mm tree.  Its filename is
     mm-compaction-clean-up-comment-about-async-compaction-in-isolate_migratepages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-clean-up-comment-about-async-compaction-in-isolate_migratepages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-clean-up-comment-about-async-compaction-in-isolate_migratepages.patch

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
Subject: mm: compaction: clean up comment about async compaction in isolate_migratepages

Since commit 282722b0d258 ("mm, compaction: restrict async compaction to
pageblocks of same migratetype"), async direct compaction is restricted to
scan the pageblocks of same migratetype.  Correct the comment accordingly.

Link: https://lkml.kernel.org/r/20220418141253.24298-9-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Charan Teja Kalla <charante@codeaurora.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Pintu Kumar <pintu@codeaurora.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/compaction.c~mm-compaction-clean-up-comment-about-async-compaction-in-isolate_migratepages
+++ a/mm/compaction.c
@@ -1941,12 +1941,12 @@ static isolate_migrate_t isolate_migrate
 			continue;
 
 		/*
-		 * For async compaction, also only scan in MOVABLE blocks
-		 * without huge pages. Async compaction is optimistic to see
-		 * if the minimum amount of work satisfies the allocation.
-		 * The cached PFN is updated as it's possible that all
-		 * remaining blocks between source and target are unsuitable
-		 * and the compaction scanners fail to meet.
+		 * For async direct compaction, only scan the pageblocks of the
+		 * same migratetype without huge pages. Async direct compaction
+		 * is optimistic to see if the minimum amount of work satisfies
+		 * the allocation. The cached PFN is updated as it's possible
+		 * that all remaining blocks between source and target are
+		 * unsuitable and the compaction scanners fail to meet.
 		 */
 		if (!suitable_migration_source(cc, page)) {
 			update_cached_migrate(cc, block_end_pfn);
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

