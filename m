From: akpm@linux-foundation.org
Subject: + writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix.patch added to -mm tree
Date: Tue, 03 May 2011 13:56:54 -0700
Message-ID: <201105032056.p43KutLC009820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754974Ab1ECU6C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 May 2011 16:58:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, Trond.Myklebust@netapp.com, axboe@kernel.dk, david@fromorbit.com, fengguang.wu@intel.com, hch@lst.de, jack@suse.cz, kitayama@cl.bb4u.ne.jp, mel@linux.vnet.ibm.com, minchan.kim@gmail.com, npiggin@kernel.dk


The patch titled
     mmotm: fix hang at startup
has been added to the -mm tree.  Its filename is
     writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix.patch

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
Subject: mmotm: fix hang at startup
From: Hugh Dickins <hughd@google.com>

Yesterday's mmotm hangs at startup, and with lockdep it reports:
BUG: spinlock recursion on CPU#1, blkid/284 - with bdi_lock_two()
called from bdev_inode_switch_bdi() in the backtrace.  It appears
that this function is sometimes called with new the same as old.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Mel Gorman <mel@linux.vnet.ibm.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/block_dev.c~writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix fs/block_dev.c
--- a/fs/block_dev.c~writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix
+++ a/fs/block_dev.c
@@ -57,6 +57,8 @@ static void bdev_inode_switch_bdi(struct
 {
 	struct backing_dev_info *old = inode->i_data.backing_dev_info;
 
+	if (dst == old)
+		return;
 	bdi_lock_two(&old->wb, &dst->wb);
 	spin_lock(&inode->i_lock);
 	inode->i_data.backing_dev_info = dst;
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
tmpfs-fix-race-between-umount-and-writepage.patch
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
mn10300-replace-mm-cpu_vm_mask-with-mm_cpumask.patch
tile-replace-mm-cpu_vm_mask-with-mm_cpumask.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch
prio_tree-debugging-patch.patch

