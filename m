From: akpm@linux-foundation.org
Subject: + tridentfb-replace-macros-with-functions.patch added to -mm tree
Date: Fri, 02 May 2008 05:32:50 -0700
Message-ID: <200805021232.m42CWov9026294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934813AbYEBMcx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 08:32:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net


The patch titled
     tridentfb: replace macros with functions
has been added to the -mm tree.  Its filename is
     tridentfb-replace-macros-with-functions.patch

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
Subject: tridentfb: replace macros with functions
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Replace macros with static functions and puts tridentfb_par pointer as the
first argument of these functions.  These is a step toward multihead support.

Additionally, bogus TRIDENT_MMIO define is removed as the driver supports
graphics cards only through the mmio mode.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |  513 +++++++++++++++++++-----------------
 1 file changed, 274 insertions(+), 239 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-replace-macros-with-functions drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-replace-macros-with-functions
+++ a/drivers/video/tridentfb.c
@@ -137,28 +137,34 @@ static int iscyber(int id)
 
 #define CRT 0x3D0		/* CRTC registers offset for color display */
 
-#ifndef TRIDENT_MMIO
-	#define TRIDENT_MMIO 1
-#endif
-
-#if TRIDENT_MMIO
-	#define t_outb(val, reg)	writeb(val,((struct tridentfb_par *)(fb_info.par))->io_virt + reg)
-	#define t_inb(reg)	readb(((struct tridentfb_par*)(fb_info.par))->io_virt + reg)
-#else
-	#define t_outb(val, reg) outb(val, reg)
-	#define t_inb(reg) inb(reg)
-#endif
+static void t_outb(struct tridentfb_par *p, u8 val, u16 reg)
+{
+	fb_writeb(val, p->io_virt + reg);
+}
 
+static u8 t_inb(struct tridentfb_par *p, u16 reg)
+{
+	return fb_readb(p->io_virt + reg);
+}
 
 static struct accel_switch {
-	void (*init_accel) (int, int);
-	void (*wait_engine) (void);
-	void (*fill_rect) (u32, u32, u32, u32, u32, u32);
-	void (*copy_rect) (u32, u32, u32, u32, u32, u32);
+	void (*init_accel) (struct tridentfb_par *, int, int);
+	void (*wait_engine) (struct tridentfb_par *);
+	void (*fill_rect)
+		(struct tridentfb_par *par, u32, u32, u32, u32, u32, u32);
+	void (*copy_rect)
+		(struct tridentfb_par *par, u32, u32, u32, u32, u32, u32);
 } *acc;
 
