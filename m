From: akpm@osdl.org
Subject: + tgafb-module-support-fixes.patch added to -mm tree
Date: Wed, 13 Dec 2006 16:16:13 -0800
Message-ID: <200612140016.kBE0GDdB025777@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60825 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbWLNAQd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:16:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, adaplas@pol.net, jsimmons@infradead.org


The patch titled
     tgafb: module support fixes
has been added to the -mm tree.  Its filename is
     tgafb-module-support-fixes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tgafb: module support fixes
From: "Maciej W. Rozycki" <macro@linux-mips.org>

This is a set of clean-ups for the module support in the driver -- __devinit
and __devexit classifiers are now specified correctly, initialization
functions are marked static and a few unnecessary #ifdefs are removed.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/tgafb.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff -puN drivers/video/tgafb.c~tgafb-module-support-fixes drivers/video/tgafb.c
--- a/drivers/video/tgafb.c~tgafb-module-support-fixes
+++ a/drivers/video/tgafb.c
@@ -43,8 +43,9 @@ static void tgafb_imageblit(struct fb_in
 static void tgafb_fillrect(struct fb_info *, const struct fb_fillrect *);
 static void tgafb_copyarea(struct fb_info *, const struct fb_copyarea *);
 
-static int tgafb_pci_register(struct pci_dev *, const struct pci_device_id *);
-static void tgafb_pci_unregister(struct pci_dev *);
+static int __devinit tgafb_pci_register(struct pci_dev *,
+					const struct pci_device_id *);
+static void __devexit tgafb_pci_unregister(struct pci_dev *);
 
 static const char *mode_option = "640x480@60";
 
@@ -1454,7 +1455,7 @@ tgafb_pci_register(struct pci_dev *pdev,
 	return ret;
 }
 
-static void __exit
+static void __devexit
 tgafb_pci_unregister(struct pci_dev *pdev)
 {
 	struct fb_info *info = pci_get_drvdata(pdev);
@@ -1470,16 +1471,14 @@ tgafb_pci_unregister(struct pci_dev *pde
 	framebuffer_release(info);
 }
 
-#ifdef MODULE
-static void __exit
+static void __devexit
 tgafb_exit(void)
 {
 	pci_unregister_driver(&tgafb_driver);
 }
-#endif /* MODULE */
 
 #ifndef MODULE
-int __init
+static int __devinit
 tgafb_setup(char *arg)
 {
 	char *this_opt;
@@ -1501,7 +1500,7 @@ tgafb_setup(char *arg)
 }
 #endif /* !MODULE */
 
-int __init
+static int __devinit
 tgafb_init(void)
 {
 #ifndef MODULE
@@ -1519,10 +1518,7 @@ tgafb_init(void)
  */
 
 module_init(tgafb_init);
-
-#ifdef MODULE
 module_exit(tgafb_exit);
-#endif
 
 MODULE_DESCRIPTION("framebuffer driver for TGA chipset");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
i386-io_apic-fix-a-typo-in-an-irq-handler-name.patch
tgafb-switch-to-framebuffer_alloc.patch
tgafb-fix-copying-overlapping-areas.patch
tgafb-support-the-directcolor-visual.patch
tgafb-fix-the-mode-register-setting.patch
tgafb-module-support-fixes.patch
tgafb-sync-on-green-support-fixes.patch

