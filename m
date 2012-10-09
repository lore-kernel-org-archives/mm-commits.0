From: akpm@linux-foundation.org
Subject: [merged] mm-remove-__gfp_no_kswapd.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:05:33 -0700
Message-ID: <20121009180534.68B7C200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:41222 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISFg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:05:36 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so362097bkw.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:05:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, aarcange@redhat.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove __GFP_NO_KSWAPD
has been removed from the -mm tree.  Its filename was
     mm-remove-__gfp_no_kswapd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1056,8 +1056,7 @@ EXPORT_SYMBOL_GPL(mtd_writev);
  * until the request succeeds or until the allocation size falls below
  * the system page size. This attempts to make sure it does not adversely
  * impact system performance, so when allocating more than one page, we
- * ask the memory allocator to avoid re-trying, swapping, writing back
- * or performing I/O.
+ * ask the memory allocator to avoid re-trying.
  *
  * Note, this function also makes sure that the allocated buffer is aligned to
  * the MTD device's min. I/O unit, i.e. the "mtd->writesize" value.
@@ -1071,8 +1070,7 @@ EXPORT_SYMBOL_GPL(mtd_writev);
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
@@ -2362,9 +2362,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 		goto nopage;
 
 restart:
-	if (!(gfp_mask & __GFP_NO_KSWAPD))
-		wake_all_kswapd(order, zonelist, high_zoneidx,
-						zone_idx(preferred_zone));
+	wake_all_kswapd(order, zonelist, high_zoneidx,
+					zone_idx(preferred_zone));
 
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
@@ -2441,7 +2440,7 @@ rebalance:
 	 * system then fail the allocation instead of entering direct reclaim.
 	 */
 	if ((deferred_compaction || contended_compaction) &&
-						(gfp_mask & __GFP_NO_KSWAPD))
+	    (gfp_mask & (__GFP_MOVABLE|__GFP_REPEAT)) == __GFP_MOVABLE)
 		goto nopage;
 
 	/* Try direct reclaim and then allocating */
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
linux-next.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

