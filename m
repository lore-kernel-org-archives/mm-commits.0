From: akpm@linux-foundation.org
Subject: + tdfxfb-checkpatch-fixes.patch added to -mm tree
Date: Fri, 14 Sep 2007 19:25:30 -0700
Message-ID: <200709150225.l8F2PUeG002979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53451 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756255AbXIOCZe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 22:25:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     tdfxfb: checkpatch fixes
has been added to the -mm tree.  Its filename is
     tdfxfb-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: tdfxfb: checkpatch fixes
=46rom: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch fixes all errors pointed by the checkpatch.pl script.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |  136 ++++++++++++++++++++++-----------------
 1 file changed, 77 insertions(+), 59 deletions(-)

diff -puN drivers/video/tdfxfb.c~tdfxfb-checkpatch-fixes drivers/video/=
tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-checkpatch-fixes
+++ a/drivers/video/tdfxfb.c
@@ -4,7 +4,7 @@
  *
  * Author: Hannu Mallat <hmallat@cc.hut.fi>
  *
- * Copyright =A9 1999 Hannu Mallat
+ * Copyright =C2=A9 1999 Hannu Mallat
  * All rights reserved
  *
  * Created      : Thu Sep 23 18:17:43 1999, hmallat
@@ -42,18 +42,18 @@
  *
  * Version history:
  *
- * 0.1.4 (released 2002-05-28) ported over to new fbdev api by James S=
immons
+ * 0.1.4 (released 2002-05-28)	ported over to new fbdev api by James S=
immons
  *
- * 0.1.3 (released 1999-11-02) added Attila's panning support, code
- *			       reorg, hwcursor address page size alignment
- *                             (for mmaping both frame buffer and regs=
),
- *                             and my changes to get rid of hardcoded
- *                             VGA i/o register locations (uses PCI
- *                             configuration info now)
- * 0.1.2 (released 1999-10-19) added Attila Kesmarki's bug fixes and
- *                             improvements
- * 0.1.1 (released 1999-10-07) added Voodoo3 support by Harold Oga.
- * 0.1.0 (released 1999-10-06) initial version
+ * 0.1.3 (released 1999-11-02)	added Attila's panning support, code
+ *				reorg, hwcursor address page size alignment
+ *				(for mmaping both frame buffer and regs),
+ *				and my changes to get rid of hardcoded
+ *				VGA i/o register locations (uses PCI
+ *				configuration info now)
+ * 0.1.2 (released 1999-10-19)	added Attila Kesmarki's bug fixes and
+ *				improvements
+ * 0.1.1 (released 1999-10-07)	added Voodoo3 support by Harold Oga.
+ * 0.1.0 (released 1999-10-06)	initial version
  *
  */
=20
@@ -70,12 +70,7 @@
=20
 #include <video/tdfx.h>
=20
-#undef TDFXFB_DEBUG
-#ifdef TDFXFB_DEBUG
-#define DPRINTK(a,b...) printk(KERN_DEBUG "fb: %s: " a, __FUNCTION__ ,=
 ## b)
-#else
-#define DPRINTK(a,b...)
-#endif
+#define DPRINTK(a, b...) pr_debug("fb: %s: " a, __FUNCTION__ , ## b)
=20
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
@@ -172,7 +167,7 @@ static char *mode_option __devinitdata;
 static int nomtrr __devinitdata;
=20
 /* -------------------------------------------------------------------=
------
- *                      Hardware-specific funcions
+ *			Hardware-specific funcions
  * -------------------------------------------------------------------=
------ */
=20
 static inline u8 vga_inb(struct tdfx_par *par, u32 reg)
@@ -276,7 +271,7 @@ static inline void banshee_make_room(str
 	while ((tdfx_inl(par, STATUS) & 0x1f) < size - 1)
 		cpu_relax();
 }
-=20
+
 static int banshee_wait_idle(struct fb_info *info)
 {
 	struct tdfx_par *par =3D info->par;
@@ -286,8 +281,8 @@ static int banshee_wait_idle(struct fb_i
 	tdfx_outl(par, COMMAND_3D, COMMAND_3D_NOP);
=20
 	do {
- 		if ((tdfx_inl(par, STATUS) & STATUS_BUSY) =3D=3D 0)
-		       i++;
+		if ((tdfx_inl(par, STATUS) & STATUS_BUSY) =3D=3D 0)
+			i++;
 	} while (i < 3);
=20
 	return 0;
@@ -297,7 +292,7 @@ static int banshee_wait_idle(struct fb_i
  * Set the color of a palette entry in 8bpp mode
  */
 static inline void do_setpalentry(struct tdfx_par *par, unsigned regno=
, u32 c)
-{ =20
+{
 	banshee_make_room(par, 2);
 	tdfx_outl(par, DACADDR, regno);
 	/* read after write makes it working */
@@ -475,8 +470,12 @@ static int tdfxfb_check_var(struct fb_va
 	}
 	var->yoffset =3D 0;
=20
-	/* Banshee doesn't support interlace, but Voodoo4/5 and probably Vood=
oo3 do. */
-	/* no direct information about device id now? use max_pixclock for th=
is... */
+	/*
+	 * Banshee doesn't support interlace, but Voodoo4/5 and probably
+	 * Voodoo3 do.
+	 * no direct information about device id now?
+	 *  use max_pixclock for this...
+	 */
 	if (((var->vmode & FB_VMODE_MASK) =3D=3D FB_VMODE_INTERLACED) &&
 	    (par->max_pixclock < VOODOO3_MAX_PIXCLOCK)) {
 		DPRINTK("interlace not supported\n");
@@ -516,7 +515,10 @@ static int tdfxfb_check_var(struct fb_va
 	var->transp.length =3D 0;
 	switch (var->bits_per_pixel) {
 	case 8:
-		var->red.length =3D var->green.length =3D var->blue.length =3D 8;
+		var->red.length =3D 8;
+		var->red.offset =3D 0;
+		var->green =3D var->red;
+		var->blue =3D var->red;
 		break;
 	case 16:
 		var->red.offset   =3D 11;
@@ -536,7 +538,8 @@ static int tdfxfb_check_var(struct fb_va
 		var->red.length =3D var->green.length =3D var->blue.length =3D 8;
 		break;
 	}
-	var->height =3D var->width =3D -1;
+	var->width =3D -1;
+	var->height =3D -1;
=20
 	var->accel_flags =3D FB_ACCELF_TEXT;
=20
@@ -581,7 +584,8 @@ static int tdfxfb_set_par(struct fb_info
 		htotal   >>=3D 1;
 	}
=20
-	hd  =3D wd =3D (hdispend >> 3) - 1;
+	wd =3D (hdispend >> 3) - 1;
+	hd  =3D wd;
 	hs  =3D (hsyncsta >> 3) - 1;
 	he  =3D (hsyncend >> 3) - 1;
 	ht  =3D (htotal >> 3) - 1;
@@ -589,21 +593,23 @@ static int tdfxfb_set_par(struct fb_info
 	hbe =3D ht;
=20
 	if ((info->var.vmode & FB_VMODE_MASK) =3D=3D FB_VMODE_DOUBLE) {
-		vbs =3D vd =3D (info->var.yres << 1) - 1;
+		vd =3D (info->var.yres << 1) - 1;
 		vs  =3D vd + (info->var.lower_margin << 1);
 		ve  =3D vs + (info->var.vsync_len << 1);
-		vbe =3D vt =3D ve + (info->var.upper_margin << 1) - 1;
+		vt =3D ve + (info->var.upper_margin << 1) - 1;
 		reg.screensize =3D info->var.xres | (info->var.yres << 13);
 		reg.vidcfg |=3D VIDCFG_HALF_MODE;
 		reg.crt[0x09] =3D 0x80;
 	} else {
-		vbs =3D vd =3D info->var.yres - 1;
+		vd =3D info->var.yres - 1;
 		vs  =3D vd + info->var.lower_margin;
 		ve  =3D vs + info->var.vsync_len;
-		vbe =3D vt =3D ve + info->var.upper_margin - 1;
+		vt =3D ve + info->var.upper_margin - 1;
 		reg.screensize =3D info->var.xres | (info->var.yres << 12);
 		reg.vidcfg &=3D ~VIDCFG_HALF_MODE;
 	}
+	vbs =3D vd;
+	vbe =3D vt;
=20
 	/* this is all pretty standard VGA register stuffing */
 	reg.misc[0x00] =3D 0x0f |
@@ -736,7 +742,7 @@ static int tdfxfb_set_par(struct fb_info
 }
=20
 /* A handy macro shamelessly pinched from matroxfb */
-#define CNVT_TOHW(val, width) ((((val)<<(width))+0x7FFF-(val))>>16)
+#define CNVT_TOHW(val, width) ((((val) << (width)) + 0x7FFF - (val)) >=
> 16)
=20
 static int tdfxfb_setcolreg(unsigned regno, unsigned red, unsigned gre=
en,
 			    unsigned blue, unsigned transp,
@@ -751,14 +757,16 @@ static int tdfxfb_setcolreg(unsigned reg
 	/* grayscale works only partially under directcolor */
 	if (info->var.grayscale) {
 		/* grayscale =3D 0.30*R + 0.59*G + 0.11*B */
-		red =3D green =3D blue =3D (red * 77 + green * 151 + blue * 28) >> 8=
;
+		blue =3D (red * 77 + green * 151 + blue * 28) >> 8;
+		green =3D blue;
+		red =3D blue;
 	}
=20
 	switch (info->fix.visual) {
 	case FB_VISUAL_PSEUDOCOLOR:
-		rgbcol =3D(((u32)red   & 0xff00) << 8) |
-			(((u32)green & 0xff00) << 0) |
-			(((u32)blue  & 0xff00) >> 8);
+		rgbcol =3D (((u32)red   & 0xff00) << 8) |
+			 (((u32)green & 0xff00) << 0) |
+			 (((u32)blue  & 0xff00) >> 8);
 		do_setpalentry(par, regno, rgbcol);
 		break;
 	/* Truecolor has no hardware color palettes. */
@@ -851,7 +859,7 @@ static void tdfxfb_fillrect(struct fb_in
 	struct tdfx_par *par =3D info->par;
 	u32 bpp =3D info->var.bits_per_pixel;
 	u32 stride =3D info->fix.line_length;
-	u32 fmt=3D stride | ((bpp + ((bpp =3D=3D 8) ? 0 : 8)) << 13);
+	u32 fmt =3D stride | ((bpp + ((bpp =3D=3D 8) ? 0 : 8)) << 13);
 	int tdfx_rop;
 	u32 dx =3D rect->dx;
 	u32 dy =3D rect->dy;
@@ -922,13 +930,13 @@ static void tdfxfb_copyarea(struct fb_in
 	}
=20
 	if (area->sx <=3D area->dx) {
-		//-X
+		/* -X */
 		blitcmd |=3D BIT(14);
 		sx +=3D area->width - 1;
 		dx +=3D area->width - 1;
 	}
 	if (area->sy <=3D area->dy) {
-		//-Y
+		/* -Y */
 		blitcmd |=3D BIT(15);
 		sy +=3D area->height - 1;
 		dy +=3D area->height - 1;
@@ -961,9 +969,13 @@ static void tdfxfb_imageblit(struct fb_i
 	u32 dstbase =3D 0;
=20
 	if (image->depth !=3D 1) {
-		//banshee_make_room(par, 6 + ((size + 3) >> 2));
-		//srcfmt =3D stride | ((bpp+((bpp=3D=3D8) ? 0 : 8)) << 13) | 0x40000=
0;
+#ifdef BROKEN_CODE
+		banshee_make_room(par, 6 + ((size + 3) >> 2));
+		srcfmt =3D stride | ((bpp + ((bpp =3D=3D 8) ? 0 : 8)) << 13) |
+			0x400000;
+#else
 		cfb_imageblit(info, image);
+#endif
 		return;
 	}
 	banshee_make_room(par, 9);
@@ -998,7 +1010,8 @@ static void tdfxfb_imageblit(struct fb_i
 	tdfx_outl(par, DSTBASE, dstbase);
 	tdfx_outl(par, SRCXY, 0);
 	tdfx_outl(par, DSTXY, dx | (dy << 16));
-	tdfx_outl(par, COMMAND_2D, COMMAND_2D_H2S_BITBLT | (TDFX_ROP_COPY << =
24));
+	tdfx_outl(par, COMMAND_2D,
+		  COMMAND_2D_H2S_BITBLT | (TDFX_ROP_COPY << 24));
 	tdfx_outl(par, SRCFORMAT, srcfmt);
 	tdfx_outl(par, DSTFORMAT, dstfmt);
 	tdfx_outl(par, DSTSIZE, image->width | (image->height << 16));
@@ -1013,7 +1026,7 @@ static void tdfxfb_imageblit(struct fb_i
 			fifo_free =3D 31;
 			banshee_make_room(par, fifo_free);
 		}
-		tdfx_outl(par, LAUNCH_2D, *(u32*)chardata);
+		tdfx_outl(par, LAUNCH_2D, *(u32 *)chardata);
 		chardata +=3D 4;
 	}
=20
@@ -1026,11 +1039,11 @@ static void tdfxfb_imageblit(struct fb_i
 		tdfx_outl(par, LAUNCH_2D, *chardata);
 		break;
 	case 2:
-		tdfx_outl(par, LAUNCH_2D, *(u16*)chardata);
+		tdfx_outl(par, LAUNCH_2D, *(u16 *)chardata);
 		break;
 	case 3:
 		tdfx_outl(par, LAUNCH_2D,
-			*(u16*)chardata | ((chardata[3]) << 24));
+			*(u16 *)chardata | (chardata[3] << 24));
 		break;
 	}
 }
@@ -1175,8 +1188,9 @@ static int __devinit tdfxfb_probe(struct
 	struct fb_info *info;
 	int err, lpitch;
=20
-	if ((err =3D pci_enable_device(pdev))) {
-		printk(KERN_WARNING "tdfxfb: Can't enable pdev: %d\n", err);
+	err =3D pci_enable_device(pdev);
+	if (err) {
+		printk(KERN_ERR "tdfxfb: Can't enable pdev: %d\n", err);
 		return err;
 	}
=20
@@ -1207,33 +1221,36 @@ static int __devinit tdfxfb_probe(struct
 	tdfx_fix.mmio_len =3D pci_resource_len(pdev, 0);
 	if (!request_mem_region(tdfx_fix.mmio_start, tdfx_fix.mmio_len,
 				"tdfx regbase")) {
-		printk(KERN_WARNING "tdfxfb: Can't reserve regbase\n");
+		printk(KERN_ERR "tdfxfb: Can't reserve regbase\n");
 		goto out_err;
 	}
=20
 	default_par->regbase_virt =3D
 		ioremap_nocache(tdfx_fix.mmio_start, tdfx_fix.mmio_len);
 	if (!default_par->regbase_virt) {
-		printk("fb: Can't remap %s register area.\n", tdfx_fix.id);
+		printk(KERN_ERR "fb: Can't remap %s register area.\n",
+				tdfx_fix.id);
 		goto out_err_regbase;
 	}
=20
 	tdfx_fix.smem_start =3D pci_resource_start(pdev, 1);
-	if (!(tdfx_fix.smem_len =3D do_lfb_size(default_par, pdev->device))) =
{
-		printk("fb: Can't count %s memory.\n", tdfx_fix.id);
+	tdfx_fix.smem_len =3D do_lfb_size(default_par, pdev->device);
+	if (!tdfx_fix.smem_len) {
+		printk(KERN_ERR "fb: Can't count %s memory.\n", tdfx_fix.id);
 		goto out_err_regbase;
 	}
=20
 	if (!request_mem_region(tdfx_fix.smem_start,
 				pci_resource_len(pdev, 1), "tdfx smem")) {
-		printk(KERN_WARNING "tdfxfb: Can't reserve smem\n");
+		printk(KERN_ERR "tdfxfb: Can't reserve smem\n");
 		goto out_err_regbase;
 	}
=20
 	info->screen_base =3D ioremap_nocache(tdfx_fix.smem_start,
 					    tdfx_fix.smem_len);
 	if (!info->screen_base) {
-		printk("fb: Can't remap %s framebuffer.\n", tdfx_fix.id);
+		printk(KERN_ERR "fb: Can't remap %s framebuffer.\n",
+				tdfx_fix.id);
 		goto out_err_screenbase;
 	}
=20
@@ -1241,11 +1258,12 @@ static int __devinit tdfxfb_probe(struct
=20
 	if (!request_region(pci_resource_start(pdev, 2),
 			    pci_resource_len(pdev, 2), "tdfx iobase")) {
-		printk(KERN_WARNING "tdfxfb: Can't reserve iobase\n");
+		printk(KERN_ERR "tdfxfb: Can't reserve iobase\n");
 		goto out_err_screenbase;
 	}
=20
-	printk("fb: %s memory =3D %dK\n", tdfx_fix.id, tdfx_fix.smem_len >> 1=
0);
+	printk(KERN_INFO "fb: %s memory =3D %dK\n", tdfx_fix.id,
+			tdfx_fix.smem_len >> 10);
=20
 	default_par->mtrr_handle =3D -1;
 	if (!nomtrr)
@@ -1261,7 +1279,7 @@ static int __devinit tdfxfb_probe(struct
 	info->pseudo_palette	=3D default_par->palette;
 	info->flags		=3D FBINFO_DEFAULT | FBINFO_HWACCEL_YPAN;
 #ifdef CONFIG_FB_3DFX_ACCEL
-	info->flags             |=3D FBINFO_HWACCEL_FILLRECT |
+	info->flags		|=3D FBINFO_HWACCEL_FILLRECT |
 				   FBINFO_HWACCEL_COPYAREA |
 				   FBINFO_HWACCEL_IMAGEBLIT |
 				   FBINFO_READS_FAST;
@@ -1286,12 +1304,12 @@ static int __devinit tdfxfb_probe(struct
 		goto out_err_iobase;
=20
 	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0) {
-		printk(KERN_WARNING "tdfxfb: Can't allocate color map\n");
+		printk(KERN_ERR "tdfxfb: Can't allocate color map\n");
 		goto out_err_iobase;
 	}
=20
 	if (register_framebuffer(info) < 0) {
-		printk("tdfxfb: can't register framebuffer\n");
+		printk(KERN_ERR "tdfxfb: can't register framebuffer\n");
 		fb_dealloc_cmap(&info->cmap);
 		goto out_err_iobase;
 	}
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

git-alsa.patch
git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patc=
h
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option-pm2fb-lowsyncs-section-mismatch-f=
ix.patch
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
tdfxfb-replace-busy-waiting-with-cpu_relax.patch
pm2fb-replace-busy-waiting-with-cpu_relax.patch
pm3fb-replace-busy-waiting-with-cpu_relax.patch
tdfxfb-checkpatch-fixes.patch
