From: akpm@linux-foundation.org
Subject: + tridentfb-make-use-of-functions-and-constants-from-the-vgah.patch added to -mm tree
Date: Mon, 05 May 2008 23:12:31 -0700
Message-ID: <200805060612.m466CVmc025143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754221AbYEFGND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 02:13:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net


The patch titled
     tridentfb: make use of functions and constants from the vga.h
has been added to the -mm tree.  Its filename is
     tridentfb-make-use-of-functions-and-constants-from-the-vgah.patch

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
Subject: tridentfb: make use of functions and constants from the vga.h
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Make use of functions and constants from the vga.h header to compact the code
and make it more readable.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |  144 +++++++++++++++---------------------
 include/video/trident.h   |   26 ------
 2 files changed, 61 insertions(+), 109 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-make-use-of-functions-and-constants-from-the-vgah drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-make-use-of-functions-and-constants-from-the-vgah
+++ a/drivers/video/tridentfb.c
@@ -22,6 +22,7 @@
 #include <linux/pci.h>
 
 #include <linux/delay.h>
+#include <video/vga.h>
 #include <video/trident.h>
 
 #define VERSION		"0.7.9-NEWAPI"
@@ -149,8 +150,6 @@ static int iscyber(int id)
 	}
 }
 
-#define CRT 0x3D0		/* CRTC registers offset for color display */
-
 static inline void t_outb(struct tridentfb_par *p, u8 val, u16 reg)
 {
 	fb_writeb(val, p->io_virt + reg);
@@ -525,60 +524,41 @@ static void tridentfb_copyarea(struct fb
 
 static inline unsigned char read3X4(struct tridentfb_par *par, int reg)
 {
-	writeb(reg, par->io_virt + CRT + 4);
-	return readb(par->io_virt + CRT + 5);
+	return vga_mm_rcrt(par->io_virt, reg);
 }
 
 static inline void write3X4(struct tridentfb_par *par, int reg,
 			    unsigned char val)
 {
-	writeb(reg, par->io_virt + CRT + 4);
-	writeb(val, par->io_virt + CRT + 5);
-}
-
-static inline unsigned char read3C4(struct tridentfb_par *par, int reg)
-{
-	t_outb(par, reg, 0x3C4);
-	return t_inb(par, 0x3C5);
-}
-
-static inline void write3C4(struct tridentfb_par *par, int reg,
-			    unsigned char val)
-{
-	t_outb(par, reg, 0x3C4);
-	t_outb(par, val, 0x3C5);
+	vga_mm_wcrt(par->io_virt, reg, val);
 }
 
-static inline unsigned char read3CE(struct tridentfb_par *par, int reg)
+static inline unsigned char read3CE(struct tridentfb_par *par,
+				    unsigned char reg)
 {
-	t_outb(par, reg, 0x3CE);
-	return t_inb(par, 0x3CF);
+	return vga_mm_rgfx(par->io_virt, reg);
 }
 
 static inline void writeAttr(struct tridentfb_par *par, int reg,
 			     unsigned char val)
 {
-	fb_readb(par->io_virt + CRT + 0x0A);	/* flip-flop to index */
-	t_outb(par, reg, 0x3C0);
-	t_outb(par, val, 0x3C0);
+	fb_readb(par->io_virt + VGA_IS1_RC);	/* flip-flop to index */
+	vga_mm_wattr(par->io_virt, reg, val);
 }
 
 static inline void write3CE(struct tridentfb_par *par, int reg,
 			    unsigned char val)
 {
-	t_outb(par, reg, 0x3CE);
-	t_outb(par, val, 0x3CF);
+	vga_mm_wgfx(par->io_virt, reg, val);
 }
 
 static void enable_mmio(void)
 {
 	/* Goto New Mode */
-	outb(0x0B, 0x3C4);
-	inb(0x3C5);
+	vga_io_rseq(0x0B);
 
 	/* Unprotect registers */
-	outb(NewMode1, 0x3C4);
-	outb(0x80, 0x3C5);
+	vga_io_wseq(NewMode1, 0x80);
 
 	/* Enable MMIO */
 	outb(PCIReg, 0x3D4);
@@ -588,12 +568,10 @@ static void enable_mmio(void)
 static void disable_mmio(struct tridentfb_par *par)
 {
 	/* Goto New Mode */
-	t_outb(par, 0x0B, 0x3C4);
-	t_inb(par, 0x3C5);
+	vga_mm_rseq(par->io_virt, 0x0B);
 
 	/* Unprotect registers */
-	t_outb(par, NewMode1, 0x3C4);
-	t_outb(par, 0x80, 0x3C5);
+	vga_mm_wseq(par->io_virt, NewMode1, 0x80);
 
 	/* Disable MMIO */
 	t_outb(par, PCIReg, 0x3D4);
@@ -602,7 +580,8 @@ static void disable_mmio(struct tridentf
 
 static void crtc_unlock(struct tridentfb_par *par)
 {
-	write3X4(par, CRTVSyncEnd, read3X4(par, CRTVSyncEnd) & 0x7F);
+	write3X4(par, VGA_CRTC_V_SYNC_END,
+		 read3X4(par, VGA_CRTC_V_SYNC_END) & 0x7F);
 }
 
 /*  Return flat panel's maximum x resolution */
@@ -641,7 +620,7 @@ static int __devinit get_nativex(struct 
 /* Set pitch */
 static void set_lwidth(struct tridentfb_par *par, int width)
 {
-	write3X4(par, Offset, width & 0xFF);
+	write3X4(par, VGA_CRTC_OFFSET, width & 0xFF);
 	write3X4(par, AddColReg,
 		 (read3X4(par, AddColReg) & 0xCF) | ((width & 0x300) >> 4));
 }
@@ -668,8 +647,8 @@ static void screen_center(struct trident
 static void set_screen_start(struct tridentfb_par *par, int base)
 {
 	u8 tmp;
-	write3X4(par, StartAddrLow, base & 0xFF);
-	write3X4(par, StartAddrHigh, (base & 0xFF00) >> 8);
+	write3X4(par, VGA_CRTC_START_LO, base & 0xFF);
+	write3X4(par, VGA_CRTC_START_HI, (base & 0xFF00) >> 8);
 	tmp = read3X4(par, CRTCModuleTest) & 0xDF;
 	write3X4(par, CRTCModuleTest, tmp | ((base & 0x10000) >> 11));
 	tmp = read3X4(par, CRTHiOrd) & 0xF8;
@@ -698,8 +677,8 @@ static void set_vclk(struct tridentfb_pa
 					break;
 			}
 	if (is3Dchip(par->chip_id)) {
-		write3C4(par, ClockHigh, hi);
-		write3C4(par, ClockLow, lo);
+		vga_mm_wseq(par->io_virt, ClockHigh, hi);
+		vga_mm_wseq(par->io_virt, ClockLow, lo);
 	} else {
 		outb(lo, 0x43C8);
 		outb(hi, 0x43C9);
@@ -782,7 +761,7 @@ static unsigned int __devinit get_memsiz
 				break;
 			case 0x0E:		/* XP */
 
-				tmp2 = read3C4(par, 0xC1);
+				tmp2 = vga_mm_rseq(par->io_virt, 0xC1);
 				switch (tmp2) {
 				case 0x00:
 					k = 20 * Mb;
@@ -931,7 +910,7 @@ static int tridentfb_set_par(struct fb_i
 		 * than requested resolution decide whether
 		 * we stretch or center
 		 */
-		t_outb(par, 0xEB, 0x3C2);
+		t_outb(par, 0xEB, VGA_MIS_W);
 
 		shadowmode_on(par);
 
@@ -941,26 +920,26 @@ static int tridentfb_set_par(struct fb_i
 			screen_stretch(par);
 
 	} else {
-		t_outb(par, 0x2B, 0x3C2);
+		t_outb(par, 0x2B, VGA_MIS_W);
 		write3CE(par, CyberControl, 8);
 	}
 
 	/* vertical timing values */
-	write3X4(par, CRTVTotal, vtotal & 0xFF);
-	write3X4(par, CRTVDispEnd, vdispend & 0xFF);
-	write3X4(par, CRTVSyncStart, vsyncstart & 0xFF);
-	write3X4(par, CRTVSyncEnd, (vsyncend & 0x0F));
-	write3X4(par, CRTVBlankStart, vblankstart & 0xFF);
-	write3X4(par, CRTVBlankEnd, 0 /* p->vblankend & 0xFF */);
+	write3X4(par, VGA_CRTC_V_TOTAL, vtotal & 0xFF);
+	write3X4(par, VGA_CRTC_V_DISP_END, vdispend & 0xFF);
+	write3X4(par, VGA_CRTC_V_SYNC_START, vsyncstart & 0xFF);
+	write3X4(par, VGA_CRTC_V_SYNC_END, (vsyncend & 0x0F));
+	write3X4(par, VGA_CRTC_V_BLANK_START, vblankstart & 0xFF);
+	write3X4(par, VGA_CRTC_V_BLANK_END, 0 /* p->vblankend & 0xFF */);
 
 	/* horizontal timing values */
-	write3X4(par, CRTHTotal, htotal & 0xFF);
-	write3X4(par, CRTHDispEnd, hdispend & 0xFF);
-	write3X4(par, CRTHSyncStart, hsyncstart & 0xFF);
-	write3X4(par, CRTHSyncEnd,
+	write3X4(par, VGA_CRTC_H_TOTAL, htotal & 0xFF);
+	write3X4(par, VGA_CRTC_H_DISP, hdispend & 0xFF);
+	write3X4(par, VGA_CRTC_H_SYNC_START, hsyncstart & 0xFF);
+	write3X4(par, VGA_CRTC_H_SYNC_END,
 		 (hsyncend & 0x1F) | ((hblankend & 0x20) << 2));
-	write3X4(par, CRTHBlankStart, hblankstart & 0xFF);
-	write3X4(par, CRTHBlankEnd, 0 /* (p->hblankend & 0x1F) */);
+	write3X4(par, VGA_CRTC_H_BLANK_START, hblankstart & 0xFF);
+	write3X4(par, VGA_CRTC_H_BLANK_END, 0 /* (p->hblankend & 0x1F) */);
 
 	/* higher bits of vertical timing values */
 	tmp = 0x10;
@@ -972,7 +951,7 @@ static int tridentfb_set_par(struct fb_i
 	if (vtotal & 0x200) tmp |= 0x20;
 	if (vdispend & 0x200) tmp |= 0x40;
 	if (vsyncstart & 0x200) tmp |= 0x80;
-	write3X4(par, CRTOverflow, tmp);
+	write3X4(par, VGA_CRTC_OVERFLOW, tmp);
 
 	tmp = read3X4(par, CRTHiOrd) | 0x08;	/* line compare bit 10 */
 	if (vtotal & 0x400) tmp |= 0x80;
@@ -989,11 +968,11 @@ static int tridentfb_set_par(struct fb_i
 	tmp = 0x40;
 	if (vblankstart & 0x200) tmp |= 0x20;
 //FIXME	if (info->var.vmode & FB_VMODE_DOUBLE) tmp |= 0x80;  /* double scan for 200 line modes */
-	write3X4(par, CRTMaxScanLine, tmp);
+	write3X4(par, VGA_CRTC_MAX_SCAN, tmp);
 
-	write3X4(par, CRTLineCompare, 0xFF);
-	write3X4(par, CRTPRowScan, 0);
-	write3X4(par, CRTModeControl, 0xC3);
+	write3X4(par, VGA_CRTC_LINE_COMPARE, 0xFF);
+	write3X4(par, VGA_CRTC_PRESET_ROW, 0);
+	write3X4(par, VGA_CRTC_MODE, 0xC3);
 
 	write3X4(par, LinearAddReg, 0x20);	/* enable linear addressing */
 
@@ -1041,12 +1020,12 @@ static int tridentfb_set_par(struct fb_i
 		vclk *= 2;
 	set_vclk(par, vclk);
 
-	write3C4(par, 0, 3);
-	write3C4(par, 1, 1);		/* set char clock 8 dots wide */
+	vga_mm_wseq(par->io_virt, 0, 3);
+	vga_mm_wseq(par->io_virt, 1, 1); /* set char clock 8 dots wide */
 	/* enable 4 maps because needed in chain4 mode */
-	write3C4(par, 2, 0x0F);
-	write3C4(par, 3, 0);
-	write3C4(par, 4, 0x0E);	/* memory mode enable bitmaps ?? */
+	vga_mm_wseq(par->io_virt, 2, 0x0F);
+	vga_mm_wseq(par->io_virt, 3, 0);
+	vga_mm_wseq(par->io_virt, 4, 0x0E); /* memory mode enable bitmaps ?? */
 
 	/* divide clock by 2 if 32bpp chain4 mode display and CPU path */
 	write3CE(par, MiscExtFunc, (bpp == 32) ? 0x1A : 0x12);
@@ -1056,7 +1035,7 @@ static int tridentfb_set_par(struct fb_i
 
 	if (par->chip_id == CYBERBLADEXPAi1) {
 		/* This fixes snow-effect in 32 bpp */
-		write3X4(par, CRTHSyncStart, 0x84);
+		write3X4(par, VGA_CRTC_H_SYNC_START, 0x84);
 	}
 
 	/* graphics mode and support 256 color modes */
@@ -1067,8 +1046,8 @@ static int tridentfb_set_par(struct fb_i
 	/* colors */
 	for (tmp = 0; tmp < 0x10; tmp++)
 		writeAttr(par, tmp, tmp);
-	fb_readb(par->io_virt + CRT + 0x0A);	/* flip-flop to index */
-	t_outb(par, 0x20, 0x3C0);		/* enable attr */
+	fb_readb(par->io_virt + VGA_IS1_RC);	/* flip-flop to index */
+	t_outb(par, 0x20, VGA_ATT_W);		/* enable attr */
 
 	switch (bpp) {
 	case 8:
@@ -1086,13 +1065,13 @@ static int tridentfb_set_par(struct fb_i
 		break;
 	}
 
-	t_inb(par, 0x3C8);
-	t_inb(par, 0x3C6);
-	t_inb(par, 0x3C6);
-	t_inb(par, 0x3C6);
-	t_inb(par, 0x3C6);
-	t_outb(par, tmp, 0x3C6);
-	t_inb(par, 0x3C8);
+	t_inb(par, VGA_PEL_IW);
+	t_inb(par, VGA_PEL_MSK);
+	t_inb(par, VGA_PEL_MSK);
+	t_inb(par, VGA_PEL_MSK);
+	t_inb(par, VGA_PEL_MSK);
+	t_outb(par, tmp, VGA_PEL_MSK);
+	t_inb(par, VGA_PEL_IW);
 
 	if (par->flatpanel)
 		set_number_of_lines(par, info->var.yres);
@@ -1116,12 +1095,12 @@ static int tridentfb_setcolreg(unsigned 
 		return 1;
 
 	if (bpp == 8) {
-		t_outb(par, 0xFF, 0x3C6);
-		t_outb(par, regno, 0x3C8);
+		t_outb(par, 0xFF, VGA_PEL_MSK);
+		t_outb(par, regno, VGA_PEL_IW);
 
-		t_outb(par, red >> 10, 0x3C9);
-		t_outb(par, green >> 10, 0x3C9);
-		t_outb(par, blue >> 10, 0x3C9);
+		t_outb(par, red >> 10, VGA_PEL_D);
+		t_outb(par, green >> 10, VGA_PEL_D);
+		t_outb(par, blue >> 10, VGA_PEL_D);
 
 	} else if (regno < 16) {
 		if (bpp == 16) {	/* RGB 565 */
@@ -1232,8 +1211,7 @@ static int __devinit trident_pci_probe(s
 	/* If PCI id is 0x9660 then further detect chip type */
 
 	if (chip_id == TGUI9660) {
-		outb(RevisionID, 0x3C4);
-		revision = inb(0x3C5);
+		revision = vga_io_rseq(RevisionID);
 
 		switch (revision) {
 		case 0x22:
diff -puN include/video/trident.h~tridentfb-make-use-of-functions-and-constants-from-the-vgah include/video/trident.h
--- a/include/video/trident.h~tridentfb-make-use-of-functions-and-constants-from-the-vgah
+++ a/include/video/trident.h
@@ -63,33 +63,7 @@
 #define SKey 0x37
 #define SPKey 0x57
 
-/* 0x3x4 */
-#define CRTHTotal	0x00
-#define CRTHDispEnd	0x01
-#define CRTHBlankStart	0x02
-#define CRTHBlankEnd	0x03
-#define CRTHSyncStart	0x04
-#define CRTHSyncEnd	0x05
-
-#define CRTVTotal	0x06
-#define CRTVDispEnd	0x12
-#define CRTVBlankStart	0x15
-#define CRTVBlankEnd	0x16
-#define CRTVSyncStart	0x10
-#define CRTVSyncEnd	0x11
-
-#define CRTOverflow	0x07
-#define CRTPRowScan	0x08
-#define CRTMaxScanLine	0x09
-#define CRTModeControl	0x17
-#define CRTLineCompare	0x18
