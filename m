From: akpm@linux-foundation.org
Subject: + radeonfb-accelerate-imageblit-and-other-improvements.patch added to -mm tree
Date: Fri, 05 Sep 2008 15:38:41 -0700
Message-ID: <200809052238.m85Mcf01023732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848AbYIEWis (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2008 18:38:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, davem@davemloft.net, khc@pm.waw.pl


The patch titled
     radeonfb: accelerate imageblit and other improvements
has been added to the -mm tree.  Its filename is
     radeonfb-accelerate-imageblit-and-other-improvements.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radeonfb: accelerate imageblit and other improvements
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Implement support for HW color expansion of 1bpp images, along with some
improvements to the FIFO handling and other accel operations.

The offset fixup code is now unnecessary as the fbcon core will call our
set_par upon switch back from KD_GRAPHICS before anything else happens.  I
removed it as it would slow down accel operations.

The fifo wait has been improved to avoid hitting the HW register as often,
and the various accel ops are now performing better caching of register
values.

Overall, this improve accel performances.  The imageblit acceleration does
result in a small overall regression in performances on some machines (on
the order of 5% on some x86), probably becaus the SW path provides a
better bus utilisation, but I decided to ingnore that as the performances
is still very good, and on the other hand, some machines such as some
sparc64 get a 3 fold performance improvement.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_accel.c     |  287 +++++++++++++++++--------
 drivers/video/aty/radeon_backlight.c |    2 
 drivers/video/aty/radeon_base.c      |   22 -
 drivers/video/aty/radeon_pm.c        |    6 
 drivers/video/aty/radeonfb.h         |   38 +--
 include/video/radeon.h               |   18 +
 6 files changed, 248 insertions(+), 125 deletions(-)

diff -puN drivers/video/aty/radeon_accel.c~radeonfb-accelerate-imageblit-and-other-improvements drivers/video/aty/radeon_accel.c
--- a/drivers/video/aty/radeon_accel.c~radeonfb-accelerate-imageblit-and-other-improvements
+++ a/drivers/video/aty/radeon_accel.c
@@ -5,61 +5,61 @@
  * --dte
  */
 
-static void radeon_fixup_offset(struct radeonfb_info *rinfo)
-{
-	u32 local_base;
+#define FLUSH_CACHE_WORKAROUND	1
 
-	/* *** Ugly workaround *** */
-	/*
-	 * On some platforms, the video memory is mapped at 0 in radeon chip space
-	 * (like PPCs) by the firmware. X will always move it up so that it's seen
-	 * by the chip to be at the same address as the PCI BAR.
-	 * That means that when switching back from X, there is a mismatch between
-	 * the offsets programmed into the engine. This means that potentially,
-	 * accel operations done before radeonfb has a chance to re-init the engine
-	 * will have incorrect offsets, and potentially trash system memory !
-	 *
-	 * The correct fix is for fbcon to never call any accel op before the engine
-	 * has properly been re-initialized (by a call to set_var), but this is a
-	 * complex fix. This workaround in the meantime, called before every accel
-	 * operation, makes sure the offsets are in sync.
-	 */
+void radeon_fifo_update_and_wait(struct radeonfb_info *rinfo, int entries)
+{
+	int i;
 
-	radeon_fifo_wait (1);
-	local_base = INREG(MC_FB_LOCATION) << 16;
-	if (local_base == rinfo->fb_local_base)
-		return;
+	for (i=0; i<2000000; i++) {
+		rinfo->fifo_free = INREG(RBBM_STATUS) & 0x7f;
+		if (rinfo->fifo_free >= entries)
+			return;
+		udelay(10);
+	}
+	printk(KERN_ERR "radeonfb: FIFO Timeout !\n");
+	/* XXX Todo: attempt to reset the engine */
+}
 
-	rinfo->fb_local_base = local_base;
+static inline void radeon_fifo_wait(struct radeonfb_info *rinfo, int entries)
+{
+	if (entries <= rinfo->fifo_free)
+		rinfo->fifo_free -= entries;
+	else
+		radeon_fifo_update_and_wait(rinfo, entries);
+}
 
-	radeon_fifo_wait (3);
-	OUTREG(DEFAULT_PITCH_OFFSET, (rinfo->pitch << 0x16) |
-				     (rinfo->fb_local_base >> 10));
-	OUTREG(DST_PITCH_OFFSET, (rinfo->pitch << 0x16) | (rinfo->fb_local_base >> 10));
-	OUTREG(SRC_PITCH_OFFSET, (rinfo->pitch << 0x16) | (rinfo->fb_local_base >> 10));
+static inline void radeonfb_set_creg(struct radeonfb_info *rinfo, u32 reg,
+				     u32 *cache, u32 new_val)
+{
+	if (new_val == *cache)
+		return;
+	*cache = new_val;
+	radeon_fifo_wait(rinfo, 1);
+	OUTREG(reg, new_val);
 }
 
 static void radeonfb_prim_fillrect(struct radeonfb_info *rinfo, 
 				   const struct fb_fillrect *region)
 {
-	radeon_fifo_wait(4);  
-  
-	OUTREG(DP_GUI_MASTER_CNTL,  
-		rinfo->dp_gui_master_cntl  /* contains, like GMC_DST_32BPP */
-                | GMC_BRUSH_SOLID_COLOR
-                | ROP3_P);
-	if (radeon_get_dstbpp(rinfo->depth) != DST_8BPP)
-		OUTREG(DP_BRUSH_FRGD_CLR, rinfo->pseudo_palette[region->color]);
-	else
-		OUTREG(DP_BRUSH_FRGD_CLR, region->color);
-	OUTREG(DP_WRITE_MSK, 0xffffffff);
-	OUTREG(DP_CNTL, (DST_X_LEFT_TO_RIGHT | DST_Y_TOP_TO_BOTTOM));
+	radeonfb_set_creg(rinfo, DP_GUI_MASTER_CNTL, &rinfo->dp_gui_mc_cache,
+			  rinfo->dp_gui_mc_base | GMC_BRUSH_SOLID_COLOR | ROP3_P);
+	radeonfb_set_creg(rinfo, DP_CNTL, &rinfo->dp_cntl_cache,
+			  DST_X_LEFT_TO_RIGHT | DST_Y_TOP_TO_BOTTOM);
+	radeonfb_set_creg(rinfo, DP_BRUSH_FRGD_CLR, &rinfo->dp_brush_fg_cache,
+			  region->color);
 
-	radeon_fifo_wait(2);
+	/* Ensure the dst cache is flushed and the engine idle before
+	 * issuing the operation.
+	 *
+	 * This works around engine lockups on some cards
+	 */
+#if FLUSH_CACHE_WORKAROUND
+	radeon_fifo_wait(rinfo, 2);
 	OUTREG(DSTCACHE_CTLSTAT, RB2D_DC_FLUSH_ALL);
 	OUTREG(WAIT_UNTIL, (WAIT_2D_IDLECLEAN | WAIT_DMA_GUI_IDLE));
-
-	radeon_fifo_wait(2);  
+#endif
+	radeon_fifo_wait(rinfo, 2);
 	OUTREG(DST_Y_X, (region->dy << 16) | region->dx);
 	OUTREG(DST_WIDTH_HEIGHT, (region->width << 16) | region->height);
 }
@@ -70,15 +70,14 @@ void radeonfb_fillrect(struct fb_info *i
 	struct fb_fillrect modded;
 	int vxres, vyres;
   
-	if (info->state != FBINFO_STATE_RUNNING)
+	WARN_ON(rinfo->gfx_mode);
+	if (info->state != FBINFO_STATE_RUNNING || rinfo->gfx_mode)
 		return;
 	if (info->flags & FBINFO_HWACCEL_DISABLED) {
 		cfb_fillrect(info, region);
 		return;
 	}
 
-	radeon_fixup_offset(rinfo);
-
 	vxres = info->var.xres_virtual;
 	vyres = info->var.yres_virtual;
 
@@ -91,6 +90,10 @@ void radeonfb_fillrect(struct fb_info *i
 	if(modded.dx + modded.width  > vxres) modded.width  = vxres - modded.dx;
 	if(modded.dy + modded.height > vyres) modded.height = vyres - modded.dy;
 
+	if (info->fix.visual == FB_VISUAL_TRUECOLOR ||
+	    info->fix.visual == FB_VISUAL_DIRECTCOLOR )
+		modded.color = ((u32 *) (info->pseudo_palette))[region->color];
+
 	radeonfb_prim_fillrect(rinfo, &modded);
 }
 
@@ -109,22 +112,22 @@ static void radeonfb_prim_copyarea(struc
 	if ( xdir < 0 ) { sx += w-1; dx += w-1; }
 	if ( ydir < 0 ) { sy += h-1; dy += h-1; }
 
-	radeon_fifo_wait(3);
-	OUTREG(DP_GUI_MASTER_CNTL,
-		rinfo->dp_gui_master_cntl /* i.e. GMC_DST_32BPP */
-		| GMC_BRUSH_NONE
-		| GMC_SRC_DSTCOLOR
-		| ROP3_S 
-		| DP_SRC_SOURCE_MEMORY );
-	OUTREG(DP_WRITE_MSK, 0xffffffff);
-	OUTREG(DP_CNTL, (xdir>=0 ? DST_X_LEFT_TO_RIGHT : 0)
-			| (ydir>=0 ? DST_Y_TOP_TO_BOTTOM : 0));
+	radeonfb_set_creg(rinfo, DP_GUI_MASTER_CNTL, &rinfo->dp_gui_mc_cache,
+			  rinfo->dp_gui_mc_base |
+			  GMC_BRUSH_NONE |
+			  GMC_SRC_DATATYPE_COLOR |
+			  ROP3_S |
+			  DP_SRC_SOURCE_MEMORY);
+	radeonfb_set_creg(rinfo, DP_CNTL, &rinfo->dp_cntl_cache,
+			  (xdir>=0 ? DST_X_LEFT_TO_RIGHT : 0) |
+			  (ydir>=0 ? DST_Y_TOP_TO_BOTTOM : 0));
 
-	radeon_fifo_wait(2);
+#if FLUSH_CACHE_WORKAROUND
+	radeon_fifo_wait(rinfo, 2);
 	OUTREG(DSTCACHE_CTLSTAT, RB2D_DC_FLUSH_ALL);
 	OUTREG(WAIT_UNTIL, (WAIT_2D_IDLECLEAN | WAIT_DMA_GUI_IDLE));
-
-	radeon_fifo_wait(3);
+#endif
+	radeon_fifo_wait(rinfo, 3);
 	OUTREG(SRC_Y_X, (sy << 16) | sx);
 	OUTREG(DST_Y_X, (dy << 16) | dx);
 	OUTREG(DST_HEIGHT_WIDTH, (h << 16) | w);
@@ -143,15 +146,14 @@ void radeonfb_copyarea(struct fb_info *i
 	modded.width  = area->width;
 	modded.height = area->height;
   
-	if (info->state != FBINFO_STATE_RUNNING)
+	WARN_ON(rinfo->gfx_mode);
+	if (info->state != FBINFO_STATE_RUNNING || rinfo->gfx_mode)
 		return;
 	if (info->flags & FBINFO_HWACCEL_DISABLED) {
 		cfb_copyarea(info, area);
 		return;
 	}
 
-	radeon_fixup_offset(rinfo);
-
 	vxres = info->var.xres_virtual;
 	vyres = info->var.yres_virtual;
 
@@ -168,13 +170,112 @@ void radeonfb_copyarea(struct fb_info *i
 	radeonfb_prim_copyarea(rinfo, &modded);
 }
 
+static void radeonfb_prim_imageblit(struct radeonfb_info *rinfo,
+				    const struct fb_image *image,
+				    u32 fg, u32 bg)
+{
+	unsigned int src_bytes, dwords;
+	u32 *bits;
+
+	radeonfb_set_creg(rinfo, DP_GUI_MASTER_CNTL, &rinfo->dp_gui_mc_cache,
+			  rinfo->dp_gui_mc_base |
+			  GMC_BRUSH_NONE |
+			  GMC_SRC_DATATYPE_MONO_FG_BG |
+			  ROP3_S |
+			  GMC_BYTE_ORDER_MSB_TO_LSB |
+			  DP_SRC_SOURCE_HOST_DATA);
+	radeonfb_set_creg(rinfo, DP_CNTL, &rinfo->dp_cntl_cache,
+			  DST_X_LEFT_TO_RIGHT | DST_Y_TOP_TO_BOTTOM);
+	radeonfb_set_creg(rinfo, DP_SRC_FRGD_CLR, &rinfo->dp_src_fg_cache, fg);
+	radeonfb_set_creg(rinfo, DP_SRC_BKGD_CLR, &rinfo->dp_src_bg_cache, bg);
+
+	radeon_fifo_wait(rinfo, 1);
+	OUTREG(DST_Y_X, (image->dy << 16) | image->dx);
+
+	/* Ensure the dst cache is flushed and the engine idle before
+	 * issuing the operation.
+	 *
+	 * This works around engine lockups on some cards
+	 */
+#if FLUSH_CACHE_WORKAROUND
+	radeon_fifo_wait(rinfo, 2);
+	OUTREG(DSTCACHE_CTLSTAT, RB2D_DC_FLUSH_ALL);
+	OUTREG(WAIT_UNTIL, (WAIT_2D_IDLECLEAN | WAIT_DMA_GUI_IDLE));
+#endif
+
+	/* X here pads width to a multiple of 32 and uses the clipper to
+	 * adjust the result. Is that really necessary ? Things seem to
+	 * work ok for me without that and the doco doesn't seem to imply
+	 * there is such a restriction.
+	 */
+	OUTREG(DST_WIDTH_HEIGHT, (image->width << 16) | image->height);
+
+	src_bytes = (((image->width * image->depth) + 7) / 8) * image->height;
+	dwords = (src_bytes + 3) / 4;
+	bits = (u32*)(image->data);
+
+	while(dwords >= 8) {
+		radeon_fifo_wait(rinfo, 8);
+#if BITS_PER_LONG == 64
+		__raw_writeq(*((u64 *)(bits)), rinfo->mmio_base + HOST_DATA0);
+		__raw_writeq(*((u64 *)(bits+2)), rinfo->mmio_base + HOST_DATA2);
+		__raw_writeq(*((u64 *)(bits+4)), rinfo->mmio_base + HOST_DATA4);
+		__raw_writeq(*((u64 *)(bits+6)), rinfo->mmio_base + HOST_DATA6);
+		bits += 8;
+#else
+		__raw_writel(*(bits++), rinfo->mmio_base + HOST_DATA0);
+		__raw_writel(*(bits++), rinfo->mmio_base + HOST_DATA1);
+		__raw_writel(*(bits++), rinfo->mmio_base + HOST_DATA2);
+		__raw_writel(*(bits++), rinfo->mmio_base + HOST_DATA3);
+		__raw_writel(*(bits++), rinfo->mmio_base + HOST_DATA4);
+		__raw_writel(*(bits++), rinfo->mmio_base + HOST_DATA5);
+		__raw_writel(*(bits++), rinfo->mmio_base + HOST_DATA6);
+		__raw_writel(*(bits++), rinfo->mmio_base + HOST_DATA7);
+#endif
+		dwords -= 8;
+	}
+	while(dwords--) {
+		radeon_fifo_wait(rinfo, 1);
+		__raw_writel(*(bits++), rinfo->mmio_base + HOST_DATA0);
+	}
+}
+
 void radeonfb_imageblit(struct fb_info *info, const struct fb_image *image)
 {
 	struct radeonfb_info *rinfo = info->par;
+	u32 fg, bg;
 
-	if (info->state != FBINFO_STATE_RUNNING)
+	WARN_ON(rinfo->gfx_mode);
+	if (info->state != FBINFO_STATE_RUNNING || rinfo->gfx_mode)
+		return;
+
+	if (!image->width || !image->height)
 		return;
-	radeon_engine_idle();
+
+	/* We only do 1 bpp color expansion for now */
+	if (info->flags & FBINFO_HWACCEL_DISABLED || image->depth != 1)
+		goto fallback;
+
+	/* Fallback if running out of the screen. We may do clipping
+	 * in the future */
+	if ((image->dx + image->width) > info->var.xres_virtual ||
+	    (image->dy + image->height) > info->var.yres_virtual)
+		goto fallback;
+
+	if (info->fix.visual == FB_VISUAL_TRUECOLOR ||
+	    info->fix.visual == FB_VISUAL_DIRECTCOLOR) {
+		fg = ((u32*)(info->pseudo_palette))[image->fg_color];
+		bg = ((u32*)(info->pseudo_palette))[image->bg_color];
+	} else {
+		fg = image->fg_color;
+		bg = image->bg_color;
+	}
+
+	radeonfb_prim_imageblit(rinfo, image, fg, bg);
+	return;
+
+ fallback:
+	radeon_engine_idle(rinfo);
 
 	cfb_imageblit(info, image);
 }
@@ -185,7 +286,8 @@ int radeonfb_sync(struct fb_info *info)
 
 	if (info->state != FBINFO_STATE_RUNNING)
 		return 0;
-	radeon_engine_idle();
+
+	radeon_engine_idle(rinfo);
 
 	return 0;
 }
@@ -261,9 +363,10 @@ void radeonfb_engine_init (struct radeon
 	/* disable 3D engine */
 	OUTREG(RB3D_CNTL, 0);
 
+	rinfo->fifo_free = 0;
 	radeonfb_engine_reset(rinfo);
 
-	radeon_fifo_wait (1);
+	radeon_fifo_wait(rinfo, 1);
 	if (IS_R300_VARIANT(rinfo)) {
 		OUTREG(RB2D_DSTCACHE_MODE, INREG(RB2D_DSTCACHE_MODE) |
 		       RB2D_DC_AUTOFLUSH_ENABLE |
@@ -277,7 +380,7 @@ void radeonfb_engine_init (struct radeon
 		OUTREG(RB2D_DSTCACHE_MODE, 0);
 	}
 
-	radeon_fifo_wait (3);
+	radeon_fifo_wait(rinfo, 3);
 	/* We re-read MC_FB_LOCATION from card as it can have been
 	 * modified by XFree drivers (ouch !)
 	 */
@@ -288,41 +391,57 @@ void radeonfb_engine_init (struct radeon
 	OUTREG(DST_PITCH_OFFSET, (rinfo->pitch << 0x16) | (rinfo->fb_local_base >> 10));
 	OUTREG(SRC_PITCH_OFFSET, (rinfo->pitch << 0x16) | (rinfo->fb_local_base >> 10));
 
-	radeon_fifo_wait (1);
-#if defined(__BIG_ENDIAN)
+	radeon_fifo_wait(rinfo, 1);
+#ifdef __BIG_ENDIAN
 	OUTREGP(DP_DATATYPE, HOST_BIG_ENDIAN_EN, ~HOST_BIG_ENDIAN_EN);
 #else
 	OUTREGP(DP_DATATYPE, 0, ~HOST_BIG_ENDIAN_EN);
 #endif
-	radeon_fifo_wait (2);
+	radeon_fifo_wait(rinfo, 2);
 	OUTREG(DEFAULT_SC_TOP_LEFT, 0);
 	OUTREG(DEFAULT_SC_BOTTOM_RIGHT, (DEFAULT_SC_RIGHT_MAX |
 					 DEFAULT_SC_BOTTOM_MAX));
 
+	/* set default DP_GUI_MASTER_CNTL */
 	temp = radeon_get_dstbpp(rinfo->depth);
-	rinfo->dp_gui_master_cntl = ((temp << 8) | GMC_CLR_CMP_CNTL_DIS);
+	rinfo->dp_gui_mc_base = ((temp << 8) | GMC_CLR_CMP_CNTL_DIS);
 
-	radeon_fifo_wait (1);
-	OUTREG(DP_GUI_MASTER_CNTL, (rinfo->dp_gui_master_cntl |
-				    GMC_BRUSH_SOLID_COLOR |
-				    GMC_SRC_DATATYPE_COLOR));
+	rinfo->dp_gui_mc_cache = rinfo->dp_gui_mc_base |
+		GMC_BRUSH_SOLID_COLOR |
+		GMC_SRC_DATATYPE_COLOR;
+	radeon_fifo_wait(rinfo, 1);
+	OUTREG(DP_GUI_MASTER_CNTL, rinfo->dp_gui_mc_cache);
 
-	radeon_fifo_wait (7);
 
 	/* clear line drawing regs */
+	radeon_fifo_wait(rinfo, 2);
 	OUTREG(DST_LINE_START, 0);
 	OUTREG(DST_LINE_END, 0);
 
-	/* set brush color regs */
-	OUTREG(DP_BRUSH_FRGD_CLR, 0xffffffff);
-	OUTREG(DP_BRUSH_BKGD_CLR, 0x00000000);
-
-	/* set source color regs */
-	OUTREG(DP_SRC_FRGD_CLR, 0xffffffff);
-	OUTREG(DP_SRC_BKGD_CLR, 0x00000000);
+	/* set brush and source color regs */
+	rinfo->dp_brush_fg_cache = 0xffffffff;
+	rinfo->dp_brush_bg_cache = 0x00000000;
+	rinfo->dp_src_fg_cache = 0xffffffff;
+	rinfo->dp_src_bg_cache = 0x00000000;
+	radeon_fifo_wait(rinfo, 4);
+	OUTREG(DP_BRUSH_FRGD_CLR, rinfo->dp_brush_fg_cache);
+	OUTREG(DP_BRUSH_BKGD_CLR, rinfo->dp_brush_bg_cache);
+	OUTREG(DP_SRC_FRGD_CLR, rinfo->dp_src_fg_cache);
+	OUTREG(DP_SRC_BKGD_CLR, rinfo->dp_src_bg_cache);
+
+	/* Default direction */
+	rinfo->dp_cntl_cache = DST_X_LEFT_TO_RIGHT | DST_Y_TOP_TO_BOTTOM;
+	radeon_fifo_wait(rinfo, 1);
+	OUTREG(DP_CNTL, rinfo->dp_cntl_cache);
 
 	/* default write mask */
+	radeon_fifo_wait(rinfo, 1);
 	OUTREG(DP_WRITE_MSK, 0xffffffff);
 
-	radeon_engine_idle ();
+	/* Default to no swapping of host data */
+	radeon_fifo_wait(rinfo, 1);
+	OUTREG(RBBM_GUICNTL, RBBM_GUICNTL_HOST_DATA_SWAP_NONE);
+
+	/* Make sure it's settled */
+	radeon_engine_idle(rinfo);
 }
diff -puN drivers/video/aty/radeon_backlight.c~radeonfb-accelerate-imageblit-and-other-improvements drivers/video/aty/radeon_backlight.c
--- a/drivers/video/aty/radeon_backlight.c~radeonfb-accelerate-imageblit-and-other-improvements
+++ a/drivers/video/aty/radeon_backlight.c
@@ -66,7 +66,7 @@ static int radeon_bl_update_status(struc
 		level = bd->props.brightness;
 
 	del_timer_sync(&rinfo->lvds_timer);
-	radeon_engine_idle();
+	radeon_engine_idle(rinfo);
 
 	lvds_gen_cntl = INREG(LVDS_GEN_CNTL);
 	if (level > 0) {
diff -puN drivers/video/aty/radeon_base.c~radeonfb-accelerate-imageblit-and-other-improvements drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~radeonfb-accelerate-imageblit-and-other-improvements
+++ a/drivers/video/aty/radeon_base.c
@@ -852,7 +852,6 @@ static int radeonfb_pan_display (struct 
         if (rinfo->asleep)
         	return 0;
 
-	radeon_fifo_wait(2);
         OUTREG(CRTC_OFFSET, ((var->yoffset * var->xres_virtual + var->xoffset)
 			     * var->bits_per_pixel / 8) & ~7);
         return 0;
@@ -882,7 +881,6 @@ static int radeonfb_ioctl (struct fb_inf
 			if (rc)
 				return rc;
 
-			radeon_fifo_wait(2);
 			if (value & 0x01) {
 				tmp = INREG(LVDS_GEN_CNTL);
 
@@ -940,7 +938,7 @@ int radeon_screen_blank(struct radeonfb_
 	if (rinfo->lock_blank)
 		return 0;
 
-	radeon_engine_idle();
+	radeon_engine_idle(rinfo);
 
 	val = INREG(CRTC_EXT_CNTL);
         val &= ~(CRTC_DISPLAY_DIS | CRTC_HSYNC_DIS |
@@ -1048,7 +1046,7 @@ static int radeonfb_blank (int blank, st
 
 	if (rinfo->asleep)
 		return 0;
-		
+
 	return radeon_screen_blank(rinfo, blank, 0);
 }
 
@@ -1074,8 +1072,6 @@ static int radeon_setcolreg (unsigned re
         pindex = regno;
 
         if (!rinfo->asleep) {
-		radeon_fifo_wait(9);
-
 		if (rinfo->bpp == 16) {
 			pindex = regno * 8;
 
@@ -1244,8 +1240,6 @@ static void radeon_write_pll_regs(struct
 {
 	int i;
 
-	radeon_fifo_wait(20);
-
 	/* Workaround from XFree */
 	if (rinfo->is_mobility) {
 	        /* A temporal workaround for the occational blanking on certain laptop
@@ -1341,7 +1335,7 @@ static void radeon_lvds_timer_func(unsig
 {
 	struct radeonfb_info *rinfo = (struct radeonfb_info *)data;
 
-	radeon_engine_idle();
+	radeon_engine_idle(rinfo);
 
 	OUTREG(LVDS_GEN_CNTL, rinfo->pending_lvds_gen_cntl);
 }
@@ -1359,10 +1353,11 @@ void radeon_write_mode (struct radeonfb_
 	if (nomodeset)
 		return;
 
+	radeon_engine_idle(rinfo);
+
 	if (!regs_only)
 		radeon_screen_blank(rinfo, FB_BLANK_NORMAL, 0);
 
-	radeon_fifo_wait(31);
 	for (i=0; i<10; i++)
 		OUTREG(common_regs[i].reg, common_regs[i].val);
 
@@ -1390,7 +1385,6 @@ void radeon_write_mode (struct radeonfb_
 	radeon_write_pll_regs(rinfo, mode);
 
 	if ((primary_mon == MT_DFP) || (primary_mon == MT_LCD)) {
-		radeon_fifo_wait(10);
 		OUTREG(FP_CRTC_H_TOTAL_DISP, mode->fp_crtc_h_total_disp);
 		OUTREG(FP_CRTC_V_TOTAL_DISP, mode->fp_crtc_v_total_disp);
 		OUTREG(FP_H_SYNC_STRT_WID, mode->fp_h_sync_strt_wid);
@@ -1405,7 +1399,6 @@ void radeon_write_mode (struct radeonfb_
 	if (!regs_only)
 		radeon_screen_blank(rinfo, FB_BLANK_UNBLANK, 0);
 
-	radeon_fifo_wait(2);
 	OUTPLL(VCLK_ECP_CNTL, mode->vclk_ecp_cntl);
 	
 	return;
@@ -1556,7 +1549,7 @@ static int radeonfb_set_par(struct fb_in
 	/* We always want engine to be idle on a mode switch, even
 	 * if we won't actually change the mode
 	 */
-	radeon_engine_idle();
+	radeon_engine_idle(rinfo);
 
 	hSyncStart = mode->xres + mode->right_margin;
 	hSyncEnd = hSyncStart + mode->hsync_len;
@@ -1851,7 +1844,6 @@ static int radeonfb_set_par(struct fb_in
 	return 0;
 }
 
-
 static struct fb_ops radeonfb_ops = {
 	.owner			= THIS_MODULE,
 	.fb_check_var		= radeonfb_check_var,
@@ -1875,6 +1867,7 @@ static int __devinit radeon_set_fbinfo (
 	info->par = rinfo;
 	info->pseudo_palette = rinfo->pseudo_palette;
 	info->flags = FBINFO_DEFAULT
+		    | FBINFO_HWACCEL_IMAGEBLIT
 		    | FBINFO_HWACCEL_COPYAREA
 		    | FBINFO_HWACCEL_FILLRECT
 		    | FBINFO_HWACCEL_XPAN
@@ -2006,7 +1999,6 @@ static void radeon_identify_vram(struct 
           u32 tom = INREG(NB_TOM);
           tmp = ((((tom >> 16) - (tom & 0xffff) + 1) << 6) * 1024);
 
- 		radeon_fifo_wait(6);
           OUTREG(MC_FB_LOCATION, tom);
           OUTREG(DISPLAY_BASE_ADDR, (tom & 0xffff) << 16);
           OUTREG(CRTC2_DISPLAY_BASE_ADDR, (tom & 0xffff) << 16);
diff -puN drivers/video/aty/radeon_pm.c~radeonfb-accelerate-imageblit-and-other-improvements drivers/video/aty/radeon_pm.c
--- a/drivers/video/aty/radeon_pm.c~radeonfb-accelerate-imageblit-and-other-improvements
+++ a/drivers/video/aty/radeon_pm.c
@@ -2653,9 +2653,9 @@ int radeonfb_pci_suspend(struct pci_dev 
 
 	if (!(info->flags & FBINFO_HWACCEL_DISABLED)) {
 		/* Make sure engine is reset */
-		radeon_engine_idle();
+		radeon_engine_idle(rinfo);
 		radeonfb_engine_reset(rinfo);
-		radeon_engine_idle();
+		radeon_engine_idle(rinfo);
 	}
 
 	/* Blank display and LCD */
@@ -2767,7 +2767,7 @@ int radeonfb_pci_resume(struct pci_dev *
 
 		rinfo->asleep = 0;
 	} else
-		radeon_engine_idle();
+		radeon_engine_idle(rinfo);
 
 	/* Restore display & engine */
 	radeon_write_mode (rinfo, &rinfo->state, 1);
diff -puN drivers/video/aty/radeonfb.h~radeonfb-accelerate-imageblit-and-other-improvements drivers/video/aty/radeonfb.h
--- a/drivers/video/aty/radeonfb.h~radeonfb-accelerate-imageblit-and-other-improvements
+++ a/drivers/video/aty/radeonfb.h
@@ -336,7 +336,15 @@ struct radeonfb_info {
 	int			mon2_type;
 	u8		        *mon2_EDID;
 
-	u32			dp_gui_master_cntl;
+	/* accel bits */
+	u32			dp_gui_mc_base;
+	u32			dp_gui_mc_cache;
+	u32			dp_cntl_cache;
+	u32			dp_brush_fg_cache;
+	u32			dp_brush_bg_cache;
+	u32			dp_src_fg_cache;
+	u32			dp_src_bg_cache;
+	u32			fifo_free;
 
 	struct pll_info		pll;
 
@@ -348,6 +356,7 @@ struct radeonfb_info {
 	int			lock_blank;
 	int			dynclk;
 	int			no_schedule;
+	int 			gfx_mode;
 	enum radeon_pm_mode	pm_mode;
 	reinit_function_ptr     reinit_func;
 
@@ -392,8 +401,14 @@ static inline void _radeon_msleep(struct
 #define OUTREG8(addr,val)	writeb(val, (rinfo->mmio_base)+addr)
 #define INREG16(addr)		readw((rinfo->mmio_base)+addr)
 #define OUTREG16(addr,val)	writew(val, (rinfo->mmio_base)+addr)
+
+#ifdef CONFIG_PPC
+#define INREG(addr)	     	({ eieio(); ld_le32(rinfo->mmio_base+(addr)); })
+#define OUTREG(addr,val)	do { eieio(); st_le32(rinfo->mmio_base+(addr),(val)); } while(0)
+#else
 #define INREG(addr)		readl((rinfo->mmio_base)+addr)
 #define OUTREG(addr,val)	writel(val, (rinfo->mmio_base)+addr)
+#endif
 
 static inline void _OUTREGP(struct radeonfb_info *rinfo, u32 addr,
 		       u32 val, u32 mask)
@@ -535,17 +550,7 @@ static inline u32 radeon_get_dstbpp(u16 
  * 2D Engine helper routines
  */
 
-static inline void _radeon_fifo_wait(struct radeonfb_info *rinfo, int entries)
-{
-	int i;
-
-	for (i=0; i<2000000; i++) {
-		if ((INREG(RBBM_STATUS) & 0x7f) >= entries)
-			return;
-		udelay(1);
-	}
-	printk(KERN_ERR "radeonfb: FIFO Timeout !\n");
-}
+extern void radeon_fifo_update_and_wait(struct radeonfb_info *rinfo, int entries);
 
 static inline void radeon_engine_flush (struct radeonfb_info *rinfo)
 {
@@ -558,7 +563,7 @@ static inline void radeon_engine_flush (
 	/* Ensure FIFO is empty, ie, make sure the flush commands
 	 * has reached the cache
 	 */
-	_radeon_fifo_wait (rinfo, 64);
+	radeon_fifo_update_and_wait(rinfo, 64);
 
 	/* Wait for the flush to complete */
 	for (i=0; i < 2000000; i++) {
@@ -570,12 +575,12 @@ static inline void radeon_engine_flush (
 }
 
 
-static inline void _radeon_engine_idle(struct radeonfb_info *rinfo)
+static inline void radeon_engine_idle(struct radeonfb_info *rinfo)
 {
 	int i;
 
 	/* ensure FIFO is empty before waiting for idle */
-	_radeon_fifo_wait (rinfo, 64);
+	radeon_fifo_update_and_wait (rinfo, 64);
 
 	for (i=0; i<2000000; i++) {
 		if (((INREG(RBBM_STATUS) & GUI_ACTIVE)) == 0) {
@@ -588,8 +593,6 @@ static inline void _radeon_engine_idle(s
 }
 
 
-#define radeon_engine_idle()		_radeon_engine_idle(rinfo)
-#define radeon_fifo_wait(entries)	_radeon_fifo_wait(rinfo,entries)
 #define radeon_msleep(ms)		_radeon_msleep(rinfo,ms)
 
 
@@ -619,6 +622,7 @@ extern void radeonfb_imageblit(struct fb
 extern int radeonfb_sync(struct fb_info *info);
 extern void radeonfb_engine_init (struct radeonfb_info *rinfo);
 extern void radeonfb_engine_reset(struct radeonfb_info *rinfo);
+extern void radeon_fixup_mem_offset(struct radeonfb_info *rinfo);
 
 /* Other functions */
 extern int radeon_screen_blank(struct radeonfb_info *rinfo, int blank, int mode_switch);
diff -puN include/video/radeon.h~radeonfb-accelerate-imageblit-and-other-improvements include/video/radeon.h
--- a/include/video/radeon.h~radeonfb-accelerate-imageblit-and-other-improvements
+++ a/include/video/radeon.h
@@ -525,6 +525,9 @@
 #define CRTC_DISPLAY_DIS			   (1 << 10)
 #define CRTC_CRT_ON				   (1 << 15)
 
+/* DSTCACHE_MODE bits constants */
+#define RB2D_DC_AUTOFLUSH_ENABLE                   (1 << 8)
+#define RB2D_DC_DC_DISABLE_IGNORE_PE               (1 << 17)
 
 /* DSTCACHE_CTLSTAT bit constants */
 #define RB2D_DC_FLUSH_2D			   (1 << 0)
@@ -866,15 +869,10 @@
 #define GMC_DST_16BPP_YVYU422                      0x00000c00
 #define GMC_DST_32BPP_AYUV444                      0x00000e00
 #define GMC_DST_16BPP_ARGB4444                     0x00000f00
-#define GMC_SRC_MONO                               0x00000000
-#define GMC_SRC_MONO_LBKGD                         0x00001000
-#define GMC_SRC_DSTCOLOR                           0x00003000
 #define GMC_BYTE_ORDER_MSB_TO_LSB                  0x00000000
 #define GMC_BYTE_ORDER_LSB_TO_MSB                  0x00004000
 #define GMC_DP_CONVERSION_TEMP_9300                0x00008000
 #define GMC_DP_CONVERSION_TEMP_6500                0x00000000
-#define GMC_DP_SRC_RECT                            0x02000000
-#define GMC_DP_SRC_HOST                            0x03000000
 #define GMC_DP_SRC_HOST_BYTEALIGN                  0x04000000
 #define GMC_3D_FCN_EN_CLR                          0x00000000
 #define GMC_3D_FCN_EN_SET                          0x08000000
@@ -885,6 +883,9 @@
 #define GMC_WRITE_MASK_LEAVE                       0x00000000
 #define GMC_WRITE_MASK_SET                         0x40000000
 #define GMC_CLR_CMP_CNTL_DIS      		   (1 << 28)
+#define GMC_SRC_DATATYPE_MASK			   (3 << 12)
+#define GMC_SRC_DATATYPE_MONO_FG_BG		   (0 << 12)
+#define GMC_SRC_DATATYPE_MONO_FG_LA		   (1 << 12)
 #define GMC_SRC_DATATYPE_COLOR			   (3 << 12)
 #define ROP3_S                			   0x00cc0000
 #define ROP3_SRCCOPY				   0x00cc0000
@@ -893,6 +894,7 @@
 #define DP_SRC_SOURCE_MASK        		   (7    << 24)
 #define GMC_BRUSH_NONE            		   (15   <<  4)
 #define DP_SRC_SOURCE_MEMORY			   (2    << 24)
+#define DP_SRC_SOURCE_HOST_DATA			   (3    << 24)
 #define GMC_BRUSH_SOLIDCOLOR			   0x000000d0
 
 /* DP_MIX bit constants */
@@ -978,6 +980,12 @@
 #define DISP_PWR_MAN_TV_ENABLE_RST                 (1 << 25)
 #define DISP_PWR_MAN_AUTO_PWRUP_EN                 (1 << 26)
 
+/* RBBM_GUICNTL constants */
+#define RBBM_GUICNTL_HOST_DATA_SWAP_NONE	   (0 << 0)
+#define RBBM_GUICNTL_HOST_DATA_SWAP_16BIT          (1 << 0)
+#define RBBM_GUICNTL_HOST_DATA_SWAP_32BIT	   (2 << 0)
+#define RBBM_GUICNTL_HOST_DATA_SWAP_HDW		   (3 << 0)
+
 /* masks */
 
 #define CONFIG_MEMSIZE_MASK		0x1f000000
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
linux-next.patch
powerpc-convert-config_ppc_merge-to-config_ppc-for-legacy-io-checks.patch
pata_sil680-convert-config_ppc_merge-to-config_ppc.patch
fs-enet-remove-code-associated-with-config_ppc_merge.patch
netdev-drop-config_ppc_merge-from-kconfig.patch
usb-remove-code-associated-with-config_ppc_merge.patch
add-phys_addr_t-for-holding-physical-addresses.patch
make-pfn_phys-explicitly-return-phys_addr_t.patch
redefine-resource_size_t-as-phys_addr_t.patch
compat-generic-compat-get-settimeofday.patch
x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
powerpc-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
introduce-generic-iommu_num_pages-function.patch
powerpc-use-iommu_num_pages-function-in-iommu-code.patch
serial-mpc52xx_uart-remove-code-associated-with-config_ppc_merge.patch
mpc52xx_psc_spi-remove-code-associated-with-config_ppc_merge.patch
rtc-use-config_ppc-instead-of-config_ppc_merge.patch
radeonfb-revert-fix-radeon-ddc-regression.patch
radeonfb-misc-cleanup-of-engine-and-dst-cache-handling.patch
radeonfb-accelerate-imageblit-and-other-improvements.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
powerpc-hugetlb-pgtable-cache-access-cleanup.patch

