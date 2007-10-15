From: akpm@linux-foundation.org
Subject: + fb-move-and-rename-extern-declaration-for-global_mode_option.patch added to -mm tree
Date: Mon, 15 Oct 2007 14:36:25 -0700
Message-ID: <200710152136.l9FLaPsj026161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44005 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756503AbXJOVg3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 17:36:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net


The patch titled
     fb: move and rename extern declaration for global_mode_option
has been added to the -mm tree.  Its filename is
     fb-move-and-rename-extern-declaration-for-global_mode_option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-scsi-misc.patch
fbdev-fb_create_modedb-non-static-int-first-=-1.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
ps3-fix-black-and-white-stripes.patch
ps3fb-fix-spurious-mode-change-failures.patch
ps3av-eliminate-unneeded-temporary-variables.patch
ps3av-eliminate-ps3av_debug.patch
ps3av-use-ps3-video-mode-ids-in-autodetect-code.patch
ps3av-treat-dvi-d-like-hdmi-in-autodetect.patch
ps3av-add-autodetection-for-vesa-modes.patch
ps3av-add-quirk-database-for-broken-monitors.patch
ps3av-remove-unused-ps3av_set_mode.patch
ps3av-dont-distinguish-between-boot-and-non-boot-autodetection.patch
ps3fb-convert-from-printk-dprintk-to-dev_-pr_.patch
ps3fb-do-not-print-warnings-on-invalid-frame-numbers.patch
ps3fb-clean-up-includes.patch
ps3fb-make-ps3fb_wait_for_vsync-and-ps3fb_flip_ctl-static.patch
ps3fb-fix-possible-overlap-of-gpu-command-buffer-and-frame-buffer.patch
ps3fb-use-fb_infopar-properly.patch
ps3fb-dont-keep-the-borders-for-non-fullscreen-modes-in-xdr-memory.patch
ps3fb-add-virtual-screen-and-panning-support.patch
ps3fb-enhance-horizontal-panning-on-firmware-190-and-up.patch
fb-move-and-rename-extern-declaration-for-global_mode_option.patch
ps3fb-default-to-480p-on-dvi-d-hdmi-if-video=safe.patch
