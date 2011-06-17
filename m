From: akpm@linux-foundation.org
Subject: + mm-a-few-small-updates-for-radix-swap.patch added to -mm tree
Date: Fri, 17 Jun 2011 16:40:09 -0700
Message-ID: <201106172340.p5HNeANS008329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759588Ab1FQXkO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jun 2011 19:40:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, riel@redhat.com


The patch titled
     mm: a few small updates for radix-swap
has been added to the -mm tree.  Its filename is
     mm-a-few-small-updates-for-radix-swap.patch

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
Subject: mm: a few small updates for radix-swap
From: Hugh Dickins <hughd@google.com>

Remove PageSwapBacked (!page_is_file_cache) cases from
add_to_page_cache_locked() and add_to_page_cache_lru(): those pages now go
through shmem_add_to_page_cache().

Remove a comment on maximum tmpfs size from fsstack_copy_inode_size(), and
add a comment on swap entries to invalidate_mapping_pages().

And mincore_page() uses find_get_page() on what might be shmem or a tmpfs
file: allow for a radix_tree_exceptional_entry(), and proceed to
find_get_page() on swapper_space if so (oh, swapper_space needs #ifdef).

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/stack.c    |    5 +----
 mm/filemap.c  |   21 +++------------------
 mm/mincore.c  |   10 ++++++----
 mm/truncate.c |    8 ++++++++
 4 files changed, 18 insertions(+), 26 deletions(-)

diff -puN fs/stack.c~mm-a-few-small-updates-for-radix-swap fs/stack.c
--- a/fs/stack.c~mm-a-few-small-updates-for-radix-swap
+++ a/fs/stack.c
@@ -29,10 +29,7 @@ void fsstack_copy_inode_size(struct inod
 	 *
 	 * We don't actually know what locking is used at the lower level;
 	 * but if it's a filesystem that supports quotas, it will be using
-	 * i_lock as in inode_add_bytes().  tmpfs uses other locking, and
-	 * its 32-bit is (just) able to exceed 2TB i_size with the aid of
-	 * holes; but its i_blocks cannot carry into the upper long without
-	 * almost 2TB swap - let's ignore that case.
+	 * i_lock as in inode_add_bytes().
 	 */
 	if (sizeof(i_blocks) > sizeof(long))
 		spin_lock(&src->i_lock);
diff -puN mm/filemap.c~mm-a-few-small-updates-for-radix-swap mm/filemap.c
--- a/mm/filemap.c~mm-a-few-small-updates-for-radix-swap
+++ a/mm/filemap.c
@@ -33,7 +33,6 @@
 #include <linux/cpuset.h>
 #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
 #include <linux/memcontrol.h>
-#include <linux/mm_inline.h> /* for page_is_file_cache() */
 #include <linux/cleancache.h>
 #include "internal.h"
 
@@ -465,6 +464,7 @@ int add_to_page_cache_locked(struct page
 	int error;
 
 	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON(PageSwapBacked(page));
 
 	error = mem_cgroup_cache_charge(page, current->mm,
 					gfp_mask & GFP_RECLAIM_MASK);
@@ -482,8 +482,6 @@ int add_to_page_cache_locked(struct page
 		if (likely(!error)) {
 			mapping->nrpages++;
 			__inc_zone_page_state(page, NR_FILE_PAGES);
-			if (PageSwapBacked(page))
-				__inc_zone_page_state(page, NR_SHMEM);
 			spin_unlock_irq(&mapping->tree_lock);
 		} else {
 			page->mapping = NULL;
@@ -505,22 +503,9 @@ int add_to_page_cache_lru(struct page *p
 {
 	int ret;
 
-	/*
-	 * Splice_read and readahead add shmem/tmpfs pages into the page cache
-	 * before shmem_readpage has a chance to mark them as SwapBacked: they
-	 * need to go on the anon lru below, and mem_cgroup_cache_charge
-	 * (called in add_to_page_cache) needs to know where they're going too.
-	 */
-	if (mapping_cap_swap_backed(mapping))
-		SetPageSwapBacked(page);
-
 	ret = add_to_page_cache(page, mapping, offset, gfp_mask);
-	if (ret == 0) {
-		if (page_is_file_cache(page))
-			lru_cache_add_file(page);
-		else
-			lru_cache_add_anon(page);
-	}
+	if (ret == 0)
+		lru_cache_add_file(page);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(add_to_page_cache_lru);
diff -puN mm/mincore.c~mm-a-few-small-updates-for-radix-swap mm/mincore.c
--- a/mm/mincore.c~mm-a-few-small-updates-for-radix-swap
+++ a/mm/mincore.c
@@ -69,13 +69,15 @@ static unsigned char mincore_page(struct
 	 * file will not get a swp_entry_t in its pte, but rather it is like
 	 * any other file mapping (ie. marked !present and faulted in with
 	 * tmpfs's .fault). So swapped out tmpfs mappings are tested here.
-	 *
-	 * However when tmpfs moves the page from pagecache and into swapcache,
-	 * it is still in core, but the find_get_page below won't find it.
-	 * No big deal, but make a note of it.
 	 */
 	page = find_get_page(mapping, pgoff);
 	if (page) {
+#ifdef CONFIG_SWAP
+		if (radix_tree_exceptional_entry(page)) {
+			swp_entry_t swap = radix_to_swp_entry(page);
+			page = find_get_page(&swapper_space, swap.val);
+		}
+#endif
 		present = PageUptodate(page);
 		page_cache_release(page);
 	}
diff -puN mm/truncate.c~mm-a-few-small-updates-for-radix-swap mm/truncate.c
--- a/mm/truncate.c~mm-a-few-small-updates-for-radix-swap
+++ a/mm/truncate.c
@@ -331,6 +331,14 @@ unsigned long invalidate_mapping_pages(s
 	unsigned long count = 0;
 	int i;
 
+	/*
+	 * Note: this function may get called on a shmem/tmpfs mapping:
+	 * pagevec_lookup() might then return 0 prematurely (because it
+	 * got a gangful of swap entries); but it's hardly worth worrying
+	 * about - it can rarely have anything to free from such a mapping
+	 * (most pages are dirty), and already skips over any difficulties.
+	 */
+
 	pagevec_init(&pvec, 0);
 	while (index <= end && pagevec_lookup(&pvec, mapping, index,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-move-vmtruncate_range-to-truncatec.patch
mm-move-shmem-prototypes-to-shmem_fsh.patch
tmpfs-take-control-of-its-truncate_range.patch
tmpfs-add-shmem_read_mapping_page_gfp.patch
drm-ttm-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_truncate_range.patch
drm-i915-more-struct_mutex-locking.patch
drm-i915-more-struct_mutex-locking-fix.patch
mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
linux-next.patch
tmpfs-clone-shmem_file_splice_read.patch
tmpfs-refine-shmem_file_splice_read.patch
tmpfs-pass-gfp-to-shmem_getpage_gfp.patch
tmpfs-remove_shmem_readpage.patch
tmpfs-simplify-prealloc_page.patch
tmpfs-simplify-filepage-swappage.patch
tmpfs-simplify-unuse-and-writepage.patch
radix_tree-exceptional-entries-and-indices.patch
mm-let-swap-use-exceptional-entries.patch
tmpfs-demolish-old-swap-vector-support.patch
tmpfs-miscellaneous-trivial-cleanups.patch
tmpfs-copy-truncate_inode_pages_range.patch
tmpfs-convert-shmem_truncate_range-to-radix-swap.patch
tmpfs-convert-shmem_unuse_inode-to-radix-swap.patch
tmpfs-convert-shmem_getpage_gfp-to-radix-swap.patch
tmpfs-convert-mem_cgroup-shmem-to-radix-swap.patch
tmpfs-convert-shmem_writepage-and-enable-swap.patch
tmpfs-use-kmemdup-for-short-symlinks.patch
mm-a-few-small-updates-for-radix-swap.patch
prio_tree-debugging-patch.patch

