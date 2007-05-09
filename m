From: akpm@linux-foundation.org
Subject: - fbdev-display-class.patch removed from -mm tree
Date: Tue, 08 May 2007 19:59:10 -0700
Message-ID: <200705090259.l492xAWb010366@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970005AbXEIC7T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:59:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsimmons@infradead.org, adaplas@pol.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: display class
has been removed from the -mm tree.  Its filename was
     fbdev-display-class.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: display class
From: James Simmons <jsimmons@infradead.org>

Add the new display class.  This is meant to unite the various solutions to
display units ie acpi output device, auxdisplay and the defunct lcd class
in the backlight directory.

Signed-off-by: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig                 |    1 
 drivers/video/Makefile                |    2 
 drivers/video/display/Kconfig         |   24 ++
 drivers/video/display/Makefile        |    6 
 drivers/video/display/display-sysfs.c |  217 ++++++++++++++++++++++++
 include/linux/display.h               |   61 ++++++
 6 files changed, 310 insertions(+), 1 deletion(-)

diff -puN drivers/video/Kconfig~fbdev-display-class drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-display-class
+++ a/drivers/video/Kconfig
@@ -5,6 +5,7 @@
 menu "Graphics support"
 
 source "drivers/video/backlight/Kconfig"
+source "drivers/video/display/Kconfig"
 
 config FB
 	tristate "Support for frame buffer devices"
diff -puN drivers/video/Makefile~fbdev-display-class drivers/video/Makefile
--- a/drivers/video/Makefile~fbdev-display-class
+++ a/drivers/video/Makefile
@@ -12,7 +12,7 @@ fb-objs                           := $(f
 
 obj-$(CONFIG_VT)		  += console/
 obj-$(CONFIG_LOGO)		  += logo/
-obj-y				  += backlight/
+obj-y				  += backlight/ display/
 
 obj-$(CONFIG_FB_CFB_FILLRECT)  += cfbfillrect.o
 obj-$(CONFIG_FB_CFB_COPYAREA)  += cfbcopyarea.o
diff -puN /dev/null drivers/video/display/Kconfig
--- /dev/null
+++ a/drivers/video/display/Kconfig
@@ -0,0 +1,24 @@
+#
+# Display drivers configuration
+#
+
+menu "Display device support"
+
+config DISPLAY_SUPPORT
+	tristate "Display panel/monitor support"
+	---help---
+	  This framework adds support for low-level control of a display.
+	  This includes support for power.
+
+	  Enable this to be able to choose the drivers for controlling the
+	  physical display panel/monitor on some platforms. This not only
+	  covers LCD displays for PDAs but also other types of displays
+	  such as CRT, TVout etc.
+
+	  To have support for your specific display panel you will have to
+	  select the proper drivers which depend on this option.
+
+comment "Display hardware drivers"
+	depends on DISPLAY_SUPPORT
+
+endmenu
diff -puN /dev/null drivers/video/display/Makefile
--- /dev/null
+++ a/drivers/video/display/Makefile
@@ -0,0 +1,6 @@
+# Display drivers
+
+display-objs				:= display-sysfs.o
+
+obj-$(CONFIG_DISPLAY_SUPPORT)		+= display.o
+
diff -puN /dev/null drivers/video/display/display-sysfs.c
--- /dev/null
+++ a/drivers/video/display/display-sysfs.c
@@ -0,0 +1,217 @@
+/*
+ *  display-sysfs.c - Display output driver sysfs interface
+ *
+ *  Copyright (C) 2007 James Simmons <jsimmons@infradead.org>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or (at
+ *  your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#include <linux/module.h>
+#include <linux/display.h>
+#include <linux/ctype.h>
+#include <linux/idr.h>
+#include <linux/err.h>
+
+static ssize_t display_show_name(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct display_device *dsp = dev_get_drvdata(dev);
+	return snprintf(buf, PAGE_SIZE, "%s\n", dsp->name);
+}
+
+static ssize_t display_show_type(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct display_device *dsp = dev_get_drvdata(dev);
+	return snprintf(buf, PAGE_SIZE, "%s\n", dsp->type);
+}
+
+static ssize_t display_show_contrast(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct display_device *dsp = dev_get_drvdata(dev);
+	ssize_t rc = -ENXIO;
+
+	mutex_lock(&dsp->lock);
+	if (likely(dsp->driver) && dsp->driver->get_contrast)
+		rc = sprintf(buf, "%d\n", dsp->driver->get_contrast(dsp));
+	mutex_unlock(&dsp->lock);
+	return rc;
+}
+
+static ssize_t display_store_contrast(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct display_device *dsp = dev_get_drvdata(dev);
+	ssize_t ret = -EINVAL, size;
+	int contrast;
+	char *endp;
+
+	contrast = simple_strtoul(buf, &endp, 0);
+	size = endp - buf;
+
+	if (*endp && isspace(*endp))
+		size++;
+
+	if (size != count)
+		return ret;
+
+	mutex_lock(&dsp->lock);
+	if (likely(dsp->driver && dsp->driver->set_contrast)) {
+		pr_debug("display: set contrast to %d\n", contrast);
+		dsp->driver->set_contrast(dsp, contrast);
+		ret = count;
+	}
+	mutex_unlock(&dsp->lock);
+	return ret;
+}
+
+static ssize_t display_show_max_contrast(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct display_device *dsp = dev_get_drvdata(dev);
+	ssize_t rc = -ENXIO;
+
+	mutex_lock(&dsp->lock);
+	if (likely(dsp->driver))
+		rc = sprintf(buf, "%d\n", dsp->driver->max_contrast);
+	mutex_unlock(&dsp->lock);
+	return rc;
+}
+
+static struct device_attribute display_attrs[] = {
+	__ATTR(name, S_IRUGO, display_show_name, NULL),
+	__ATTR(type, S_IRUGO, display_show_type, NULL),
+	__ATTR(contrast, S_IRUGO | S_IWUSR, display_show_contrast, display_store_contrast),
+	__ATTR(max_contrast, S_IRUGO, display_show_max_contrast, NULL),
+};
+
+static int display_suspend(struct device *dev, pm_message_t state)
+{
+	struct display_device *dsp = dev_get_drvdata(dev);
+
+	mutex_lock(&dsp->lock);
+	if (likely(dsp->driver->suspend))
+		dsp->driver->suspend(dsp, state);
+	mutex_unlock(&dsp->lock);
+	return 0;
+};
+
+static int display_resume(struct device *dev)
+{
+	struct display_device *dsp = dev_get_drvdata(dev);
+
+	mutex_lock(&dsp->lock);
+	if (likely(dsp->driver->resume))
+		dsp->driver->resume(dsp);
+	mutex_unlock(&dsp->lock);
+	return 0;
+};
+
+static struct mutex allocated_dsp_lock;
+static DEFINE_IDR(allocated_dsp);
+struct class *display_class;
+
+struct display_device *display_device_register(struct display_driver *driver,
+						struct device *parent, void *devdata)
+{
+	struct display_device *new_dev = NULL;
+	int ret = -EINVAL;
+
+	if (unlikely(!driver))
+		return ERR_PTR(ret);
+
+	mutex_lock(&allocated_dsp_lock);
+	ret = idr_pre_get(&allocated_dsp, GFP_KERNEL);
+	mutex_unlock(&allocated_dsp_lock);
+	if (!ret)
+		return ERR_PTR(ret);
+
+	new_dev = kzalloc(sizeof(struct display_device), GFP_KERNEL);
+	if (likely(new_dev) && unlikely(driver->probe(new_dev, devdata))) {
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
+}
+EXPORT_SYMBOL(display_device_register);
+
+void display_device_unregister(struct display_device *ddev)
+{
+	if (!ddev)
+		return;
+	// Free device
+	mutex_lock(&ddev->lock);
+	device_unregister(ddev->dev);
+	mutex_unlock(&ddev->lock);
+	// Mark device index as avaliable
+	mutex_lock(&allocated_dsp_lock);
+	idr_remove(&allocated_dsp, ddev->idx);
+	mutex_unlock(&allocated_dsp_lock);
+	kfree(ddev);
+}
+EXPORT_SYMBOL(display_device_unregister);
+
+static int __init display_class_init(void)
+{
+	display_class = class_create(THIS_MODULE, "display");
+	if (IS_ERR(display_class)) {
+		printk(KERN_ERR "Failed to create display class\n");
+		display_class = NULL;
+		return -EINVAL;
+	}
+	display_class->dev_attrs = display_attrs;
+	display_class->suspend = display_suspend;
+	display_class->resume = display_resume;
+	mutex_init(&allocated_dsp_lock);
+	return 0;
+}
+
+static void __exit display_class_exit(void)
+{
+	class_destroy(display_class);
+}
+
+module_init(display_class_init);
+module_exit(display_class_exit);
+
+MODULE_DESCRIPTION("Display Hardware handling");
+MODULE_AUTHOR("James Simmons <jsimmons@infradead.org>");
+MODULE_LICENSE("GPL");
+
diff -puN /dev/null include/linux/display.h
--- /dev/null
+++ a/include/linux/display.h
@@ -0,0 +1,61 @@
+/*
+ *  Copyright (C) 2006 James Simmons <jsimmons@infradead.org>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or (at
+ *  your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#ifndef _LINUX_DISPLAY_H
+#define _LINUX_DISPLAY_H
+
+#include <linux/device.h>
+
+struct display_device;
+
+/* This structure defines all the properties of a Display. */
+struct display_driver {
+	int  (*set_contrast)(struct display_device *, unsigned int);
+	int  (*get_contrast)(struct display_device *);
+	void (*suspend)(struct display_device *, pm_message_t state);
+	void (*resume)(struct display_device *);
+	int  (*probe)(struct display_device *, void *);
+	int  (*remove)(struct display_device *);
+	int  max_contrast;
+};
+
+struct display_device {
+	struct module *owner;			/* Owner module */
+	struct display_driver *driver;
+	struct device *parent;			/* This is the parent */
+	struct device *dev;			/* This is this display device */
+	struct mutex lock;
+	void *priv_data;
+	char type[16];
+	char *name;
+	int idx;
+};
+
+extern struct display_device *display_device_register(struct display_driver *driver,
+					struct device *dev, void *devdata);
+extern void display_device_unregister(struct display_device *dev);
+
+extern int probe_edid(struct display_device *dev, void *devdata);
+
+#define to_display_device(obj) container_of(obj, struct display_device, class_dev)
+
+#endif
_

Patches currently in -mm which might be from jsimmons@infradead.org are

origin.patch
