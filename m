From: akpm@linux-foundation.org
Subject: - tmpfs-fix-shmem_swaplist-races.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:30:47 -0800
Message-ID: <200802052230.m15MUSSt012070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33729 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932140AbYBEWmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     tmpfs: fix shmem_swaplist races
has been removed from the -mm tree.  Its filename was
     tmpfs-fix-shmem_swaplist-races.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: fix shmem_swaplist races
From: Hugh Dickins <hugh@veritas.com>

Intensive swapoff testing shows shmem_unuse spinning on an entry in
shmem_swaplist pointing to itself: how does that come about?  Days pass...

First guess is this: shmem_delete_inode tests list_empty without taking the
global mutex (so the swapping case doesn't slow down the common case); but
there's an instant in shmem_unuse_inode's list_move_tail when the list entry
may appear empty (a rare case, because it's actually moving the head not the
the list member).  So there's a danger of leaving the inode on the swaplist
when it's freed, then reinitialized to point to itself when reused.  Fix that
by skipping the list_move_tail when it's a no-op, which happens to plug this.

But this same spinning then surfaces on another machine.  Ah, I'd never
suspected it, but shmem_writepage's swaplist manipulation is unsafe: though we
still hold page lock, which would hold off inode deletion if the page were in
pagecache, it doesn't hold off once it's in swapcache (free_swap_and_cache
doesn't wait on locked pages).  Hmm: we could put the the inode on swaplist
earlier, but then shmem_unuse_inode could never prune unswapped inodes.

Fix this with an igrab before dropping info->lock, as in shmem_unuse_inode;
though I am a little uneasy about the iput which has to follow - it works, and
I see nothing wrong with it, but it is surprising that shmem inode deletion
may now occur below shmem_writepage.  Revisit this fix later?

And while we're looking at these races: the way shmem_unuse tests swapped
without holding info->lock looks unsafe, if we've more than one swap area: a
racing shmem_writepage on another page of the same inode could be putting it
in swapcache, just as we're deciding to remove the inode from swaplist -
there's a danger of going on swap without being listed, so a later swapoff
would hang, being unable to locate the entry.  Move that test and removal down
into shmem_unuse_inode, once info->lock is held.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff -puN mm/shmem.c~tmpfs-fix-shmem_swaplist-races mm/shmem.c
--- a/mm/shmem.c~tmpfs-fix-shmem_swaplist-races
+++ a/mm/shmem.c
@@ -833,6 +833,10 @@ static int shmem_unuse_inode(struct shme
 	idx = 0;
 	ptr = info->i_direct;
 	spin_lock(&info->lock);
+	if (!info->swapped) {
+		list_del_init(&info->swaplist);
+		goto lost2;
+	}
 	limit = info->next_index;
 	size = limit;
 	if (size > SHMEM_NR_DIRECT)
@@ -894,8 +898,15 @@ found:
 	inode = igrab(&info->vfs_inode);
 	spin_unlock(&info->lock);
 
-	/* move head to start search for next from here */
-	list_move_tail(&shmem_swaplist, &info->swaplist);
+	/*
+	 * Move _head_ to start search for next from here.
+	 * But be careful: shmem_delete_inode checks list_empty without taking
+	 * mutex, and there's an instant in list_move_tail when info->swaplist
+	 * would appear empty, if it were the only one on shmem_swaplist.  We
+	 * could avoid doing it if inode NULL; or use this minor optimization.
+	 */
+	if (shmem_swaplist.next != &info->swaplist)
+		list_move_tail(&shmem_swaplist, &info->swaplist);
 	mutex_unlock(&shmem_swaplist_mutex);
 
 	error = 1;
@@ -955,10 +966,7 @@ int shmem_unuse(swp_entry_t entry, struc
 	mutex_lock(&shmem_swaplist_mutex);
 	list_for_each_safe(p, next, &shmem_swaplist) {
 		info = list_entry(p, struct shmem_inode_info, swaplist);
-		if (info->swapped)
-			found = shmem_unuse_inode(info, entry, page);
-		else
-			list_del_init(&info->swaplist);
+		found = shmem_unuse_inode(info, entry, page);
 		cond_resched();
 		if (found)
 			goto out;
@@ -1021,18 +1029,23 @@ static int shmem_writepage(struct page *
 		remove_from_page_cache(page);
 		shmem_swp_set(info, entry, swap.val);
 		shmem_swp_unmap(entry);
+		if (list_empty(&info->swaplist))
+			inode = igrab(inode);
+		else
+			inode = NULL;
 		spin_unlock(&info->lock);
-		if (list_empty(&info->swaplist)) {
-			mutex_lock(&shmem_swaplist_mutex);
-			/* move instead of add in case we're racing */
-			list_move_tail(&info->swaplist, &shmem_swaplist);
-			mutex_unlock(&shmem_swaplist_mutex);
-		}
 		swap_duplicate(swap);
 		BUG_ON(page_mapped(page));
 		page_cache_release(page);	/* pagecache ref */
 		set_page_dirty(page);
 		unlock_page(page);
+		if (inode) {
+			mutex_lock(&shmem_swaplist_mutex);
+			/* move instead of add in case we're racing */
+			list_move_tail(&info->swaplist, &shmem_swaplist);
+			mutex_unlock(&shmem_swaplist_mutex);
+			iput(inode);
+		}
 		return 0;
 	}
 
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-unionfs.patch
git-x86.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-tmpfs-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
prio_tree-debugging-patch.patch
