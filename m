From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-as3711_blc-add-of-support.patch added to -mm tree
Date: Mon, 25 Mar 2013 15:41:00 -0700
Message-ID: <20130325224100.7AF995A4028@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:45008 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570Ab3CYWlC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 18:41:02 -0400
Received: by mail-vb0-f73.google.com with SMTP id fq11so103492vbb.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 15:41:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@gmx.de, broonie@opensource.wolfsonmicro.com, g.liakhovetski+renesas@gmail.com, horms@verge.net.au, jg1.han@samsung.com, magnus.damm@gmail.com, sameo@linux.intel.com


The patch titled
     Subject: drivers/video/backlight/as3711_bl.c: add OF support
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-as3711_blc-add-of-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: drivers/video/backlight/as3711_bl.c: add OF support

Add support for configuring AS3711 backlight driver from DT.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/as3711_bl.c |  118 +++++++++++++++++++++++++-
 1 file changed, 117 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/as3711_bl.c~drivers-video-backlight-as3711_blc-add-of-support drivers/video/backlight/as3711_bl.c
--- a/drivers/video/backlight/as3711_bl.c~drivers-video-backlight-as3711_blc-add-of-support
+++ a/drivers/video/backlight/as3711_bl.c
@@ -258,6 +258,109 @@ static int as3711_bl_register(struct pla
 	return 0;
 }
 
+static int as3711_backlight_parse_dt(struct device *dev)
+{
+	struct as3711_bl_pdata *pdata = dev_get_platdata(dev);
+	struct device_node *bl =
+		of_find_node_by_name(dev->parent->of_node, "backlight"), *fb;
+	int ret;
+
+	if (!bl) {
+		dev_dbg(dev, "backlight node not found\n");
+		return -ENODEV;
+	}
+
+	fb = of_parse_phandle(bl, "su1-dev", 0);
+	if (fb) {
+		pdata->su1_fb = fb->full_name;
+
+		ret = of_property_read_u32(bl, "su1-max-uA", &pdata->su1_max_uA);
+		if (pdata->su1_max_uA <= 0)
+			ret = -EINVAL;
+		if (ret < 0)
+			return ret;
+	}
+
+	fb = of_parse_phandle(bl, "su2-dev", 0);
+	if (fb) {
+		int count = 0;
+
+		pdata->su2_fb = fb->full_name;
+
+		ret = of_property_read_u32(bl, "su2-max-uA", &pdata->su2_max_uA);
+		if (pdata->su2_max_uA <= 0)
+			ret = -EINVAL;
+		if (ret < 0)
+			return ret;
+
+		if (of_find_property(bl, "su2-feedback-voltage", NULL)) {
+			pdata->su2_feedback = AS3711_SU2_VOLTAGE;
+			count++;
+		}
+		if (of_find_property(bl, "su2-feedback-curr1", NULL)) {
+			pdata->su2_feedback = AS3711_SU2_CURR1;
+			count++;
+		}
+		if (of_find_property(bl, "su2-feedback-curr2", NULL)) {
+			pdata->su2_feedback = AS3711_SU2_CURR2;
+			count++;
+		}
+		if (of_find_property(bl, "su2-feedback-curr3", NULL)) {
+			pdata->su2_feedback = AS3711_SU2_CURR3;
+			count++;
+		}
+		if (of_find_property(bl, "su2-feedback-curr-auto", NULL)) {
+			pdata->su2_feedback = AS3711_SU2_CURR_AUTO;
+			count++;
+		}
+		if (count != 1)
+			return -EINVAL;
+
+		count = 0;
+		if (of_find_property(bl, "su2-fbprot-lx-sd4", NULL)) {
+			pdata->su2_fbprot = AS3711_SU2_LX_SD4;
+			count++;
+		}
+		if (of_find_property(bl, "su2-fbprot-gpio2", NULL)) {
+			pdata->su2_fbprot = AS3711_SU2_GPIO2;
+			count++;
+		}
+		if (of_find_property(bl, "su2-fbprot-gpio3", NULL)) {
+			pdata->su2_fbprot = AS3711_SU2_GPIO3;
+			count++;
+		}
+		if (of_find_property(bl, "su2-fbprot-gpio4", NULL)) {
+			pdata->su2_fbprot = AS3711_SU2_GPIO4;
+			count++;
+		}
+		if (count != 1)
+			return -EINVAL;
+
+		count = 0;
+		if (of_find_property(bl, "su2-auto-curr1", NULL)) {
+			pdata->su2_auto_curr1 = true;
+			count++;
+		}
+		if (of_find_property(bl, "su2-auto-curr2", NULL)) {
+			pdata->su2_auto_curr2 = true;
+			count++;
+		}
+		if (of_find_property(bl, "su2-auto-curr3", NULL)) {
+			pdata->su2_auto_curr3 = true;
+			count++;
+		}
+
+		/*
+		 * At least one su2-auto-curr* must be specified iff
+		 * AS3711_SU2_CURR_AUTO is used
+		 */
+		if (!count ^ (pdata->su2_feedback != AS3711_SU2_CURR_AUTO))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int as3711_backlight_probe(struct platform_device *pdev)
 {
 	struct as3711_bl_pdata *pdata = dev_get_platdata(&pdev->dev);
@@ -267,11 +370,24 @@ static int as3711_backlight_probe(struct
 	unsigned int max_brightness;
 	int ret;
 
-	if (!pdata || (!pdata->su1_fb && !pdata->su2_fb)) {
+	if (!pdata) {
 		dev_err(&pdev->dev, "No platform data, exiting...\n");
 		return -ENODEV;
 	}
 
+	if (pdev->dev.parent->of_node) {
+		ret = as3711_backlight_parse_dt(&pdev->dev);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "DT parsing failed: %d\n", ret);
+			return ret;
+		}
+	}
+
+	if (!pdata->su1_fb && !pdata->su2_fb) {
+		dev_err(&pdev->dev, "No framebuffer specified\n");
+		return -EINVAL;
+	}
+
 	/*
 	 * Due to possible hardware damage I chose to block all modes,
 	 * unsupported on my hardware. Anyone, wishing to use any of those modes
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

linux-next.patch
drivers-video-backlight-as3711_blc-add-of-support.patch

