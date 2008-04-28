From: akpm@linux-foundation.org
Subject: - olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:09 -0700
Message-ID: <200804282159.m3SLx9AL018556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965453AbYD1V7W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     OLPC: gxfb/lxfb: add DCON panel modes to framebuffer drivers
has been removed from the -mm tree.  Its filename was
     olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: OLPC: gxfb/lxfb: add DCON panel modes to framebuffer drivers
From: Andres Salomon <dilinger@queued.net>

Since there's no way to autodetect panel modes, we're forced to hardcode them
in the driver and add a big fat #ifdef.  The OLPC DCON needs a specific mode
line (at 1200x900).  This adds it to both gxfb and lxfb.

(Jordan said: We could probably detect the panel mode, but there isn't any
reason to since the panel timings are well known and won't change.  While OFW
detection would be good computer science fu, it would be a wasted effort since
its so easy to hard code them into the table.)

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/gxfb_core.c |   37 ++++++++++++++++++++++++++++--
 drivers/video/geode/lxfb_core.c |   37 +++++++++++++++++++++++++-----
 2 files changed, 67 insertions(+), 7 deletions(-)

diff -puN drivers/video/geode/gxfb_core.c~olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers
+++ a/drivers/video/geode/gxfb_core.c
@@ -41,7 +41,7 @@ static int vram;
 static int vt_switch;
 
 /* Modes relevant to the GX (taken from modedb.c) */
-static const struct fb_videomode gx_modedb[] __initdata = {
+static struct fb_videomode gx_modedb[] __initdata = {
 	/* 640x480-60 VESA */
 	{ NULL, 60, 640, 480, 39682,  48, 16, 33, 10, 96, 2,
 	  0, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
@@ -108,6 +108,35 @@ static const struct fb_videomode gx_mode
 	  FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
 };
 
+#ifdef CONFIG_OLPC
+#include <asm/olpc.h>
+
+static struct fb_videomode gx_dcon_modedb[] __initdata = {
+	/* The only mode the DCON has is 1200x900 */
+	{ NULL, 50, 1200, 900, 17460, 24, 8, 4, 5, 8, 3,
+	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	  FB_VMODE_NONINTERLACED, 0 }
+};
+
+static void __init get_modedb(struct fb_videomode **modedb, unsigned int *size)
+{
+	if (olpc_has_dcon()) {
+		*modedb = (struct fb_videomode *) gx_dcon_modedb;
+		*size = ARRAY_SIZE(gx_dcon_modedb);
+	} else {
+		*modedb = (struct fb_videomode *) gx_modedb;
+		*size = ARRAY_SIZE(gx_modedb);
+	}
+}
+
+#else
+static void __init get_modedb(struct fb_videomode **modedb, unsigned int *size)
+{
+	*modedb = (struct fb_videomode *) gx_modedb;
+	*size = ARRAY_SIZE(gx_modedb);
+}
+#endif
+
 static int gxfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	if (var->xres > 1600 || var->yres > 1200)
@@ -350,6 +379,9 @@ static int __init gxfb_probe(struct pci_
 	int ret;
 	unsigned long val;
 
+	struct fb_videomode *modedb_ptr;
+	unsigned int modedb_size;
+
 	info = gxfb_init_fbinfo(&pdev->dev);
 	if (!info)
 		return -ENOMEM;
@@ -369,8 +401,9 @@ static int __init gxfb_probe(struct pci_
 	else
 		par->enable_crt = 1;
 
+	get_modedb(&modedb_ptr, &modedb_size);
 	ret = fb_find_mode(&info->var, info, mode_option,
-			   gx_modedb, ARRAY_SIZE(gx_modedb), NULL, 16);
+			   modedb_ptr, modedb_size, NULL, 16);
 	if (ret == 0 || ret == 4) {
 		dev_err(&pdev->dev, "could not find valid video mode\n");
 		ret = -EINVAL;
diff -puN drivers/video/geode/lxfb_core.c~olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers drivers/video/geode/lxfb_core.c
--- a/drivers/video/geode/lxfb_core.c~olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers
+++ a/drivers/video/geode/lxfb_core.c
@@ -36,7 +36,7 @@ static int vt_switch;
  * we try to make it something sane - 640x480-60 is sane
  */
 
-static const struct fb_videomode geode_modedb[] __initdata = {
+static struct fb_videomode geode_modedb[] __initdata = {
 	/* 640x480-60 */
 	{ NULL, 60, 640, 480, 39682, 48, 8, 25, 2, 88, 2,
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
@@ -217,6 +217,35 @@ static const struct fb_videomode geode_m
 	  0, FB_VMODE_NONINTERLACED, 0 },
 };
 
+#ifdef CONFIG_OLPC
+#include <asm/olpc.h>
+
+static struct fb_videomode olpc_dcon_modedb[] __initdata = {
+	/* The only mode the DCON has is 1200x900 */
+	{ NULL, 50, 1200, 900, 17460, 24, 8, 4, 5, 8, 3,
+	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	  FB_VMODE_NONINTERLACED, 0 }
+};
+
+static void __init get_modedb(struct fb_videomode **modedb, unsigned int *size)
+{
+	if (olpc_has_dcon()) {
+		*modedb = (struct fb_videomode *) olpc_dcon_modedb;
+		*size = ARRAY_SIZE(olpc_dcon_modedb);
+	} else {
+		*modedb = (struct fb_videomode *) geode_modedb;
+		*size = ARRAY_SIZE(geode_modedb);
+	}
+}
+
+#else
+static void __init get_modedb(struct fb_videomode **modedb, unsigned int *size)
+{
+	*modedb = (struct fb_videomode *) geode_modedb;
+	*size = ARRAY_SIZE(geode_modedb);
+}
+#endif
+
 static int lxfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	if (var->xres > 1920 || var->yres > 1440)
@@ -477,7 +506,7 @@ static int __init lxfb_probe(struct pci_
 	int ret;
 
 	struct fb_videomode *modedb_ptr;
-	int modedb_size;
+	unsigned int modedb_size;
 
 	info = lxfb_init_fbinfo(&pdev->dev);
 
@@ -502,9 +531,7 @@ static int __init lxfb_probe(struct pci_
 
 	/* Set up the mode database */
 
-	modedb_ptr = (struct fb_videomode *) geode_modedb;
-	modedb_size = ARRAY_SIZE(geode_modedb);
