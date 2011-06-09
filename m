From: akpm@linux-foundation.org
Subject: + drm-i915-more-struct_mutex-locking.patch added to -mm tree
Date: Thu, 09 Jun 2011 15:42:34 -0700
Message-ID: <201106092242.p59MgYrE005051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756994Ab1FIWnO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 18:43:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, chris@chris-wilson.co.uk, keithp@keithp.com


The patch titled
     drm/i915: more struct_mutex locking
has been added to the -mm tree.  Its filename is
     drm-i915-more-struct_mutex-locking.patch

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
@@ -1463,6 +1467,7 @@ void intel_setup_overlay(struct drm_devi
 out_unpin_bo:
 	i915_gem_object_unpin(reg_bo);
 out_free_bo:
+	mutex_unlock(&dev->struct_mutex);
 	drm_gem_object_unreference(&reg_bo->base);
 out_free:
 	kfree(overlay);
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

