From: akpm@linux-foundation.org
Subject: - gxfb-replace-fbsize-config-option-with-a-kernel-argument.patch removed from -mm tree
Date: Tue, 11 Mar 2008 13:27:47 -0700
Message-ID: <200803112027.m2BKRlaL025252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757050AbYCKU2p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 16:28:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, dwmw2@infradead.org, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     gxfb: replace FBSIZE config option with a kernel argument
has been removed from the -mm tree.  Its filename was
     gxfb-replace-fbsize-config-option-with-a-kernel-argument.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gxfb: replace FBSIZE config option with a kernel argument
From: Andres Salomon <dilinger@queued.net>

Use a command line option (fbsize:) rather than hardcoding the vram size. 
LxFB already does this; it's useful for machines that can't query the BIOS for
fb size.  This patch originated from David Woodhouse, was modified by Jordan
Crouse, and was then modified further by me.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/Kconfig      |   20 --------------------
 drivers/video/geode/display_gx.c |    7 -------
 drivers/video/geode/gxfb_core.c  |   19 ++++++++++++-------
 3 files changed, 12 insertions(+), 34 deletions(-)

diff -puN drivers/video/geode/Kconfig~gxfb-replace-fbsize-config-option-with-a-kernel-argument drivers/video/geode/Kconfig
--- a/drivers/video/geode/Kconfig~gxfb-replace-fbsize-config-option-with-a-kernel-argument
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
diff -puN drivers/video/geode/display_gx.c~gxfb-replace-fbsize-config-option-with-a-kernel-argument drivers/video/geode/display_gx.c
--- a/drivers/video/geode/display_gx.c~gxfb-replace-fbsize-config-option-with-a-kernel-argument
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
diff -puN drivers/video/geode/gxfb_core.c~gxfb-replace-fbsize-config-option-with-a-kernel-argument drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~gxfb-replace-fbsize-config-option-with-a-kernel-argument
+++ a/drivers/video/geode/gxfb_core.c
@@ -36,6 +36,7 @@
 #include "video_gx.h"
 
 static char *mode_option;
+static int fbsize;
 
 /* Modes relevant to the GX (taken from modedb.c) */
 static const struct fb_videomode gx_modedb[] __initdata = {
@@ -207,7 +208,6 @@ static int gxfb_blank(int blank_mode, st
 static int __init gxfb_map_video_memory(struct fb_info *info, struct pci_dev *dev)
 {
 	struct geodefb_par *par = info->par;
-	int fb_len;
 	int ret;
 
 	ret = pci_enable_device(dev);
@@ -232,21 +232,20 @@ static int __init gxfb_map_video_memory(
 	ret = pci_request_region(dev, 0, "gxfb (framebuffer)");
 	if (ret < 0)
 		return ret;
-	if ((fb_len = gx_frame_buffer_size()) < 0)
-		return -ENOMEM;
+
 	info->fix.smem_start = pci_resource_start(dev, 0);
-	info->fix.smem_len = fb_len;
+	info->fix.smem_len = fbsize ? fbsize : gx_frame_buffer_size();
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
@@ -425,7 +424,10 @@ static int __init gxfb_setup(char *optio
 		if (!*opt)
 			continue;
 
-		mode_option = opt;
+		if (!strncmp(opt, "fbsize:", 7))
+			fbsize = simple_strtoul(opt+7, NULL, 0);
+		else
+			mode_option = opt;
 	}
 
 	return 0;
@@ -456,5 +458,8 @@ module_exit(gxfb_cleanup);
 module_param(mode_option, charp, 0);
 MODULE_PARM_DESC(mode_option, "video mode (<x>x<y>[-<bpp>][@<refr>])");
 
+module_param(fbsize, int, 0);
+MODULE_PARM_DESC(fbsize, "video memory size");
+
 MODULE_DESCRIPTION("Framebuffer driver for the AMD Geode GX");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from dilinger@queued.net are

gxfb-replace-fbsize-config-option-with-a-kernel-argument.patch
gxfb-use-pci_device-for-gxfbs-pci-device-table.patch

