From: akpm@linux-foundation.org
Subject: [merged] drm-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:13:42 -0800
Message-ID: <20130228201342.C27795A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:36042 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3B1UNn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:13:43 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so245101yen.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:13:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, airlied@linux.ie, artem.savkov@gmail.com, jslaby@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: drm: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     drm-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: drm: convert to idr_alloc()

Convert to the much saner new idr interface.

* drm_ctxbitmap_next() error handling in drm_addctx() seems broken.
  drm_ctxbitmap_next() return -errno on failure not -1.

[artem.savkov@gmail.com: missing idr_preload_end in drm_gem_flink_ioctl]
[jslaby@suse.cz: fix drm_gem_flink_ioctl() return value]
Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: David Airlie <airlied@linux.ie>
Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_context.c |   17 ++------------
 drivers/gpu/drm/drm_crtc.c    |   19 +++-------------
 drivers/gpu/drm/drm_gem.c     |   38 +++++++++++++-------------------
 drivers/gpu/drm/drm_stub.c    |   19 +---------------
 4 files changed, 25 insertions(+), 68 deletions(-)

diff -puN drivers/gpu/drm/drm_context.c~drm-convert-to-idr_alloc drivers/gpu/drm/drm_context.c
--- a/drivers/gpu/drm/drm_context.c~drm-convert-to-idr_alloc
+++ a/drivers/gpu/drm/drm_context.c
@@ -74,24 +74,13 @@ void drm_ctxbitmap_free(struct drm_devic
  */
 static int drm_ctxbitmap_next(struct drm_device * dev)
 {
-	int new_id;
 	int ret;
 
-again:
-	if (idr_pre_get(&dev->ctx_idr, GFP_KERNEL) == 0) {
-		DRM_ERROR("Out of memory expanding drawable idr\n");
-		return -ENOMEM;
-	}
 	mutex_lock(&dev->struct_mutex);
-	ret = idr_get_new_above(&dev->ctx_idr, NULL,
-				DRM_RESERVED_CONTEXTS, &new_id);
+	ret = idr_alloc(&dev->ctx_idr, NULL, DRM_RESERVED_CONTEXTS, 0,
+			GFP_KERNEL);
 	mutex_unlock(&dev->struct_mutex);
-	if (ret == -EAGAIN)
-		goto again;
-	else if (ret)
-		return ret;
-
-	return new_id;
+	return ret;
 }
 
 /**
diff -puN drivers/gpu/drm/drm_crtc.c~drm-convert-to-idr_alloc drivers/gpu/drm/drm_crtc.c
--- a/drivers/gpu/drm/drm_crtc.c~drm-convert-to-idr_alloc
+++ a/drivers/gpu/drm/drm_crtc.c
@@ -266,32 +266,21 @@ char *drm_get_connector_status_name(enum
 static int drm_mode_object_get(struct drm_device *dev,
 			       struct drm_mode_object *obj, uint32_t obj_type)
 {
-	int new_id = 0;
 	int ret;
 
-again:
-	if (idr_pre_get(&dev->mode_config.crtc_idr, GFP_KERNEL) == 0) {
-		DRM_ERROR("Ran out memory getting a mode number\n");
-		return -ENOMEM;
-	}
-
 	mutex_lock(&dev->mode_config.idr_mutex);
-	ret = idr_get_new_above(&dev->mode_config.crtc_idr, obj, 1, &new_id);
-
-	if (!ret) {
+	ret = idr_alloc(&dev->mode_config.crtc_idr, obj, 1, 0, GFP_KERNEL);
+	if (ret >= 0) {
 		/*
 		 * Set up the object linking under the protection of the idr
 		 * lock so that other users can't see inconsistent state.
 		 */
-		obj->id = new_id;
+		obj->id = ret;
 		obj->type = obj_type;
 	}
 	mutex_unlock(&dev->mode_config.idr_mutex);
 
