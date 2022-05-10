Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2745AC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236019AbiEJER4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236033AbiEJERA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:17:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9D02438C8
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:12:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B94F6173E
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EF5C385C2;
        Tue, 10 May 2022 04:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155941;
        bh=vDV+3T686GaRofPe90ilbUtmVv7u9IKCoxSbKyEM8s4=;
        h=Date:To:From:Subject:From;
        b=nqav7UbeXVhPUDUOmLhl+3nS/iFl7BnWOBdiWBZF+MUlRggUVDjSNHvvJxt/dPW+l
         rzBDMyV//qcbniuKzvSg5ePQLLZM8d5nDbkaogpPkGdaHgeoHn3bVx4KiZuux5dRdE
         eqw5EErROA0UVsWU4482b9yjxSdmyLvHjQAqfZ0U=
Date:   Mon, 09 May 2022 21:12:20 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, pintu@codeaurora.org,
        david@redhat.com, charante@codeaurora.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-clean-up-comment-for-sched-contention.patch removed from -mm tree
Message-Id: <20220510041220.F3EF5C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: clean up comment for sched contention
has been removed from the -mm tree.  Its filename was
     mm-compaction-clean-up-comment-for-sched-contention.patch

This patch was dropped because it was merged into mm-stable

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
@@ -402,7 +402,7 @@ struct compact_control {
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

