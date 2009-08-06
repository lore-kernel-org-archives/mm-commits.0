From: akpm@linux-foundation.org
Subject: + viafb-merge-viafb_update_viafb_par-in-viafb_update_fix.patch added to -mm tree
Date: Wed, 05 Aug 2009 17:13:06 -0700
Message-ID: <200908060013.n760D60b030323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209AbZHFANM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2009 20:13:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: merge viafb_update_viafb_par in viafb_update_fix
has been added to the -mm tree.  Its filename is
     viafb-merge-viafb_update_viafb_par-in-viafb_update_fix.patch

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
Subject: viafb: merge viafb_update_viafb_par in viafb_update_fix
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Shrink and merge viafb_update_viafb_par.  This removes a lot of duplicated
data in viafb_par.  Use the relevant data of fb_info instead.  On the way
it removes an inconsistency in handling a second framebuffer which only
worked because viafbinfo1->par is modified to point to the same viafb_par
as viafbinfo->par.

Code cleanup only, no runtime change expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/accel.c    |   13 +++------
 drivers/video/via/viafbdev.c |   44 +++++++--------------------------
 drivers/video/via/viafbdev.h |    7 -----
 3 files changed, 15 insertions(+), 49 deletions(-)

diff -puN drivers/video/via/accel.c~viafb-merge-viafb_update_viafb_par-in-viafb_update_fix drivers/video/via/accel.c
--- a/drivers/video/via/accel.c~viafb-merge-viafb_update_viafb_par-in-viafb_update_fix
+++ a/drivers/video/via/accel.c
@@ -34,7 +34,7 @@ void viafb_init_accel(void)
 
 void viafb_init_2d_engine(void)
 {
-	u32 dwVQStartAddr, dwVQEndAddr;
+	u32 dwVQStartAddr, dwVQEndAddr, linesize;
 	u32 dwVQLen, dwVQStartL, dwVQEndL, dwVQStartEndH;
 
 	/* init 2D engine regs to reset 2D engine */
@@ -191,17 +191,14 @@ void viafb_init_2d_engine(void)
 		}
 	}
 
-	viafb_set_2d_color_depth(viaparinfo->bpp);
+	viafb_set_2d_color_depth(viafbinfo->var.bits_per_pixel);
 
 	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCBASE);
 	writel(0x0, viaparinfo->io_virt + VIA_REG_DSTBASE);
 
-	writel(VIA_PITCH_ENABLE |
-		   (((viaparinfo->hres *
-		      viaparinfo->bpp >> 3) >> 3) | (((viaparinfo->hres *
-						   viaparinfo->
-						   bpp >> 3) >> 3) << 16)),
-					viaparinfo->io_virt + VIA_REG_PITCH);
+	linesize = viafbinfo->var.xres * viafbinfo->var.bits_per_pixel >> 3;
+	writel(VIA_PITCH_ENABLE | (linesize >> 3) | ((linesize >> 3) << 16),
+		viaparinfo->io_virt + VIA_REG_PITCH);
 }
 
 void viafb_set_2d_color_depth(int bpp)
diff -puN drivers/video/via/viafbdev.c~viafb-merge-viafb_update_viafb_par-in-viafb_update_fix drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-merge-viafb_update_viafb_par-in-viafb_update_fix
+++ a/drivers/video/via/viafbdev.c
@@ -100,21 +100,17 @@ static const struct viafb_modeinfo viafb
 
 static struct fb_ops viafb_ops;
 
-static int viafb_update_fix(struct fb_fix_screeninfo *fix, struct fb_info *info)
-{
-	struct viafb_par *ppar;
-	ppar = info->par;
-
-	DEBUG_MSG(KERN_INFO "viafb_update_fix!\n");
 
-	fix->visual =
-	    ppar->bpp == 8 ? FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
-	fix->line_length = ppar->linelength;
+static void viafb_update_fix(struct fb_info *info)
+{
+	u32 bpp = info->var.bits_per_pixel;
 
-	return 0;
+	info->fix.visual =
+		bpp == 8 ? FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
+	info->fix.line_length =
+		((info->var.xres_virtual + 7) & ~7) * bpp / 8;
 }
 
-
 static void viafb_setup_fixinfo(struct fb_fix_screeninfo *fix,
 	struct viafb_par *viaparinfo)
 {
@@ -147,19 +143,6 @@ static int viafb_release(struct fb_info 
 	return 0;
 }
 
-static void viafb_update_viafb_par(struct fb_info *info)
-{
-	struct viafb_par *ppar;
-
-	ppar = info->par;
-	ppar->bpp = info->var.bits_per_pixel;
-	ppar->linelength = ((info->var.xres_virtual + 7) & ~7) * ppar->bpp / 8;
-	ppar->hres = info->var.xres;
-	ppar->vres = info->var.yres;
-	ppar->xoffset = info->var.xoffset;
-	ppar->yoffset = info->var.yoffset;
-}
-
 static int viafb_check_var(struct fb_var_screeninfo *var,
 	struct fb_info *info)
 {
@@ -255,12 +238,7 @@ static int viafb_set_par(struct fb_info 
 		/*We should set memory offset according virtual_x */
 		/*Fix me:put this function into viafb_setmode */
 		viafb_memory_pitch_patch(info);
-
-		/* Update ***fb_par information */
-		viafb_update_viafb_par(info);
-
-		/* Update other fixed information */
-		viafb_update_fix(&info->fix, info);
+		viafb_update_fix(info);
 		viafb_bpp = info->var.bits_per_pixel;
 		/* Update viafb_accel, it is necessary to our 2D accelerate */
 		viafb_accel = info->var.accel_flags;
@@ -2323,15 +2301,13 @@ static int __devinit via_pci_probe(void)
 		viafb_setup_fixinfo(&viafbinfo1->fix, viaparinfo1);
 		viafb_check_var(&default_var, viafbinfo1);
 		viafbinfo1->var = default_var;
-		viafb_update_viafb_par(viafbinfo);
-		viafb_update_fix(&viafbinfo1->fix, viafbinfo1);
+		viafb_update_fix(viafbinfo1);
 	}
 
 	viafb_setup_fixinfo(&viafbinfo->fix, viaparinfo);
 	viafb_check_var(&default_var, viafbinfo);
 	viafbinfo->var = default_var;
-	viafb_update_viafb_par(viafbinfo);
-	viafb_update_fix(&viafbinfo->fix, viafbinfo);
+	viafb_update_fix(viafbinfo);
 	default_var.activate = FB_ACTIVATE_NOW;
 	fb_alloc_cmap(&viafbinfo->cmap, 256, 0);
 
diff -puN drivers/video/via/viafbdev.h~viafb-merge-viafb_update_viafb_par-in-viafb_update_fix drivers/video/via/viafbdev.h
--- a/drivers/video/via/viafbdev.h~viafb-merge-viafb_update_viafb_par-in-viafb_update_fix
+++ a/drivers/video/via/viafbdev.h
@@ -38,13 +38,6 @@
 #define VERSION_MINOR       4
 
 struct viafb_par {
-	int bpp;
-	int hres;
-	int vres;
-	int linelength;
-	u32 xoffset;
-	u32 yoffset;
