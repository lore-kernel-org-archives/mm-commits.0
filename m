From: akpm@osdl.org
Subject: - backlight-lcd-remove-dependenct-from-the-framebuffer-layer.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:21 -0800
Message-ID: <200612082014.kB8KEL83003161@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59775 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946848AbWLHUOa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     backlight: lcd: Remove dependenct from the framebuffer layer
has been removed from the -mm tree.  Its filename was
     backlight-lcd-remove-dependenct-from-the-framebuffer-layer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: backlight: lcd: Remove dependenct from the framebuffer layer
From: James Simmons <jsimmons@infradead.org>

The backlight layer should be independent from the framebuffer layer.  It
can use the services offered by the framebuffer, but its absence should not
prevent the backlight/lcd layer from functioning.

[akpm@osdl.org: cleanups]
Signed-off-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/backlight/backlight.c |   87 ++++++++++++++++----------
 drivers/video/backlight/lcd.c       |   78 ++++++++++++++---------
 2 files changed, 104 insertions(+), 61 deletions(-)

diff -puN drivers/video/backlight/backlight.c~backlight-lcd-remove-dependenct-from-the-framebuffer-layer drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~backlight-lcd-remove-dependenct-from-the-framebuffer-layer
+++ a/drivers/video/backlight/backlight.c
@@ -14,6 +14,59 @@
 #include <linux/err.h>
 #include <linux/fb.h>
 
+
+#if defined(CONFIG_FB) || (defined(CONFIG_FB_MODULE) && \
+			   defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE))
+/* This callback gets called when something important happens inside a
+ * framebuffer driver. We're looking if that important event is blanking,
+ * and if it is, we're switching backlight power as well ...
+ */
+static int fb_notifier_callback(struct notifier_block *self,
+				unsigned long event, void *data)
+{
+	struct backlight_device *bd;
+	struct fb_event *evdata = data;
+
+	/* If we aren't interested in this event, skip it immediately ... */
+	if (event != FB_EVENT_BLANK)
+		return 0;
+
+	bd = container_of(self, struct backlight_device, fb_notif);
+	down(&bd->sem);
+	if (bd->props)
+		if (!bd->props->check_fb ||
+		    bd->props->check_fb(evdata->info)) {
+			bd->props->fb_blank = *(int *)evdata->data;
+			if (likely(bd->props && bd->props->update_status))
+				bd->props->update_status(bd);
+		}
+	up(&bd->sem);
+	return 0;
+}
+
+static int backlight_register_fb(struct backlight_device *bd)
+{
+	memset(&bd->fb_notif, 0, sizeof(bd->fb_notif));
+	bd->fb_notif.notifier_call = fb_notifier_callback;
+
+	return fb_register_client(&bd->fb_notif);
+}
+
+static void backlight_unregister_fb(struct backlight_device *bd)
+{
+	fb_unregister_client(&bd->fb_notif);
+}
+#else
+static inline int backlight_register_fb(struct backlight_device *bd)
+{
+	return 0;
+}
+
+static inline void backlight_unregister_fb(struct backlight_device *bd)
+{
+}
+#endif /* CONFIG_FB */
+
 static ssize_t backlight_show_power(struct class_device *cdev, char *buf)
 {
 	int rc = -ENXIO;
@@ -151,33 +204,6 @@ static const struct class_device_attribu
 	DECLARE_ATTR(max_brightness, 0444, backlight_show_max_brightness, NULL),
 };
 
