From: akpm@linux-foundation.org
Subject: + drm-i915-use-shmem_truncate_range.patch added to -mm tree
Date: Thu, 09 Jun 2011 15:42:32 -0700
Message-ID: <201106092242.p59MgXBl005045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756531Ab1FIWsN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 18:48:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, airlied@redhat.com, chris@chris-wilson.co.uk, hch@infradead.org, keithp@keithp.com


The patch titled
     drm/i915: use shmem_truncate_range
has been added to the -mm tree.  Its filename is
     drm-i915-use-shmem_truncate_range.patch

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
@@ -1694,13 +1694,10 @@ i915_gem_object_truncate(struct drm_i915
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

mm-fix-wrong-kunmap_atomic-pointer.patch
mm-migratec-dont-account-swapcache-as-shmem.patch
linux-next.patch
mm-move-vmtruncate_range-to-truncatec.patch
mm-move-shmem-prototypes-to-shmem_fsh.patch
tmpfs-take-control-of-its-truncate_range.patch
tmpfs-add-shmem_read_mapping_page_gfp.patch
drm-ttm-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_truncate_range.patch
drm-i915-more-struct_mutex-locking.patch
mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
prio_tree-debugging-patch.patch

