From: akpm@linux-foundation.org
Subject: + tmpfs-convert-shmem_unuse_inode-to-radix-swap.patch added to -mm tree
Date: Fri, 17 Jun 2011 16:39:58 -0700
Message-ID: <201106172339.p5HNdweJ008263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759585Ab1FQXkF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jun 2011 19:40:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, riel@redhat.com


The patch titled
     tmpfs: convert shmem_unuse_inode to radix-swap
has been added to the -mm tree.  Its filename is
     tmpfs-convert-shmem_unuse_inode-to-radix-swap.patch

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
Subject: tmpfs: convert shmem_unuse_inode to radix-swap
From: Hugh Dickins <hughd@google.com>

Convert shmem_unuse_inode() to use a lockless gang lookup of the radix
tree, searching for matching swap.

This is somewhat slower than the old method: because of repeated radix
tree descents, because of copying entries up, but probably most because
the old method noted and skipped once a vector page was cleared of swap. 
Perhaps we can devise a use of radix tree tagging to achieve that later.

shmem_add_to_page_cache() uses shmem_radix_tree_replace() to compensate
for the lockless lookup by checking that the expected entry is in place,
under lock.  It is not very satisfactory to be copying this much from
add_to_page_cache_locked(), but I think easier to sell than insisting that
every caller of add_to_page_cache*() go through the extras.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |  133 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 107 insertions(+), 26 deletions(-)

