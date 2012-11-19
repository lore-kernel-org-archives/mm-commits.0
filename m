From: akpm@linux-foundation.org
Subject: [merged] tmpfs-change-final-i_blocks-bug-to-warning.patch removed from -mm tree
Date: Mon, 19 Nov 2012 12:22:04 -0800
Message-ID: <20121119202205.2D92120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:42462 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab2KSUWH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Nov 2012 15:22:07 -0500
Received: by mail-wi0-f202.google.com with SMTP id cb5so23289wib.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Nov 2012 12:22:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: change final i_blocks BUG to WARNING
has been removed from the -mm tree.  Its filename was
     tmpfs-change-final-i_blocks-bug-to-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: tmpfs: change final i_blocks BUG to WARNING

Under a particular load on one machine, I have hit shmem_evict_inode()'s
BUG_ON(inode->i_blocks), enough times to narrow it down to a particular
race between swapout and eviction.

It comes from the "if (freed > 0)" asymmetry in shmem_recalc_inode(), and
the lack of coherent locking between mapping's nrpages and shmem's swapped
count.  There's a window in shmem_writepage(), between lowering nrpages in
shmem_delete_from_page_cache() and then raising swapped count, when the
freed count appears to be +1 when it should be 0, and then the asymmetry
stops it from being corrected with -1 before hitting the BUG.

One answer is coherent locking: using tree_lock throughout, without
info->lock; reasonable, but the raw_spin_lock in percpu_counter_add() on
used_blocks makes that messier than expected.  Another answer may be a
further effort to eliminate the weird shmem_recalc_inode() altogether, but
previous attempts at that failed.

So far undecided, but for now change the BUG_ON to WARN_ON: in usual
circumstances it remains a useful consistency check.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/shmem.c~tmpfs-change-final-i_blocks-bug-to-warning mm/shmem.c
--- a/mm/shmem.c~tmpfs-change-final-i_blocks-bug-to-warning
+++ a/mm/shmem.c
@@ -643,7 +643,7 @@ static void shmem_evict_inode(struct ino
 		kfree(info->symlink);
 
 	simple_xattrs_free(&info->xattrs);
-	BUG_ON(inode->i_blocks);
+	WARN_ON(inode->i_blocks);
 	shmem_free_inode(inode->i_sb);
 	clear_inode(inode);
 }
_

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
mm-add-comment-on-storage-key-dirty-bit-semantics.patch
mm-refactor-reinsert-of-swap_info-in-sys_swapoff.patch
mm-do-not-call-frontswap_init-during-swapoff.patch
mm-augment-vma-rbtree-with-rb_subtree_gap.patch
mm-augment-vma-rbtree-with-rb_subtree_gap-ensure-safe-rb_subtree_gap-update-when-inserting-new-vma.patch
mm-augment-vma-rbtree-with-rb_subtree_gap-ensure-safe-rb_subtree_gap-update-when-removing-vma.patch
mm-augment-vma-rbtree-with-rb_subtree_gap--debug-code-to-verify-rb_subtree_gap-updates-are-safe.patch
mm-check-rb_subtree_gap-correctness.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch
mm-vm_unmapped_area-lookup-function.patch
mm-use-vm_unmapped_area-on-x86_64-architecture.patch
mm-fix-cache-coloring-on-x86_64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix.patch
mm-use-vm_unmapped_area-on-mips-architecture.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

