Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 634C7C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 03:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbiDSEBo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 00:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237705AbiDSEBn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 00:01:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE0021831
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 20:59:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3DFA7CE12A2
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 03:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C12C385A7;
        Tue, 19 Apr 2022 03:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650340738;
        bh=ZBgqgjXS1VtEucCwRBnPh3jFvoqbkOg5O9tR6J0Ad6U=;
        h=Date:To:From:Subject:From;
        b=Ae1j7AU/3zt75nXBMyoMn6T3UcTwS4dsbOrdkEuUhglnXibltESZGQiU5ixNMYwFy
         SoEauotMSH6NJ2yE5BA884yQrd6vu/ld+S56CPsolOUjS4lWtgoJ2K18GbUH+dxP/Y
         fHyX4sYFNWcNxdv/tzcPyDWgnicxT/WVuKzeJ/bU=
Date:   Mon, 18 Apr 2022 20:58:57 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, pintu@codeaurora.org,
        david@redhat.com, charante@codeaurora.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-remove-unneeded-return-value-of-kcompactd_run.patch added to -mm tree
Message-Id: <20220419035858.55C12C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: remove unneeded return value of kcompactd_run
has been added to the -mm tree.  Its filename is
     mm-compaction-remove-unneeded-return-value-of-kcompactd_run.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-remove-unneeded-return-value-of-kcompactd_run.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-remove-unneeded-return-value-of-kcompactd_run.patch

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
Subject: mm: compaction: remove unneeded return value of kcompactd_run

Patch series "A few cleanup and fixup patches for compaction".

This series contains a few patches to clean up some obsolete comment,
remove unneeded return value and so on.  Also we fix the possible NULL
pointer dereference.  More details can be found in the respective
changelogs.


This patch (of 12):

The return value of kcompactd_run() is unused now.  Clean it up.

Link: https://lkml.kernel.org/r/20220418141253.24298-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220418141253.24298-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc; Mel Gorman <mgorman@techsingularity.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Pintu Kumar <pintu@codeaurora.org>
Cc: Charan Teja Kalla <charante@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    5 ++---
 mm/compaction.c            |    7 ++-----
 2 files changed, 4 insertions(+), 8 deletions(-)

--- a/include/linux/compaction.h~mm-compaction-remove-unneeded-return-value-of-kcompactd_run
+++ a/include/linux/compaction.h
@@ -177,7 +177,7 @@ static inline bool compaction_withdrawn(
 bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
 					int alloc_flags);
 
-extern int kcompactd_run(int nid);
+extern void kcompactd_run(int nid);
 extern void kcompactd_stop(int nid);
 extern void wakeup_kcompactd(pg_data_t *pgdat, int order, int highest_zoneidx);
 
@@ -212,9 +212,8 @@ static inline bool compaction_withdrawn(
 	return true;
 }
 
-static inline int kcompactd_run(int nid)
+static inline void kcompactd_run(int nid)
 {
-	return 0;
 }
 static inline void kcompactd_stop(int nid)
 {
--- a/mm/compaction.c~mm-compaction-remove-unneeded-return-value-of-kcompactd_run
+++ a/mm/compaction.c
@@ -3016,21 +3016,18 @@ static int kcompactd(void *p)
  * This kcompactd start function will be called by init and node-hot-add.
  * On node-hot-add, kcompactd will moved to proper cpus if cpus are hot-added.
  */
-int kcompactd_run(int nid)
+void kcompactd_run(int nid)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
-	int ret = 0;
 
 	if (pgdat->kcompactd)
-		return 0;
+		return;
 
 	pgdat->kcompactd = kthread_run(kcompactd, pgdat, "kcompactd%d", nid);
 	if (IS_ERR(pgdat->kcompactd)) {
 		pr_err("Failed to start kcompactd on node %d\n", nid);
-		ret = PTR_ERR(pgdat->kcompactd);
 		pgdat->kcompactd = NULL;
 	}
-	return ret;
 }
 
 /*
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