-#define writemmr(r, v)	writel(v, ((struct tridentfb_par *)fb_info.par)->io_virt + r)
-#define readmmr(r)	readl(((struct tridentfb_par *)fb_info.par)->io_virt + r)
+static void writemmr(struct tridentfb_par *par, u16 r, u32 v)
+{
+	fb_writel(v, par->io_virt + r);
+}
+
+static u32 readmmr(struct tridentfb_par *par, u16 r)
+{
+	return fb_readl(par->io_virt + r);
+}
 
 /*
  * Blade specific acceleration.
@@ -176,7 +182,7 @@ static struct accel_switch {
 
 #define ROP_S	0xCC
 
-static void blade_init_accel(int pitch, int bpp)
+static void blade_init_accel(struct tridentfb_par *par, int pitch, int bpp)
 {
 	int v1 = (pitch >> 3) << 20;
 	int tmp = 0, v2;
@@ -196,33 +202,35 @@ static void blade_init_accel(int pitch, 
 		break;
 	}
 	v2 = v1 | (tmp << 29);
-	writemmr(0x21C0, v2);
-	writemmr(0x21C4, v2);
-	writemmr(0x21B8, v2);
-	writemmr(0x21BC, v2);
-	writemmr(0x21D0, v1);
-	writemmr(0x21D4, v1);
-	writemmr(0x21C8, v1);
-	writemmr(0x21CC, v1);
-	writemmr(0x216C, 0);
+	writemmr(par, 0x21C0, v2);
+	writemmr(par, 0x21C4, v2);
+	writemmr(par, 0x21B8, v2);
+	writemmr(par, 0x21BC, v2);
+	writemmr(par, 0x21D0, v1);
+	writemmr(par, 0x21D4, v1);
+	writemmr(par, 0x21C8, v1);
+	writemmr(par, 0x21CC, v1);
+	writemmr(par, 0x216C, 0);
 }
 
-static void blade_wait_engine(void)
+static void blade_wait_engine(struct tridentfb_par *par)
 {
-	while (readmmr(STA) & 0xFA800000) ;
+	while (readmmr(par, STA) & 0xFA800000) ;
 }
 
-static void blade_fill_rect(u32 x, u32 y, u32 w, u32 h, u32 c, u32 rop)
+static void blade_fill_rect(struct tridentfb_par *par,
+			    u32 x, u32 y, u32 w, u32 h, u32 c, u32 rop)
 {
-	writemmr(CLR, c);
-	writemmr(ROP, rop ? 0x66 : ROP_S);
-	writemmr(CMD, 0x20000000 | 1 << 19 | 1 << 4 | 2 << 2);
+	writemmr(par, CLR, c);
+	writemmr(par, ROP, rop ? 0x66 : ROP_S);
+	writemmr(par, CMD, 0x20000000 | 1 << 19 | 1 << 4 | 2 << 2);
 
-	writemmr(DR1, point(x, y));
-	writemmr(DR2, point(x + w - 1, y + h - 1));
+	writemmr(par, DR1, point(x, y));
+	writemmr(par, DR2, point(x + w - 1, y + h - 1));
 }
 
-static void blade_copy_rect(u32 x1, u32 y1, u32 x2, u32 y2, u32 w, u32 h)
+static void blade_copy_rect(struct tridentfb_par *par,
+			    u32 x1, u32 y1, u32 x2, u32 y2, u32 w, u32 h)
 {
 	u32 s1, s2, d1, d2;
 	int direction = 2;
@@ -234,13 +242,13 @@ static void blade_copy_rect(u32 x1, u32 
 	if ((y1 > y2) || ((y1 == y2) && (x1 > x2)))
 		direction = 0;
 
-	writemmr(ROP, ROP_S);
-	writemmr(CMD, 0xE0000000 | 1 << 19 | 1 << 4 | 1 << 2 | direction);
+	writemmr(par, ROP, ROP_S);
+	writemmr(par, CMD, 0xE0000000 | 1 << 19 | 1 << 4 | 1 << 2 | direction);
 
-	writemmr(SR1, direction ? s2 : s1);
-	writemmr(SR2, direction ? s1 : s2);
-	writemmr(DR1, direction ? d2 : d1);
-	writemmr(DR2, direction ? d1 : d2);
+	writemmr(par, SR1, direction ? s2 : s1);
+	writemmr(par, SR2, direction ? s1 : s2);
+	writemmr(par, DR1, direction ? d2 : d1);
+	writemmr(par, DR2, direction ? d1 : d2);
 }
 
 static struct accel_switch accel_blade = {
@@ -257,7 +265,7 @@ static struct accel_switch accel_blade =
 #define ROP_P 0xF0
 #define masked_point(x, y) ((y & 0xffff)<<16|(x & 0xffff))
 
-static void xp_init_accel(int pitch, int bpp)
+static void xp_init_accel(struct tridentfb_par *par, int pitch, int bpp)
 {
 	int tmp = 0, v1;
 	unsigned char x = 0;
@@ -293,7 +301,7 @@ static void xp_init_accel(int pitch, int
 		break;
 	}
 
-	t_outb(x, 0x2125);
+	t_outb(par, x, 0x2125);
 
 	eng_oper = x | 0x40;
 
@@ -313,12 +321,12 @@ static void xp_init_accel(int pitch, int
 
 	v1 = pitch << tmp;
 
-	writemmr(0x2154, v1);
-	writemmr(0x2150, v1);
-	t_outb(3, 0x2126);
+	writemmr(par, 0x2154, v1);
+	writemmr(par, 0x2150, v1);
+	t_outb(par, 3, 0x2126);
 }
 
-static void xp_wait_engine(void)
+static void xp_wait_engine(struct tridentfb_par *par)
 {
 	int busy;
 	int count, timeout;
@@ -326,7 +334,7 @@ static void xp_wait_engine(void)
 	count = 0;
 	timeout = 0;
 	for (;;) {
-		busy = t_inb(STA) & 0x80;
+		busy = t_inb(par, STA) & 0x80;
 		if (busy != 0x80)
 			return;
 		count++;
@@ -336,25 +344,27 @@ static void xp_wait_engine(void)
 			timeout++;
 			if (timeout == 8) {
 				/* Reset engine */
-				t_outb(0x00, 0x2120);
+				t_outb(par, 0x00, 0x2120);
 				return;
 			}
 		}
 	}
 }
 
-static void xp_fill_rect(u32 x, u32 y, u32 w, u32 h, u32 c, u32 rop)
+static void xp_fill_rect(struct tridentfb_par *par,
+			 u32 x, u32 y, u32 w, u32 h, u32 c, u32 rop)
 {
-	writemmr(0x2127, ROP_P);
-	writemmr(0x2158, c);
-	writemmr(0x2128, 0x4000);
-	writemmr(0x2140, masked_point(h, w));
-	writemmr(0x2138, masked_point(y, x));
-	t_outb(0x01, 0x2124);
-	t_outb(eng_oper, 0x2125);
+	writemmr(par, 0x2127, ROP_P);
+	writemmr(par, 0x2158, c);
+	writemmr(par, 0x2128, 0x4000);
+	writemmr(par, 0x2140, masked_point(h, w));
+	writemmr(par, 0x2138, masked_point(y, x));
+	t_outb(par, 0x01, 0x2124);
+	t_outb(par, eng_oper, 0x2125);
 }
 
