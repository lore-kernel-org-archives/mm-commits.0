From: akpm@linux-foundation.org
Subject: - fbdev-fbcon-console-unregistration-from-unregister_framebuffer.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:05 -0700
Message-ID: <200707172307.l6HN752D012149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47707 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936431AbXGQXPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesse.barnes@intel.com, adaplas@gmail.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: fbcon: console unregistration from unregister_framebuffer
has been removed from the -mm tree.  Its filename was
     fbdev-fbcon-console-unregistration-from-unregister_framebuffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: fbcon: console unregistration from unregister_framebuffer
From: Jesse Barnes <jesse.barnes@intel.com>

This allows for proper console unregistration via the VT layer, and updates
the FB layer to use it.  This makes debugging new console drivers much easier,
since you can properly clean them up before unloading.

[adaplas]
unregister_framebuffer() is typically called as part of the driver's
module_exit(). Doing so otherwise will freeze the machine as the VT layer is
holding reference counts on fbcon, and fbcon on the driver.  With this change,
it allows unregister_framebuffer() to be called safely anywhere as needed.

Additions from the original:  If multiple drivers are used by fbcon, and if
one of them unregisters, a driver will take over the consoles vacated by the
outgoing one (via set_con2fb_map).   Once only the outgoing driver remains,
then fbcon will unbind from the VT layer (if CONFIG_HW_CONSOLE_UNBINDING is
set to y).

It is important that these drivers implement fb_open() and fb_release()
just to ensure that no other process is using the driver. Likewise, these
drivers _must_ check the return value of unregister_framebuffer().

[akpm@linux-foundation.org: make fbcon_unbind() stub inline]
Signed-off-by: Jesse Barnes <jesse.barnes@intel.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   42 ++++++++++++++++++++++++++++++++
 drivers/video/fbmem.c         |   26 ++++++++++++++++---
 include/linux/fb.h            |    2 +
 3 files changed, 66 insertions(+), 4 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbdev-fbcon-console-unregistration-from-unregister_framebuffer drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbdev-fbcon-console-unregistration-from-unregister_framebuffer
+++ a/drivers/video/console/fbcon.c
@@ -3003,6 +3003,45 @@ static int fbcon_mode_deleted(struct fb_
 	return found;
 }
 
+#ifdef CONFIG_VT_HW_CONSOLE_BINDING
+static int fbcon_unbind(void)
+{
+	int ret;
+
+	ret = unbind_con_driver(&fb_con, first_fb_vc, last_fb_vc,
+				fbcon_is_default);
+	return ret;
+}
+#else
+static inline int fbcon_unbind(void)
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_VT_HW_CONSOLE_BINDING */
+
+static int fbcon_fb_unbind(int idx)
+{
+	int i, new_idx = -1, ret = 0;
+
+	for (i = first_fb_vc; i <= last_fb_vc; i++) {
+		if (con2fb_map[i] != idx &&
+		    con2fb_map[i] != -1) {
+			new_idx = i;
+			break;
+		}
+	}
+
+	if (new_idx != -1) {
+		for (i = first_fb_vc; i <= last_fb_vc; i++) {
+			if (con2fb_map[i] == idx)
+				set_con2fb_map(i, new_idx, 0);
+		}
+	} else
+		ret = fbcon_unbind();
+
+	return ret;
+}
+
 static int fbcon_fb_unregistered(struct fb_info *info)
 {
 	int i, idx = info->node;
@@ -3210,6 +3249,9 @@ static int fbcon_event_notify(struct not
 		mode = event->data;
 		ret = fbcon_mode_deleted(info, mode);
 		break;
+	case FB_EVENT_FB_UNBIND:
+		ret = fbcon_fb_unbind(info->node);
+		break;
 	case FB_EVENT_FB_REGISTERED:
 		ret = fbcon_fb_registered(info);
 		break;
diff -puN drivers/video/fbmem.c~fbdev-fbcon-console-unregistration-from-unregister_framebuffer drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-fbcon-console-unregistration-from-unregister_framebuffer
+++ a/drivers/video/fbmem.c
@@ -1334,17 +1334,34 @@ register_framebuffer(struct fb_info *fb_
  *
  *	Returns negative errno on error, or zero for success.
  *
+ *      This function will also notify the framebuffer console
+ *      to release the driver.
+ *
+ *      This is meant to be called within a driver's module_exit()
+ *      function. If this is called outside module_exit(), ensure
+ *      that the driver implements fb_open() and fb_release() to
+ *      check that no processes are using the device.
  */
 
 int
 unregister_framebuffer(struct fb_info *fb_info)
 {
 	struct fb_event event;
-	int i;
+	int i, ret = 0;
 
 	i = fb_info->node;
-	if (!registered_fb[i])
-		return -EINVAL;
+	if (!registered_fb[i]) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	event.info = fb_info;
+	ret = fb_notifier_call_chain(FB_EVENT_FB_UNBIND, &event);
+
+	if (ret) {
+		ret = -EINVAL;
+		goto done;
+	}
 
 	if (fb_info->pixmap.addr &&
 	    (fb_info->pixmap.flags & FB_PIXMAP_DEFAULT))
@@ -1356,7 +1373,8 @@ unregister_framebuffer(struct fb_info *f
 	device_destroy(fb_class, MKDEV(FB_MAJOR, i));
 	event.info = fb_info;
 	fb_notifier_call_chain(FB_EVENT_FB_UNREGISTERED, &event);
-	return 0;
+done:
+	return ret;
 }
 
 /**
diff -puN include/linux/fb.h~fbdev-fbcon-console-unregistration-from-unregister_framebuffer include/linux/fb.h
--- a/include/linux/fb.h~fbdev-fbcon-console-unregistration-from-unregister_framebuffer
+++ a/include/linux/fb.h
@@ -529,6 +529,8 @@ struct fb_cursor_user {
 #define FB_EVENT_CONBLANK               0x0C
 /*      Get drawing requirements        */
 #define FB_EVENT_GET_REQ                0x0D
+/*      Unbind from the console if possible */
+#define FB_EVENT_FB_UNBIND              0x0E
 
 struct fb_event {
 	struct fb_info *info;
_

Patches currently in -mm which might be from jesse.barnes@intel.com are

origin.patch
pci-disable-decode-of-io-memory-during-bar-sizing.patch
i386-trim-memory-not-covered-by-wb-mtrrs.patch
