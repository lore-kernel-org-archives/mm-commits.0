From: akpm@linux-foundation.org
Subject: + davinci-fb-add-framebuffer-blank-operation.patch added to -mm tree
Date: Tue, 01 Dec 2009 14:00:35 -0800
Message-ID: <200912012200.nB1M0Z7H012876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753319AbZLAWAg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 17:00:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chaithrika@ti.com, khilman@deeprootsystems.com, krzysztof.h1@poczta.fm


The patch titled
     davinci: fb: add framebuffer blank operation
has been added to the -mm tree.  Its filename is
     davinci-fb-add-framebuffer-blank-operation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
linux-next.patch
davinci-mmc-add-cpufreq-support.patch
davinci-fb-calculate-the-clock-divider-from-pixel-clock-info.patch
davinci-fb-add-cpufreq-support.patch
davinci-fb-updates-the-driver-in-preparation-for-addition-of-power-management-features.patch
da850-omap-l138-add-callback-to-control-lcd-panel-power.patch
davinci-fb-add-suspend-resume-suuport-for-da8xx-omap-l1xx-fb-driver.patch
davinci-fb-add-framebuffer-blank-operation.patch

