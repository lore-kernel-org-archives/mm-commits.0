From: akpm@linux-foundation.org
Subject: + tridentfb-coding-style-improvement.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:52 -0700
Message-ID: <200707261900.l6QJ0qxF015680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41114 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932566AbXGZTMj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:12:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     tridentfb: coding style improvement
has been added to the -mm tree.  Its filename is
     tridentfb-coding-style-improvement.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tridentfb: coding style improvement
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch contains coding style improvements to the tridentfb driver (white
spaces, indentations, long lines).

It also moves fb_ops structure after fb api functions are defined.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c | 1081 +++++++++++++++++++-----------------
 1 file changed, 595 insertions(+), 486 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-coding-style-improvement drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-coding-style-improvement
+++ a/drivers/video/tridentfb.c
@@ -1,18 +1,19 @@
 /*
  * Frame buffer driver for Trident Blade and Image series
  *
- * Copyright 2001,2002 - Jani Monoses   <jani@iv.ro>
+ * Copyright 2001, 2002 - Jani Monoses   <jani@iv.ro>
  *
  *
  * CREDITS:(in order of appearance)
- * 	skeletonfb.c by Geert Uytterhoeven and other fb code in drivers/video
- * 	Special thanks ;) to Mattia Crivellini <tia@mclink.it>
- * 	much inspired by the XFree86 4.x Trident driver sources by Alan Hourihane
- * 	the FreeVGA project
- *	Francesco Salvestrini <salvestrini@users.sf.net> XP support,code,suggestions
+ *	skeletonfb.c by Geert Uytterhoeven and other fb code in drivers/video
+ *	Special thanks ;) to Mattia Crivellini <tia@mclink.it>
+ *	much inspired by the XFree86 4.x Trident driver sources
+ *	by Alan Hourihane the FreeVGA project
+ *	Francesco Salvestrini <salvestrini@users.sf.net> XP support,
+ *	code, suggestions
  * TODO:
- * 	timing value tweaking so it looks good on every monitor in every mode
- *	TGUI acceleration	
+ *	timing value tweaking so it looks good on every monitor in every mode
+ *	TGUI acceleration
  */
 
 #include <linux/module.h>
@@ -26,11 +27,11 @@
 #define VERSION		"0.7.8-NEWAPI"
 
 struct tridentfb_par {
-	int vclk;		//in MHz
-	void __iomem * io_virt;	//iospace virtual memory address
+	int vclk;		/* in MHz */
+	void __iomem *io_virt;	/* iospace virtual memory address */
 };
 
-static unsigned char eng_oper;		//engine operation...
+static unsigned char eng_oper;	/* engine operation... */
 static struct fb_ops tridentfb_ops;
 
 static struct tridentfb_par default_par;
@@ -39,11 +40,10 @@ static struct tridentfb_par default_par;
 static struct fb_info fb_info;
 static u32 pseudo_pal[16];
 
