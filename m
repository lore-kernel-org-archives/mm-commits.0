Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB43EC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235971AbiEJESK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbiEJEQz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:16:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A765B243108
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:12:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 366B1B81AE7
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E0BC385A6;
        Tue, 10 May 2022 04:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155938;
        bh=tOQTMSLL2hH0vo9Vvj3sFS1xT3CeK/1RISuURcRKt/A=;
        h=Date:To:From:Subject:From;
        b=dlaW2c1Qsw+959cmd7zIGkxxBGbkFbnmuArOirLcRFkdA2sfzabdt6UUoRVKVn/XX
         lQE27tyJGNRszNX6+tYXzx/dKQPesCgEm3fbR35MX53g7bsUeGFwIqh/de7K65HJyf
         3WlAQXUgBrsevgyvHl6V5gh/6pR+tiELHadjh2nc=
Date:   Mon, 09 May 2022 21:12:17 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, pintu@codeaurora.org,
        david@redhat.com, charante@codeaurora.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-remove-unneeded-return-value-of-kcompactd_run.patch removed from -mm tree
Message-Id: <20220510041217.E5E0BC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: remove unneeded return value of kcompactd_run
has been removed from the -mm tree.  Its filename was
     mm-compaction-remove-unneeded-return-value-of-kcompactd_run.patch

This patch was dropped because it was merged into mm-stable

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

