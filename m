Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68DEDC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 03:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347232AbiDSEBu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 00:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347243AbiDSEBs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 00:01:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F1021839
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 20:59:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57600B8118D
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 03:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074C7C385A5;
        Tue, 19 Apr 2022 03:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650340744;
        bh=xM6XsZ70ez8xVxiPqUjmXbTq4UOp+sJobbVai/MHEBU=;
        h=Date:To:From:Subject:From;
        b=WtlKXd2yGAQtfdSnzq/Cm6Nuw1gmNW8n39ZNoD1QV7fftjq0Ys5KQja723csCaGfj
         RaR06PsygLNgIJdOlrkPWujYnZQi41KKsVlA8Jx3XYbwdgn8ad/Ffl3YoGoskcVM1D
         nPeOi19xOs4ER26ecRUPVcBJ5oL87B9sLYto3Q/k=
Date:   Mon, 18 Apr 2022 20:59:03 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, pintu@codeaurora.org,
        david@redhat.com, charante@codeaurora.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-clean-up-comment-for-sched-contention.patch added to -mm tree
Message-Id: <20220419035904.074C7C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: clean up comment for sched contention
has been added to the -mm tree.  Its filename is
     mm-compaction-clean-up-comment-for-sched-contention.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-clean-up-comment-for-sched-contention.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-clean-up-comment-for-sched-contention.patch

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
Subject: mm: compaction: clean up comment for sched contention

Since commit cf66f0700c8f ("mm, compaction: do not consider a need to
reschedule as contention"), async compaction won't abort when scheduling
is needed.  Correct the relevant comment accordingly.

Link: https://lkml.kernel.org/r/20220418141253.24298-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Charan Teja Kalla <charante@codeaurora.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Pintu Kumar <pintu@codeaurora.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   11 ++++-------
 mm/internal.h   |    2 +-
 2 files changed, 5 insertions(+), 8 deletions(-)

--- a/mm/compaction.c~mm-compaction-clean-up-comment-for-sched-contention
+++ a/mm/compaction.c
@@ -513,15 +513,12 @@ static bool compact_lock_irqsave(spinloc
  * very heavily contended. The lock should be periodically unlocked to avoid
  * having disabled IRQs for a long time, even when there is nobody waiting on
  * the lock. It might also be that allowing the IRQs will result in
- * need_resched() becoming true. If scheduling is needed, async compaction
- * aborts. Sync compaction schedules.
+ * need_resched() becoming true. If scheduling is needed, compaction schedules.
  * Either compaction type will also abort if a fatal signal is pending.
  * In either case if the lock was locked, it is dropped and not regained.
  *
- * Returns true if compaction should abort due to fatal signal pending, or
- *		async compaction due to need_resched()
- * Returns false when compaction can continue (sync compaction might have
- *		scheduled)
+ * Returns true if compaction should abort due to fatal signal pending.
+ * Returns false when compaction can continue.
  */
 static bool compact_unlock_should_abort(spinlock_t *lock,
 		unsigned long flags, bool *locked, struct compact_control *cc)
@@ -574,7 +571,7 @@ static unsigned long isolate_freepages_b
 		/*
 		 * Periodically drop the lock (if held) regardless of its
 		 * contention, to give chance to IRQs. Abort if fatal signal
-		 * pending or async compaction detects need_resched()
+		 * pending.
 		 */
 		if (!(blockpfn % SWAP_CLUSTER_MAX)
 		    && compact_unlock_should_abort(&cc->zone->lock, flags,
--- a/mm/internal.h~mm-compaction-clean-up-comment-for-sched-contention
+++ a/mm/internal.h
@@ -404,7 +404,7 @@ struct compact_control {
 	bool direct_compaction;		/* False from kcompactd or /proc/... */
 	bool proactive_compaction;	/* kcompactd proactive compaction */
 	bool whole_zone;		/* Whole zone should/has been scanned */
-	bool contended;			/* Signal lock or sched contention */
+	bool contended;			/* Signal lock contention */
 	bool rescan;			/* Rescanning the same pageblock */
 	bool alloc_contig;		/* alloc_contig_range allocation */
 };
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

