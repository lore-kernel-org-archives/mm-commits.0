From: akpm@osdl.org
Subject: - constify-vga16fbc.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:13:30 -0800
Message-ID: <200612082013.kB8KDUU2003097@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59534 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946756AbWLHUNe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:13:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deller@gmx.de, mm-commits@vger.kernel.org


The patch titled
     constify vga16fb.c
has been removed from the -mm tree.  Its filename was
     constify-vga16fbc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: constify vga16fb.c
From: Helge Deller <deller@gmx.de>

- move some static data into the .rodata section

- simplify source code for transl_l[] and transl_h[] which makes it more
  readable

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/vga16fb.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff -puN drivers/video/vga16fb.c~constify-vga16fbc drivers/video/vga16fb.c
--- a/drivers/video/vga16fb.c~constify-vga16fbc
+++ a/drivers/video/vga16fb.c
@@ -264,7 +264,7 @@ static void vga16fb_clock_chip(struct vg
 			       const struct fb_info *info,
 			       int mul, int div)
 {
-	static struct {
+	static const struct {
 		u32 pixclock;
 		u8  misc;
 		u8  seq_clock_mode;
@@ -652,7 +652,7 @@ static int vga16fb_set_par(struct fb_inf
 
 static void ega16_setpalette(int regno, unsigned red, unsigned green, unsigned blue)
 {
-	static unsigned char map[] = { 000, 001, 010, 011 };
+	static const unsigned char map[] = { 000, 001, 010, 011 };
 	int val;
 	
 	if (regno >= 16)
@@ -1139,23 +1139,19 @@ static void vga16fb_copyarea(struct fb_i
 	}
 }
 
-#ifdef __LITTLE_ENDIAN
-static unsigned int transl_l[] =
-{0x0,0x8,0x4,0xC,0x2,0xA,0x6,0xE,0x1,0x9,0x5,0xD,0x3,0xB,0x7,0xF};
-static unsigned int transl_h[] =
-{0x000, 0x800, 0x400, 0xC00, 0x200, 0xA00, 0x600, 0xE00,
- 0x100, 0x900, 0x500, 0xD00, 0x300, 0xB00, 0x700, 0xF00};
-#else
-#ifdef __BIG_ENDIAN
-static unsigned int transl_h[] =
-{0x0,0x8,0x4,0xC,0x2,0xA,0x6,0xE,0x1,0x9,0x5,0xD,0x3,0xB,0x7,0xF};
-static unsigned int transl_l[] =
-{0x000, 0x800, 0x400, 0xC00, 0x200, 0xA00, 0x600, 0xE00,
- 0x100, 0x900, 0x500, 0xD00, 0x300, 0xB00, 0x700, 0xF00};
+#define TRANS_MASK_LOW  {0x0,0x8,0x4,0xC,0x2,0xA,0x6,0xE,0x1,0x9,0x5,0xD,0x3,0xB,0x7,0xF}
+#define TRANS_MASK_HIGH {0x000, 0x800, 0x400, 0xC00, 0x200, 0xA00, 0x600, 0xE00, \
+			 0x100, 0x900, 0x500, 0xD00, 0x300, 0xB00, 0x700, 0xF00}
+
+#if defined(__LITTLE_ENDIAN)
+static const u16 transl_l[] = TRANS_MASK_LOW;
+static const u16 transl_h[] = TRANS_MASK_HIGH;
+#elif defined(__BIG_ENDIAN)
+static const u16 transl_l[] = TRANS_MASK_HIGH;
+static const u16 transl_h[] = TRANS_MASK_LOW;
 #else
 #error "Only __BIG_ENDIAN and __LITTLE_ENDIAN are supported in vga-planes"
 #endif
-#endif
 
 static void vga_8planes_imageblit(struct fb_info *info, const struct fb_image *image)
 {
_

Patches currently in -mm which might be from deller@gmx.de are

origin.patch
constify-vga16fbc.patch

