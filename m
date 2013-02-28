From: akpm@linux-foundation.org
Subject: [merged] drm-via-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:13:54 -0800
Message-ID: <20130228201354.A5F985A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:47222 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821Ab3B1UNz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:13:55 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so245010yen.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:13:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/via: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     drm-via-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: drm/via: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/via/via_mm.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff -puN drivers/gpu/drm/via/via_mm.c~drm-via-convert-to-idr_alloc drivers/gpu/drm/via/via_mm.c
--- a/drivers/gpu/drm/via/via_mm.c~drm-via-convert-to-idr_alloc
+++ a/drivers/gpu/drm/via/via_mm.c
@@ -148,17 +148,10 @@ int via_mem_alloc(struct drm_device *dev
 	if (retval)
 		goto fail_alloc;
 
-again:
-	if (idr_pre_get(&dev_priv->object_idr, GFP_KERNEL) == 0) {
-		retval = -ENOMEM;
-		goto fail_idr;
-	}
-
-	retval = idr_get_new_above(&dev_priv->object_idr, item, 1, &user_key);
-	if (retval == -EAGAIN)
-		goto again;
-	if (retval)
+	retval = idr_alloc(&dev_priv->object_idr, item, 1, 0, GFP_KERNEL);
+	if (retval < 0)
 		goto fail_idr;
+	user_key = retval;
 
 	list_add(&item->owner_list, &file_priv->obj_list);
 	mutex_unlock(&dev->struct_mutex);
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

