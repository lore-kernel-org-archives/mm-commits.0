From: akpm@linux-foundation.org
Subject: - fbdev-display-class-update.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:06:27 -0800
Message-ID: <200703060206.l2626RSH008897@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46868 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965722AbXCFCGn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:06:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsimmons@infradead.org, adaplas@pol.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     display class update
has been removed from the -mm tree.  Its filename was
     fbdev-display-class-update.patch

This patch was dropped because it was folded into fbdev-display-class.patch

------------------------------------------------------
Subject: display class update
From: James Simmons <jsimmons@infradead.org>

Signed-off-by: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/display/display-sysfs.c |   94 +++++++++++++-----------
 1 file changed, 54 insertions(+), 40 deletions(-)

diff -puN drivers/video/display/display-sysfs.c~fbdev-display-class-update drivers/video/display/display-sysfs.c
--- a/drivers/video/display/display-sysfs.c~fbdev-display-class-update
+++ a/drivers/video/display/display-sysfs.c
@@ -23,26 +23,26 @@
  */
 #include <linux/module.h>
 #include <linux/display.h>
-#include <linux/bitmap.h>
-#include <linux/err.h>
 #include <linux/ctype.h>
+#include <linux/idr.h>
+#include <linux/err.h>
 
-static ssize_t display_show_name(struct device *dev, struct device_attribute *attr,
-				char *buf)
+static ssize_t display_show_name(struct device *dev,
+				struct device_attribute *attr, char *buf)
 {
 	struct display_device *dsp = dev_get_drvdata(dev);
 	return snprintf(buf, PAGE_SIZE, "%s\n", dsp->name);
 }
 
-static ssize_t display_show_type(struct device *dev, struct device_attribute *attr,
-				char *buf)
+static ssize_t display_show_type(struct device *dev,
+				struct device_attribute *attr, char *buf)
 {
 	struct display_device *dsp = dev_get_drvdata(dev);
 	return snprintf(buf, PAGE_SIZE, "%s\n", dsp->type);
 }
 
-static ssize_t display_show_contrast(struct device *dev, struct device_attribute *attr,
-				char *buf)
+static ssize_t display_show_contrast(struct device *dev,
+				struct device_attribute *attr, char *buf)
 {
 	struct display_device *dsp = dev_get_drvdata(dev);
 	ssize_t rc = -ENXIO;
@@ -54,8 +54,9 @@ static ssize_t display_show_contrast(str
 	return rc;
 }
 
-static ssize_t display_store_contrast(struct device *dev, struct device_attribute *attr,
-				const char *buf, size_t count)
+static ssize_t display_store_contrast(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
 {
 	struct display_device *dsp = dev_get_drvdata(dev);
 	ssize_t ret = -EINVAL, size;
@@ -81,7 +82,8 @@ static ssize_t display_store_contrast(st
 	return ret;
 }
 
-static ssize_t display_show_max_contrast(struct device *dev, struct device_attribute *attr,
+static ssize_t display_show_max_contrast(struct device *dev,
+					struct device_attribute *attr,
 					char *buf)
 {
 	struct display_device *dsp = dev_get_drvdata(dev);
@@ -123,38 +125,50 @@ static int display_resume(struct device 
 	return 0;
 };
 
+static struct mutex allocated_dsp_lock;
+static DEFINE_IDR(allocated_dsp);
 struct class *display_class;
-EXPORT_SYMBOL(display_class);
-
-#define NUM_OF_DISPLAYS		32
-DECLARE_BITMAP(inuse, NUM_OF_DISPLAYS);
 
 struct display_device *display_device_register(struct display_driver *driver,
 						struct device *parent, void *devdata)
 {
-	int idx = find_first_zero_bit(inuse, NUM_OF_DISPLAYS);
 	struct display_device *new_dev = NULL;
-	struct device *display_device = NULL;
+	int ret = -EINVAL;
 
 	if (unlikely(!driver))
-		return ERR_PTR(-EINVAL);
+		return ERR_PTR(ret);
 
-	display_device = device_create(display_class, parent, 0, "display%d", idx);
-	if (IS_ERR(display_device))
-		return ERR_PTR(-ENOMEM);
+	mutex_lock(&allocated_dsp_lock);
+	ret = idr_pre_get(&allocated_dsp, GFP_KERNEL);
+	mutex_unlock(&allocated_dsp_lock);
+	if (!ret)
+		return ERR_PTR(ret);
 
 	new_dev = kzalloc(sizeof(struct display_device), GFP_KERNEL);
 	if (likely(new_dev) && unlikely(driver->probe(new_dev, devdata))) {
-		dev_set_drvdata(display_device, new_dev);
-		new_dev->dev = display_device;
-		new_dev->parent = parent;
-		new_dev->driver = driver;
-		mutex_init(&new_dev->lock);
-		set_bit(idx, inuse);
-		new_dev->idx = idx;
-	} else
-		device_unregister(display_device);
-	return new_dev;
+		// Reserve the index for this display
+		mutex_lock(&allocated_dsp_lock);
+		ret = idr_get_new(&allocated_dsp, new_dev, &new_dev->idx);
+		mutex_unlock(&allocated_dsp_lock);
+
+		if (!ret) {
+			new_dev->dev = device_create(display_class, parent, 0,
+						"display%d", new_dev->idx);
+			if (!IS_ERR(new_dev->dev)) {
+				dev_set_drvdata(new_dev->dev, new_dev);
+				new_dev->parent = parent;
+				new_dev->driver = driver;
+				mutex_init(&new_dev->lock);
+				return new_dev;
+			}
+			mutex_lock(&allocated_dsp_lock);
+			idr_remove(&allocated_dsp, new_dev->idx);
+			mutex_unlock(&allocated_dsp_lock);
+			ret = -EINVAL;
+		}
+	}
+	kfree(new_dev);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(display_device_register);
 
@@ -162,10 +176,14 @@ void display_device_unregister(struct di
 {
 	if (!ddev)
 		return;
+	// Free device
 	mutex_lock(&ddev->lock);
-	device_unregister(ddev->parent);
-	clear_bit(ddev->idx, inuse);
+	device_unregister(ddev->dev);
 	mutex_unlock(&ddev->lock);
+	// Mark device index as avaliable
+	mutex_lock(&allocated_dsp_lock);
+	idr_remove(&allocated_dsp, ddev->idx);
+	mutex_unlock(&allocated_dsp_lock);
 	kfree(ddev);
 }
 EXPORT_SYMBOL(display_device_unregister);
@@ -181,21 +199,17 @@ static int __init display_class_init(voi
 	display_class->dev_attrs = display_attrs;
 	display_class->suspend = display_suspend;
 	display_class->resume = display_resume;
-	bitmap_zero(inuse, NUM_OF_DISPLAYS);
+	mutex_init(&allocated_dsp_lock);
 	return 0;
 }
 
-#ifdef MODULE
-module_init(display_class_init);
-
 static void __exit display_class_exit(void)
 {
 	class_destroy(display_class);
 }
+
+module_init(display_class_init);
 module_exit(display_class_exit);
-#else
-subsys_initcall(display_class_init);
-#endif
 
 MODULE_DESCRIPTION("Display Hardware handling");
 MODULE_AUTHOR("James Simmons <jsimmons@infradead.org>");
_

Patches currently in -mm which might be from jsimmons@infradead.org are

nvidiafb-backlight-fix-implicit-declaration-in-nv_backlight.patch
atyfb-fix-kconfig-error-part-2.patch
fbdev-fix-kconfig-error-if-fb_ddc=n.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch
aty128fb-fix-blanking.patch
change-rivafb_remove-to-__devexit.patch
fbdev-display-class.patch
fbdev-display-class-update.patch
fbdev-add-ultrasharp-uxga-to-broken-monitor-database-fix.patch
tgafb-turbochannel-support.patch
tgafb-accelerated-code.patch
