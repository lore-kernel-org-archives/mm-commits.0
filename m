From: akpm@linux-foundation.org
Subject: + tridentfb-source-code-improvements.patch added to -mm tree
Date: Tue, 20 May 2008 02:18:21 -0700
Message-ID: <200805200918.m4K9IL28015174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759268AbYETJSX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 05:18:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     tridentfb: source code improvements
has been added to the -mm tree.  Its filename is
     tridentfb-source-code-improvements.patch

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
Subject: tridentfb: source code improvements
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch contains general source code improvments:
 - more simple functions are inline
 - removes some meaningless output and the VERSION
   string as it is no use
 - eng_par is moved into the tridentfb_par
 - removed small section of code for CyberBladeXPAi1
   which is maybe right for only one resolution
   and refresh rate and is probably redundant now
 - other minor improvements

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   83 +++++++++++++-----------------------
 include/video/trident.h   |    4 -
 2 files changed, 32 insertions(+), 55 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-source-code-improvements drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-source-code-improvements
+++ a/drivers/video/tridentfb.c
@@ -24,8 +24,6 @@
 #include <video/vga.h>
 #include <video/trident.h>
 
-#define VERSION		"0.7.9-NEWAPI"
-
 struct tridentfb_par {
 	void __iomem *io_virt;	/* iospace virtual memory address */
 	u32 pseudo_pal[16];
@@ -37,9 +35,9 @@ struct tridentfb_par {
 		(struct tridentfb_par *par, u32, u32, u32, u32, u32, u32);
 	void (*copy_rect)
 		(struct tridentfb_par *par, u32, u32, u32, u32, u32, u32);
+	unsigned char eng_oper;	/* engine operation... */
 };
 
-static unsigned char eng_oper;	/* engine operation... */
 static struct fb_ops tridentfb_ops;
 
 static struct fb_fix_screeninfo tridentfb_fix = {
@@ -53,7 +51,7 @@ static struct fb_fix_screeninfo tridentf
 /* defaults which are normally overriden by user values */
 
 /* video mode */
-static char *mode_option __devinitdata = "640x480";
+static char *mode_option __devinitdata = "640x480-8@60";
 static int bpp __devinitdata = 8;
 
 static int noaccel __devinitdata;
@@ -84,24 +82,22 @@ MODULE_PARM_DESC(fp, "Define if flatpane
 module_param(crt, int, 0);
 MODULE_PARM_DESC(crt, "Define if CRT is connected");
 
-static int is_oldclock(int id)
+static inline int is_oldclock(int id)
 {
 	return	(id == TGUI9440) ||
 		(id == TGUI9660) ||
 		(id == CYBER9320);
 }
 
-static int is_oldprotect(int id)
+static inline int is_oldprotect(int id)
 {
-	return	(id == TGUI9440) ||
-		(id == TGUI9660) ||
+	return	is_oldclock(id) ||
 		(id == PROVIDIA9685) ||
-		(id == CYBER9320) ||
 		(id == CYBER9382) ||
 		(id == CYBER9385);
 }
 
-static int is_blade(int id)
+static inline int is_blade(int id)
 {
 	return	(id == BLADE3D) ||
 		(id == CYBERBLADEE4) ||
@@ -113,27 +109,22 @@ static int is_blade(int id)
 		(id == CYBERBLADEAi1D);
 }
 
-static int is_xp(int id)
+static inline int is_xp(int id)
 {
 	return	(id == CYBERBLADEXPAi1) ||
 		(id == CYBERBLADEXPm8) ||
 		(id == CYBERBLADEXPm16);
 }
 
-static int is3Dchip(int id)
+static inline int is3Dchip(int id)
 {
-	return ((id == BLADE3D) || (id == CYBERBLADEE4) ||
-		(id == CYBERBLADEi7) || (id == CYBERBLADEi7D) ||
+	return	is_blade(id) || is_xp(id) ||
 		(id == CYBER9397) || (id == CYBER9397DVD) ||
 		(id == CYBER9520) || (id == CYBER9525DVD) ||
-		(id == IMAGE975) || (id == IMAGE985) ||
-		(id == CYBERBLADEi1) || (id == CYBERBLADEi1D) ||
-		(id == CYBERBLADEAi1) || (id == CYBERBLADEAi1D) ||
-		(id == CYBERBLADEXPm8) || (id == CYBERBLADEXPm16) ||
-		(id == CYBERBLADEXPAi1));
+		(id == IMAGE975) || (id == IMAGE985);
 }
 
-static int iscyber(int id)
+static inline int iscyber(int id)
 {
 	switch (id) {
 	case CYBER9388:
@@ -153,13 +144,7 @@ static int iscyber(int id)
 		return 1;
 
 	case CYBER9320:
-	case TGUI9660:
-	case PROVIDIA9685:
-	case IMAGE975:
-	case IMAGE985:
-	case BLADE3D:
 	case CYBERBLADEi7:	/* VIA MPV4 integrated version */
-
 	default:
 		/* case CYBERBLDAEXPm8:  Strange */
 		/* case CYBERBLDAEXPm16: Strange */
@@ -275,7 +260,7 @@ static void xp_init_accel(struct trident
 
 	t_outb(par, x, 0x2125);
 
-	eng_oper = x | 0x40;
+	par->eng_oper = x | 0x40;
 
 	writemmr(par, 0x2154, v1);
 	writemmr(par, 0x2150, v1);
@@ -284,10 +269,9 @@ static void xp_init_accel(struct trident
 
 static void xp_wait_engine(struct tridentfb_par *par)
 {
-	int count, timeout;
+	int count = 0;
+	int timeout = 0;
 
-	count = 0;
-	timeout = 0;
 	while (t_inb(par, STATUS) & 0x80) {
 		count++;
 		if (count == 10000000) {
@@ -313,16 +297,14 @@ static void xp_fill_rect(struct tridentf
 	writemmr(par, OLDDIM, point(h, w));
 	writemmr(par, OLDDST, point(y, x));
 	t_outb(par, 0x01, OLDCMD);
-	t_outb(par, eng_oper, 0x2125);
+	t_outb(par, par->eng_oper, 0x2125);
 }
 
 static void xp_copy_rect(struct tridentfb_par *par,
 			 u32 x1, u32 y1, u32 x2, u32 y2, u32 w, u32 h)
 {
-	int direction;
 	u32 x1_tmp, x2_tmp, y1_tmp, y2_tmp;
-
-	direction = 0x0004;
+	int direction = 0x0004;
 
 	if ((x1 < x2) && (y1 == y2)) {
 		direction |= 0x0200;
@@ -602,7 +584,7 @@ static void disable_mmio(struct tridentf
 	t_outb(par, t_inb(par, 0x3D5) & ~0x01, 0x3D5);
 }
 
-static void crtc_unlock(struct tridentfb_par *par)
+static inline void crtc_unlock(struct tridentfb_par *par)
 {
 	write3X4(par, VGA_CRTC_V_SYNC_END,
 		 read3X4(par, VGA_CRTC_V_SYNC_END) & 0x7F);
@@ -642,7 +624,7 @@ static int __devinit get_nativex(struct 
 }
 
 /* Set pitch */
-static void set_lwidth(struct tridentfb_par *par, int width)
+static inline void set_lwidth(struct tridentfb_par *par, int width)
 {
 	write3X4(par, VGA_CRTC_OFFSET, width & 0xFF);
 	write3X4(par, AddColReg,
@@ -661,7 +643,7 @@ static void screen_stretch(struct triden
 }
 
 /* For resolutions smaller than FP resolution center */
-static void screen_center(struct tridentfb_par *par)
+static inline void screen_center(struct tridentfb_par *par)
 {
 	write3CE(par, VertStretch, (read3CE(par, VertStretch) & 0x7C) | 0x80);
 	write3CE(par, HorStretch, (read3CE(par, HorStretch) & 0x7C) | 0x80);
@@ -967,12 +949,12 @@ static int tridentfb_pan_display(struct 
 	return 0;
 }
 
-static void shadowmode_on(struct tridentfb_par *par)
+static inline void shadowmode_on(struct tridentfb_par *par)
 {
 	write3CE(par, CyberControl, read3CE(par, CyberControl) | 0x81);
 }
 
-static void shadowmode_off(struct tridentfb_par *par)
+static inline void shadowmode_off(struct tridentfb_par *par)
 {
 	write3CE(par, CyberControl, read3CE(par, CyberControl) & 0x7E);
 }
@@ -980,7 +962,7 @@ static void shadowmode_off(struct triden
 /* Set the hardware to the requested video mode */
 static int tridentfb_set_par(struct fb_info *info)
 {
-	struct tridentfb_par *par = (struct tridentfb_par *)(info->par);
+	struct tridentfb_par *par = info->par;
 	u32 htotal, hdispend, hsyncstart, hsyncend, hblankstart, hblankend;
 	u32 vtotal, vdispend, vsyncstart, vsyncend, vblankstart, vblankend;
 	struct fb_var_screeninfo *var = &info->var;
@@ -1159,11 +1141,6 @@ static int tridentfb_set_par(struct fb_i
 	write3CE(par, 0x6, 0x05);	/* graphics mode */
 	write3CE(par, 0x7, 0x0F);	/* planes? */
 
-	if (par->chip_id == CYBERBLADEXPAi1) {
-		/* This fixes snow-effect in 32 bpp */
-		write3X4(par, VGA_CRTC_H_SYNC_START, 0x84);
-	}
-
 	/* graphics mode and support 256 color modes */
 	writeAttr(par, 0x10, 0x41);
 	writeAttr(par, 0x12, 0x0F);	/* planes */
@@ -1238,7 +1215,7 @@ static int tridentfb_setcolreg(unsigned 
 			col |= col << 16;
 			((u32 *)(info->pseudo_palette))[regno] = col;
 		} else if (bpp == 32)		/* ARGB 8888 */
-			((u32*)info->pseudo_palette)[regno] =
+			((u32 *)info->pseudo_palette)[regno] =
 				((transp & 0xFF00) << 16)	|
 				((red & 0xFF00) << 8)		|
 				((green & 0xFF00))		|
@@ -1249,7 +1226,7 @@ static int tridentfb_setcolreg(unsigned 
 	return 0;
 }
 
-/* Try blanking the screen.For flat panels it does nothing */
+/* Try blanking the screen. For flat panels it does nothing */
 static int tridentfb_blank(int blank_mode, struct fb_info *info)
 {
 	unsigned char PMCont, DPMSCont;
@@ -1408,9 +1385,10 @@ static int __devinit trident_pci_probe(s
 
 	/* setup MMIO region */
 	tridentfb_fix.mmio_start = pci_resource_start(dev, 1);
-	tridentfb_fix.mmio_len = chip3D ? 0x20000 : 0x10000;
+	tridentfb_fix.mmio_len = pci_resource_len(dev, 1);
 
-	if (!request_mem_region(tridentfb_fix.mmio_start, tridentfb_fix.mmio_len, "tridentfb")) {
+	if (!request_mem_region(tridentfb_fix.mmio_start,
+				tridentfb_fix.mmio_len, "tridentfb")) {
 		debug("request_region failed!\n");
 		framebuffer_release(info);
 		return -1;
@@ -1431,7 +1409,8 @@ static int __devinit trident_pci_probe(s
 	tridentfb_fix.smem_start = pci_resource_start(dev, 0);
 	tridentfb_fix.smem_len = get_memsize(default_par);
 
-	if (!request_mem_region(tridentfb_fix.smem_start, tridentfb_fix.smem_len, "tridentfb")) {
+	if (!request_mem_region(tridentfb_fix.smem_start,
+				tridentfb_fix.smem_len, "tridentfb")) {
 		debug("request_mem_region failed!\n");
 		disable_mmio(info->par);
 		err = -1;
@@ -1447,7 +1426,6 @@ static int __devinit trident_pci_probe(s
 		goto out_unmap2;
 	}
 
-	output("%s board found\n", pci_name(dev));
 	default_par->flatpanel = is_flatpanel(default_par);
 
 	if (default_par->flatpanel)
@@ -1477,7 +1455,7 @@ static int __devinit trident_pci_probe(s
 	info->var.activate |= FB_ACTIVATE_NOW;
 	info->device = &dev->dev;
 	if (register_framebuffer(info) < 0) {
-		printk(KERN_ERR "tridentfb: could not register Trident framebuffer\n");
+		printk(KERN_ERR "tridentfb: could not register framebuffer\n");
 		fb_dealloc_cmap(&info->cmap);
 		err = -EINVAL;
 		goto out_unmap2;
@@ -1599,7 +1577,6 @@ static int __init tridentfb_init(void)
 		return -ENODEV;
 	tridentfb_setup(option);
 #endif
-	output("Trident framebuffer %s initializing\n", VERSION);
 	return pci_register_driver(&tridentfb_pci_driver);
 }
 
diff -puN include/video/trident.h~tridentfb-source-code-improvements include/video/trident.h
--- a/include/video/trident.h~tridentfb-source-code-improvements
+++ a/include/video/trident.h
@@ -4,9 +4,9 @@
 #endif
 
 #if TRIDENTFB_DEBUG
-#define debug(f,a...)	printk("%s:" f,  __FUNCTION__ , ## a);mdelay(100);
+#define debug(f, a...)	printk("%s:" f,  __func__ , ## a);
 #else
-#define debug(f,a...)
+#define debug(f, a...)
 #endif
 
 #define output(f, a...) pr_info("tridentfb: " f, ## a)
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

tridentfb-replace-macros-with-functions.patch
tridentfb-convert-fb_info-into-allocated-one.patch
tridentfb-move-global-pseudo-palette-into-structure.patch
tridentfb-move-global-chip_id-into-structure.patch
tridentfb-move-global-flat-panel-variable-into-structure.patch
tridentfb-convert-is_blade-and-is_xp-macros-into-functions.patch
tridentfb-move-global-acceleration-hooks-into-structure.patch
tridentfb-make-use-of-functions-and-constants-from-the-vgah.patch
tridentfb-fix-timing-calculations.patch
tridentfb-use-mmio-access-for-clock-setting.patch
tridentfb-fix-clock-settings-for-older-trident-96xx-chips.patch
tridentfb-improve-probe-function.patch
tridentfb-improved-register-values-on-tgui-9680.patch
tridentfb-add-tgui-9440-support.patch
tridentfb-fix-unitialized-pseudo_palette.patch
tridentfb-improve-check_var-function.patch
tridentfb-preserve-memory-type-settings.patch
tridentfb-fix-hi-color-modes-for-tgui-9440.patch
tridentfb-add-acceleration-for-tgui-families.patch
tridentfb-acceleration-code-improvements.patch
tridentfb-acceleration-bug-fixes.patch
tridentfb-various-pixclock-and-timing-improvements.patch
tridentfb-acceleration-constants-change.patch
tridentfb-source-code-improvements.patch
tridentfb-fix-console-freeze-when-switching-from-x11.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch

