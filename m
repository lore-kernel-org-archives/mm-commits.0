From: akpm@linux-foundation.org
Subject: [merged] drm-exynos-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:13:45 -0800
Message-ID: <20130228201345.AC9645A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:59465 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684Ab3B1UNq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:13:46 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so244837vch.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:13:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, airlied@linux.ie, kgene.kim@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/exynos: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     drm-exynos-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: drm/exynos: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: David Airlie <airlied@linux.ie>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/exynos/exynos_drm_ipp.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN drivers/gpu/drm/exynos/exynos_drm_ipp.c~drm-exynos-convert-to-idr_alloc drivers/gpu/drm/exynos/exynos_drm_ipp.c
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c~drm-exynos-convert-to-idr_alloc
+++ a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -137,21 +137,15 @@ static int ipp_create_id(struct idr *id_
 
 	DRM_DEBUG_KMS("%s\n", __func__);
 
-again:
-	/* ensure there is space available to allocate a handle */
-	if (idr_pre_get(id_idr, GFP_KERNEL) == 0) {
-		DRM_ERROR("failed to get idr.\n");
-		return -ENOMEM;
-	}
-
 	/* do the allocation under our mutexlock */
 	mutex_lock(lock);
-	ret = idr_get_new_above(id_idr, obj, 1, (int *)idp);
+	ret = idr_alloc(id_idr, obj, 1, 0, GFP_KERNEL);
 	mutex_unlock(lock);
-	if (ret == -EAGAIN)
-		goto again;
+	if (ret < 0)
+		return ret;
 
-	return ret;
+	*idp = ret;
+	return 0;
 }
 
 static void *ipp_find_obj(struct idr *id_idr, struct mutex *lock, u32 id)
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