-	if (ret == -EAGAIN)
-		goto again;
-
-	return ret;
+	return ret < 0 ? ret : 0;
 }
 
 /**
diff -puN drivers/gpu/drm/drm_gem.c~drm-convert-to-idr_alloc drivers/gpu/drm/drm_gem.c
--- a/drivers/gpu/drm/drm_gem.c~drm-convert-to-idr_alloc
+++ a/drivers/gpu/drm/drm_gem.c
@@ -270,21 +270,19 @@ drm_gem_handle_create(struct drm_file *f
 	int ret;
 
 	/*
-	 * Get the user-visible handle using idr.
+	 * Get the user-visible handle using idr.  Preload and perform
+	 * allocation under our spinlock.
 	 */
-again:
-	/* ensure there is space available to allocate a handle */
-	if (idr_pre_get(&file_priv->object_idr, GFP_KERNEL) == 0)
-		return -ENOMEM;
-
-	/* do the allocation under our spinlock */
+	idr_preload(GFP_KERNEL);
 	spin_lock(&file_priv->table_lock);
-	ret = idr_get_new_above(&file_priv->object_idr, obj, 1, (int *)handlep);
+
+	ret = idr_alloc(&file_priv->object_idr, obj, 1, 0, GFP_NOWAIT);
+
 	spin_unlock(&file_priv->table_lock);
-	if (ret == -EAGAIN)
-		goto again;
-	else if (ret)
+	idr_preload_end();
+	if (ret < 0)
 		return ret;
+	*handlep = ret;
 
 	drm_gem_object_handle_reference(obj);
 
@@ -451,29 +449,25 @@ drm_gem_flink_ioctl(struct drm_device *d
 	if (obj == NULL)
 		return -ENOENT;
 
-again:
-	if (idr_pre_get(&dev->object_name_idr, GFP_KERNEL) == 0) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
+	idr_preload(GFP_KERNEL);
 	spin_lock(&dev->object_name_lock);
 	if (!obj->name) {
-		ret = idr_get_new_above(&dev->object_name_idr, obj, 1,
-					&obj->name);
+		ret = idr_alloc(&dev->object_name_idr, obj, 1, 0, GFP_NOWAIT);
+		obj->name = ret;
 		args->name = (uint64_t) obj->name;
 		spin_unlock(&dev->object_name_lock);
+		idr_preload_end();
 
-		if (ret == -EAGAIN)
-			goto again;
-		else if (ret)
+		if (ret < 0)
 			goto err;
+		ret = 0;
 
 		/* Allocate a reference for the name table.  */
 		drm_gem_object_reference(obj);
 	} else {
 		args->name = (uint64_t) obj->name;
 		spin_unlock(&dev->object_name_lock);
+		idr_preload_end();
 		ret = 0;
 	}
 
diff -puN drivers/gpu/drm/drm_stub.c~drm-convert-to-idr_alloc drivers/gpu/drm/drm_stub.c
--- a/drivers/gpu/drm/drm_stub.c~drm-convert-to-idr_alloc
+++ a/drivers/gpu/drm/drm_stub.c
@@ -109,7 +109,6 @@ EXPORT_SYMBOL(drm_ut_debug_printk);
 
 static int drm_minor_get_id(struct drm_device *dev, int type)
 {
-	int new_id;
 	int ret;
 	int base = 0, limit = 63;
 
@@ -121,25 +120,11 @@ static int drm_minor_get_id(struct drm_d
                 limit = base + 255;
         }
 
-again:
-	if (idr_pre_get(&drm_minors_idr, GFP_KERNEL) == 0) {
-		DRM_ERROR("Out of memory expanding drawable idr\n");
-		return -ENOMEM;
-	}
 	mutex_lock(&dev->struct_mutex);
-	ret = idr_get_new_above(&drm_minors_idr, NULL,
-				base, &new_id);
+	ret = idr_alloc(&drm_minors_idr, NULL, base, limit, GFP_KERNEL);
 	mutex_unlock(&dev->struct_mutex);
-	if (ret == -EAGAIN)
-		goto again;
-	else if (ret)
-		return ret;
 
-	if (new_id >= limit) {
-		idr_remove(&drm_minors_idr, new_id);
-		return -EINVAL;
-	}
-	return new_id;
+	return ret == -ENOSPC ? -EINVAL : ret;
 }
 
 struct drm_master *drm_master_create(struct drm_minor *minor)
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

