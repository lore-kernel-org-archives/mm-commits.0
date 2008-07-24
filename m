From: akpm@linux-foundation.org
Subject: - skeletonfb-update-to-correct-platform-driver-usage.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:32:41 -0700
Message-ID: <200807242332.m6ONWfqo011857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756771AbYGXXcn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:32:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     skeletonfb: update to correct platform driver usage
has been removed from the -mm tree.  Its filename was
     skeletonfb-update-to-correct-platform-driver-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: skeletonfb: update to correct platform driver usage
From: Krzysztof Helt <krzysztof.h1@wp.pl>

It updates skeletonfb to new platform driver API.  The skeletonfb is
templates for creating new drivers.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/skeletonfb.c |   37 ++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff -puN drivers/video/skeletonfb.c~skeletonfb-update-to-correct-platform-driver-usage drivers/video/skeletonfb.c
--- a/drivers/video/skeletonfb.c~skeletonfb-update-to-correct-platform-driver-usage
+++ a/drivers/video/skeletonfb.c
@@ -675,13 +675,13 @@ static struct fb_ops xxxfb_ops = {
      *  Initialization
      */
 
-/* static int __init xxfb_probe (struct device *device) -- for platform devs */
+/* static int __init xxfb_probe (struct platform_device *pdev) -- for platform devs */
 static int __devinit xxxfb_probe(struct pci_dev *dev,
 			      const struct pci_device_id *ent)
 {
     struct fb_info *info;
     struct xxx_par *par;
-    struct device* device = &dev->dev; /* for pci drivers */
+    struct device *device = &dev->dev; /* or &pdev->dev */
     int cmap_len, retval;	
    
     /*
@@ -824,18 +824,18 @@ static int __devinit xxxfb_probe(struct 
 	return -EINVAL;
     printk(KERN_INFO "fb%d: %s frame buffer device\n", info->node,
 	   info->fix.id);
-    pci_set_drvdata(dev, info); /* or dev_set_drvdata(device, info) */
+    pci_set_drvdata(dev, info); /* or platform_set_drvdata(pdev, info) */
     return 0;
 }
 
     /*
      *  Cleanup
      */
-/* static void __devexit xxxfb_remove(struct device *device) */
+/* static void __devexit xxxfb_remove(struct platform_device *pdev) */
 static void __devexit xxxfb_remove(struct pci_dev *dev)
 {
 	struct fb_info *info = pci_get_drvdata(dev);
-	/* or dev_get_drvdata(device); */
+	/* or platform_get_drvdata(pdev); */
 
 	if (info) {
 		unregister_framebuffer(info);
@@ -961,18 +961,17 @@ static int xxxfb_resume(struct platform_
 #define xxxfb_resume NULL
 #endif /* CONFIG_PM */
 
-static struct device_driver xxxfb_driver = {
-	.name = "xxxfb",
-	.bus  = &platform_bus_type,
+static struct platform_device_driver xxxfb_driver = {
 	.probe = xxxfb_probe,
 	.remove = xxxfb_remove,
 	.suspend = xxxfb_suspend, /* optional but recommended */
 	.resume = xxxfb_resume,   /* optional but recommended */
+	.driver = {
+		.name = "xxxfb",
+	},
 };
 
-static struct platform_device xxxfb_device = {
-	.name = "xxxfb",
-};
+static struct platform_device *xxxfb_device;
 
 #ifndef MODULE
     /*
@@ -1002,12 +1001,16 @@ static int __init xxxfb_init(void)
 		return -ENODEV;
 	xxxfb_setup(option);
 #endif
-	ret = driver_register(&xxxfb_driver);
+	ret = platform_driver_register(&xxxfb_driver);
 
 	if (!ret) {
-		ret = platform_device_register(&xxxfb_device);
-		if (ret)
-			driver_unregister(&xxxfb_driver);
+		xxxfb_device = platform_device_register_simple("xxxfb", 0,
+								NULL, 0);
+
+		if (IS_ERR(xxxfb_device)) {
+			platform_driver_unregister(&xxxfb_driver);
+			ret = PTR_ERR(xxxfb_device);
+		}
 	}
 
 	return ret;
@@ -1015,8 +1018,8 @@ static int __init xxxfb_init(void)
 
 static void __exit xxxfb_exit(void)
 {
-	platform_device_unregister(&xxxfb_device);
-	driver_unregister(&xxxfb_driver);
+	platform_device_unregister(xxxfb_device);
+	platform_driver_unregister(&xxxfb_driver);
 }
 #endif /* CONFIG_PCI */
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

