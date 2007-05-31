From: akpm@linux-foundation.org
Subject: + fbcon-revise-primary-device-selection.patch added to -mm tree
Date: Thu, 31 May 2007 15:24:28 -0700
Message-ID: <200705312224.l4VMOSNe029505@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752899AbXEaWYb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 18:24:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     fbcon: Revise primary device selection
has been added to the -mm tree.  Its filename is
     fbcon-revise-primary-device-selection.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

skeletonfb-fix-of-xxxfb_setup-ifdef.patch
vt8623fb-arkfb-null-pointer-dereference-fix.patch
cfag12864bfb-use-sys_-instead-of-cfb_-framebuffer-accessors.patch
fbdev-move-declaration-of-fb_class-to-linux-fbh.patch
neofb-fix-pseudo_palette-array-overrun-in-neofb_setcolreg.patch
fbcon-smart-blitter-usage-for-scrolling.patch
nvidiafb-adjust-flags-to-take-advantage-of-new-scroll-method.patch
fbcon-cursor-blink-control.patch
fbcon-use-struct-device-instead-of-struct-class_device.patch
fbdev-move-arch-specific-bits-to-their-respective.patch
fbdev-detect-primary-display-device.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix-2.patch
pm3fb-switching-between-x-and-fb-fix.patch
radeonfb-add-support-for-radeon-xpress-200m-rs485.patch
nvidiafb-add-proper-support-for-geforce-7600-chipset.patch
pm2fb-white-spaces-clean-up.patch
fbcon-set_con2fb_map-fixes.patch
fbcon-revise-primary-device-selection.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer-fix.patch
vt-add-comment-for-unbind_con_driver.patch
