From: akpm@linux-foundation.org
Subject: + drm-dont-use-idr_remove_all.patch added to -mm tree
Date: Mon, 28 Jan 2013 16:07:09 -0800
Message-ID: <20130129000710.5ABE55A419C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:64115 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab3A2AHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 19:07:12 -0500
Received: by mail-ob0-f201.google.com with SMTP id un3so653968obb.2
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 16:07:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, airlied@linux.ie, inki.dae@samsung.com, jy0922.shim@samsung.com, kyungmin.park@samsung.com, sw0312.kim@samsung.com


The patch titled
     Subject: drm: don't use idr_remove_all()
has been added to the -mm tree.  Its filename is
     drm-dont-use-idr_remove_all.patch

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
Subject: drm: don't use idr_remove_all()

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

* drm_ctxbitmap_cleanup() was calling idr_remove_all() but forgetting
  idr_destroy() thus leaking all buffered free idr_layers.  Replace it
  with idr_destroy().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_context.c           |    2 +-
 drivers/gpu/drm/drm_crtc.c              |    1 -
 drivers/gpu/drm/drm_drv.c               |    1 -
 drivers/gpu/drm/drm_gem.c               |    2 --
 drivers/gpu/drm/exynos/exynos_drm_ipp.c |    4 ----
 drivers/gpu/drm/sis/sis_drv.c           |    1 -
 drivers/gpu/drm/via/via_map.c           |    1 -
 7 files changed, 1 insertion(+), 11 deletions(-)

diff -puN drivers/gpu/drm/drm_context.c~drm-dont-use-idr_remove_all drivers/gpu/drm/drm_context.c
--- a/drivers/gpu/drm/drm_context.c~drm-dont-use-idr_remove_all
+++ a/drivers/gpu/drm/drm_context.c
@@ -118,7 +118,7 @@ int drm_ctxbitmap_init(struct drm_device
 void drm_ctxbitmap_cleanup(struct drm_device * dev)
 {
 	mutex_lock(&dev->struct_mutex);
-	idr_remove_all(&dev->ctx_idr);
+	idr_destroy(&dev->ctx_idr);
 	mutex_unlock(&dev->struct_mutex);
 }
 
diff -puN drivers/gpu/drm/drm_crtc.c~drm-dont-use-idr_remove_all drivers/gpu/drm/drm_crtc.c
--- a/drivers/gpu/drm/drm_crtc.c~drm-dont-use-idr_remove_all
+++ a/drivers/gpu/drm/drm_crtc.c
@@ -1258,7 +1258,6 @@ void drm_mode_config_cleanup(struct drm_
 		crtc->funcs->destroy(crtc);
 	}
 
-	idr_remove_all(&dev->mode_config.crtc_idr);
 	idr_destroy(&dev->mode_config.crtc_idr);
 }
 EXPORT_SYMBOL(drm_mode_config_cleanup);
diff -puN drivers/gpu/drm/drm_drv.c~drm-dont-use-idr_remove_all drivers/gpu/drm/drm_drv.c
--- a/drivers/gpu/drm/drm_drv.c~drm-dont-use-idr_remove_all
+++ a/drivers/gpu/drm/drm_drv.c
@@ -297,7 +297,6 @@ static void __exit drm_core_exit(void)
 
 	unregister_chrdev(DRM_MAJOR, "drm");
 
-	idr_remove_all(&drm_minors_idr);
 	idr_destroy(&drm_minors_idr);
 }
 
diff -puN drivers/gpu/drm/drm_gem.c~drm-dont-use-idr_remove_all drivers/gpu/drm/drm_gem.c
--- a/drivers/gpu/drm/drm_gem.c~drm-dont-use-idr_remove_all
+++ a/drivers/gpu/drm/drm_gem.c
@@ -561,8 +561,6 @@ drm_gem_release(struct drm_device *dev, 
 {
 	idr_for_each(&file_private->object_idr,
 		     &drm_gem_object_release_handle, file_private);
-
-	idr_remove_all(&file_private->object_idr);
 	idr_destroy(&file_private->object_idr);
 }
 
diff -puN drivers/gpu/drm/exynos/exynos_drm_ipp.c~drm-dont-use-idr_remove_all drivers/gpu/drm/exynos/exynos_drm_ipp.c
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c~drm-dont-use-idr_remove_all
+++ a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -1786,8 +1786,6 @@ err_iommu:
 			drm_iommu_detach_device(drm_dev, ippdrv->dev);
 
 err_idr:
-	idr_remove_all(&ctx->ipp_idr);
-	idr_remove_all(&ctx->prop_idr);
 	idr_destroy(&ctx->ipp_idr);
 	idr_destroy(&ctx->prop_idr);
 	return ret;
@@ -1965,8 +1963,6 @@ static int ipp_remove(struct platform_de
 	exynos_drm_subdrv_unregister(&ctx->subdrv);
 
 	/* remove,destroy ipp idr */
-	idr_remove_all(&ctx->ipp_idr);
-	idr_remove_all(&ctx->prop_idr);
 	idr_destroy(&ctx->ipp_idr);
 	idr_destroy(&ctx->prop_idr);
 
diff -puN drivers/gpu/drm/sis/sis_drv.c~drm-dont-use-idr_remove_all drivers/gpu/drm/sis/sis_drv.c
--- a/drivers/gpu/drm/sis/sis_drv.c~drm-dont-use-idr_remove_all
+++ a/drivers/gpu/drm/sis/sis_drv.c
@@ -58,7 +58,6 @@ static int sis_driver_unload(struct drm_
 {
 	drm_sis_private_t *dev_priv = dev->dev_private;
 
-	idr_remove_all(&dev_priv->object_idr);
 	idr_destroy(&dev_priv->object_idr);
 
 	kfree(dev_priv);
diff -puN drivers/gpu/drm/via/via_map.c~drm-dont-use-idr_remove_all drivers/gpu/drm/via/via_map.c
--- a/drivers/gpu/drm/via/via_map.c~drm-dont-use-idr_remove_all
+++ a/drivers/gpu/drm/via/via_map.c
@@ -120,7 +120,6 @@ int via_driver_unload(struct drm_device 
 {
 	drm_via_private_t *dev_priv = dev->dev_private;
 
-	idr_remove_all(&dev_priv->object_idr);
 	idr_destroy(&dev_priv->object_idr);
 
 	kfree(dev_priv);
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

