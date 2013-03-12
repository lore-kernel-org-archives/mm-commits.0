From: akpm@linux-foundation.org
Subject: + drivers-video-mxsfbc-convert-to-devm_ioremap_resource.patch added to -mm tree
Date: Tue, 12 Mar 2013 13:53:31 -0700
Message-ID: <20130312205331.7161731C214@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:62124 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab3CLUxc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 16:53:32 -0400
Received: by mail-yh0-f74.google.com with SMTP id z6so35218yhz.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 13:53:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fabio.estevam@freescale.com, FlorianSchandinat@gmx.de, shawn.guo@linaro.org


The patch titled
     Subject: drivers/video/mxsfb.c: convert to devm_ioremap_resource()
has been added to the -mm tree.  Its filename is
     drivers-video-mxsfbc-convert-to-devm_ioremap_resource.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
drivers-video-mxsfbc-convert-to-devm_ioremap_resource.patch

