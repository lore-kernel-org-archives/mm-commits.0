Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA341C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 20 Apr 2022 22:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353886AbiDTWZO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Apr 2022 18:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354616AbiDTWZN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Apr 2022 18:25:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16FE3CA63
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 15:22:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F40C1CE18D3
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 22:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B16C385A1;
        Wed, 20 Apr 2022 22:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650493342;
        bh=QyQ1jrElI+zd/WoWUtj61IWE2uO1oKbr9mH6/sCrItU=;
        h=Date:To:From:Subject:From;
        b=Fx6q++05FinjXTSDBIvwCzIPok+InkpZa4TyUzsUje1n6LEi086B1s0ry0+UlFBsM
         CoJyqy5QUW4HaNZDLgrfUta0n2j2Pl5qdno3WwqrAaGCNkgWPpNuLD1Qqk5KaskJ2x
         wSwUcNuO132n/cX/2aA1bAei7iGP60bjoxXxADMM=
Date:   Wed, 20 Apr 2022 15:22:21 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, shy828301@gmail.com,
        mhocko@suse.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-clean-up-the-code-logic-in-queue_pages_pte_range.patch added to -mm tree
Message-Id: <20220420222222.38B16C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: clean up the code logic in queue_pages_pte_range
has been added to the -mm tree.  Its filename is
     mm-mempolicy-clean-up-the-code-logic-in-queue_pages_pte_range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-clean-up-the-code-logic-in-queue_pages_pte_range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-clean-up-the-code-logic-in-queue_pages_pte_range.patch

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
Subject: mm/mempolicy: clean up the code logic in queue_pages_pte_range

Since commit e5947d23edd8 ("mm: mempolicy: don't have to split pmd for
huge zero page"), THP is never splited in queue_pages_pmd.  Thus 2 is
never returned now.  We can remove such unnecessary ret != 2 check and
clean up the relevant comment.  Minor improvements in readability.

Link: https://lkml.kernel.org/r/20220419122234.45083-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-clean-up-the-code-logic-in-queue_pages_pte_range
+++ a/mm/mempolicy.c
@@ -442,12 +442,11 @@ static inline bool queue_pages_required(
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
@@ -509,18 +508,13 @@ static int queue_pages_pte_range(pmd_t *
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
mm-mempolicy-clean-up-the-code-logic-in-queue_pages_pte_range.patch
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

