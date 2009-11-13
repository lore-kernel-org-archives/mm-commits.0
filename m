From: akpm@linux-foundation.org
Subject: [merged] fb-remove-fb_save_state-and-fb_restore_state-operations.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:26:11 -0800
Message-ID: <200911131926.nADJQBno027553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932164AbZKMT0q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:26:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, geert@linux-m68k.org, jochen@jochen.org, spock@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     fb: remove fb_save_state() and fb_restore_state operations
has been removed from the -mm tree.  Its filename was
     fb-remove-fb_save_state-and-fb_restore_state-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fb: remove fb_save_state() and fb_restore_state operations
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Remove fb_save_state() and fb_restore_state operations from frame buffer layer.
They are used only in two drivers:
1. savagefb  - and cause bug #11248
2. uvesafb

Usage of these operations is misunderstood in both drivers so kill these
operations, fix the bug #11248 and avoid confusion in the future.

Tested on Savage 3D/MV card and the patch fixes the bug #11248.

The frame buffer layer uses these funtions during switch between graphics
and text mode of the console, but these drivers saves state before
switching of the frame buffer (in the fb_open) and after releasing it (in
the fb_release).  This defeats the purpose of these operations.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=11248

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Reported-by: Jochen Hein <jochen@jochen.org>
Tested-by: Jochen Hein <jochen@jochen.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Januszewski <spock@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/video/atafb.c~fb-remove-fb_save_state-and-fb_restore_state-operations drivers/video/atafb.c
--- a/drivers/video/atafb.c~fb-remove-fb_save_state-and-fb_restore_state-operations
+++ a/drivers/video/atafb.c
@@ -329,12 +329,6 @@ extern unsigned char fontdata_8x16[];
  *
  *	* perform fb specific mmap *
  *	int (*fb_mmap)(struct fb_info *info, struct vm_area_struct *vma);
- *
- *	* save current hardware state *
- *	void (*fb_save_state)(struct fb_info *info);
- *
- *	* restore saved state *
- *	void (*fb_restore_state)(struct fb_info *info);
  * } ;
  */
 
diff -puN drivers/video/console/fbcon.c~fb-remove-fb_save_state-and-fb_restore_state-operations drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fb-remove-fb_save_state-and-fb_restore_state-operations
+++ a/drivers/video/console/fbcon.c
@@ -2311,14 +2311,11 @@ static int fbcon_blank(struct vc_data *v
 		ops->graphics = 1;
 
 		if (!blank) {
-			if (info->fbops->fb_save_state)
-				info->fbops->fb_save_state(info);
 			var.activate = FB_ACTIVATE_NOW | FB_ACTIVATE_FORCE;
 			fb_set_var(info, &var);
 			ops->graphics = 0;
 			ops->var = info->var;
-		} else if (info->fbops->fb_restore_state)
-			info->fbops->fb_restore_state(info);
+		}
 	}
 
  	if (!fbcon_is_inactive(vc, info)) {
diff -puN drivers/video/savage/savagefb_driver.c~fb-remove-fb_save_state-and-fb_restore_state-operations drivers/video/savage/savagefb_driver.c
--- a/drivers/video/savage/savagefb_driver.c~fb-remove-fb_save_state-and-fb_restore_state-operations
+++ a/drivers/video/savage/savagefb_driver.c
@@ -1606,22 +1606,6 @@ static int savagefb_blank(int blank, str
 	return (blank == FB_BLANK_NORMAL) ? 1 : 0;
 }
 
-static void savagefb_save_state(struct fb_info *info)
-{
-	struct savagefb_par *par = info->par;
-
-	savage_get_default_par(par, &par->save);
-}
-
-static void savagefb_restore_state(struct fb_info *info)
-{
-	struct savagefb_par *par = info->par;
-
-	savagefb_blank(FB_BLANK_POWERDOWN, info);
-	savage_set_default_par(par, &par->save);
-	savagefb_blank(FB_BLANK_UNBLANK, info);
-}
-
 static int savagefb_open(struct fb_info *info, int user)
 {
 	struct savagefb_par *par = info->par;
@@ -1667,8 +1651,6 @@ static struct fb_ops savagefb_ops = {
 	.fb_setcolreg   = savagefb_setcolreg,
 	.fb_pan_display = savagefb_pan_display,
 	.fb_blank       = savagefb_blank,
-	.fb_save_state  = savagefb_save_state,
-	.fb_restore_state = savagefb_restore_state,
 #if defined(CONFIG_FB_SAVAGE_ACCEL)
 	.fb_fillrect    = savagefb_fillrect,
 	.fb_copyarea    = savagefb_copyarea,
diff -puN drivers/video/uvesafb.c~fb-remove-fb_save_state-and-fb_restore_state-operations drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c~fb-remove-fb_save_state-and-fb_restore_state-operations
+++ a/drivers/video/uvesafb.c
@@ -1411,23 +1411,6 @@ static int uvesafb_check_var(struct fb_v
 	return 0;
 }
 
-static void uvesafb_save_state(struct fb_info *info)
-{
-	struct uvesafb_par *par = info->par;
-
-	if (par->vbe_state_saved)
-		kfree(par->vbe_state_saved);
-
-	par->vbe_state_saved = uvesafb_vbe_state_save(par);
-}
-
-static void uvesafb_restore_state(struct fb_info *info)
-{
-	struct uvesafb_par *par = info->par;
-
-	uvesafb_vbe_state_restore(par, par->vbe_state_saved);
-}
-
 static struct fb_ops uvesafb_ops = {
 	.owner		= THIS_MODULE,
 	.fb_open	= uvesafb_open,
@@ -1441,8 +1424,6 @@ static struct fb_ops uvesafb_ops = {
 	.fb_imageblit	= cfb_imageblit,
 	.fb_check_var	= uvesafb_check_var,
 	.fb_set_par	= uvesafb_set_par,
-	.fb_save_state	= uvesafb_save_state,
-	.fb_restore_state = uvesafb_restore_state,
 };
 
 static void __devinit uvesafb_init_info(struct fb_info *info,
@@ -1459,15 +1440,6 @@ static void __devinit uvesafb_init_info(
 	info->fix.ypanstep = par->ypan ? 1 : 0;
 	info->fix.ywrapstep = (par->ypan > 1) ? 1 : 0;
 
-	/*
-	 * If we were unable to get the state buffer size, disable
-	 * functions for saving and restoring the hardware state.
-	 */
-	if (par->vbe_state_size == 0) {
-		info->fbops->fb_save_state = NULL;
-		info->fbops->fb_restore_state = NULL;
-	}
-
 	/* Disable blanking if the user requested so. */
 	if (!blank)
 		info->fbops->fb_blank = NULL;
diff -puN include/linux/fb.h~fb-remove-fb_save_state-and-fb_restore_state-operations include/linux/fb.h
--- a/include/linux/fb.h~fb-remove-fb_save_state-and-fb_restore_state-operations
+++ a/include/linux/fb.h
@@ -669,12 +669,6 @@ struct fb_ops {
 	/* perform fb specific mmap */
 	int (*fb_mmap)(struct fb_info *info, struct vm_area_struct *vma);
 
-	/* save current hardware state */
-	void (*fb_save_state)(struct fb_info *info);
-
-	/* restore saved state */
-	void (*fb_restore_state)(struct fb_info *info);
