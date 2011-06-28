From: akpm@linux-foundation.org
Subject: [merged] drm-i915-more-struct_mutex-locking.patch removed from -mm tree
Date: Tue, 28 Jun 2011 13:43:00 -0700
Message-ID: <201106282042.p5SKggc1003040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069Ab1F1Umz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 16:42:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, chris@chris-wilson.co.uk, keithp@keithp.com, mm-commits@vger.kernel.org


The patch titled
     drm/i915: more struct_mutex locking
has been removed from the -mm tree.  Its filename was
     drm-i915-more-struct_mutex-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm/i915: more struct_mutex locking
From: Hugh Dickins <hughd@google.com>

When auditing the locking in i915_gem.c (for a prospective change which I
then abandoned), I noticed two places where struct_mutex is not held
across GEM object manipulations that would usually require it.  Since one
is in initial setup and the other in driver unload, I'm guessing the mutex
is not required for either; but post a patch in case it is.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Keith Packard <keithp@keithp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_dma.c      |    3 +--
 drivers/gpu/drm/i915/intel_overlay.c |    5 +++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/i915/i915_dma.c~drm-i915-more-struct_mutex-locking drivers/gpu/drm/i915/i915_dma.c
--- a/drivers/gpu/drm/i915/i915_dma.c~drm-i915-more-struct_mutex-locking
+++ a/drivers/gpu/drm/i915/i915_dma.c
@@ -2182,9 +2182,8 @@ int i915_driver_unload(struct drm_device
 		/* Flush any outstanding unpin_work. */
 		flush_workqueue(dev_priv->wq);
 
-		i915_gem_free_all_phys_object(dev);
-
 		mutex_lock(&dev->struct_mutex);
+		i915_gem_free_all_phys_object(dev);
 		i915_gem_cleanup_ringbuffer(dev);
 		mutex_unlock(&dev->struct_mutex);
 		if (I915_HAS_FBC(dev) && i915_powersave)
diff -puN drivers/gpu/drm/i915/intel_overlay.c~drm-i915-more-struct_mutex-locking drivers/gpu/drm/i915/intel_overlay.c
--- a/drivers/gpu/drm/i915/intel_overlay.c~drm-i915-more-struct_mutex-locking
+++ a/drivers/gpu/drm/i915/intel_overlay.c
@@ -1416,6 +1416,8 @@ void intel_setup_overlay(struct drm_devi
 		goto out_free;
 	overlay->reg_bo = reg_bo;
 
+	mutex_lock(&dev->struct_mutex);
+
 	if (OVERLAY_NEEDS_PHYSICAL(dev)) {
 		ret = i915_gem_attach_phys_object(dev, reg_bo,
 						  I915_GEM_PHYS_OVERLAY_REGS,
@@ -1440,6 +1442,8 @@ void intel_setup_overlay(struct drm_devi
                 }
 	}
 
+	mutex_unlock(&dev->struct_mutex);
+
 	/* init all values */
 	overlay->color_key = 0x0101fe;
 	overlay->brightness = -19;
@@ -1464,6 +1468,7 @@ out_unpin_bo:
 	i915_gem_object_unpin(reg_bo);
 out_free_bo:
 	drm_gem_object_unreference(&reg_bo->base);
+	mutex_unlock(&dev->struct_mutex);
 out_free:
 	kfree(overlay);
 	return;
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

