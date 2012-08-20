From: akpm@linux-foundation.org
Subject: + mm-remove-__gfp_no_kswapd.patch added to -mm tree
Date: Mon, 20 Aug 2012 15:56:50 -0700
Message-ID: <20120820225650.9720D100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-iy0-f202.google.com ([209.85.210.202]:44194 "EHLO
	mail-iy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab2HTW4x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 18:56:53 -0400
Received: by ialo24 with SMTP id o24so951426ial.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 15:56:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, aarcange@redhat.com, mgorman@suse.de


The patch titled
     Subject: mm: remove __GFP_NO_KSWAPD
has been added to the -mm tree.  Its filename is
     mm-remove-__gfp_no_kswapd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm: remove __GFP_NO_KSWAPD

When transparent huge pages were introduced, memory compaction and swap
storms were an issue, and the kernel had to be careful to not make THP
allocations cause pageout or compaction.

Now that we have working compaction deferral, kswapd is smart enough to
invoke compaction and the quadratic behaviour around isolate_free_pages
has been fixed, it should be safe to remove __GFP_NO_KSWAPD.

[minchan@kernel.org: Comment fix]
[mgorman@suse.de: Avoid direct reclaim for deferred compaction]
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdcore.c           |    6 ++----
 include/linux/gfp.h             |    5 +----
 include/trace/events/gfpflags.h |    1 -
 mm/page_alloc.c                 |    7 +++----
 4 files changed, 6 insertions(+), 13 deletions(-)

diff -puN drivers/mtd/mtdcore.c~mm-remove-__gfp_no_kswapd drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~mm-remove-__gfp_no_kswapd
+++ a/drivers/mtd/mtdcore.c
@@ -1077,8 +1077,7 @@ EXPORT_SYMBOL_GPL(mtd_writev);
  * until the request succeeds or until the allocation size falls below
  * the system page size. This attempts to make sure it does not adversely
  * impact system performance, so when allocating more than one page, we
- * ask the memory allocator to avoid re-trying, swapping, writing back
- * or performing I/O.
+ * ask the memory allocator to avoid re-trying.
  *
  * Note, this function also makes sure that the allocated buffer is aligned to
  * the MTD device's min. I/O unit, i.e. the "mtd->writesize" value.
@@ -1092,8 +1091,7 @@ EXPORT_SYMBOL_GPL(mtd_writev);
  */
 void *mtd_kmalloc_up_to(const struct mtd_info *mtd, size_t *size)
 {
-	gfp_t flags = __GFP_NOWARN | __GFP_WAIT |
-		       __GFP_NORETRY | __GFP_NO_KSWAPD;
+	gfp_t flags = __GFP_NOWARN | __GFP_WAIT | __GFP_NORETRY;
 	size_t min_alloc = max_t(size_t, mtd->writesize, PAGE_SIZE);
 	void *kbuf;
 
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
diff -puN include/trace/events/gfpflags.h~mm-remove-__gfp_no_kswapd include/trace/events/gfpflags.h
--- a/include/trace/events/gfpflags.h~mm-remove-__gfp_no_kswapd
+++ a/include/trace/events/gfpflags.h
@@ -36,7 +36,6 @@
 	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
 	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"},		\
 	{(unsigned long)__GFP_NOTRACK,		"GFP_NOTRACK"},		\
-	{(unsigned long)__GFP_NO_KSWAPD,	"GFP_NO_KSWAPD"},	\
 	{(unsigned long)__GFP_OTHER_NODE,	"GFP_OTHER_NODE"}	\
 	) : "GFP_NOWAIT"
 
diff -puN mm/page_alloc.c~mm-remove-__gfp_no_kswapd mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-__gfp_no_kswapd
+++ a/mm/page_alloc.c
@@ -2361,9 +2361,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 		goto nopage;
 
 restart:
-	if (!(gfp_mask & __GFP_NO_KSWAPD))
-		wake_all_kswapd(order, zonelist, high_zoneidx,
-						zone_idx(preferred_zone));
+	wake_all_kswapd(order, zonelist, high_zoneidx,
+					zone_idx(preferred_zone));
 
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
@@ -2440,7 +2439,7 @@ rebalance:
 	 * system then fail the allocation instead of entering direct reclaim.
 	 */
 	if ((deferred_compaction || contended_compaction) &&
-						(gfp_mask & __GFP_NO_KSWAPD))
+	    (gfp_mask & (__GFP_MOVABLE|__GFP_REPEAT)) == __GFP_MOVABLE)
 		goto nopage;
 
 	/* Try direct reclaim and then allocating */
_

Patches currently in -mm which might be from riel@redhat.com are

linux-next.patch
mm-hugetlbfs-correctly-populate-shared-pmd.patch
mm-hugetlbfs-correctly-populate-shared-pmd-fix.patch
mm-compactionc-fix-deferring-compaction-mistake.patch
mm-have-order-0-compaction-start-near-a-pageblock-with-free-pages-v2.patch
mm-remove-__gfp_no_kswapd.patch
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

