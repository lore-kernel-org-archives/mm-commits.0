From: akpm@linux-foundation.org
Subject: + hgafb-convert-to-new-platform-driver-api-bugzilla-9689.patch added to -mm tree
Date: Tue, 03 Jun 2008 17:07:16 -0700
Message-ID: <200806040007.m5407GCM026838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936AbYFDAJR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 20:09:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net, avorontsov@ru.mvista.com


The patch titled
     hgafb: convert to new platform driver API
has been added to the -mm tree.  Its filename is
     hgafb-convert-to-new-platform-driver-api-bugzilla-9689.patch

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
@@ -547,7 +547,7 @@ static struct fb_ops hgafb_ops = {
 	 *  Initialization
 	 */
 
-static int __init hgafb_probe(struct device *device)
+static int __init hgafb_probe(struct platform_device *pdev)
 {
 	struct fb_info *info;
 
@@ -561,7 +561,7 @@ static int __init hgafb_probe(struct dev
 	printk(KERN_INFO "hgafb: %s with %ldK of memory detected.\n",
 		hga_type_name, hga_vram_len/1024);
 
-	info = framebuffer_alloc(0, NULL);
+	info = framebuffer_alloc(0, &pdev->dev);
 	if (!info) {
 		iounmap(hga_vram);
 		return -ENOMEM;
@@ -589,13 +589,13 @@ static int __init hgafb_probe(struct dev
 
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
@@ -616,16 +616,15 @@ static int hgafb_remove(struct device *d
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
@@ -634,12 +633,15 @@ static int __init hgafb_init(void)
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
@@ -647,8 +649,8 @@ static int __init hgafb_init(void)
 
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

