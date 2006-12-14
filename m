From: akpm@osdl.org
Subject: + tgafb-support-the-directcolor-visual.patch added to -mm tree
Date: Wed, 13 Dec 2006 16:16:09 -0800
Message-ID: <200612140016.kBE0GA2U025769@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60815 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbWLNAQZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:16:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, adaplas@pol.net, jsimmons@infradead.org


The patch titled
     tgafb: support the DirectColor visual
has been added to the -mm tree.  Its filename is
     tgafb-support-the-directcolor-visual.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tgafb: support the DirectColor visual
From: "Maciej W. Rozycki" <macro@linux-mips.org>

 The 32-plane variations of the TGA use the Bt463 RAMDAC and are therefore
DirectColor rather than TrueColor adapters.  This is a set of changes to
implement the necessary bits to support this model.  A couple of fixes to fix
accesses to the RAMDAC are included as a side-effect.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/tgafb.c |   85 +++++++++++++++++++++++-----------------
 1 files changed, 49 insertions(+), 36 deletions(-)

diff -puN drivers/video/tgafb.c~tgafb-support-the-directcolor-visual drivers/video/tgafb.c
--- a/drivers/video/tgafb.c~tgafb-support-the-directcolor-visual
+++ a/drivers/video/tgafb.c
@@ -99,6 +99,12 @@ tgafb_check_var(struct fb_var_screeninfo
 		if (var->bits_per_pixel != 32)
 			return -EINVAL;
 	}
+	var->red.length = var->green.length = var->blue.length = 8;
+	if (var->bits_per_pixel == 32) {
+		var->red.offset = 16;
+		var->green.offset = 8;
+		var->blue.offset = 0;
+	}
 
 	if (var->xres_virtual != var->xres || var->yres_virtual != var->yres)
 		return -EINVAL;
@@ -152,7 +158,7 @@ tgafb_set_par(struct fb_info *info)
 	struct tga_par *par = (struct tga_par *) info->par;
 	u32 htimings, vtimings, pll_freq;
 	u8 tga_type;
-	int i, j;
+	int i;
 
 	/* Encode video timings.  */
 	htimings = (((info->var.xres/4) & TGA_HORIZ_ACT_LSB)
@@ -227,8 +233,10 @@ tgafb_set_par(struct fb_info *info)
 		BT485_WRITE(par, 0x00, BT485_ADDR_PAL_WRITE);
 		TGA_WRITE_REG(par, BT485_DATA_PAL, TGA_RAMDAC_SETUP_REG);
 
+#ifdef CONFIG_HW_CONSOLE
 		for (i = 0; i < 16; i++) {
-			j = color_table[i];
+			int j = color_table[i];
+
 			TGA_WRITE_REG(par, default_red[j]|(BT485_DATA_PAL<<8),
 				      TGA_RAMDAC_REG);
 			TGA_WRITE_REG(par, default_grn[j]|(BT485_DATA_PAL<<8),
@@ -236,14 +244,17 @@ tgafb_set_par(struct fb_info *info)
 			TGA_WRITE_REG(par, default_blu[j]|(BT485_DATA_PAL<<8),
 				      TGA_RAMDAC_REG);
 		}
-		for (i = 0; i < 240*3; i += 4) {
-			TGA_WRITE_REG(par, 0x55|(BT485_DATA_PAL<<8),
+		for (i = 0; i < 240 * 3; i += 4) {
+#else
+		for (i = 0; i < 256 * 3; i += 4) {
+#endif
+			TGA_WRITE_REG(par, 0x55 | (BT485_DATA_PAL << 8),
 				      TGA_RAMDAC_REG);
-			TGA_WRITE_REG(par, 0x00|(BT485_DATA_PAL<<8),
+			TGA_WRITE_REG(par, 0x00 | (BT485_DATA_PAL << 8),
 				      TGA_RAMDAC_REG);
-			TGA_WRITE_REG(par, 0x00|(BT485_DATA_PAL<<8),
+			TGA_WRITE_REG(par, 0x00 | (BT485_DATA_PAL << 8),
 				      TGA_RAMDAC_REG);
-			TGA_WRITE_REG(par, 0x00|(BT485_DATA_PAL<<8),
+			TGA_WRITE_REG(par, 0x00 | (BT485_DATA_PAL << 8),
 				      TGA_RAMDAC_REG);
 		}
 
@@ -267,26 +278,24 @@ tgafb_set_par(struct fb_info *info)
 
 		/* Fill the palette.  */
 		BT463_LOAD_ADDR(par, 0x0000);
-		TGA_WRITE_REG(par, BT463_PALETTE<<2, TGA_RAMDAC_REG);
+		TGA_WRITE_REG(par, BT463_PALETTE << 2, TGA_RAMDAC_SETUP_REG);
 
+#ifdef CONFIG_HW_CONSOLE
 		for (i = 0; i < 16; i++) {
-			j = color_table[i];
-			TGA_WRITE_REG(par, default_red[j]|(BT463_PALETTE<<10),
-				      TGA_RAMDAC_REG);
-			TGA_WRITE_REG(par, default_grn[j]|(BT463_PALETTE<<10),
-				      TGA_RAMDAC_REG);
-			TGA_WRITE_REG(par, default_blu[j]|(BT463_PALETTE<<10),
-				      TGA_RAMDAC_REG);
-		}
-		for (i = 0; i < 512*3; i += 4) {
-			TGA_WRITE_REG(par, 0x55|(BT463_PALETTE<<10),
-				      TGA_RAMDAC_REG);
-			TGA_WRITE_REG(par, 0x00|(BT463_PALETTE<<10),
-				      TGA_RAMDAC_REG);
-			TGA_WRITE_REG(par, 0x00|(BT463_PALETTE<<10),
-				      TGA_RAMDAC_REG);
-			TGA_WRITE_REG(par, 0x00|(BT463_PALETTE<<10),
-				      TGA_RAMDAC_REG);
+			int j = color_table[i];
+
+			TGA_WRITE_REG(par, default_red[j], TGA_RAMDAC_REG);
+			TGA_WRITE_REG(par, default_grn[j], TGA_RAMDAC_REG);
+			TGA_WRITE_REG(par, default_blu[j], TGA_RAMDAC_REG);
+		}
+		for (i = 0; i < 512 * 3; i += 4) {
+#else
+		for (i = 0; i < 528 * 3; i += 4) {
+#endif
+			TGA_WRITE_REG(par, 0x55, TGA_RAMDAC_REG);
+			TGA_WRITE_REG(par, 0x00, TGA_RAMDAC_REG);
+			TGA_WRITE_REG(par, 0x00, TGA_RAMDAC_REG);
+			TGA_WRITE_REG(par, 0x00, TGA_RAMDAC_REG);
 		}
 
 		/* Fill window type table after start of vertical retrace.  */
@@ -299,15 +308,12 @@ tgafb_set_par(struct fb_info *info)
 		TGA_WRITE_REG(par, 0x01, TGA_INTR_STAT_REG);
 
 		BT463_LOAD_ADDR(par, BT463_WINDOW_TYPE_BASE);
-		TGA_WRITE_REG(par, BT463_REG_ACC<<2, TGA_RAMDAC_SETUP_REG);
+		TGA_WRITE_REG(par, BT463_REG_ACC << 2, TGA_RAMDAC_SETUP_REG);
 
 		for (i = 0; i < 16; i++) {
-			TGA_WRITE_REG(par, 0x00|(BT463_REG_ACC<<10),
-				      TGA_RAMDAC_REG);
-			TGA_WRITE_REG(par, 0x01|(BT463_REG_ACC<<10),
-				      TGA_RAMDAC_REG);
-			TGA_WRITE_REG(par, 0x80|(BT463_REG_ACC<<10),
-				      TGA_RAMDAC_REG);
+			TGA_WRITE_REG(par, 0x00, TGA_RAMDAC_REG);
+			TGA_WRITE_REG(par, 0x01, TGA_RAMDAC_REG);
+			TGA_WRITE_REG(par, 0x00, TGA_RAMDAC_REG);
 		}
 
 	}
@@ -435,9 +441,16 @@ tgafb_setcolreg(unsigned regno, unsigned
 		TGA_WRITE_REG(par, red|(BT485_DATA_PAL<<8),TGA_RAMDAC_REG);
 		TGA_WRITE_REG(par, green|(BT485_DATA_PAL<<8),TGA_RAMDAC_REG);
 		TGA_WRITE_REG(par, blue|(BT485_DATA_PAL<<8),TGA_RAMDAC_REG);
-	} else if (regno < 16) {
-		u32 value = (red << 16) | (green << 8) | blue;
-		((u32 *)info->pseudo_palette)[regno] = value;
+	} else {
+		if (regno < 16) {
+			u32 value = (regno << 16) | (regno << 8) | regno;
+			((u32 *)info->pseudo_palette)[regno] = value;
+		}
+		BT463_LOAD_ADDR(par, regno);
+		TGA_WRITE_REG(par, BT463_PALETTE << 2, TGA_RAMDAC_SETUP_REG);
+		TGA_WRITE_REG(par, red, TGA_RAMDAC_REG);
+		TGA_WRITE_REG(par, green, TGA_RAMDAC_REG);
+		TGA_WRITE_REG(par, blue, TGA_RAMDAC_REG);
 	}
 
 	return 0;
@@ -1317,7 +1330,7 @@ tgafb_init_fix(struct fb_info *info)
 	info->fix.type_aux = 0;
 	info->fix.visual = (tga_type == TGA_TYPE_8PLANE
 			    ? FB_VISUAL_PSEUDOCOLOR
-			    : FB_VISUAL_TRUECOLOR);
+			    : FB_VISUAL_DIRECTCOLOR);
 
 	info->fix.line_length = par->xres * (par->bits_per_pixel >> 3);
 	info->fix.smem_start = (size_t) par->tga_fb_base;
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
i386-io_apic-fix-a-typo-in-an-irq-handler-name.patch
tgafb-switch-to-framebuffer_alloc.patch
tgafb-fix-copying-overlapping-areas.patch
tgafb-support-the-directcolor-visual.patch
tgafb-fix-the-mode-register-setting.patch
tgafb-module-support-fixes.patch
tgafb-sync-on-green-support-fixes.patch

