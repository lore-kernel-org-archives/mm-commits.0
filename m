From: akpm@linux-foundation.org
Subject: + drm-fix-kconfig-unmet-dependency-warning.patch added to -mm tree
Date: Wed, 17 Aug 2011 15:50:15 -0700
Message-ID: <201108172250.p7HMoFtu001199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754315Ab1HQWuS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Aug 2011 18:50:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, airlied@linux.ie


The patch titled
     drm: fix kconfig unmet dependency warning
has been added to the -mm tree.  Its filename is
     drm-fix-kconfig-unmet-dependency-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: fix kconfig unmet dependency warning
From: Randy Dunlap <rdunlap@xenotime.net>

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
drm-fix-kconfig-unmet-dependency-warning.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
cross-memory-attach-update.patch
consolidate-config_debug_strict_user_copy_checks-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
docs-sysfs-specify-abi-documentation-requirements.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
init-add-root=partuuid=uuid-partnroff=%d-support.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

