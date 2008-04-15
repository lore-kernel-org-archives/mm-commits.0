From: akpm@linux-foundation.org
Subject: + olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers.patch added to -mm tree
Date: Mon, 14 Apr 2008 18:21:18 -0700
Message-ID: <200804150121.m3F1LI8K003970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760606AbYDOBWG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 21:22:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com


The patch titled
     OLPC: gxfb/lxfb: add DCON panel modes to framebuffer drivers
has been added to the -mm tree.  Its filename is
     olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 drivers/video/geode/gxfb_core.c |   35 +++++++++++++++++++++++++++++-
 drivers/video/geode/lxfb_core.c |   35 ++++++++++++++++++++++++++----
 2 files changed, 65 insertions(+), 5 deletions(-)

diff -puN drivers/video/geode/gxfb_core.c~olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers
+++ a/drivers/video/geode/gxfb_core.c
@@ -108,6 +108,35 @@ static const struct fb_videomode gx_mode
 	  FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
 };
 
+#ifdef CONFIG_OLPC
+#include <asm/olpc.h>
+
+static const struct fb_videomode gx_dcon_modedb[] __initdata = {
+	/* The only mode the DCON has is 1200x900 */
+	{ NULL, 50, 1200, 900, 17460, 24, 8, 4, 5, 8, 3,
+	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	  FB_VMODE_NONINTERLACED, 0 }
+};
+
+static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
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
+static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
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
@@ -217,6 +217,35 @@ static const struct fb_videomode geode_m
 	  0, FB_VMODE_NONINTERLACED, 0 },
 };
 
+#ifdef CONFIG_OLPC
+#include <asm/olpc.h>
+
+const struct fb_videomode olpc_dcon_modedb[] __initdata = {
+	/* The only mode the DCON has is 1200x900 */
+	{ NULL, 50, 1200, 900, 17460, 24, 8, 4, 5, 8, 3,
+	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	  FB_VMODE_NONINTERLACED, 0 }
+};
+
+static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
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
+static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
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
-
+	get_modedb(&modedb_ptr, &modedb_size);
 	ret = fb_find_mode(&info->var, info, mode_option,
 			   modedb_ptr, modedb_size, NULL, 16);
 
_

Patches currently in -mm which might be from dilinger@queued.net are

x86-geode-msr-cleanup.patch
x86-geode-add-virtual-systems-architecture-detection.patch
gxfb-use-pci_device-for-gxfbs-pci-device-table.patch
gxfb-replace-fbsize-config-option-with-a-module-parameter.patch
gxfb-create-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
gxfb-clean-up-register-definitions.patch
gxfb-move-msr-bit-fields-into-gxfbh.patch
gxfb-stop-sharing-code-with-gx1fb.patch
gxfb-add-power-management-functionality.patch
gxfb-add-power-management-functionality-fix.patch
gxfb-add-power-management-functionality-update.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-create-gp-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
lxfb-clean-up-register-definitions.patch
lxfb-clean-up-final-bits-of-df_regs.patch
lxfb-rearrange-rename-msr-bitfields.patch
lxfb-add-power-management-functionality.patch
lxfb-add-power-management-functionality-fix.patch
lxfb-add-power-management-functionality-update.patch
lxfb-rename-kernel-arg-fbsize-to-vram.patch
lxfb-disable-suspend-vt-switch-by-default.patch
lxfb-gxfb-when-blanking-with-fb_blank_powerdown-also-turn-off-the-crt.patch
gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size.patch
gxfb-lxfb-detect-framebuffer-size-using-an-msr-if-vsa2-isnt-available.patch
olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers.patch

