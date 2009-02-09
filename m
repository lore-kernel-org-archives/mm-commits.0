From: akpm@linux-foundation.org
Subject: [merged] drivers-gpu-drm-i915-intel_lvdsc-remove-unneeded-locking.patch removed from -mm tree
Date: Mon, 09 Feb 2009 12:05:28 -0800
Message-ID: <200902092005.n19K5Stm024540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752952AbZBIULr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 15:11:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, airlied@redhat.com, daniel@ffwll.ch, jbarnes@virtuousgeek.org, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     drivers/gpu/drm/i915/intel_lvds.c: remove unneeded locking
has been removed from the -mm tree.  Its filename was
     drivers-gpu-drm-i915-intel_lvdsc-remove-unneeded-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpu/drm/i915/intel_lvds.c: remove unneeded locking
From: Dave Airlie <airlied@linux.ie>

This code is always called under the lock from the higher layers,
so need to go locking it here.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_lvds.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/gpu/drm/i915/intel_lvds.c~drivers-gpu-drm-i915-intel_lvdsc-remove-unneeded-locking drivers/gpu/drm/i915/intel_lvds.c
--- a/drivers/gpu/drm/i915/intel_lvds.c~drivers-gpu-drm-i915-intel_lvdsc-remove-unneeded-locking
+++ a/drivers/gpu/drm/i915/intel_lvds.c
@@ -311,10 +311,8 @@ static int intel_lvds_get_modes(struct d
 	if (dev_priv->panel_fixed_mode != NULL) {
 		struct drm_display_mode *mode;
 
-		mutex_lock(&dev->mode_config.mutex);
 		mode = drm_mode_duplicate(dev, dev_priv->panel_fixed_mode);
 		drm_mode_probed_add(connector, mode);
-		mutex_unlock(&dev->mode_config.mutex);
 
 		return 1;
 	}
_

Patches currently in -mm which might be from airlied@linux.ie are

origin.patch
linux-next.patch
intel-agp-fix-a-panic-with-1m-of-shared-memory-no-gtt-entries.patch
intelfb-support-i854.patch

