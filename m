From: akpm@linux-foundation.org
Subject: + drm-i915-more-struct_mutex-locking-fix.patch added to -mm tree
Date: Thu, 09 Jun 2011 18:06:18 -0700
Message-ID: <201106100105.p5A154gA012597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753992Ab1FJBFR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 21:05:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, chris@chris-wilson.co.uk, keithp@keithp.com


The patch titled
     drm-i915-more-struct_mutex-locking-fix
has been added to the -mm tree.  Its filename is
     drm-i915-more-struct_mutex-locking-fix.patch

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
Subject: drm-i915-more-struct_mutex-locking-fix
From: Hugh Dickins <hughd@google.com>

Chris Wilson points out that drm_gem_object_unreference() also
requires struct_mutex to be held for the final unreference.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Keith Packard <keithp@keithp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_overlay.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/i915/intel_overlay.c~drm-i915-more-struct_mutex-locking-fix drivers/gpu/drm/i915/intel_overlay.c
--- a/drivers/gpu/drm/i915/intel_overlay.c~drm-i915-more-struct_mutex-locking-fix
+++ a/drivers/gpu/drm/i915/intel_overlay.c
@@ -1467,8 +1467,8 @@ void intel_setup_overlay(struct drm_devi
 out_unpin_bo:
 	i915_gem_object_unpin(reg_bo);
 out_free_bo:
-	mutex_unlock(&dev->struct_mutex);
 	drm_gem_object_unreference(&reg_bo->base);
+	mutex_unlock(&dev->struct_mutex);
 out_free:
 	kfree(overlay);
 	return;
_

Patches currently in -mm which might be from hughd@google.com are

mm-fix-wrong-kunmap_atomic-pointer.patch
mm-migratec-dont-account-swapcache-as-shmem.patch
mm-move-vmtruncate_range-to-truncatec.patch
mm-move-shmem-prototypes-to-shmem_fsh.patch
tmpfs-take-control-of-its-truncate_range.patch
tmpfs-add-shmem_read_mapping_page_gfp.patch
drm-ttm-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_truncate_range.patch
drm-i915-more-struct_mutex-locking.patch
drm-i915-more-struct_mutex-locking-fix.patch
mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
linux-next.patch
ksm-fix-null-pointer-dereference-in-scan_get_next_rmap_item.patch
prio_tree-debugging-patch.patch

