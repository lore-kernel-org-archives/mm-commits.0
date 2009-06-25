From: akpm@linux-foundation.org
Subject: + omapfb-add-support-for-rotation-on-the-blizzard-lcd-ctrl.patch added to -mm tree
Date: Wed, 24 Jun 2009 17:08:02 -0700
Message-ID: <200906250008.n5P082rr004858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756325AbZFYAIj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 20:08:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rodrigo.vivi@openbossa.org, imre.deak@nokia.com, krzysztof.h1@wp.pl, siarhei.siamashka@nokia.com, tony@atomide.com


The patch titled
     omapfb: add support for rotation on the Blizzard LCD ctrl
has been added to the -mm tree.  Its filename is
     omapfb-add-support-for-rotation-on-the-blizzard-lcd-ctrl.patch

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
Subject: omapfb: add support for rotation on the Blizzard LCD ctrl
From: Rodrigo Vivi <rodrigo.vivi@openbossa.org>

The LCD controller (EPSON S1D13744) supports rotation (0, 90, 180 and 270
degrees) on hardware just setting the bits 0 and 1 of 0x28 register (LCD
Panel Configuration Register).  Now it is possible to use this caps only
setting the angle degree on var rotate of fb_var_screeninfo using the
FBIOPUT_VSCREENINFO ioctl.

Fixed-by: Siarhei Siamashka <siarhei.siamashka@nokia.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@openbossa.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/blizzard.c    |   91 +++++++++++++++++++++++++++--
 drivers/video/omap/omapfb_main.c |   52 ++++++++++++----
 2 files changed, 124 insertions(+), 19 deletions(-)

diff -puN drivers/video/omap/blizzard.c~omapfb-add-support-for-rotation-on-the-blizzard-lcd-ctrl drivers/video/omap/blizzard.c
--- a/drivers/video/omap/blizzard.c~omapfb-add-support-for-rotation-on-the-blizzard-lcd-ctrl
+++ a/drivers/video/omap/blizzard.c
@@ -44,6 +44,7 @@
 #define BLIZZARD_CLK_SRC			0x0e
 #define BLIZZARD_MEM_BANK0_ACTIVATE		0x10
 #define BLIZZARD_MEM_BANK0_STATUS		0x14
+#define BLIZZARD_PANEL_CONFIGURATION		0x28
 #define BLIZZARD_HDISP				0x2a
 #define BLIZZARD_HNDP				0x2c
 #define BLIZZARD_VDISP0				0x2e
@@ -162,6 +163,10 @@ struct blizzard_struct {
 	int			vid_scaled;
 	int			last_color_mode;
 	int			zoom_on;
+	int			zoom_area_gx1;
+	int			zoom_area_gx2;
+	int			zoom_area_gy1;
+	int			zoom_area_gy2;
 	int			screen_width;
 	int			screen_height;
 	unsigned		te_connected:1;
@@ -513,6 +518,13 @@ static int do_full_screen_update(struct 
 	return REQ_PENDING;
 }
 
+static int check_1d_intersect(int a1, int a2, int b1, int b2)
+{
+	if (a2 <= b1 || b2 <= a1)
+		return 0;
+	return 1;
+}
+
 /* Setup all planes with an overlapping area with the update window. */
 static int do_partial_update(struct blizzard_request *req, int plane,
 			     int x, int y, int w, int h,
@@ -525,6 +537,7 @@ static int do_partial_update(struct bliz
 	int color_mode;
 	int flags;
 	int zoom_off;
+	int have_zoom_for_this_update = 0;
 
 	/* Global coordinates, relative to pixel 0,0 of the LCD */
 	gx1 = x + blizzard.plane[plane].pos_x;
@@ -544,10 +557,6 @@ static int do_partial_update(struct bliz
 		gx2_out = gx1_out + w_out;
 		gy2_out = gy1_out + h_out;
 	}
-	zoom_off = blizzard.zoom_on && gx1 == 0 && gy1 == 0 &&
-		w == blizzard.screen_width && h == blizzard.screen_height;
-	blizzard.zoom_on = (!zoom_off && blizzard.zoom_on) ||
-			   (w < w_out || h < h_out);
 
 	for (i = 0; i < OMAPFB_PLANE_NUM; i++) {
 		struct plane_info *p = &blizzard.plane[i];
@@ -653,8 +662,49 @@ static int do_partial_update(struct bliz
 	else
 		disable_tearsync();
 
+	if ((gx2_out - gx1_out) != (gx2 - gx1) ||
+	    (gy2_out - gy1_out) != (gy2 - gy1))
+		have_zoom_for_this_update = 1;
+
+	/* 'background' type of screen update (as opposed to 'destructive')
+	   can be used to disable scaling if scaling is active */
+	zoom_off = blizzard.zoom_on && !have_zoom_for_this_update &&
+	    (gx1_out == 0) && (gx2_out == blizzard.screen_width) &&
+	    (gy1_out == 0) && (gy2_out == blizzard.screen_height) &&
+	    (gx1 == 0) && (gy1 == 0);
+
+	if (blizzard.zoom_on && !have_zoom_for_this_update && !zoom_off &&
+	    check_1d_intersect(blizzard.zoom_area_gx1, blizzard.zoom_area_gx2,
+			       gx1_out, gx2_out) &&
+	    check_1d_intersect(blizzard.zoom_area_gy1, blizzard.zoom_area_gy2,
+			       gy1_out, gy2_out)) {
+		/* Previous screen update was using scaling, current update
+		 * is not using it. Additionally, current screen update is
+		 * going to overlap with the scaled area. Scaling needs to be
+		 * disabled in order to avoid 'magnifying glass' effect.
+		 * Dummy setup of background window can be used for this.
+		 */
+		set_window_regs(0, 0, blizzard.screen_width,
+				blizzard.screen_height,
+				0, 0, blizzard.screen_width,
+				blizzard.screen_height,
+				BLIZZARD_COLOR_RGB565, 1, flags);
+		blizzard.zoom_on = 0;
+	}
+
+	/* remember scaling settings if we have scaled update */
+	if (have_zoom_for_this_update) {
+		blizzard.zoom_on = 1;
+		blizzard.zoom_area_gx1 = gx1_out;
+		blizzard.zoom_area_gx2 = gx2_out;
+		blizzard.zoom_area_gy1 = gy1_out;
+		blizzard.zoom_area_gy2 = gy2_out;
+	}
+
 	set_window_regs(gx1, gy1, gx2, gy2, gx1_out, gy1_out, gx2_out, gy2_out,
 			color_mode, zoom_off, flags);
+	if (zoom_off)
+		blizzard.zoom_on = 0;
 
 	blizzard.extif->set_bits_per_cycle(16);
 	/* set_window_regs has left the register index at the right
@@ -908,6 +958,35 @@ static int blizzard_set_scale(int plane,
 	return 0;
 }
 
+static int blizzard_set_rotate(int angle)
+{
+	u32 l;
+
+	l = blizzard_read_reg(BLIZZARD_PANEL_CONFIGURATION);
+	l &= ~0x03;
+
+	switch (angle) {
+	case 0:
+		l = l | 0x00;
+		break;
+	case 90:
+		l = l | 0x03;
+		break;
+	case 180:
+		l = l | 0x02;
+		break;
+	case 270:
+		l = l | 0x01;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	blizzard_write_reg(BLIZZARD_PANEL_CONFIGURATION, l);
+
+	return 0;
+}
+
 static int blizzard_enable_plane(int plane, int enable)
 {
 	if (enable)
@@ -1285,7 +1364,8 @@ static void blizzard_get_caps(int plane,
 	caps->ctrl |= OMAPFB_CAPS_MANUAL_UPDATE |
 		OMAPFB_CAPS_WINDOW_PIXEL_DOUBLE |
 		OMAPFB_CAPS_WINDOW_SCALE |
-		OMAPFB_CAPS_WINDOW_OVERLAY;
+		OMAPFB_CAPS_WINDOW_OVERLAY |
+		OMAPFB_CAPS_WINDOW_ROTATE;
 	if (blizzard.te_connected)
 		caps->ctrl |= OMAPFB_CAPS_TEARSYNC;
 	caps->wnd_color |= (1 << OMAPFB_COLOR_RGB565) |
@@ -1560,6 +1640,7 @@ struct lcd_ctrl blizzard_ctrl = {
 	.setup_plane		= blizzard_setup_plane,
 	.set_scale		= blizzard_set_scale,
 	.enable_plane		= blizzard_enable_plane,
+	.set_rotate		= blizzard_set_rotate,
 	.update_window		= blizzard_update_window_async,
 	.sync			= blizzard_sync,
 	.suspend		= blizzard_suspend,
diff -puN drivers/video/omap/omapfb_main.c~omapfb-add-support-for-rotation-on-the-blizzard-lcd-ctrl drivers/video/omap/omapfb_main.c
--- a/drivers/video/omap/omapfb_main.c~omapfb-add-support-for-rotation-on-the-blizzard-lcd-ctrl
+++ a/drivers/video/omap/omapfb_main.c
@@ -67,6 +67,7 @@ static struct caps_table_struct ctrl_cap
 	{ OMAPFB_CAPS_WINDOW_PIXEL_DOUBLE, "pixel double window" },
 	{ OMAPFB_CAPS_WINDOW_SCALE,   "scale window" },
 	{ OMAPFB_CAPS_WINDOW_OVERLAY, "overlay window" },
+	{ OMAPFB_CAPS_WINDOW_ROTATE,  "rotate window" },
 	{ OMAPFB_CAPS_SET_BACKLIGHT,  "backlight setting" },
 };
 
@@ -215,6 +216,15 @@ static int ctrl_change_mode(struct fb_in
 				 offset, var->xres_virtual,
 				 plane->info.pos_x, plane->info.pos_y,
 				 var->xres, var->yres, plane->color_mode);
+	if (r < 0)
+		return r;
+
+	if (fbdev->ctrl->set_rotate != NULL) {
+		r = fbdev->ctrl->set_rotate(var->rotate);
+		if (r < 0)
+			return r;
+	}
+
 	if (fbdev->ctrl->set_scale != NULL)
 		r = fbdev->ctrl->set_scale(plane->idx,
 				   var->xres, var->yres,
@@ -600,7 +610,7 @@ static void omapfb_rotate(struct fb_info
 	struct omapfb_device *fbdev = plane->fbdev;
 
 	omapfb_rqueue_lock(fbdev);
-	if (cpu_is_omap15xx() && rotate != fbi->var.rotate) {
+	if (rotate != fbi->var.rotate) {
 		struct fb_var_screeninfo *new_var = &fbdev->new_var;
 
 		memcpy(new_var, &fbi->var, sizeof(*new_var));
@@ -707,28 +717,42 @@ int omapfb_update_window_async(struct fb
 				void (*callback)(void *),
 				void *callback_data)
 {
+	int xres, yres;
 	struct omapfb_plane_struct *plane = fbi->par;
 	struct omapfb_device *fbdev = plane->fbdev;
-	struct fb_var_screeninfo *var;
+	struct fb_var_screeninfo *var = &fbi->var;
+
+	switch (var->rotate) {
+	case 0:
+	case 180:
+		xres = fbdev->panel->x_res;
+		yres = fbdev->panel->y_res;
+		break;
+	case 90:
+	case 270:
+		xres = fbdev->panel->y_res;
+		yres = fbdev->panel->x_res;
+		break;
+	default:
+		return -EINVAL;
+	}
 
-	var = &fbi->var;
-	if (win->x >= var->xres || win->y >= var->yres ||
-	    win->out_x > var->xres || win->out_y >= var->yres)
+	if (win->x >= xres || win->y >= yres ||
+	    win->out_x > xres || win->out_y > yres)
 		return -EINVAL;
 
 	if (!fbdev->ctrl->update_window ||
 	    fbdev->ctrl->get_update_mode() != OMAPFB_MANUAL_UPDATE)
 		return -ENODEV;
 
-	if (win->x + win->width >= var->xres)
-		win->width = var->xres - win->x;
-	if (win->y + win->height >= var->yres)
-		win->height = var->yres - win->y;
-	/* The out sizes should be cropped to the LCD size */
-	if (win->out_x + win->out_width > fbdev->panel->x_res)
-		win->out_width = fbdev->panel->x_res - win->out_x;
-	if (win->out_y + win->out_height > fbdev->panel->y_res)
-		win->out_height = fbdev->panel->y_res - win->out_y;
+	if (win->x + win->width > xres)
+		win->width = xres - win->x;
+	if (win->y + win->height > yres)
+		win->height = yres - win->y;
+	if (win->out_x + win->out_width > xres)
+		win->out_width = xres - win->out_x;
+	if (win->out_y + win->out_height > yres)
+		win->out_height = yres - win->out_y;
 	if (!win->width || !win->height || !win->out_width || !win->out_height)
 		return 0;
 
_

Patches currently in -mm which might be from rodrigo.vivi@openbossa.org are

omapfb-add-support-for-rotation-on-the-blizzard-lcd-ctrl.patch

