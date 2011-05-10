From: akpm@linux-foundation.org
Subject: + tmpfs-fix-race-between-umount-and-swapoff.patch added to -mm tree
Date: Tue, 10 May 2011 14:13:11 -0700
Message-ID: <201105102113.p4ALDCcf022242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625Ab1EJVNR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 May 2011 17:13:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, khlebnikov@openvz.org, stable@kernel.org


The patch titled
     tmpfs: fix race between umount and swapoff
has been added to the -mm tree.  Its filename is
     tmpfs-fix-race-between-umount-and-swapoff.patch

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
Subject: tmpfs: fix race between umount and swapoff
From: Hugh Dickins <hughd@google.com>

The use of igrab() in swapoff's shmem_unuse_inode() is just as vulnerable
to umount as that in shmem_writepage().

Fix this instance by extending the protection of shmem_swaplist_mutex
right across shmem_unuse_inode(): while it's on the list, the inode cannot
be evicted (and the filesystem cannot be unmounted) without
shmem_evict_inode() taking that mutex to remove it from the list.

But since shmem_writepage() might take that mutex, we should avoid making
memory allocations or memcg charges while holding it: prepare them at the
outer level in shmem_unuse().  When mem_cgroup_cache_charge() was
originally placed, we didn't know until that point that the page from swap
was actually a shmem page; but nowadays it's noted in the swap_map, so
we're safe to charge upfront.  For the radix_tree, do as is done in
shmem_getpage(): preload upfront, but don't pin to the cpu; so we make a
habit of refreshing the node pool, but might dip into GFP_NOWAIT reserves
on occasion if subsequently preempted.

With the allocation and charge moved out from shmem_unuse_inode(),
we can also hold index map and info->lock over from finding the entry.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   88 ++++++++++++++++++++++++---------------------------
 1 file changed, 43 insertions(+), 45 deletions(-)