-
 static struct fb_var_screeninfo default_var;
 
 static struct fb_fix_screeninfo tridentfb_fix = {
-	.id = "Trident",	
+	.id = "Trident",
 	.type = FB_TYPE_PACKED_PIXELS,
 	.ypanstep = 1,
 	.visual = FB_VISUAL_PSEUDOCOLOR,
@@ -55,11 +55,10 @@ static int chip_id;
 static int defaultaccel;
 static int displaytype;
 
-
 /* defaults which are normally overriden by user values */
 
 /* video mode */
-static char * mode = "640x480";
+static char *mode = "640x480";
 static int bpp = 8;
 
 static int noaccel;
@@ -74,7 +73,6 @@ static int memsize;
 static int memdiff;
 static int nativex;
 
-
 module_param(mode, charp, 0);
 module_param(bpp, int, 0);
 module_param(center, int, 0);
@@ -86,88 +84,85 @@ module_param(nativex, int, 0);
 module_param(fp, int, 0);
 module_param(crt, int, 0);
 
-
 static int chip3D;
 static int chipcyber;
 
 static int is3Dchip(int id)
 {
-	return 	((id == BLADE3D) || (id == CYBERBLADEE4) ||
-		 (id == CYBERBLADEi7) || (id == CYBERBLADEi7D) ||
-		 (id == CYBER9397) || (id == CYBER9397DVD) ||
-		 (id == CYBER9520) || (id == CYBER9525DVD) ||
-		 (id == IMAGE975) || (id == IMAGE985) ||
-		 (id == CYBERBLADEi1) || (id == CYBERBLADEi1D) ||
-		 (id ==	CYBERBLADEAi1) || (id == CYBERBLADEAi1D) ||
-		 (id ==	CYBERBLADEXPm8) || (id == CYBERBLADEXPm16) ||
-		 (id ==	CYBERBLADEXPAi1));
+	return ((id == BLADE3D) || (id == CYBERBLADEE4) ||
+		(id == CYBERBLADEi7) || (id == CYBERBLADEi7D) ||
+		(id == CYBER9397) || (id == CYBER9397DVD) ||
+		(id == CYBER9520) || (id == CYBER9525DVD) ||
+		(id == IMAGE975) || (id == IMAGE985) ||
+		(id == CYBERBLADEi1) || (id == CYBERBLADEi1D) ||
+		(id == CYBERBLADEAi1) || (id == CYBERBLADEAi1D) ||
+		(id == CYBERBLADEXPm8) || (id == CYBERBLADEXPm16) ||
+		(id == CYBERBLADEXPAi1));
 }
 
 static int iscyber(int id)
 {
 	switch (id) {
-		case CYBER9388:		
-		case CYBER9382:
-		case CYBER9385:
-		case CYBER9397:
-		case CYBER9397DVD:
-		case CYBER9520:
-		case CYBER9525DVD:
-		case CYBERBLADEE4:
-		case CYBERBLADEi7D:
-		case CYBERBLADEi1:
-		case CYBERBLADEi1D: 
-		case CYBERBLADEAi1: 
-		case CYBERBLADEAi1D:
-		case CYBERBLADEXPAi1:
-			return 1;
-		
-		case CYBER9320:
-		case TGUI9660:     
-		case IMAGE975:
-		case IMAGE985:
-		case BLADE3D:
-		case CYBERBLADEi7: /* VIA MPV4 integrated version */
+	case CYBER9388:
+	case CYBER9382:
+	case CYBER9385:
+	case CYBER9397:
+	case CYBER9397DVD:
+	case CYBER9520:
+	case CYBER9525DVD:
+	case CYBERBLADEE4:
+	case CYBERBLADEi7D:
+	case CYBERBLADEi1:
+	case CYBERBLADEi1D:
+	case CYBERBLADEAi1:
+	case CYBERBLADEAi1D:
+	case CYBERBLADEXPAi1:
+		return 1;
 
-		default:
-			/* case CYBERBLDAEXPm8:	 Strange */
-			/* case CYBERBLDAEXPm16: Strange */
-			return 0;
+	case CYBER9320:
+	case TGUI9660:
+	case IMAGE975:
+	case IMAGE985:
+	case BLADE3D:
+	case CYBERBLADEi7:	/* VIA MPV4 integrated version */
+
+	default:
+		/* case CYBERBLDAEXPm8:  Strange */
+		/* case CYBERBLDAEXPm16: Strange */
+		return 0;
 	}
 }
 
-#define CRT 0x3D0		//CRTC registers offset for color display
+#define CRT 0x3D0		/* CRTC registers offset for color display */
 
 #ifndef TRIDENT_MMIO
 	#define TRIDENT_MMIO 1
 #endif
 
 #if TRIDENT_MMIO
-	#define t_outb(val,reg)	writeb(val,((struct tridentfb_par *)(fb_info.par))->io_virt + reg)
+	#define t_outb(val, reg)	writeb(val,((struct tridentfb_par *)(fb_info.par))->io_virt + reg)
 	#define t_inb(reg)	readb(((struct tridentfb_par*)(fb_info.par))->io_virt + reg)
 #else
-	#define t_outb(val,reg) outb(val,reg)
+	#define t_outb(val, reg) outb(val, reg)
 	#define t_inb(reg) inb(reg)
 #endif
 
 
 static struct accel_switch {
-	void (*init_accel)(int,int);
-	void (*wait_engine)(void);
-	void (*fill_rect)(__u32,__u32,__u32,__u32,__u32,__u32);
-	void (*copy_rect)(__u32,__u32,__u32,__u32,__u32,__u32);
+	void (*init_accel) (int, int);
+	void (*wait_engine) (void);
+	void (*fill_rect) (u32, u32, u32, u32, u32, u32);
+	void (*copy_rect) (u32, u32, u32, u32, u32, u32);
 } *acc;
 
-#define writemmr(r,v)	writel(v, ((struct tridentfb_par *)fb_info.par)->io_virt + r)
+#define writemmr(r, v)	writel(v, ((struct tridentfb_par *)fb_info.par)->io_virt + r)
 #define readmmr(r)	readl(((struct tridentfb_par *)fb_info.par)->io_virt + r)
 
-
-
 /*
  * Blade specific acceleration.
  */
 
-#define point(x,y) ((y)<<16|(x))
+#define point(x, y) ((y) << 16 | (x))
 #define STA	0x2120
 #define CMD	0x2144
 #define ROP	0x2148
@@ -179,64 +174,71 @@ static struct accel_switch {
 
 #define ROP_S	0xCC
 
-static void blade_init_accel(int pitch,int bpp)
+static void blade_init_accel(int pitch, int bpp)
 {
-	int v1 = (pitch>>3)<<20;
-	int tmp = 0,v2;
+	int v1 = (pitch >> 3) << 20;
+	int tmp = 0, v2;
 	switch (bpp) {
-		case 8:tmp = 0;break;
-		case 15:tmp = 5;break;
-		case 16:tmp = 1;break;
-		case 24:
-		case 32:tmp = 2;break;
-	}
-	v2 = v1 | (tmp<<29);
-	writemmr(0x21C0,v2);
-	writemmr(0x21C4,v2);
-	writemmr(0x21B8,v2);
-	writemmr(0x21BC,v2);
-	writemmr(0x21D0,v1);
-	writemmr(0x21D4,v1);
-	writemmr(0x21C8,v1);
-	writemmr(0x21CC,v1);
-	writemmr(0x216C,0);
+	case 8:
+		tmp = 0;
+		break;
+	case 15:
+		tmp = 5;
+		break;
+	case 16:
+		tmp = 1;
+		break;
+	case 24:
+	case 32:
+		tmp = 2;
+		break;
+	}
+	v2 = v1 | (tmp << 29);
+	writemmr(0x21C0, v2);
+	writemmr(0x21C4, v2);
+	writemmr(0x21B8, v2);
+	writemmr(0x21BC, v2);
+	writemmr(0x21D0, v1);
+	writemmr(0x21D4, v1);
+	writemmr(0x21C8, v1);
+	writemmr(0x21CC, v1);
+	writemmr(0x216C, 0);
 }
 
 static void blade_wait_engine(void)
 {
-	while(readmmr(STA) & 0xFA800000);
+	while (readmmr(STA) & 0xFA800000) ;
 }
 
-static void blade_fill_rect(__u32 x,__u32 y,__u32 w,__u32 h,__u32 c,__u32 rop)
+static void blade_fill_rect(u32 x, u32 y, u32 w, u32 h, u32 c, u32 rop)
 {
-	writemmr(CLR,c);
-	writemmr(ROP,rop ? 0x66:ROP_S);
-	writemmr(CMD,0x20000000|1<<19|1<<4|2<<2);
+	writemmr(CLR, c);
+	writemmr(ROP, rop ? 0x66 : ROP_S);
+	writemmr(CMD, 0x20000000 | 1 << 19 | 1 << 4 | 2 << 2);
 
-	writemmr(DR1,point(x,y));
-	writemmr(DR2,point(x+w-1,y+h-1));
+	writemmr(DR1, point(x, y));
+	writemmr(DR2, point(x + w - 1, y + h - 1));
 }
 
-static void blade_copy_rect(__u32 x1,__u32 y1,__u32 x2,__u32 y2,__u32 w,__u32 h)
+static void blade_copy_rect(u32 x1, u32 y1, u32 x2, u32 y2, u32 w, u32 h)
 {
-	__u32 s1,s2,d1,d2;
+	u32 s1, s2, d1, d2;
 	int direction = 2;
-	s1 = point(x1,y1);
-	s2 = point(x1+w-1,y1+h-1);
-	d1 = point(x2,y2);
-	d2 = point(x2+w-1,y2+h-1);
+	s1 = point(x1, y1);
+	s2 = point(x1 + w - 1, y1 + h - 1);
+	d1 = point(x2, y2);
+	d2 = point(x2 + w - 1, y2 + h - 1);
 
 	if ((y1 > y2) || ((y1 == y2) && (x1 > x2)))
-			direction = 0;
-
+		direction = 0;
 
-	writemmr(ROP,ROP_S);
-	writemmr(CMD,0xE0000000|1<<19|1<<4|1<<2|direction);
+	writemmr(ROP, ROP_S);
+	writemmr(CMD, 0xE0000000 | 1 << 19 | 1 << 4 | 1 << 2 | direction);
 
-	writemmr(SR1,direction?s2:s1);
-	writemmr(SR2,direction?s1:s2);
-	writemmr(DR1,direction?d2:d1);
-	writemmr(DR2,direction?d1:d2);
+	writemmr(SR1, direction ? s2 : s1);
+	writemmr(SR2, direction ? s1 : s2);
+	writemmr(DR1, direction ? d2 : d1);
+	writemmr(DR2, direction ? d1 : d2);
 }
 
 static struct accel_switch accel_blade = {
@@ -246,51 +248,72 @@ static struct accel_switch accel_blade =
 	blade_copy_rect,
 };
 
-
 /*
  * BladeXP specific acceleration functions
  */
 
 #define ROP_P 0xF0
-#define masked_point(x,y) ((y & 0xffff)<<16|(x & 0xffff))
+#define masked_point(x, y) ((y & 0xffff)<<16|(x & 0xffff))
 
-static void xp_init_accel(int pitch,int bpp)
+static void xp_init_accel(int pitch, int bpp)
 {
-	int tmp = 0,v1;
+	int tmp = 0, v1;
 	unsigned char x = 0;
 
 	switch (bpp) {
-		case 8:  x = 0; break;
-		case 16: x = 1; break;
-		case 24: x = 3; break;
-		case 32: x = 2; break;
+	case 8:
+		x = 0;
+		break;
+	case 16:
+		x = 1;
+		break;
+	case 24:
+		x = 3;
+		break;
+	case 32:
+		x = 2;
+		break;
 	}
 
 	switch (pitch << (bpp >> 3)) {
-		case 8192:
-		case 512:  x |= 0x00; break;
-		case 1024: x |= 0x04; break;
-		case 2048: x |= 0x08; break;
-		case 4096: x |= 0x0C; break;
+	case 8192:
+	case 512:
+		x |= 0x00;
+		break;
+	case 1024:
+		x |= 0x04;
+		break;
+	case 2048:
+		x |= 0x08;
+		break;
+	case 4096:
+		x |= 0x0C;
+		break;
 	}
 
-	t_outb(x,0x2125);
+	t_outb(x, 0x2125);
 
 	eng_oper = x | 0x40;
 
 	switch (bpp) {
-		case 8:  tmp = 18; break;
-		case 15:
-		case 16: tmp = 19; break;
-		case 24:
-		case 32: tmp = 20; break;
+	case 8:
+		tmp = 18;
+		break;
+	case 15:
+	case 16:
+		tmp = 19;
+		break;
+	case 24:
+	case 32:
+		tmp = 20;
+		break;
 	}
 
 	v1 = pitch << tmp;
 
-	writemmr(0x2154,v1);
-	writemmr(0x2150,v1);
-	t_outb(3,0x2126);
+	writemmr(0x2154, v1);
+	writemmr(0x2150, v1);
+	t_outb(3, 0x2126);
 }
 
 static void xp_wait_engine(void)
@@ -318,24 +341,24 @@ static void xp_wait_engine(void)
 	}
 }
 
-static void xp_fill_rect(__u32 x,__u32 y,__u32 w,__u32 h,__u32 c,__u32 rop)
+static void xp_fill_rect(u32 x, u32 y, u32 w, u32 h, u32 c, u32 rop)
 {
-	writemmr(0x2127,ROP_P);
-	writemmr(0x2158,c);
-	writemmr(0x2128,0x4000);
-	writemmr(0x2140,masked_point(h,w));
-	writemmr(0x2138,masked_point(y,x));
-	t_outb(0x01,0x2124);
-        t_outb(eng_oper,0x2125);
+	writemmr(0x2127, ROP_P);
+	writemmr(0x2158, c);
+	writemmr(0x2128, 0x4000);
+	writemmr(0x2140, masked_point(h, w));
+	writemmr(0x2138, masked_point(y, x));
+	t_outb(0x01, 0x2124);
+	t_outb(eng_oper, 0x2125);
 }
 
