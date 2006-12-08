From: akpm@osdl.org
Subject: - backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch removed from -mm tree
Date: Fri, 08 Dec 2006 01:08:11 -0800
Message-ID: <200612080908.kB898Bc5014460@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:39082 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425273AbWLHJIU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 04:08:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy
has been removed from the -mm tree.  Its filename was
     backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch

This patch was dropped because it was folded into backlight-lcd-remove-dependenct-from-the-framebuffer-layer.patch

------------------------------------------------------
Subject: backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy
From: Andrew Morton <akpm@osdl.org>

cleanuplets.

Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/backlight/backlight.c |    6 ++++--
 drivers/video/backlight/lcd.c       |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/backlight.c~backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy
+++ a/drivers/video/backlight/backlight.c
@@ -25,7 +25,7 @@ static int fb_notifier_callback(struct n
 				unsigned long event, void *data)
 {
 	struct backlight_device *bd;
-	struct fb_event *evdata =(struct fb_event *)data;
+	struct fb_event *evdata = data;
 
 	/* If we aren't interested in this event, skip it immediately ... */
 	if (event != FB_EVENT_BLANK)
@@ -62,7 +62,9 @@ static inline int backlight_register_fb(
 	return 0;
 }
 
-#define backlight_unregister_fb(...) do { } while (0)
+static inline void backlight_unregister_fb(struct backlight_device *bd)
+{
+}
 #endif /* CONFIG_FB */
 
 static ssize_t backlight_show_power(struct class_device *cdev, char *buf)
diff -puN drivers/video/backlight/lcd.c~backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy drivers/video/backlight/lcd.c
--- a/drivers/video/backlight/lcd.c~backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy
+++ a/drivers/video/backlight/lcd.c
@@ -24,7 +24,7 @@ static int fb_notifier_callback(struct n
 				 unsigned long event, void *data)
 {
 	struct lcd_device *ld;
-	struct fb_event *evdata =(struct fb_event *)data;
+	struct fb_event *evdata = data;
 
 	/* If we aren't interested in this event, skip it immediately ... */
 	if (event != FB_EVENT_BLANK)
@@ -56,7 +56,9 @@ static int lcd_register_fb(struct lcd_de
 	return 0;
 }
 
-#define lcd_unregister_fb(...) do { } while (0)
+static inline void lcd_unregister_fb(struct lcd_device *ld)
+{
+}
 #endif /* CONFIG_FB */
 
 static ssize_t lcd_show_power(struct class_device *cdev, char *buf)
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
tty-signal-tty-locking.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
add-process_session-helper-routine-deprecate-old-field.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework.patch
tty-switch-to-ktermios.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2.patch
drivers-isdn-handcrafted-min-max-macro-removal.patch
fault-injection-capabilities-infrastructure.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch

