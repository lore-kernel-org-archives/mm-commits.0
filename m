From: akpm@linux-foundation.org
Subject: + s3fb-add-support-for-s3-trio3d-1x-2x.patch added to -mm tree
Date: Tue, 25 May 2010 12:46:13 -0700
Message-ID: <201005251946.o4PJkDF2011293@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758743Ab0EYTqW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 15:46:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@rainbow-software.org


The patch titled
     Subject: [PATCH] [resend] s3fb: add support for S3 Trio3D/1X/2X
has been added to the -mm tree.  Its filename is
     s3fb-add-support-for-s3-trio3d-1x-2x.patch

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
Subject: Subject: [PATCH] [resend] s3fb: add support for S3 Trio3D/1X/2X
From: Ondrej Zary <linux@rainbow-software.org>

Add support for S3 Trio3D/1X (86C360) and S3 Trio3D/2X (86C362 and 86C368)
cards to s3fb driver. Tested with 86C362 AGP and 86C368 PCI&AGP.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3fb.c |  101 ++++++++++++++++++++++++++++++++---------
 1 file changed, 81 insertions(+), 20 deletions(-)

diff -puN drivers/video/s3fb.c~s3fb-add-support-for-s3-trio3d-1x-2x drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~s3fb-add-support-for-s3-trio3d-1x-2x
+++ a/drivers/video/s3fb.c
@@ -71,7 +71,8 @@ static const char * const s3_names[] = {
 			"S3 Trio64UV+", "S3 Trio64V2/DX", "S3 Trio64V2/GX",
 			"S3 Plato/PX", "S3 Aurora64VP", "S3 Virge",
 			"S3 Virge/VX", "S3 Virge/DX", "S3 Virge/GX",
-			"S3 Virge/GX2", "S3 Virge/GX2P", "S3 Virge/GX2P"};
+			"S3 Virge/GX2", "S3 Virge/GX2P", "S3 Virge/GX2P",
+			"S3 Trio3D/1X", "S3 Trio3D/2X", "S3 Trio3D/2X"};
 
 #define CHIP_UNKNOWN		0x00
 #define CHIP_732_TRIO32		0x01
@@ -89,10 +90,14 @@ static const char * const s3_names[] = {
 #define CHIP_356_VIRGE_GX2	0x0D
 #define CHIP_357_VIRGE_GX2P	0x0E
 #define CHIP_359_VIRGE_GX2P	0x0F
+#define CHIP_360_TRIO3D_1X	0x10
+#define CHIP_362_TRIO3D_2X	0x11
+#define CHIP_368_TRIO3D_2X	0x12
 
 #define CHIP_XXX_TRIO		0x80
 #define CHIP_XXX_TRIO64V2_DXGX	0x81
 #define CHIP_XXX_VIRGE_DXGX	0x82
+#define CHIP_36X_TRIO3D_1X_2X	0x83
 
 #define CHIP_UNDECIDED_FLAG	0x80
 #define CHIP_MASK		0xFF
@@ -324,6 +329,7 @@ static void s3fb_fillrect(struct fb_info
 
 static void s3_set_pixclock(struct fb_info *info, u32 pixclock)
 {
+	struct s3fb_info *par = info->par;
 	u16 m, n, r;
 	u8 regval;
 	int rv;
@@ -339,7 +345,13 @@ static void s3_set_pixclock(struct fb_in
 	vga_w(NULL, VGA_MIS_W, regval | VGA_MIS_ENB_PLL_LOAD);
 
 	/* Set S3 clock registers */
-	vga_wseq(NULL, 0x12, ((n - 2) | (r << 5)));
+	if (par->chip == CHIP_360_TRIO3D_1X ||
+	    par->chip == CHIP_362_TRIO3D_2X ||
+	    par->chip == CHIP_368_TRIO3D_2X) {
+		vga_wseq(NULL, 0x12, (n - 2) | ((r & 3) << 6));	/* n and two bits of r */
+		vga_wseq(NULL, 0x29, r >> 2); /* remaining highest bit of r */
+	} else
+		vga_wseq(NULL, 0x12, (n - 2) | (r << 5));
 	vga_wseq(NULL, 0x13, m - 2);
 
 	udelay(1000);
@@ -456,7 +468,7 @@ static int s3fb_check_var(struct fb_var_
 static int s3fb_set_par(struct fb_info *info)
 {
 	struct s3fb_info *par = info->par;
-	u32 value, mode, hmul, offset_value, screen_size, multiplex;
+	u32 value, mode, hmul, offset_value, screen_size, multiplex, dbytes;
 	u32 bpp = info->var.bits_per_pixel;
 
 	if (bpp != 0) {
@@ -518,7 +530,7 @@ static int s3fb_set_par(struct fb_info *
 	svga_wcrt_mask(0x33, 0x00, 0x08); /* no DDR ?	*/
 	svga_wcrt_mask(0x43, 0x00, 0x01); /* no DDR ?	*/
 
-	svga_wcrt_mask(0x5D, 0x00, 0x28); // Clear strange HSlen bits
+	svga_wcrt_mask(0x5D, 0x00, 0x28); /* Clear strange HSlen bits */
 
 /*	svga_wcrt_mask(0x58, 0x03, 0x03); */
 
@@ -530,10 +542,14 @@ static int s3fb_set_par(struct fb_info *
 	pr_debug("fb%d: offset register       : %d\n", info->node, offset_value);
 	svga_wcrt_multi(s3_offset_regs, offset_value);
 
-	vga_wcrt(NULL, 0x54, 0x18); /* M parameter */
-	vga_wcrt(NULL, 0x60, 0xff); /* N parameter */
-	vga_wcrt(NULL, 0x61, 0xff); /* L parameter */
-	vga_wcrt(NULL, 0x62, 0xff); /* L parameter */
+	if (par->chip != CHIP_360_TRIO3D_1X &&
+	    par->chip != CHIP_362_TRIO3D_2X &&
+	    par->chip != CHIP_368_TRIO3D_2X) {
+		vga_wcrt(NULL, 0x54, 0x18); /* M parameter */
+		vga_wcrt(NULL, 0x60, 0xff); /* N parameter */
+		vga_wcrt(NULL, 0x61, 0xff); /* L parameter */
+		vga_wcrt(NULL, 0x62, 0xff); /* L parameter */
+	}
 
 	vga_wcrt(NULL, 0x3A, 0x35);
 	svga_wattr(0x33, 0x00);
@@ -570,6 +586,16 @@ static int s3fb_set_par(struct fb_info *
 		vga_wcrt(NULL, 0x66, 0x90);
 	}
 
+	if (par->chip == CHIP_360_TRIO3D_1X ||
+	    par->chip == CHIP_362_TRIO3D_2X ||
+	    par->chip == CHIP_368_TRIO3D_2X) {
+		dbytes = info->var.xres * ((bpp+7)/8);
+		vga_wcrt(NULL, 0x91, (dbytes + 7) / 8);
+		vga_wcrt(NULL, 0x90, (((dbytes + 7) / 8) >> 8) | 0x80);
+
+		vga_wcrt(NULL, 0x66, 0x81);
+	}
+
 	svga_wcrt_mask(0x31, 0x00, 0x40);
 	multiplex = 0;
 	hmul = 1;
@@ -615,11 +641,13 @@ static int s3fb_set_par(struct fb_info *
 		break;
 	case 3:
 		pr_debug("fb%d: 8 bit pseudocolor\n", info->node);
-		if (info->var.pixclock > 20000) {
-			svga_wcrt_mask(0x50, 0x00, 0x30);
+		svga_wcrt_mask(0x50, 0x00, 0x30);
+		if (info->var.pixclock > 20000 ||
+		    par->chip == CHIP_360_TRIO3D_1X ||
+		    par->chip == CHIP_362_TRIO3D_2X ||
+		    par->chip == CHIP_368_TRIO3D_2X)
 			svga_wcrt_mask(0x67, 0x00, 0xF0);
-		} else {
-			svga_wcrt_mask(0x50, 0x00, 0x30);
+		else {
 			svga_wcrt_mask(0x67, 0x10, 0xF0);
 			multiplex = 1;
 		}
@@ -634,7 +662,10 @@ static int s3fb_set_par(struct fb_info *
 		} else {
 			svga_wcrt_mask(0x50, 0x10, 0x30);
 			svga_wcrt_mask(0x67, 0x30, 0xF0);
-			hmul = 2;
+			if (par->chip != CHIP_360_TRIO3D_1X &&
+			    par->chip != CHIP_362_TRIO3D_2X &&
+			    par->chip != CHIP_368_TRIO3D_2X)
+				hmul = 2;
 		}
 		break;
 	case 5:
@@ -647,7 +678,10 @@ static int s3fb_set_par(struct fb_info *
 		} else {
 			svga_wcrt_mask(0x50, 0x10, 0x30);
 			svga_wcrt_mask(0x67, 0x50, 0xF0);
-			hmul = 2;
+			if (par->chip != CHIP_360_TRIO3D_1X &&
+			    par->chip != CHIP_362_TRIO3D_2X &&
+			    par->chip != CHIP_368_TRIO3D_2X)
+				hmul = 2;
 		}
 		break;
 	case 6:
@@ -866,6 +900,17 @@ static int __devinit s3_identification(i
 			return CHIP_385_VIRGE_GX;
 	}
 
+	if (chip == CHIP_36X_TRIO3D_1X_2X) {
+		switch(vga_rcrt(NULL, 0x2f)) {
+		case 0x00:
+			return CHIP_360_TRIO3D_1X;
+		case 0x01:
+			return CHIP_362_TRIO3D_2X;
+		case 0x02:
+			return CHIP_368_TRIO3D_2X;
+		}
+	}
+
 	return CHIP_UNKNOWN;
 }
 
@@ -930,17 +975,32 @@ static int __devinit s3_pci_probe(struct
 	vga_wcrt(NULL, 0x38, 0x48);
 	vga_wcrt(NULL, 0x39, 0xA5);
 
-	/* Find how many physical memory there is on card */
-	/* 0x36 register is accessible even if other registers are locked */
-	regval = vga_rcrt(NULL, 0x36);
-	info->screen_size = s3_memsizes[regval >> 5] << 10;
-	info->fix.smem_len = info->screen_size;
-
+	/* Identify chip type */
 	par->chip = id->driver_data & CHIP_MASK;
 	par->rev = vga_rcrt(NULL, 0x2f);
 	if (par->chip & CHIP_UNDECIDED_FLAG)
 		par->chip = s3_identification(par->chip);
 
+	/* Find how many physical memory there is on card */
+	/* 0x36 register is accessible even if other registers are locked */
+	regval = vga_rcrt(NULL, 0x36);
+	if (par->chip == CHIP_360_TRIO3D_1X ||
+	    par->chip == CHIP_362_TRIO3D_2X ||
+	    par->chip == CHIP_368_TRIO3D_2X) {
+		switch((regval & 0xE0) >> 5) {
+		case 0: /* 8MB -- only 4MB usable for display */
+		case 1: /* 4MB with 32-bit bus */
+		case 2:	/* 4MB */
+			info->screen_size = 4 << 20;
+			break;
+		case 6: /* 2MB */
+			info->screen_size = 2 << 20;
+			break;
+		}
+	} else
+		info->screen_size = s3_memsizes[regval >> 5] << 10;
+	info->fix.smem_len = info->screen_size;
+
 	/* Find MCLK frequency */
 	regval = vga_rseq(NULL, 0x10);
 	par->mclk_freq = ((vga_rseq(NULL, 0x11) + 2) * 14318) / ((regval & 0x1F)  + 2);
@@ -1131,6 +1191,7 @@ static struct pci_device_id s3_devices[]
 	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8A10), .driver_data = CHIP_356_VIRGE_GX2},
 	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8A11), .driver_data = CHIP_357_VIRGE_GX2P},
 	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8A12), .driver_data = CHIP_359_VIRGE_GX2P},
+	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8A13), .driver_data = CHIP_36X_TRIO3D_1X_2X},
 
 	{0, 0, 0, 0, 0, 0, 0}
 };
_

Patches currently in -mm which might be from linux@rainbow-software.org are

origin.patch
linux-next.patch
usbtouchscreen-support-bigger-inexio-touchscreens.patch
g_ncr5380-remove-misleading-pnp-error-message.patch
g_ncr5380-fix-broken-mmio-compilation.patch
s3fb-add-support-for-s3-trio3d-1x-2x.patch

