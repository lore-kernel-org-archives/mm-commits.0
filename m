From: akpm@linux-foundation.org
Subject: + tdfxfb-hardware-cursor.patch added to -mm tree
Date: Wed, 01 Aug 2007 15:42:16 -0700
Message-ID: <200708012242.l71MgGSJ021174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40894 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754257AbXHAWm7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 18:42:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     tdfxfb: hardware cursor
has been added to the -mm tree.  Its filename is
     tdfxfb-hardware-cursor.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tdfxfb: hardware cursor
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds hardware cursor support to the tdfxfb driver.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |  169 +++++++++++++++++----------------------
 include/video/tdfx.h   |    8 -
 2 files changed, 74 insertions(+), 103 deletions(-)

diff -puN drivers/video/tdfxfb.c~tdfxfb-hardware-cursor drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-hardware-cursor
+++ a/drivers/video/tdfxfb.c
@@ -67,7 +67,6 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <asm/io.h>
-#include <linux/timer.h>
 #include <linux/spinlock.h>
 
 #include <video/tdfx.h>
@@ -148,8 +147,9 @@ MODULE_DEVICE_TABLE(pci, tdfxfb_id_table
 /*
  * Driver data
  */
-static int  nopan   = 0;
-static int  nowrap  = 1;      // not implemented (yet)
+static int nopan;
+static int nowrap = 1;      /* not implemented (yet) */
+static int hwcursor = 1;
 static char *mode_option __devinitdata = NULL;
 
 /* -------------------------------------------------------------------------
@@ -378,7 +378,7 @@ static void do_write_regs(struct fb_info
 	tdfx_outl(par, VGAINIT0, reg->vgainit0);
 	tdfx_outl(par, DACMODE, reg->dacmode);
 	tdfx_outl(par, VIDDESKSTRIDE, reg->stride);
-	tdfx_outl(par, HWCURPATADDR, 0);
+	tdfx_outl(par, HWCURPATADDR, reg->curspataddr);
 
 	tdfx_outl(par, VIDSCREENSIZE, reg->screensize);
 	tdfx_outl(par, VIDDESKSTART, reg->startaddr);
@@ -453,6 +453,7 @@ static int tdfxfb_check_var(struct fb_va
 		DPRINTK("xoffset not supported\n");
 		return -EINVAL;
 	}
+	var->yoffset = 0;
 
 	/* Banshee doesn't support interlace, but Voodoo4/5 and probably Voodoo3 do. */
 	/* no direct information about device id now? use max_pixclock for this... */
@@ -663,6 +664,9 @@ static int tdfxfb_set_par(struct fb_info
 			VGAINIT0_EXTSHIFTOUT;
 	reg.vgainit1 = tdfx_inl(par, VGAINIT1) & 0x1fffff;
 
+	if (hwcursor)
+		reg.curspataddr = info->fix.smem_len;
+
 	reg.cursloc   = 0;
 
 	reg.cursc0    = 0;
@@ -1012,11 +1016,25 @@ static void tdfxfb_imageblit(struct fb_i
 }
 #endif /* CONFIG_FB_3DFX_ACCEL */
 
-#ifdef TDFX_HARDWARE_CURSOR
 static int tdfxfb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 {
 	struct tdfx_par *par = info->par;
-	unsigned long flags;
+	u32 vidcfg;
+
+	if (!hwcursor)
+		return -EINVAL;	/* just to force soft_cursor() call */
+
+	/* Too large of a cursor or wrong bpp :-( */
+	if (cursor->image.width > 64 ||
+	    cursor->image.height > 64 ||
+	    cursor->image.depth > 1)
+		return -EINVAL;
+
+	vidcfg = tdfx_inl(par, VIDPROCCFG);
+	if (cursor->enable)
+		tdfx_outl(par, VIDPROCCFG, vidcfg | VIDCFG_HWCURSOR_ENABLE);
+	else
+		tdfx_outl(par, VIDPROCCFG, vidcfg & ~VIDCFG_HWCURSOR_ENABLE);
 
 	/*
 	 * If the cursor is not be changed this means either we want the
@@ -1026,69 +1044,34 @@ static int tdfxfb_cursor(struct fb_info 
 	if (!cursor->set)
 		return 0;
 
-	/* Too large of a cursor :-( */
-	if (cursor->image.width > 64 || cursor->image.height > 64)
-		return -ENXIO;
-
-	/*
-	 * If we are going to be changing things we should disable
-	 * the cursor first
-	 */
-	if (info->cursor.enable) {
-		spin_lock_irqsave(&par->DAClock, flags);
-		info->cursor.enable = 0;
-		del_timer(&(par->hwcursor.timer));
-		tdfx_outl(par, VIDPROCCFG, par->hwcursor.disable);
-		spin_unlock_irqrestore(&par->DAClock, flags);
-	}
-
-	/* Disable the Cursor */
-	if ((cursor->set && FB_CUR_SETCUR) && !cursor->enable)
-		return 0;
-
 	/* fix cursor color - XFree86 forgets to restore it properly */
-	if (cursor->set && FB_CUR_SETCMAP) {
-		struct fb_cmap cmap = cursor->image.cmap;
+	if (cursor->set & FB_CUR_SETCMAP) {
+		struct fb_cmap cmap = info->cmap;
+		u32 bg_idx = cursor->image.bg_color;
+		u32 fg_idx = cursor->image.fg_color;
 		unsigned long bg_color, fg_color;
 
-		cmap.len = 2; /* Voodoo 3+ only support 2 color cursors */
-		fg_color = ((cmap.red[cmap.start] << 16) |
-			    (cmap.green[cmap.start] << 8) |
-			    (cmap.blue[cmap.start]));
-		bg_color = ((cmap.red[cmap.start + 1] << 16) |
-			    (cmap.green[cmap.start + 1] << 8) |
-			    (cmap.blue[cmap.start + 1]));
-		fb_copy_cmap(&cmap, &info->cursor.image.cmap);
-		spin_lock_irqsave(&par->DAClock, flags);
+		fg_color = (((u32)cmap.red[fg_idx]   & 0xff00) << 8) |
+			   (((u32)cmap.green[fg_idx] & 0xff00) << 0) |
+			   (((u32)cmap.blue[fg_idx]  & 0xff00) >> 8);
+		bg_color = (((u32)cmap.red[bg_idx]   & 0xff00) << 8) |
+			   (((u32)cmap.green[bg_idx] & 0xff00) << 0) |
+			   (((u32)cmap.blue[bg_idx]  & 0xff00) >> 8);
 		banshee_make_room(par, 2);
 		tdfx_outl(par, HWCURC0, bg_color);
 		tdfx_outl(par, HWCURC1, fg_color);
-		spin_unlock_irqrestore(&par->DAClock, flags);
 	}
 
-	if (cursor->set && FB_CUR_SETPOS) {
-		int x, y;
+	if (cursor->set & FB_CUR_SETPOS) {
+		int x = cursor->image.dx;
+		int y = cursor->image.dy - info->var.yoffset;
 
-		x = cursor->image.dx;
-		y = cursor->image.dy;
-		y -= info->var.yoffset;
-		info->cursor.image.dx = x;
-		info->cursor.image.dy = y;
 		x += 63;
 		y += 63;
-		spin_lock_irqsave(&par->DAClock, flags);
 		banshee_make_room(par, 1);
 		tdfx_outl(par, HWCURLOC, (y << 16) + x);
-		spin_unlock_irqrestore(&par->DAClock, flags);
 	}
-
-	/* Not supported so we fake it */
-	if (cursor->set && FB_CUR_SETHOT) {
-		info->cursor.hot.x = cursor->hot.x;
-		info->cursor.hot.y = cursor->hot.y;
-	}
-
-	if (cursor->set && FB_CUR_SETSHAPE) {
+	if (cursor->set & (FB_CUR_SETIMAGE | FB_CUR_SETSHAPE)) {
 		/*
 		 * Voodoo 3 and above cards use 2 monochrome cursor patterns.
 		 *    The reason is so the card can fetch 8 words at a time
@@ -1096,7 +1079,7 @@ static int tdfxfb_cursor(struct fb_info 
 		 * This reduces the number of times for access to draw the
 		 * cursor for each screen refresh.
 		 *    Each pattern is a bitmap of 64 bit wide and 64 bit high
-		 * (total of 8192 bits or 1024 Kbytes). The two patterns are
+		 * (total of 8192 bits or 1024 bytes). The two patterns are
 		 * stored in such a way that pattern 0 always resides in the
 		 * lower half (least significant 64 bits) of a 128 bit word
 		 * and pattern 1 the upper half. If you examine the data of
@@ -1107,50 +1090,34 @@ static int tdfxfb_cursor(struct fb_info 
 		 * (128 bits) which is the maximum cursor width times two for
 		 * the two monochrome patterns.
 		 */
-		u8 *cursorbase = (u8 *)info->cursor.image.data;
-		char *bitmap = (char *)cursor->image.data;
-		char *mask = (char *)cursor->mask;
-		int i, j, k, h = 0;
-
-		for (i = 0; i < 64; i++) {
-			if (i < cursor->image.height) {
-				j = (cursor->image.width + 7) >> 3;
-				k = 8 - j;
-
-				for (; j > 0; j--) {
-					/* Pattern 0. Copy the cursor bitmap to it */
-					fb_writeb(*bitmap, cursorbase + h);
-					bitmap++;
-					/* Pattern 1. Copy the cursor mask to it */
-					fb_writeb(*mask, cursorbase + h + 8);
-					mask++;
-					h++;
-				}
-				for (; k > 0; k--) {
-					fb_writeb(0, cursorbase + h);
-					fb_writeb(~0, cursorbase + h + 8);
-					h++;
-				}
-			} else {
-				fb_writel(0, cursorbase + h);
-				fb_writel(0, cursorbase + h + 4);
-				fb_writel(~0, cursorbase + h + 8);
-				fb_writel(~0, cursorbase + h + 12);
-				h += 16;
+		u8 __iomem *cursorbase = info->screen_base + info->fix.smem_len;
+		u8 *bitmap = (u8 *)cursor->image.data;
+		u8 *mask = (u8 *)cursor->mask;
+		int i;
+
+		fb_memset(cursorbase, 0, 1024);
+
+		for (i = 0; i < cursor->image.height; i++) {
+			int h = 0;
+			int j = (cursor->image.width + 7) >> 3;
+
+			for (; j > 0; j--) {
+				u8 data = *mask ^ *bitmap;
+				if (cursor->rop == ROP_COPY)
+					data = *mask & *bitmap;
+				/* Pattern 0. Copy the cursor mask to it */
+				fb_writeb(*mask, cursorbase + h);
+				mask++;
+				/* Pattern 1. Copy the cursor bitmap to it */
+				fb_writeb(data, cursorbase + h + 8);
+				bitmap++;
+				h++;
 			}
+			cursorbase += 16;
 		}
 	}
-	/* Turn the cursor on */
-	cursor->enable = 1;
-	info->cursor = *cursor;
-	mod_timer(&par->hwcursor.timer, jiffies + HZ / 2);
-	spin_lock_irqsave(&par->DAClock, flags);
-	banshee_make_room(par, 1);
-	tdfx_outl(par, VIDPROCCFG, par->hwcursor.enable);
-	spin_unlock_irqrestore(&par->DAClock, flags);
 	return 0;
 }
-#endif
 
 static struct fb_ops tdfxfb_ops = {
 	.owner		= THIS_MODULE,
@@ -1160,6 +1127,7 @@ static struct fb_ops tdfxfb_ops = {
 	.fb_blank	= tdfxfb_blank,
 	.fb_pan_display	= tdfxfb_pan_display,
 	.fb_sync	= banshee_wait_idle,
+	.fb_cursor	= tdfxfb_cursor,
 #ifdef CONFIG_FB_3DFX_ACCEL
 	.fb_fillrect	= tdfxfb_fillrect,
 	.fb_copyarea	= tdfxfb_copyarea,
@@ -1272,6 +1240,11 @@ static int __devinit tdfxfb_probe(struct
 				   FBINFO_HWACCEL_IMAGEBLIT |
 				   FBINFO_READS_FAST;
 #endif
+	/* reserve 8192 bits for cursor */
+	/* the 2.4 driver says PAGE_MASK boundary is not enough for Voodoo4 */
+	if (hwcursor)
+		info->fix.smem_len = (info->fix.smem_len - 1024) &
+					(PAGE_MASK << 1);
 
 	if (!mode_option)
 		mode_option = "640x480@60";
@@ -1336,6 +1309,8 @@ static void tdfxfb_setup(char *options)
 			nopan = 1;
 		} else if (!strcmp(this_opt, "nowrap")) {
 			nowrap = 1;
+		} else if (!strcmp(this_opt, "hwcursor")) {
+			hwcursor = simple_strtoul(opt + 9, NULL, 0);
 		} else {
 			mode_option = this_opt;
 		}
@@ -1394,5 +1369,9 @@ MODULE_AUTHOR("Hannu Mallat <hmallat@cc.
 MODULE_DESCRIPTION("3Dfx framebuffer device driver");
 MODULE_LICENSE("GPL");
 
+module_param(hwcursor, int, 0644);
+MODULE_PARM_DESC(hwcursor, "Enable hardware cursor "
+			"(1=enable, 0=disable, default=1)");
+
 module_init(tdfxfb_init);
 module_exit(tdfxfb_exit);
diff -puN include/video/tdfx.h~tdfxfb-hardware-cursor include/video/tdfx.h
--- a/include/video/tdfx.h~tdfxfb-hardware-cursor
+++ a/include/video/tdfx.h
@@ -175,14 +175,6 @@ struct tdfx_par {
 	u32 palette[16];
 	void __iomem *regbase_virt;
 	unsigned long iobase;
-
-	struct {
-		int w, u, d;
-		unsigned long enable, disable;
-		struct timer_list timer;
-	} hwcursor;
-
-	spinlock_t DAClock;
 };
 
 #endif	/* __KERNEL__ */
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
tdfxfb-code-improvements.patch
tdfxfb-hardware-cursor.patch
tdfxfb-mtrr-support.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
