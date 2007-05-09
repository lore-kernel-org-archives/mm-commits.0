From: akpm@linux-foundation.org
Subject: - fbdev-link-vgastateo-using-kconfig.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:50 -0700
Message-ID: <200705090300.l4930oM8010614@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032920AbXEIDAy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: link vgastate.o using Kconfig
has been removed from the -mm tree.  Its filename was
     fbdev-link-vgastateo-using-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: link vgastate.o using Kconfig
From: "Antonino A. Daplas" <adaplas@gmail.com>

Instead of directly linking vgastate.o by individual drivers, create a Kconfig
option VGASTATE which can be 'SELECT'ed by individual drivers instead.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig  |   11 +++++++++++
 drivers/video/Makefile |   14 +++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff -puN drivers/video/Kconfig~fbdev-link-vgastateo-using-kconfig drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-link-vgastateo-using-kconfig
+++ a/drivers/video/Kconfig
@@ -7,6 +7,10 @@ menu "Graphics support"
 source "drivers/video/backlight/Kconfig"
 source "drivers/video/display/Kconfig"
 
+config VGASTATE
+       tristate
+       default n
+
 config FB
 	tristate "Support for frame buffer devices"
 	---help---
@@ -481,6 +485,7 @@ config FB_VGA16
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select VGASTATE
 	help
 	  This is the frame buffer device driver for VGA 16 color graphic
 	  cards. Say Y if you have such a card.
@@ -716,6 +721,7 @@ config FB_NVIDIA
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	select BITREVERSE
+	select VGASTATE
 	help
 	  This driver supports graphics boards with the nVidia chips, TNT
 	  and newer. For very old chipsets, such as the RIVA128, then use
@@ -754,6 +760,7 @@ config FB_RIVA
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	select BITREVERSE
+	select VGASTATE
 	help
 	  This driver supports graphics boards with the nVidia Riva/Geforce
 	  chips.
@@ -800,6 +807,7 @@ config FB_I810
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select VGASTATE
 	help
 	  This driver supports the on-board graphics built in to the Intel 810 
           and 815 chipsets.  Say Y if you have and plan to use such a board.
@@ -1150,6 +1158,7 @@ config FB_S3
 	select FB_CFB_IMAGEBLIT
 	select FB_TILEBLITTING
 	select FB_SVGALIB
+	select VGASTATE
 	---help---
 	  Driver for graphics boards with S3 Trio / S3 Virge chip.
 
@@ -1160,6 +1169,7 @@ config FB_SAVAGE
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select VGASTATE
 	help
 	  This driver supports notebooks and computers with S3 Savage PCI/AGP
 	  chips.
@@ -1226,6 +1236,7 @@ config FB_NEOMAGIC
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select VGASTATE
 	help
 	  This driver supports notebooks with NeoMagic PCI chips.
 	  Say Y if you have such a graphics card. 
diff -puN drivers/video/Makefile~fbdev-link-vgastateo-using-kconfig drivers/video/Makefile
--- a/drivers/video/Makefile~fbdev-link-vgastateo-using-kconfig
+++ a/drivers/video/Makefile
@@ -4,6 +4,7 @@
 
 # Each configuration option enables a list of files.
 
+obj-$(CONFIG_VGASTATE)            += vgastate.o
 obj-y                             += fb_notify.o
 obj-$(CONFIG_FB)                  += fb.o
 fb-y                              := fbmem.o fbmon.o fbcmap.o fbsysfs.o \
@@ -31,18 +32,17 @@ obj-$(CONFIG_FB_PM2)              += pm2
 obj-$(CONFIG_FB_PM3)		  += pm3fb.o
 
 obj-$(CONFIG_FB_MATROX)		  += matrox/
-obj-$(CONFIG_FB_RIVA)		  += riva/ vgastate.o
-obj-$(CONFIG_FB_NVIDIA)		  += nvidia/ vgastate.o
+obj-$(CONFIG_FB_RIVA)		  += riva/
+obj-$(CONFIG_FB_NVIDIA)		  += nvidia/
 obj-$(CONFIG_FB_ATY)		  += aty/ macmodes.o
 obj-$(CONFIG_FB_ATY128)		  += aty/ macmodes.o
 obj-$(CONFIG_FB_RADEON)		  += aty/
 obj-$(CONFIG_FB_SIS)		  += sis/
 obj-$(CONFIG_FB_KYRO)             += kyro/
-obj-$(CONFIG_FB_SAVAGE)		  += savage/ vgastate.o
+obj-$(CONFIG_FB_SAVAGE)		  += savage/
 obj-$(CONFIG_FB_GEODE)		  += geode/
 obj-$(CONFIG_FB_MBX)		  += mbx/
-obj-$(CONFIG_FB_I810)             += vgastate.o
-obj-$(CONFIG_FB_NEOMAGIC)         += neofb.o vgastate.o
+obj-$(CONFIG_FB_NEOMAGIC)         += neofb.o
 obj-$(CONFIG_FB_3DFX)             += tdfxfb.o
 obj-$(CONFIG_FB_CONTROL)          += controlfb.o
 obj-$(CONFIG_FB_PLATINUM)         += platinumfb.o
@@ -52,7 +52,7 @@ obj-$(CONFIG_FB_IMSTT)            += ims
 obj-$(CONFIG_FB_FM2)              += fm2fb.o
 obj-$(CONFIG_FB_CYBLA)            += cyblafb.o
 obj-$(CONFIG_FB_TRIDENT)          += tridentfb.o
-obj-$(CONFIG_FB_S3)               += s3fb.o vgastate.o
+obj-$(CONFIG_FB_S3)               += s3fb.o
 obj-$(CONFIG_FB_STI)              += stifb.o
 obj-$(CONFIG_FB_FFB)              += ffb.o sbuslib.o
 obj-$(CONFIG_FB_CG6)              += cg6.o sbuslib.o
@@ -108,7 +108,7 @@ obj-$(CONFIG_FB_SM501)            += sm5
 # Platform or fallback drivers go here
 obj-$(CONFIG_FB_VESA)             += vesafb.o
 obj-$(CONFIG_FB_IMAC)             += imacfb.o
-obj-$(CONFIG_FB_VGA16)            += vga16fb.o vgastate.o
+obj-$(CONFIG_FB_VGA16)            += vga16fb.o
 obj-$(CONFIG_FB_OF)               += offb.o
 
 # the test framebuffer is last
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
