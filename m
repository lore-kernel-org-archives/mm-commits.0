From: akpm@linux-foundation.org
Subject: - gxfb-replace-fbsize-config-option-with-a-module-parameter.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:57:37 -0700
Message-ID: <200804282157.m3SLvbKe018413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965168AbYD1V54 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:57:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     gxfb: replace FBSIZE config option with a module parameter
has been removed from the -mm tree.  Its filename was
     gxfb-replace-fbsize-config-option-with-a-module-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gxfb: replace FBSIZE config option with a module parameter
From: Andres Salomon <dilinger@queued.net>

Use a command line option (vram) rather than hardcoding the vram size.  LxFB
already does this; it's useful for machines that can't query the BIOS for fb
size.  This patch originated from David Woodhouse, was modified by Jordan
Crouse, and was then modified further by me.

This also adds some gxfb documentation in Documentation/fb.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/gxfb.txt        |   51 +++++++++++++++++++++++++++++
 drivers/video/geode/Kconfig      |   20 -----------
 drivers/video/geode/display_gx.c |    7 ---
 drivers/video/geode/gxfb_core.c  |   14 ++++---
 4 files changed, 59 insertions(+), 33 deletions(-)

diff -puN /dev/null Documentation/fb/gxfb.txt
--- /dev/null
+++ a/Documentation/fb/gxfb.txt
@@ -0,0 +1,51 @@
+[This file is cloned from VesaFB/aty128fb]
+
+What is gxfb?
+=================
+
+This is a graphics framebuffer driver for AMD Geode GX2 based processors.
+
+Advantages:
+
+ * No need to use AMD's VSA code (or other VESA emulation layer) in the
+   BIOS.
+ * It provides a nice large console (128 cols + 48 lines with 1024x768)
+   without using tiny, unreadable fonts.
+ * You can run XF68_FBDev on top of /dev/fb0
+ * Most important: boot logo :-)
+
+Disadvantages:
+
+ * graphic mode is slower than text mode...
+
+
+How to use it?
+==============
+
+Switching modes is done using  gxfb.mode_option=<resolution>... boot
+parameter or using `fbset' program.
+
+See Documentation/fb/modedb.txt for more information on modedb
+resolutions.
+
+
+X11
+===
+
+XF68_FBDev should generally work fine, but it is non-accelerated.
+
+
+Configuration
+=============
+
+You can pass kernel command line options to gxfb with gxfb.<option>.
+For example, gxfb.mode_option=800x600@75.
+Accepted options:
+
+mode_option	- specify the video mode.  Of the form
+		  <x>x<y>[-<bpp>][@<refresh>]
+vram		- size of video ram (normally auto-detected)
+
+
+--
+Andres Salomon <dilinger@debian.org>
diff -puN drivers/video/geode/Kconfig~gxfb-replace-fbsize-config-option-with-a-module-parameter drivers/video/geode/Kconfig
--- a/drivers/video/geode/Kconfig~gxfb-replace-fbsize-config-option-with-a-module-parameter
+++ a/drivers/video/geode/Kconfig
@@ -38,26 +38,6 @@ config FB_GEODE_GX
 
 	  If unsure, say N.
 
-config FB_GEODE_GX_SET_FBSIZE
-	bool "Manually specify the Geode GX framebuffer size"
-	depends on FB_GEODE_GX
-	default n
-	---help---
-	  If you want to manually specify the size of your GX framebuffer,
-	  say Y here, otherwise say N to dynamically probe it.
-
-	  Say N unless you know what you are doing.
-
-config FB_GEODE_GX_FBSIZE
-	hex "Size of the GX framebuffer, in bytes"
-	depends on FB_GEODE_GX_SET_FBSIZE
-	default "0x1600000"
-	---help---
-	  Specify the size of the GX framebuffer.  Normally, you will
-	  want this to be MB aligned.  Common values are 0x80000 (8MB)
-	  and 0x1600000 (16MB).  Don't change this unless you know what
-	  you are doing
-
 config FB_GEODE_GX1
 	tristate "AMD Geode GX1 framebuffer support (EXPERIMENTAL)"
 	depends on FB && FB_GEODE && EXPERIMENTAL
diff -puN drivers/video/geode/display_gx.c~gxfb-replace-fbsize-config-option-with-a-module-parameter drivers/video/geode/display_gx.c
--- a/drivers/video/geode/display_gx.c~gxfb-replace-fbsize-config-option-with-a-module-parameter
+++ a/drivers/video/geode/display_gx.c
@@ -21,12 +21,6 @@
 #include "geodefb.h"
 #include "display_gx.h"
 
-#ifdef CONFIG_FB_GEODE_GX_SET_FBSIZE
-unsigned int gx_frame_buffer_size(void)
-{
-	return CONFIG_FB_GEODE_GX_FBSIZE;
-}
-#else
 unsigned int gx_frame_buffer_size(void)
 {
 	unsigned int val;
@@ -41,7 +35,6 @@ unsigned int gx_frame_buffer_size(void)
 	val = (unsigned int)(inw(0xAC1E)) & 0xFFl;
 	return (val << 19);
 }
-#endif
 
 int gx_line_delta(int xres, int bpp)
 {
diff -puN drivers/video/geode/gxfb_core.c~gxfb-replace-fbsize-config-option-with-a-module-parameter drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~gxfb-replace-fbsize-config-option-with-a-module-parameter
+++ a/drivers/video/geode/gxfb_core.c
@@ -37,6 +37,7 @@
 #include "video_gx.h"
 
 static char *mode_option;
+static int vram;
 
 /* Modes relevant to the GX (taken from modedb.c) */
 static const struct fb_videomode gx_modedb[] __initdata = {
@@ -208,7 +209,6 @@ static int gxfb_blank(int blank_mode, st
 static int __init gxfb_map_video_memory(struct fb_info *info, struct pci_dev *dev)
 {
 	struct geodefb_par *par = info->par;
-	int fb_len;
 	int ret;
 
 	ret = pci_enable_device(dev);
@@ -233,21 +233,20 @@ static int __init gxfb_map_video_memory(
 	ret = pci_request_region(dev, 0, "gxfb (framebuffer)");
 	if (ret < 0)
 		return ret;
-	if ((fb_len = gx_frame_buffer_size()) < 0)
-		return -ENOMEM;
+
 	info->fix.smem_start = pci_resource_start(dev, 0);
-	info->fix.smem_len = fb_len;
+	info->fix.smem_len = vram ? vram : gx_frame_buffer_size();
 	info->screen_base = ioremap(info->fix.smem_start, info->fix.smem_len);
 	if (!info->screen_base)
 		return -ENOMEM;
 
-	/* Set the 16MB aligned base address of the graphics memory region
+	/* Set the 16MiB aligned base address of the graphics memory region
 	 * in the display controller */
 
 	writel(info->fix.smem_start & 0xFF000000,
 			par->dc_regs + DC_GLIU0_MEM_OFFSET);
 
-	dev_info(&dev->dev, "%d Kibyte of video memory at 0x%lx\n",
+	dev_info(&dev->dev, "%d KiB of video memory at 0x%lx\n",
 		 info->fix.smem_len / 1024, info->fix.smem_start);
 
 	return 0;
@@ -455,5 +454,8 @@ module_exit(gxfb_cleanup);
 module_param(mode_option, charp, 0);
 MODULE_PARM_DESC(mode_option, "video mode (<x>x<y>[-<bpp>][@<refr>])");
 
+module_param(vram, int, 0);
+MODULE_PARM_DESC(vram, "video memory size");
+
 MODULE_DESCRIPTION("Framebuffer driver for the AMD Geode GX");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
git-kbuild.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch

