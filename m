From: akpm@linux-foundation.org
Subject: + skeletonfb-various-corrections.patch added to -mm tree
Date: Mon, 09 Apr 2007 16:35:09 -0700
Message-ID: <200704092335.l39NZ9jM026444@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35860 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbXDIXfN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 19:35:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     skeletonfb: various corrections
has been added to the -mm tree.  Its filename is
     skeletonfb-various-corrections.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: skeletonfb: various corrections
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This is mainly correction of types, typos and missing characters in the
skeletonfb.c file found while trying to prepare a new fb driver.

[adaplas]
Additions on power management and fixes as per akpm

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/skeletonfb.c |  195 +++++++++++++++++++++++++----------
 1 files changed, 142 insertions(+), 53 deletions(-)

diff -puN drivers/video/skeletonfb.c~skeletonfb-various-corrections drivers/video/skeletonfb.c
--- a/drivers/video/skeletonfb.c~skeletonfb-various-corrections
+++ a/drivers/video/skeletonfb.c
@@ -51,6 +51,7 @@
 #include <linux/delay.h>
 #include <linux/fb.h>
 #include <linux/init.h>
+#include <linux/pci.h>
 
     /*
      *  This is just simple sample code.
@@ -60,6 +61,11 @@
      */
 
 /*
+ * Driver data
+ */
+static char *mode_option __devinitdata;
+
+/*
  *  If your driver supports multiple boards, you should make the  
  *  below data types arrays, or allocate them dynamically (using kmalloc()). 
  */ 
