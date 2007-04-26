From: akpm@linux-foundation.org
Subject: + fbdev-link-vgastateo-using-kconfig.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:32:38 -0700
Message-ID: <200704260032.l3Q0Wc5q016910@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423414AbXDZAcm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:32:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     fbdev: link vgastate.o using Kconfig
has been added to the -mm tree.  Its filename is
     fbdev-link-vgastateo-using-kconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -478,6 +482,7 @@ config FB_VGA16
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select VGASTATE
 	help
 	  This is the frame buffer device driver for VGA 16 color graphic
 	  cards. Say Y if you have such a card.
@@ -713,6 +718,7 @@ config FB_NVIDIA
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	select BITREVERSE
+	select VGASTATE
 	help
 	  This driver supports graphics boards with the nVidia chips, TNT
 	  and newer. For very old chipsets, such as the RIVA128, then use
@@ -751,6 +757,7 @@ config FB_RIVA
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	select BITREVERSE
+	select VGASTATE
 	help
 	  This driver supports graphics boards with the nVidia Riva/Geforce
 	  chips.
@@ -797,6 +804,7 @@ config FB_I810
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select VGASTATE
 	help
 	  This driver supports the on-board graphics built in to the Intel 810 
           and 815 chipsets.  Say Y if you have and plan to use such a board.
@@ -1147,6 +1155,7 @@ config FB_S3
 	select FB_CFB_IMAGEBLIT
 	select FB_TILEBLITTING
 	select FB_SVGALIB
+	select VGASTATE
 	---help---
 	  Driver for graphics boards with S3 Trio / S3 Virge chip.
 
@@ -1157,6 +1166,7 @@ config FB_SAVAGE
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select VGASTATE
 	help
 	  This driver supports notebooks and computers with S3 Savage PCI/AGP
 	  chips.
@@ -1223,6 +1233,7 @@ config FB_NEOMAGIC
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
@@ -105,7 +105,7 @@ obj-$(CONFIG_FB_SM501)            += sm5
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
fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch
intelfb-fix-ring-space-calculation.patch
nvidiafb-bring-back-generic-ddc-reading.patch
fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
fbdev-fix-obvious-bug-in-show_pan.patch
neofb-fill-transp-msb_right-with-the-correct.patch
atyfb-kill-dead-code.patch
fbdev-mm-deferred-io-support.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-mm-deferred-io-support-fix-2.patch
fbdev-hecuba-framebuffer-driver.patch
fbdev-hecuba-framebuffer-driver-fix.patch
nvidiafb-fix-reversed-ddc-port.patch
vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch
fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch
rivafb-nvidiafb-enable-hardware-monitoring.patch
rivafb-handle-i2c-bus-creation-failure.patch
rivafb-nvidiafb-various-cleanups.patch
rivafb-fixed-reversed-ddc-ports.patch
nvidiafb-ensure-that-crtc-registers-are-accessible.patch
nvidiafb-access-crt-registers-safely.patch
skeletonfb-various-corrections.patch
epson1355fbc-fix-error-handling-code.patch
nvidiafb-vga-state-save-and-restore.patch
savagefb-rework-i2c-bit-access.patch
savagefb-vga-state-save-and-restore.patch
fbdev-link-vgastateo-using-kconfig.patch
fbcon-delay-screen-update-when-setting-the-mode-of.patch
nvidiafb-fix-sparse-warning.patch
rivafb-fix-io-access.patch
fbdev-kill-sparse-warning-in-deferred-io.patch
fbdev-add-sparse-annotations-in-svgalibc.patch
arcfb-kill-sparse-warning.patch
s3fb-add-sparse-annotations.patch
hecubafb-kill-sparse-warnings.patch
i810fb-fix-incorrect-frequency-mask.patch
vt-add-documentation-for-new-boot-sysfs-options.patch
skeletonfb-documentation-error-fixes.patch
fbdev-add-drawing-functions-for-framebuffers-in-system.patch
arcfb-use-sys-instead-of-cfb-drawing-functions.patch
hecubafb-use-sys-instead-of-cfb-drawing-functions.patch
vfb-use-sys-instead-of-cfb-drawing-functions.patch
fbdev-pass-struct-fb_info-to-fb_read-and-fb_write.patch
fbdev-add-fb_read-fb_write-functions-for-framebuffers.patch
arcfb-us-fb_sys_read.patch
hecubafb-us-fb_sys_read.patch
vfb-us-fb_sys_read-and-fb_sys_write.patch
fbdev-consolidate-common-drawing-functions-into-a.patch
fbdev-advertise-limitation-of-drawing-engine.patch
fbcon-font-setting-should-check-limitation-of-driver.patch
vga16fb-restrict-to-blit-rectangles-with-widths-of.patch
s3fb-limit-8x16-rectangles-when-tileblitting-is-enabled.patch
fbdev-add-tile-operation-to-get-the-maximum-length.patch
s3fb-implement-fb_get_tilemax.patch
fbcon-check-if-the-character-count-can-be-handled.patch
fbdev-save-the-activate-field-before-calling-fb_check_var.patch
s3fb-driver-fixes.patch
vmlfb-framebuffer-driver-for-intel-vermilion-range.patch
nvidiafb-rivafb-switch-to-pci_get-refcounting.patch
pm2fb-3dlabs-permedia-2v-reference-board-added.patch
pm2fb-permedia-2v-memory-clock-setting.patch
pm2fb-pixclock-setting-restriction.patch
nvidiafb-prevent-triggering-of-softlockup.patch
