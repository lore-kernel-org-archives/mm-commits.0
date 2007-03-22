From: akpm@linux-foundation.org
Subject: + fbdev-sysfs-imrovements.patch added to -mm tree
Date: Thu, 22 Mar 2007 13:52:57 -0700
Message-ID: <200703222052.l2MKqvDS030102@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51213 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbXCVUxR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 16:53:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jsimmons@infradead.org, adaplas@pol.net, greg@kroah.com


The patch titled
     fbdev sysfs imrovements
has been added to the -mm tree.  Its filename is
     fbdev-sysfs-imrovements.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev sysfs imrovements
From: James Simmons <jsimmons@infradead.org>

This patch does several things to allow the underlying hardware to be
shared amount many devices.  The most important thing is the use of the
created device via device_create instead of the hardware device.  No longer
should fbdev drivers use the xxx_set_drvdata with the parent bus device. 
The second change is having a bus independent power management for the
framebuffer driver.  The final change is using the release method to
cleanup the device.  The reason again is to make the fbdev driver
independent of the bus parent device.

Looks-good-to: Greg KH <greg@kroah.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c   |   20 +-------
 drivers/video/fbsysfs.c |   93 ++++++++++++++++++++++++++++++--------
 include/linux/fb.h      |    5 ++
 3 files changed, 84 insertions(+), 34 deletions(-)

diff -puN drivers/video/fbmem.c~fbdev-sysfs-imrovements drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-sysfs-imrovements
+++ a/drivers/video/fbmem.c
@@ -1271,8 +1271,6 @@ static const struct file_operations fb_f
 #endif
 };
 
-struct class *fb_class;
-EXPORT_SYMBOL(fb_class);
 /**
  *	register_framebuffer - registers a frame buffer device
  *	@fb_info: frame buffer info structure
@@ -1298,14 +1296,9 @@ register_framebuffer(struct fb_info *fb_
 			break;
 	fb_info->node = i;
 
-	fb_info->dev = device_create(fb_class, fb_info->device,
-				     MKDEV(FB_MAJOR, i), "fb%d", i);
-	if (IS_ERR(fb_info->dev)) {
-		/* Not fatal */
+	/* Not fatal */
+	if (fb_init_device(fb_info))
 		printk(KERN_WARNING "Unable to create device for framebuffer %d; errno = %ld\n", i, PTR_ERR(fb_info->dev));
-		fb_info->dev = NULL;
-	} else
-		fb_init_device(fb_info);
 
 	if (fb_info->pixmap.addr == NULL) {
 		fb_info->pixmap.addr = kmalloc(FBPIXMAPSIZE, GFP_KERNEL);
@@ -1359,7 +1352,6 @@ unregister_framebuffer(struct fb_info *f
 	registered_fb[i]=NULL;
 	num_registered_fb--;
 	fb_cleanup_device(fb_info);
-	device_destroy(fb_class, MKDEV(FB_MAJOR, i));
 	event.info = fb_info;
 	fb_notifier_call_chain(FB_EVENT_FB_UNREGISTERED, &event);
 	return 0;
@@ -1405,11 +1397,7 @@ fbmem_init(void)
 	if (register_chrdev(FB_MAJOR,"fb",&fb_fops))
 		printk("unable to get major %d for fb devs\n", FB_MAJOR);
 
-	fb_class = class_create(THIS_MODULE, "graphics");
-	if (IS_ERR(fb_class)) {
-		printk(KERN_WARNING "Unable to create fb class; errno = %ld\n", PTR_ERR(fb_class));
-		fb_class = NULL;
-	}
+	fb_create_class();
 	return 0;
 }
 
@@ -1418,8 +1406,8 @@ module_init(fbmem_init);
 static void __exit
 fbmem_exit(void)
 {
-	class_destroy(fb_class);
 	unregister_chrdev(FB_MAJOR, "fb");
+	fb_destroy_class();
 }
 
 module_exit(fbmem_exit);
diff -puN drivers/video/fbsysfs.c~fbdev-sysfs-imrovements drivers/video/fbsysfs.c
--- a/drivers/video/fbsysfs.c~fbdev-sysfs-imrovements
+++ a/drivers/video/fbsysfs.c
@@ -505,42 +505,99 @@ static struct device_attribute device_at
 #endif
 };
 
-int fb_init_device(struct fb_info *fb_info)
+struct class *fb_class;
+EXPORT_SYMBOL(fb_class);
+
+static void fb_device_release(struct device *dev)
 {
-	int i, error = 0;
+	struct fb_info *fb_info = dev_get_drvdata(dev);
 
-	dev_set_drvdata(fb_info->dev, fb_info);
+	if (fb_info) {
+		acquire_console_sem();
 
-	fb_info->class_flag |= FB_SYSFS_FLAG_ATTR;
+		// shutdown the hardware.
+		if (fb_info->fbops->fb_release)
+			fb_info->fbops->fb_release(fb_info, 0);
 
-	for (i = 0; i < ARRAY_SIZE(device_attrs); i++) {
-		error = device_create_file(fb_info->dev, &device_attrs[i]);
+		fb_dealloc_cmap(&fb_info->cmap);
+		unregister_framebuffer(fb_info);
 
-		if (error)
-			break;
+		//framebuffer_release(info); Not every driver does this yet
+		release_console_sem();
 	}
+}
+
+int fb_init_device(struct fb_info *fb_info)
+{
+	int error = 0;
 
-	if (error) {
-		while (--i >= 0)
-			device_remove_file(fb_info->dev, &device_attrs[i]);
+	fb_info->dev = device_create(fb_class, fb_info->device,
+					MKDEV(FB_MAJOR, fb_info->node),
+					"fb%d", fb_info->node);
+	if (IS_ERR(fb_info->dev)) {
 		fb_info->class_flag &= ~FB_SYSFS_FLAG_ATTR;
+		fb_info->dev = NULL;
+		error = -EINVAL;
+	} else {
+		dev_set_drvdata(fb_info->dev, fb_info);
+		fb_info->dev->release = fb_device_release;
+		fb_info->class_flag |= FB_SYSFS_FLAG_ATTR;
 	}
-
-	return 0;
+	return error;
 }
 
 void fb_cleanup_device(struct fb_info *fb_info)
 {
-	unsigned int i;
+	fb_info->class_flag &= ~FB_SYSFS_FLAG_ATTR;
+	dev_set_drvdata(fb_info->dev, NULL);
+	device_destroy(fb_class, MKDEV(FB_MAJOR, fb_info->node));
+}
 
-	if (fb_info->class_flag & FB_SYSFS_FLAG_ATTR) {
-		for (i = 0; i < ARRAY_SIZE(device_attrs); i++)
-			device_remove_file(fb_info->dev, &device_attrs[i]);
+static int fb_class_suspend(struct device *dev, pm_message_t state)
+{
+	struct fb_info *fb_info = dev_get_drvdata(dev);
+	int ret = 0;
 
-		fb_info->class_flag &= ~FB_SYSFS_FLAG_ATTR;
+	acquire_console_sem();
+	fb_set_suspend(fb_info, 1);
+	if (fb_info->fbops->fb_power)
+		ret = fb_info->fbops->fb_power(fb_info, state);
+	release_console_sem();
+	return ret;
+}
+
+static int fb_class_resume(struct device *dev)
+{
+	struct fb_info *fb_info = dev_get_drvdata(dev);
+	int ret = 0;
+
+	acquire_console_sem();
+	fb_set_suspend(fb_info, 0);
+	if (fb_info->fbops->fb_power)
+		ret = fb_info->fbops->fb_power(fb_info, PMSG_ON);
+	release_console_sem();
+	return ret;
+}
+
+void fb_create_class()
+{
+	fb_class = class_create(THIS_MODULE, "graphics");
+	if (IS_ERR(fb_class)) {
+		printk(KERN_WARNING "Unable to create fb class; errno = %ld\n", PTR_ERR(fb_class));
+		fb_class = NULL;
+	} else {
+		fb_class->suspend = fb_class_suspend;
+		fb_class->resume = fb_class_resume;
+		fb_class->dev_attrs = device_attrs;
 	}
 }
 
+void fb_destroy_class()
+{
+	if (fb_class)
+		class_destroy(fb_class);
+}
+
 #ifdef CONFIG_FB_BACKLIGHT
 /* This function generates a linear backlight curve
  *
diff -puN include/linux/fb.h~fbdev-sysfs-imrovements include/linux/fb.h
--- a/include/linux/fb.h~fbdev-sysfs-imrovements
+++ a/include/linux/fb.h
@@ -641,6 +641,9 @@ struct fb_ops {
 	/* perform fb specific mmap */
 	int (*fb_mmap)(struct fb_info *info, struct vm_area_struct *vma);
 
+	/* Power management */
+	int (*fb_power)(struct fb_info *info, pm_message_t state);
+
 	/* save current hardware state */
 	void (*fb_save_state)(struct fb_info *info);
 
@@ -941,6 +944,8 @@ extern void framebuffer_release(struct f
 extern int fb_init_device(struct fb_info *fb_info);
 extern void fb_cleanup_device(struct fb_info *head);
 extern void fb_bl_default_curve(struct fb_info *fb_info, u8 off, u8 min, u8 max);
+extern void fb_destroy_class(void);
+extern void fb_create_class(void);
 
 /* drivers/video/fbmon.c */
 #define FB_MAXTIMINGS		0
_

Patches currently in -mm which might be from jsimmons@infradead.org are

ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch
aty128fb-fix-blanking.patch
change-rivafb_remove-to-__devexit.patch
fbdev-display-class.patch
fbdev-display-class-fix.patch
tgafb-turbochannel-support.patch
tgafb-accelerated-code.patch
fbdev-avoid-vertical-overflow-when-making-space-for-the-logo.patch
fbdev-fb_do_show_logo-updates.patch
fbdev-correct-image-offsets-when-rotating-logo.patch
fbdev-sysfs-imrovements.patch
