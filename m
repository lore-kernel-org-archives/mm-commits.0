From: akpm@linux-foundation.org
Subject: [merged] drm-i915-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:13:48 -0800
Message-ID: <20130228201348.A86765A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:61524 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757693Ab3B1UNt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:13:49 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so261133qaj.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:13:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, airlied@linux.ie, daniel.vetter@ffwll.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/i915: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     drm-i915-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: drm/i915: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_gem_context.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff -puN drivers/gpu/drm/i915/i915_gem_context.c~drm-i915-convert-to-idr_alloc drivers/gpu/drm/i915/i915_gem_context.c
--- a/drivers/gpu/drm/i915/i915_gem_context.c~drm-i915-convert-to-idr_alloc
+++ a/drivers/gpu/drm/i915/i915_gem_context.c
@@ -139,7 +139,7 @@ create_hw_context(struct drm_device *dev
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct i915_hw_context *ctx;
-	int ret, id;
+	int ret;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (ctx == NULL)
@@ -164,22 +164,11 @@ create_hw_context(struct drm_device *dev
 
 	ctx->file_priv = file_priv;
 
-again:
-	if (idr_pre_get(&file_priv->context_idr, GFP_KERNEL) == 0) {
-		ret = -ENOMEM;
-		DRM_DEBUG_DRIVER("idr allocation failed\n");
-		goto err_out;
-	}
-
-	ret = idr_get_new_above(&file_priv->context_idr, ctx,
-				DEFAULT_CONTEXT_ID + 1, &id);
-	if (ret == 0)
-		ctx->id = id;
-
-	if (ret == -EAGAIN)
-		goto again;
-	else if (ret)
+	ret = idr_alloc(&file_priv->context_idr, ctx, DEFAULT_CONTEXT_ID + 1, 0,
+			GFP_KERNEL);
+	if (ret < 0)
 		goto err_out;
+	ctx->id = ret;
 
 	return ctx;
 
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

