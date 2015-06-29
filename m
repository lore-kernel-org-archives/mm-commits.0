From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-inline-should_alloc_retry.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:38:26 -0700
Message-ID: <5591acc2.ig6Nd1jghTcU0it5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbbF2Ui1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:38:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, aarcange@redhat.com, david@fromorbit.com, mhocko@suse.cz, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: inline should_alloc_retry()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-inline-should_alloc_retry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: inline should_alloc_retry()

The should_alloc_retry() function was meant to encapsulate retry
conditions of the allocator slowpath, but there are still checks remaining
in the main function, and much of how the retrying is performed also
depends on the OOM killer progress.  The physical separation of those
conditions make the code hard to follow.

Inline the should_alloc_retry() checks.  Notes:

- The __GFP_NOFAIL check is already done in __alloc_pages_may_oom(),
  replace it with looping on OOM killer progress

- The pm_suspended_storage() check is meant to skip the OOM killer
  when reclaim has no IO available, move to __alloc_pages_may_oom()

- The order <= PAGE_ALLOC_COSTLY order is re-united with its original
  counterpart of checking whether reclaim actually made any progress

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  104 ++++++++++++++--------------------------------
 1 file changed, 32 insertions(+), 72 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-inline-should_alloc_retry mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-inline-should_alloc_retry
+++ a/mm/page_alloc.c
@@ -2309,48 +2309,6 @@ void warn_alloc_failed(gfp_t gfp_mask, i
 		show_mem(filter);
 }
 
-static inline int
-should_alloc_retry(gfp_t gfp_mask, unsigned int order,
-				unsigned long did_some_progress,
-				unsigned long pages_reclaimed)
-{
-	/* Do not loop if specifically requested */
-	if (gfp_mask & __GFP_NORETRY)
-		return 0;
-
-	/* Always retry if specifically requested */
-	if (gfp_mask & __GFP_NOFAIL)
-		return 1;
-
-	/*
-	 * Suspend converts GFP_KERNEL to __GFP_WAIT which can prevent reclaim
-	 * making forward progress without invoking OOM. Suspend also disables
-	 * storage devices so kswapd will not help. Bail if we are suspending.
-	 */
-	if (!did_some_progress && pm_suspended_storage())
-		return 0;
-
-	/*
-	 * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
-	 * means __GFP_NOFAIL, but that may not be true in other
-	 * implementations.
-	 */
-	if (order <= PAGE_ALLOC_COSTLY_ORDER)
-		return 1;
-
-	/*
-	 * For order > PAGE_ALLOC_COSTLY_ORDER, if __GFP_REPEAT is
-	 * specified, then we retry until we no longer reclaim any pages
-	 * (above), or we've reclaimed an order of pages at least as
-	 * large as the allocation's order. In both cases, if the
-	 * allocation still fails, we stop retrying.
-	 */
-	if (gfp_mask & __GFP_REPEAT && pages_reclaimed < (1 << order))
-		return 1;
-
-	return 0;
-}
-
 static inline struct page *
 __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	const struct alloc_context *ac, unsigned long *did_some_progress)
@@ -2389,16 +2347,18 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		/* The OOM killer does not needlessly kill tasks for lowmem */
 		if (ac->high_zoneidx < ZONE_NORMAL)
 			goto out;
-		/* The OOM killer does not compensate for light reclaim */
+		/* The OOM killer does not compensate for IO-less reclaim */
 		if (!(gfp_mask & __GFP_FS)) {
 			/*
 			 * XXX: Page reclaim didn't yield anything,
 			 * and the OOM killer can't be invoked, but
-			 * keep looping as per should_alloc_retry().
+			 * keep looping as per tradition.
 			 */
 			*did_some_progress = 1;
 			goto out;
 		}
+		if (pm_suspended_storage())
+			goto out;
 		/* The OOM killer may not free memory on a specific node */
 		if (gfp_mask & __GFP_THISNODE)
 			goto out;
@@ -2781,40 +2741,40 @@ retry:
 	if (page)
 		goto got_pg;
 
-	/* Check if we should retry the allocation */
+	/* Do not loop if specifically requested */
+	if (gfp_mask & __GFP_NORETRY)
+		goto noretry;
+
+	/* Keep reclaiming pages as long as there is reasonable progress */
 	pages_reclaimed += did_some_progress;
-	if (should_alloc_retry(gfp_mask, order, did_some_progress,
-						pages_reclaimed)) {
-		/*
-		 * If we fail to make progress by freeing individual
-		 * pages, but the allocation wants us to keep going,
-		 * start OOM killing tasks.
-		 */
-		if (!did_some_progress) {
-			page = __alloc_pages_may_oom(gfp_mask, order, ac,
-							&did_some_progress);
-			if (page)
-				goto got_pg;
-			if (!did_some_progress)
-				goto nopage;
-		}
+	if ((did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER) ||
+	    ((gfp_mask & __GFP_REPEAT) && pages_reclaimed < (1 << order))) {
 		/* Wait for some write requests to complete then retry */
 		wait_iff_congested(ac->preferred_zone, BLK_RW_ASYNC, HZ/50);
 		goto retry;
-	} else {
-		/*
-		 * High-order allocations do not necessarily loop after
-		 * direct reclaim and reclaim/compaction depends on compaction
-		 * being called after reclaim so call directly if necessary
-		 */
-		page = __alloc_pages_direct_compact(gfp_mask, order,
-					alloc_flags, ac, migration_mode,
-					&contended_compaction,
-					&deferred_compaction);
-		if (page)
-			goto got_pg;
 	}
 
+	/* Reclaim has failed us, start killing things */
+	page = __alloc_pages_may_oom(gfp_mask, order, ac, &did_some_progress);
+	if (page)
+		goto got_pg;
+
+	/* Retry as long as the OOM killer is making progress */
+	if (did_some_progress)
+		goto retry;
+
+noretry:
+	/*
+	 * High-order allocations do not necessarily loop after
+	 * direct reclaim and reclaim/compaction depends on compaction
+	 * being called after reclaim so call directly if necessary
+	 */
+	page = __alloc_pages_direct_compact(gfp_mask, order, alloc_flags,
+					    ac, migration_mode,
+					    &contended_compaction,
+					    &deferred_compaction);
+	if (page)
+		goto got_pg;
 nopage:
 	warn_alloc_failed(gfp_mask, order, NULL);
 got_pg:
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch

