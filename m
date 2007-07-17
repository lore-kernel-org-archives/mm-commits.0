From: akpm@linux-foundation.org
Subject: - fbcon-use-struct-device-instead-of-struct-class_device.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:47 -0700
Message-ID: <200707172306.l6HN6l2i012050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36466 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932300AbXGQXPO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbcon: use struct device instead of struct class_device
has been removed from the -mm tree.  Its filename was
     fbcon-use-struct-device-instead-of-struct-class_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbcon: use struct device instead of struct class_device
From: "Antonino A. Daplas" <adaplas@gmail.com>

Port fbcon.c to use struct device from using struct class_device

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   57 ++++++++++++++++----------------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbcon-use-struct-device-instead-of-struct-class_device drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-use-struct-device-instead-of-struct-class_device
+++ a/drivers/video/console/fbcon.c
@@ -198,7 +198,7 @@ static void fbcon_modechanged(struct fb_
 static void fbcon_set_all_vcs(struct fb_info *info);
 static void fbcon_start(void);
 static void fbcon_exit(void);
-static struct class_device *fbcon_class_device;
+static struct device *fbcon_device;
 
 #ifdef CONFIG_MAC
 /*
@@ -3246,8 +3246,9 @@ static struct notifier_block fbcon_event
 	.notifier_call	= fbcon_event_notify,
 };
 
-static ssize_t store_rotate(struct class_device *class_device,
-			    const char *buf, size_t count)
+static ssize_t store_rotate(struct device *device,
+			    struct device_attribute *attr, const char *buf,
+			    size_t count)
 {
 	struct fb_info *info;
 	int rotate, idx;
@@ -3270,8 +3271,9 @@ err:
 	return count;
 }
 
-static ssize_t store_rotate_all(struct class_device *class_device,
-				const char *buf, size_t count)
+static ssize_t store_rotate_all(struct device *device,
+				struct device_attribute *attr,const char *buf,
+				size_t count)
 {
 	struct fb_info *info;
 	int rotate, idx;
@@ -3294,7 +3296,8 @@ err:
 	return count;
 }
 
-static ssize_t show_rotate(struct class_device *class_device, char *buf)
+static ssize_t show_rotate(struct device *device,
+			   struct device_attribute *attr,char *buf)
 {
 	struct fb_info *info;
 	int rotate = 0, idx;
@@ -3315,7 +3318,8 @@ err:
 	return snprintf(buf, PAGE_SIZE, "%d\n", rotate);
 }
 
-static ssize_t show_cursor_blink(struct class_device *class_device, char *buf)
+static ssize_t show_cursor_blink(struct device *device,
+				 struct device_attribute *attr, char *buf)
 {
 	struct fb_info *info;
 	struct fbcon_ops *ops;
@@ -3342,7 +3346,8 @@ err:
 	return snprintf(buf, PAGE_SIZE, "%d\n", blink);
 }
 
-static ssize_t store_cursor_blink(struct class_device *clas_device,
+static ssize_t store_cursor_blink(struct device *device,
+				  struct device_attribute *attr,
 				  const char *buf, size_t count)
 {
 	struct fb_info *info;
@@ -3378,22 +3383,21 @@ err:
 	return count;
 }
 
-static struct class_device_attribute class_device_attrs[] = {
+static struct device_attribute device_attrs[] = {
 	__ATTR(rotate, S_IRUGO|S_IWUSR, show_rotate, store_rotate),
 	__ATTR(rotate_all, S_IWUSR, NULL, store_rotate_all),
 	__ATTR(cursor_blink, S_IRUGO|S_IWUSR, show_cursor_blink,
 	       store_cursor_blink),
 };
 
-static int fbcon_init_class_device(void)
+static int fbcon_init_device(void)
 {
 	int i, error = 0;
 
 	fbcon_has_sysfs = 1;
 
-	for (i = 0; i < ARRAY_SIZE(class_device_attrs); i++) {
-		error = class_device_create_file(fbcon_class_device,
-						 &class_device_attrs[i]);
+	for (i = 0; i < ARRAY_SIZE(device_attrs); i++) {
+		error = device_create_file(fbcon_device, &device_attrs[i]);
 
 		if (error)
 			break;
@@ -3401,8 +3405,7 @@ static int fbcon_init_class_device(void)
 
 	if (error) {
 		while (--i >= 0)
-			class_device_remove_file(fbcon_class_device,
-						 &class_device_attrs[i]);
+			device_remove_file(fbcon_device, &device_attrs[i]);
 
 		fbcon_has_sysfs = 0;
 	}
@@ -3488,16 +3491,15 @@ static int __init fb_console_init(void)
 
 	acquire_console_sem();
 	fb_register_client(&fbcon_event_notifier);
-	fbcon_class_device =
-	    class_device_create(fb_class, NULL, MKDEV(0, 0), NULL, "fbcon");
+	fbcon_device = device_create(fb_class, NULL, MKDEV(0, 0), "fbcon");
 
-	if (IS_ERR(fbcon_class_device)) {
-		printk(KERN_WARNING "Unable to create class_device "
+	if (IS_ERR(fbcon_device)) {
+		printk(KERN_WARNING "Unable to create device "
 		       "for fbcon; errno = %ld\n",
-		       PTR_ERR(fbcon_class_device));
-		fbcon_class_device = NULL;
+		       PTR_ERR(fbcon_device));
+		fbcon_device = NULL;
 	} else
-		fbcon_init_class_device();
+		fbcon_init_device();
 
 	for (i = 0; i < MAX_NR_CONSOLES; i++)
 		con2fb_map[i] = -1;
@@ -3511,14 +3513,13 @@ module_init(fb_console_init);
 
 #ifdef MODULE
 
-static void __exit fbcon_deinit_class_device(void)
+static void __exit fbcon_deinit_device(void)
 {
 	int i;
 
 	if (fbcon_has_sysfs) {
-		for (i = 0; i < ARRAY_SIZE(class_device_attrs); i++)
-			class_device_remove_file(fbcon_class_device,
-						 &class_device_attrs[i]);
+		for (i = 0; i < ARRAY_SIZE(device_attrs); i++)
+			device_remove_file(fbcon_device, &device_attrs[i]);
 
 		fbcon_has_sysfs = 0;
 	}
@@ -3528,8 +3529,8 @@ static void __exit fb_console_exit(void)
 {
 	acquire_console_sem();
 	fb_unregister_client(&fbcon_event_notifier);
-	fbcon_deinit_class_device();
-	class_device_destroy(fb_class, MKDEV(0, 0));
+	fbcon_deinit_device();
+	device_destroy(fb_class, MKDEV(0, 0));
 	fbcon_exit();
 	release_console_sem();
 	unregister_con_driver(&fb_con);
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
