From: akpm@linux-foundation.org
Subject: [merged] davinci-fb-add-framebuffer-blank-operation.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:36:24 -0800
Message-ID: <200912162036.nBGKaOZD013166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935443AbZLPUga (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:36:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chaithrika@ti.com, khilman@deeprootsystems.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     davinci: fb: add framebuffer blank operation
has been removed from the -mm tree.  Its filename was
     davinci-fb-add-framebuffer-blank-operation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: davinci: fb: add framebuffer blank operation
From: Chaithrika U S <chaithrika@ti.com>

Implement frame buffer blank operation feature for DA8xx/OMAP-L1xx driver.

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/da8xx-fb.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff -puN drivers/video/da8xx-fb.c~davinci-fb-add-framebuffer-blank-operation drivers/video/da8xx-fb.c
--- a/drivers/video/da8xx-fb.c~davinci-fb-add-framebuffer-blank-operation
+++ a/drivers/video/da8xx-fb.c
@@ -702,6 +702,35 @@ static int fb_ioctl(struct fb_info *info
 	return 0;
 }
 
+static int cfb_blank(int blank, struct fb_info *info)
+{
+	struct da8xx_fb_par *par = info->par;
+	int ret = 0;
+
+	if (par->blank == blank)
+		return 0;
+
+	par->blank = blank;
+	switch (blank) {
+	case FB_BLANK_UNBLANK:
+		if (par->panel_power_ctrl)
+			par->panel_power_ctrl(1);
+
+		lcd_enable_raster();
+		break;
+	case FB_BLANK_POWERDOWN:
+		if (par->panel_power_ctrl)
+			par->panel_power_ctrl(0);
+
+		lcd_disable_raster();
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
 static struct fb_ops da8xx_fb_ops = {
 	.owner = THIS_MODULE,
 	.fb_check_var = fb_check_var,
@@ -710,6 +739,7 @@ static struct fb_ops da8xx_fb_ops = {
 	.fb_fillrect = cfb_fillrect,
 	.fb_copyarea = cfb_copyarea,
 	.fb_imageblit = cfb_imageblit,
+	.fb_blank = cfb_blank,
 };
 
 static int __init fb_probe(struct platform_device *device)
_

Patches currently in -mm which might be from chaithrika@ti.com are

origin.patch

