From: akpm@linux-foundation.org
Subject: + pm2fb-accelerated-fillrect-and-copyarea.patch added to -mm tree
Date: Mon, 07 May 2007 15:27:13 -0700
Message-ID: <200705072227.l47MRDnE006976@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966707AbXEGWlP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 18:41:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm2fb: accelerated fillrect and copyarea
has been added to the -mm tree.  Its filename is
     pm2fb-accelerated-fillrect-and-copyarea.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm2fb: accelerated fillrect and copyarea
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This is a port of accelerated functions from 2.4 kernel.  Only fillrect and
copyarea are accelerated.  Fillrect is not accelerated in 24-bit mode.

[adaplas]
Add appropriate flags

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |  132 ++++++++++++++++++++++++++++++++++++++--
 1 files changed, 128 insertions(+), 4 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-accelerated-fillrect-and-copyarea drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-accelerated-fillrect-and-copyarea
+++ a/drivers/video/pm2fb.c
@@ -103,7 +103,7 @@ static struct fb_fix_screeninfo pm2fb_fi
 	.xpanstep =	1,
 	.ypanstep =	1,
 	.ywrapstep =	0, 
-	.accel =	FB_ACCEL_NONE,
+	.accel =	FB_ACCEL_3DLABS_PERMEDIA2,
 };
 
 /*
@@ -206,6 +206,17 @@ static inline void WAIT_FIFO(struct pm2f
 }
 #endif
 
+static void wait_pm2(struct pm2fb_par* par) {
+
+	WAIT_FIFO(par, 1);
+	pm2_WR(par, PM2R_SYNC, 0);
+	mb();
+	do {
+		while (pm2_RD(par, PM2R_OUT_FIFO_WORDS) == 0);
+		rmb();
+	} while (pm2_RD(par, PM2R_OUT_FIFO) != PM2TAG(PM2R_SYNC));
+}
+
 /*
  * partial products for the supported horizontal resolutions.
  */
@@ -1041,6 +1052,117 @@ static int pm2fb_blank(int blank_mode, s
 	return 0;
 }
 
+/*
+ * block operation. copy=0: rectangle fill, copy=1: rectangle copy.
+ */
+static void pm2fb_block_op(struct pm2fb_par* par, int copy,
+				s32 xsrc, s32 ysrc,
+				s32 x, s32 y, s32 w, s32 h,
+				u32 color) {
+
+	if (!w || !h)
+		return;
+	WAIT_FIFO(par, 6);
+	pm2_WR(par, PM2R_CONFIG, PM2F_CONFIG_FB_WRITE_ENABLE |
+		PM2F_CONFIG_FB_READ_SOURCE_ENABLE);
+	pm2_WR(par, PM2R_FB_PIXEL_OFFSET, 0);
+	if (copy)
+		pm2_WR(par, PM2R_FB_SOURCE_DELTA,
+			((ysrc-y) & 0xfff) << 16 | ((xsrc-x) & 0xfff));
+	else
+		pm2_WR(par, PM2R_FB_BLOCK_COLOR, color);
+	pm2_WR(par, PM2R_RECTANGLE_ORIGIN, (y << 16) | x);
+	pm2_WR(par, PM2R_RECTANGLE_SIZE, (h << 16) | w);
+	wmb();
+	pm2_WR(par, PM2R_RENDER,PM2F_RENDER_RECTANGLE |
+				(x<xsrc ? PM2F_INCREASE_X : 0) |
+				(y<ysrc ? PM2F_INCREASE_Y : 0) |
+				(copy ? 0 : PM2F_RENDER_FASTFILL));
+	wait_pm2(par);
+}
+
+static void pm2fb_fillrect (struct fb_info *info,
+				const struct fb_fillrect *region)
+{
+	struct pm2fb_par *par = info->par;
+	struct fb_fillrect modded;
+	int vxres, vyres;
+	u32 color = (info->fix.visual == FB_VISUAL_TRUECOLOR) ?
+		((u32*)info->pseudo_palette)[region->color] : region->color;
+
+	if (info->state != FBINFO_STATE_RUNNING)
+		return;
+	if ((info->flags & FBINFO_HWACCEL_DISABLED) ||
+		region->rop != ROP_COPY ) {
+		cfb_fillrect(info, region);
+		return;
+	}
+
+	vxres = info->var.xres_virtual;
+	vyres = info->var.yres_virtual;
+
+	memcpy(&modded, region, sizeof(struct fb_fillrect));
+
+	if(!modded.width || !modded.height ||
+	   modded.dx >= vxres || modded.dy >= vyres)
+		return;
+
+	if(modded.dx + modded.width  > vxres)
+		modded.width  = vxres - modded.dx;
+	if(modded.dy + modded.height > vyres)
+		modded.height = vyres - modded.dy;
+
+	if(info->var.bits_per_pixel == 8)
+		color |= color << 8;
+	if(info->var.bits_per_pixel <= 16)
+		color |= color << 16;
+
+	if(info->var.bits_per_pixel != 24)
+		pm2fb_block_op(par, 0, 0, 0,
+				modded.dx, modded.dy,
+				modded.width, modded.height, color);
+	else
+		cfb_fillrect(info, region);
+}
+
+static void pm2fb_copyarea(struct fb_info *info,
+				const struct fb_copyarea *area)
+{
+	struct pm2fb_par *par = info->par;
+	struct fb_copyarea modded;
+	u32 vxres, vyres;
+
+	if (info->state != FBINFO_STATE_RUNNING)
+		return;
+	if (info->flags & FBINFO_HWACCEL_DISABLED) {
+		cfb_copyarea(info, area);
+		return;
+	}
+
+	memcpy(&modded, area, sizeof(struct fb_copyarea));
+
+	vxres = info->var.xres_virtual;
+	vyres = info->var.yres_virtual;
+
+	if(!modded.width || !modded.height ||
+	   modded.sx >= vxres || modded.sy >= vyres ||
+	   modded.dx >= vxres || modded.dy >= vyres)
+		return;
+
+	if(modded.sx + modded.width > vxres)
+		modded.width = vxres - modded.sx;
+	if(modded.dx + modded.width > vxres)
+		modded.width = vxres - modded.dx;
+	if(modded.sy + modded.height > vyres)
+		modded.height = vyres - modded.sy;
+	if(modded.dy + modded.height > vyres)
+		modded.height = vyres - modded.dy;
+
+	pm2fb_block_op(par, 1, modded.sx, modded.sy,
+			modded.dx, modded.dy,
+			modded.width, modded.height, 0);
+}
+
 /* ------------ Hardware Independent Functions ------------ */
 
 /*
@@ -1054,8 +1176,8 @@ static struct fb_ops pm2fb_ops = {
 	.fb_setcolreg	= pm2fb_setcolreg,
 	.fb_blank	= pm2fb_blank,
 	.fb_pan_display	= pm2fb_pan_display,
-	.fb_fillrect	= cfb_fillrect,
-	.fb_copyarea	= cfb_copyarea,
+	.fb_fillrect	= pm2fb_fillrect,
+	.fb_copyarea	= pm2fb_copyarea,
 	.fb_imageblit	= cfb_imageblit,
 };
 
@@ -1204,7 +1326,9 @@ static int __devinit pm2fb_probe(struct 
 	info->fix		= pm2fb_fix; 	
 	info->pseudo_palette	= default_par->palette;
 	info->flags		= FBINFO_DEFAULT |
-                                  FBINFO_HWACCEL_YPAN;
+                                  FBINFO_HWACCEL_YPAN |
+	                          FBINFO_HWACCEL_COPYAREA |
+	                          FBINFO_HWACCEL_FILLRECT;
 
 	if (!mode)
 		mode = "640x480@60";
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

skeletonfb-various-corrections.patch
pm2fb-3dlabs-permedia-2v-reference-board-added.patch
pm2fb-permedia-2v-memory-clock-setting.patch
pm2fb-pixclock-setting-restriction.patch
pm2fb-reset-transparency-settings.patch
pm2fb-memclock-setting-corrections.patch
pm2fb-accelerated-fillrect-and-copyarea.patch
skeletonfb-more-corrections.patch
pm2fb-removal-of-pm2fb_par-fields.patch
skeletonfb-improvements.patch
pm2fb-fix-of-jumps-in-pm2fb_probe.patch
