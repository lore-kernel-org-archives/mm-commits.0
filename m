From: akpm@linux-foundation.org
Subject: - tmpfs-make-shmem_unuse-more-preemptible.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:30:38 -0800
Message-ID: <200802052230.m15MUJNP012058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932090AbYBEWmv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     tmpfs: make shmem_unuse more preemptible
has been removed from the -mm tree.  Its filename was
     tmpfs-make-shmem_unuse-more-preemptible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: make shmem_unuse more preemptible
From: Hugh Dickins <hugh@veritas.com>

shmem_unuse is at present an unbroken search through every swap vector page of
every tmpfs file which might be swapped, all under shmem_swaplist_lock.  This
dates from long ago, when the caller held mmlist_lock over it all too: long
gone, but there's never been much pressure for preemptible swapoff.

Make it a little more preemptible, replacing shmem_swaplist_lock by
shmem_swaplist_mutex, inserting a cond_resched in the main loop, and a
cond_resched_lock (on info->lock) at one convenient point in the
shmem_unuse_inode loop, where it has no outstanding kmap_atomic.

If we're serious about preemptible swapoff, there's much further to go e.g. 
I'm stupid to let the kmap_atomics of the decreasingly significant HIGHMEM
case dictate preemptiblility for other configs.  But as in the earlier patch
to make swapoff scan ptes preemptibly, my hidden agenda is really towards
making memcgroups work, hardly about preemptibility at all.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff -puN mm/shmem.c~tmpfs-make-shmem_unuse-more-preemptible mm/shmem.c
--- a/mm/shmem.c~tmpfs-make-shmem_unuse-more-preemptible
+++ a/mm/shmem.c
@@ -193,7 +193,7 @@ static struct backing_dev_info shmem_bac
 };
 
 static LIST_HEAD(shmem_swaplist);
-static DEFINE_SPINLOCK(shmem_swaplist_lock);
+static DEFINE_MUTEX(shmem_swaplist_mutex);
 
 static void shmem_free_blocks(struct inode *inode, long pages)
 {
@@ -796,9 +796,9 @@ static void shmem_delete_inode(struct in
 		inode->i_size = 0;
 		shmem_truncate(inode);
 		if (!list_empty(&info->swaplist)) {
-			spin_lock(&shmem_swaplist_lock);
+			mutex_lock(&shmem_swaplist_mutex);
 			list_del_init(&info->swaplist);
-			spin_unlock(&shmem_swaplist_lock);
+			mutex_unlock(&shmem_swaplist_mutex);
 		}
 	}
 	BUG_ON(inode->i_blocks);
@@ -851,6 +851,14 @@ static int shmem_unuse_inode(struct shme
 	for (idx = SHMEM_NR_DIRECT; idx < limit; idx += ENTRIES_PER_PAGE, dir++) {
 		if (unlikely(idx == stage)) {
 			shmem_dir_unmap(dir-1);
+			if (cond_resched_lock(&info->lock)) {
+				/* check it has not been truncated */
+				if (limit > info->next_index) {
+					limit = info->next_index;
+					if (idx >= limit)
+						goto lost2;
+				}
+			}
 			dir = shmem_dir_map(info->i_indirect) +
 			    ENTRIES_PER_PAGE/2 + idx/ENTRIES_PER_PAGEPAGE;
 			while (!*dir) {
@@ -924,7 +932,7 @@ int shmem_unuse(swp_entry_t entry, struc
 	struct shmem_inode_info *info;
 	int found = 0;
 
-	spin_lock(&shmem_swaplist_lock);
+	mutex_lock(&shmem_swaplist_mutex);
 	list_for_each_safe(p, next, &shmem_swaplist) {
 		info = list_entry(p, struct shmem_inode_info, swaplist);
 		if (!info->swapped)
@@ -935,8 +943,9 @@ int shmem_unuse(swp_entry_t entry, struc
 			found = 1;
 			break;
 		}
+		cond_resched();
 	}
-	spin_unlock(&shmem_swaplist_lock);
+	mutex_unlock(&shmem_swaplist_mutex);
 	return found;
 }
 
@@ -996,10 +1005,10 @@ static int shmem_writepage(struct page *
 		shmem_swp_unmap(entry);
 		spin_unlock(&info->lock);
 		if (list_empty(&info->swaplist)) {
-			spin_lock(&shmem_swaplist_lock);
+			mutex_lock(&shmem_swaplist_mutex);
 			/* move instead of add in case we're racing */
 			list_move_tail(&info->swaplist, &shmem_swaplist);
-			spin_unlock(&shmem_swaplist_lock);
+			mutex_unlock(&shmem_swaplist_mutex);
 		}
 		swap_duplicate(swap);
 		BUG_ON(page_mapped(page));
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
