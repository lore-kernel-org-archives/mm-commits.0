From: akpm@linux-foundation.org
Subject: - proper-backlight-selection-for-fbdev-drivers.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:14:57 -0800
Message-ID: <200702100514.l1A5Ev6M004323@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36437 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101AbXBJFPL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:15:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Proper backlight selection for fbdev drivers
has been removed from the -mm tree.  Its filename was
     proper-backlight-selection-for-fbdev-drivers.patch

This patch was dropped because git-backlight tree broke it

------------------------------------------------------
Subject: Proper backlight selection for fbdev drivers
From: James Simmons <jsimmons@infradead.org>

Signed-off-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/Kconfig          |   73 +++++++++++++++----------------
 drivers/video/aty/aty128fb.c   |    4 -
 drivers/video/aty/atyfb_base.c |    4 -
 3 files changed, 40 insertions(+), 41 deletions(-)

diff -puN drivers/video/Kconfig~proper-backlight-selection-for-fbdev-drivers drivers/video/Kconfig
--- a/drivers/video/Kconfig~proper-backlight-selection-for-fbdev-drivers
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
@@ -53,9 +42,27 @@ config FB
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
-       depends on FB && I2C && I2C_ALGOBIT
+       depends on FB
+       select I2C_ALGOBIT
+       select I2C
        default n
 
 config FB_CFB_FILLRECT
@@ -126,6 +133,9 @@ config FB_TILEBLITTING
 	 This is particularly important to one driver, matroxfb.  If
 	 unsure, say N.
 
+comment "Frambuffer hardware drivers"
+	depends on FB
+
 config FB_CIRRUS
 	tristate "Cirrus Logic support"
 	depends on FB && (ZORRO || PCI)
@@ -703,6 +713,7 @@ config FB_NVIDIA
 	depends on FB && PCI
 	select I2C_ALGOBIT if FB_NVIDIA_I2C
 	select I2C if FB_NVIDIA_I2C
+	select FB_BACKLIGHT if FB_NVIDIA_BACKLIGHT
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -731,8 +742,7 @@ config FB_NVIDIA_I2C
 
 config FB_NVIDIA_BACKLIGHT
 	bool "Support for backlight control"
-	depends on FB_NVIDIA && PMAC_BACKLIGHT
-	select FB_BACKLIGHT
+	depends on FB_NVIDIA
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display.
@@ -740,9 +750,8 @@ config FB_NVIDIA_BACKLIGHT
 config FB_RIVA
 	tristate "nVidia Riva support"
 	depends on FB && PCI
-	select I2C_ALGOBIT if FB_RIVA_I2C
-	select I2C if FB_RIVA_I2C
 	select FB_DDC if FB_RIVA_I2C
+	select FB_BACKLIGHT if FB_RIVA_BACKLIGHT
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -779,8 +788,7 @@ config FB_RIVA_DEBUG
 
 config FB_RIVA_BACKLIGHT
 	bool "Support for backlight control"
-	depends on FB_RIVA && PMAC_BACKLIGHT
-	select FB_BACKLIGHT
+	depends on FB_RIVA
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display.
@@ -830,8 +838,6 @@ config FB_I810_GTF
 config FB_I810_I2C
 	bool "Enable DDC Support"
 	depends on FB_I810 && FB_I810_GTF
-	select I2C
-	select I2C_ALGOBIT
 	select FB_DDC
 	help
 
@@ -1021,9 +1027,8 @@ config FB_MATROX_MULTIHEAD
 config FB_RADEON
 	tristate "ATI Radeon display support"
 	depends on FB && PCI
-	select I2C_ALGOBIT if FB_RADEON_I2C
-	select I2C if FB_RADEON_I2C
 	select FB_DDC if FB_RADEON_I2C
+	select FB_BACKLIGHT if FB_RADEON_BACKLIGHT
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1053,8 +1058,7 @@ config FB_RADEON_I2C
 
 config FB_RADEON_BACKLIGHT
 	bool "Support for backlight control"
-	depends on FB_RADEON && PMAC_BACKLIGHT
-	select FB_BACKLIGHT
+	depends on FB_RADEON
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display.
@@ -1074,6 +1078,7 @@ config FB_ATY128
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select FB_BACKLIGHT if FB_ATY128_BACKLIGHT
 	select FB_MACMODES if PPC_PMAC
 	help
 	  This driver supports graphics boards with the ATI Rage128 chips.
@@ -1085,8 +1090,7 @@ config FB_ATY128
 
 config FB_ATY128_BACKLIGHT
 	bool "Support for backlight control"
-	depends on FB_ATY128 && PMAC_BACKLIGHT
-	select FB_BACKLIGHT
+	depends on FB_ATY128
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display.
@@ -1097,6 +1101,7 @@ config FB_ATY
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select FB_BACKLIGHT if FB_ATY_BACKLIGHT
 	select FB_MACMODES if PPC
 	help
 	  This driver supports graphics boards with the ATI Mach64 chips.
@@ -1135,8 +1140,7 @@ config FB_ATY_GX
 
 config FB_ATY_BACKLIGHT
 	bool "Support for backlight control"
