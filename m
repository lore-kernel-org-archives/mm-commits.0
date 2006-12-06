From: akpm@osdl.org
Subject: - fbdev-backlight-kconfig-fixes.patch removed from -mm tree
Date: Wed, 06 Dec 2006 15:39:51 -0800
Message-ID: <200612062341.kB6Nf2Hc020985@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55274 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937808AbWLFXlL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 18:41:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsimmons@infradead.org, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     fbdev: backlight Kconfig fixes
has been removed from the -mm tree.  Its filename was
     fbdev-backlight-kconfig-fixes.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: fbdev: backlight Kconfig fixes
From: James Simmons <jsimmons@infradead.org>

Place the backlight before the framebuffers.  You will now be able to
select using the backlight with various framebuffer drivers.

Signed-off-by: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/Kconfig |   63 +++++++++++++++++-----------------------
 1 files changed, 28 insertions(+), 35 deletions(-)

diff -puN drivers/video/Kconfig~fbdev-backlight-kconfig-fixes drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-backlight-kconfig-fixes
+++ a/drivers/video/Kconfig
@@ -4,20 +4,9 @@
 
 menu "Graphics support"
 
-config FIRMWARE_EDID
-       bool "Enable firmware EDID"
-       default y
-       ---help---
-         This enables access to the EDID transferred from the firmware.
-	 On the i386, this is from the Video BIOS. Enable this if DDC/I2C
-	 transfers do not work for your driver and if you are using
-	 nvidiafb, i810fb or savagefb.
-
-	 In general, choosing Y for this option is safe.  If you
-	 experience extremely long delays while booting before you get
-	 something on your display, try setting this to N.  Matrox cards in
-	 combination with certain motherboards and monitors are known to
-	 suffer from this problem.
+if SYSFS
+	source "drivers/video/backlight/Kconfig"
+endif
 
 config FB
 	tristate "Support for frame buffer devices"
@@ -53,6 +42,22 @@ config FB
 	  (e.g. an accelerated X server) and that are not frame buffer
 	  device-aware may cause unexpected results. If unsure, say N.
 
+config FIRMWARE_EDID
+       bool "Enable firmware EDID"
+       depends on FB
+       default n
+       ---help---
+         This enables access to the EDID transferred from the firmware.
+	 On the i386, this is from the Video BIOS. Enable this if DDC/I2C
+	 transfers do not work for your driver and if you are using
+	 nvidiafb, i810fb or savagefb.
+
+	 In general, choosing Y for this option is safe.  If you
+	 experience extremely long delays while booting before you get
+	 something on your display, try setting this to N.  Matrox cards in
+	 combination with certain motherboards and monitors are known to
+	 suffer from this problem.
+
 config FB_DDC
        tristate
        depends on FB && I2C && I2C_ALGOBIT
@@ -90,13 +95,6 @@ config FB_MACMODES
        depends on FB
        default n
 
-config FB_BACKLIGHT
-	bool
-	depends on FB
-	select BACKLIGHT_LCD_SUPPORT
-	select BACKLIGHT_CLASS_DEVICE
-	default n
-
 config FB_MODE_HELPERS
         bool "Enable Video Mode Handling Helpers"
         depends on FB
@@ -126,6 +124,9 @@ config FB_TILEBLITTING
 	 This is particularly important to one driver, matroxfb.  If
 	 unsure, say N.
 
+comment "Frambuffer hardware drivers"
+	depends on FB
+
 config FB_CIRRUS
 	tristate "Cirrus Logic support"
 	depends on FB && (ZORRO || PCI)
@@ -731,8 +732,7 @@ config FB_NVIDIA_I2C
 
 config FB_NVIDIA_BACKLIGHT
 	bool "Support for backlight control"
-	depends on FB_NVIDIA && PMAC_BACKLIGHT
-	select FB_BACKLIGHT
+	depends on FB_NVIDIA && BACKLIGHT_CLASS_DEVICE
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display.
@@ -779,8 +779,7 @@ config FB_RIVA_DEBUG
 
 config FB_RIVA_BACKLIGHT
 	bool "Support for backlight control"
-	depends on FB_RIVA && PMAC_BACKLIGHT
-	select FB_BACKLIGHT
+	depends on FB_RIVA && BACKLIGHT_CLASS_DEVICE
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display.
@@ -1053,8 +1052,7 @@ config FB_RADEON_I2C
 
 config FB_RADEON_BACKLIGHT
 	bool "Support for backlight control"
-	depends on FB_RADEON && PMAC_BACKLIGHT
-	select FB_BACKLIGHT
+	depends on FB_RADEON && BACKLIGHT_CLASS_DEVICE
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display.
@@ -1085,8 +1083,7 @@ config FB_ATY128
 
 config FB_ATY128_BACKLIGHT
 	bool "Support for backlight control"
-	depends on FB_ATY128 && PMAC_BACKLIGHT
-	select FB_BACKLIGHT
+	depends on FB_ATY128 && BACKLIGHT_CLASS_DEVICE
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display.
@@ -1135,8 +1132,7 @@ config FB_ATY_GX
 
 config FB_ATY_BACKLIGHT
 	bool "Support for backlight control"
-	depends on FB_ATY && PMAC_BACKLIGHT
-	select FB_BACKLIGHT
+	depends on FB_ATY && BACKLIGHT_CLASS_DEVICE
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display.
@@ -1636,6 +1632,7 @@ config FB_VIRTUAL
 	  the vfb_enable=1 option.
 
 	  If unsure, say N.
+
 if VT
 	source "drivers/video/console/Kconfig"
 endif
@@ -1644,9 +1641,5 @@ if FB || SGI_NEWPORT_CONSOLE
 	source "drivers/video/logo/Kconfig"
 endif
 
-if SYSFS
-	source "drivers/video/backlight/Kconfig"
-endif
-
 endmenu
 
_

Patches currently in -mm which might be from jsimmons@infradead.org are

video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-fix-fbdev-drivers.patch
add-return-value-checking-of-get_user-in.patch
pmagb-b-fb-fix-a-default-clock.patch
video-get-the-default-mode-from-the-right-database.patch
s3c2410fb-add-support-for-stn-displays.patch
fbcmapc-mark-structs-const-or.patch
various-fbdev-files-mark-structs.patch
annotate-some-variables-in-vesafb.patch
au1100fb-fix-to-remove-flickering.patch
mbxfb-fix-hscoeff3-register-address.patch
mbxfb-add-more-registers-bits.patch
mbxfb-add-more-registers-to-debugfs.patch
mbxfb-add-yuv-video-overlay-support.patch
mbxfb-document-the-new-ioctl.patch
atyfb-remove-fixme.patch
visws-sgivwfb-is-module-needs-exports.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
softcursorc-avoid-unaligned-accesses.patch
backlight-do-not-power-off-backlight-when-unregistering-try-3.patch
fb-get-the-geode-gx-frambuffer-size-from-the-bios.patch
gxfb-fixups-for-the-amd-geode-gx.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options.patch
gxfb-support-command-line-options-tidy.patch
gxfb-fixup-flatpanel-detection.patch
gxfb-turn-on-the-flatpanel-power-and-data.patch
video-select-set-for-vesa-fb.patch

