From: akpm@linux-foundation.org
Subject: [merged] drm-i915-optimize-div_round_closest-call.patch removed from -mm tree
Date: Fri, 30 Nov 2012 13:29:21 -0800
Message-ID: <20121130212921.BF06E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:55005 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2K3V3W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Nov 2012 16:29:22 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so1990593vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 30 Nov 2012 13:29:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, airlied@linux.ie, daniel.vetter@ffwll.ch, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/i915: optimize DIV_ROUND_CLOSEST() call
has been removed from the -mm tree.  Its filename was
     drm-i915-optimize-div_round_closest-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jean Delvare <khali@linux-fr.org>
Subject: drm/i915: optimize DIV_ROUND_CLOSEST() call

DIV_ROUND_CLOSEST is faster if the compiler knows it will only be dealing
with unsigned dividends.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_pm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/gpu/drm/i915/intel_pm.c~drm-i915-optimize-div_round_closest-call drivers/gpu/drm/i915/intel_pm.c
--- a/drivers/gpu/drm/i915/intel_pm.c~drm-i915-optimize-div_round_closest-call
+++ a/drivers/gpu/drm/i915/intel_pm.c
@@ -2552,7 +2552,8 @@ static void gen6_update_ring_freq(struct
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int min_freq = 15;
-	int gpu_freq, ia_freq, max_ia_freq;
+	int gpu_freq;
+	unsigned int ia_freq, max_ia_freq;
 	int scaling_factor = 180;
 
 	WARN_ON(!mutex_is_locked(&dev_priv->rps.hw_lock));
_

Patches currently in -mm which might be from khali@linux-fr.org are

linux-next.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch

