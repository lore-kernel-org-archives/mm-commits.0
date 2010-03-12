From: akpm@linux-foundation.org
Subject: + i915-fix-small-leak-on-error-path.patch added to -mm tree
Date: Fri, 12 Mar 2010 14:11:31 -0800
Message-ID: <201003122211.o2CMBVW2010960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758703Ab0CLWMK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Mar 2010 17:12:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, airlied@linux.ie, eric@anholt.net


The patch titled
     i915: fix small leak on error path
has been added to the -mm tree.  Its filename is
     i915-fix-small-leak-on-error-path.patch

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
Subject: i915: fix small leak on error path
From: Dan Carpenter <error27@gmail.com>

We should free "params" before returning.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Eric Anholt <eric@anholt.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_overlay.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN drivers/gpu/drm/i915/intel_overlay.c~i915-fix-small-leak-on-error-path drivers/gpu/drm/i915/intel_overlay.c
--- a/drivers/gpu/drm/i915/intel_overlay.c~i915-fix-small-leak-on-error-path
+++ a/drivers/gpu/drm/i915/intel_overlay.c
@@ -1068,14 +1068,18 @@ int intel_overlay_put_image(struct drm_d
 
 	drmmode_obj = drm_mode_object_find(dev, put_image_rec->crtc_id,
                         DRM_MODE_OBJECT_CRTC);
-	if (!drmmode_obj)
-		return -ENOENT;
+	if (!drmmode_obj) {
+		ret = -ENOENT;
+		goto out_free;
+	}
 	crtc = to_intel_crtc(obj_to_crtc(drmmode_obj));
 
 	new_bo = drm_gem_object_lookup(dev, file_priv,
 			put_image_rec->bo_handle);
-	if (!new_bo)
-		return -ENOENT;
+	if (!new_bo) {
+		ret = -ENOENT;
+		goto out_free;
+	}
 
 	mutex_lock(&dev->mode_config.mutex);
 	mutex_lock(&dev->struct_mutex);
@@ -1165,6 +1169,7 @@ out_unlock:
 	mutex_unlock(&dev->struct_mutex);
 	mutex_unlock(&dev->mode_config.mutex);
 	drm_gem_object_unreference_unlocked(new_bo);
+out_free:
 	kfree(params);
 
 	return ret;
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
i915-fix-small-leak-on-error-path.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch

