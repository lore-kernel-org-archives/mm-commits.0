From: akpm@linux-foundation.org
Subject: + vt-console-try-harder-to-print-output-when-panicing.patch added to -mm tree
Date: Wed, 23 Jun 2010 12:56:12 -0700
Message-ID: <201006231956.o5NJuC9U028343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753660Ab0FWT4j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jun 2010 15:56:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, airlied@redhat.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, jsimmons@infradead.org


The patch titled
     vt/console: try harder to print output when panicing
has been added to the -mm tree.  Its filename is
     vt-console-try-harder-to-print-output-when-panicing.patch

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
Subject: vt/console: try harder to print output when panicing
From: Jesse Barnes <jbarnes@virtuousgeek.org>

Jesse's initial patch commit said:

"At panic time (i.e.  when oops_in_progress is set) we should try a bit
harder to update the screen and make sure output gets to the VT, since
some drivers are capable of flipping back to it.

So make sure we try to unblank and update the display if called from a
panic context."

I've enhanced this to add a flag to the vc that console layer can set to
indicate they want this behaviour to occur.  This also adds support to
fbcon for that flag and adds an fb flag for drivers to indicate they want
to use the support.  It enables this for KMS drivers.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Acked-by: James Simmons <jsimmons@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c                       |   13 +++++++++----
 drivers/gpu/drm/i915/intel_fb.c         |    4 +---
 drivers/gpu/drm/nouveau/nouveau_fbcon.c |    1 +
 drivers/gpu/drm/radeon/radeon_fb.c      |    2 +-
 drivers/video/console/fbcon.c           |    4 +++-
 include/linux/console_struct.h          |    1 +
 include/linux/fb.h                      |    4 ++++
 include/linux/vt_kern.h                 |    7 +++++++
 8 files changed, 27 insertions(+), 9 deletions(-)

diff -puN drivers/char/vt.c~vt-console-try-harder-to-print-output-when-panicing drivers/char/vt.c
--- a/drivers/char/vt.c~vt-console-try-harder-to-print-output-when-panicing
+++ a/drivers/char/vt.c
@@ -703,7 +703,10 @@ void redraw_screen(struct vc_data *vc, i
 			update_attr(vc);
 			clear_buffer_attributes(vc);
 		}
-		if (update && vc->vc_mode != KD_GRAPHICS)
+
+		/* Forcibly update if we're panicing */
+		if ((update && vc->vc_mode != KD_GRAPHICS) ||
+		    vt_force_oops_output(vc))
 			do_update_region(vc, vc->vc_origin, vc->vc_screenbuf_size / 2);
 	}
 	set_cursor(vc);
@@ -741,6 +744,7 @@ static void visual_init(struct vc_data *
 	vc->vc_hi_font_mask = 0;
 	vc->vc_complement_mask = 0;
 	vc->vc_can_do_color = 0;
+	vc->vc_panic_force_write = false;
 	vc->vc_sw->con_init(vc, init);
 	if (!vc->vc_complement_mask)
 		vc->vc_complement_mask = vc->vc_can_do_color ? 0x7700 : 0x0800;
@@ -2505,7 +2509,7 @@ static void vt_console_print(struct cons
 		goto quit;
 	}
 
-	if (vc->vc_mode != KD_TEXT)
+	if (vc->vc_mode != KD_TEXT && !vt_force_oops_output(vc))
 		goto quit;
 
 	/* undraw cursor first */
@@ -3709,7 +3713,8 @@ void do_unblank_screen(int leaving_gfx)
 		return;
 	}
 	vc = vc_cons[fg_console].d;
-	if (vc->vc_mode != KD_TEXT)
+	/* Try to unblank in oops case too */
+	if (vc->vc_mode != KD_TEXT && !vt_force_oops_output(vc))
 		return; /* but leave console_blanked != 0 */
 
 	if (blankinterval) {
@@ -3718,7 +3723,7 @@ void do_unblank_screen(int leaving_gfx)
 	}
 
 	console_blanked = 0;
-	if (vc->vc_sw->con_blank(vc, 0, leaving_gfx))
+	if (vc->vc_sw->con_blank(vc, 0, leaving_gfx) || vt_force_oops_output(vc))
 		/* Low-level driver cannot restore -> do it ourselves */
 		update_screen(vc);
 	if (console_blank_hook)
diff -puN drivers/gpu/drm/i915/intel_fb.c~vt-console-try-harder-to-print-output-when-panicing drivers/gpu/drm/i915/intel_fb.c
--- a/drivers/gpu/drm/i915/intel_fb.c~vt-console-try-harder-to-print-output-when-panicing
+++ a/drivers/gpu/drm/i915/intel_fb.c
@@ -128,7 +128,7 @@ static int intelfb_create(struct intel_f
 
 	strcpy(info->fix.id, "inteldrmfb");
 
-	info->flags = FBINFO_DEFAULT;
+	info->flags = FBINFO_DEFAULT | FBINFO_CAN_FORCE_OUTPUT;
 	info->fbops = &intelfb_ops;
 
 	/* setup aperture base/size for vesafb takeover */
@@ -146,8 +146,6 @@ static int intelfb_create(struct intel_f
 	info->fix.smem_start = dev->mode_config.fb_base + obj_priv->gtt_offset;
 	info->fix.smem_len = size;
 
-	info->flags = FBINFO_DEFAULT;
-
 	info->screen_base = ioremap_wc(dev->agp->base + obj_priv->gtt_offset,
 				       size);
 	if (!info->screen_base) {
diff -puN drivers/gpu/drm/nouveau/nouveau_fbcon.c~vt-console-try-harder-to-print-output-when-panicing drivers/gpu/drm/nouveau/nouveau_fbcon.c
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c~vt-console-try-harder-to-print-output-when-panicing
+++ a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -250,6 +250,7 @@ nouveau_fbcon_create(struct nouveau_fbde
 		info->flags = FBINFO_DEFAULT | FBINFO_HWACCEL_COPYAREA |
 			      FBINFO_HWACCEL_FILLRECT |
 			      FBINFO_HWACCEL_IMAGEBLIT;
+	info->flags |= FBINFO_CAN_FORCE_OUTPUT;
 	info->fbops = &nouveau_fbcon_ops;
 	info->fix.smem_start = dev->mode_config.fb_base + nvbo->bo.offset -
 			       dev_priv->vm_vram_base;
diff -puN drivers/gpu/drm/radeon/radeon_fb.c~vt-console-try-harder-to-print-output-when-panicing drivers/gpu/drm/radeon/radeon_fb.c
--- a/drivers/gpu/drm/radeon/radeon_fb.c~vt-console-try-harder-to-print-output-when-panicing
+++ a/drivers/gpu/drm/radeon/radeon_fb.c
@@ -224,7 +224,7 @@ static int radeonfb_create(struct radeon
 
 	drm_fb_helper_fill_fix(info, fb->pitch, fb->depth);
 
-	info->flags = FBINFO_DEFAULT;
+	info->flags = FBINFO_DEFAULT | FBINFO_CAN_FORCE_OUTPUT;
 	info->fbops = &radeonfb_ops;
 
 	tmp = radeon_bo_gpu_offset(rbo) - rdev->mc.vram_start;
diff -puN drivers/video/console/fbcon.c~vt-console-try-harder-to-print-output-when-panicing drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~vt-console-try-harder-to-print-output-when-panicing
+++ a/drivers/video/console/fbcon.c
@@ -283,7 +283,8 @@ static inline int fbcon_is_inactive(stru
 	struct fbcon_ops *ops = info->fbcon_par;
 
 	return (info->state != FBINFO_STATE_RUNNING ||
-		vc->vc_mode != KD_TEXT || ops->graphics);
+		vc->vc_mode != KD_TEXT || ops->graphics) &&
+		!vt_force_oops_output(vc);
 }
 
 static inline int get_color(struct vc_data *vc, struct fb_info *info,
@@ -1073,6 +1074,7 @@ static void fbcon_init(struct vc_data *v
 	if (p->userfont)
 		charcnt = FNTCHARCNT(p->fontdata);
 
+	vc->vc_panic_force_write = !!(info->flags & FBINFO_CAN_FORCE_OUTPUT);
 	vc->vc_can_do_color = (fb_get_color_depth(&info->var, &info->fix)!=1);
 	vc->vc_complement_mask = vc->vc_can_do_color ? 0x7700 : 0x0800;
 	if (charcnt == 256) {
diff -puN include/linux/console_struct.h~vt-console-try-harder-to-print-output-when-panicing include/linux/console_struct.h
--- a/include/linux/console_struct.h~vt-console-try-harder-to-print-output-when-panicing
+++ a/include/linux/console_struct.h
@@ -106,6 +106,7 @@ struct vc_data {
 	struct vc_data **vc_display_fg;		/* [!] Ptr to var holding fg console for this display */
 	unsigned long	vc_uni_pagedir;
 	unsigned long	*vc_uni_pagedir_loc;  /* [!] Location of uni_pagedir variable for this console */
+	bool vc_panic_force_write; /* when oops/panic this VC can accept forced output/blanking */
 	/* additional information is in vt_kern.h */
 };
 
diff -puN include/linux/fb.h~vt-console-try-harder-to-print-output-when-panicing include/linux/fb.h
--- a/include/linux/fb.h~vt-console-try-harder-to-print-output-when-panicing
+++ a/include/linux/fb.h
@@ -812,6 +812,10 @@ struct fb_tile_ops {
  */
 #define FBINFO_BE_MATH  0x100000
 
+/* report to the VT layer that this fb driver can accept forced console
+   output like oopses */
+#define FBINFO_CAN_FORCE_OUTPUT     0x200000
+
 struct fb_info {
 	int node;
 	int flags;
diff -puN include/linux/vt_kern.h~vt-console-try-harder-to-print-output-when-panicing include/linux/vt_kern.h
--- a/include/linux/vt_kern.h~vt-console-try-harder-to-print-output-when-panicing
+++ a/include/linux/vt_kern.h
@@ -100,6 +100,13 @@ extern int unbind_con_driver(const struc
 			     int deflt);
 int vty_init(const struct file_operations *console_fops);
 
+static inline bool vt_force_oops_output(struct vc_data *vc)
+{
+	if (oops_in_progress && vc->vc_panic_force_write)
+		return true;
+	return false;
+}
+
 /*
  * vc_screen.c shares this temporary buffer with the console write code so that
  * we can easily avoid touching user space while holding the console spinlock.
_

Patches currently in -mm which might be from jbarnes@virtuousgeek.org are

linux-next.patch
vt-console-try-harder-to-print-output-when-panicing.patch