-static void xp_copy_rect(u32 x1, u32 y1, u32 x2, u32 y2, u32 w, u32 h)
+static void xp_copy_rect(struct tridentfb_par *par,
+			 u32 x1, u32 y1, u32 x2, u32 y2, u32 w, u32 h)
 {
 	int direction;
 	u32 x1_tmp, x2_tmp, y1_tmp, y2_tmp;
@@ -379,12 +389,12 @@ static void xp_copy_rect(u32 x1, u32 y1,
 		y2_tmp = y2;
 	}
 
-	writemmr(0x2128, direction);
-	t_outb(ROP_S, 0x2127);
-	writemmr(0x213C, masked_point(y1_tmp, x1_tmp));
-	writemmr(0x2138, masked_point(y2_tmp, x2_tmp));
-	writemmr(0x2140, masked_point(h, w));
-	t_outb(0x01, 0x2124);
+	writemmr(par, 0x2128, direction);
+	t_outb(par, ROP_S, 0x2127);
+	writemmr(par, 0x213C, masked_point(y1_tmp, x1_tmp));
+	writemmr(par, 0x2138, masked_point(y2_tmp, x2_tmp));
+	writemmr(par, 0x2140, masked_point(h, w));
+	t_outb(par, 0x01, 0x2124);
 }
 
 static struct accel_switch accel_xp = {
@@ -397,7 +407,7 @@ static struct accel_switch accel_xp = {
 /*
  * Image specific acceleration functions
  */
-static void image_init_accel(int pitch, int bpp)
+static void image_init_accel(struct tridentfb_par *par, int pitch, int bpp)
 {
 	int tmp = 0;
 	switch (bpp) {
@@ -415,40 +425,42 @@ static void image_init_accel(int pitch, 
 		tmp = 2;
 		break;
 	}
-	writemmr(0x2120, 0xF0000000);
-	writemmr(0x2120, 0x40000000 | tmp);
-	writemmr(0x2120, 0x80000000);
-	writemmr(0x2144, 0x00000000);
-	writemmr(0x2148, 0x00000000);
-	writemmr(0x2150, 0x00000000);
-	writemmr(0x2154, 0x00000000);
-	writemmr(0x2120, 0x60000000 | (pitch << 16) | pitch);
-	writemmr(0x216C, 0x00000000);
-	writemmr(0x2170, 0x00000000);
-	writemmr(0x217C, 0x00000000);
-	writemmr(0x2120, 0x10000000);
-	writemmr(0x2130, (2047 << 16) | 2047);
+	writemmr(par, 0x2120, 0xF0000000);
+	writemmr(par, 0x2120, 0x40000000 | tmp);
+	writemmr(par, 0x2120, 0x80000000);
+	writemmr(par, 0x2144, 0x00000000);
+	writemmr(par, 0x2148, 0x00000000);
+	writemmr(par, 0x2150, 0x00000000);
+	writemmr(par, 0x2154, 0x00000000);
+	writemmr(par, 0x2120, 0x60000000 | (pitch << 16) | pitch);
+	writemmr(par, 0x216C, 0x00000000);
+	writemmr(par, 0x2170, 0x00000000);
+	writemmr(par, 0x217C, 0x00000000);
+	writemmr(par, 0x2120, 0x10000000);
+	writemmr(par, 0x2130, (2047 << 16) | 2047);
 }
 
-static void image_wait_engine(void)
+static void image_wait_engine(struct tridentfb_par *par)
 {
-	while (readmmr(0x2164) & 0xF0000000) ;
+	while (readmmr(par, 0x2164) & 0xF0000000) ;
 }
 
-static void image_fill_rect(u32 x, u32 y, u32 w, u32 h, u32 c, u32 rop)
+static void image_fill_rect(struct tridentfb_par *par,
+			    u32 x, u32 y, u32 w, u32 h, u32 c, u32 rop)
 {
-	writemmr(0x2120, 0x80000000);
-	writemmr(0x2120, 0x90000000 | ROP_S);
+	writemmr(par, 0x2120, 0x80000000);
+	writemmr(par, 0x2120, 0x90000000 | ROP_S);
 
-	writemmr(0x2144, c);
+	writemmr(par, 0x2144, c);
 
-	writemmr(DR1, point(x, y));
-	writemmr(DR2, point(x + w - 1, y + h - 1));
+	writemmr(par, DR1, point(x, y));
+	writemmr(par, DR2, point(x + w - 1, y + h - 1));
 
-	writemmr(0x2124, 0x80000000 | 3 << 22 | 1 << 10 | 1 << 9);
+	writemmr(par, 0x2124, 0x80000000 | 3 << 22 | 1 << 10 | 1 << 9);
 }
 
-static void image_copy_rect(u32 x1, u32 y1, u32 x2, u32 y2, u32 w, u32 h)
+static void image_copy_rect(struct tridentfb_par *par,
+			    u32 x1, u32 y1, u32 x2, u32 y2, u32 w, u32 h)
 {
 	u32 s1, s2, d1, d2;
 	int direction = 2;
@@ -460,14 +472,15 @@ static void image_copy_rect(u32 x1, u32 
 	if ((y1 > y2) || ((y1 == y2) && (x1 > x2)))
 		direction = 0;
 
-	writemmr(0x2120, 0x80000000);
-	writemmr(0x2120, 0x90000000 | ROP_S);
+	writemmr(par, 0x2120, 0x80000000);
+	writemmr(par, 0x2120, 0x90000000 | ROP_S);
 
-	writemmr(SR1, direction ? s2 : s1);
-	writemmr(SR2, direction ? s1 : s2);
-	writemmr(DR1, direction ? d2 : d1);
-	writemmr(DR2, direction ? d1 : d2);
-	writemmr(0x2124, 0x80000000 | 1 << 22 | 1 << 10 | 1 << 7 | direction);
+	writemmr(par, SR1, direction ? s2 : s1);
+	writemmr(par, SR2, direction ? s1 : s2);
+	writemmr(par, DR1, direction ? d2 : d1);
+	writemmr(par, DR2, direction ? d1 : d2);
+	writemmr(par, 0x2124,
+		 0x80000000 | 1 << 22 | 1 << 10 | 1 << 7 | direction);
 }
 
 static struct accel_switch accel_image = {
@@ -521,49 +534,51 @@ static void tridentfb_copyarea(struct fb
  * Hardware access functions
  */
 
-static inline unsigned char read3X4(int reg)
+static inline unsigned char read3X4(struct tridentfb_par *par, int reg)
 {
-	struct tridentfb_par *par = (struct tridentfb_par *)fb_info.par;
 	writeb(reg, par->io_virt + CRT + 4);
 	return readb(par->io_virt + CRT + 5);
 }
 
-static inline void write3X4(int reg, unsigned char val)
+static inline void write3X4(struct tridentfb_par *par, int reg,
+			    unsigned char val)
 {
-	struct tridentfb_par *par = (struct tridentfb_par *)fb_info.par;
 	writeb(reg, par->io_virt + CRT + 4);
 	writeb(val, par->io_virt + CRT + 5);
 }
 
-static inline unsigned char read3C4(int reg)
+static inline unsigned char read3C4(struct tridentfb_par *par, int reg)
 {
-	t_outb(reg, 0x3C4);
-	return t_inb(0x3C5);
+	t_outb(par, reg, 0x3C4);
+	return t_inb(par, 0x3C5);
 }
 
-static inline void write3C4(int reg, unsigned char val)
+static inline void write3C4(struct tridentfb_par *par, int reg,
+			    unsigned char val)
 {
-	t_outb(reg, 0x3C4);
-	t_outb(val, 0x3C5);
+	t_outb(par, reg, 0x3C4);
+	t_outb(par, val, 0x3C5);
 }
 
-static inline unsigned char read3CE(int reg)
+static inline unsigned char read3CE(struct tridentfb_par *par, int reg)
 {
-	t_outb(reg, 0x3CE);
-	return t_inb(0x3CF);
+	t_outb(par, reg, 0x3CE);
+	return t_inb(par, 0x3CF);
 }
 
-static inline void writeAttr(int reg, unsigned char val)
+static inline void writeAttr(struct tridentfb_par *par, int reg,
+			     unsigned char val)
 {
-	readb(((struct tridentfb_par *)fb_info.par)->io_virt + CRT + 0x0A);	/* flip-flop to index */
-	t_outb(reg, 0x3C0);
-	t_outb(val, 0x3C0);
+	fb_readb(par->io_virt + CRT + 0x0A);	/* flip-flop to index */
+	t_outb(par, reg, 0x3C0);
+	t_outb(par, val, 0x3C0);
 }
 
-static inline void write3CE(int reg, unsigned char val)
+static inline void write3CE(struct tridentfb_par *par, int reg,
+			    unsigned char val)
 {
-	t_outb(reg, 0x3CE);
-	t_outb(val, 0x3CF);
+	t_outb(par, reg, 0x3CE);
+	t_outb(par, val, 0x3CF);
 }
 
 static void enable_mmio(void)
@@ -581,32 +596,35 @@ static void enable_mmio(void)
 	outb(inb(0x3D5) | 0x01, 0x3D5);
 }
 
-static void disable_mmio(void)
+static void disable_mmio(struct tridentfb_par *par)
 {
 	/* Goto New Mode */
-	t_outb(0x0B, 0x3C4);
-	t_inb(0x3C5);
+	t_outb(par, 0x0B, 0x3C4);
+	t_inb(par, 0x3C5);
 
 	/* Unprotect registers */
-	t_outb(NewMode1, 0x3C4);
-	t_outb(0x80, 0x3C5);
+	t_outb(par, NewMode1, 0x3C4);
+	t_outb(par, 0x80, 0x3C5);
 
 	/* Disable MMIO */
-	t_outb(PCIReg, 0x3D4);
-	t_outb(t_inb(0x3D5) & ~0x01, 0x3D5);
+	t_outb(par, PCIReg, 0x3D4);
+	t_outb(par, t_inb(par, 0x3D5) & ~0x01, 0x3D5);
 }
 
-#define crtc_unlock()	write3X4(CRTVSyncEnd, read3X4(CRTVSyncEnd) & 0x7F)
+static void crtc_unlock(struct tridentfb_par *par)
+{
+	write3X4(par, CRTVSyncEnd, read3X4(par, CRTVSyncEnd) & 0x7F);
+}
 
 /*  Return flat panel's maximum x resolution */
-static int __devinit get_nativex(void)
+static int __devinit get_nativex(struct tridentfb_par *par)
 {
 	int x, y, tmp;
 
 	if (nativex)
 		return nativex;
 
-	tmp = (read3CE(VertStretch) >> 4) & 3;
+	tmp = (read3CE(par, VertStretch) >> 4) & 3;
 
 	switch (tmp) {
 	case 0:
@@ -632,44 +650,45 @@ static int __devinit get_nativex(void)
 }
 
 /* Set pitch */
-static void set_lwidth(int width)
+static void set_lwidth(struct tridentfb_par *par, int width)
 {
-	write3X4(Offset, width & 0xFF);
-	write3X4(AddColReg,
-		 (read3X4(AddColReg) & 0xCF) | ((width & 0x300) >> 4));
+	write3X4(par, Offset, width & 0xFF);
+	write3X4(par, AddColReg,
+		 (read3X4(par, AddColReg) & 0xCF) | ((width & 0x300) >> 4));
 }
 
 /* For resolutions smaller than FP resolution stretch */
-static void screen_stretch(void)
+static void screen_stretch(struct tridentfb_par *par)
 {
 	if (chip_id != CYBERBLADEXPAi1)
-		write3CE(BiosReg, 0);
+		write3CE(par, BiosReg, 0);
 	else
-		write3CE(BiosReg, 8);
-	write3CE(VertStretch, (read3CE(VertStretch) & 0x7C) | 1);
-	write3CE(HorStretch, (read3CE(HorStretch) & 0x7C) | 1);
+		write3CE(par, BiosReg, 8);
+	write3CE(par, VertStretch, (read3CE(par, VertStretch) & 0x7C) | 1);
+	write3CE(par, HorStretch, (read3CE(par, HorStretch) & 0x7C) | 1);
 }
 
 /* For resolutions smaller than FP resolution center */
-static void screen_center(void)
+static void screen_center(struct tridentfb_par *par)
 {
-	write3CE(VertStretch, (read3CE(VertStretch) & 0x7C) | 0x80);
-	write3CE(HorStretch, (read3CE(HorStretch) & 0x7C) | 0x80);
+	write3CE(par, VertStretch, (read3CE(par, VertStretch) & 0x7C) | 0x80);
+	write3CE(par, HorStretch, (read3CE(par, HorStretch) & 0x7C) | 0x80);
 }
 
 /* Address of first shown pixel in display memory */
-static void set_screen_start(int base)
+static void set_screen_start(struct tridentfb_par *par, int base)
 {
-	write3X4(StartAddrLow, base & 0xFF);
-	write3X4(StartAddrHigh, (base & 0xFF00) >> 8);
-	write3X4(CRTCModuleTest,
-		 (read3X4(CRTCModuleTest) & 0xDF) | ((base & 0x10000) >> 11));
-	write3X4(CRTHiOrd,
-		 (read3X4(CRTHiOrd) & 0xF8) | ((base & 0xE0000) >> 17));
+	u8 tmp;
+	write3X4(par, StartAddrLow, base & 0xFF);
+	write3X4(par, StartAddrHigh, (base & 0xFF00) >> 8);
+	tmp = read3X4(par, CRTCModuleTest) & 0xDF;
+	write3X4(par, CRTCModuleTest, tmp | ((base & 0x10000) >> 11));
+	tmp = read3X4(par, CRTHiOrd) & 0xF8;
+	write3X4(par, CRTHiOrd, tmp | ((base & 0xE0000) >> 17));
 }
 
 /* Set dotclock frequency */
-static void set_vclk(unsigned long freq)
+static void set_vclk(struct tridentfb_par *par, unsigned long freq)
 {
 	int m, n, k;
 	unsigned long f, fi, d, di;
@@ -690,8 +709,8 @@ static void set_vclk(unsigned long freq)
 					break;
 			}
 	if (chip3D) {
-		write3C4(ClockHigh, hi);
-		write3C4(ClockLow, lo);
+		write3C4(par, ClockHigh, hi);
+		write3C4(par, ClockLow, lo);
 	} else {
 		outb(lo, 0x43C8);
 		outb(hi, 0x43C9);
@@ -700,9 +719,9 @@ static void set_vclk(unsigned long freq)
 }
 
 /* Set number of lines for flat panels*/
-static void set_number_of_lines(int lines)
+static void set_number_of_lines(struct tridentfb_par *par, int lines)
 {
-	int tmp = read3CE(CyberEnhance) & 0x8F;
+	int tmp = read3CE(par, CyberEnhance) & 0x8F;
 	if (lines > 1024)
 		tmp |= 0x50;
 	else if (lines > 768)
@@ -711,24 +730,24 @@ static void set_number_of_lines(int line
 		tmp |= 0x20;
 	else if (lines > 480)
 		tmp |= 0x10;
-	write3CE(CyberEnhance, tmp);
+	write3CE(par, CyberEnhance, tmp);
 }
 
 /*
  * If we see that FP is active we assume we have one.
  * Otherwise we have a CRT display.User can override.
  */
-static unsigned int __devinit get_displaytype(void)
+static unsigned int __devinit get_displaytype(struct tridentfb_par *par)
 {
 	if (fp)
 		return DISPLAY_FP;
 	if (crt || !chipcyber)
 		return DISPLAY_CRT;
-	return (read3CE(FPConfig) & 0x10) ? DISPLAY_FP : DISPLAY_CRT;
+	return (read3CE(par, FPConfig) & 0x10) ? DISPLAY_FP : DISPLAY_CRT;
 }
 
 /* Try detecting the video memory size */
-static unsigned int __devinit get_memsize(void)
+static unsigned int __devinit get_memsize(struct tridentfb_par *par)
 {
 	unsigned char tmp, tmp2;
 	unsigned int k;
@@ -742,7 +761,7 @@ static unsigned int __devinit get_memsiz
 			k = 2560 * Kb;
 			break;
 		default:
-			tmp = read3X4(SPR) & 0x0F;
+			tmp = read3X4(par, SPR) & 0x0F;
 			switch (tmp) {
 
 			case 0x01:
@@ -774,7 +793,7 @@ static unsigned int __devinit get_memsiz
 				break;
 			case 0x0E:		/* XP */
 
-				tmp2 = read3C4(0xC1);
+				tmp2 = read3C4(par, 0xC1);
 				switch (tmp2) {
 				case 0x00:
 					k = 20 * Mb;
@@ -862,6 +881,7 @@ static int tridentfb_check_var(struct fb
 static int tridentfb_pan_display(struct fb_var_screeninfo *var,
 				 struct fb_info *info)
 {
+	struct tridentfb_par *par = (struct tridentfb_par *)(info->par);
 	unsigned int offset;
 
 	debug("enter\n");
@@ -869,13 +889,20 @@ static int tridentfb_pan_display(struct 
 		* var->bits_per_pixel / 32;
 	info->var.xoffset = var->xoffset;
 	info->var.yoffset = var->yoffset;
-	set_screen_start(offset);
+	set_screen_start(par, offset);
 	debug("exit\n");
 	return 0;
 }
 
-#define shadowmode_on()  write3CE(CyberControl, read3CE(CyberControl) | 0x81)
-#define shadowmode_off() write3CE(CyberControl, read3CE(CyberControl) & 0x7E)
+static void shadowmode_on(struct tridentfb_par *par)
+{
+	write3CE(par, CyberControl, read3CE(par, CyberControl) | 0x81);
+}
+
+static void shadowmode_off(struct tridentfb_par *par)
+{
+	write3CE(par, CyberControl, read3CE(par, CyberControl) & 0x7E);
+}
 
 /* Set the hardware to the requested video mode */
 static int tridentfb_set_par(struct fb_info *info)
@@ -905,8 +932,8 @@ static int tridentfb_set_par(struct fb_i
 	vblankstart = var->yres;
 	vblankend = vtotal + 2;
 
-	crtc_unlock();
-	write3CE(CyberControl, 8);
+	crtc_unlock(par);
+	write3CE(par, CyberControl, 8);
 
 	if (flatpanel && var->xres < nativex) {
 		/*
@@ -914,35 +941,36 @@ static int tridentfb_set_par(struct fb_i
 		 * than requested resolution decide whether
 		 * we stretch or center
 		 */
-		t_outb(0xEB, 0x3C2);
+		t_outb(par, 0xEB, 0x3C2);
 
-		shadowmode_on();
+		shadowmode_on(par);
 
 		if (center)
-			screen_center();
+			screen_center(par);
 		else if (stretch)
-			screen_stretch();
+			screen_stretch(par);
 
 	} else {
-		t_outb(0x2B, 0x3C2);
-		write3CE(CyberControl, 8);
+		t_outb(par, 0x2B, 0x3C2);
+		write3CE(par, CyberControl, 8);
 	}
 
 	/* vertical timing values */
-	write3X4(CRTVTotal, vtotal & 0xFF);
-	write3X4(CRTVDispEnd, vdispend & 0xFF);
-	write3X4(CRTVSyncStart, vsyncstart & 0xFF);
-	write3X4(CRTVSyncEnd, (vsyncend & 0x0F));
-	write3X4(CRTVBlankStart, vblankstart & 0xFF);
-	write3X4(CRTVBlankEnd, 0 /* p->vblankend & 0xFF */ );
+	write3X4(par, CRTVTotal, vtotal & 0xFF);
+	write3X4(par, CRTVDispEnd, vdispend & 0xFF);
+	write3X4(par, CRTVSyncStart, vsyncstart & 0xFF);
+	write3X4(par, CRTVSyncEnd, (vsyncend & 0x0F));
+	write3X4(par, CRTVBlankStart, vblankstart & 0xFF);
+	write3X4(par, CRTVBlankEnd, 0 /* p->vblankend & 0xFF */);
 
 	/* horizontal timing values */
-	write3X4(CRTHTotal, htotal & 0xFF);
-	write3X4(CRTHDispEnd, hdispend & 0xFF);
-	write3X4(CRTHSyncStart, hsyncstart & 0xFF);
-	write3X4(CRTHSyncEnd, (hsyncend & 0x1F) | ((hblankend & 0x20) << 2));
-	write3X4(CRTHBlankStart, hblankstart & 0xFF);
-	write3X4(CRTHBlankEnd, 0 /* (p->hblankend & 0x1F) */ );
+	write3X4(par, CRTHTotal, htotal & 0xFF);
+	write3X4(par, CRTHDispEnd, hdispend & 0xFF);
+	write3X4(par, CRTHSyncStart, hsyncstart & 0xFF);
+	write3X4(par, CRTHSyncEnd,
+		 (hsyncend & 0x1F) | ((hblankend & 0x20) << 2));
+	write3X4(par, CRTHBlankStart, hblankstart & 0xFF);
+	write3X4(par, CRTHBlankEnd, 0 /* (p->hblankend & 0x1F) */);
 
 	/* higher bits of vertical timing values */
 	tmp = 0x10;
@@ -954,35 +982,37 @@ static int tridentfb_set_par(struct fb_i
 	if (vtotal & 0x200) tmp |= 0x20;
 	if (vdispend & 0x200) tmp |= 0x40;
 	if (vsyncstart & 0x200) tmp |= 0x80;
-	write3X4(CRTOverflow, tmp);
+	write3X4(par, CRTOverflow, tmp);
 
-	tmp = read3X4(CRTHiOrd) | 0x08;	/* line compare bit 10 */
+	tmp = read3X4(par, CRTHiOrd) | 0x08;	/* line compare bit 10 */
 	if (vtotal & 0x400) tmp |= 0x80;
 	if (vblankstart & 0x400) tmp |= 0x40;
 	if (vsyncstart & 0x400) tmp |= 0x20;
 	if (vdispend & 0x400) tmp |= 0x10;
-	write3X4(CRTHiOrd, tmp);
+	write3X4(par, CRTHiOrd, tmp);
 
 	tmp = 0;
 	if (htotal & 0x800) tmp |= 0x800 >> 11;
 	if (hblankstart & 0x800) tmp |= 0x800 >> 7;
-	write3X4(HorizOverflow, tmp);
+	write3X4(par, HorizOverflow, tmp);
 
 	tmp = 0x40;
 	if (vblankstart & 0x200) tmp |= 0x20;
 //FIXME	if (info->var.vmode & FB_VMODE_DOUBLE) tmp |= 0x80;  /* double scan for 200 line modes */
-	write3X4(CRTMaxScanLine, tmp);
+	write3X4(par, CRTMaxScanLine, tmp);
 
-	write3X4(CRTLineCompare, 0xFF);
-	write3X4(CRTPRowScan, 0);
-	write3X4(CRTModeControl, 0xC3);
+	write3X4(par, CRTLineCompare, 0xFF);
+	write3X4(par, CRTPRowScan, 0);
+	write3X4(par, CRTModeControl, 0xC3);
 
-	write3X4(LinearAddReg, 0x20);	/* enable linear addressing */
+	write3X4(par, LinearAddReg, 0x20);	/* enable linear addressing */
 
 	tmp = (info->var.vmode & FB_VMODE_INTERLACED) ? 0x84 : 0x80;
-	write3X4(CRTCModuleTest, tmp);	/* enable access extended memory */
+	/* enable access extended memory */
+	write3X4(par, CRTCModuleTest, tmp);
 
-	write3X4(GraphEngReg, 0x80);	/* enable GE for text acceleration */
+	/* enable GE for text acceleration */
+	write3X4(par, GraphEngReg, 0x80);
 
 #ifdef CONFIG_FB_TRIDENT_ACCEL
 	acc->init_accel(info->var.xres, bpp);
@@ -1003,49 +1033,52 @@ static int tridentfb_set_par(struct fb_i
 		break;
 	}
 
-	write3X4(PixelBusReg, tmp);
+	write3X4(par, PixelBusReg, tmp);
 
 	tmp = 0x10;
 	if (chipcyber)
 		tmp |= 0x20;
-	write3X4(DRAMControl, tmp);	/* both IO, linear enable */
+	write3X4(par, DRAMControl, tmp);	/* both IO, linear enable */
 
-	write3X4(InterfaceSel, read3X4(InterfaceSel) | 0x40);
-	write3X4(Performance, 0x92);
-	write3X4(PCIReg, 0x07);		/* MMIO & PCI read and write burst enable */
+	write3X4(par, InterfaceSel, read3X4(par, InterfaceSel) | 0x40);
+	write3X4(par, Performance, 0x92);
+	/* MMIO & PCI read and write burst enable */
+	write3X4(par, PCIReg, 0x07);
 
 	/* convert from picoseconds to kHz */
 	vclk = PICOS2KHZ(info->var.pixclock);
 	if (bpp == 32)
 		vclk *= 2;
-	set_vclk(vclk);
+	set_vclk(par, vclk);
 
-	write3C4(0, 3);
-	write3C4(1, 1);		/* set char clock 8 dots wide */
-	write3C4(2, 0x0F);	/* enable 4 maps because needed in chain4 mode */
-	write3C4(3, 0);
-	write3C4(4, 0x0E);	/* memory mode enable bitmaps ?? */
-
-	write3CE(MiscExtFunc, (bpp == 32) ? 0x1A : 0x12);	/* divide clock by 2 if 32bpp */
-							/* chain4 mode display and CPU path */
-	write3CE(0x5, 0x40);	/* no CGA compat, allow 256 col */
-	write3CE(0x6, 0x05);	/* graphics mode */
-	write3CE(0x7, 0x0F);	/* planes? */
+	write3C4(par, 0, 3);
+	write3C4(par, 1, 1);		/* set char clock 8 dots wide */
+	/* enable 4 maps because needed in chain4 mode */
+	write3C4(par, 2, 0x0F);
+	write3C4(par, 3, 0);
+	write3C4(par, 4, 0x0E);	/* memory mode enable bitmaps ?? */
+
+	/* divide clock by 2 if 32bpp chain4 mode display and CPU path */
+	write3CE(par, MiscExtFunc, (bpp == 32) ? 0x1A : 0x12);
+	write3CE(par, 0x5, 0x40);	/* no CGA compat, allow 256 col */
+	write3CE(par, 0x6, 0x05);	/* graphics mode */
+	write3CE(par, 0x7, 0x0F);	/* planes? */
 
 	if (chip_id == CYBERBLADEXPAi1) {
 		/* This fixes snow-effect in 32 bpp */
-		write3X4(CRTHSyncStart, 0x84);
+		write3X4(par, CRTHSyncStart, 0x84);
 	}
 
-	writeAttr(0x10, 0x41);	/* graphics mode and support 256 color modes */
-	writeAttr(0x12, 0x0F);	/* planes */
-	writeAttr(0x13, 0);	/* horizontal pel panning */
+	/* graphics mode and support 256 color modes */
+	writeAttr(par, 0x10, 0x41);
+	writeAttr(par, 0x12, 0x0F);	/* planes */
+	writeAttr(par, 0x13, 0);	/* horizontal pel panning */
 
 	/* colors */
 	for (tmp = 0; tmp < 0x10; tmp++)
-		writeAttr(tmp, tmp);
-	readb(par->io_virt + CRT + 0x0A);	/* flip-flop to index */
-	t_outb(0x20, 0x3C0);			/* enable attr */
+		writeAttr(par, tmp, tmp);
+	fb_readb(par->io_virt + CRT + 0x0A);	/* flip-flop to index */
+	t_outb(par, 0x20, 0x3C0);		/* enable attr */
 
 	switch (bpp) {
 	case 8:
@@ -1063,17 +1096,17 @@ static int tridentfb_set_par(struct fb_i
 		break;
 	}
 
-	t_inb(0x3C8);
-	t_inb(0x3C6);
-	t_inb(0x3C6);
-	t_inb(0x3C6);
-	t_inb(0x3C6);
-	t_outb(tmp, 0x3C6);
-	t_inb(0x3C8);
+	t_inb(par, 0x3C8);
+	t_inb(par, 0x3C6);
+	t_inb(par, 0x3C6);
+	t_inb(par, 0x3C6);
+	t_inb(par, 0x3C6);
+	t_outb(par, tmp, 0x3C6);
+	t_inb(par, 0x3C8);
 
 	if (flatpanel)
-		set_number_of_lines(info->var.yres);
-	set_lwidth(info->var.xres * bpp / (4 * 16));
+		set_number_of_lines(par, info->var.yres);
+	set_lwidth(par, info->var.xres * bpp / (4 * 16));
 	info->fix.visual = (bpp == 8) ? FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
 	info->fix.line_length = info->var.xres * (bpp >> 3);
 	info->cmap.len = (bpp == 8) ? 256 : 16;
@@ -1087,17 +1120,18 @@ static int tridentfb_setcolreg(unsigned 
 			       struct fb_info *info)
 {
 	int bpp = info->var.bits_per_pixel;
+	struct tridentfb_par *par = (struct tridentfb_par*)info->par;
 
 	if (regno >= info->cmap.len)
 		return 1;
 
 	if (bpp == 8) {
-		t_outb(0xFF, 0x3C6);
-		t_outb(regno, 0x3C8);
+		t_outb(par, 0xFF, 0x3C6);
+		t_outb(par, regno, 0x3C8);
 
-		t_outb(red >> 10, 0x3C9);
-		t_outb(green >> 10, 0x3C9);
-		t_outb(blue >> 10, 0x3C9);
+		t_outb(par, red >> 10, 0x3C9);
+		t_outb(par, green >> 10, 0x3C9);
+		t_outb(par, blue >> 10, 0x3C9);
 
 	} else if (regno < 16) {
 		if (bpp == 16) {	/* RGB 565 */
@@ -1123,13 +1157,14 @@ static int tridentfb_setcolreg(unsigned 
 static int tridentfb_blank(int blank_mode, struct fb_info *info)
 {
 	unsigned char PMCont, DPMSCont;
+	struct tridentfb_par *par = (struct tridentfb_par*)info->par;
 
 	debug("enter\n");
 	if (flatpanel)
 		return 0;
-	t_outb(0x04, 0x83C8); /* Read DPMS Control */
-	PMCont = t_inb(0x83C6) & 0xFC;
-	DPMSCont = read3CE(PowerStatus) & 0xFC;
+	t_outb(par, 0x04, 0x83C8); /* Read DPMS Control */
+	PMCont = t_inb(par, 0x83C6) & 0xFC;
+	DPMSCont = read3CE(par, PowerStatus) & 0xFC;
 	switch (blank_mode) {
 	case FB_BLANK_UNBLANK:
 		/* Screen: On, HSync: On, VSync: On */
@@ -1155,9 +1190,9 @@ static int tridentfb_blank(int blank_mod
 		break;
 	}
 
-	write3CE(PowerStatus, DPMSCont);
-	t_outb(4, 0x83C8);
-	t_outb(PMCont, 0x83C6);
+	write3CE(par, PowerStatus, DPMSCont);
+	t_outb(par, 4, 0x83C8);
+	t_outb(par, PMCont, 0x83C6);
 
 	debug("exit\n");
 
@@ -1265,11 +1300,11 @@ static int __devinit trident_pci_probe(s
 
 	/* setup framebuffer memory */
 	tridentfb_fix.smem_start = pci_resource_start(dev, 0);
-	tridentfb_fix.smem_len = get_memsize();
+	tridentfb_fix.smem_len = get_memsize(&default_par);
 
 	if (!request_mem_region(tridentfb_fix.smem_start, tridentfb_fix.smem_len, "tridentfb")) {
 		debug("request_mem_region failed!\n");
-		disable_mmio();
+		disable_mmio(fb_info.par);
 		err = -1;
 		goto out_unmap1;
 	}
@@ -1284,10 +1319,10 @@ static int __devinit trident_pci_probe(s
 	}
 
 	output("%s board found\n", pci_name(dev));
-	displaytype = get_displaytype();
+	displaytype = get_displaytype(&default_par);
 
 	if (flatpanel)
-		nativex = get_nativex();
+		nativex = get_nativex(&default_par);
 
 	fb_info.fix = tridentfb_fix;
 	fb_info.fbops = &tridentfb_ops;
@@ -1330,7 +1365,7 @@ out_unmap2:
 	if (fb_info.screen_base)
 		iounmap(fb_info.screen_base);
 	release_mem_region(tridentfb_fix.smem_start, tridentfb_fix.smem_len);
-	disable_mmio();
+	disable_mmio(fb_info.par);
 out_unmap1:
 	if (default_par.io_virt)
 		iounmap(default_par.io_virt);
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
tridentfb-remove-misplaced-enable_mmio.patch
tridentfb-improve-clock-setting-accuracy.patch
tridentfb-replace-macros-with-functions.patch