diff -puN mm/shmem.c~tmpfs-convert-shmem_unuse_inode-to-radix-swap mm/shmem.c
--- a/mm/shmem.c~tmpfs-convert-shmem_unuse_inode-to-radix-swap
+++ a/mm/shmem.c
@@ -262,6 +262,55 @@ static int shmem_radix_tree_replace(stru
 }
 
 /*
+ * Like add_to_page_cache_locked, but error if expected item has gone.
+ */
+static int shmem_add_to_page_cache(struct page *page,
+				   struct address_space *mapping,
+				   pgoff_t index, gfp_t gfp, void *expected)
+{
+	int error;
+
+	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON(!PageSwapBacked(page));
+
+	error = mem_cgroup_cache_charge(page, current->mm,
+						gfp & GFP_RECLAIM_MASK);
+	if (error)
+		goto out;
+	if (!expected)
+		error = radix_tree_preload(gfp & GFP_RECLAIM_MASK);
+	if (!error) {
+		page_cache_get(page);
+		page->mapping = mapping;
+		page->index = index;
+
+		spin_lock_irq(&mapping->tree_lock);
+		if (!expected)
+			error = radix_tree_insert(&mapping->page_tree,
+							index, page);
+		else
+			error = shmem_radix_tree_replace(mapping, index,
+							expected, page);
+		if (!error) {
+			mapping->nrpages++;
+			__inc_zone_page_state(page, NR_FILE_PAGES);
+			__inc_zone_page_state(page, NR_SHMEM);
+			spin_unlock_irq(&mapping->tree_lock);
+		} else {
+			page->mapping = NULL;
+			spin_unlock_irq(&mapping->tree_lock);
+			page_cache_release(page);
+		}
+		if (!expected)
+			radix_tree_preload_end();
+	}
+	if (error)
+		mem_cgroup_uncharge_cache_page(page);
+out:
+	return error;
+}
+
+/*
  * Like find_get_pages, but collecting swap entries as well as pages.
  */
 static unsigned shmem_find_get_pages_and_swap(struct address_space *mapping,
@@ -309,6 +358,42 @@ export:
 }
 
 /*
+ * Lockless lookup of swap entry in radix tree, avoiding refcount on pages.
+ */
+static pgoff_t shmem_find_swap(struct address_space *mapping, void *radswap)
+{
+	void  **slots[PAGEVEC_SIZE];
+	pgoff_t indices[PAGEVEC_SIZE];
+	unsigned int nr_found;
+
+restart:
+	nr_found = 1;
+	indices[0] = -1;
+	while (nr_found) {
+		pgoff_t index = indices[nr_found - 1] + 1;
+		unsigned int i;
+
+		rcu_read_lock();
+		nr_found = radix_tree_gang_lookup_slot(&mapping->page_tree,
+					slots, indices, index, PAGEVEC_SIZE);
+		for (i = 0; i < nr_found; i++) {
+			void *item = radix_tree_deref_slot(slots[i]);
+			if (radix_tree_deref_retry(item)) {
+				rcu_read_unlock();
+				goto restart;
+			}
+			if (item == radswap) {
+				rcu_read_unlock();
+				return indices[i];
+			}
+		}
+		rcu_read_unlock();
+		cond_resched();
+	}
+	return -1;
+}
+
+/*
  * Remove swap entry from radix tree, free the swap and its page cache.
  */
 static int shmem_free_swap(struct address_space *mapping,
@@ -515,23 +600,21 @@ static void shmem_evict_inode(struct ino
 	end_writeback(inode);
 }
 
+/*
+ * If swap found in inode, free it and move page from swapcache to filecache.
+ */
 static int shmem_unuse_inode(struct shmem_inode_info *info,
 			     swp_entry_t swap, struct page *page)
 {
 	struct address_space *mapping = info->vfs_inode.i_mapping;
+	void *radswap;
 	pgoff_t index;
 	int error;
 
-	for (index = 0; index < SHMEM_NR_DIRECT; index++)
-		if (shmem_get_swap(info, index).val == swap.val)
-			goto found;
-	return 0;
-found:
-	spin_lock(&info->lock);
-	if (shmem_get_swap(info, index).val != swap.val) {
-		spin_unlock(&info->lock);
+	radswap = swp_to_radix_entry(swap);
+	index = shmem_find_swap(mapping, radswap);
+	if (index == -1)
 		return 0;
-	}
 
 	/*
 	 * Move _head_ to start search for next from here.
@@ -547,23 +630,30 @@ found:
 	 * but also to hold up shmem_evict_inode(): so inode cannot be freed
 	 * beneath us (pagelock doesn't help until the page is in pagecache).
 	 */
-	error = add_to_page_cache_locked(page, mapping, index, GFP_NOWAIT);
+	error = shmem_add_to_page_cache(page, mapping, index,
+						GFP_NOWAIT, radswap);
 	/* which does mem_cgroup_uncharge_cache_page on error */
 
 	if (error != -ENOMEM) {
+		/*
+		 * Truncation and eviction use free_swap_and_cache(), which
+		 * only does trylock page: if we raced, best clean up here.
+		 */
 		delete_from_swap_cache(page);
 		set_page_dirty(page);
-		shmem_put_swap(info, index, (swp_entry_t){0});
-		info->swapped--;
-		swap_free(swap);
+		if (!error) {
+			spin_lock(&info->lock);
+			info->swapped--;
+			spin_unlock(&info->lock);
+			swap_free(swap);
+		}
 		error = 1;	/* not an error, but entry was found */
 	}
-	spin_unlock(&info->lock);
 	return error;
 }
 
 /*
- * shmem_unuse() search for an eventually swapped out shmem page.
+ * Search through swapped inodes to find and replace swap by page.
  */
 int shmem_unuse(swp_entry_t swap, struct page *page)
 {
@@ -576,20 +666,12 @@ int shmem_unuse(swp_entry_t swap, struct
 	 * Charge page using GFP_KERNEL while we can wait, before taking
 	 * the shmem_swaplist_mutex which might hold up shmem_writepage().
 	 * Charged back to the user (not to caller) when swap account is used.
-	 * add_to_page_cache() will be called with GFP_NOWAIT.
+	 * shmem_add_to_page_cache() will be called with GFP_NOWAIT.
 	 */
 	error = mem_cgroup_cache_charge(page, current->mm, GFP_KERNEL);
 	if (error)
 		goto out;
-	/*
-	 * Try to preload while we can wait, to not make a habit of
-	 * draining atomic reserves; but don't latch on to this cpu,
-	 * it's okay if sometimes we get rescheduled after this.
-	 */
-	error = radix_tree_preload(GFP_KERNEL);
-	if (error)
-		goto uncharge;
-	radix_tree_preload_end();
+	/* No radix_tree_preload: swap entry keeps a place for page in tree */
 
 	mutex_lock(&shmem_swaplist_mutex);
 	list_for_each_safe(this, next, &shmem_swaplist) {
@@ -608,7 +690,6 @@ int shmem_unuse(swp_entry_t swap, struct
 	}
 	mutex_unlock(&shmem_swaplist_mutex);
 
-uncharge:
 	if (!found)
 		mem_cgroup_uncharge_cache_page(page);
 	if (found < 0)
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

