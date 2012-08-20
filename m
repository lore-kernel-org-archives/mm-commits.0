From: akpm@linux-foundation.org
Subject: [obsolete] remove-__gfp_no_kswapd-fixes.patch removed from -mm tree
Date: Mon, 20 Aug 2012 15:56:58 -0700
Message-ID: <20120820225659.468741E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-iy0-f202.google.com ([209.85.210.202]:44194 "EHLO
	mail-iy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab2HTW5A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 18:57:00 -0400
Received: by mail-iy0-f202.google.com with SMTP id o24so951426ial.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 15:57:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, David.Woodhouse@intel.com, aarcange@redhat.com, artem.bityutskiy@linux.intel.com, mel@csn.ul.ie, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove __GFP_NO_KSWAPD fixes
has been removed from the -mm tree.  Its filename was
     remove-__gfp_no_kswapd-fixes.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm: remove __GFP_NO_KSWAPD fixes

Turns out I missed two spots where __GFP_NO_KSWAPD is used.

The removal from the trace code is obvious, since the flag
got removed there is no need to print it.

For mtdcore.c, now that memory compaction has been fixed, we should no
longer see large swap storms from an attempt to allocate a large buffer,
removing the need to specify __GFP_NO_KSWAPD.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdcore.c           |    3 +--
 include/trace/events/gfpflags.h |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/mtd/mtdcore.c~remove-__gfp_no_kswapd-fixes drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~remove-__gfp_no_kswapd-fixes
+++ a/drivers/mtd/mtdcore.c
@@ -1080,8 +1080,7 @@ EXPORT_SYMBOL_GPL(mtd_writev);
  */
 void *mtd_kmalloc_up_to(const struct mtd_info *mtd, size_t *size)
 {
-	gfp_t flags = __GFP_NOWARN | __GFP_WAIT |
-		       __GFP_NORETRY | __GFP_NO_KSWAPD;
+	gfp_t flags = __GFP_NOWARN | __GFP_WAIT | __GFP_NORETRY;
 	size_t min_alloc = max_t(size_t, mtd->writesize, PAGE_SIZE);
 	void *kbuf;
 
diff -puN include/trace/events/gfpflags.h~remove-__gfp_no_kswapd-fixes include/trace/events/gfpflags.h
--- a/include/trace/events/gfpflags.h~remove-__gfp_no_kswapd-fixes
+++ a/include/trace/events/gfpflags.h
@@ -36,7 +36,6 @@
 	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
 	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"},		\
 	{(unsigned long)__GFP_NOTRACK,		"GFP_NOTRACK"},		\
-	{(unsigned long)__GFP_NO_KSWAPD,	"GFP_NO_KSWAPD"},	\
 	{(unsigned long)__GFP_OTHER_NODE,	"GFP_OTHER_NODE"}	\
 	) : "GFP_NOWAIT"
 
_

Patches currently in -mm which might be from riel@redhat.com are

linux-next.patch
mm-hugetlbfs-correctly-populate-shared-pmd.patch
mm-hugetlbfs-correctly-populate-shared-pmd-fix.patch
mm-compactionc-fix-deferring-compaction-mistake.patch
mm-have-order-0-compaction-start-near-a-pageblock-with-free-pages-v2.patch
mm-remove-__gfp_no_kswapd.patch
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

