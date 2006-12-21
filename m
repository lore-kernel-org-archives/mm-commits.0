From: akpm@osdl.org
Subject: - video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register.patch removed from -mm tree
Date: Wed, 20 Dec 2006 16:36:24 -0800
Message-ID: <200612210036.kBL0aOZ0011189@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53269 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161099AbWLUAgd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:36:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luming.yu@gmail.com, Luming.yu@intel.com, adaplas@pol.net, greg@kroah.com, len.brown@intel.com, mm-commits@vger.kernel.org


The patch titled
     video sysfs support: Add dev argument for backlight_device_register
has been removed from the -mm tree.  Its filename was
     video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: video sysfs support: Add dev argument for backlight_device_register
From: Yu Luming <luming.yu@gmail.com>

This patch set adds generic abstract layer support for acpi video driver to
have generic user interface to control backlight and output switch control by
leveraging the existing backlight sysfs class driver, and by adding a new
video output sysfs class driver.

This patch:

Add dev argument for backlight_device_register to link the class device to
real device object.  The platform specific driver should find a way to get the
real device object for their video device.

[akpm@osdl.org: build fix]
[akpm@osdl.org: fix msi-laptop.c]
Signed-off-by: Luming Yu <Luming.yu@intel.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/asus_acpi.c            |    2 +-
 drivers/acpi/ibm_acpi.c             |    2 +-
 drivers/acpi/toshiba_acpi.c         |    3 ++-
 drivers/misc/msi-laptop.c           |    3 ++-
 drivers/usb/misc/appledisplay.c     |    2 +-
 drivers/video/backlight/backlight.c |    7 +++++--
 include/linux/backlight.h           |    2 +-
 7 files changed, 13 insertions(+), 8 deletions(-)

diff -puN drivers/acpi/asus_acpi.c~video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register drivers/acpi/asus_acpi.c
--- a/drivers/acpi/asus_acpi.c~video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register
+++ a/drivers/acpi/asus_acpi.c
@@ -1400,7 +1400,7 @@ static int __init asus_acpi_init(void)
 		return result;
 	}
 
-	asus_backlight_device = backlight_device_register("asus", NULL,
+	asus_backlight_device = backlight_device_register("asus",NULL,NULL,
 							  &asus_backlight_data);
         if (IS_ERR(asus_backlight_device)) {
 		printk(KERN_ERR "Could not register asus backlight device\n");
diff -puN drivers/acpi/ibm_acpi.c~video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register drivers/acpi/ibm_acpi.c
--- a/drivers/acpi/ibm_acpi.c~video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register
+++ a/drivers/acpi/ibm_acpi.c
@@ -1714,7 +1714,7 @@ static struct backlight_properties ibm_b
 
 static int brightness_init(void)
 {
-	ibm_backlight_device = backlight_device_register("ibm", NULL,
+	ibm_backlight_device = backlight_device_register("ibm", NULL, NULL,
 							 &ibm_backlight_data);
 	if (IS_ERR(ibm_backlight_device)) {
 		printk(IBM_ERR "Could not register backlight device\n");
diff -puN drivers/acpi/toshiba_acpi.c~video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register drivers/acpi/toshiba_acpi.c
--- a/drivers/acpi/toshiba_acpi.c~video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register
+++ a/drivers/acpi/toshiba_acpi.c
@@ -590,7 +590,8 @@ static int __init toshiba_acpi_init(void
 			remove_proc_entry(PROC_TOSHIBA, acpi_root_dir);
 	}
 
-	toshiba_backlight_device = backlight_device_register("toshiba", NULL,
+	toshiba_backlight_device = backlight_device_register("toshiba",NULL,
+						NULL,
 						&toshiba_backlight_data);
         if (IS_ERR(toshiba_backlight_device)) {
 		printk(KERN_ERR "Could not register toshiba backlight device\n");
diff -puN drivers/misc/msi-laptop.c~video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register drivers/misc/msi-laptop.c
--- a/drivers/misc/msi-laptop.c~video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register
+++ a/drivers/misc/msi-laptop.c
@@ -317,7 +317,8 @@ static int __init msi_init(void)
 
 	/* Register backlight stuff */
 
-	msibl_device = backlight_device_register("msi-laptop-bl", NULL, &msibl_props);
+	msibl_device = backlight_device_register("msi-laptop-bl", NULL, NULL,
+						&msibl_props);
 	if (IS_ERR(msibl_device))
 		return PTR_ERR(msibl_device);
 
diff -puN drivers/usb/misc/appledisplay.c~video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register drivers/usb/misc/appledisplay.c
--- a/drivers/usb/misc/appledisplay.c~video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register
+++ a/drivers/usb/misc/appledisplay.c
@@ -281,7 +281,7 @@ static int appledisplay_probe(struct usb
 	/* Register backlight device */
 	snprintf(bl_name, sizeof(bl_name), "appledisplay%d",
 		atomic_inc_return(&count_displays) - 1);
-	pdata->bd = backlight_device_register(bl_name, pdata,
+	pdata->bd = backlight_device_register(bl_name, NULL, NULL,
 						&appledisplay_bl_data);
 	if (IS_ERR(pdata->bd)) {
 		err("appledisplay: Backlight registration failed");
diff -puN drivers/video/backlight/backlight.c~video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register
+++ a/drivers/video/backlight/backlight.c
@@ -216,8 +216,10 @@ static const struct class_device_attribu
  * Creates and registers new backlight class_device. Returns either an
  * ERR_PTR() or a pointer to the newly allocated device.
  */
-struct backlight_device *backlight_device_register(const char *name, void *devdata,
-						   struct backlight_properties *bp)
+struct backlight_device *backlight_device_register(const char *name,
+	struct device *dev,
+	void *devdata,
+	struct backlight_properties *bp)
 {
 	int i, rc;
 	struct backlight_device *new_bd;
@@ -232,6 +234,7 @@ struct backlight_device *backlight_devic
 	new_bd->props = bp;
 	memset(&new_bd->class_dev, 0, sizeof(new_bd->class_dev));
 	new_bd->class_dev.class = &backlight_class;
+	new_bd->class_dev.dev = dev;
 	strlcpy(new_bd->class_dev.class_id, name, KOBJ_NAME_LEN);
 	class_set_devdata(&new_bd->class_dev, devdata);
 
diff -puN include/linux/backlight.h~video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register include/linux/backlight.h
--- a/include/linux/backlight.h~video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register
+++ a/include/linux/backlight.h
@@ -54,7 +54,7 @@ struct backlight_device {
 };
 
 extern struct backlight_device *backlight_device_register(const char *name,
-	void *devdata, struct backlight_properties *bp);
+	struct device *dev,void *devdata,struct backlight_properties *bp);
 extern void backlight_device_unregister(struct backlight_device *bd);
 
 #define to_backlight_device(obj) container_of(obj, struct backlight_device, class_dev)
_

Patches currently in -mm which might be from luming.yu@gmail.com are

git-acpi.patch

