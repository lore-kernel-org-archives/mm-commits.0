From: akpm@linux-foundation.org
Subject: - xilinxfb-dont-bail-if-the-xilinxfb-platform-device-doesnt-have-any-pdata.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:55:07 -0700
Message-ID: <200707312355.l6VNt7kn029206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40628 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761429AbXHAARM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: grant.likely@secretlab.ca, adaplas@gmail.com, akonovalov@ru.mvista.com, mm-commits@vger.kernel.org


The patch titled
     xilinxfb: Don't bail if the xilinxfb platform device  doesn't have any pdata
has been removed from the -mm tree.  Its filename was
     xilinxfb-dont-bail-if-the-xilinxfb-platform-device-doesnt-have-any-pdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xilinxfb: Don't bail if the xilinxfb platform device  doesn't have any pdata
From: Grant Likely <grant.likely@secretlab.ca>

Lack of pdata is not a fatal omission.  The driver can still be used even
if we do not know the screen dimensions.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Andrei Konovalov <akonovalov@ru.mvista.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/xilinxfb.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff -puN drivers/video/xilinxfb.c~xilinxfb-dont-bail-if-the-xilinxfb-platform-device-doesnt-have-any-pdata drivers/video/xilinxfb.c
--- a/drivers/video/xilinxfb.c~xilinxfb-dont-bail-if-the-xilinxfb-platform-device-doesnt-have-any-pdata
+++ a/drivers/video/xilinxfb.c
@@ -212,11 +212,6 @@ xilinxfb_drv_probe(struct device *dev)
 	pdev = to_platform_device(dev);
 	pdata = pdev->dev.platform_data;
 
-	if (pdata == NULL) {
-		printk(KERN_ERR "Couldn't find platform data.\n");
-		return -EFAULT;
-	}
-
 	drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
 	if (!drvdata) {
 		printk(KERN_ERR "Couldn't allocate device private record\n");
@@ -258,11 +253,9 @@ xilinxfb_drv_probe(struct device *dev)
 	xilinx_fb_out_be32(drvdata, REG_FB_ADDR, drvdata->fb_phys);
 
 	/* Turn on the display */
-	if (pdata->rotate_screen) {
-		drvdata->reg_ctrl_default = REG_CTRL_ENABLE | REG_CTRL_ROTATE;
-	} else {
-		drvdata->reg_ctrl_default = REG_CTRL_ENABLE;
-	}
+	drvdata->reg_ctrl_default = REG_CTRL_ENABLE;
+	if (pdata && pdata->rotate_screen)
+		drvdata->reg_ctrl_default |= REG_CTRL_ROTATE;
 	xilinx_fb_out_be32(drvdata, REG_CTRL, drvdata->reg_ctrl_default);
 
 	/* Fill struct fb_info */
@@ -281,8 +274,10 @@ xilinxfb_drv_probe(struct device *dev)
 	}
 
 	drvdata->info.flags = FBINFO_DEFAULT;
-	xilinx_fb_var.height = pdata->screen_height_mm;
-	xilinx_fb_var.width = pdata->screen_width_mm;
+	if (pdata) {
+		xilinx_fb_var.height = pdata->screen_height_mm;
+		xilinx_fb_var.width = pdata->screen_width_mm;
+	}
 	drvdata->info.var = xilinx_fb_var;
 
 	/* Register new frame buffer */
_

Patches currently in -mm which might be from grant.likely@secretlab.ca are

origin.patch
