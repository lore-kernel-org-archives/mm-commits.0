From: akpm@linux-foundation.org
Subject: + tridentfb-move-global-flat-panel-variable-into-structure.patch added to -mm tree
Date: Mon, 05 May 2008 23:12:25 -0700
Message-ID: <200805060612.m466CPN5025134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754149AbYEFGM5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 02:12:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net


The patch titled
     tridentfb: move global flat panel variable into structure
has been added to the -mm tree.  Its filename is
     tridentfb-move-global-flat-panel-variable-into-structure.patch

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
Subject: tridentfb: move global flat panel variable into structure
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch moves flat panel indicator into tridentfb_par structure and removes
related global variables and macros.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   44 ++++++++++++++++++------------------
 include/video/trident.h   |    6 ----
 2 files changed, 23 insertions(+), 27 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-move-global-flat-panel-variable-into-structure drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-move-global-flat-panel-variable-into-structure
+++ a/drivers/video/tridentfb.c
@@ -30,6 +30,7 @@ struct tridentfb_par {
 	void __iomem *io_virt;	/* iospace virtual memory address */
 	u32 pseudo_pal[16];
 	int chip_id;
+	int flatpanel;
 };
 
 static unsigned char eng_oper;	/* engine operation... */
@@ -43,24 +44,22 @@ static struct fb_fix_screeninfo tridentf
 	.accel = FB_ACCEL_NONE,
 };
 
-static int displaytype;
-
 /* defaults which are normally overriden by user values */
 
 /* video mode */
 static char *mode_option __devinitdata = "640x480";
-static int bpp = 8;
+static int bpp __devinitdata = 8;
 
-static int noaccel;
+static int noaccel __devinitdata;
 
 static int center;
 static int stretch;
 
-static int fp;
-static int crt;
+static int fp __devinitdata;
+static int crt __devinitdata;
 
-static int memsize;
-static int memdiff;
+static int memsize __devinitdata;
+static int memdiff __devinitdata;
 static int nativex;
 
 module_param(mode_option, charp, 0);
@@ -75,7 +74,9 @@ module_param(memsize, int, 0);
 module_param(memdiff, int, 0);
 module_param(nativex, int, 0);
 module_param(fp, int, 0);
+MODULE_PARM_DESC(fp, "Define if flatpanel is connected");
 module_param(crt, int, 0);
+MODULE_PARM_DESC(crt, "Define if CRT is connected");
 
 static int is3Dchip(int id)
 {
@@ -728,15 +729,15 @@ static void set_number_of_lines(struct t
 
 /*
  * If we see that FP is active we assume we have one.
- * Otherwise we have a CRT display.User can override.
+ * Otherwise we have a CRT display. User can override.
  */
-static unsigned int __devinit get_displaytype(struct tridentfb_par *par)
+static int __devinit is_flatpanel(struct tridentfb_par *par)
 {
 	if (fp)
-		return DISPLAY_FP;
+		return 1;
 	if (crt || !iscyber(par->chip_id))
-		return DISPLAY_CRT;
-	return (read3CE(par, FPConfig) & 0x10) ? DISPLAY_FP : DISPLAY_CRT;
+		return 0;
+	return (read3CE(par, FPConfig) & 0x10) ? 1 : 0;
 }
 
 /* Try detecting the video memory size */
@@ -824,6 +825,7 @@ static unsigned int __devinit get_memsiz
 static int tridentfb_check_var(struct fb_var_screeninfo *var,
 			       struct fb_info *info)
 {
+	struct tridentfb_par *par = info->par;
 	int bpp = var->bits_per_pixel;
 	debug("enter\n");
 
@@ -831,7 +833,7 @@ static int tridentfb_check_var(struct fb
 	if (bpp == 24)
 		bpp = var->bits_per_pixel = 32;
 	/* check whether resolution fits on panel and in memory */
-	if (flatpanel && nativex && var->xres > nativex)
+	if (par->flatpanel && nativex && var->xres > nativex)
 		return -EINVAL;
 	if (var->xres * var->yres_virtual * bpp / 8 > info->fix.smem_len)
 		return -EINVAL;
@@ -928,7 +930,7 @@ static int tridentfb_set_par(struct fb_i
 	crtc_unlock(par);
 	write3CE(par, CyberControl, 8);
 
-	if (flatpanel && var->xres < nativex) {
+	if (par->flatpanel && var->xres < nativex) {
 		/*
 		 * on flat panels with native size larger
 		 * than requested resolution decide whether
@@ -1097,7 +1099,7 @@ static int tridentfb_set_par(struct fb_i
 	t_outb(par, tmp, 0x3C6);
 	t_inb(par, 0x3C8);
 
-	if (flatpanel)
+	if (par->flatpanel)
 		set_number_of_lines(par, info->var.yres);
 	set_lwidth(par, info->var.xres * bpp / (4 * 16));
 	info->fix.visual = (bpp == 8) ? FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
@@ -1153,7 +1155,7 @@ static int tridentfb_blank(int blank_mod
 	struct tridentfb_par *par = info->par;
 
 	debug("enter\n");
-	if (flatpanel)
+	if (par->flatpanel)
 		return 0;
 	t_outb(par, 0x04, 0x83C8); /* Read DPMS Control */
 	PMCont = t_inb(par, 0x83C6) & 0xFC;
@@ -1322,9 +1324,9 @@ static int __devinit trident_pci_probe(s
 	}
 
 	output("%s board found\n", pci_name(dev));
-	displaytype = get_displaytype(default_par);
+	default_par->flatpanel = is_flatpanel(default_par);
 
-	if (flatpanel)
+	if (default_par->flatpanel)
 		nativex = get_nativex(default_par);
 
 	info->fix = tridentfb_fix;
@@ -1441,9 +1443,9 @@ static int __init tridentfb_setup(char *
 		if (!strncmp(opt, "noaccel", 7))
 			noaccel = 1;
 		else if (!strncmp(opt, "fp", 2))
-			displaytype = DISPLAY_FP;
+			fp = 1;
 		else if (!strncmp(opt, "crt", 3))
-			displaytype = DISPLAY_CRT;
+			fp = 0;
 		else if (!strncmp(opt, "bpp=", 4))
 			bpp = simple_strtoul(opt + 4, NULL, 0);
 		else if (!strncmp(opt, "center", 6))
diff -puN include/video/trident.h~tridentfb-move-global-flat-panel-variable-into-structure include/video/trident.h
--- a/include/video/trident.h~tridentfb-move-global-flat-panel-variable-into-structure
+++ a/include/video/trident.h
@@ -63,12 +63,6 @@
 #define LCD_CENTER	1
 #define LCD_BIOS	2
 
-/* display types */
-#define DISPLAY_CRT	0
-#define DISPLAY_FP	1
-
-#define flatpanel (displaytype == DISPLAY_FP)