diff -puN mm/shmem.c~tmpfs-fix-race-between-umount-and-swapoff mm/shmem.c
--- a/mm/shmem.c~tmpfs-fix-race-between-umount-and-swapoff
+++ a/mm/shmem.c
@@ -852,7 +852,7 @@ static inline int shmem_find_swp(swp_ent
 
 static int shmem_unuse_inode(struct shmem_inode_info *info, swp_entry_t entry, struct page *page)
 {
-	struct inode *inode;
+	struct address_space *mapping;
 	unsigned long idx;
 	unsigned long size;
 	unsigned long limit;
@@ -875,8 +875,10 @@ static int shmem_unuse_inode(struct shme
 	if (size > SHMEM_NR_DIRECT)
 		size = SHMEM_NR_DIRECT;
 	offset = shmem_find_swp(entry, ptr, ptr+size);
-	if (offset >= 0)
+	if (offset >= 0) {
+		shmem_swp_balance_unmap();
 		goto found;
+	}
 	if (!info->i_indirect)
 		goto lost2;
 
@@ -914,11 +916,11 @@ static int shmem_unuse_inode(struct shme
 			if (size > ENTRIES_PER_PAGE)
 				size = ENTRIES_PER_PAGE;
 			offset = shmem_find_swp(entry, ptr, ptr+size);
-			shmem_swp_unmap(ptr);
 			if (offset >= 0) {
 				shmem_dir_unmap(dir);
 				goto found;
 			}
+			shmem_swp_unmap(ptr);
 		}
 	}
 lost1:
@@ -928,8 +930,7 @@ lost2:
 	return 0;
 found:
 	idx += offset;
-	inode = igrab(&info->vfs_inode);
-	spin_unlock(&info->lock);
+	ptr += offset;
 
 	/*
 	 * Move _head_ to start search for next from here.
@@ -940,37 +941,18 @@ found:
 	 */
 	if (shmem_swaplist.next != &info->swaplist)
 		list_move_tail(&shmem_swaplist, &info->swaplist);
-	mutex_unlock(&shmem_swaplist_mutex);
 
-	error = 1;
-	if (!inode)
-		goto out;
 	/*
-	 * Charge page using GFP_KERNEL while we can wait.
-	 * Charged back to the user(not to caller) when swap account is used.
-	 * add_to_page_cache() will be called with GFP_NOWAIT.
+	 * We rely on shmem_swaplist_mutex, not only to protect the swaplist,
+	 * but also to hold up shmem_evict_inode(): so inode cannot be freed
+	 * beneath us (pagelock doesn't help until the page is in pagecache).
 	 */
-	error = mem_cgroup_cache_charge(page, current->mm, GFP_KERNEL);
-	if (error)
-		goto out;
-	error = radix_tree_preload(GFP_KERNEL);
-	if (error) {
-		mem_cgroup_uncharge_cache_page(page);
-		goto out;
-	}
-	error = 1;
-
-	spin_lock(&info->lock);
-	ptr = shmem_swp_entry(info, idx, NULL);
-	if (ptr && ptr->val == entry.val) {
-		error = add_to_page_cache_locked(page, inode->i_mapping,
-						idx, GFP_NOWAIT);
-		/* does mem_cgroup_uncharge_cache_page on error */
-	} else	/* we must compensate for our precharge above */
-		mem_cgroup_uncharge_cache_page(page);
+	mapping = info->vfs_inode.i_mapping;
+	error = add_to_page_cache_locked(page, mapping, idx, GFP_NOWAIT);
+	/* which does mem_cgroup_uncharge_cache_page on error */
 
 	if (error == -EEXIST) {
-		struct page *filepage = find_get_page(inode->i_mapping, idx);
+		struct page *filepage = find_get_page(mapping, idx);
 		error = 1;
 		if (filepage) {
 			/*
@@ -990,14 +972,8 @@ found:
 		swap_free(entry);
 		error = 1;	/* not an error, but entry was found */
 	}
-	if (ptr)
-		shmem_swp_unmap(ptr);
+	shmem_swp_unmap(ptr);
 	spin_unlock(&info->lock);
-	radix_tree_preload_end();
-out:
-	unlock_page(page);
-	page_cache_release(page);
-	iput(inode);		/* allows for NULL */
 	return error;
 }
 
@@ -1009,6 +985,26 @@ int shmem_unuse(swp_entry_t entry, struc
 	struct list_head *p, *next;
 	struct shmem_inode_info *info;
 	int found = 0;
+	int error;
+
+	/*
+	 * Charge page using GFP_KERNEL while we can wait, before taking
+	 * the shmem_swaplist_mutex which might hold up shmem_writepage().
+	 * Charged back to the user (not to caller) when swap account is used.
+	 * add_to_page_cache() will be called with GFP_NOWAIT.
+	 */
+	error = mem_cgroup_cache_charge(page, current->mm, GFP_KERNEL);
+	if (error)
+		goto out;
+	/*
+	 * Try to preload while we can wait, to not make a habit of
+	 * draining atomic reserves; but don't latch on to this cpu,
+	 * it's okay if sometimes we get rescheduled after this.
+	 */
+	error = radix_tree_preload(GFP_KERNEL);
+	if (error)
+		goto uncharge;
+	radix_tree_preload_end();
 
 	mutex_lock(&shmem_swaplist_mutex);
 	list_for_each_safe(p, next, &shmem_swaplist) {
@@ -1016,17 +1012,19 @@ int shmem_unuse(swp_entry_t entry, struc
 		found = shmem_unuse_inode(info, entry, page);
 		cond_resched();
 		if (found)
-			goto out;
+			break;
 	}
 	mutex_unlock(&shmem_swaplist_mutex);
-	/*
-	 * Can some race bring us here?  We've been holding page lock,
-	 * so I think not; but would rather try again later than BUG()
-	 */
+
+uncharge:
+	if (!found)
+		mem_cgroup_uncharge_cache_page(page);
+	if (found < 0)
+		error = found;
+out:
 	unlock_page(page);
 	page_cache_release(page);
-out:
-	return (found < 0) ? found : 0;
+	return error;
 }
 
 /*
_

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
tmpfs-fix-race-between-umount-and-writepage.patch
tmpfs-fix-race-between-umount-and-swapoff.patch
tmpfs-fix-spurious-enospc-when-racing-with-unswap.patch
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

