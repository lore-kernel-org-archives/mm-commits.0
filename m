From: akpm@linux-foundation.org
Subject: - hgafb-fix-module-removal.patch removed from -mm tree
Date: Tue, 03 Jun 2008 17:05:49 -0700
Message-ID: <200806040005.m5405nYM026799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbYFDAHU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 20:07:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, adaplas@pol.net, devzero@web.de, greg@kroah.com, kay.sievers@vrfy.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     hgafb: fix module removal
has been removed from the -mm tree.  Its filename was
     hgafb-fix-module-removal.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hgafb: fix module removal
From: Anton Vorontsov <avorontsov@ru.mvista.com>

We should allocate platform device dynamically, otherwise it can't be removed.

Also, back in time it was acceptable to mix devices and platform_devices,
today this might cause all sort of bugs. Fix that too.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: <devzero@web.de>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/hgafb.c |   41 ++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff -puN drivers/video/hgafb.c~hgafb-fix-module-removal drivers/video/hgafb.c
--- a/drivers/video/hgafb.c~hgafb-fix-module-removal
+++ a/drivers/video/hgafb.c
@@ -547,7 +547,7 @@ static struct fb_ops hgafb_ops = {
 	 *  Initialization
 	 */
 
-static int __init hgafb_probe(struct device *device)
+static int __init hgafb_probe(struct platform_device *pdev)
 {
 	struct fb_info *info;
 
@@ -589,13 +589,13 @@ static int __init hgafb_probe(struct dev
 
         printk(KERN_INFO "fb%d: %s frame buffer device\n",
                info->node, info->fix.id);
-	dev_set_drvdata(device, info);
+	platform_set_drvdata(pdev, info);
 	return 0;
 }
 
-static int hgafb_remove(struct device *device)
+static int __devexit hgafb_remove(struct platform_device *pdev)
 {
-	struct fb_info *info = dev_get_drvdata(device);
+	struct fb_info *info = platform_get_drvdata(pdev);
 
 	hga_txt_mode();
 	hga_clear_screen();
@@ -616,16 +616,15 @@ static int hgafb_remove(struct device *d
 	return 0;
 }
 
-static struct device_driver hgafb_driver = {
-	.name = "hgafb",
-	.bus  = &platform_bus_type,
+static struct platform_driver hgafb_driver = {
+	.driver = {
+		.name = "hgafb",
+	},
 	.probe = hgafb_probe,
-	.remove = hgafb_remove,
+	.remove = __devexit_p(hgafb_remove),
 };
 
-static struct platform_device hgafb_device = {
-	.name = "hgafb",
-};
+static struct platform_device *hgafb_device;
 
 static int __init hgafb_init(void)
 {
@@ -634,21 +633,23 @@ static int __init hgafb_init(void)
 	if (fb_get_options("hgafb", NULL))
 		return -ENODEV;
 
-	ret = driver_register(&hgafb_driver);
-
-	if (!ret) {
-		ret = platform_device_register(&hgafb_device);
-		if (ret)
-			driver_unregister(&hgafb_driver);
+	ret = platform_driver_register(&hgafb_driver);
+	if (ret)
+		return ret;
+
+	hgafb_device = platform_device_register_simple("hgafb", -1, NULL, 0);
+	if (!hgafb_device) {
+		platform_driver_unregister(&hgafb_driver);
+		return -ENOMEM;
 	}
 
-	return ret;
+	return 0;
 }
 
 static void __exit hgafb_exit(void)
 {
-	platform_device_unregister(&hgafb_device);
-	driver_unregister(&hgafb_driver);
+	platform_device_unregister(hgafb_device);
+	platform_driver_unregister(&hgafb_driver);
 }
 
 /* -------------------------------------------------------------------------
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
serial-fix-driver_name-conflicts.patch
linux-next.patch
git-leds.patch
mpc83xx_wdt-convert-to-the-of-platform-driver.patch
mpc83xx_wdt-add-support-for-mpc86xx-cpus.patch
mpc83xx_wdt-rename-to-mpc8xxx_wdt.patch
mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g.patch
mpc8xxx_wdt-add-support-for-mpc8xx-watchdogs.patch
powerpc-fsl_soc-remove-mpc83xx_wdt-code.patch
powerpc-86xx-mpc8610_hpcd-add-watchdog-node.patch
hgafb-fix-module-removal.patch

