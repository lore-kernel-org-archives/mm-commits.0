From: akpm@linux-foundation.org
Subject: + lcd-add-brightness-feature-to-lcd-class.patch added to -mm tree
Date: Mon, 09 Nov 2009 15:19:18 -0800
Message-ID: <200911092319.nA9NJIlH018617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754356AbZKIXTt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 18:19:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daeinki@gmail.com, inki.dae@samsung.com, kmpark@infradead.org, rpurdie@rpsys.net


The patch titled
     lcd: add brightness feature to lcd class
has been added to the -mm tree.  Its filename is
     lcd-add-brightness-feature-to-lcd-class.patch

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
Subject: lcd: add brightness feature to lcd class
From: InKi Dae <daeinki@gmail.com>

Add a brightness feature to the lcd class, drivers/video/backlight/lcd.c

In the past, most of the lcd panels for embedded system was TFT-LCD Panel
needing backlight device.  But now AMOLED LCD Panel appeared so we should
consider brightness control for AMOLED Panel.

For the time being, I used backlight fake driver for brightness control of
AMOLED LCD Panel.  But this way is not good, so I propose to add
brightness feature to lcd class.

Signed-off-by: InKi Dae <inki.dae@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Kyungmin Park <kmpark@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/video/backlight/lcd.c~lcd-add-brightness-feature-to-lcd-class drivers/video/backlight/lcd.c
--- a/drivers/video/backlight/lcd.c~lcd-add-brightness-feature-to-lcd-class
+++ a/drivers/video/backlight/lcd.c
@@ -164,6 +164,53 @@ static ssize_t lcd_show_max_contrast(str
 	return sprintf(buf, "%d\n", ld->props.max_contrast);
 }
 
+static ssize_t lcd_show_brightness(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int rc = -ENXIO;
+	struct lcd_device *ld = to_lcd_device(dev);
+
+	mutex_lock(&ld->ops_lock);
+	if (ld->ops && ld->ops->get_brightness)
+		rc = sprintf(buf, "%d\n", ld->ops->get_brightness(ld));
+	mutex_unlock(&ld->ops_lock);
+
+	return rc;
+}
+
+static ssize_t lcd_store_brightness(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int rc = -ENXIO;
+	char *endp;
+	struct lcd_device *ld = to_lcd_device(dev);
+	int brightness = simple_strtoul(buf, &endp, 0);
+	size_t size = endp - buf;
+
+	if (*endp && isspace(*endp))
+		size++;
+	if (size != count)
+		return -EINVAL;
+
+	mutex_lock(&ld->ops_lock);
+	if (ld->ops && ld->ops->set_brightness) {
+		pr_debug("lcd: set brightness to %d\n", brightness);
+		ld->ops->set_brightness(ld, brightness);
+		rc = count;
+	}
+	mutex_unlock(&ld->ops_lock);
+
+	return rc;
+}
+
+static ssize_t lcd_show_max_brightness(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct lcd_device *ld = to_lcd_device(dev);
+
+	return sprintf(buf, "%d\n", ld->props.max_brightness);
+}
+
 static struct class *lcd_class;
 
 static void lcd_device_release(struct device *dev)
@@ -176,6 +223,8 @@ static struct device_attribute lcd_devic
 	__ATTR(lcd_power, 0644, lcd_show_power, lcd_store_power),
 	__ATTR(contrast, 0644, lcd_show_contrast, lcd_store_contrast),
 	__ATTR(max_contrast, 0444, lcd_show_max_contrast, NULL),
+	__ATTR(brightness, 0644, lcd_show_brightness, lcd_store_brightness),
+	__ATTR(max_brightness, 0444, lcd_show_max_brightness, NULL),
 	__ATTR_NULL,
 };
 
diff -puN include/linux/lcd.h~lcd-add-brightness-feature-to-lcd-class include/linux/lcd.h
--- a/include/linux/lcd.h~lcd-add-brightness-feature-to-lcd-class
+++ a/include/linux/lcd.h
@@ -34,6 +34,9 @@ struct fb_info;
 struct lcd_properties {
 	/* The maximum value for contrast (read-only) */
 	int max_contrast;
+
+	/* The maximum value for brightness (read-only) */
+	int max_brightness;
 };
 
 struct lcd_ops {
@@ -46,6 +49,10 @@ struct lcd_ops {
 	int (*get_contrast)(struct lcd_device *);
 	/* Set LCD panel contrast */
         int (*set_contrast)(struct lcd_device *, int contrast);
+	/* Get the current brighness setting (only AMOLED lcd panel) */
+	int (*get_brightness)(struct lcd_device *);
+	/* Set LCD panel brightness (only AMOLED lcd panel) */
+	int (*set_brightness)(struct lcd_device *, int brightness);
 	/* Set LCD panel mode (resolutions ...) */
 	int (*set_mode)(struct lcd_device *, struct fb_videomode *);
 	/* Check if given framebuffer device is the one LCD is bound to;
_

Patches currently in -mm which might be from daeinki@gmail.com are

lcd-add-brightness-feature-to-lcd-class.patch

