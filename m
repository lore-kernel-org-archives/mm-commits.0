From: akpm@linux-foundation.org
Subject: + tmpfs-fix-spurious-enospc-when-racing-with-unswap.patch added to -mm tree
Date: Tue, 10 May 2011 14:13:13 -0700
Message-ID: <201105102113.p4ALDEqi022245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625Ab1EJVNT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 May 2011 17:13:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, khlebnikov@openvz.org, stable@kernel.org


The patch titled
     tmpfs: fix spurious ENOSPC when racing with unswap
has been added to the -mm tree.  Its filename is
     tmpfs-fix-spurious-enospc-when-racing-with-unswap.patch

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
Subject: tmpfs: fix spurious ENOSPC when racing with unswap
From: Hugh Dickins <hughd@google.com>

Testing the shmem_swaplist replacements for igrab() revealed another bug:
writes to /dev/loop0 on a tmpfs file which fills its filesystem were
sometimes failing with "Buffer I/O error"s.

These came from ENOSPC failures of shmem_getpage(), when racing with
swapoff: the same could happen when racing with another shmem_getpage(),
pulling the page in from swap in between our find_lock_page() and our
taking the info->lock (though not in the single-threaded loop case).

This is unacceptable, and surprising that I've not noticed it before:
it dates back many years, but (presumably) was made a lot easier to
reproduce in 2.6.36, which sited a page preallocation in the race window.

Fix it by rechecking the page cache before settling on an ENOSPC error.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff -puN mm/shmem.c~tmpfs-fix-spurious-enospc-when-racing-with-unswap mm/shmem.c
--- a/mm/shmem.c~tmpfs-fix-spurious-enospc-when-racing-with-unswap
+++ a/mm/shmem.c
@@ -1407,20 +1407,14 @@ repeat:
 		if (sbinfo->max_blocks) {
 			if (percpu_counter_compare(&sbinfo->used_blocks,
 						sbinfo->max_blocks) >= 0 ||
-			    shmem_acct_block(info->flags)) {
-				spin_unlock(&info->lock);
-				error = -ENOSPC;
-				goto failed;
-			}
+			    shmem_acct_block(info->flags))
+				goto nospace;
 			percpu_counter_inc(&sbinfo->used_blocks);
 			spin_lock(&inode->i_lock);
 			inode->i_blocks += BLOCKS_PER_PAGE;
 			spin_unlock(&inode->i_lock);
-		} else if (shmem_acct_block(info->flags)) {
-			spin_unlock(&info->lock);
-			error = -ENOSPC;
-			goto failed;
-		}
+		} else if (shmem_acct_block(info->flags))
+			goto nospace;
 
 		if (!filepage) {
 			int ret;
@@ -1500,6 +1494,24 @@ done:
 	error = 0;
 	goto out;
 
+nospace:
+	/*
+	 * Perhaps the page was brought in from swap between find_lock_page
+	 * and taking info->lock?  We allow for that at add_to_page_cache_lru,
+	 * but must also avoid reporting a spurious ENOSPC while working on a
+	 * full tmpfs.  (When filepage has been passed in to shmem_getpage, it
+	 * is already in page cache, which prevents this race from occurring.)
+	 */
+	if (!filepage) {
+		struct page *page = find_get_page(mapping, idx);
+		if (page) {
+			spin_unlock(&info->lock);
+			page_cache_release(page);
+			goto repeat;
+		}
+	}
+	spin_unlock(&info->lock);
+	error = -ENOSPC;
 failed:
 	if (*pagep != filepage) {
 		unlock_page(filepage);
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

