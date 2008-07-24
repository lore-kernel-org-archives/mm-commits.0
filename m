From: akpm@linux-foundation.org
Subject: - tridentfb-acceleration-constants-change.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:23 -0700
Message-ID: <200807242331.m6ONVNk9011623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756591AbYGXXbZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     tridentfb: acceleration constants change
has been removed from the -mm tree.  Its filename was
     tridentfb-acceleration-constants-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: acceleration constants change
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch replaces deprecated constant FB_ACCELF_TEXT with
FBINFO_HWACCEL_DISABLED and adds constants for Trident families of
accelerators.

The FBINFO_HWACCEL_DISABLED is correctly used so noaccel parameter works
now.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   45 ++++++++++++++++++++++++------------
 include/linux/fb.h        |    4 +++
 2 files changed, 35 insertions(+), 14 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-acceleration-constants-change drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-acceleration-constants-change
+++ a/drivers/video/tridentfb.c
@@ -499,6 +499,10 @@ static void tridentfb_fillrect(struct fb
 	struct tridentfb_par *par = info->par;
 	int col;
 
+	if (info->flags & FBINFO_HWACCEL_DISABLED) {
+		cfb_fillrect(info, fr);
+		return;
+	}
 	if (info->var.bits_per_pixel == 8) {
 		col = fr->color;
 		col |= col << 8;
@@ -516,6 +520,10 @@ static void tridentfb_copyarea(struct fb
 {
 	struct tridentfb_par *par = info->par;
 
+	if (info->flags & FBINFO_HWACCEL_DISABLED) {
+		cfb_copyarea(info, ca);
+		return;
+	}
 	par->wait_engine(par);
 	par->copy_rect(par, ca->sx, ca->sy, ca->dx, ca->dy,
 		       ca->width, ca->height);
@@ -525,7 +533,8 @@ static int tridentfb_sync(struct fb_info
 {
 	struct tridentfb_par *par = info->par;
 
-	par->wait_engine(par);
+	if (!(info->flags & FBINFO_HWACCEL_DISABLED))
+		par->wait_engine(par);
 	return 0;
 }
 #else
@@ -855,8 +864,9 @@ static int tridentfb_check_var(struct fb
 	if (var->yres_virtual > 0xffff)
 		return -EINVAL;
 	line_length = var->xres_virtual * bpp / 8;
-#ifdef CONFIG_FB_TRIDENT_ACCEL
-	if (!is3Dchip(par->chip_id)) {
+
+	if (!is3Dchip(par->chip_id) &&
+	    !(info->flags & FBINFO_HWACCEL_DISABLED)) {
 		/* acceleration requires line length to be power of 2 */
 		if (line_length <= 512)
 			var->xres_virtual = 512 * 8 / bpp;
@@ -873,7 +883,7 @@ static int tridentfb_check_var(struct fb
 
 		line_length = var->xres_virtual * bpp / 8;
 	}
-#endif
+
 	if (var->yres > var->yres_virtual)
 		var->yres_virtual = var->yres;
 	if (line_length * var->yres_virtual > info->fix.smem_len)
@@ -1190,9 +1200,9 @@ static int tridentfb_set_par(struct fb_i
 		set_number_of_lines(par, info->var.yres);
 	info->fix.line_length = info->var.xres_virtual * bpp / 8;
 	set_lwidth(par, info->fix.line_length / 8);
-#ifdef CONFIG_FB_TRIDENT_ACCEL
-	par->init_accel(par, info->var.xres_virtual, bpp);
-#endif
+
+	if (!(info->flags & FBINFO_HWACCEL_DISABLED))
+		par->init_accel(par, info->var.xres_virtual, bpp);
 
 	info->fix.visual = (bpp == 8) ? FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
 	info->cmap.len = (bpp == 8) ? 256 : 16;
@@ -1326,6 +1336,9 @@ static int __devinit trident_pci_probe(s
 		output("*** Please do use cyblafb, Cyberblade/i1 support "
 		       "will soon be removed from tridentfb!\n");
 
+#ifndef CONFIG_FB_TRIDENT_ACCEL
+	noaccel = 1;
+#endif
 
 	/* If PCI id is 0x9660 then further detect chip type */
 
@@ -1370,21 +1383,25 @@ static int __devinit trident_pci_probe(s
 		default_par->wait_engine = xp_wait_engine;
 		default_par->fill_rect = xp_fill_rect;
 		default_par->copy_rect = xp_copy_rect;
+		tridentfb_fix.accel = FB_ACCEL_TRIDENT_BLADEXP;
 	} else if (is_blade(chip_id)) {
 		default_par->init_accel = blade_init_accel;
 		default_par->wait_engine = blade_wait_engine;
 		default_par->fill_rect = blade_fill_rect;
 		default_par->copy_rect = blade_copy_rect;
+		tridentfb_fix.accel = FB_ACCEL_TRIDENT_BLADE3D;
 	} else if (chip3D) {			/* 3DImage family left */
 		default_par->init_accel = image_init_accel;
 		default_par->wait_engine = image_wait_engine;
 		default_par->fill_rect = image_fill_rect;
 		default_par->copy_rect = image_copy_rect;
+		tridentfb_fix.accel = FB_ACCEL_TRIDENT_3DIMAGE;
 	} else { 				/* TGUI 9440/96XX family */
 		default_par->init_accel = tgui_init_accel;
 		default_par->wait_engine = xp_wait_engine;
 		default_par->fill_rect = tgui_fill_rect;
 		default_par->copy_rect = tgui_copy_rect;
+		tridentfb_fix.accel = FB_ACCEL_TRIDENT_TGUI;
 	}
 
 	default_par->chip_id = chip_id;
@@ -1441,9 +1458,13 @@ static int __devinit trident_pci_probe(s
 	info->pseudo_palette = default_par->pseudo_pal;
 
 	info->flags = FBINFO_DEFAULT | FBINFO_HWACCEL_YPAN;
-#ifdef CONFIG_FB_TRIDENT_ACCEL
-	info->flags |= FBINFO_HWACCEL_COPYAREA | FBINFO_HWACCEL_FILLRECT;
-#endif
+	if (!noaccel && default_par->init_accel) {
+		info->flags &= ~FBINFO_HWACCEL_DISABLED;
+		info->flags |= FBINFO_HWACCEL_COPYAREA;
+		info->flags |= FBINFO_HWACCEL_FILLRECT;
+	} else
+		info->flags |= FBINFO_HWACCEL_DISABLED;
+
 	if (!fb_find_mode(&info->var, info,
 			  mode_option, NULL, 0, NULL, bpp)) {
 		err = -EINVAL;
@@ -1453,10 +1474,6 @@ static int __devinit trident_pci_probe(s
 	if (err < 0)
 		goto out_unmap2;
 
-	if (!noaccel && default_par->init_accel)
-		info->var.accel_flags |= FB_ACCELF_TEXT;
-	else
-		info->var.accel_flags &= ~FB_ACCELF_TEXT;
 	info->var.activate |= FB_ACTIVATE_NOW;
 	info->device = &dev->dev;
 	if (register_framebuffer(info) < 0) {
diff -puN include/linux/fb.h~tridentfb-acceleration-constants-change include/linux/fb.h
--- a/include/linux/fb.h~tridentfb-acceleration-constants-change
+++ a/include/linux/fb.h
@@ -120,6 +120,10 @@ struct dentry;
 #define FB_ACCEL_XGI_VOLARI_V	47	/* XGI Volari V3XT, V5, V8      */
 #define FB_ACCEL_XGI_VOLARI_Z	48	/* XGI Volari Z7                */
 #define FB_ACCEL_OMAP1610	49	/* TI OMAP16xx                  */
+#define FB_ACCEL_TRIDENT_TGUI	50	/* Trident TGUI			*/
+#define FB_ACCEL_TRIDENT_3DIMAGE 51	/* Trident 3DImage		*/
+#define FB_ACCEL_TRIDENT_BLADE3D 52	/* Trident Blade3D		*/
+#define FB_ACCEL_TRIDENT_BLADEXP 53	/* Trident BladeXP		*/
 #define FB_ACCEL_NEOMAGIC_NM2070 90	/* NeoMagic NM2070              */
 #define FB_ACCEL_NEOMAGIC_NM2090 91	/* NeoMagic NM2090              */
 #define FB_ACCEL_NEOMAGIC_NM2093 92	/* NeoMagic NM2093              */
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

