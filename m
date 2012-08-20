From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-remove-__gfp_no_kswapd.patch removed from -mm tree
Date: Mon, 20 Aug 2012 15:56:16 -0700
Message-ID: <20120820225617.91AB9200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:40424 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab2HTW4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 18:56:20 -0400
Received: by weyr1 with SMTP id r1so314918wey.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 15:56:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, David.Woodhouse@intel.com, aarcange@redhat.com, artem.bityutskiy@linux.intel.com, mel@csn.ul.ie, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove __GFP_NO_KSWAPD
has been removed from the -mm tree.  Its filename was
     mm-remove-__gfp_no_kswapd.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm: remove __GFP_NO_KSWAPD

When transparent huge pages were introduced, memory compaction and swap
storms were an issue, and the kernel had to be careful to not make THP
allocations cause pageout or compaction.

Now that we have working compaction deferral, kswapd is smart enough to
invoke compaction and the quadratic behaviour around isolate_free_pages
has been fixed, it should be safe to remove __GFP_NO_KSWAPD.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    5 +----
 mm/page_alloc.c     |    7 +++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff -puN include/linux/gfp.h~mm-remove-__gfp_no_kswapd include/linux/gfp.h
--- a/include/linux/gfp.h~mm-remove-__gfp_no_kswapd
+++ a/include/linux/gfp.h
@@ -35,7 +35,6 @@ struct vm_area_struct;
 #else
 #define ___GFP_NOTRACK		0
 #endif
-#define ___GFP_NO_KSWAPD	0x400000u
 #define ___GFP_OTHER_NODE	0x800000u
 #define ___GFP_WRITE		0x1000000u
 
@@ -90,7 +89,6 @@ struct vm_area_struct;
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE) /* Page is reclaimable */
 #define __GFP_NOTRACK	((__force gfp_t)___GFP_NOTRACK)  /* Don't track with kmemcheck */
 
-#define __GFP_NO_KSWAPD	((__force gfp_t)___GFP_NO_KSWAPD)
 #define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE) /* On behalf of other node */
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)	/* Allocator intends to dirty page */
 
@@ -120,8 +118,7 @@ struct vm_area_struct;
 				 __GFP_MOVABLE)
 #define GFP_IOFS	(__GFP_IO | __GFP_FS)
 #define GFP_TRANSHUGE	(GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
-			 __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN | \
-			 __GFP_NO_KSWAPD)
+			 __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN)
 
 #ifdef CONFIG_NUMA
 #define GFP_THISNODE	(__GFP_THISNODE | __GFP_NOWARN | __GFP_NORETRY)
diff -puN mm/page_alloc.c~mm-remove-__gfp_no_kswapd mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-__gfp_no_kswapd
+++ a/mm/page_alloc.c
@@ -2348,9 +2348,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 		goto nopage;
 
 restart:
-	if (!(gfp_mask & __GFP_NO_KSWAPD))
-		wake_all_kswapd(order, zonelist, high_zoneidx,
-						zone_idx(preferred_zone));
+	wake_all_kswapd(order, zonelist, high_zoneidx,
+					zone_idx(preferred_zone));
 
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
@@ -2433,7 +2432,7 @@ rebalance:
 	 * has requested the system not be heavily disrupted, fail the
 	 * allocation now instead of entering direct reclaim
 	 */
-	if (deferred_compaction && (gfp_mask & __GFP_NO_KSWAPD))
+	if (deferred_compaction)
 		goto nopage;
 
 	/* Try direct reclaim and then allocating */
_

Patches currently in -mm which might be from riel@redhat.com are

linux-next.patch
mm-hugetlbfs-correctly-populate-shared-pmd.patch
mm-hugetlbfs-correctly-populate-shared-pmd-fix.patch
mm-compactionc-fix-deferring-compaction-mistake.patch
mm-have-order-0-compaction-start-near-a-pageblock-with-free-pages-v2.patch
remove-__gfp_no_kswapd-fixes.patch
remove-__gfp_no_kswapd-fixes-fix.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
mm-have-order-0-compaction-start-near-a-pageblock-with-free-pages.patch
mm-compaction-abort-async-compaction-if-locks-are-contended-or-taking-too-long.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-performance-and-correctness-test.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch
rbtree-optimize-fetching-of-sibling-node.patch
rbtree-test-fix-sparse-warning-about-64-bit-constant.patch
rbtree-add-__rb_change_child-helper-function.patch
rbtree-place-easiest-case-first-in-rb_erase.patch
rbtree-handle-1-child-recoloring-in-rb_erase-instead-of-rb_erase_color.patch
rbtree-low-level-optimizations-in-rb_erase.patch
rbtree-augmented-rbtree-test.patch
rbtree-faster-augmented-rbtree-manipulation.patch
rbtree-remove-prior-augmented-rbtree-implementation.patch
rbtree-add-rb_declare_callbacks-macro.patch

