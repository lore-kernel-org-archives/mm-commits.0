From: akpm@linux-foundation.org
Subject: + fbdefio-add-sysfs-support-for-fbdefio-delay.patch added to -mm tree
Date: Tue, 02 Mar 2010 16:21:19 -0800
Message-ID: <201003030021.o230LJlr006877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758036Ab0CCAV2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 19:21:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rvinyard@cs.nmsu.edu, jayakumar.lkml@gmail.com, krzysztof.h1@poczta.fm


The patch titled
     fbdefio: add sysfs support for fbdefio delay
has been added to the -mm tree.  Its filename is
     fbdefio-add-sysfs-support-for-fbdefio-delay.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdefio: add sysfs support for fbdefio delay
From: "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>

Add support for examining and modifying the fbdefio delay parameter
through sysfs.  It also adds two driver definable minimum and maximum
bounds.

The default behavior is to not permit modifications if delay_max is 0,
thus preventing modification of the delay if the driver does not
explicitly permit modification.

Signed-off-by: Rick L. Vinyard, Jr <rvinyard@cs.nmsu.edu>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-graphics-defio |   35 ++++
 drivers/video/fbsysfs.c                              |   87 ++++++++++
 include/linux/fb.h                                   |    9 -
 3 files changed, 130 insertions(+), 1 deletion(-)

diff -puN /dev/null Documentation/ABI/testing/sysfs-class-graphics-defio
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-class-graphics-defio
@@ -0,0 +1,35 @@
+What:		/sys/class/graphics/<fb>/defio_delay
+Date:		February 2010
+KernelVersion:	2.6.34
+Contact:	Rick L Vinyard Jr <rvinyard@cs.nmsu.edu>
+Description:
+		Set the deferred I/O delay of the framebuffer in ms.
+		This value can be used to throttle deferred I/O updates.
+		Most framebuffer devices do not have or need support for
+		deferred I/O. Accessing a framebuffer without deferred I/O
+		support will return -ENODEV. Can be read but not modified if
+		/sys/class/graphics/<fb>/defio_delay_max is 0. When modifying,
+		the value must be greater than or equal to
+		/sys/class/graphics/<fb>/defio_delay_min and less than or equal
+		to /sys/class/graphics/<fb>/defio_delay_max.
+
+What:		/sys/class/graphics/<fb>/defio_delay_min
+Date:		February 2010
+KernelVersion:	2.6.34
+Contact:	Rick L Vinyard Jr <rvinyard@cs.nmsu.edu>
+Description:
+		Minimum deferred I/O value in ms for this framebuffer.
+		This value is specified by the driver and cannot be modified
+		from sysfs. Default is 0.
+
+What:		/sys/class/graphics/<fb>/defio_delay_min
+Date:		February 2010
+KernelVersion:	2.6.34
+Contact:	Rick L Vinyard Jr <rvinyard@cs.nmsu.edu>
+Description:
+		Maximum deferred I/O value in ms for this framebuffer.
+		This value is specified by the driver and cannot be modified
+		from sysfs. Default is 0.
+		If this value is 0 /sys/class/graphics/<fb>/defio_delay cannot
+		be modified, but can be read.
+
diff -puN drivers/video/fbsysfs.c~fbdefio-add-sysfs-support-for-fbdefio-delay drivers/video/fbsysfs.c
--- a/drivers/video/fbsysfs.c~fbdefio-add-sysfs-support-for-fbdefio-delay
+++ a/drivers/video/fbsysfs.c
@@ -484,6 +484,87 @@ static ssize_t show_bl_curve(struct devi
 }
 #endif
 
+#ifdef CONFIG_FB_DEFERRED_IO
+static ssize_t store_defio_delay(struct device *device,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct fb_info *fb_info = dev_get_drvdata(device);
+	unsigned long delay_ms = 0;
+	unsigned long delay;
+	int error;
+	char *last = NULL;
+
+	/* Check to see whether this is a deferred I/O driver */
+	if (!fb_info || !fb_info->fbdefio)
+		return -ENODEV;
+
+	/* Check whether delay_max permits setting of delay */
+	if (fb_info->fbdefio->delay_max == 0)
+		return -EPERM;
+
+	error = strict_strtoul(buf, 10, &delay_ms);
+	if (error < 0)
+		return error;
+
+	delay = delay_ms * HZ / 1000;
+
+	if (delay < fb_info->fbdefio->delay_min ||
+	    delay > fb_info->fbdefio->delay_max)
+		return -EINVAL;
+
+	fb_info->fbdefio->delay = delay;
+
+	return count;
+}
+
+static ssize_t show_defio_delay(struct device *device,
+				struct device_attribute *attr, char *buf)
+{
+	struct fb_info *fb_info = dev_get_drvdata(device);
+	unsigned long delay_ms;
+
+	/* Check to see whether this is a deferred I/O driver */
+	if (!fb_info || !fb_info->fbdefio)
+		return -ENODEV;
+
+	delay_ms = fb_info->fbdefio->delay * 1000 / HZ;
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", delay_ms);
+}
+
+static ssize_t show_defio_delay_min(struct device *device,
+				    struct device_attribute *attr, char *buf)
+{
+	struct fb_info *fb_info = dev_get_drvdata(device);
+	unsigned long delay_ms;
+
+	/* Check to see whether this is a deferred I/O driver */
+	if (!fb_info || !fb_info->fbdefio)
+		return -ENODEV;
+
+	delay_ms = fb_info->fbdefio->delay_min * 1000 / HZ;
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", delay_ms);
+}
+
+static ssize_t show_defio_delay_max(struct device *device,
+				    struct device_attribute *attr, char *buf)
+{
+	struct fb_info *fb_info = dev_get_drvdata(device);
+	unsigned long delay_ms;
+
+	/* Check to see whether this is a deferred I/O driver */
+	if (!fb_info || !fb_info->fbdefio)
+		return -ENODEV;
+
+	delay_ms = fb_info->fbdefio->delay_max * 1000 / HZ;
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", delay_ms);
+}
+
+#endif
+
 /* When cmap is added back in it should be a binary attribute
  * not a text one. Consideration should also be given to converting
  * fbdev to use configfs instead of sysfs */
@@ -503,6 +584,12 @@ static struct device_attribute device_at
 #ifdef CONFIG_FB_BACKLIGHT
 	__ATTR(bl_curve, S_IRUGO|S_IWUSR, show_bl_curve, store_bl_curve),
 #endif
+#ifdef CONFIG_FB_DEFERRED_IO
+	__ATTR(defio_delay, S_IRUGO|S_IWUSR,
+	       show_defio_delay, store_defio_delay),
+	__ATTR(defio_delay_min, S_IRUGO, show_defio_delay_min, NULL),
+	__ATTR(defio_delay_max, S_IRUGO, show_defio_delay_max, NULL),
+#endif
 };
 
 int fb_init_device(struct fb_info *fb_info)
diff -puN include/linux/fb.h~fbdefio-add-sysfs-support-for-fbdefio-delay include/linux/fb.h
--- a/include/linux/fb.h~fbdefio-add-sysfs-support-for-fbdefio-delay
+++ a/include/linux/fb.h
@@ -593,8 +593,15 @@ struct fb_pixmap {
 
 #ifdef CONFIG_FB_DEFERRED_IO
 struct fb_deferred_io {
-	/* delay between mkwrite and deferred handler */
+	/* delay in jiffies between mkwrite and deferred handler */
 	unsigned long delay;
+	/* The minimum delay in jiffies that may be set through sysfs */
+	unsigned long delay_min;
+	/*
+	 * The maximum delay in jiffies that may be set through sysfs.
+	 * If delay_max is 0, delay cannot be set through sysfs.
+	 */
+	unsigned long delay_max;
 	struct mutex lock; /* mutex that protects the page list */
 	struct list_head pagelist; /* list of touched pages */
 	/* callback */
_

Patches currently in -mm which might be from rvinyard@cs.nmsu.edu are

fbdefio-add-sysfs-support-for-fbdefio-delay.patch

