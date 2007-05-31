From: akpm@linux-foundation.org
Subject: + fbcon-set_con2fb_map-fixes.patch added to -mm tree
Date: Thu, 31 May 2007 15:24:26 -0700
Message-ID: <200705312224.l4VMOQJM029498@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752777AbXEaWY3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 18:24:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     fbcon: set_con2fb_map fixes
has been added to the -mm tree.  Its filename is
     fbcon-set_con2fb_map-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbcon: set_con2fb_map fixes
From: "Antonino A. Daplas" <adaplas@gmail.com>

set_con2fb_map() has regressed for some time.  Using fbcon=map:01, for
example, works only if there is only 1 working framebuffer. Trying to do a
set_con2fb_map() on a non-allocated vc will freeze the system.

- ensure that succeeding drivers after the first gets mapped to the console
- remove fbcon_preset_display() and modify fbcon_set_display() to include the
  former's functionality
- ensure that binding and unbinding succeeds if multiple drivers are mapped to
  the console

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   64 ++++++++++++--------------------
 1 files changed, 25 insertions(+), 39 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbcon-set_con2fb_map-fixes drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-set_con2fb_map-fixes
+++ a/drivers/video/console/fbcon.c
@@ -192,9 +192,7 @@ static __inline__ void ypan_down(struct 
 static void fbcon_bmove_rec(struct vc_data *vc, struct display *p, int sy, int sx,
 			    int dy, int dx, int height, int width, u_int y_break);
 static void fbcon_set_disp(struct fb_info *info, struct fb_var_screeninfo *var,
-			   struct vc_data *vc);
-static void fbcon_preset_disp(struct fb_info *info, struct fb_var_screeninfo *var,
-			      int unit);
+			   int unit);
 static void fbcon_redraw_move(struct vc_data *vc, struct display *p,
 			      int line, int count, int dy);
 static void fbcon_modechanged(struct fb_info *info);
@@ -745,7 +743,9 @@ static int con2fb_acquire_newinfo(struct
 
 	if (!err) {
 		info->fbcon_par = ops;
-		set_blitting_type(vc, info);
+
+		if (vc)
+			set_blitting_type(vc, info);
 	}
 
 	if (err) {
@@ -807,11 +807,7 @@ static void con2fb_init_display(struct v
 
 	ops->flags |= FBCON_FLAGS_INIT;
 	ops->graphics = 0;
-
-	if (vc)
-		fbcon_set_disp(info, &info->var, vc);
-	else
-		fbcon_preset_disp(info, &info->var, unit);
+	fbcon_set_disp(info, &info->var, unit);
 
 	if (show_logo) {
 		struct vc_data *fg_vc = vc_cons[fg_console].d;
@@ -1116,6 +1112,9 @@ static void fbcon_init(struct vc_data *v
 	if (var_to_display(p, &info->var, info))
 		return;
 
+	if (!info->fbcon_par)
+		con2fb_acquire_newinfo(vc, info, vc->vc_num, -1);
+
 	/* If we are not the first console on this
 	   fb, copy the font from that console */
 	t = &fb_display[fg_console];
@@ -1382,36 +1381,29 @@ static int scrollback_phys_max = 0;
 static int scrollback_max = 0;
 static int scrollback_current = 0;
 
-/*
- * If no vc is existent yet, just set struct display
- */
-static void fbcon_preset_disp(struct fb_info *info, struct fb_var_screeninfo *var,
-			      int unit)
-{
-	struct display *p = &fb_display[unit];
-	struct display *t = &fb_display[fg_console];
-
-	if (var_to_display(p, var, info))
-		return;
-
-	p->fontdata = t->fontdata;
-	p->userfont = t->userfont;
-	if (p->userfont)
-		REFCOUNT(p->fontdata)++;
-}
-
 static void fbcon_set_disp(struct fb_info *info, struct fb_var_screeninfo *var,
-			   struct vc_data *vc)
+			   int unit)
 {
-	struct display *p = &fb_display[vc->vc_num], *t;
-	struct vc_data **default_mode = vc->vc_display_fg;
-	struct vc_data *svc = *default_mode;
+	struct display *p, *t;
+	struct vc_data **default_mode, *vc;
+	struct vc_data *svc;
 	struct fbcon_ops *ops = info->fbcon_par;
 	int rows, cols, charcnt = 256;
 
+	p = &fb_display[unit];
+
 	if (var_to_display(p, var, info))
 		return;
+
+	vc = vc_cons[unit].d;
+
+	if (!vc)
+		return;
+
+	default_mode = vc->vc_display_fg;
+	svc = *default_mode;
 	t = &fb_display[svc->vc_num];
+
 	if (!vc->vc_font.data) {
 		vc->vc_font.data = (void *)(p->fontdata = t->fontdata);
 		vc->vc_font.width = (*default_mode)->vc_font.width;
@@ -3118,8 +3110,7 @@ static int fbcon_fb_registered(struct fb
 			ret = fbcon_takeover(1);
 	} else {
 		for (i = first_fb_vc; i <= last_fb_vc; i++) {
-			if (con2fb_map_boot[i] == idx &&
-			    con2fb_map[i] == -1)
+			if (con2fb_map_boot[i] == idx)
 				set_con2fb_map(i, idx, 0);
 		}
 	}
@@ -3167,12 +3158,7 @@ static void fbcon_new_modelist(struct fb
 		mode = fb_find_nearest_mode(fb_display[i].mode,
 					    &info->modelist);
 		fb_videomode_to_var(&var, mode);
-
-		if (vc)
-			fbcon_set_disp(info, &var, vc);
-		else
-			fbcon_preset_disp(info, &var, i);
-
+		fbcon_set_disp(info, &var, vc->vc_num);
 	}
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