-	depends on FB_ATY && PMAC_BACKLIGHT
-	select FB_BACKLIGHT
+	depends on FB_ATY
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display.
@@ -1150,8 +1154,6 @@ config FB_S3TRIO
 config FB_SAVAGE
 	tristate "S3 Savage support"
 	depends on FB && PCI && EXPERIMENTAL
-	select I2C_ALGOBIT if FB_SAVAGE_I2C
-	select I2C if FB_SAVAGE_I2C
 	select FB_DDC if FB_SAVAGE_I2C
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
@@ -1646,6 +1648,7 @@ config FB_VIRTUAL
 	  the vfb_enable=1 option.
 
 	  If unsure, say N.
+
 if VT
 	source "drivers/video/console/Kconfig"
 endif
@@ -1654,9 +1657,5 @@ if FB || SGI_NEWPORT_CONSOLE
 	source "drivers/video/logo/Kconfig"
 endif
 
-if SYSFS
-	source "drivers/video/backlight/Kconfig"
-endif
-
 endmenu
 
diff -puN drivers/video/aty/aty128fb.c~proper-backlight-selection-for-fbdev-drivers drivers/video/aty/aty128fb.c
--- a/drivers/video/aty/aty128fb.c~proper-backlight-selection-for-fbdev-drivers
+++ a/drivers/video/aty/aty128fb.c
@@ -2215,7 +2215,7 @@ static int aty128fb_blank(int blank, str
 		return 0;
 
 #ifdef CONFIG_FB_ATY128_BACKLIGHT
-	if (machine_is(powermac) && blank)
+	if (blank)
 		aty128_bl_set_power(fb, FB_BLANK_POWERDOWN);
 #endif
 
@@ -2234,7 +2234,7 @@ static int aty128fb_blank(int blank, str
 	}
 
 #ifdef CONFIG_FB_ATY128_BACKLIGHT
-	if (machine_is(powermac) && !blank)
+	if (!blank)
 		aty128_bl_set_power(fb, FB_BLANK_UNBLANK);
 #endif
 
diff -puN drivers/video/aty/atyfb_base.c~proper-backlight-selection-for-fbdev-drivers drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~proper-backlight-selection-for-fbdev-drivers
+++ a/drivers/video/aty/atyfb_base.c
@@ -2814,7 +2814,7 @@ static int atyfb_blank(int blank, struct
 		return 0;
 
 #ifdef CONFIG_FB_ATY_BACKLIGHT
-	if (machine_is(powermac) && blank > FB_BLANK_NORMAL)
+	if (blank > FB_BLANK_NORMAL)
 		aty_bl_set_power(info, FB_BLANK_POWERDOWN);
 #elif defined(CONFIG_FB_ATY_GENERIC_LCD)
 	if (par->lcd_table && blank > FB_BLANK_NORMAL &&
@@ -2846,7 +2846,7 @@ static int atyfb_blank(int blank, struct
 	aty_st_le32(CRTC_GEN_CNTL, gen_cntl, par);
 
 #ifdef CONFIG_FB_ATY_BACKLIGHT
-	if (machine_is(powermac) && blank <= FB_BLANK_NORMAL)
+	if (blank <= FB_BLANK_NORMAL)
 		aty_bl_set_power(info, FB_BLANK_UNBLANK);
 #elif defined(CONFIG_FB_ATY_GENERIC_LCD)
 	if (par->lcd_table && blank <= FB_BLANK_NORMAL &&
_

Patches currently in -mm which might be from jsimmons@infradead.org are

origin.patch
git-input.patch
proper-backlight-selection-for-fbdev-drivers.patch
fbdev-driver-for-s3-trio-virge.patch
fbdev-driver-for-s3-trio-virge-update.patch
fbdev-driver-for-s3-trio-virge-update-2.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
remove-broken-video-drivers-v4.patch
tgafb-switch-to-framebuffer_alloc.patch
tgafb-fix-copying-overlapping-areas.patch
tgafb-support-the-directcolor-visual.patch
tgafb-fix-the-mode-register-setting.patch
tgafb-module-support-fixes.patch
tgafb-sync-on-green-support-fixes.patch
tgafb-fix-the-pci-id-table.patch
remove-bogus-con_is_present-prototypes.patch
cyber2010-framebuffer-on-arm-netwinder-fix.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
proper-prototype-for-tosh_smm.patch
recognize-video=gx1fb-option.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
pm3fb-kill-pci_find_device-usage.patch
drivers-video-sis-convert-to-generic-boolean.patch
matroxfb-use-kzalloc.patch
remove-the-broken-fb_s3trio-driver.patch
video-fb-add-true-ref_count-atomicity.patch
video-fb-kzalloc-changes.patch
change-nvidiafb_remove-to-__devexit.patch
ps3-add-shutdown-to-virtual-uart-port-driver-framework.patch
ps3-av-settings-driver.patch
fbdev-modedb-allow-refresh-rates-for-named-video-modes.patch
fbdev-modedb-make-more-pointer-parameters-const.patch
fb_videomode_to_var-reset-virtual-screen-parameters.patch
ps3-preallocate-bootmem-memory-for-ps3fb.patch
ps3-virtual-frame-buffer-driver.patch
ps3-disable-display-flipping-during-mode-changes.patch
ps3-cleanup-ps3fb-before-clearing-hpte.patch
ps3-ps3av-fb-defconfig-updates.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
