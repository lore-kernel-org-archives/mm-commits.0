From: akpm@linux-foundation.org
Subject: [merged] drm-vmwgfx-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:13:57 -0800
Message-ID: <20130228201357.AB54131C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:44099 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab3B1UN6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:13:58 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so244771vcd.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:13:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/vmwgfx: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     drm-vmwgfx-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: drm/vmwgfx: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/gpu/drm/vmwgfx/vmwgfx_resource.c~drm-vmwgfx-convert-to-idr_alloc drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c~drm-vmwgfx-convert-to-idr_alloc
+++ a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -177,17 +177,16 @@ int vmw_resource_alloc_id(struct vmw_res
 
 	BUG_ON(res->id != -1);
 
-	do {
-		if (unlikely(idr_pre_get(idr, GFP_KERNEL) == 0))
-			return -ENOMEM;
-
-		write_lock(&dev_priv->resource_lock);
-		ret = idr_get_new_above(idr, res, 1, &res->id);
-		write_unlock(&dev_priv->resource_lock);
+	idr_preload(GFP_KERNEL);
+	write_lock(&dev_priv->resource_lock);
 
-	} while (ret == -EAGAIN);
+	ret = idr_alloc(idr, res, 1, 0, GFP_NOWAIT);
+	if (ret >= 0)
+		res->id = ret;
 
-	return ret;
+	write_unlock(&dev_priv->resource_lock);
+	idr_preload_end();
+	return ret < 0 ? ret : 0;
 }
 
 /**
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

