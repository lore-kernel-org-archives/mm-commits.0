From: akpm@linux-foundation.org
Subject: [merged] drm-i915-use-shmem_truncate_range.patch removed from -mm tree
Date: Tue, 28 Jun 2011 13:42:58 -0700
Message-ID: <201106282042.p5SKgeKm003036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708Ab1F1Umx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 16:42:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, airlied@redhat.com, chris@chris-wilson.co.uk, hch@infradead.org, keithp@keithp.com, mm-commits@vger.kernel.org


The patch titled
     drm/i915: use shmem_truncate_range
has been removed from the -mm tree.  Its filename was
     drm-i915-use-shmem_truncate_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm/i915: use shmem_truncate_range
From: Hugh Dickins <hughd@google.com>

The interface to ->truncate_range is changing very slightly: once "tmpfs:
take control of its truncate_range" has been applied, this can be applied.
 For now there is only a slight inefficiency while this remains unapplied,
but it will soon become essential for managing shmem's use of swap.

Change i915_gem_object_truncate() to use shmem_truncate_range() directly:
which should also spare i915 later change if we switch from
inode_operations->truncate_range to file_operations->fallocate.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_gem.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/gpu/drm/i915/i915_gem.c~drm-i915-use-shmem_truncate_range drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~drm-i915-use-shmem_truncate_range
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -1696,13 +1696,10 @@ i915_gem_object_truncate(struct drm_i915
 	/* Our goal here is to return as much of the memory as
 	 * is possible back to the system as we are called from OOM.
 	 * To do this we must instruct the shmfs to drop all of its
-	 * backing pages, *now*. Here we mirror the actions taken
-	 * when by shmem_delete_inode() to release the backing store.
+	 * backing pages, *now*.
 	 */
 	inode = obj->base.filp->f_path.dentry->d_inode;
-	truncate_inode_pages(inode->i_mapping, 0);
-	if (inode->i_op->truncate_range)
-		inode->i_op->truncate_range(inode, 0, (loff_t)-1);
+	shmem_truncate_range(inode, 0, (loff_t)-1);
 
 	obj->madv = __I915_MADV_PURGED;
 }
_

Patches currently in -mm which might be from hughd@google.com are

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
mm-a-few-small-updates-for-radix-swap-fix.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
prio_tree-debugging-patch.patch

