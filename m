From: akpm@linux-foundation.org
Subject: [merged] tmpfs-fix-race-between-umount-and-writepage.patch removed from -mm tree
Date: Thu, 12 May 2011 11:54:51 -0700
Message-ID: <201105121847.p4CIlOV1025953@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685Ab1ELSra (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 May 2011 14:47:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, khlebnikov@openvz.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     tmpfs: fix race between umount and writepage
has been removed from the -mm tree.  Its filename was
     tmpfs-fix-race-between-umount-and-writepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: fix race between umount and writepage
From: Hugh Dickins <hughd@google.com>

Konstanin Khlebnikov reports that a dangerous race between umount and
shmem_writepage can be reproduced by this script:

for i in {1..300} ; do
	mkdir $i
	while true ; do
		mount -t tmpfs none $i
		dd if=/dev/zero of=$i/test bs=1M count=$(($RANDOM % 100))
		umount $i
	done &
done

on a 6xCPU node with 8Gb RAM: kernel very unstable after this accident. =)

Kernel log:

VFS: Busy inodes after unmount of tmpfs.
               Self-destruct in 5 seconds.  Have a nice day...

WARNING: at lib/list_debug.c:53 __list_del_entry+0x8d/0x98()
list_del corruption. prev->next should be ffff880222fdaac8, but was (null)
Pid: 11222, comm: mount.tmpfs Not tainted 2.6.39-rc2+ #4
Call Trace:
 warn_slowpath_common+0x80/0x98
 warn_slowpath_fmt+0x41/0x43
 __list_del_entry+0x8d/0x98
 evict+0x50/0x113
 iput+0x138/0x141
...
BUG: unable to handle kernel paging request at ffffffffffffffff
IP: shmem_free_blocks+0x18/0x4c
Pid: 10422, comm: dd Tainted: G        W   2.6.39-rc2+ #4
Call Trace:
 shmem_recalc_inode+0x61/0x66
 shmem_writepage+0xba/0x1dc
 pageout+0x13c/0x24c
 shrink_page_list+0x28e/0x4be
 shrink_inactive_list+0x21f/0x382
...

shmem_writepage() calls igrab() on the inode for the page which came from
page reclaim, to add it later into shmem_swaplist for swapoff operation.

This igrab() can race with super-block deactivating process:

shrink_inactive_list()		deactivate_super()
pageout()			tmpfs_fs_type->kill_sb()
shmem_writepage()		kill_litter_super()
				generic_shutdown_super()
				 evict_inodes()
 igrab()
				  atomic_read(&inode->i_count)
				   skip-inode
 iput()
				 if (!list_empty(&sb->s_inodes))
					printk("VFS: Busy inodes after...

This igrap-iput pair was added in commit 1b1b32f2c6f6 "tmpfs: fix
shmem_swaplist races" based on incorrect assumptions: igrab() protects the
inode from concurrent eviction by deletion, but it does nothing to protect
it from concurrent unmounting, which goes ahead despite the raised
i_count.

So this use of igrab() was wrong all along, but the race made much worse
in 2.6.37 when commit 63997e98a3be "split invalidate_inodes()" replaced
two attempts at invalidate_inodes() by a single evict_inodes().

Konstantin posted a plausible patch, raising sb->s_active too: I'm unsure
whether it was correct or not; but burnt once by igrab(), I am sure that
we don't want to rely more deeply upon externals here.

Fix it by adding the inode to shmem_swaplist earlier, while the page lock
on page in page cache still secures the inode against eviction, without
artifically raising i_count.  It was originally added later because
shmem_unuse_inode() is liable to remove an inode from the list while it's
unswapped; but we can guard against that by taking spinlock before
dropping mutex.

Reported-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Tested-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff -puN mm/shmem.c~tmpfs-fix-race-between-umount-and-writepage mm/shmem.c
--- a/mm/shmem.c~tmpfs-fix-race-between-umount-and-writepage
+++ a/mm/shmem.c
@@ -1039,6 +1039,7 @@ static int shmem_writepage(struct page *
 	struct address_space *mapping;
 	unsigned long index;
 	struct inode *inode;
+	bool unlock_mutex = false;
 
 	BUG_ON(!PageLocked(page));
 	mapping = page->mapping;
@@ -1064,7 +1065,26 @@ static int shmem_writepage(struct page *
 	else
 		swap.val = 0;
 
+	/*
+	 * Add inode to shmem_unuse()'s list of swapped-out inodes,
+	 * if it's not already there.  Do it now because we cannot take
+	 * mutex while holding spinlock, and must do so before the page
+	 * is moved to swap cache, when its pagelock no longer protects
+	 * the inode from eviction.  But don't unlock the mutex until
+	 * we've taken the spinlock, because shmem_unuse_inode() will
+	 * prune a !swapped inode from the swaplist under both locks.
+	 */
+	if (swap.val && list_empty(&info->swaplist)) {
+		mutex_lock(&shmem_swaplist_mutex);
+		/* move instead of add in case we're racing */
+		list_move_tail(&info->swaplist, &shmem_swaplist);
+		unlock_mutex = true;
+	}
+
 	spin_lock(&info->lock);
+	if (unlock_mutex)
+		mutex_unlock(&shmem_swaplist_mutex);
+
 	if (index >= info->next_index) {
 		BUG_ON(!(info->flags & SHMEM_TRUNCATE));
 		goto unlock;
@@ -1084,21 +1104,10 @@ static int shmem_writepage(struct page *
 		delete_from_page_cache(page);
 		shmem_swp_set(info, entry, swap.val);
 		shmem_swp_unmap(entry);
-		if (list_empty(&info->swaplist))
-			inode = igrab(inode);
-		else
-			inode = NULL;
 		spin_unlock(&info->lock);
 		swap_shmem_alloc(swap);
 		BUG_ON(page_mapped(page));
 		swap_writepage(page, wbc);
-		if (inode) {
-			mutex_lock(&shmem_swaplist_mutex);
-			/* move instead of add in case we're racing */
-			list_move_tail(&info->swaplist, &shmem_swaplist);
-			mutex_unlock(&shmem_swaplist_mutex);
-			iput(inode);
-		}
 		return 0;
 	}
 
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mmap-add-alignment-for-some-variables.patch
mmap-avoid-unnecessary-anon_vma-lock.patch
mmap-avoid-merging-cloned-vmas.patch
mm-convert-vma-vm_flags-to-64-bit.patch
mm-add-__nocast-attribute-to-vm_flags.patch
fremap-convert-vm_flags-to-unsigned-long-long.patch
procfs-convert-vm_flags-to-unsigned-long-long.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch
mm-vmalloc-remove-guard-page-from-between-vmap-blocks.patch
mm-make-expand_downwards-symmetrical-with-expand_upwards.patch
mm-make-expand_downwards-symmetrical-with-expand_upwards-v4.patch
mm-mmu_gather-rework.patch
powerpc-mmu_gather-rework.patch
sparc-mmu_gather-rework.patch
s390-mmu_gather-rework.patch
arm-mmu_gather-rework.patch
sh-mmu_gather-rework.patch
ia64-mmu_gather-rework.patch
um-mmu_gather-rework.patch
mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage.patch
mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code.patch
mm-extended-batches-for-generic-mmu_gather.patch
lockdep-mutex-provide-mutex_lock_nest_lock.patch
mm-remove-i_mmap_lock-lockbreak.patch
mm-convert-i_mmap_lock-to-a-mutex.patch
mm-revert-page_lock_anon_vma-lock-annotation.patch
mm-improve-page_lock_anon_vma-comment.patch
mm-use-refcounts-for-page_lock_anon_vma.patch
mm-convert-anon_vma-lock-to-a-mutex.patch
mm-optimize-page_lock_anon_vma-fast-path.patch
mm-uninline-large-generic-tlbh-functions.patch
mm-thp-optimize-memcg-charge-in-khugepaged.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
mm-delete-non-atomic-mm-counter-implementation.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
mn10300-convert-old-cpumask-api-into-new-one.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch
prio_tree-debugging-patch.patch

