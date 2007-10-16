From: akpm@linux-foundation.org
Subject: - fb-move-and-rename-extern-declaration-for-global_mode_option.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:45:42 -0700
Message-ID: <200710162045.l9GKjgRV016292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38550 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965094AbXJPU44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:56:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     fb: move and rename extern declaration for global_mode_option
has been removed from the -mm tree.  Its filename was
     fb-move-and-rename-extern-declaration-for-global_mode_option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fb: move and rename extern declaration for global_mode_option
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Move the extern declaration for global_mode_option to <linux/fb.h> and rename
the variable to fb_mode_option.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c  |    4 +---
 drivers/video/modedb.c |    4 ++--
 include/linux/fb.h     |    1 +
 3 files changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/video/fbmem.c~fb-move-and-rename-extern-declaration-for-global_mode_option drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fb-move-and-rename-extern-declaration-for-global_mode_option
+++ a/drivers/video/fbmem.c
@@ -1567,8 +1567,6 @@ int fb_new_modelist(struct fb_info *info
 static char *video_options[FB_MAX] __read_mostly;
 static int ofonly __read_mostly;
 
-extern const char *global_mode_option;
-
 /**
  * fb_get_options - get kernel boot parameters
  * @name:   framebuffer name as it would appear in
@@ -1636,7 +1634,7 @@ static int __init video_setup(char *opti
  	}
 
  	if (!global && !strstr(options, "fb:")) {
- 		global_mode_option = options;
+ 		fb_mode_option = options;
  		global = 1;
  	}
 
diff -puN drivers/video/modedb.c~fb-move-and-rename-extern-declaration-for-global_mode_option drivers/video/modedb.c
--- a/drivers/video/modedb.c~fb-move-and-rename-extern-declaration-for-global_mode_option
+++ a/drivers/video/modedb.c
@@ -27,7 +27,7 @@
 #define DPRINTK(fmt, args...)
 #endif
 
-const char *global_mode_option;
+const char *fb_mode_option;
 
     /*
      *  Standard video mode definitions (taken from XFree86)
@@ -510,7 +510,7 @@ int fb_find_mode(struct fb_var_screeninf
 	default_bpp = 8;
 
     /* Did the user specify a video mode? */
-    if (mode_option || (mode_option = global_mode_option)) {
+    if (mode_option || (mode_option = fb_mode_option)) {
 	const char *name = mode_option;
 	unsigned int namelen = strlen(name);
 	int res_specified = 0, bpp_specified = 0, refresh_specified = 0;
diff -puN include/linux/fb.h~fb-move-and-rename-extern-declaration-for-global_mode_option include/linux/fb.h
--- a/include/linux/fb.h~fb-move-and-rename-extern-declaration-for-global_mode_option
+++ a/include/linux/fb.h
@@ -1056,6 +1056,7 @@ struct fb_videomode {
 	u32 flag;
 };
 
+extern const char *fb_mode_option;
 extern const struct fb_videomode vesa_modes[];
 
 struct fb_modelist {
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
