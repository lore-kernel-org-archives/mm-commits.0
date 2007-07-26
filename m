From: akpm@linux-foundation.org
Subject: + pm2fb-permedia-2v-initialization-fixes.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:38 -0700
Message-ID: <200707261900.l6QJ0cF1015649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40388 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932259AbXGZTMd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:12:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm2fb: Permedia 2V initialization fixes
has been added to the -mm tree.  Its filename is
     pm2fb-permedia-2v-initialization-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm2fb: Permedia 2V initialization fixes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch:
- initializes correctly the Permedia2V chip if it is not initialized by BIOS
- puts back clock frequency for the ELSA WINNER board to 100kHz
- fixes returned error values from setcolreg() function
- uses more general classes for PCI ids

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c     |   42 +++++++++++++++---------------------
 include/video/permedia2.h |    1 
 2 files changed, 19 insertions(+), 24 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-permedia-2v-initialization-fixes drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-permedia-2v-initialization-fixes
+++ a/drivers/video/pm2fb.c
@@ -343,7 +343,7 @@ static void reset_card(struct pm2fb_par*
 
 static void reset_config(struct pm2fb_par* p)
 {
-	WAIT_FIFO(p, 52);
+	WAIT_FIFO(p, 53);
 	pm2_WR(p, PM2R_CHIP_CONFIG, pm2_RD(p, PM2R_CHIP_CONFIG) &
 			~(PM2F_VGA_ENABLE | PM2F_VGA_FIXED));
 	pm2_WR(p, PM2R_BYPASS_WRITE_MASK, ~(0L));
@@ -380,6 +380,7 @@ static void reset_config(struct pm2fb_pa
 	pm2_WR(p, PM2R_STATISTICS_MODE, 0);
 	pm2_WR(p, PM2R_SCISSOR_MODE, 0);
 	pm2_WR(p, PM2R_FILTER_MODE, PM2F_SYNCHRONIZATION);
+	pm2_WR(p, PM2R_RD_PIXEL_MASK, 0xff);
 	switch (p->type) {
 	case PM2_TYPE_PERMEDIA2:
 		pm2_RDAC_WR(p, PM2I_RD_MODE_CONTROL, 0); /* no overlay */
@@ -393,11 +394,6 @@ static void reset_config(struct pm2fb_pa
 		break;
 	case PM2_TYPE_PERMEDIA2V:
 		pm2v_RDAC_WR(p, PM2VI_RD_MISC_CONTROL, 1); /* 8bit */
-		pm2v_RDAC_WR(p, PM2I_RD_COLOR_KEY_CONTROL, 0);
-		pm2v_RDAC_WR(p, PM2I_RD_OVERLAY_KEY, 0);
-		pm2v_RDAC_WR(p, PM2I_RD_RED_KEY, 0);
-		pm2v_RDAC_WR(p, PM2I_RD_GREEN_KEY, 0);
-		pm2v_RDAC_WR(p, PM2I_RD_BLUE_KEY, 0);
 		break;
 	}
 }
@@ -532,7 +528,7 @@ static void set_video(struct pm2fb_par* 
 	vsync &= ~(PM2F_HSYNC_MASK | PM2F_VSYNC_MASK);
 	vsync |= PM2F_HSYNC_ACT_HIGH | PM2F_VSYNC_ACT_HIGH;
 
-	WAIT_FIFO(p, 5);
+	WAIT_FIFO(p, 3);
 	pm2_WR(p, PM2R_VIDEO_CONTROL, vsync);
 
 	switch (p->type) {
@@ -551,7 +547,6 @@ static void set_video(struct pm2fb_par* 
 		if ((video & PM2F_VSYNC_MASK) == PM2F_VSYNC_ACT_LOW)
 			tmp |= 4; /* invert vsync */
 		pm2v_RDAC_WR(p, PM2VI_RD_SYNC_CONTROL, tmp);
-		pm2v_RDAC_WR(p, PM2VI_RD_MISC_CONTROL, 1);
 		break;
 	}
 }
@@ -686,6 +681,7 @@ static int pm2fb_set_par(struct fb_info 
 	u32 txtmap = 0;
 	u32 pixsize = 0;
 	u32 clrformat = 0;
+	u32 misc = 1; /* 8-bit DAC */
 	u32 xres = (info->var.xres + 31) & ~31;
 	int data64;
 
@@ -767,7 +763,7 @@ static int pm2fb_set_par(struct fb_info 
 	switch (depth) {
 	case 8:
 		pm2_WR(par, PM2R_FB_READ_PIXEL, 0);
-		clrformat = 0x0e;
+		clrformat = 0x2e;
 		break;
 	case 16:
 		pm2_WR(par, PM2R_FB_READ_PIXEL, 1);
@@ -775,6 +771,7 @@ static int pm2fb_set_par(struct fb_info 
 		txtmap = PM2F_TEXTEL_SIZE_16;
 		pixsize = 1;
 		clrformat = 0x70;
+		misc |= 8;
 		break;
 	case 32:
 		pm2_WR(par, PM2R_FB_READ_PIXEL, 2);
@@ -782,6 +779,7 @@ static int pm2fb_set_par(struct fb_info 
 		txtmap = PM2F_TEXTEL_SIZE_32;
 		pixsize = 2;
 		clrformat = 0x20;
+		misc |= 8;
 		break;
 	case 24:
 		pm2_WR(par, PM2R_FB_READ_PIXEL, 4);
@@ -789,6 +787,7 @@ static int pm2fb_set_par(struct fb_info 
 		txtmap = PM2F_TEXTEL_SIZE_24;
 		pixsize = 4;
 		clrformat = 0x20;
+		misc |= 8;
 		break;
 	}
 	pm2_WR(par, PM2R_FB_WRITE_MODE, PM2F_FB_WRITE_ENABLE);
@@ -813,7 +812,7 @@ static int pm2fb_set_par(struct fb_info 
 	pm2_WR(par, PM2R_SCREEN_BASE, base);
 	wmb();
 	set_video(par, video);
-	WAIT_FIFO(par, 6);
+	WAIT_FIFO(par, 10);
 	switch (par->type) {
 	case PM2_TYPE_PERMEDIA2:
 		pm2_RDAC_WR(par, PM2I_RD_COLOR_MODE, clrmode);
@@ -821,10 +820,11 @@ static int pm2fb_set_par(struct fb_info 
 			        (depth == 8) ? 0 : PM2F_COLOR_KEY_TEST_OFF);
 		break;
 	case PM2_TYPE_PERMEDIA2V:
+		pm2v_RDAC_WR(par, PM2VI_RD_DAC_CONTROL, 0);
 		pm2v_RDAC_WR(par, PM2VI_RD_PIXEL_SIZE, pixsize);
 		pm2v_RDAC_WR(par, PM2VI_RD_COLOR_FORMAT, clrformat);
-		pm2v_RDAC_WR(par, PM2I_RD_COLOR_KEY_CONTROL,
-			         (depth == 8) ? 0 : PM2F_COLOR_KEY_TEST_OFF);
+		pm2v_RDAC_WR(par, PM2VI_RD_MISC_CONTROL, misc);
+		pm2v_RDAC_WR(par, PM2VI_RD_OVERLAY_KEY, 0);
 		break;
 	}
 	set_pixclock(par, pixclock);
@@ -855,7 +855,7 @@ static int pm2fb_setcolreg(unsigned regn
 	struct pm2fb_par *par = info->par;
 
 	if (regno >= info->cmap.len)  /* no. of hw registers */
-		return 1;
+		return -EINVAL;
 	/*
 	 * Program hardware... do anything you want with transp
 	 */
@@ -914,7 +914,7 @@ static int pm2fb_setcolreg(unsigned regn
 		u32 v;
 
 		if (regno >= 16)
-			return 1;
+			return -EINVAL;
 
 		v = (red << info->var.red.offset) |
 			(green << info->var.green.offset) |
@@ -1341,7 +1341,7 @@ static int __devinit pm2fb_probe(struct 
 			DPRINTK("We have not been initialized by VGA BIOS "
 				"and are running on an Elsa Winner 2000 Office\n");
 			DPRINTK("Initializing card timings manually...\n");
-			default_par->memclock = 70000;
+			default_par->memclock = 100000;
 		}
 		if (pdev->subsystem_vendor == 0x3d3d &&
 			pdev->subsystem_device == 0x0100) {
@@ -1491,17 +1491,11 @@ static void __devexit pm2fb_remove(struc
 
 static struct pci_device_id pm2fb_id_table[] = {
 	{ PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_TVP4020,
-	  PCI_ANY_ID, PCI_ANY_ID, PCI_BASE_CLASS_DISPLAY << 16,
-	  0xff0000, 0 },
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ PCI_VENDOR_ID_3DLABS, PCI_DEVICE_ID_3DLABS_PERMEDIA2,
-	  PCI_ANY_ID, PCI_ANY_ID, PCI_BASE_CLASS_DISPLAY << 16,
-	  0xff0000, 0 },
-	{ PCI_VENDOR_ID_3DLABS, PCI_DEVICE_ID_3DLABS_PERMEDIA2V,
-	  PCI_ANY_ID, PCI_ANY_ID, PCI_BASE_CLASS_DISPLAY << 16,
-	  0xff0000, 0 },
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ PCI_VENDOR_ID_3DLABS, PCI_DEVICE_ID_3DLABS_PERMEDIA2V,
-	  PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_NOT_DEFINED_VGA << 8,
-	  0xff00, 0 },
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ 0, }
 };
 
diff -puN include/video/permedia2.h~pm2fb-permedia-2v-initialization-fixes include/video/permedia2.h
--- a/include/video/permedia2.h~pm2fb-permedia-2v-initialization-fixes
+++ a/include/video/permedia2.h
@@ -153,6 +153,7 @@
 #define PM2VI_RD_CURSOR_Y_HIGH				0x00A
 #define PM2VI_RD_CURSOR_X_HOT				0x00B
 #define PM2VI_RD_CURSOR_Y_HOT				0x00C
+#define PM2VI_RD_OVERLAY_KEY				0x00D
 #define PM2VI_RD_CLK0_PRESCALE				0x201
 #define PM2VI_RD_CLK0_FEEDBACK				0x202
 #define PM2VI_RD_CLK0_POSTSCALE				0x203
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
tdfxfb-coding-style-improvement.patch
tridentfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
