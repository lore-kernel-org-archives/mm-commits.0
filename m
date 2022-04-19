Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB09C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 03:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347275AbiDSECJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 00:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240345AbiDSECF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 00:02:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2186521E26
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 20:59:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A89C16112D
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 03:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF2AC385A5;
        Tue, 19 Apr 2022 03:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650340757;
        bh=BNuRMG2SOm0oYeUDEjvmYF4xfLBGkioMuDa/uAb801Y=;
        h=Date:To:From:Subject:From;
        b=c7LLfgrGjpWXmMFVW64r4Q/d85oOxZPgDwjxFy2PcKd09xR7LVNpX/kPO2cK4h1B1
         Xjhi9QRVFR4xN3hLVL+ujKHSD60bkhtNnbRbETA4/uE41qFMHp1IIZP1Jl6P+BVfDr
         CVyhgOySJQfCUWagDxVj3ItsrBRw7qVG64GZDVbo=
Date:   Mon, 18 Apr 2022 20:59:16 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, pintu@codeaurora.org,
        david@redhat.com, charante@codeaurora.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-simplify-the-code-in-__compact_finished.patch added to -mm tree
Message-Id: <20220419035917.0FF2AC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: simplify the code in __compact_finished
has been added to the -mm tree.  Its filename is
     mm-compaction-simplify-the-code-in-__compact_finished.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-simplify-the-code-in-__compact_finished.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-simplify-the-code-in-__compact_finished.patch

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

