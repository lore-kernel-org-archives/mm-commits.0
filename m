From: akpm@linux-foundation.org
Subject: - fbdev-fix-kconfig-error-if-fb_ddc=n.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:21:01 -0800
Message-ID: <200703070421.l274L1Pm018857@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46975 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161287AbXCGEVH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:21:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsimmons@infradead.org, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: fix kconfig error if FB_DDC=n
has been removed from the -mm tree.  Its filename was
     fbdev-fix-kconfig-error-if-fb_ddc=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: fix kconfig error if FB_DDC=n
From: James Simmons <jsimmons@infradead.org>

Fix the following error if FB_DDC=n

Kernel: arch/x86_64/boot/bzImage is ready  (#1)
  Building modules, stage 2.
  MODPOST 229 modules
WARNING: "fb_ddc_read" [drivers/video/nvidia/nvidiafb.ko] undefined!
make[1]: *** [__modpost] Error 1

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN drivers/video/Kconfig~fbdev-fix-kconfig-error-if-fb_ddc=n drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-fix-kconfig-error-if-fb_ddc=n
+++ a/drivers/video/Kconfig
@@ -677,8 +677,6 @@ config FB_S1D13XXX
 config FB_NVIDIA
 	tristate "nVidia Framebuffer Support"
 	depends on FB && PCI
-	select I2C_ALGOBIT if FB_NVIDIA_I2C
-	select I2C if FB_NVIDIA_I2C
 	select FB_BACKLIGHT if FB_NVIDIA_BACKLIGHT
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
@@ -697,6 +695,7 @@ config FB_NVIDIA
 config FB_NVIDIA_I2C
        bool "Enable DDC Support"
        depends on FB_NVIDIA
+       select FB_DDC
        help
 	  This enables I2C support for nVidia Chipsets.  This is used
 	  only for getting EDID information from the attached display
@@ -716,7 +715,6 @@ config FB_NVIDIA_BACKLIGHT
 config FB_RIVA
 	tristate "nVidia Riva support"
 	depends on FB && PCI
-	select FB_DDC if FB_RIVA_I2C
 	select FB_BACKLIGHT if FB_RIVA_BACKLIGHT
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
@@ -734,6 +732,7 @@ config FB_RIVA
 config FB_RIVA_I2C
        bool "Enable DDC Support"
        depends on FB_RIVA
+       select FB_DDC
        help
 	  This enables I2C support for nVidia Chipsets.  This is used
 	  only for getting EDID information from the attached display
@@ -812,8 +811,6 @@ config FB_INTEL
 	depends on FB && EXPERIMENTAL && PCI && X86
 	select AGP
 	select AGP_INTEL
-	select I2C_ALGOBIT if FB_INTEL_I2C
-	select I2C if FB_INTEL_I2C
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -846,6 +843,7 @@ config FB_INTEL_DEBUG
 config FB_INTEL_I2C
 	bool "DDC/I2C for Intel framebuffer support"
 	depends on FB_INTEL
+	select FB_DDC
 	default y
 	help
 	  Say Y here if you want DDC/I2C support for your on-board Intel graphics.
@@ -924,8 +922,8 @@ config FB_MATROX_G
 
 config FB_MATROX_I2C
 	tristate "Matrox I2C support"
-	depends on FB_MATROX && I2C
-	select I2C_ALGOBIT
+	depends on FB_MATROX
+	select FB_DDC
 	---help---
 	  This drivers creates I2C buses which are needed for accessing the
 	  DDC (I2C) bus present on all Matroxes, an I2C bus which
@@ -993,7 +991,6 @@ config FB_MATROX_MULTIHEAD
 config FB_RADEON
 	tristate "ATI Radeon display support"
 	depends on FB && PCI
-	select FB_DDC if FB_RADEON_I2C
 	select FB_BACKLIGHT if FB_RADEON_BACKLIGHT
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
@@ -1018,6 +1015,7 @@ config FB_RADEON
 config FB_RADEON_I2C
 	bool "DDC/I2C for ATI Radeon support"
 	depends on FB_RADEON
+	select FB_DDC
 	default y
 	help
 	  Say Y here if you want DDC/I2C support for your Radeon board. 
@@ -1125,7 +1123,6 @@ config FB_S3
 config FB_SAVAGE
 	tristate "S3 Savage support"
 	depends on FB && PCI && EXPERIMENTAL
-	select FB_DDC if FB_SAVAGE_I2C
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1142,6 +1139,7 @@ config FB_SAVAGE
 config FB_SAVAGE_I2C
        bool "Enable DDC2 Support"
        depends on FB_SAVAGE
+       select FB_DDC
        help
 	  This enables I2C support for S3 Savage Chipsets.  This is used
 	  only for getting EDID information from the attached display
_

Patches currently in -mm which might be from jsimmons@infradead.org are

origin.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch
aty128fb-fix-blanking.patch
change-rivafb_remove-to-__devexit.patch
fbdev-display-class.patch
fbdev-display-class-fix.patch
tgafb-turbochannel-support.patch
tgafb-accelerated-code.patch
