From: akpm@linux-foundation.org
Subject: + viafb-viafbdevc-update.patch added to -mm tree
Date: Wed, 27 Aug 2008 16:27:08 -0700
Message-ID: <200808272327.m7RNR8fp028369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754568AbYH0X1K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 19:27:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JosephChan@via.com.tw, josephchan@via.com.tw, krzysztof.h1@wp.pl


The patch titled
     viafb: viafbdev.c (update)
has been added to the -mm tree.  Its filename is
     viafb-viafbdevc-update.patch

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
Subject: viafb: viafbdev.c (update)
From: <JosephChan@via.com.tw>

Remove the macro MMIO_OUT32, and replace it with writel() function. 
And replace "u32" with "unsigned long" in writel() function (original
MMIO_OUT32 marco) for avoiding warning message in 64bit OS.

Signed-off-by: Joseph Chan <josephchan@via.com.tw>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |  110 +++++++++++++++++----------------
 1 file changed, 57 insertions(+), 53 deletions(-)

diff -puN drivers/video/via/viafbdev.c~viafb-viafbdevc-update drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-viafbdevc-update
+++ a/drivers/video/via/viafbdev.c
@@ -896,30 +896,32 @@ static void viafb_fillrect(struct fb_inf
 	}
 
 	/* BitBlt Source Address */
-	MMIO_OUT32(VIA_REG_SRCPOS, 0x0);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCPOS);
 	/* Source Base Address */
-	MMIO_OUT32(VIA_REG_SRCBASE, 0x0);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCBASE);
 	/* Destination Base Address */
-	/*MMIO_OUT32(VIA_REG_DSTBASE, 0x0); */
-	MMIO_OUT32(VIA_REG_DSTBASE,
-		   ((u32) (info->screen_base) - (u32) viafb_FB_MM) >> 3);
+	writel(((unsigned long) (info->screen_base) -
+		   (unsigned long) viafb_FB_MM) >> 3,
+		   viaparinfo->io_virt + VIA_REG_DSTBASE);
 	/* Pitch */
 	pitch = (info->var.xres_virtual + 7) & ~7;
-	MMIO_OUT32(VIA_REG_PITCH,
-		   VIA_PITCH_ENABLE |
+	writel(VIA_PITCH_ENABLE |
 		   (((pitch *
 		      info->var.bits_per_pixel >> 3) >> 3) |
 		      (((pitch * info->
-		      var.bits_per_pixel >> 3) >> 3) << 16)));
+		      var.bits_per_pixel >> 3) >> 3) << 16)),
+		      viaparinfo->io_virt + VIA_REG_PITCH);
 	/* BitBlt Destination Address */
-	MMIO_OUT32(VIA_REG_DSTPOS, ((rect->dy << 16) | rect->dx));
+	writel(((rect->dy << 16) | rect->dx),
+		viaparinfo->io_virt + VIA_REG_DSTPOS);
 	/* Dimension: width & height */
-	MMIO_OUT32(VIA_REG_DIMENSION,
-		   (((rect->height - 1) << 16) | (rect->width - 1)));
+	writel((((rect->height - 1) << 16) | (rect->width - 1)),
+		viaparinfo->io_virt + VIA_REG_DIMENSION);
 	/* Forground color or Destination color */
-	MMIO_OUT32(VIA_REG_FGCOLOR, col);
+	writel(col, viaparinfo->io_virt + VIA_REG_FGCOLOR);
 	/* GE Command */
-	MMIO_OUT32(VIA_REG_GECMD, (0x01 | 0x2000 | (rop << 24)));
+	writel((0x01 | 0x2000 | (rop << 24)),
+		viaparinfo->io_virt + VIA_REG_GECMD);
 
 }
 
@@ -951,33 +953,34 @@ static void viafb_copyarea(struct fb_inf
 	}
 
 	/* Source Base Address */
-	/*MMIO_OUT32(VIA_REG_SRCBASE, 0x0); */
-	MMIO_OUT32(VIA_REG_SRCBASE,
-		   ((u32) (info->screen_base) - (u32) viafb_FB_MM) >> 3);
+	writel(((unsigned long) (info->screen_base) -
+		   (unsigned long) viafb_FB_MM) >> 3,
+		   viaparinfo->io_virt + VIA_REG_SRCBASE);
 	/* Destination Base Address */
-	/*MMIO_OUT32(VIA_REG_DSTBASE, 0x0); */
-	MMIO_OUT32(VIA_REG_DSTBASE,
-		   ((u32) (info->screen_base) - (u32) viafb_FB_MM) >> 3);
+	writel(((unsigned long) (info->screen_base) -
+		   (unsigned long) viafb_FB_MM) >> 3,
+		   viaparinfo->io_virt + VIA_REG_DSTBASE);
 	/* Pitch */
 	pitch = (info->var.xres_virtual + 7) & ~7;
 	/* VIA_PITCH_ENABLE can be omitted now. */
-	MMIO_OUT32(VIA_REG_PITCH,
-		   VIA_PITCH_ENABLE |
+	writel(VIA_PITCH_ENABLE |
 		   (((pitch *
 		      info->var.bits_per_pixel >> 3) >> 3) | (((pitch *
 								info->var.
 								bits_per_pixel
 								>> 3) >> 3)
-							      << 16)));
+							      << 16)),
+				viaparinfo->io_virt + VIA_REG_PITCH);
 	/* BitBlt Source Address */
-	MMIO_OUT32(VIA_REG_SRCPOS, ((sy << 16) | sx));
+	writel(((sy << 16) | sx), viaparinfo->io_virt + VIA_REG_SRCPOS);
 	/* BitBlt Destination Address */
-	MMIO_OUT32(VIA_REG_DSTPOS, ((dy << 16) | dx));
+	writel(((dy << 16) | dx), viaparinfo->io_virt + VIA_REG_DSTPOS);
 	/* Dimension: width & height */
-	MMIO_OUT32(VIA_REG_DIMENSION,
-		   (((area->height - 1) << 16) | (area->width - 1)));
+	writel((((area->height - 1) << 16) | (area->width - 1)),
+		   viaparinfo->io_virt + VIA_REG_DIMENSION);
 	/* GE Command */
-	MMIO_OUT32(VIA_REG_GECMD, (0x01 | direction | (0xCC << 24)));
+	writel((0x01 | direction | (0xCC << 24)),
+		viaparinfo->io_virt + VIA_REG_GECMD);
 
 }
 
@@ -1010,37 +1013,38 @@ static void viafb_imageblit(struct fb_in
 	size = image->width * image->height;
 
 	/* Source Base Address */
-	MMIO_OUT32(VIA_REG_SRCBASE, 0x0);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCBASE);
 	/* Destination Base Address */
-	/*MMIO_OUT32(VIA_REG_DSTBASE, 0x0); */
-	MMIO_OUT32(VIA_REG_DSTBASE,
-		   ((u32) (info->screen_base) - (u32) viafb_FB_MM) >> 3);
+	writel(((unsigned long) (info->screen_base) -
+		   (unsigned long) viafb_FB_MM) >> 3,
+		   viaparinfo->io_virt + VIA_REG_DSTBASE);
 	/* Pitch */
 	pitch = (info->var.xres_virtual + 7) & ~7;
-	MMIO_OUT32(VIA_REG_PITCH,
-		   VIA_PITCH_ENABLE |
+	writel(VIA_PITCH_ENABLE |
 		   (((pitch *
 		      info->var.bits_per_pixel >> 3) >> 3) | (((pitch *
 								info->var.
 								bits_per_pixel
 								>> 3) >> 3)
-							      << 16)));
+							      << 16)),
+				viaparinfo->io_virt + VIA_REG_PITCH);
 	/* BitBlt Source Address */
-	MMIO_OUT32(VIA_REG_SRCPOS, 0x0);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCPOS);
 	/* BitBlt Destination Address */
-	MMIO_OUT32(VIA_REG_DSTPOS, ((image->dy << 16) | image->dx));
+	writel(((image->dy << 16) | image->dx),
+		viaparinfo->io_virt + VIA_REG_DSTPOS);
 	/* Dimension: width & height */
-	MMIO_OUT32(VIA_REG_DIMENSION,
-		   (((image->height - 1) << 16) | (image->width - 1)));
+	writel((((image->height - 1) << 16) | (image->width - 1)),
+		   viaparinfo->io_virt + VIA_REG_DIMENSION);
 	/* fb color */
-	MMIO_OUT32(VIA_REG_FGCOLOR, fg_col);
+	writel(fg_col, viaparinfo->io_virt + VIA_REG_FGCOLOR);
 	/* bg color */
-	MMIO_OUT32(VIA_REG_BGCOLOR, bg_col);
+	writel(bg_col, viaparinfo->io_virt + VIA_REG_BGCOLOR);
 	/* GE Command */
-	MMIO_OUT32(VIA_REG_GECMD, 0xCC020142);
+	writel(0xCC020142, viaparinfo->io_virt + VIA_REG_GECMD);
 
 	for (i = 0; i < size / 4; i++) {
-		MMIO_OUT32(VIA_MMIO_BLTBASE, *udata);
+		writel(*udata, viaparinfo->io_virt + VIA_MMIO_BLTBASE);
 		udata++;
 	}
 
@@ -1080,7 +1084,7 @@ static int viafb_cursor(struct fb_info *
 	if (cursor->set & FB_CUR_SETHOT) {
 		viacursor.hot = cursor->hot;
 		temp = ((viacursor.hot.x) << 16) + viacursor.hot.y;
-		MMIO_OUT32(VIA_REG_CURSOR_ORG, temp);
+		writel(temp, viaparinfo->io_virt + VIA_REG_CURSOR_ORG);
 	}
 
 	if (cursor->set & FB_CUR_SETPOS) {
@@ -1090,11 +1094,11 @@ static int viafb_cursor(struct fb_info *
 		xx = cursor->image.dx - info->var.xoffset;
 		temp = yy & 0xFFFF;
 		temp |= (xx << 16);
-		MMIO_OUT32(VIA_REG_CURSOR_POS, temp);
+		writel(temp, viaparinfo->io_virt + VIA_REG_CURSOR_POS);
 	}
 
 	if (cursor->set & FB_CUR_SETSIZE) {
-		temp = MMIO_IN32(VIA_REG_CURSOR_MODE);
+		temp = readl(viaparinfo->io_virt + VIA_REG_CURSOR_MODE);
 
 		if ((cursor->image.width <= 32)
 		    && (cursor->image.height <= 32)) {
@@ -1109,7 +1113,7 @@ static int viafb_cursor(struct fb_info *
 			"The cursor image is biger than 64x64 bits...\n");
 			return -ENXIO;
 		}
-		MMIO_OUT32(VIA_REG_CURSOR_MODE, temp);
+		writel(temp, viaparinfo->io_virt + VIA_REG_CURSOR_MODE);
 
 		viacursor.image.height = cursor->image.height;
 		viacursor.image.width = cursor->image.width;
@@ -1169,8 +1173,8 @@ static int viafb_cursor(struct fb_info *
 			    0xFFC0) >> 6);
 		}
 
-		MMIO_OUT32(VIA_REG_CURSOR_BG, bg_col);
-		MMIO_OUT32(VIA_REG_CURSOR_FG, fg_col);
+		writel(bg_col, viaparinfo->io_virt + VIA_REG_CURSOR_BG);
+		writel(fg_col, viaparinfo->io_virt + VIA_REG_CURSOR_FG);
 	}
 
 	if (cursor->set & FB_CUR_SETSHAPE) {
@@ -2116,15 +2120,15 @@ static int __devinit via_pci_probe(void)
 
 	viaparinfo = (struct viafb_par *)viafbinfo->par;
 	viaparinfo->tmds_setting_info = (struct tmds_setting_information *)
-		((u32)viaparinfo + viafb_par_length);
+		((unsigned long)viaparinfo + viafb_par_length);
 	viaparinfo->lvds_setting_info = (struct lvds_setting_information *)
-		((u32)viaparinfo->tmds_setting_info + tmds_length);
+		((unsigned long)viaparinfo->tmds_setting_info + tmds_length);
 	viaparinfo->lvds_setting_info2 = (struct lvds_setting_information *)
-		((u32)viaparinfo->lvds_setting_info + lvds_length);
+		((unsigned long)viaparinfo->lvds_setting_info + lvds_length);
 	viaparinfo->crt_setting_info = (struct crt_setting_information *)
-		((u32)viaparinfo->lvds_setting_info2 + lvds_length);
+		((unsigned long)viaparinfo->lvds_setting_info2 + lvds_length);
 	viaparinfo->chip_info = (struct chip_information *)
-		((u32)viaparinfo->crt_setting_info + crt_length);
+		((unsigned long)viaparinfo->crt_setting_info + crt_length);
 
 	if (viafb_dual_fb)
 		viafb_SAMM_ON = 1;
_

Patches currently in -mm which might be from JosephChan@via.com.tw are

origin.patch
sata_viac-add-support-for-vt8251-fix-the-internal-chips-issue-and.patch
viafb-viafbmodes-viafbtxt.patch
viafb-viafbmodes-viafbtxt-fix.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-makefile-kconfig.patch
viafb-accelc-accelh.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-accelc-accelh-update.patch
viafb-chiph-debugh.patch
viafb-dvic-dvih-globalc-and-globalh.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-ifacec-ifaceh-ioctlc-ioctlh.patch
viafb-lcdc-lcdh-lcdtblh.patch
viafb-makefile-shareh.patch
viafb-tbl1636c-tbl1636h-tbldpasettingc-tbldpasettingh.patch
viafb-viafbdevc-viafbdevh.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
viafb-viafbdevc-update.patch
viafb-via_i2cc-via_i2ch-viamodec-viamodeh.patch
viafb-via_utilityc-via_utilityh-vt1636c-vt1636h.patch

