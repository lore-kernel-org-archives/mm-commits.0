From: akpm@linux-foundation.org
Subject: [merged] drm-fix-kconfig-unmet-dependency-warning.patch removed from -mm tree
Date: Mon, 14 Nov 2011 13:26:22 -0800
Message-ID: <201111142126.pAELQNsI000678@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:54114 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab1KNVdi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2011 16:33:38 -0500
Received: by faap16 with SMTP id p16so80113faa.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2011 13:33:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: drm: fix kconfig unmet dependency warning
has been removed from the -mm tree.  Its filename was
     drm-fix-kconfig-unmet-dependency-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: drm: fix kconfig unmet dependency warning

Fix kconfig unmet dependency warning.  BACKLIGHT_CLASS_DEVICE depends on
BACKLIGHT_LCD_SUPPORT, so select the latter along with the former.

warning: (DRM_RADEON_KMS && DRM_I915 && STUB_POULSBO && FB_BACKLIGHT && PANEL_SHARP_LS037V7DW01 && PANEL_ACX565AKM && USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_ASUS && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT)

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpu/drm/Kconfig~drm-fix-kconfig-unmet-dependency-warning drivers/gpu/drm/Kconfig
--- a/drivers/gpu/drm/Kconfig~drm-fix-kconfig-unmet-dependency-warning
+++ a/drivers/gpu/drm/Kconfig
@@ -96,6 +96,7 @@ config DRM_I915
 	select FB_CFB_IMAGEBLIT
 	# i915 depends on ACPI_VIDEO when ACPI is enabled
 	# but for select to work, need to select ACPI_VIDEO's dependencies, ick
+	select BACKLIGHT_LCD_SUPPORT if ACPI
 	select BACKLIGHT_CLASS_DEVICE if ACPI
 	select VIDEO_OUTPUT_CONTROL if ACPI
 	select INPUT if ACPI
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
consolidate-config_debug_strict_user_copy_checks-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