-/* This callback gets called when something important happens inside a
- * framebuffer driver. We're looking if that important event is blanking,
- * and if it is, we're switching backlight power as well ...
- */
-static int fb_notifier_callback(struct notifier_block *self,
-				unsigned long event, void *data)
-{
-	struct backlight_device *bd;
-	struct fb_event *evdata =(struct fb_event *)data;
-
-	/* If we aren't interested in this event, skip it immediately ... */
-	if (event != FB_EVENT_BLANK)
-		return 0;
-
-	bd = container_of(self, struct backlight_device, fb_notif);
-	down(&bd->sem);
-	if (bd->props)
-		if (!bd->props->check_fb ||
-		    bd->props->check_fb(evdata->info)) {
-			bd->props->fb_blank = *(int *)evdata->data;
-			if (likely(bd->props && bd->props->update_status))
-				bd->props->update_status(bd);
-		}
-	up(&bd->sem);
-	return 0;
-}
-
 /**
  * backlight_device_register - create and register a new object of
  *   backlight_device class.
@@ -215,10 +241,7 @@ error:		kfree(new_bd);
 		return ERR_PTR(rc);
 	}
 
-	memset(&new_bd->fb_notif, 0, sizeof(new_bd->fb_notif));
-	new_bd->fb_notif.notifier_call = fb_notifier_callback;
-
-	rc = fb_register_client(&new_bd->fb_notif);
+	rc = backlight_register_fb(new_bd);
 	if (unlikely(rc))
 		goto error;
 
@@ -268,7 +291,7 @@ void backlight_device_unregister(struct 
 	bd->props = NULL;
 	up(&bd->sem);
 
-	fb_unregister_client(&bd->fb_notif);
+	backlight_unregister_fb(bd);
 
 	class_device_unregister(&bd->class_dev);
 }
diff -puN drivers/video/backlight/lcd.c~backlight-lcd-remove-dependenct-from-the-framebuffer-layer drivers/video/backlight/lcd.c
--- a/drivers/video/backlight/lcd.c~backlight-lcd-remove-dependenct-from-the-framebuffer-layer
+++ a/drivers/video/backlight/lcd.c
@@ -14,6 +14,53 @@
 #include <linux/err.h>
 #include <linux/fb.h>
 
+#if defined(CONFIG_FB) || (defined(CONFIG_FB_MODULE) && \
+			   defined(CONFIG_LCD_CLASS_DEVICE_MODULE))
+/* This callback gets called when something important happens inside a
+ * framebuffer driver. We're looking if that important event is blanking,
+ * and if it is, we're switching lcd power as well ...
+ */
+static int fb_notifier_callback(struct notifier_block *self,
+				 unsigned long event, void *data)
+{
+	struct lcd_device *ld;
+	struct fb_event *evdata = data;
+
+	/* If we aren't interested in this event, skip it immediately ... */
+	if (event != FB_EVENT_BLANK)
+		return 0;
+
+	ld = container_of(self, struct lcd_device, fb_notif);
+	down(&ld->sem);
+	if (ld->props)
+		if (!ld->props->check_fb || ld->props->check_fb(evdata->info))
+			ld->props->set_power(ld, *(int *)evdata->data);
+	up(&ld->sem);
+	return 0;
+}
+
+static int lcd_register_fb(struct lcd_device *ld)
+{
+	memset(&ld->fb_notif, 0, sizeof(&ld->fb_notif));
+	ld->fb_notif.notifier_call = fb_notifier_callback;
+	return fb_register_client(&ld->fb_notif);
+}
+
+static void lcd_unregister_fb(struct lcd_device *ld)
+{
+	fb_unregister_client(&ld->fb_notif);
+}
+#else
+static int lcd_register_fb(struct lcd_device *ld)
+{
+	return 0;
+}
+
+static inline void lcd_unregister_fb(struct lcd_device *ld)
+{
+}
+#endif /* CONFIG_FB */
+
 static ssize_t lcd_show_power(struct class_device *cdev, char *buf)
 {
 	int rc;
@@ -127,29 +174,6 @@ static const struct class_device_attribu
 	DECLARE_ATTR(max_contrast, 0444, lcd_show_max_contrast, NULL),
 };
 
-/* This callback gets called when something important happens inside a
- * framebuffer driver. We're looking if that important event is blanking,
- * and if it is, we're switching lcd power as well ...
- */
-static int fb_notifier_callback(struct notifier_block *self,
-				 unsigned long event, void *data)
-{
-	struct lcd_device *ld;
-	struct fb_event *evdata =(struct fb_event *)data;
-
-	/* If we aren't interested in this event, skip it immediately ... */
-	if (event != FB_EVENT_BLANK)
-		return 0;
-
-	ld = container_of(self, struct lcd_device, fb_notif);
-	down(&ld->sem);
-	if (ld->props)
-		if (!ld->props->check_fb || ld->props->check_fb(evdata->info))
-			ld->props->set_power(ld, *(int *)evdata->data);
-	up(&ld->sem);
-	return 0;
-}
-
 /**
  * lcd_device_register - register a new object of lcd_device class.
  * @name: the name of the new object(must be the same as the name of the
@@ -186,10 +210,8 @@ error:		kfree(new_ld);
 		return ERR_PTR(rc);
 	}
 
-	memset(&new_ld->fb_notif, 0, sizeof(new_ld->fb_notif));
-	new_ld->fb_notif.notifier_call = fb_notifier_callback;
+	rc = lcd_register_fb(new_ld);
 
-	rc = fb_register_client(&new_ld->fb_notif);
 	if (unlikely(rc))
 		goto error;
 
@@ -232,9 +254,7 @@ void lcd_device_unregister(struct lcd_de
 	down(&ld->sem);
 	ld->props = NULL;
 	up(&ld->sem);
-
-	fb_unregister_client(&ld->fb_notif);
-
+	lcd_unregister_fb(ld);
 	class_device_unregister(&ld->class_dev);
 }
 EXPORT_SYMBOL(lcd_device_unregister);
_

Patches currently in -mm which might be from jsimmons@infradead.org are

origin.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer.patch
softcursorc-avoid-unaligned-accesses.patch
backlight-do-not-power-off-backlight-when-unregistering-try-3.patch
fb-get-the-geode-gx-frambuffer-size-from-the-bios.patch
gxfb-fixups-for-the-amd-geode-gx.patch
gxfb-support-flat-panel-timings.patch
gxfb-support-command-line-options.patch
gxfb-fixup-flatpanel-detection.patch
gxfb-turn-on-the-flatpanel-power-and-data.patch
video-select-set-for-vesa-fb.patch
fbdev-update-after-backlight-argument-change.patch
proper-backlight-selection-for-fbdev-drivers.patch
fbdev-driver-for-ibm-gxt4500p-video-cards.patch

