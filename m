From: akpm@linux-foundation.org
Subject: [merged] mm-a-few-small-updates-for-radix-swap.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:51:24 -0700
Message-ID: <201108161848.p7GImV4v015334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753156Ab1HPStG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:49:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: a few small updates for radix-swap
has been removed from the -mm tree.  Its filename was
     mm-a-few-small-updates-for-radix-swap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 
@@ -462,6 +461,7 @@ int add_to_page_cache_locked(struct page
 	int error;
 
 	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON(PageSwapBacked(page));
 
 	error = mem_cgroup_cache_charge(page, current->mm,
 					gfp_mask & GFP_RECLAIM_MASK);
@@ -479,8 +479,6 @@ int add_to_page_cache_locked(struct page
 		if (likely(!error)) {
 			mapping->nrpages++;
 			__inc_zone_page_state(page, NR_FILE_PAGES);
-			if (PageSwapBacked(page))
-				__inc_zone_page_state(page, NR_SHMEM);
 			spin_unlock_irq(&mapping->tree_lock);
 		} else {
 			page->mapping = NULL;
@@ -502,22 +500,9 @@ int add_to_page_cache_lru(struct page *p
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
@@ -69,12 +69,14 @@ static unsigned char mincore_page(struct
 	 * file will not get a swp_entry_t in its pte, but rather it is like
 	 * any other file mapping (ie. marked !present and faulted in with
 	 * tmpfs's .fault). So swapped out tmpfs mappings are tested here.
-	 *
-	 * However when tmpfs moves the page from pagecache and into swapcache,
-	 * it is still in core, but the find_get_page below won't find it.
-	 * No big deal, but make a note of it.
 	 */
 	page = find_get_page(mapping, pgoff);
+#ifdef CONFIG_SWAP
+	if (radix_tree_exceptional_entry(page)) {
+		swp_entry_t swap = radix_to_swp_entry(page);
+		page = find_get_page(&swapper_space, swap.val);
+	}
+#endif
 	if (page) {
 		present = PageUptodate(page);
 		page_cache_release(page);
diff -puN mm/truncate.c~mm-a-few-small-updates-for-radix-swap mm/truncate.c
--- a/mm/truncate.c~mm-a-few-small-updates-for-radix-swap
+++ a/mm/truncate.c
@@ -336,6 +336,14 @@ unsigned long invalidate_mapping_pages(s
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

linux-next.patch
radix_tree-clean-away-saw_unset_tag-leftovers.patch
tmpfs-add-tmpfs-to-the-kconfig-prompt-to-make-it-obvious.patch
prio_tree-debugging-patch.patch

