From: akpm@linux-foundation.org
Subject: + tmpfs-radix_tree_preloading.patch added to -mm tree
Date: Tue, 18 Dec 2007 14:34:50 -0800
Message-ID: <200712182234.lBIMYoId025491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38864 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753457AbXLRWe5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 17:34:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com


The patch titled
     tmpfs: radix_tree_preloading
has been added to the -mm tree.  Its filename is
     tmpfs-radix_tree_preloading.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tmpfs: radix_tree_preloading
From: Hugh Dickins <hugh@veritas.com>

Nick has observed that shmem.c still uses GFP_ATOMIC when adding to page cache
or swap cache, without any radix tree preload: so tending to deplete emergency
reserves of memory.

GFP_ATOMIC remains appropriate in shmem_writepage's add_to_swap_cache: it's
being called under memory pressure, so must not wait for more memory to become
available.  But shmem_unuse_inode now has a window in which it can and should
preload with GFP_KERNEL, and say GFP_NOWAIT instead of GFP_ATOMIC in its
add_to_page_cache.

shmem_getpage is not so straightforward: its filepage/swappage integrity
relies upon exchanging between caches under spinlock, and it would need a lot
of restructuring to place the preloads correctly.  Instead, follow its pattern
of retrying on races: use GFP_NOWAIT instead of GFP_ATOMIC in
add_to_page_cache, and begin each circuit of the repeat loop with a sleeping
radix_tree_preload, followed immediately by radix_tree_preload_end - that
won't guarantee success in the next add_to_page_cache, but doesn't need to.

And we can then remove that bothersome congestion_wait: when needed, it'll
automatically get done in the course of the radix_tree_preload.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff -puN mm/shmem.c~tmpfs-radix_tree_preloading mm/shmem.c
--- a/mm/shmem.c~tmpfs-radix_tree_preloading
+++ a/mm/shmem.c
@@ -901,12 +901,16 @@ found:
 	error = 1;
 	if (!inode)
 		goto out;
+	error = radix_tree_preload(GFP_KERNEL);
+	if (error)
+		goto out;
+	error = 1;
 
 	spin_lock(&info->lock);
 	ptr = shmem_swp_entry(info, idx, NULL);
 	if (ptr && ptr->val == entry.val)
 		error = add_to_page_cache(page, inode->i_mapping,
-						idx, GFP_ATOMIC);
+						idx, GFP_NOWAIT);
 	if (error == -EEXIST) {
 		struct page *filepage = find_get_page(inode->i_mapping, idx);
 		error = 1;
@@ -931,6 +935,7 @@ found:
 	if (ptr)
 		shmem_swp_unmap(ptr);
 	spin_unlock(&info->lock);
+	radix_tree_preload_end();
 out:
 	unlock_page(page);
 	page_cache_release(page);
@@ -1185,6 +1190,16 @@ repeat:
 		goto done;
 	error = 0;
 	gfp = mapping_gfp_mask(mapping);
+	if (!filepage) {
+		/*
+		 * Try to preload while we can wait, to not make a habit of
+		 * draining atomic reserves; but don't latch on to this cpu.
+		 */
+		error = radix_tree_preload(gfp & ~__GFP_HIGHMEM);
+		if (error)
+			goto failed;
+		radix_tree_preload_end();
+	}
 
 	spin_lock(&info->lock);
 	shmem_recalc_inode(inode);
@@ -1266,7 +1281,7 @@ repeat:
 			set_page_dirty(filepage);
 			swap_free(swap);
 		} else if (!(error = add_to_page_cache(
-				swappage, mapping, idx, GFP_ATOMIC))) {
+				swappage, mapping, idx, GFP_NOWAIT))) {
 			info->flags |= SHMEM_PAGEIN;
 			shmem_swp_set(info, entry, 0);
 			shmem_swp_unmap(entry);
@@ -1280,10 +1295,6 @@ repeat:
 			spin_unlock(&info->lock);
 			unlock_page(swappage);
 			page_cache_release(swappage);
-			if (error == -ENOMEM) {
-				/* let kswapd refresh zone for GFP_ATOMICs */
-				congestion_wait(WRITE, HZ/50);
-			}
 			goto repeat;
 		}
 	} else if (sgp == SGP_READ && !filepage) {
@@ -1338,7 +1349,7 @@ repeat:
 				shmem_swp_unmap(entry);
 			}
 			if (error || swap.val || 0 != add_to_page_cache_lru(
-					filepage, mapping, idx, GFP_ATOMIC)) {
+					filepage, mapping, idx, GFP_NOWAIT)) {
 				spin_unlock(&info->lock);
 				page_cache_release(filepage);
 				shmem_unacct_blocks(info->flags, 1);
_

Patches currently in -mm which might be from hugh@veritas.com are

git-unionfs.patch
swapin_readahead-excise-numa-bogosity.patch
swapin_readahead-move-and-rearrange-args.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
shmem-sgp_quick-and-sgp_fault-redundant.patch
shmem_getpage-return-page-locked.patch
shmem_file_write-is-redundant.patch
swapin-fix-valid_swaphandles-defect.patch
swapoff-scan-ptes-preemptibly.patch
shmem-factor-out-sbi-free_inodes-manipulations.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch
tmpfs-move-swap_state-stats-update.patch
tmpfs-shuffle-add_to_swap_caches.patch
tmpfs-move-swap-swizzling-into-shmem.patch
tmpfs-allow-filepage-alongside-swappage.patch
tmpfs-allocate-on-read-when-stacked.patch
tmpfs-make-shmem_unuse-more-preemptible.patch
tmpfs-open-a-window-in-shmem_unuse_inode.patch
tmpfs-radix_tree_preloading.patch
tmpfs-fix-shmem_swaplist-races.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
mm-dont-waste-swap-on-locked-pages.patch
skip-writing-data-pages-when-inode-is-under-i_sync.patch
printk-trivial-optimizations-fix.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
prio_tree-debugging-patch.patch