@@ -278,7 +284,7 @@ static int xxxfb_set_par(struct fb_info 
  */
 static int xxxfb_setcolreg(unsigned regno, unsigned red, unsigned green,
 			   unsigned blue, unsigned transp,
-			   const struct fb_info *info)
+			   struct fb_info *info)
 {
     if (regno >= 256)  /* no. of hw registers */
        return -EINVAL;
@@ -416,7 +422,7 @@ static int xxxfb_setcolreg(unsigned regn
  *      Returns negative errno on error, or zero on success.
  */
 static int xxxfb_pan_display(struct fb_var_screeninfo *var,
-			     const struct fb_info *info)
+			     struct fb_info *info)
 {
     /*
      * If your hardware does not support panning, _do_ _not_ implement this
@@ -454,7 +460,7 @@ static int xxxfb_pan_display(struct fb_v
  *      Return !0 for any modes that are unimplemented.
  *
  */
-static int xxxfb_blank(int blank_mode, const struct fb_info *info)
+static int xxxfb_blank(int blank_mode, struct fb_info *info)
 {
     /* ... */
     return 0;
@@ -483,7 +489,7 @@ static int xxxfb_blank(int blank_mode, c
  *	depending on the rastering operation with the value of color which
  *	is in the current color depth format.
  */
-void xxfb_fillrect(struct fb_info *p, const struct fb_fillrect *region)
+void xxxfb_fillrect(struct fb_info *p, const struct fb_fillrect *region)
 {
 /*	Meaning of struct fb_fillrect
  *
@@ -647,21 +653,50 @@ void xxxfb_poll(struct fb_info *info, po
  *      If the driver has implemented its own hardware-based drawing function,
  *      implementing this function is highly recommended.
  */
-void xxxfb_sync(struct fb_info *info)
+int xxxfb_sync(struct fb_info *info)
 {
+	return 0;
 }
 
     /*
+     *  Frame buffer operations
+     */
+
+static struct fb_ops xxxfb_ops = {
+	.owner		= THIS_MODULE,
+	.fb_open	= xxxfb_open,
+	.fb_read	= xxxfb_read,
+	.fb_write	= xxxfb_write,
+	.fb_release	= xxxfb_release,
+	.fb_check_var	= xxxfb_check_var,
+	.fb_set_par	= xxxfb_set_par,
+	.fb_setcolreg	= xxxfb_setcolreg,
+	.fb_blank	= xxxfb_blank,
+	.fb_pan_display	= xxxfb_pan_display,
+	.fb_fillrect	= xxxfb_fillrect, 	/* Needed !!! */
+	.fb_copyarea	= xxxfb_copyarea,	/* Needed !!! */
+	.fb_imageblit	= xxxfb_imageblit,	/* Needed !!! */
+	.fb_cursor	= xxxfb_cursor,		/* Optional !!! */
+	.fb_rotate	= xxxfb_rotate,
+	.fb_poll	= xxxfb_poll,
+	.fb_sync	= xxxfb_sync,
+	.fb_ioctl	= xxxfb_ioctl,
+	.fb_mmap	= xxxfb_mmap,
+};
+
+/* ------------------------------------------------------------------------- */
+
+    /*
      *  Initialization
      */
 
 /* static int __init xxfb_probe (struct device *device) -- for platform devs */
-static int __init xxxfb_probe(struct pci_dev *dev,
+static int __devinit xxxfb_probe(struct pci_dev *dev,
 			      const_struct pci_device_id *ent)
 {
     struct fb_info *info;
     struct xxx_par *par;
-    struct device = &dev->dev; /* for pci drivers */
+    struct device* device = &dev->dev; /* for pci drivers */
     int cmap_len, retval;	
    
     /*
@@ -760,7 +795,7 @@ static int __init xxxfb_probe(struct pci
      *
      * NOTE: This field is currently unused.
      */
-    info->pixmap.scan_align = 32
+    info->pixmap.scan_align = 32;
 /***************************** End optional stage ***************************/
 
     /*
@@ -770,13 +805,13 @@ static int __init xxxfb_probe(struct pci
     if (!mode_option)
 	mode_option = "640x480@60";	 	
 
-    retval = fb_find_mode(info->var, info, mode_option, NULL, 0, NULL, 8);
+    retval = fb_find_mode(&info->var, info, mode_option, NULL, 0, NULL, 8);
   
     if (!retval || retval == 4)
 	return -EINVAL;			
 
     /* This has to been done !!! */	
-    fb_alloc_cmap(info->cmap, cmap_len, 0);
+    fb_alloc_cmap(&info->cmap, cmap_len, 0);
 	
     /* 
      * The following is done in the case of having hardware with a static 
@@ -811,15 +846,15 @@ static int __init xxxfb_probe(struct pci
     /*
      *  Cleanup
      */
-/* static void __exit xxxfb_remove(struct device *device) */
-static void __exit xxxfb_remove(struct pci_dev *dev)
+/* static void __devexit xxxfb_remove(struct device *device) */
+static void __devexit xxxfb_remove(struct pci_dev *dev)
 {
-	struct fb_info *info = pci_get_drv_data(dev);
-	/* or dev_get_drv_data(device); */
+	struct fb_info *info = pci_get_drvdata(dev);
+	/* or dev_get_drvdata(device); */
 
 	if (info) {
 		unregister_framebuffer(info);
-		fb_dealloc_cmap(&info.cmap);
+		fb_dealloc_cmap(&info->cmap);
 		/* ... */
 		framebuffer_release(info);
 	}
@@ -827,18 +862,61 @@ static void __exit xxxfb_remove(struct p
 	return 0;
 }
 
-#if CONFIG_PCI
+#ifdef CONFIG_PCI
+#ifdef CONFIG_PM
+/**
+ *	xxxfb_suspend - Optional but recommended function. Suspend the device.
+ *	@dev: PCI device
+ *	@msg: the suspend event code.
+ *
+ *      See Documentation/power/devices.txt for more information
+ */
+static int xxxfb_suspend(struct pci_dev *dev, pm_message_t msg)
+{
+	struct fb_info *info = pci_get_drvdata(dev);
+	struct xxxfb_par *par = info->par;
+
+	/* suspend here */
+	return 0;
+}
+
+/**
+ *	xxxfb_resume - Optional but recommended function. Resume the device.
+ *	@dev: PCI device
+ *
+ *      See Documentation/power/devices.txt for more information
+ */
+static int xxxfb_resume(struct pci_dev *dev)
+{
+	struct fb_info *info = pci_get_drvdata(dev);
+	struct xxxfb_par *par = info->par;
+
+	/* resume here */
+	return 0;
+}
+#else
+#define xxxfb_suspend NULL
+#define xxxfb_resume NULL
+#endif /* CONFIG_PM */
+
+static struct pci_device_id xxxfb_id_table[] = {
+	{ PCI_VENDOR_ID_XXX, PCI_DEVICE_ID_XXX,
+	  PCI_ANY_ID, PCI_ANY_ID, PCI_BASE_CLASS_DISPLAY << 16,
+	  ADDR, 0 },
+	{ 0, }
+};
+
 /* For PCI drivers */
 static struct pci_driver xxxfb_driver = {
 	.name =		"xxxfb",
-	.id_table =	xxxfb_devices,
+	.id_table =	xxxfb_id_table,
 	.probe =	xxxfb_probe,
 	.remove =	__devexit_p(xxxfb_remove),
-	.suspend =      xxxfb_suspend, /* optional */
-	.resume =       xxxfb_resume,  /* optional */
+	.suspend =      xxxfb_suspend, /* optional but recommended */
+	.resume =       xxxfb_resume,  /* optional but recommended */
 };
 
-static int __init xxxfb_init(void)
+int __init xxxfb_init(void)
 {
 	/*
 	 *  For kernel boot options (in 'video=xxxfb:<options>' format)
@@ -858,16 +936,53 @@ static void __exit xxxfb_exit(void)
 {
 	pci_unregister_driver(&xxxfb_driver);
 }
-#else
+#else /* non PCI, platform drivers */
 #include <linux/platform_device.h>
 /* for platform devices */
+
+#ifdef CONFIG_PM
+/**
+ *	xxxfb_suspend - Optional but recommended function. Suspend the device.
+ *	@dev: platform device
+ *	@msg: the suspend event code.
+ *
+ *      See Documentation/power/devices.txt for more information
+ */
+static int xxxfb_suspend(struct platform_device *dev, pm_message_t msg)
+{
+	struct fb_info *info = platform_get_drvdata(dev);
+	struct xxxfb_par *par = info->par;
+
+	/* suspend here */
+	return 0;
+}
+
+/**
+ *	xxxfb_resume - Optional but recommended function. Resume the device.
+ *	@dev: PCI device
+ *
+ *      See Documentation/power/devices.txt for more information
+ */
+static int xxxfb_suspend(struct platform_dev *dev)
+{
+	struct fb_info *info = platform_get_drvdata(dev);
+	struct xxxfb_par *par = info->par;
+
+	/* resume here */
+	return 0;
+}
+#else
+#define xxxfb_suspend NULL
+#define xxxfb_resume NULL
+#endif /* CONFIG_PM */
+
 static struct device_driver xxxfb_driver = {
 	.name = "xxxfb",
 	.bus  = &platform_bus_type,
 	.probe = xxxfb_probe,
 	.remove = xxxfb_remove,
-	.suspend = xxxfb_suspend, /* optional */
-	.resume = xxxfb_resume,   /* optional */
+	.suspend = xxxfb_suspend, /* optional but recommended */
+	.resume = xxxfb_resume,   /* optional but recommended */
 };
 
 static struct platform_device xxxfb_device = {
@@ -903,8 +1018,9 @@ static void __exit xxxfb_exit(void)
 	platform_device_unregister(&xxxfb_device);
 	driver_unregister(&xxxfb_driver);
 }
-#endif
+#endif /* CONFIG_PCI */
 
+#ifdef MODULE
     /*
      *  Setup
      */
@@ -917,34 +1033,7 @@ int __init xxxfb_setup(char *options)
 {
     /* Parse user speficied options (`video=xxxfb:') */
 }
-
-/* ------------------------------------------------------------------------- */
-
-    /*
-     *  Frame buffer operations
-     */
-
-static struct fb_ops xxxfb_ops = {
-	.owner		= THIS_MODULE,
-	.fb_open	= xxxfb_open,
-	.fb_read	= xxxfb_read,
-	.fb_write	= xxxfb_write,
-	.fb_release	= xxxfb_release,
-	.fb_check_var	= xxxfb_check_var,
-	.fb_set_par	= xxxfb_set_par,	
-	.fb_setcolreg	= xxxfb_setcolreg,
-	.fb_blank	= xxxfb_blank,
-	.fb_pan_display	= xxxfb_pan_display,	
-	.fb_fillrect	= xxxfb_fillrect, 	/* Needed !!! */ 
-	.fb_copyarea	= xxxfb_copyarea,	/* Needed !!! */ 
-	.fb_imageblit	= xxxfb_imageblit,	/* Needed !!! */
-	.fb_cursor	= xxxfb_cursor,		/* Optional !!! */
-	.fb_rotate	= xxxfb_rotate,
-	.fb_poll	= xxxfb_poll,
-	.fb_sync	= xxxfb_sync,
-	.fb_ioctl	= xxxfb_ioctl,
-	.fb_mmap	= xxxfb_mmap,	
-};
+#endif /* MODULE *?
 
 /* ------------------------------------------------------------------------- */
 
@@ -954,6 +1043,6 @@ static struct fb_ops xxxfb_ops = {
      */
 
 module_init(xxxfb_init);
-module_exit(xxxfb_cleanup);
+module_exit(xxxfb_remove);
 
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

skeletonfb-various-corrections.patch
