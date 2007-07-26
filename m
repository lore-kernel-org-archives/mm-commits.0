From: akpm@linux-foundation.org
Subject: + xilinxfb-dont-bail-if-the-xilinxfb-platform-device-doesnt-have-any-pdata.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:11 -0700
Message-ID: <200707261900.l6QJ0BJK015590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41593 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759638AbXGZTAW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:00:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: grant.likely@secretlab.ca, adaplas@gmail.com, akonovalov@ru.mvista.com


The patch titled
     xilinxfb: Don't bail if the xilinxfb platform device  doesn't have any pdata
has been added to the -mm tree.  Its filename is
     xilinxfb-dont-bail-if-the-xilinxfb-platform-device-doesnt-have-any-pdata.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

xilinxfbremove-__initdata-from-xilinx_fb_fix-and-xilinx_fb_var.patch
xilinxfb-dont-bail-if-the-xilinxfb-platform-device-doesnt-have-any-pdata.patch
