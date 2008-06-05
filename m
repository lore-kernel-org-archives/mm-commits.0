From: akpm@linux-foundation.org
Subject: + skeletonfb-update-to-correct-platform-driver-usage.patch added to -mm tree
Date: Thu, 05 Jun 2008 15:06:43 -0700
Message-ID: <200806052206.m55M6hZh032060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751909AbYFEWHQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 18:07:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     skeletonfb: update to correct platform driver usage
has been added to the -mm tree.  Its filename is
     skeletonfb-update-to-correct-platform-driver-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

modedb-fix-incorrect-sync-and-vmode-flags-for-cvt-modes.patch
fbcon-fix-wrong-vmode-bits-copied-on-console-switch.patch
tridentfb-replace-macros-with-functions.patch
tridentfb-convert-fb_info-into-allocated-one.patch
tridentfb-move-global-pseudo-palette-into-structure.patch
tridentfb-move-global-chip_id-into-structure.patch
tridentfb-move-global-flat-panel-variable-into-structure.patch
tridentfb-convert-is_blade-and-is_xp-macros-into-functions.patch
tridentfb-move-global-acceleration-hooks-into-structure.patch
tridentfb-make-use-of-functions-and-constants-from-the-vgah.patch
tridentfb-fix-timing-calculations.patch
tridentfb-use-mmio-access-for-clock-setting.patch
tridentfb-fix-clock-settings-for-older-trident-96xx-chips.patch
tridentfb-improve-probe-function.patch
tridentfb-improved-register-values-on-tgui-9680.patch
tridentfb-add-tgui-9440-support.patch
tridentfb-fix-unitialized-pseudo_palette.patch
tridentfb-improve-check_var-function.patch
tridentfb-preserve-memory-type-settings.patch
tridentfb-fix-hi-color-modes-for-tgui-9440.patch
tridentfb-add-acceleration-for-tgui-families.patch
tridentfb-acceleration-code-improvements.patch
tridentfb-acceleration-bug-fixes.patch
tridentfb-various-pixclock-and-timing-improvements.patch
tridentfb-acceleration-constants-change.patch
tridentfb-source-code-improvements.patch
tridentfb-fix-console-freeze-when-switching-from-x11.patch
tridentfb-fix-224-color-logo-at-8-bpp.patch
tridentfb-y-panning-fixes.patch
tridentfb-blade3d-clock-fixes.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
fbcon-make-logo_height-a-local-variable.patch
uvesafb-change-mode-parameter-to-mode_option.patch
tridentfb-documentation-update.patch
tdfxfb-add-mode_option-module-parameter.patch
vga16fb-source-code-improvement.patch
tdfxfb-remove-ypan-checks-done-by-a-higher-layer.patch
vfb-only-enable-if-explicitly-requested-when-compiled-in.patch
hgafb-convert-to-new-platform-driver-api-bugzilla-9689.patch
skeletonfb-update-to-correct-platform-driver-usage.patch

