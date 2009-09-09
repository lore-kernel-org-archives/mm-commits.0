From: akpm@linux-foundation.org
Subject: + viafb-cleanup-viafb_cursor.patch added to -mm tree
Date: Tue, 08 Sep 2009 17:26:28 -0700
Message-ID: <200909090026.n890QTCr031563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819AbZIIA1A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2009 20:27:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: cleanup viafb_cursor
has been added to the -mm tree.  Its filename is
     viafb-cleanup-viafb_cursor.patch

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
Subject: viafb: cleanup viafb_cursor
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Clean the hardware cursor handling up.

The most notable change is that it no longer buffers the values in
viacursor but uses the ones in cursor instead as they are guaranteed to be
always valid.

Furthermore it uses local instead global variables where possible, moves
the cursor variable in shared as only one hardware cursor is supported and
returns an error if memory allocation fails.  Last but not least it fixes
a too small buffer (as u32 has only 4 and not 32 bytes) but this did not
produce any known problems.

This is mostly a code cleanup, no negative runtime changes are expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/accel.c    |    4 
 drivers/video/via/global.c   |    1 
 drivers/video/via/global.h   |    1 
 drivers/video/via/viafbdev.c |  186 +++++++++++----------------------
 drivers/video/via/viafbdev.h |    2 
 5 files changed, 68 insertions(+), 126 deletions(-)

diff -puN drivers/video/via/accel.c~viafb-cleanup-viafb_cursor drivers/video/via/accel.c
--- a/drivers/video/via/accel.c~viafb-cleanup-viafb_cursor
+++ a/drivers/video/via/accel.c
@@ -331,7 +331,7 @@ void viafb_init_accel(struct viafb_share
 	}
 
 	viaparinfo->fbmem_free -= CURSOR_SIZE;
-	viaparinfo->cursor_start = viaparinfo->fbmem_free;
+	shared->cursor_vram_addr = viaparinfo->fbmem_free;
 	viaparinfo->fbmem_used += CURSOR_SIZE;
 
 	/* Reverse 8*1024 memory space for cursor image */
@@ -487,7 +487,7 @@ void viafb_init_2d_engine(void)
 void viafb_hw_cursor_init(void)
 {
 	/* Set Cursor Image Base Address */
-	writel(viaparinfo->cursor_start,
+	writel(viaparinfo->shared->cursor_vram_addr,
 		viaparinfo->io_virt + VIA_REG_CURSOR_MODE);
 	writel(0x0, viaparinfo->io_virt + VIA_REG_CURSOR_POS);
 	writel(0x0, viaparinfo->io_virt + VIA_REG_CURSOR_ORG);
diff -puN drivers/video/via/global.c~viafb-cleanup-viafb_cursor drivers/video/via/global.c
--- a/drivers/video/via/global.c~viafb-cleanup-viafb_cursor
+++ a/drivers/video/via/global.c
@@ -51,7 +51,6 @@ unsigned int viafb_second_yres = 480;
 unsigned int viafb_second_virtual_xres;
 unsigned int viafb_second_virtual_yres;
 int viafb_lcd_panel_id = LCD_PANEL_ID_MAXIMUM + 1;
-struct fb_cursor viacursor;
 struct fb_info *viafbinfo;
 struct fb_info *viafbinfo1;
 struct viafb_par *viaparinfo;
diff -puN drivers/video/via/global.h~viafb-cleanup-viafb_cursor drivers/video/via/global.h
--- a/drivers/video/via/global.h~viafb-cleanup-viafb_cursor
+++ a/drivers/video/via/global.h
@@ -77,7 +77,6 @@ extern int viafb_hotplug_Yres;
 extern int viafb_hotplug_bpp;
 extern int viafb_hotplug_refresh;
 extern int viafb_primary_dev;
-extern struct fb_cursor viacursor;
 
 extern unsigned int viafb_second_xres;
 extern unsigned int viafb_second_yres;
diff -puN drivers/video/via/viafbdev.c~viafb-cleanup-viafb_cursor drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-cleanup-viafb_cursor
+++ a/drivers/video/via/viafbdev.c
@@ -25,7 +25,6 @@
 
 #include "global.h"
 
-static int MAX_CURS = 32;
 static struct fb_var_screeninfo default_var;
 static char *viafb_name = "Via";
 static u32 pseudo_pal[17];
@@ -856,150 +855,99 @@ static void viafb_imageblit(struct fb_in
 
 static int viafb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 {
-	u32 temp, xx, yy, bg_col = 0, fg_col = 0;
-	int i, j = 0;
-	static int hw_cursor;
-	struct viafb_par *p_viafb_par;
-
-	if (viafb_accel)
-		hw_cursor = 1;
-
-	if (!viafb_accel) {
-		if (hw_cursor) {
-			viafb_show_hw_cursor(info, HW_Cursor_OFF);
-			hw_cursor = 0;
-		}
-		return -ENODEV;
-	}
+	struct viafb_par *viapar = info->par;
+	u32 temp, xx, yy, bg_color = 0, fg_color = 0,
+		chip_name = viapar->shared->chip_info.gfx_chip_name;
+	int i, j = 0, cur_size = 64;
 
-	if ((((struct viafb_par *)(info->par))->iga_path == IGA2)
-	    && (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266))
+	if (info->flags & FBINFO_HWACCEL_DISABLED || info != viafbinfo)
 		return -ENODEV;
 
-	/* When duoview and using lcd , use soft cursor */
-	if (viafb_LCD_ON || (!viafb_SAMM_ON &&
-		viafb_LCD2_ON + viafb_DVI_ON + viafb_CRT_ON == 2))
+	if (chip_name == UNICHROME_CLE266 && viapar->iga_path == IGA2)
 		return -ENODEV;
 
 	viafb_show_hw_cursor(info, HW_Cursor_OFF);
-	viacursor = *cursor;
 
 	if (cursor->set & FB_CUR_SETHOT) {
-		viacursor.hot = cursor->hot;
-		temp = ((viacursor.hot.x) << 16) + viacursor.hot.y;
-		writel(temp, viaparinfo->io_virt + VIA_REG_CURSOR_ORG);
+		temp = (cursor->hot.x << 16) + cursor->hot.y;
+		writel(temp, viapar->io_virt + VIA_REG_CURSOR_ORG);
 	}
 
 	if (cursor->set & FB_CUR_SETPOS) {
-		viacursor.image.dx = cursor->image.dx;
-		viacursor.image.dy = cursor->image.dy;
 		yy = cursor->image.dy - info->var.yoffset;
 		xx = cursor->image.dx - info->var.xoffset;
 		temp = yy & 0xFFFF;
 		temp |= (xx << 16);
-		writel(temp, viaparinfo->io_virt + VIA_REG_CURSOR_POS);
+		writel(temp, viapar->io_virt + VIA_REG_CURSOR_POS);
 	}
 
-	if (cursor->set & FB_CUR_SETSIZE) {
-		temp = readl(viaparinfo->io_virt + VIA_REG_CURSOR_MODE);
+	if (cursor->image.width <= 32 && cursor->image.height <= 32)
+		cur_size = 32;
+	else if (cursor->image.width <= 64 && cursor->image.height <= 64)
+		cur_size = 64;
+	else {
+		printk(KERN_WARNING "viafb_cursor: The cursor is too large "
+			"%dx%d", cursor->image.width, cursor->image.height);
+		return -ENXIO;
+	}
 
-		if ((cursor->image.width <= 32)
-		    && (cursor->image.height <= 32)) {
-			MAX_CURS = 32;
+	if (cursor->set & FB_CUR_SETSIZE) {
+		temp = readl(viapar->io_virt + VIA_REG_CURSOR_MODE);
+		if (cur_size == 32)
 			temp |= 0x2;
-		} else if ((cursor->image.width <= 64)
-			   && (cursor->image.height <= 64)) {
-			MAX_CURS = 64;
-			temp &= 0xFFFFFFFD;
-		} else {
-			DEBUG_MSG(KERN_INFO
-			"The cursor image is biger than 64x64 bits...\n");
-			return -ENXIO;
-		}
-		writel(temp, viaparinfo->io_virt + VIA_REG_CURSOR_MODE);
+		else
+			temp &= ~0x2;
 
-		viacursor.image.height = cursor->image.height;
-		viacursor.image.width = cursor->image.width;
+		writel(temp, viapar->io_virt + VIA_REG_CURSOR_MODE);
 	}
 
 	if (cursor->set & FB_CUR_SETCMAP) {
-		viacursor.image.fg_color = cursor->image.fg_color;
-		viacursor.image.bg_color = cursor->image.bg_color;
-
-		switch (info->var.bits_per_pixel) {
-		case 8:
-		case 16:
-		case 32:
-			bg_col =
-			    (0xFF << 24) |
-			    (((info->cmap.red)[viacursor.image.bg_color] &
-			    0xFF00) << 8) |
-			    ((info->cmap.green)[viacursor.image.bg_color] &
-			    0xFF00) |
-			    (((info->cmap.blue)[viacursor.image.bg_color] &
-			    0xFF00) >> 8);
-			fg_col =
-			    (0xFF << 24) |
-			    (((info->cmap.red)[viacursor.image.fg_color] &
-			    0xFF00) << 8) |
-			    ((info->cmap.green)[viacursor.image.fg_color] &
-			    0xFF00) |
-			    (((info->cmap.blue)[viacursor.image.fg_color] &
-			    0xFF00) >> 8);
-			break;
-		default:
-			return 0;
-		}
-
-		/* This is indeed a patch for VT3324/VT3353 */
-		if (!info->par)
-			return 0;
-		p_viafb_par = (struct viafb_par *)info->par;
-
-		if ((p_viafb_par->chip_info->gfx_chip_name ==
-			UNICHROME_CX700) ||
-			((p_viafb_par->chip_info->gfx_chip_name ==
-			UNICHROME_VX800))) {
-			bg_col =
-			    (((info->cmap.red)[viacursor.image.bg_color] &
-			    0xFFC0) << 14) |
-			    (((info->cmap.green)[viacursor.image.bg_color] &
-			    0xFFC0) << 4) |
-			    (((info->cmap.blue)[viacursor.image.bg_color] &
-			    0xFFC0) >> 6);
-			fg_col =
-			    (((info->cmap.red)[viacursor.image.fg_color] &
-			    0xFFC0) << 14) |
-			    (((info->cmap.green)[viacursor.image.fg_color] &
-			    0xFFC0) << 4) |
-			    (((info->cmap.blue)[viacursor.image.fg_color] &
-			    0xFFC0) >> 6);
+		fg_color = cursor->image.fg_color;
+		bg_color = cursor->image.bg_color;
+		if (chip_name == UNICHROME_CX700 ||
+			chip_name == UNICHROME_VX800) {
+			fg_color =
+				((info->cmap.red[fg_color] & 0xFFC0) << 14) |
+				((info->cmap.green[fg_color] & 0xFFC0) << 4) |
+				((info->cmap.blue[fg_color] & 0xFFC0) >> 6);
+			bg_color =
+				((info->cmap.red[bg_color] & 0xFFC0) << 14) |
+				((info->cmap.green[bg_color] & 0xFFC0) << 4) |
+				((info->cmap.blue[bg_color] & 0xFFC0) >> 6);
+		} else {
+			fg_color =
+				((info->cmap.red[fg_color] & 0xFF00) << 8) |
+				(info->cmap.green[fg_color] & 0xFF00) |
+				((info->cmap.blue[fg_color] & 0xFF00) >> 8);
+			bg_color =
+				((info->cmap.red[bg_color] & 0xFF00) << 8) |
+				(info->cmap.green[bg_color] & 0xFF00) |
+				((info->cmap.blue[bg_color] & 0xFF00) >> 8);
 		}
 
-		writel(bg_col, viaparinfo->io_virt + VIA_REG_CURSOR_BG);
-		writel(fg_col, viaparinfo->io_virt + VIA_REG_CURSOR_FG);
+		writel(bg_color, viapar->io_virt + VIA_REG_CURSOR_BG);
+		writel(fg_color, viapar->io_virt + VIA_REG_CURSOR_FG);
 	}
 
 	if (cursor->set & FB_CUR_SETSHAPE) {
 		struct {
-			u8 data[CURSOR_SIZE / 8];
-			u32 bak[CURSOR_SIZE / 32];
+			u8 data[CURSOR_SIZE];
+			u32 bak[CURSOR_SIZE / 4];
 		} *cr_data = kzalloc(sizeof(*cr_data), GFP_ATOMIC);
-		int size =
-		    ((viacursor.image.width + 7) >> 3) *
-		    viacursor.image.height;
+		int size = ((cursor->image.width + 7) >> 3) *
+			cursor->image.height;
 
-		if (cr_data == NULL)
-			goto out;
+		if (!cr_data)
+			return -ENOMEM;
 
-		if (MAX_CURS == 32) {
-			for (i = 0; i < (CURSOR_SIZE / 32); i++) {
+		if (cur_size == 32) {
+			for (i = 0; i < (CURSOR_SIZE / 4); i++) {
 				cr_data->bak[i] = 0x0;
 				cr_data->bak[i + 1] = 0xFFFFFFFF;
 				i += 1;
 			}
-		} else if (MAX_CURS == 64) {
-			for (i = 0; i < (CURSOR_SIZE / 32); i++) {
+		} else {
+			for (i = 0; i < (CURSOR_SIZE / 4); i++) {
 				cr_data->bak[i] = 0x0;
 				cr_data->bak[i + 1] = 0x0;
 				cr_data->bak[i + 2] = 0xFFFFFFFF;
@@ -1008,27 +956,27 @@ static int viafb_cursor(struct fb_info *
 			}
 		}
 
-		switch (viacursor.rop) {
+		switch (cursor->rop) {
 		case ROP_XOR:
 			for (i = 0; i < size; i++)
-				cr_data->data[i] = viacursor.mask[i];
+				cr_data->data[i] = cursor->mask[i];
 			break;
 		case ROP_COPY:
 
 			for (i = 0; i < size; i++)
-				cr_data->data[i] = viacursor.mask[i];
+				cr_data->data[i] = cursor->mask[i];
 			break;
 		default:
 			break;
 		}
 
-		if (MAX_CURS == 32) {
+		if (cur_size == 32) {
 			for (i = 0; i < size; i++) {
 				cr_data->bak[j] = (u32) cr_data->data[i];
 				cr_data->bak[j + 1] = ~cr_data->bak[j];
 				j += 2;
 			}
-		} else if (MAX_CURS == 64) {
+		} else {
 			for (i = 0; i < size; i++) {
 				cr_data->bak[j] = (u32) cr_data->data[i];
 				cr_data->bak[j + 1] = 0x0;
@@ -1038,14 +986,12 @@ static int viafb_cursor(struct fb_info *
 			}
 		}
 
-		memcpy(viafbinfo->screen_base +
-		       ((struct viafb_par *)(info->par))->cursor_start,
-		       cr_data->bak, CURSOR_SIZE);
-out:
+		memcpy_toio(viafbinfo->screen_base + viapar->shared->
+			cursor_vram_addr, cr_data->bak, CURSOR_SIZE);
 		kfree(cr_data);
 	}
 
-	if (viacursor.enable)
+	if (cursor->enable)
 		viafb_show_hw_cursor(info, HW_Cursor_ON);
 
 	return 0;
@@ -2052,8 +1998,6 @@ static int __devinit via_pci_probe(void)
 		viaparinfo->fbmem_free = viaparinfo->memsize;
 		viaparinfo->fbmem_used = 0;
 		if (viafb_accel) {
-			viaparinfo1->cursor_start =
-			    viaparinfo->cursor_start - viafb_second_offset;
 			viaparinfo1->VQ_start = viaparinfo->VQ_start -
 				viafb_second_offset;
 			viaparinfo1->VQ_end = viaparinfo->VQ_end -
diff -puN drivers/video/via/viafbdev.h~viafb-cleanup-viafb_cursor drivers/video/via/viafbdev.h
--- a/drivers/video/via/viafbdev.h~viafb-cleanup-viafb_cursor
+++ a/drivers/video/via/viafbdev.h
@@ -51,6 +51,7 @@ struct viafb_shared {
 	struct chip_information chip_info;
 
 	/* hardware acceleration stuff */
+	u32 cursor_vram_addr;
 	int (*hw_bitblt)(void __iomem *engine, u8 op, u32 width, u32 height,
 		u8 dst_bpp, u32 dst_addr, u32 dst_pitch, u32 dst_x, u32 dst_y,
 		u32 *src_mem, u32 src_addr, u32 src_pitch, u32 src_x, u32 src_y,
@@ -65,7 +66,6 @@ struct viafb_par {
 	unsigned int memsize;	/*size of fbmem */
 	u32 fbmem_free;		/* Free FB memory */
 	u32 fbmem_used;		/* Use FB memory size */
-	u32 cursor_start;	/* Cursor Start Address */
 	u32 VQ_start;		/* Virtual Queue Start Address */
 	u32 VQ_end;		/* Virtual Queue End Address */
 	u32 iga_path;
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-remove-duplicated-cx700-register-init.patch
viafb-remove-temporary-start-address-setting.patch
viafb-merge-viafb_update_viafb_par-in-viafb_update_fix.patch
viafb-split-viafb_set_start_addr-up.patch
viafb-fix-ioremap_nocache-error-handling.patch
viafb-clean-up-viamodeh.patch
viafb-remove-duplicated-mode-information.patch
viafb-clean-up-duoview.patch
viafb-clean-up-virtual-memory-handling.patch
viafb-remove-unused-video-device-stuff.patch
viafb-remove-lvds-initialization.patch
viafb-another-small-cleanup-of-viafb_par.patch
viafb-improve-viafb_par.patch
viafb-2d-engine-rewrite.patch
viafb-2d-engine-rewrite-v2.patch
viafb-switch-to-seq_file.patch
viafb-cleanup-viafb_cursor.patch
viafb-improve-pitch-handling.patch
viafb-hardware-acceleration-initialization-cleanup.patch
fb-fix-fb_pan_display-range-check.patch
fb-do-not-ignore-fb_set_par-errors.patch

