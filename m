From: akpm@linux-foundation.org
Subject: + mm-pagecache-gfp-flags-fix.patch added to -mm tree
Date: Mon, 15 Dec 2008 15:23:51 -0800
Message-ID: <200812152323.mBFNNq3T002583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751772AbYLOXX5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 18:23:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm: pagecache gfp flags fix
has been added to the -mm tree.  Its filename is
     mm-pagecache-gfp-flags-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: pagecache gfp flags fix
From: Nick Piggin <npiggin@suse.de>

Frustratingly, gfp_t is really divided into two classes of flags.  One are
the context dependent ones (can we sleep?  can we enter filesystem?  block
subsystem?  should we use some extra reserves, etc.).  The other ones are
the type of memory required and depend on how the algorithm is implemented
rather than the point at which the memory is allocated (highmem?  dma
memory?  etc).

Some of the functions which allocate a page and add it to page cache take
a gfp_t, but sometimes those functions or their callers aren't really
doing the right thing: when allocating pagecache page, the memory type
should be mapping_gfp_mask(mapping).  When allocating radix tree nodes,
the memory type should be kernel mapped (not highmem) memory.  The gfp_t
argument should only really be needed for context dependent options.

This patch doesn't really solve that tangle in a nice way, but it does
attempt to fix a couple of bugs.

- find_or_create_page changes its radix-tree allocation to only include
  the main context dependent flags in order so the pagecache page may be
  allocated from arbitrary types of memory without affecting the
  radix-tree.  In practice, slab allocations don't come from highmem
  anyway, and radix-tree only uses slab allocations.  So there isn't a
  practical change (unless some fs uses GFP_DMA for pages).

- grab_cache_page_nowait() is changed to allocate radix-tree nodes with
  GFP_NOFS, because it is not supposed to reenter the filesystem.  This
  bug could cause lock recursion if a filesystem is not expecting the
  function to reenter the fs (as-per documentation).

Filesystems should be careful about exactly what semantics they want and
what they get when fiddling with gfp_t masks to allocate pagecache.  One
should be as liberal as possible with the type of memory that can be used,
and same for the the context specific flags.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN mm/filemap.c~mm-pagecache-gfp-flags-fix mm/filemap.c
--- a/mm/filemap.c~mm-pagecache-gfp-flags-fix
+++ a/mm/filemap.c
@@ -793,7 +793,14 @@ repeat:
 		page = __page_cache_alloc(gfp_mask);
 		if (!page)
 			return NULL;
-		err = add_to_page_cache_lru(page, mapping, index, gfp_mask);
+		/*
+		 * We want a regular kernel memory (not highmem or DMA etc)
+		 * allocation for the radix tree nodes, but we need to honour
+		 * the context-specific requirements the caller has asked for.
+		 * GFP_RECLAIM_MASK collects those requirements.
+		 */
+		err = add_to_page_cache_lru(page, mapping, index,
+			(gfp_mask & GFP_RECLAIM_MASK));
 		if (unlikely(err)) {
 			page_cache_release(page);
 			page = NULL;
@@ -1002,7 +1009,7 @@ grab_cache_page_nowait(struct address_sp
 		return NULL;
 	}
 	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~__GFP_FS);
-	if (page && add_to_page_cache_lru(page, mapping, index, GFP_KERNEL)) {
+	if (page && add_to_page_cache_lru(page, mapping, index, GFP_NOFS)) {
 		page_cache_release(page);
 		page = NULL;
 	}
_

Patches currently in -mm which might be from npiggin@suse.de are

fs-symlink-write_begin-allocation-context-fix.patch
linux-next.patch
mm-dont-mark_page_accessed-in-fault-path.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-invoke-oom-killer-from-page-fault.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-cyclic-fix.patch
mm-write_cache_pages-cyclic-fix-fix.patch
mm-write_cache_pages-early-loop-termination.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-write_cache_pages-integrity-fix.patch
mm-write_cache_pages-cleanups.patch
mm-write_cache_pages-optimise-page-cleaning.patch
mm-write_cache_pages-terminate-quickly.patch
mm-write_cache_pages-more-terminate-quickly.patch
mm-do_sync_mapping_range-integrity-fix.patch
mm-get-rid-of-pagevec_release_nonlru.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-vmalloc-tweak-failure-printk.patch
mm-vmalloc-improve-vmallocinfo.patch
mm-vmalloc-use-mutex-for-purge.patch
mm-vmalloc-make-lazy-unmapping-configurable.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
hugetlb-unsigned-ret-cannot-be-negative.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-direct-io-starvation-improvement.patch
fs-remove-wb_sync_hold.patch
fs-sync_sb_inodes-fix.patch
fs-sys_sync-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
mm-pagecache-gfp-flags-fix.patch
reiser4.patch

