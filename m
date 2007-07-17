From: akpm@linux-foundation.org
Subject: - fbcon-revise-primary-device-selection.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:03 -0700
Message-ID: <200707172307.l6HN73WX012146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41434 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759454AbXGQXPM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbcon: Revise primary device selection
has been removed from the -mm tree.  Its filename was
     fbcon-revise-primary-device-selection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbcon: Revise primary device selection
From: "Antonino A. Daplas" <adaplas@gmail.com>

Use set_con2fb_map() to select the primary display driver instead of using
unbind_con_driver() and bind_con_driver().  Using the former is much simpler
and safer than the current one.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/Kconfig |    6 ---
 drivers/video/console/fbcon.c |   49 ++++++++------------------------
 2 files changed, 14 insertions(+), 41 deletions(-)

diff -puN drivers/video/console/Kconfig~fbcon-revise-primary-device-selection drivers/video/console/Kconfig
--- a/drivers/video/console/Kconfig~fbcon-revise-primary-device-selection
+++ a/drivers/video/console/Kconfig
@@ -120,7 +120,7 @@ config FRAMEBUFFER_CONSOLE
 
 config FRAMEBUFFER_CONSOLE_DETECT_PRIMARY
        bool "Map the console to the primary display device"
-       depends on FRAMEBUFFER_CONSOLE && VT_HW_CONSOLE_BINDING
+       depends on FRAMEBUFFER_CONSOLE
        default n
        ---help---
          If this option is selected, the framebuffer console will
@@ -132,10 +132,6 @@ config FRAMEBUFFER_CONSOLE_DETECT_PRIMAR
 	 You can always override the automatic selection of the primary device
 	 by using the fbcon=map: boot option.
 
-	 To select this feature, "Support for binding and unbinding console
-         drivers", under "Device Drivers"->"Character Devices" must be set to
-	 y.
-
 	 If unsure, select n.
 
 config FRAMEBUFFER_CONSOLE_ROTATION
diff -puN drivers/video/console/fbcon.c~fbcon-revise-primary-device-selection drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-revise-primary-device-selection
+++ a/drivers/video/console/fbcon.c
@@ -3041,52 +3041,32 @@ static int fbcon_fb_unregistered(struct 
 }
 
 #ifdef CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY
-static int fbcon_select_primary(struct fb_info *info)
+static void fbcon_select_primary(struct fb_info *info)
 {
-	int ret = 0;
-
 	if (!map_override && primary_device == -1 &&
 	    fb_is_primary_device(info)) {
-		int i, err;
+		int i;
 
-		printk(KERN_INFO "fbcon: %s is primary device\n",
-		       info->fix.id);
+		printk(KERN_INFO "fbcon: %s (fb%i) is primary device\n",
+		       info->fix.id, info->node);
 		primary_device = info->node;
 
-		if (!con_is_bound(&fb_con))
-			goto done;
-
-		printk(KERN_INFO "fbcon: Unbinding old driver\n");
-		unbind_con_driver(&fb_con, first_fb_vc, last_fb_vc,
-				  fbcon_is_default);
-		info_idx = primary_device;
-
-		for (i = first_fb_vc; i <= last_fb_vc; i++) {
+		for (i = first_fb_vc; i <= last_fb_vc; i++)
 			con2fb_map_boot[i] = primary_device;
-			con2fb_map[i] = primary_device;
-		}
-
-		printk(KERN_INFO "fbcon: Selecting new driver\n");
-		err = bind_con_driver(&fb_con, first_fb_vc, last_fb_vc,
-				      fbcon_is_default);
-
-		if (err) {
-			for (i = first_fb_vc; i <= last_fb_vc; i++)
-				con2fb_map[i] = -1;
 
-			info_idx = -1;
+		if (con_is_bound(&fb_con)) {
+			printk(KERN_INFO "fbcon: Remapping primary device, "
+			       "fb%i, to tty %i-%i\n", info->node,
+			       first_fb_vc + 1, last_fb_vc + 1);
+			info_idx = primary_device;
 		}
-
-		ret = 1;
 	}
 
-done:
-	return ret;
 }
 #else
-static inline int fbcon_select_primary(struct fb_info *info)
+static inline void fbcon_select_primary(struct fb_info *info)
 {
-	return 0;
+	return;
 }
 #endif /* CONFIG_FRAMEBUFFER_DETECT_PRIMARY */
 
@@ -3094,9 +3074,7 @@ static int fbcon_fb_registered(struct fb
 {
 	int ret = 0, i, idx = info->node;
 
-	if (fbcon_select_primary(info))
-		goto done;
-
+	fbcon_select_primary(info);
 
 	if (info_idx == -1) {
 		for (i = first_fb_vc; i <= last_fb_vc; i++) {
@@ -3115,7 +3093,6 @@ static int fbcon_fb_registered(struct fb
 		}
 	}
 
-done:
 	return ret;
 }
 
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
