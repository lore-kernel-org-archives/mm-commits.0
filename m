From: akpm@linux-foundation.org
Subject: + drm-i915-optimize-div_round_closest-call.patch added to -mm tree
Date: Tue, 04 Sep 2012 15:29:49 -0700
Message-ID: <20120904222950.0BC9B200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:64215 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932828Ab2IDW3x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Sep 2012 18:29:53 -0400
Received: by lagw12 with SMTP id w12so373678lag.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Sep 2012 15:29:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, airlied@linux.ie, daniel.vetter@ffwll.ch, linux@roeck-us.net


The patch titled
     Subject: drm/i915: optimize DIV_ROUND_CLOSEST() call
has been added to the -mm tree.  Its filename is
     drm-i915-optimize-div_round_closest-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2545,7 +2545,8 @@ static void gen6_update_ring_freq(struct
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int min_freq = 15;
-	int gpu_freq, ia_freq, max_ia_freq;
+	int gpu_freq;
+	unsigned int ia_freq, max_ia_freq;
 	int scaling_factor = 180;
 
 	WARN_ON(!mutex_is_locked(&dev->struct_mutex));
_

Patches currently in -mm which might be from khali@linux-fr.org are

linux-next.patch
drm-i915-optimize-div_round_closest-call.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
hwmon-exynos4-move-thermal-sensor-driver-to-driver-thermal-directory.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
arm-exynos-add-thermal-sensor-driver-platform-data-support.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch

