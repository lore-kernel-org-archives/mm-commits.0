From: akpm@linux-foundation.org
Subject: + cirrusfb-code-improvement-2nd-part.patch added to -mm tree
Date: Mon, 27 Aug 2007 15:23:48 -0700
Message-ID: <200708272223.l7RMNmSg031683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44346 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756751AbXH0WXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 18:23:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     cirrusfb: code improvement 2nd part
has been added to the -mm tree.  Its filename is
     cirrusfb-code-improvement-2nd-part.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cirrusfb: code improvement 2nd part
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch removes:
- redundant fields from the cirrusfb_regs structure
- one redundant header
- fixes two includes ("" to <>)

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   45 ++++++++++++-------------------------
 1 files changed, 15 insertions(+), 30 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-code-improvement-2nd-part drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-code-improvement-2nd-part
+++ a/drivers/video/cirrusfb.c
@@ -45,7 +45,6 @@
 #include <linux/delay.h>
 #include <linux/fb.h>
 #include <linux/init.h>
-#include <linux/selection.h>
 #include <asm/pgtable.h>
 
 #ifdef CONFIG_ZORRO
@@ -64,8 +63,8 @@
 #define isPReP 0
 #endif
 
-#include "video/vga.h"
-#include "video/cirrus.h"
+#include <video/vga.h>
+#include <video/cirrus.h>
 
 /*****************************************************************
  *
@@ -99,9 +98,6 @@
 #endif
 
 #define MB_ (1024 * 1024)
-#define KB_ (1024)
-
-#define MAX_NUM_BOARDS 7
 
 /*****************************************************************
  *
@@ -331,10 +327,6 @@ static const struct {
 #endif /* CONFIG_ZORRO */
 
 struct cirrusfb_regs {
-	__u32 line_length;	/* in BYTES! */
-	__u32 visual;
-	__u32 type;
-
 	long freq;
 	long nom;
 	long den;
@@ -525,7 +517,7 @@ static struct fb_ops cirrusfb_ops = {
 /*--- Hardware Specific Routines -------------------------------------------*/
 static int cirrusfb_decode_var(const struct fb_var_screeninfo *var,
 				struct cirrusfb_regs *regs,
-				const struct fb_info *info);
+				struct fb_info *info);
 /*--- Internal routines ----------------------------------------------------*/
 static void init_vgachip(struct fb_info *info);
 static void switch_monitor(struct cirrusfb_info *cinfo, int on);
@@ -792,7 +784,7 @@ static int cirrusfb_check_var(struct fb_
 
 static int cirrusfb_decode_var(const struct fb_var_screeninfo *var,
 				struct cirrusfb_regs *regs,
-				const struct fb_info *info)
+				struct fb_info *info)
 {
 	long freq;
 	long maxclock;
@@ -803,20 +795,20 @@ static int cirrusfb_decode_var(const str
 
 	switch (var->bits_per_pixel) {
 	case 1:
-		regs->line_length = var->xres_virtual / 8;
-		regs->visual = FB_VISUAL_MONO10;
+		info->fix.line_length = var->xres_virtual / 8;
+		info->fix.visual = FB_VISUAL_MONO10;
 		break;
 
 	case 8:
-		regs->line_length = var->xres_virtual;
-		regs->visual = FB_VISUAL_PSEUDOCOLOR;
+		info->fix.line_length = var->xres_virtual;
+		info->fix.visual = FB_VISUAL_PSEUDOCOLOR;
 		break;
 
 	case 16:
 	case 24:
 	case 32:
-		regs->line_length = var->xres_virtual * maxclockidx;
-		regs->visual = FB_VISUAL_DIRECTCOLOR;
+		info->fix.line_length = var->xres_virtual * maxclockidx;
+		info->fix.visual = FB_VISUAL_DIRECTCOLOR;
 		break;
 
 	default:
@@ -826,7 +818,7 @@ static int cirrusfb_decode_var(const str
 		break;
 	}
 
-	regs->type = FB_TYPE_PACKED_PIXELS;
+	info->fix.type = FB_TYPE_PACKED_PIXELS;
 
 	/* convert from ps to kHz */
 	freq = PICOS2KHZ(var->pixclock);
@@ -1539,9 +1531,6 @@ static int cirrusfb_set_par_foo(struct f
 	DPRINTK("CL_SEQR1: %d\n", tmp);
 
 	cinfo->currentmode = regs;
-	info->fix.type = regs.type;
-	info->fix.visual = regs.visual;
-	info->fix.line_length = regs.line_length;
 
 	/* pan to requested offset */
 	cirrusfb_pan_display(var, info);
@@ -1622,7 +1611,7 @@ static int cirrusfb_pan_display(struct f
 	xoffset = var->xoffset * info->var.bits_per_pixel / 8;
 	yoffset = var->yoffset;
 
-	base = yoffset * cinfo->currentmode.line_length + xoffset;
+	base = yoffset * info->fix.line_length + xoffset;
 
 	if (info->var.bits_per_pixel == 1) {
 		/* base is already correct */
@@ -2081,7 +2070,7 @@ static void cirrusfb_fillrect(struct fb_
 			  (region->dx * m) / 8, region->dy,
 			  (region->width * m) / 8, region->height,
 			  color,
-			  cinfo->currentmode.line_length);
+			  info->fix.line_length);
 }
 
 static void cirrusfb_copyarea(struct fb_info *info,
@@ -2121,7 +2110,7 @@ static void cirrusfb_copyarea(struct fb_
 			(area->sx * m) / 8, area->sy,
 			(area->dx * m) / 8, area->dy,
 			(area->width * m) / 8, area->height,
-			cinfo->currentmode.line_length);
+			info->fix.line_length);
 
 }
 
@@ -2281,13 +2270,10 @@ static int cirrusfb_set_fbinfo(struct fb
 	info->fix.smem_len   = info->screen_size;
 	if (var->bits_per_pixel == 1)
 		info->fix.smem_len /= 4;
-	info->fix.type       = cinfo->currentmode.type;
 	info->fix.type_aux   = 0;
-	info->fix.visual     = cinfo->currentmode.visual;
 	info->fix.xpanstep   = 1;
 	info->fix.ypanstep   = 1;
 	info->fix.ywrapstep  = 0;
-	info->fix.line_length = cinfo->currentmode.line_length;
 
 	/* FIXME: map region at 0xB8000 if available, fill in here */
 	info->fix.mmio_len   = 0;
@@ -2446,7 +2432,7 @@ static int cirrusfb_pci_register(struct 
 	cinfo->unmap = cirrusfb_pci_unmap;
 
 	printk(KERN_INFO " RAM (%lu kB) at 0xx%lx, ",
-		info->screen_size / KB_, board_addr);
+		info->screen_size >> 10, board_addr);
 	printk(KERN_INFO "Cirrus Logic chipset on PCI bus\n");
 	pci_set_drvdata(pdev, info);
 
@@ -2520,7 +2506,6 @@ static int cirrusfb_zorro_register(struc
 	}
 
 	cinfo = info->par;
-	cinfo->info = info;
 	cinfo->btype = btype;
 
 	assert(z > 0);
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
git-arm-master.patch
git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option-pm2fb-lowsyncs-section-mismatch-fix.patch
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
tdfxfb-mtrr-support-fix.patch
tdfxfb-mtrr-support-fix-2.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
pm2fb-permedia-2v-hardware-cursor-support.patch
pm3fb-hardware-cursor-support.patch
s3c2410fb-code-cleanup.patch
s3c2410fb-remove-fb_info-pointer-from-s3c2410fb_info.patch
s3c2410fb-multi-display-support.patch
s3c2410fb-add-margin-fields-to-s3c2410fb_display.patch
s3c2410fb-use-new-margin-fields.patch
s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display.patch
s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display.patch
s3c2410fb-use-vertical-margins-values.patch
s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display.patch
s3c2410fb-remove-lcdcon2-and-lcdcon3-register-fields.patch
s3c2410fb-fix-missing-registers-offset.patch
fbdev-change-asm-uaccessh-to-linux-uaccessh.patch
s3c2410fb-source-code-improvements.patch
s3c2410fb-adds-pixclock-to-s3c2410fb_display.patch
s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display.patch
s3c2410fb-make-use-of-default_display-settings.patch
cirrusfb-checkpatchpl-cleanup.patch
cirrusfb-checkpatchpl-cleanup-ppc-fix.patch
cirrusfb-remove-typedefs.patch
cirrusfb-remove-fields-from-cirrusfb_info.patch
cirrusfb-code-improvements.patch
cirrusfb-code-improvement-2nd-part.patch
pm3fb-header-file-cleanup.patch
pm2fb-hardware-cursor-support-for-the-permedia2.patch
pm2fb-panning-and-hardware-cursor-fixes.patch
