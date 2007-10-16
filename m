From: akpm@linux-foundation.org
Subject: - tdfxfb-palette-fixes.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:42:37 -0700
Message-ID: <200710162042.l9GKgbMg015897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39168 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761059AbXJPVHu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     tdfxfb: palette fixes
has been removed from the -mm tree.  Its filename was
     tdfxfb-palette-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tdfxfb: palette fixes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch fixes:
- palette setting in 8-bit mode (aka 'funky penguin')
- grayscale handling
- adds proper barriers in xxx_inb/outb functions

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff -puN drivers/video/tdfxfb.c~tdfxfb-palette-fixes drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-palette-fixes
+++ a/drivers/video/tdfxfb.c
@@ -35,7 +35,6 @@
  * driver by Ilario Nardinocchi, which in turn is based on skeletonfb.
  *
  * TODO:
- * - support for 16/32 bpp needs fixing (funky bootup penguin)
  * - multihead support (basically need to support an array of fb_infos)
  * - support other architectures (PPC, Alpha); does the fact that the VGA
  *   core can be accessed only thru I/O (not memory mapped) complicate
@@ -184,30 +183,38 @@ static inline void vga_outb(struct tdfx_
 static inline void gra_outb(struct tdfx_par *par, u32 idx, u8 val)
 {
 	vga_outb(par, GRA_I, idx);
+	wmb();
 	vga_outb(par, GRA_D, val);
+	wmb();
 }
 
 static inline void seq_outb(struct tdfx_par *par, u32 idx, u8 val)
 {
 	vga_outb(par, SEQ_I, idx);
+	wmb();
 	vga_outb(par, SEQ_D, val);
+	wmb();
 }
 
 static inline u8 seq_inb(struct tdfx_par *par, u32 idx)
 {
 	vga_outb(par, SEQ_I, idx);
+	mb();
 	return vga_inb(par, SEQ_D);
 }
 
 static inline void crt_outb(struct tdfx_par *par, u32 idx, u8 val)
 {
 	vga_outb(par, CRT_I, idx);
+	wmb();
 	vga_outb(par, CRT_D, val);
+	wmb();
 }
 
 static inline u8 crt_inb(struct tdfx_par *par, u32 idx)
 {
 	vga_outb(par, CRT_I, idx);
+	mb();
 	return vga_inb(par, CRT_D);
 }
 
@@ -243,6 +250,7 @@ static inline void vga_enable_video(stru
 static inline void vga_enable_palette(struct tdfx_par *par)
 {
 	vga_inb(par, IS1_R);
+	mb();
 	vga_outb(par, ATT_IW, 0x20);
 }
 
@@ -286,6 +294,8 @@ static inline void do_setpalentry(struct
 {  
 	banshee_make_room(par, 2);
 	tdfx_outl(par, DACADDR, regno);
+	/* read after write makes it working */
+	tdfx_inl(par, DACADDR);
 	tdfx_outl(par, DACDATA, c);
 }
 
@@ -771,6 +781,12 @@ static int tdfxfb_setcolreg(unsigned reg
 	if (regno >= info->cmap.len || regno > 255)
 		return 1;
 
+	/* grayscale works only partially under directcolor */
+	if (info->var.grayscale) {
+		/* grayscale = 0.30*R + 0.59*G + 0.11*B */
+		red = green = blue = (red * 77 + green * 151 + blue * 28) >> 8;
+	}
+
 	switch (info->fix.visual) {
 	case FB_VISUAL_PSEUDOCOLOR:
 		rgbcol =(((u32)red   & 0xff00) << 8) |
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
