From: akpm@linux-foundation.org
Subject: [merged] slob-use-pg_slab-for-identifying-slob-pages.patch removed from -mm tree
Date: Tue, 12 May 2009 11:48:42 -0700
Message-ID: <200905121848.n4CImg8H016002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbZELSyE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 14:54:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, adobriyan@gmail.com, andi@firstfloor.org, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, mpm@selenic.com, penberg@cs.helsinki.fi, mm-c


The patch titled
     slob: use PG_slab for identifying SLOB pages
has been removed from the -mm tree.  Its filename was
     slob-use-pg_slab-for-identifying-slob-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slob: use PG_slab for identifying SLOB pages
From: Wu Fengguang <fengguang.wu@intel.com>

For the sake of consistency.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 --
 mm/slob.c                  |    6 +++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff -puN include/linux/page-flags.h~slob-use-pg_slab-for-identifying-slob-pages include/linux/page-flags.h
--- a/include/linux/page-flags.h~slob-use-pg_slab-for-identifying-slob-pages
+++ a/include/linux/page-flags.h
@@ -120,7 +120,6 @@ enum pageflags {
 	PG_savepinned = PG_dirty,
 
 	/* SLOB */
-	PG_slob_page = PG_active,
 	PG_slob_free = PG_private,
 
 	/* SLUB */
@@ -203,7 +202,6 @@ PAGEFLAG(SavePinned, savepinned);			/* X
 PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
 PAGEFLAG(SwapBacked, swapbacked) __CLEARPAGEFLAG(SwapBacked, swapbacked)
 
-__PAGEFLAG(SlobPage, slob_page)
 __PAGEFLAG(SlobFree, slob_free)
 
 __PAGEFLAG(SlubFrozen, slub_frozen)
diff -puN mm/slob.c~slob-use-pg_slab-for-identifying-slob-pages mm/slob.c
--- a/mm/slob.c~slob-use-pg_slab-for-identifying-slob-pages
+++ a/mm/slob.c
@@ -133,17 +133,17 @@ static LIST_HEAD(free_slob_large);
  */
 static inline int is_slob_page(struct slob_page *sp)
 {
-	return PageSlobPage((struct page *)sp);
+	return PageSlab((struct page *)sp);
 }
 
 static inline void set_slob_page(struct slob_page *sp)
 {
-	__SetPageSlobPage((struct page *)sp);
+	__SetPageSlab((struct page *)sp);
 }
 
 static inline void clear_slob_page(struct slob_page *sp)
 {
-	__ClearPageSlobPage((struct page *)sp);
+	__ClearPageSlab((struct page *)sp);
 }
 
 static inline struct slob_page *slob_page(const void *addr)
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
readahead-make-mmap_miss-an-unsigned-int.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-one-unnecessary-radix-tree-lookup.patch
readahead-increase-interleaved-readahead-size.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
radix-tree-add-radix_tree_prev_hole.patch
readahead-move-the-random-read-case-to-bottom.patch
readahead-introduce-context-readahead-algorithm.patch
readahead-introduce-context-readahead-algorithm-update.patch
readahead-remove-redundant-test-in-shrink_readahead_size_eio.patch
readahead-enforce-full-sync-mmap-readahead-size.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch
pagemap-document-clarifications.patch
pagemap-document-9-more-exported-page-flags.patch
pagemap-add-page-types-tool.patch
pagemap-export-pg_hwpoison.patch
pagemap-export-pg_hwpoison-fix.patch
vmscan-cleanup-the-scan-batching-code.patch
vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo.patch
vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch
inotify-reimplement-inotify-using-fsnotify-report-rounded-up-event-size-to-user-space.patch

