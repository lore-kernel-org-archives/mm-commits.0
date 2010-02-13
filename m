From: akpm@linux-foundation.org
Subject: [alternative-merged] gpu-drm-i915-fix-potential-null-dereference.patch removed from -mm tree
Date: Fri, 12 Feb 2010 21:20:57 -0800
Message-ID: <201002130520.o1D5KvgC014638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799Ab0BMFVZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Feb 2010 00:21:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, airlied@linux.ie, eric@anholt.net, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     gpu: drm/i915, fix potential null dereference
has been removed from the -mm tree.  Its filename was
     gpu-drm-i915-fix-potential-null-dereference.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpu: drm/i915, fix potential null dereference
From: Jiri Slaby <jslaby@suse.cz>

Stanse found a potential null dereference in i915_suspend.  There is a
check for dev and dev_priv being NULL, but dev is dereferenced earlier. 
Move the dereference after the check.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: David Airlie <airlied@linux.ie>
Cc: Eric Anholt <eric@anholt.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_drv.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN drivers/gpu/drm/i915/i915_drv.c~gpu-drm-i915-fix-potential-null-dereference drivers/gpu/drm/i915/i915_drv.c
--- a/drivers/gpu/drm/i915/i915_drv.c~gpu-drm-i915-fix-potential-null-dereference
+++ a/drivers/gpu/drm/i915/i915_drv.c
@@ -176,12 +176,17 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
 
 static int i915_suspend(struct drm_device *dev, pm_message_t state)
 {
-	struct drm_i915_private *dev_priv = dev->dev_private;
+	struct drm_i915_private *dev_priv;
 
-	if (!dev || !dev_priv) {
-		DRM_ERROR("dev: %p, dev_priv: %p\n", dev, dev_priv);
-		DRM_ERROR("DRM not initialized, aborting suspend.\n");
-		return -ENODEV;
+	if (!dev) {
+		DRM_ERROR("dev: %p\n", dev);
+		goto abort;
+	}
+
+	dev_priv = dev->dev_private;
+	if (!dev_priv) {
+		DRM_ERROR("dev_priv: %p\n", dev_priv);
+		goto abort;
 	}
 
 	if (state.event == PM_EVENT_PRETHAW)
@@ -211,6 +216,9 @@ static int i915_suspend(struct drm_devic
 	dev_priv->modeset_on_lid = 0;
 
 	return 0;
+abort:
+	DRM_ERROR("DRM not initialized, aborting suspend.\n");
+	return -ENODEV;
 }
 
 static int i915_resume(struct drm_device *dev)
_

Patches currently in -mm which might be from jslaby@suse.cz are

linux-next.patch
gpu-drm-i915-fix-potential-null-dereference.patch
infiniband-use-rlimit-helpers.patch
mtd-chips-cfi-remove-unneeded-null-checks.patch
mm-use-rlimit-helpers.patch
bootmem-avoid-dma32-zone-by-default.patch
fs-use-rlimit-helpers.patch
posix-cpu-timers-cleanup-rlimits-usage.patch
kernel-core-use-helpers-for-rlimits.patch
kernel-core-use-helpers-for-rlimits-fix.patch
ipc-use-rlimit-helpers.patch
edac-add-__init-to-i7core_xeon_pci_fixup.patch

