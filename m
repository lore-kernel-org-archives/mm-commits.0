From: akpm@linux-foundation.org
Subject: [merged] drivers-gpu-drm-i915-intel_displayc-disable-sr-when-more-than-one-pipe-is-enabled.patch removed from -mm tree
Date: Mon, 08 Feb 2010 11:52:26 -0800
Message-ID: <201002081952.o18JqQ0f031418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754691Ab0BHTxY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 14:53:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidjon@xenontk.org, airlied@linux.ie, eric@anholt.net, jbarnes@virtuousgeek.org, stable@kernel.org, yakui.zhao@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/gpu/drm/i915/intel_display.c: disable SR when more than one pipe is enabled
has been removed from the -mm tree.  Its filename was
     drivers-gpu-drm-i915-intel_displayc-disable-sr-when-more-than-one-pipe-is-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpu/drm/i915/intel_display.c: disable SR when more than one pipe is enabled
From: David John <davidjon@xenontk.org>

Self Refresh should be disabled on dual plane configs.  Otherwise, as the
SR watermark is not calculated for such configs, switching to non VGA mode
causes FIFO underrun and display flicker.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14897

Signed-off-by: David John <davidjon@xenontk.org>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Eric Anholt <eric@anholt.net>
Cc: Dave Airlie <airlied@linux.ie>
Cc: ykzhao <yakui.zhao@intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_display.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN drivers/gpu/drm/i915/intel_display.c~drivers-gpu-drm-i915-intel_displayc-disable-sr-when-more-than-one-pipe-is-enabled drivers/gpu/drm/i915/intel_display.c
--- a/drivers/gpu/drm/i915/intel_display.c~drivers-gpu-drm-i915-intel_displayc-disable-sr-when-more-than-one-pipe-is-enabled
+++ a/drivers/gpu/drm/i915/intel_display.c
@@ -2622,6 +2622,10 @@ static void g4x_update_wm(struct drm_dev
 		sr_entries = roundup(sr_entries / cacheline_size, 1);
 		DRM_DEBUG("self-refresh entries: %d\n", sr_entries);
 		I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN);
+	} else {
+		/* Turn off self refresh if both pipes are enabled */
+		I915_WRITE(FW_BLC_SELF, I915_READ(FW_BLC_SELF)
+					& ~FW_BLC_SELF_EN);
 	}
 
 	DRM_DEBUG("Setting FIFO watermarks - A: %d, B: %d, SR %d\n",
@@ -2665,6 +2669,10 @@ static void i965_update_wm(struct drm_de
 			srwm = 1;
 		srwm &= 0x3f;
 		I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN);
+	} else {
+		/* Turn off self refresh if both pipes are enabled */
+		I915_WRITE(FW_BLC_SELF, I915_READ(FW_BLC_SELF)
+					& ~FW_BLC_SELF_EN);
 	}
 
 	DRM_DEBUG_KMS("Setting FIFO watermarks - A: 8, B: 8, C: 8, SR %d\n",
@@ -2733,6 +2741,10 @@ static void i9xx_update_wm(struct drm_de
 		if (srwm < 0)
 			srwm = 1;
 		I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN | (srwm & 0x3f));
+	} else {
+		/* Turn off self refresh if both pipes are enabled */
+		I915_WRITE(FW_BLC_SELF, I915_READ(FW_BLC_SELF)
+					& ~FW_BLC_SELF_EN);
 	}
 
 	DRM_DEBUG_KMS("Setting FIFO watermarks - A: %d, B: %d, C: %d, SR %d\n",
_

Patches currently in -mm which might be from davidjon@xenontk.org are


