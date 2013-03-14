From: akpm@linux-foundation.org
Subject: [to-be-updated] drivers-video-mxsfbc-convert-to-devm_ioremap_resource.patch removed from -mm tree
Date: Thu, 14 Mar 2013 16:07:49 -0700
Message-ID: <20130314230749.91FBD31C0AC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:45927 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3CNXHu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 19:07:50 -0400
Received: by mail-ve0-f201.google.com with SMTP id 14so285234vea.2
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 16:07:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabio.estevam@freescale.com, FlorianSchandinat@gmx.de, shawn.guo@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/mxsfb.c: convert to devm_ioremap_resource()
has been removed from the -mm tree.  Its filename was
     drivers-video-mxsfbc-convert-to-devm_ioremap_resource.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Fabio Estevam <fabio.estevam@freescale.com>
Subject: drivers/video/mxsfb.c: convert to devm_ioremap_resource()

Converting to devm_ioremap_resource() can make the code cleaner and smaller.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mxsfb.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff -puN drivers/video/mxsfb.c~drivers-video-mxsfbc-convert-to-devm_ioremap_resource drivers/video/mxsfb.c
--- a/drivers/video/mxsfb.c~drivers-video-mxsfbc-convert-to-devm_ioremap_resource
+++ a/drivers/video/mxsfb.c
@@ -801,22 +801,17 @@ static int mxsfb_probe(struct platform_d
 		return -ENODEV;
 	}
 
-	if (!request_mem_region(res->start, resource_size(res), pdev->name))
-		return -EBUSY;
-
 	fb_info = framebuffer_alloc(sizeof(struct mxsfb_info), &pdev->dev);
 	if (!fb_info) {
 		dev_err(&pdev->dev, "Failed to allocate fbdev\n");
-		ret = -ENOMEM;
-		goto error_alloc_info;
+		return -ENOMEM;
 	}
 
 	host = to_imxfb_host(fb_info);
 
-	host->base = ioremap(res->start, resource_size(res));
-	if (!host->base) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -ENOMEM;
+	host->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(host->base)) {
+		return PTR_ERR(host->base);
 		goto error_ioremap;
 	}
 
@@ -904,11 +899,8 @@ error_panel_enable:
 	clk_put(host->clk);
 error_getclock:
 error_getpin:
-	iounmap(host->base);
 error_ioremap:
 	framebuffer_release(fb_info);
-error_alloc_info:
-	release_mem_region(res->start, resource_size(res));
 
 	return ret;
 }
@@ -917,7 +909,6 @@ static int mxsfb_remove(struct platform_
 {
 	struct fb_info *fb_info = platform_get_drvdata(pdev);
 	struct mxsfb_info *host = to_imxfb_host(fb_info);
-	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	if (host->enabled)
 		mxsfb_disable_controller(fb_info);
@@ -925,11 +916,9 @@ static int mxsfb_remove(struct platform_
 	unregister_framebuffer(fb_info);
 	kfree(fb_info->pseudo_palette);
 	mxsfb_free_videomem(host);
-	iounmap(host->base);
 	clk_put(host->clk);
 
 	framebuffer_release(fb_info);
-	release_mem_region(res->start, resource_size(res));
 
 	platform_set_drvdata(pdev, NULL);
 
_

Patches currently in -mm which might be from fabio.estevam@freescale.com are

origin.patch
linux-next.patch

