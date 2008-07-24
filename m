From: akpm@linux-foundation.org
Subject: - hgafb-convert-to-new-platform-driver-api-bugzilla-9689.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:32:21 -0700
Message-ID: <200807242332.m6ONWLoD011827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756806AbYGXXdA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:33:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, avorontsov@ru.mvista.com, mm-commits@vger.kernel.org


The patch titled
     hgafb: convert to new platform driver API
has been removed from the -mm tree.  Its filename was
     hgafb-convert-to-new-platform-driver-api-bugzilla-9689.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hgafb: convert to new platform driver API
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Convert the hgafb driver to use new platform driver API.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=9689

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/hgafb.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff -puN drivers/video/hgafb.c~hgafb-convert-to-new-platform-driver-api-bugzilla-9689 drivers/video/hgafb.c
--- a/drivers/video/hgafb.c~hgafb-convert-to-new-platform-driver-api-bugzilla-9689
+++ a/drivers/video/hgafb.c
@@ -551,7 +551,7 @@ static struct fb_ops hgafb_ops = {
 	 *  Initialization
 	 */
 
-static int __init hgafb_probe(struct device *device)
+static int __init hgafb_probe(struct platform_device *pdev)
 {
 	struct fb_info *info;
 
@@ -565,7 +565,7 @@ static int __init hgafb_probe(struct dev
 	printk(KERN_INFO "hgafb: %s with %ldK of memory detected.\n",
 		hga_type_name, hga_vram_len/1024);
 
-	info = framebuffer_alloc(0, NULL);
+	info = framebuffer_alloc(0, &pdev->dev);
 	if (!info) {
 		iounmap(hga_vram);
 		return -ENOMEM;
@@ -593,13 +593,13 @@ static int __init hgafb_probe(struct dev
 
         printk(KERN_INFO "fb%d: %s frame buffer device\n",
                info->node, info->fix.id);
-	dev_set_drvdata(device, info);
+	platform_set_drvdata(pdev, info);
 	return 0;
 }
 
-static int hgafb_remove(struct device *device)
+static int hgafb_remove(struct platform_device *pdev)
 {
-	struct fb_info *info = dev_get_drvdata(device);
+	struct fb_info *info = platform_get_drvdata(pdev);
 
 	hga_txt_mode();
 	hga_clear_screen();
@@ -620,16 +620,15 @@ static int hgafb_remove(struct device *d
 	return 0;
 }
 
-static struct device_driver hgafb_driver = {
-	.name = "hgafb",
-	.bus  = &platform_bus_type,
+static struct platform_driver hgafb_driver = {
 	.probe = hgafb_probe,
 	.remove = hgafb_remove,
+	.driver = {
+		.name = "hgafb",
+	},
 };
 
-static struct platform_device hgafb_device = {
-	.name = "hgafb",
-};
+static struct platform_device *hgafb_device;
 
 static int __init hgafb_init(void)
 {
@@ -638,12 +637,15 @@ static int __init hgafb_init(void)
 	if (fb_get_options("hgafb", NULL))
 		return -ENODEV;
 
-	ret = driver_register(&hgafb_driver);
+	ret = platform_driver_register(&hgafb_driver);
 
 	if (!ret) {
-		ret = platform_device_register(&hgafb_device);
-		if (ret)
-			driver_unregister(&hgafb_driver);
+		hgafb_device = platform_device_register_simple("hgafb", 0, NULL, 0);
+
+		if (IS_ERR(hgafb_device)) {
+			platform_driver_unregister(&hgafb_driver);
+			ret = PTR_ERR(hgafb_device);
+		}
 	}
 
 	return ret;
@@ -651,8 +653,8 @@ static int __init hgafb_init(void)
 
 static void __exit hgafb_exit(void)
 {
-	platform_device_unregister(&hgafb_device);
-	driver_unregister(&hgafb_driver);
+	platform_device_unregister(hgafb_device);
+	platform_driver_unregister(&hgafb_driver);
 }
 
 /* -------------------------------------------------------------------------
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

