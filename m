From: akpm@linux-foundation.org
Subject: + drm-convert-to-idr_alloc.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:37:47 -0800
Message-ID: <20130206223748.3D8085A42B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:64799 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab3BFWht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:37:49 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so209619vea.4
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:37:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, airlied@linux.ie


The patch titled
     Subject: drm: convert to idr_alloc()
has been added to the -mm tree.  Its filename is
     drm-convert-to-idr_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: drm: convert to idr_alloc()

Convert to the much saner new idr interface.

Only compile tested.

* drm_ctxbitmap_next() error handling in drm_addctx() seems broken.
  drm_ctxbitmap_next() return -errno on failure not -1.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_context.c |   17 ++-------------
 drivers/gpu/drm/drm_crtc.c    |   19 +++--------------
 drivers/gpu/drm/drm_gem.c     |   35 +++++++++++---------------------
 drivers/gpu/drm/drm_stub.c    |   19 +----------------
 4 files changed, 22 insertions(+), 68 deletions(-)

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
@@ -252,32 +252,21 @@ char *drm_get_connector_status_name(enum
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
 
@@ -451,22 +449,15 @@ drm_gem_flink_ioctl(struct drm_device *d
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
 
-		if (ret == -EAGAIN)
-			goto again;
-		else if (ret)
+		if (ret < 0)
 			goto err;
 
 		/* Allocate a reference for the name table.  */
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

linux-next.patch
cfq-fix-lock-imbalance-with-failed-allocations.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch
memcg-clean-up-swap-accounting-initialization-code.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
idr-fix-a-subtle-bug-in-idr_get_next.patch
idr-make-idr_destroy-imply-idr_remove_all.patch
atm-nicstar-dont-use-idr_remove_all.patch
block-loop-dont-use-idr_remove_all.patch
firewire-dont-use-idr_remove_all.patch
drm-dont-use-idr_remove_all.patch
dm-dont-use-idr_remove_all.patch
remoteproc-dont-use-idr_remove_all.patch
rpmsg-dont-use-idr_remove_all.patch
dlm-use-idr_for_each_entry-in-recover_idr_clear-error-path.patch
dlm-dont-use-idr_remove_all.patch
nfs-idr_destroy-no-longer-needs-idr_remove_all.patch
inotify-dont-use-idr_remove_all.patch
cgroup-dont-use-idr_remove_all.patch
idr-deprecate-idr_remove_all.patch
idr-cosmetic-updates-to-struct-initializer-definitions.patch
idr-relocate-idr_for_each_entry-and-reorganize-id_get_new.patch
idr-remove-_idr_rc_to_errno-hack.patch
idr-refactor-idr_get_new_above.patch
idr-implement-idr_preload-and-idr_alloc.patch
block-fix-synchronization-and-limit-check-in-blk_alloc_devt.patch
block-convert-to-idr_alloc.patch
block-loop-convert-to-idr_alloc.patch
atm-nicstar-convert-to-idr_alloc.patch
drbd-convert-to-idr_alloc.patch
dca-convert-to-idr_alloc.patch
dmaengine-convert-to-idr_alloc.patch
firewire-add-minor-number-range-check-to-fw_device_init.patch
firewire-convert-to-idr_alloc.patch
gpio-convert-to-idr_alloc.patch
drm-convert-to-idr_alloc.patch
drm-exynos-convert-to-idr_alloc.patch
drm-i915-convert-to-idr_alloc.patch
drm-sis-convert-to-idr_alloc.patch
drm-via-convert-to-idr_alloc.patch
drm-vmwgfx-convert-to-idr_alloc.patch
i2c-convert-to-idr_alloc.patch
ib-core-convert-to-idr_alloc.patch
ib-amso1100-convert-to-idr_alloc.patch
ib-cxgb3-convert-to-idr_alloc.patch
ib-cxgb4-convert-to-idr_alloc.patch
ib-ehca-convert-to-idr_alloc.patch
ib-ipath-convert-to-idr_alloc.patch
ib-mlx4-convert-to-idr_alloc.patch
ib-ocrdma-convert-to-idr_alloc.patch
ib-qib-convert-to-idr_alloc.patch
dm-convert-to-idr_alloc.patch
memstick-convert-to-idr_alloc.patch
mfd-convert-to-idr_alloc.patch
misc-c2port-convert-to-idr_alloc.patch
misc-tifm_core-convert-to-idr_alloc.patch
mmc-convert-to-idr_alloc.patch
mtd-convert-to-idr_alloc.patch
macvtap-convert-to-idr_alloc.patch
ppp-convert-to-idr_alloc.patch
power-convert-to-idr_alloc.patch
pps-convert-to-idr_alloc.patch
remoteproc-convert-to-idr_alloc.patch
rpmsg-convert-to-idr_alloc.patch
scsi-bfa-convert-to-idr_alloc.patch
scsi-convert-to-idr_alloc.patch
target-iscsi-convert-to-idr_alloc.patch
scsi-lpfc-convert-to-idr_alloc.patch
thermal-convert-to-idr_alloc.patch
uio-convert-to-idr_alloc.patch
vfio-convert-to-idr_alloc.patch
dlm-convert-to-idr_alloc.patch
inotify-convert-to-idr_alloc.patch
ocfs2-convert-to-idr_alloc.patch
ipc-convert-to-idr_alloc.patch
cgroup-convert-to-idr_alloc.patch
events-convert-to-idr_alloc.patch
posix-timers-convert-to-idr_alloc.patch
net-9p-convert-to-idr_alloc.patch
mac80211-convert-to-idr_alloc.patch
sctp-convert-to-idr_alloc.patch
nfs4client-convert-to-idr_alloc.patch

