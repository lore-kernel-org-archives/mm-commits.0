From: akpm@linux-foundation.org
Subject: + add-the-pagefault-count-into-memcg-stats-shmem-fix.patch added to -mm tree
Date: Tue, 17 May 2011 12:33:34 -0700
Message-ID: <201105171933.p4HJXZYa016800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932105Ab1EQTd6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 May 2011 15:33:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, yinghan@google.com


The patch titled
     add the pagefault count into memcg stats: shmem fix
has been added to the -mm tree.  Its filename is
     add-the-pagefault-count-into-memcg-stats-shmem-fix.patch

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
Subject: add the pagefault count into memcg stats: shmem fix
From: Hugh Dickins <hughd@google.com>

mem_cgroup_count_vm_event() should update the PGMAJFAULT count for the
target mm, not for current mm (but of course they're usually the same).

We don't know the target mm in shmem_getpage(), so do it at the outer
level in shmem_fault(); and it's easier to follow if we move the
count_vm_event(PGMAJFAULT) there too.

Hah, it was using __count_vm_event() before, sneaking that update into the
unpreemptible section under info->lock: well, it comes to the same on x86
at least, and I still think it's best to keep these together.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN mm/shmem.c~add-the-pagefault-count-into-memcg-stats-shmem-fix mm/shmem.c
--- a/mm/shmem.c~add-the-pagefault-count-into-memcg-stats-shmem-fix
+++ a/mm/shmem.c
@@ -1304,14 +1304,10 @@ repeat:
 		swappage = lookup_swap_cache(swap);
 		if (!swappage) {
 			shmem_swp_unmap(entry);
+			spin_unlock(&info->lock);
 			/* here we actually do the io */
-			if (type && !(*type & VM_FAULT_MAJOR)) {
-				__count_vm_event(PGMAJFAULT);
-				mem_cgroup_count_vm_event(current->mm,
-							  PGMAJFAULT);
+			if (type)
 				*type |= VM_FAULT_MAJOR;
-			}
-			spin_unlock(&info->lock);
 			swappage = shmem_swapin(swap, gfp, info, idx);
 			if (!swappage) {
 				spin_lock(&info->lock);
@@ -1550,7 +1546,10 @@ static int shmem_fault(struct vm_area_st
 	error = shmem_getpage(inode, vmf->pgoff, &vmf->page, SGP_CACHE, &ret);
 	if (error)
 		return ((error == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS);
-
+	if (ret & VM_FAULT_MAJOR) {
+		count_vm_event(PGMAJFAULT);
+		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
+	}
 	return ret | VM_FAULT_LOCKED;
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
tmpfs-implement-generic-xattr-support.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
mn10300-convert-old-cpumask-api-into-new-one.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
add-the-pagefault-count-into-memcg-stats-shmem-fix.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch
prio_tree-debugging-patch.patch