-static void xp_copy_rect(__u32 x1,__u32 y1,__u32 x2,__u32 y2,__u32 w,__u32 h)
+static void xp_copy_rect(u32 x1, u32 y1, u32 x2, u32 y2, u32 w, u32 h)
 {
 	int direction;
-	__u32 x1_tmp, x2_tmp, y1_tmp, y2_tmp;
+	u32 x1_tmp, x2_tmp, y1_tmp, y2_tmp;
 
 	direction = 0x0004;
-	
+
 	if ((x1 < x2) && (y1 == y2)) {
 		direction |= 0x0200;
 		x1_tmp = x1 + w - 1;
@@ -344,53 +367,60 @@ static void xp_copy_rect(__u32 x1,__u32 
 		x1_tmp = x1;
 		x2_tmp = x2;
 	}
-  
+
 	if (y1 < y2) {
 		direction |= 0x0100;
 		y1_tmp = y1 + h - 1;
 		y2_tmp = y2 + h - 1;
-  	} else {
+	} else {
 		y1_tmp = y1;
 		y2_tmp = y2;
 	}
 
-	writemmr(0x2128,direction);	
-	t_outb(ROP_S,0x2127);
-	writemmr(0x213C,masked_point(y1_tmp,x1_tmp));
-	writemmr(0x2138,masked_point(y2_tmp,x2_tmp));
-	writemmr(0x2140,masked_point(h,w));
-	t_outb(0x01,0x2124);
+	writemmr(0x2128, direction);
+	t_outb(ROP_S, 0x2127);
+	writemmr(0x213C, masked_point(y1_tmp, x1_tmp));
+	writemmr(0x2138, masked_point(y2_tmp, x2_tmp));
+	writemmr(0x2140, masked_point(h, w));
+	t_outb(0x01, 0x2124);
 }
 
 static struct accel_switch accel_xp = {
-  	xp_init_accel,
+	xp_init_accel,
 	xp_wait_engine,
 	xp_fill_rect,
 	xp_copy_rect,
 };
 
-
 /*
  * Image specific acceleration functions
  */
-static void image_init_accel(int pitch,int bpp)
+static void image_init_accel(int pitch, int bpp)
 {
 	int tmp = 0;
-   	switch (bpp) {
-		case 8:tmp = 0;break;
-		case 15:tmp = 5;break;
-		case 16:tmp = 1;break;
-		case 24:
-		case 32:tmp = 2;break;
+	switch (bpp) {
+	case 8:
+		tmp = 0;
+		break;
+	case 15:
+		tmp = 5;
+		break;
+	case 16:
+		tmp = 1;
+		break;
+	case 24:
+	case 32:
+		tmp = 2;
+		break;
 	}
 	writemmr(0x2120, 0xF0000000);
-	writemmr(0x2120, 0x40000000|tmp);
+	writemmr(0x2120, 0x40000000 | tmp);
 	writemmr(0x2120, 0x80000000);
 	writemmr(0x2144, 0x00000000);
 	writemmr(0x2148, 0x00000000);
 	writemmr(0x2150, 0x00000000);
 	writemmr(0x2154, 0x00000000);
-	writemmr(0x2120, 0x60000000|(pitch<<16) |pitch);
+	writemmr(0x2120, 0x60000000 | (pitch << 16) | pitch);
 	writemmr(0x216C, 0x00000000);
 	writemmr(0x2170, 0x00000000);
 	writemmr(0x217C, 0x00000000);
@@ -400,44 +430,43 @@ static void image_init_accel(int pitch,i
 
 static void image_wait_engine(void)
 {
-	while(readmmr(0x2164) & 0xF0000000);
+	while (readmmr(0x2164) & 0xF0000000) ;
 }
 
-static void image_fill_rect(__u32 x, __u32 y, __u32 w, __u32 h, __u32 c, __u32 rop)
+static void image_fill_rect(u32 x, u32 y, u32 w, u32 h, u32 c, u32 rop)
 {
-	writemmr(0x2120,0x80000000);
-	writemmr(0x2120,0x90000000|ROP_S);
+	writemmr(0x2120, 0x80000000);
+	writemmr(0x2120, 0x90000000 | ROP_S);
 
-	writemmr(0x2144,c);
+	writemmr(0x2144, c);
 
-	writemmr(DR1,point(x,y));
-	writemmr(DR2,point(x+w-1,y+h-1));
+	writemmr(DR1, point(x, y));
+	writemmr(DR2, point(x + w - 1, y + h - 1));
 
-	writemmr(0x2124,0x80000000|3<<22|1<<10|1<<9);
+	writemmr(0x2124, 0x80000000 | 3 << 22 | 1 << 10 | 1 << 9);
 }
 
-static void image_copy_rect(__u32 x1,__u32 y1,__u32 x2,__u32 y2,__u32 w,__u32 h)
+static void image_copy_rect(u32 x1, u32 y1, u32 x2, u32 y2, u32 w, u32 h)
 {
-	__u32 s1,s2,d1,d2;
+	u32 s1, s2, d1, d2;
 	int direction = 2;
-	s1 = point(x1,y1);
-	s2 = point(x1+w-1,y1+h-1);
-	d1 = point(x2,y2);
-	d2 = point(x2+w-1,y2+h-1);
-
-	if ((y1 > y2) || ((y1 == y2) && (x1 >x2)))
-			direction = 0;
-
-	writemmr(0x2120,0x80000000);
-	writemmr(0x2120,0x90000000|ROP_S);
-
-	writemmr(SR1,direction?s2:s1);
-	writemmr(SR2,direction?s1:s2);
-	writemmr(DR1,direction?d2:d1);
-	writemmr(DR2,direction?d1:d2);
-	writemmr(0x2124,0x80000000|1<<22|1<<10|1<<7|direction);
-}
+	s1 = point(x1, y1);
+	s2 = point(x1 + w - 1, y1 + h - 1);
+	d1 = point(x2, y2);
+	d2 = point(x2 + w - 1, y2 + h - 1);
 
+	if ((y1 > y2) || ((y1 == y2) && (x1 > x2)))
+		direction = 0;
+
+	writemmr(0x2120, 0x80000000);
+	writemmr(0x2120, 0x90000000 | ROP_S);
+
+	writemmr(SR1, direction ? s2 : s1);
+	writemmr(SR2, direction ? s1 : s2);
+	writemmr(DR1, direction ? d2 : d1);
+	writemmr(DR2, direction ? d1 : d2);
+	writemmr(0x2124, 0x80000000 | 1 << 22 | 1 << 10 | 1 << 7 | direction);
+}
 
 static struct accel_switch accel_image = {
 	image_init_accel,
@@ -450,30 +479,34 @@ static struct accel_switch accel_image =
  * Accel functions called by the upper layers
  */
 #ifdef CONFIG_FB_TRIDENT_ACCEL
-static void tridentfb_fillrect(struct fb_info * info, const struct fb_fillrect *fr)
+static void tridentfb_fillrect(struct fb_info *info,
+			       const struct fb_fillrect *fr)
 {
 	int bpp = info->var.bits_per_pixel;
 	int col = 0;
-	
+
 	switch (bpp) {
-		default:
-		case 8: col |= fr->color;
-			col |= col << 8;
-			col |= col << 16;
-			break;
-		case 16: col = ((u32 *)(info->pseudo_palette))[fr->color];
-			
-			 break;
-		case 32: col = ((u32 *)(info->pseudo_palette))[fr->color];
-			 break;
-	}		 
-			
+	default:
+	case 8:
+		col |= fr->color;
+		col |= col << 8;
+		col |= col << 16;
+		break;
+	case 16:
+		col = ((u32 *)(info->pseudo_palette))[fr->color];
+		break;
+	case 32:
+		col = ((u32 *)(info->pseudo_palette))[fr->color];
+		break;
+	}
+
 	acc->fill_rect(fr->dx, fr->dy, fr->width, fr->height, col, fr->rop);
 	acc->wait_engine();
 }
-static void tridentfb_copyarea(struct fb_info *info, const struct fb_copyarea *ca)
+static void tridentfb_copyarea(struct fb_info *info,
+			       const struct fb_copyarea *ca)
 {
-	acc->copy_rect(ca->sx,ca->sy,ca->dx,ca->dy,ca->width,ca->height);
+	acc->copy_rect(ca->sx, ca->sy, ca->dx, ca->dy, ca->width, ca->height);
 	acc->wait_engine();
 }
 #else /* !CONFIG_FB_TRIDENT_ACCEL */
@@ -488,14 +521,14 @@ static void tridentfb_copyarea(struct fb
 
 static inline unsigned char read3X4(int reg)
 {
-	struct tridentfb_par * par = (struct tridentfb_par *)fb_info.par;
+	struct tridentfb_par *par = (struct tridentfb_par *)fb_info.par;
 	writeb(reg, par->io_virt + CRT + 4);
-	return readb( par->io_virt + CRT + 5);
+	return readb(par->io_virt + CRT + 5);
 }
 
 static inline void write3X4(int reg, unsigned char val)
 {
-	struct tridentfb_par * par = (struct tridentfb_par *)fb_info.par;
+	struct tridentfb_par *par = (struct tridentfb_par *)fb_info.par;
 	writeb(reg, par->io_virt + CRT + 4);
 	writeb(val, par->io_virt + CRT + 5);
 }
@@ -520,7 +553,7 @@ static inline unsigned char read3CE(int 
 
 static inline void writeAttr(int reg, unsigned char val)
 {
-	readb(((struct tridentfb_par *)fb_info.par)->io_virt + CRT + 0x0A);	//flip-flop to index
+	readb(((struct tridentfb_par *)fb_info.par)->io_virt + CRT + 0x0A);	/* flip-flop to index */
 	t_outb(reg, 0x3C0);
 	t_outb(val, 0x3C0);
 }
@@ -540,32 +573,41 @@ static inline void enable_mmio(void)
 	/* Unprotect registers */
 	outb(NewMode1, 0x3C4);
 	outb(0x80, 0x3C5);
-  
+
 	/* Enable MMIO */
-	outb(PCIReg, 0x3D4); 
+	outb(PCIReg, 0x3D4);
 	outb(inb(0x3D5) | 0x01, 0x3D5);
 }
 
-
 #define crtc_unlock()	write3X4(CRTVSyncEnd, read3X4(CRTVSyncEnd) & 0x7F)
 
 /*  Return flat panel's maximum x resolution */
 static int __devinit get_nativex(void)
 {
-	int x,y,tmp;
+	int x, y, tmp;
 
 	if (nativex)
 		return nativex;
 
-       	tmp = (read3CE(VertStretch) >> 4) & 3;
+	tmp = (read3CE(VertStretch) >> 4) & 3;
 
 	switch (tmp) {
-		case 0: x = 1280; y = 1024; break;
-		case 2: x = 1024; y = 768;  break;
-		case 3: x = 800;  y = 600;  break; 
-		case 4: x = 1400; y = 1050; break;
-		case 1: 
-		default:x = 640;  y = 480;  break;
+	case 0:
+		x = 1280; y = 1024;
+		break;
+	case 2:
+		x = 1024; y = 768;
+		break;
+	case 3:
+		x = 800; y = 600;
+		break;
+	case 4:
+		x = 1400; y = 1050;
+		break;
+	case 1:
+	default:
+		x = 640;  y = 480;
+		break;
 	}
 
 	output("%dx%d flat panel found\n", x, y);
@@ -576,25 +618,26 @@ static int __devinit get_nativex(void)
 static void set_lwidth(int width)
 {
 	write3X4(Offset, width & 0xFF);
-	write3X4(AddColReg, (read3X4(AddColReg) & 0xCF) | ((width & 0x300) >>4));
+	write3X4(AddColReg,
+		 (read3X4(AddColReg) & 0xCF) | ((width & 0x300) >> 4));
 }
 
 /* For resolutions smaller than FP resolution stretch */
 static void screen_stretch(void)
 {
-  	if (chip_id != CYBERBLADEXPAi1)
-  		write3CE(BiosReg,0);
-  	else
-  		write3CE(BiosReg,8);
-	write3CE(VertStretch,(read3CE(VertStretch) & 0x7C) | 1);
-	write3CE(HorStretch,(read3CE(HorStretch) & 0x7C) | 1);
+	if (chip_id != CYBERBLADEXPAi1)
+		write3CE(BiosReg, 0);
+	else
+		write3CE(BiosReg, 8);
+	write3CE(VertStretch, (read3CE(VertStretch) & 0x7C) | 1);
+	write3CE(HorStretch, (read3CE(HorStretch) & 0x7C) | 1);
 }
 
 /* For resolutions smaller than FP resolution center */
 static void screen_center(void)
 {
-	write3CE(VertStretch,(read3CE(VertStretch) & 0x7C) | 0x80);
-	write3CE(HorStretch,(read3CE(HorStretch) & 0x7C) | 0x80);
+	write3CE(VertStretch, (read3CE(VertStretch) & 0x7C) | 0x80);
+	write3CE(HorStretch, (read3CE(HorStretch) & 0x7C) | 0x80);
 }
 
 /* Address of first shown pixel in display memory */
@@ -602,40 +645,42 @@ static void set_screen_start(int base)
 {
 	write3X4(StartAddrLow, base & 0xFF);
 	write3X4(StartAddrHigh, (base & 0xFF00) >> 8);
-	write3X4(CRTCModuleTest, (read3X4(CRTCModuleTest) & 0xDF) | ((base & 0x10000) >> 11));
-	write3X4(CRTHiOrd, (read3X4(CRTHiOrd) & 0xF8) | ((base & 0xE0000) >> 17));
+	write3X4(CRTCModuleTest,
+		 (read3X4(CRTCModuleTest) & 0xDF) | ((base & 0x10000) >> 11));
+	write3X4(CRTHiOrd,
+		 (read3X4(CRTHiOrd) & 0xF8) | ((base & 0xE0000) >> 17));
 }
 
 /* Use 20.12 fixed-point for NTSC value and frequency calculation */
-#define calc_freq(n,m,k)  ( ((unsigned long)0xE517 * (n+8) / ((m+2)*(1<<k))) >> 12 )
+#define calc_freq(n, m, k)  ( ((unsigned long)0xE517 * (n + 8) / ((m + 2) * (1 << k))) >> 12 )
 
 /* Set dotclock frequency */
 static void set_vclk(int freq)
 {
-	int m,n,k;
-	int f,fi,d,di;
-	unsigned char lo=0,hi=0;
+	int m, n, k;
+	int f, fi, d, di;
+	unsigned char lo = 0, hi = 0;
 
 	d = 20;
-	for(k = 2;k>=0;k--)
-	for(m = 0;m<63;m++)
-	for(n = 0;n<128;n++) {
-		fi = calc_freq(n,m,k);
-		if ((di = abs(fi - freq)) < d) {
-			d = di;
-			f = fi;
-			lo = n;
-			hi = (k<<6) | m;
-		}
-	}
+	for (k = 2; k >= 0; k--)
+		for (m = 0; m < 63; m++)
+			for (n = 0; n < 128; n++) {
+				fi = calc_freq(n, m, k);
+				if ((di = abs(fi - freq)) < d) {
+					d = di;
+					f = fi;
+					lo = n;
+					hi = (k << 6) | m;
+				}
+			}
 	if (chip3D) {
-		write3C4(ClockHigh,hi);
-		write3C4(ClockLow,lo);
+		write3C4(ClockHigh, hi);
+		write3C4(ClockLow, lo);
 	} else {
-		outb(lo,0x43C8);
-		outb(hi,0x43C9);
+		outb(lo, 0x43C8);
+		outb(hi, 0x43C9);
 	}
-	debug("VCLK = %X %X\n",hi,lo);
+	debug("VCLK = %X %X\n", hi, lo);
 }
 
 /* Set number of lines for flat panels*/
@@ -663,7 +708,7 @@ static unsigned int __devinit get_displa
 		return DISPLAY_FP;
 	if (crt || !chipcyber)
 		return DISPLAY_CRT;
-	return (read3CE(FPConfig) & 0x10)?DISPLAY_FP:DISPLAY_CRT;
+	return (read3CE(FPConfig) & 0x10) ? DISPLAY_FP : DISPLAY_CRT;
 }
 
 /* Try detecting the video memory size */
@@ -676,100 +721,136 @@ static unsigned int __devinit get_memsiz
 	if (memsize)
 		k = memsize * Kb;
 	else
-	switch (chip_id) {
-		case CYBER9525DVD:    k = 2560 * Kb; break;
+		switch (chip_id) {
+		case CYBER9525DVD:
+			k = 2560 * Kb;
+			break;
 		default:
 			tmp = read3X4(SPR) & 0x0F;
 			switch (tmp) {
 
-				case 0x01: k = 512;     break;
-				case 0x02: k = 6 * Mb;  break; /* XP */
-				case 0x03: k = 1 * Mb;  break;
-				case 0x04: k = 8 * Mb;  break;
-				case 0x06: k = 10 * Mb; break; /* XP */
-				case 0x07: k = 2 * Mb;  break;
-				case 0x08: k = 12 * Mb; break; /* XP */
-				case 0x0A: k = 14 * Mb; break; /* XP */
-				case 0x0C: k = 16 * Mb; break; /* XP */
-				case 0x0E:                     /* XP */
-  
-					tmp2 = read3C4(0xC1);
-					switch (tmp2) {
-						case 0x00: k = 20 * Mb; break;
-						case 0x01: k = 24 * Mb; break;
-						case 0x10: k = 28 * Mb; break;
-						case 0x11: k = 32 * Mb; break;
-						default:   k = 1 * Mb;  break;
-					}
+			case 0x01:
+				k = 512;
+				break;
+			case 0x02:
+				k = 6 * Mb;	/* XP */
+				break;
+			case 0x03:
+				k = 1 * Mb;
+				break;
+			case 0x04:
+				k = 8 * Mb;
+				break;
+			case 0x06:
+				k = 10 * Mb;	/* XP */
+				break;
+			case 0x07:
+				k = 2 * Mb;
+				break;
+			case 0x08:
+				k = 12 * Mb;	/* XP */
+				break;
+			case 0x0A:
+				k = 14 * Mb;	/* XP */
+				break;
+			case 0x0C:
+				k = 16 * Mb;	/* XP */
+				break;
+			case 0x0E:		/* XP */
+
+				tmp2 = read3C4(0xC1);
+				switch (tmp2) {
+				case 0x00:
+					k = 20 * Mb;
+					break;
+				case 0x01:
+					k = 24 * Mb;
+					break;
+				case 0x10:
+					k = 28 * Mb;
+					break;
+				case 0x11:
+					k = 32 * Mb;
+					break;
+				default:
+					k = 1 * Mb;
+					break;
+				}
+				break;
+
+			case 0x0F:
+				k = 4 * Mb;
+				break;
+			default:
+				k = 1 * Mb;
 				break;
-	
-				case 0x0F: k = 4 * Mb; break;
-				default:   k = 1 * Mb;
 			}
-	}
+		}
 
 	k -= memdiff * Kb;
-	output("framebuffer size = %d Kb\n", k/Kb);
+	output("framebuffer size = %d Kb\n", k / Kb);
 	return k;
 }
 
 /* See if we can handle the video mode described in var */
-static int tridentfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
+static int tridentfb_check_var(struct fb_var_screeninfo *var,
+			       struct fb_info *info)
 {
 	int bpp = var->bits_per_pixel;
 	debug("enter\n");
 
 	/* check color depth */
-	if (bpp == 24 )
+	if (bpp == 24)
 		bpp = var->bits_per_pixel = 32;
-	/* check whether resolution fits on panel and in memory*/
+	/* check whether resolution fits on panel and in memory */
 	if (flatpanel && nativex && var->xres > nativex)
 		return -EINVAL;
-	if (var->xres * var->yres_virtual * bpp/8 > info->fix.smem_len)
+	if (var->xres * var->yres_virtual * bpp / 8 > info->fix.smem_len)
 		return -EINVAL;
 
 	switch (bpp) {
-		case 8:
-			var->red.offset = 0;
-			var->green.offset = 0;
-			var->blue.offset = 0;
-			var->red.length = 6;
-			var->green.length = 6;
-			var->blue.length = 6;
-			break;
-		case 16:
-			var->red.offset = 11;
-			var->green.offset = 5;
-			var->blue.offset = 0;
-			var->red.length = 5;
-			var->green.length = 6;
-			var->blue.length = 5;
-			break;
-		case 32:
-			var->red.offset = 16;
-			var->green.offset = 8;
-			var->blue.offset = 0;
-			var->red.length = 8;
-			var->green.length = 8;
-			var->blue.length = 8;
-			break;
-		default:
-			return -EINVAL;	
+	case 8:
+		var->red.offset = 0;
+		var->green.offset = 0;
+		var->blue.offset = 0;
+		var->red.length = 6;
+		var->green.length = 6;
+		var->blue.length = 6;
+		break;
+	case 16:
+		var->red.offset = 11;
+		var->green.offset = 5;
+		var->blue.offset = 0;
+		var->red.length = 5;
+		var->green.length = 6;
+		var->blue.length = 5;
+		break;
+	case 32:
+		var->red.offset = 16;
+		var->green.offset = 8;
+		var->blue.offset = 0;
+		var->red.length = 8;
+		var->green.length = 8;
+		var->blue.length = 8;
+		break;
+	default:
+		return -EINVAL;
 	}
 	debug("exit\n");
 
 	return 0;
 
 }
+
 /* Pan the display */
 static int tridentfb_pan_display(struct fb_var_screeninfo *var,
-				   struct fb_info *info)
+				 struct fb_info *info)
 {
 	unsigned int offset;
 
 	debug("enter\n");
 	offset = (var->xoffset + (var->yoffset * var->xres))
-			* var->bits_per_pixel/32;
+		* var->bits_per_pixel / 32;
 	info->var.xoffset = var->xoffset;
 	info->var.yoffset = var->yoffset;
 	set_screen_start(offset);
@@ -777,36 +858,38 @@ static int tridentfb_pan_display(struct 
 	return 0;
 }
 
-#define shadowmode_on()  write3CE(CyberControl,read3CE(CyberControl) | 0x81)
-#define shadowmode_off() write3CE(CyberControl,read3CE(CyberControl) & 0x7E)
+#define shadowmode_on()  write3CE(CyberControl, read3CE(CyberControl) | 0x81)
+#define shadowmode_off() write3CE(CyberControl, read3CE(CyberControl) & 0x7E)
 
 /* Set the hardware to the requested video mode */
 static int tridentfb_set_par(struct fb_info *info)
 {
-	struct tridentfb_par * par = (struct tridentfb_par *)(info->par);
-	u32	htotal,hdispend,hsyncstart,hsyncend,hblankstart,hblankend,
-		vtotal,vdispend,vsyncstart,vsyncend,vblankstart,vblankend;
-	struct fb_var_screeninfo *var = &info->var;	
+	struct tridentfb_par *par = (struct tridentfb_par *)(info->par);
+	u32 htotal, hdispend, hsyncstart, hsyncend, hblankstart, hblankend;
+	u32 vtotal, vdispend, vsyncstart, vsyncend, vblankstart, vblankend;
+	struct fb_var_screeninfo *var = &info->var;
 	int bpp = var->bits_per_pixel;
 	unsigned char tmp;
 	debug("enter\n");
-	htotal = (var->xres + var->left_margin + var->right_margin + var->hsync_len)/8 - 10;
-	hdispend = var->xres/8 - 1;
-	hsyncstart = (var->xres + var->right_margin)/8;
-	hsyncend = var->hsync_len/8;
+	hdispend = var->xres / 8 - 1;
+	hsyncstart = (var->xres + var->right_margin) / 8;
+	hsyncend = var->hsync_len / 8;
+	htotal =
+		(var->xres + var->left_margin + var->right_margin +
+		 var->hsync_len) / 8 - 10;
 	hblankstart = hdispend + 1;
 	hblankend = htotal + 5;
 
-	vtotal = var->yres + var->upper_margin + var->lower_margin + var->vsync_len - 2;
 	vdispend = var->yres - 1;
 	vsyncstart = var->yres + var->lower_margin;
 	vsyncend = var->vsync_len;
+	vtotal = var->upper_margin + vsyncstart + vsyncend - 2;
 	vblankstart = var->yres;
 	vblankend = vtotal + 2;
 
 	enable_mmio();
 	crtc_unlock();
-	write3CE(CyberControl,8);
+	write3CE(CyberControl, 8);
 
 	if (flatpanel && var->xres < nativex) {
 		/*
@@ -814,18 +897,18 @@ static int tridentfb_set_par(struct fb_i
 		 * than requested resolution decide whether
 		 * we stretch or center
 		 */
-		t_outb(0xEB,0x3C2);
+		t_outb(0xEB, 0x3C2);
 
 		shadowmode_on();
 
-		if (center) 
+		if (center)
 			screen_center();
 		else if (stretch)
 			screen_stretch();
 
 	} else {
-		t_outb(0x2B,0x3C2);
-		write3CE(CyberControl,8);
+		t_outb(0x2B, 0x3C2);
+		write3CE(CyberControl, 8);
 	}
 
 	/* vertical timing values */
@@ -834,15 +917,15 @@ static int tridentfb_set_par(struct fb_i
 	write3X4(CRTVSyncStart, vsyncstart & 0xFF);
 	write3X4(CRTVSyncEnd, (vsyncend & 0x0F));
 	write3X4(CRTVBlankStart, vblankstart & 0xFF);
-	write3X4(CRTVBlankEnd, 0/*p->vblankend & 0xFF*/);
+	write3X4(CRTVBlankEnd, 0 /* p->vblankend & 0xFF */ );
 
 	/* horizontal timing values */
 	write3X4(CRTHTotal, htotal & 0xFF);
 	write3X4(CRTHDispEnd, hdispend & 0xFF);
 	write3X4(CRTHSyncStart, hsyncstart & 0xFF);
-	write3X4(CRTHSyncEnd, (hsyncend & 0x1F) | ((hblankend & 0x20)<<2));
+	write3X4(CRTHSyncEnd, (hsyncend & 0x1F) | ((hblankend & 0x20) << 2));
 	write3X4(CRTHBlankStart, hblankstart & 0xFF);
-	write3X4(CRTHBlankEnd, 0/*(p->hblankend & 0x1F)*/);
+	write3X4(CRTHBlankEnd, 0 /* (p->hblankend & 0x1F) */ );
 
 	/* higher bits of vertical timing values */
 	tmp = 0x10;
@@ -856,7 +939,7 @@ static int tridentfb_set_par(struct fb_i
 	if (vsyncstart & 0x200) tmp |= 0x80;
 	write3X4(CRTOverflow, tmp);
 
-	tmp = read3X4(CRTHiOrd) | 0x08;	//line compare bit 10
+	tmp = read3X4(CRTHiOrd) | 0x08;	/* line compare bit 10 */
 	if (vtotal & 0x400) tmp |= 0x80;
 	if (vblankstart & 0x400) tmp |= 0x40;
 	if (vsyncstart & 0x400) tmp |= 0x20;
@@ -867,84 +950,100 @@ static int tridentfb_set_par(struct fb_i
 	if (htotal & 0x800) tmp |= 0x800 >> 11;
 	if (hblankstart & 0x800) tmp |= 0x800 >> 7;
 	write3X4(HorizOverflow, tmp);
-	
+
 	tmp = 0x40;
 	if (vblankstart & 0x200) tmp |= 0x20;
-//FIXME	if (info->var.vmode & FB_VMODE_DOUBLE) tmp |= 0x80;  //double scan for 200 line modes
+//FIXME	if (info->var.vmode & FB_VMODE_DOUBLE) tmp |= 0x80;  /* double scan for 200 line modes */
 	write3X4(CRTMaxScanLine, tmp);
 
-	write3X4(CRTLineCompare,0xFF);
-	write3X4(CRTPRowScan,0);
-	write3X4(CRTModeControl,0xC3);
+	write3X4(CRTLineCompare, 0xFF);
+	write3X4(CRTPRowScan, 0);
+	write3X4(CRTModeControl, 0xC3);
 
-	write3X4(LinearAddReg,0x20);	//enable linear addressing
+	write3X4(LinearAddReg, 0x20);	/* enable linear addressing */
 
-	tmp = (info->var.vmode & FB_VMODE_INTERLACED) ? 0x84:0x80;
-	write3X4(CRTCModuleTest,tmp);	//enable access extended memory
+	tmp = (info->var.vmode & FB_VMODE_INTERLACED) ? 0x84 : 0x80;
+	write3X4(CRTCModuleTest, tmp);	/* enable access extended memory */
 
-	write3X4(GraphEngReg, 0x80);	//enable GE for text acceleration
+	write3X4(GraphEngReg, 0x80);	/* enable GE for text acceleration */
 
-#ifdef CONFIG_FB_TRIDENT_ACCEL	
-	acc->init_accel(info->var.xres,bpp);
+#ifdef CONFIG_FB_TRIDENT_ACCEL
+	acc->init_accel(info->var.xres, bpp);
 #endif
-	
+
 	switch (bpp) {
-		case 8:  tmp = 0x00; break;
-		case 16: tmp = 0x05; break;
-		case 24: tmp = 0x29; break;
-		case 32: tmp = 0x09; 
+	case 8:
+		tmp = 0x00;
+		break;
+	case 16:
+		tmp = 0x05;
+		break;
+	case 24:
+		tmp = 0x29;
+		break;
+	case 32:
+		tmp = 0x09;
+		break;
 	}
 
 	write3X4(PixelBusReg, tmp);
 
 	tmp = 0x10;
 	if (chipcyber)
-	    tmp |= 0x20;
-	write3X4(DRAMControl, tmp);	//both IO,linear enable
+		tmp |= 0x20;
+	write3X4(DRAMControl, tmp);	/* both IO, linear enable */
 
 	write3X4(InterfaceSel, read3X4(InterfaceSel) | 0x40);
-	write3X4(Performance,0x92);
-	write3X4(PCIReg,0x07);		//MMIO & PCI read and write burst enable
+	write3X4(Performance, 0x92);
+	write3X4(PCIReg, 0x07);		/* MMIO & PCI read and write burst enable */
 
 	/* convert from picoseconds to MHz */
-	par->vclk = 1000000/info->var.pixclock;
+	par->vclk = 1000000 / info->var.pixclock;
 	if (bpp == 32)
-		par->vclk *=2;
+		par->vclk *= 2;
 	set_vclk(par->vclk);
 
-	write3C4(0,3);
-	write3C4(1,1);		//set char clock 8 dots wide
-	write3C4(2,0x0F);	//enable 4 maps because needed in chain4 mode
-	write3C4(3,0);
-	write3C4(4,0x0E);	//memory mode enable bitmaps ??
-
-	write3CE(MiscExtFunc,(bpp==32)?0x1A:0x12);	//divide clock by 2 if 32bpp
-							//chain4 mode display and CPU path
-	write3CE(0x5,0x40);	//no CGA compat,allow 256 col
-	write3CE(0x6,0x05);	//graphics mode
-	write3CE(0x7,0x0F);	//planes?
+	write3C4(0, 3);
+	write3C4(1, 1);		/* set char clock 8 dots wide */
+	write3C4(2, 0x0F);	/* enable 4 maps because needed in chain4 mode */
+	write3C4(3, 0);
+	write3C4(4, 0x0E);	/* memory mode enable bitmaps ?? */
+
+	write3CE(MiscExtFunc, (bpp == 32) ? 0x1A : 0x12);	/* divide clock by 2 if 32bpp */
+							/* chain4 mode display and CPU path */
+	write3CE(0x5, 0x40);	/* no CGA compat, allow 256 col */
+	write3CE(0x6, 0x05);	/* graphics mode */
+	write3CE(0x7, 0x0F);	/* planes? */
 
 	if (chip_id == CYBERBLADEXPAi1) {
 		/* This fixes snow-effect in 32 bpp */
-		write3X4(CRTHSyncStart,0x84);
+		write3X4(CRTHSyncStart, 0x84);
 	}
 
-	writeAttr(0x10,0x41);	//graphics mode and support 256 color modes
-	writeAttr(0x12,0x0F);	//planes
-	writeAttr(0x13,0);	//horizontal pel panning
-
-	//colors
-	for(tmp = 0;tmp < 0x10;tmp++)
-		writeAttr(tmp,tmp);
-	readb(par->io_virt + CRT + 0x0A);	//flip-flop to index
-	t_outb(0x20, 0x3C0);			//enable attr
+	writeAttr(0x10, 0x41);	/* graphics mode and support 256 color modes */
+	writeAttr(0x12, 0x0F);	/* planes */
+	writeAttr(0x13, 0);	/* horizontal pel panning */
+
+	/* colors */
+	for (tmp = 0; tmp < 0x10; tmp++)
+		writeAttr(tmp, tmp);
+	readb(par->io_virt + CRT + 0x0A);	/* flip-flop to index */
+	t_outb(0x20, 0x3C0);			/* enable attr */
 
 	switch (bpp) {
-		case 8:	tmp = 0;break;		//256 colors
-		case 15: tmp = 0x10;break;
-		case 16: tmp = 0x30;break;	//hicolor
-		case 24: 			//truecolor
-		case 32: tmp = 0xD0;break;
+	case 8:
+		tmp = 0;
+		break;
+	case 15:
+		tmp = 0x10;
+		break;
+	case 16:
+		tmp = 0x30;
+		break;
+	case 24:
+	case 32:
+		tmp = 0xD0;
+		break;
 	}
 
 	t_inb(0x3C8);
@@ -952,37 +1051,36 @@ static int tridentfb_set_par(struct fb_i
 	t_inb(0x3C6);
 	t_inb(0x3C6);
 	t_inb(0x3C6);
-	t_outb(tmp,0x3C6);
+	t_outb(tmp, 0x3C6);
 	t_inb(0x3C8);
 
 	if (flatpanel)
 		set_number_of_lines(info->var.yres);
-	set_lwidth(info->var.xres * bpp/(4*16));
+	set_lwidth(info->var.xres * bpp / (4 * 16));
 	info->fix.visual = (bpp == 8) ? FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
-	info->fix.line_length = info->var.xres * (bpp >> 3);  
-	info->cmap.len = (bpp == 8) ? 256: 16;
+	info->fix.line_length = info->var.xres * (bpp >> 3);
+	info->cmap.len = (bpp == 8) ? 256 : 16;
 	debug("exit\n");
 	return 0;
 }
 
 /* Set one color register */
 static int tridentfb_setcolreg(unsigned regno, unsigned red, unsigned green,
-				 unsigned blue, unsigned transp,
-				 struct fb_info *info)
+			       unsigned blue, unsigned transp,
+			       struct fb_info *info)
 {
 	int bpp = info->var.bits_per_pixel;
 
 	if (regno >= info->cmap.len)
 		return 1;
 
-
 	if (bpp == 8) {
-		t_outb(0xFF,0x3C6);
-		t_outb(regno,0x3C8);
+		t_outb(0xFF, 0x3C6);
+		t_outb(regno, 0x3C8);
 
-		t_outb(red>>10,0x3C9);
-		t_outb(green>>10,0x3C9);
-		t_outb(blue>>10,0x3C9);
+		t_outb(red >> 10, 0x3C9);
+		t_outb(green >> 10, 0x3C9);
+		t_outb(blue >> 10, 0x3C9);
 
 	} else if (regno < 16) {
 		if (bpp == 16) {	/* RGB 565 */
@@ -994,29 +1092,28 @@ static int tridentfb_setcolreg(unsigned 
 			((u32 *)(info->pseudo_palette))[regno] = col;
 		} else if (bpp == 32)		/* ARGB 8888 */
 			((u32*)info->pseudo_palette)[regno] =
-				((transp & 0xFF00) <<16) 	|
-				((red & 0xFF00) << 8) 		|
+				((transp & 0xFF00) << 16)	|
+				((red & 0xFF00) << 8)		|
 				((green & 0xFF00))		|
-				((blue & 0xFF00)>>8);
+				((blue & 0xFF00) >> 8);
 	}
 
-//	debug("exit\n");
+/* 	debug("exit\n"); */
 	return 0;
 }
 
 /* Try blanking the screen.For flat panels it does nothing */
 static int tridentfb_blank(int blank_mode, struct fb_info *info)
 {
-	unsigned char PMCont,DPMSCont;
+	unsigned char PMCont, DPMSCont;
 
 	debug("enter\n");
 	if (flatpanel)
 		return 0;
-	t_outb(0x04,0x83C8); /* Read DPMS Control */
+	t_outb(0x04, 0x83C8); /* Read DPMS Control */
 	PMCont = t_inb(0x83C6) & 0xFC;
 	DPMSCont = read3CE(PowerStatus) & 0xFC;
-	switch (blank_mode)
-	{
+	switch (blank_mode) {
 	case FB_BLANK_UNBLANK:
 		/* Screen: On, HSync: On, VSync: On */
 	case FB_BLANK_NORMAL:
@@ -1039,11 +1136,11 @@ static int tridentfb_blank(int blank_mod
 		PMCont |= 0x00;
 		DPMSCont |= 0x03;
 		break;
-    	}
+	}
 
-	write3CE(PowerStatus,DPMSCont);
-	t_outb(4,0x83C8);
-	t_outb(PMCont,0x83C6);
+	write3CE(PowerStatus, DPMSCont);
+	t_outb(4, 0x83C8);
+	t_outb(PMCont, 0x83C6);
 
 	debug("exit\n");
 
@@ -1051,7 +1148,20 @@ static int tridentfb_blank(int blank_mod
 	return (blank_mode == FB_BLANK_NORMAL) ? 1 : 0;
 }
 
-static int __devinit trident_pci_probe(struct pci_dev * dev, const struct pci_device_id * id)
+static struct fb_ops tridentfb_ops = {
+	.owner = THIS_MODULE,
+	.fb_setcolreg = tridentfb_setcolreg,
+	.fb_pan_display = tridentfb_pan_display,
+	.fb_blank = tridentfb_blank,
+	.fb_check_var = tridentfb_check_var,
+	.fb_set_par = tridentfb_set_par,
+	.fb_fillrect = tridentfb_fillrect,
+	.fb_copyarea = tridentfb_copyarea,
+	.fb_imageblit = cfb_imageblit,
+};
+
+static int __devinit trident_pci_probe(struct pci_dev * dev,
+				       const struct pci_device_id * id)
 {
 	int err;
 	unsigned char revision;
@@ -1062,31 +1172,42 @@ static int __devinit trident_pci_probe(s
 
 	chip_id = id->device;
 
-	if(chip_id == CYBERBLADEi1)
+	if (chip_id == CYBERBLADEi1)
 		output("*** Please do use cyblafb, Cyberblade/i1 support "
 		       "will soon be removed from tridentfb!\n");
 
 
 	/* If PCI id is 0x9660 then further detect chip type */
-	
+
 	if (chip_id == TGUI9660) {
-		outb(RevisionID,0x3C4);
-		revision = inb(0x3C5);	
-	
+		outb(RevisionID, 0x3C4);
+		revision = inb(0x3C5);
+
 		switch (revision) {
-			case 0x22:
-			case 0x23: chip_id = CYBER9397;break;
-			case 0x2A: chip_id = CYBER9397DVD;break;
-			case 0x30:
-			case 0x33:
-			case 0x34:
-			case 0x35:
-			case 0x38:
-			case 0x3A:
-			case 0xB3: chip_id = CYBER9385;break;
-			case 0x40 ... 0x43: chip_id = CYBER9382;break;
-			case 0x4A: chip_id = CYBER9388;break;
-			default:break;	
+		case 0x22:
+		case 0x23:
+			chip_id = CYBER9397;
+			break;
+		case 0x2A:
+			chip_id = CYBER9397DVD;
+			break;
+		case 0x30:
+		case 0x33:
+		case 0x34:
+		case 0x35:
+		case 0x38:
+		case 0x3A:
+		case 0xB3:
+			chip_id = CYBER9385;
+			break;
+		case 0x40 ... 0x43:
+			chip_id = CYBER9382;
+			break;
+		case 0x4A:
+			chip_id = CYBER9388;
+			break;
+		default:
+			break;
 		}
 	}
 
@@ -1095,8 +1216,7 @@ static int __devinit trident_pci_probe(s
 
 	if (is_xp(chip_id)) {
 		acc = &accel_xp;
-	} else 
-	if (is_blade(chip_id)) {
+	} else if (is_blade(chip_id)) {
 		acc = &accel_blade;
 	} else {
 		acc = &accel_image;
@@ -1108,8 +1228,8 @@ static int __devinit trident_pci_probe(s
 	fb_info.par = &default_par;
 
 	/* setup MMIO region */
-	tridentfb_fix.mmio_start = pci_resource_start(dev,1);
-	tridentfb_fix.mmio_len = chip3D ? 0x20000:0x10000;
+	tridentfb_fix.mmio_start = pci_resource_start(dev, 1);
+	tridentfb_fix.mmio_len = chip3D ? 0x20000 : 0x10000;
 
 	if (!request_mem_region(tridentfb_fix.mmio_start, tridentfb_fix.mmio_len, "tridentfb")) {
 		debug("request_region failed!\n");
@@ -1125,11 +1245,11 @@ static int __devinit trident_pci_probe(s
 	}
 
 	enable_mmio();
-	
+
 	/* setup framebuffer memory */
-	tridentfb_fix.smem_start = pci_resource_start(dev,0);
+	tridentfb_fix.smem_start = pci_resource_start(dev, 0);
 	tridentfb_fix.smem_len = get_memsize();
-	
+
 	if (!request_mem_region(tridentfb_fix.smem_start, tridentfb_fix.smem_len, "tridentfb")) {
 		debug("request_mem_region failed!\n");
 		err = -1;
@@ -1137,7 +1257,7 @@ static int __devinit trident_pci_probe(s
 	}
 
 	fb_info.screen_base = ioremap_nocache(tridentfb_fix.smem_start,
-		       			tridentfb_fix.smem_len);
+					      tridentfb_fix.smem_len);
 
 	if (!fb_info.screen_base) {
 		release_mem_region(tridentfb_fix.smem_start, tridentfb_fix.smem_len);
@@ -1147,13 +1267,13 @@ static int __devinit trident_pci_probe(s
 	}
 
 	output("%s board found\n", pci_name(dev));
-#if 0	
-	output("Trident board found : mem = %X,io = %X, mem_v = %X, io_v = %X\n",
+#if 0
+	output("Trident board found : mem = %X, io = %X, mem_v = %X, io_v = %X\n",
 		tridentfb_fix.smem_start, tridentfb_fix.mmio_start, fb_info.screen_base, default_par.io_virt);
 #endif
 	displaytype = get_displaytype();
 
-	if(flatpanel)
+	if (flatpanel)
 		nativex = get_nativex();
 
 	fb_info.fix = tridentfb_fix;
@@ -1166,11 +1286,11 @@ static int __devinit trident_pci_probe(s
 #endif
 	fb_info.pseudo_palette = pseudo_pal;
 
-	if (!fb_find_mode(&default_var,&fb_info,mode,NULL,0,NULL,bpp)) {
+	if (!fb_find_mode(&default_var, &fb_info, mode, NULL, 0, NULL, bpp)) {
 		err = -EINVAL;
 		goto out_unmap;
 	}
-	fb_alloc_cmap(&fb_info.cmap,256,0);
+	fb_alloc_cmap(&fb_info.cmap, 256, 0);
 	if (defaultaccel && acc)
 		default_var.accel_flags |= FB_ACCELF_TEXT;
 	else
@@ -1184,8 +1304,8 @@ static int __devinit trident_pci_probe(s
 		goto out_unmap;
 	}
 	output("fb%d: %s frame buffer device %dx%d-%dbpp\n",
-	   fb_info.node, fb_info.fix.id,default_var.xres,
-	   default_var.yres,default_var.bits_per_pixel);
+	   fb_info.node, fb_info.fix.id, default_var.xres,
+	   default_var.yres, default_var.bits_per_pixel);
 	return 0;
 
 out_unmap:
@@ -1196,7 +1316,7 @@ out_unmap:
 	return err;
 }
 
-static void __devexit trident_pci_remove(struct pci_dev * dev)
+static void __devexit trident_pci_remove(struct pci_dev *dev)
 {
 	struct tridentfb_par *par = (struct tridentfb_par*)fb_info.par;
 	unregister_framebuffer(&fb_info);
@@ -1208,69 +1328,70 @@ static void __devexit trident_pci_remove
 
 /* List of boards that we are trying to support */
 static struct pci_device_id trident_devices[] = {
-	{PCI_VENDOR_ID_TRIDENT,	BLADE3D, PCI_ANY_ID,PCI_ANY_ID,0,0,0},
-	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEi7, PCI_ANY_ID,PCI_ANY_ID,0,0,0},
-	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEi7D, PCI_ANY_ID,PCI_ANY_ID,0,0,0},
-	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEi1, PCI_ANY_ID,PCI_ANY_ID,0,0,0},
-	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEi1D, PCI_ANY_ID,PCI_ANY_ID,0,0,0},
-	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEAi1, PCI_ANY_ID,PCI_ANY_ID,0,0,0},
-	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEAi1D, PCI_ANY_ID,PCI_ANY_ID,0,0,0},
-	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEE4, PCI_ANY_ID,PCI_ANY_ID,0,0,0},
-	{PCI_VENDOR_ID_TRIDENT,	TGUI9660, PCI_ANY_ID,PCI_ANY_ID,0,0,0},
-	{PCI_VENDOR_ID_TRIDENT,	IMAGE975, PCI_ANY_ID,PCI_ANY_ID,0,0,0},
-	{PCI_VENDOR_ID_TRIDENT,	IMAGE985, PCI_ANY_ID,PCI_ANY_ID,0,0,0},
-	{PCI_VENDOR_ID_TRIDENT,	CYBER9320, PCI_ANY_ID,PCI_ANY_ID,0,0,0},
-	{PCI_VENDOR_ID_TRIDENT,	CYBER9388, PCI_ANY_ID,PCI_ANY_ID,0,0,0},
-	{PCI_VENDOR_ID_TRIDENT,	CYBER9520, PCI_ANY_ID,PCI_ANY_ID,0,0,0},
-	{PCI_VENDOR_ID_TRIDENT,	CYBER9525DVD, PCI_ANY_ID,PCI_ANY_ID,0,0,0},
-	{PCI_VENDOR_ID_TRIDENT,	CYBER9397, PCI_ANY_ID,PCI_ANY_ID,0,0,0},
-	{PCI_VENDOR_ID_TRIDENT,	CYBER9397DVD, PCI_ANY_ID,PCI_ANY_ID,0,0,0},
-	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEXPAi1, PCI_ANY_ID,PCI_ANY_ID,0,0,0},
-	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEXPm8, PCI_ANY_ID,PCI_ANY_ID,0,0,0},
-	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEXPm16, PCI_ANY_ID,PCI_ANY_ID,0,0,0},
+	{PCI_VENDOR_ID_TRIDENT,	BLADE3D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEi7, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEi7D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEi1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEi1D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEAi1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEAi1D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEE4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_TRIDENT,	TGUI9660, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_TRIDENT,	IMAGE975, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_TRIDENT,	IMAGE985, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_TRIDENT,	CYBER9320, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_TRIDENT,	CYBER9388, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_TRIDENT,	CYBER9520, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_TRIDENT,	CYBER9525DVD, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_TRIDENT,	CYBER9397, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_TRIDENT,	CYBER9397DVD, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEXPAi1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEXPm8, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEXPm16, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0,}
-};	
-	
-MODULE_DEVICE_TABLE(pci,trident_devices); 
+};
+
+MODULE_DEVICE_TABLE(pci, trident_devices);
 
 static struct pci_driver tridentfb_pci_driver = {
-	.name		= "tridentfb",
-	.id_table	= trident_devices,
-	.probe		= trident_pci_probe,
-	.remove		= __devexit_p(trident_pci_remove)
+	.name = "tridentfb",
+	.id_table = trident_devices,
+	.probe = trident_pci_probe,
+	.remove = __devexit_p(trident_pci_remove)
 };
 
 /*
  * Parse user specified options (`video=trident:')
  * example:
- * 	video=trident:800x600,bpp=16,noaccel
+ *	video=trident:800x600,bpp=16,noaccel
  */
 #ifndef MODULE
 static int tridentfb_setup(char *options)
 {
-	char * opt;
+	char *opt;
 	if (!options || !*options)
 		return 0;
-	while((opt = strsep(&options,",")) != NULL ) {
-		if (!*opt) continue;
-		if (!strncmp(opt,"noaccel",7))
+	while ((opt = strsep(&options, ",")) != NULL) {
+		if (!*opt)
+			continue;
+		if (!strncmp(opt, "noaccel", 7))
 			noaccel = 1;
-		else if (!strncmp(opt,"fp",2))
+		else if (!strncmp(opt, "fp", 2))
 			displaytype = DISPLAY_FP;
-		else if (!strncmp(opt,"crt",3))
+		else if (!strncmp(opt, "crt", 3))
 			displaytype = DISPLAY_CRT;
-		else if (!strncmp(opt,"bpp=",4))
-			bpp = simple_strtoul(opt+4,NULL,0);
-		else if (!strncmp(opt,"center",6))
+		else if (!strncmp(opt, "bpp=", 4))
+			bpp = simple_strtoul(opt + 4, NULL, 0);
+		else if (!strncmp(opt, "center", 6))
 			center = 1;
-		else if (!strncmp(opt,"stretch",7))
+		else if (!strncmp(opt, "stretch", 7))
 			stretch = 1;
-		else if (!strncmp(opt,"memsize=",8))
-			memsize = simple_strtoul(opt+8,NULL,0);
-		else if (!strncmp(opt,"memdiff=",8))
-			memdiff = simple_strtoul(opt+8,NULL,0);
-		else if (!strncmp(opt,"nativex=",8))
-			nativex = simple_strtoul(opt+8,NULL,0);
+		else if (!strncmp(opt, "memsize=", 8))
+			memsize = simple_strtoul(opt + 8, NULL, 0);
+		else if (!strncmp(opt, "memdiff=", 8))
+			memdiff = simple_strtoul(opt + 8, NULL, 0);
+		else if (!strncmp(opt, "nativex=", 8))
+			nativex = simple_strtoul(opt + 8, NULL, 0);
 		else
 			mode = opt;
 	}
@@ -1296,18 +1417,6 @@ static void __exit tridentfb_exit(void)
 	pci_unregister_driver(&tridentfb_pci_driver);
 }
 
-static struct fb_ops tridentfb_ops = {
-	.owner	= THIS_MODULE,
-	.fb_setcolreg = tridentfb_setcolreg,
-	.fb_pan_display = tridentfb_pan_display,
-	.fb_blank = tridentfb_blank,
-	.fb_check_var = tridentfb_check_var,
-	.fb_set_par = tridentfb_set_par,
-	.fb_fillrect = tridentfb_fillrect,
-	.fb_copyarea= tridentfb_copyarea,
-	.fb_imageblit = cfb_imageblit,
-};
-
 module_init(tridentfb_init);
 module_exit(tridentfb_exit);
 
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
