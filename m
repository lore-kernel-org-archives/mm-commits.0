From: akpm@osdl.org
Subject: - gxfb-support-command-line-options.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:40 -0800
Message-ID: <200612082014.kB8KEe4w003200@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59859 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946867AbWLHUOv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jordan.crouse@amd.com, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     gxfb: Support command line options
has been removed from the -mm tree.  Its filename was
     gxfb-support-command-line-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: gxfb: Support command line options
From: Jordan Crouse <jordan.crouse@amd.com>

Add support for command line options for setting the mode and various
settings.

[akpm@osdl.org: cleanups]
Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/geode/gxfb_core.c |   37 +++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 6 deletions(-)

diff -puN drivers/video/geode/gxfb_core.c~gxfb-support-command-line-options drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~gxfb-support-command-line-options
+++ a/drivers/video/geode/gxfb_core.c
@@ -35,10 +35,10 @@
 #include "display_gx.h"
 #include "video_gx.h"
 
-static char mode_option[32] = "640x480-16@60";
+static char *mode_option;
 
 /* Modes relevant to the GX (taken from modedb.c) */
-static const struct fb_videomode __initdata gx_modedb[] = {
+static const struct fb_videomode gx_modedb[] __initdata = {
 	/* 640x480-60 VESA */
 	{ NULL, 60, 640, 480, 39682,  48, 16, 33, 10, 96, 2,
 	  0, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
@@ -341,7 +341,8 @@ static int __init gxfb_probe(struct pci_
 		goto err;
 	}
 
-        /* Clear the frame buffer of garbage. */
+
+	/* Clear the frame buffer of garbage. */
         memset_io(info->screen_base, 0, info->fix.smem_len);
 
 	gxfb_check_var(&info->var, info);
@@ -411,11 +412,35 @@ static struct pci_driver gxfb_driver = {
 	.remove		= gxfb_remove,
 };
 
+#ifndef MODULE
+static int __init gxfb_setup(char *options)
+{
+
+	char *opt;
+
+	if (!options || !*options)
+		return 0;
+
+	while ((opt = strsep(&options, ",")) != NULL) {
+		if (!*opt)
+			continue;
+
+		mode_option = opt;
+	}
+
+	return 0;
+}
+#endif
+
 static int __init gxfb_init(void)
 {
 #ifndef MODULE
-	if (fb_get_options("gxfb", NULL))
+	char *option = NULL;
+
+	if (fb_get_options("gxfb", &option))
 		return -ENODEV;
+
+	gxfb_setup(option);
 #endif
 	return pci_register_driver(&gxfb_driver);
 }
@@ -428,8 +453,8 @@ static void __exit gxfb_cleanup(void)
 module_init(gxfb_init);
 module_exit(gxfb_cleanup);
 
-module_param_string(mode, mode_option, sizeof(mode_option), 0444);
-MODULE_PARM_DESC(mode, "video mode (<x>x<y>[-<bpp>][@<refr>])");
+module_param(mode_option, charp, 0);
+MODULE_PARM_DESC(mode_option, "video mode (<x>x<y>[-<bpp>][@<refr>])");
 
 MODULE_DESCRIPTION("Framebuffer driver for the AMD Geode GX");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from jordan.crouse@amd.com are

origin.patch
gxfb-support-command-line-options.patch
gxfb-fixup-flatpanel-detection.patch
gxfb-turn-on-the-flatpanel-power-and-data.patch
acpi-clear-gpe-before-disabling-it.patch

