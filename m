From: akpm@linux-foundation.org
Subject: - tridentfb-move-global-acceleration-hooks-into-structure.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:30:51 -0700
Message-ID: <200807242330.m6ONUpMP011556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756543AbYGXXaz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:30:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     tridentfb: move global acceleration hooks into structure
has been removed from the -mm tree.  Its filename was
     tridentfb-move-global-acceleration-hooks-into-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: move global acceleration hooks into structure
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch moves acceleration hooks into the tridentfb_par structure and
removes global hooks.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   63 +++++++++++++-----------------------
 1 file changed, 24 insertions(+), 39 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-move-global-acceleration-hooks-into-structure drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-move-global-acceleration-hooks-into-structure
+++ a/drivers/video/tridentfb.c
@@ -31,6 +31,12 @@ struct tridentfb_par {
 	u32 pseudo_pal[16];
 	int chip_id;
 	int flatpanel;
+	void (*init_accel) (struct tridentfb_par *, int, int);
+	void (*wait_engine) (struct tridentfb_par *);
+	void (*fill_rect)
+		(struct tridentfb_par *par, u32, u32, u32, u32, u32, u32);
+	void (*copy_rect)
+		(struct tridentfb_par *par, u32, u32, u32, u32, u32, u32);
 };
 
 static unsigned char eng_oper;	/* engine operation... */
@@ -155,15 +161,6 @@ static inline u8 t_inb(struct tridentfb_
 	return fb_readb(p->io_virt + reg);
 }
 
-static struct accel_switch {
-	void (*init_accel) (struct tridentfb_par *, int, int);
-	void (*wait_engine) (struct tridentfb_par *);
-	void (*fill_rect)
-		(struct tridentfb_par *par, u32, u32, u32, u32, u32, u32);
-	void (*copy_rect)
-		(struct tridentfb_par *par, u32, u32, u32, u32, u32, u32);
-} *acc;
-
 static inline void writemmr(struct tridentfb_par *par, u16 r, u32 v)
 {
 	fb_writel(v, par->io_virt + r);
@@ -259,13 +256,6 @@ static void blade_copy_rect(struct tride
 	writemmr(par, DR2, direction ? d1 : d2);
 }
 
-static struct accel_switch accel_blade = {
-	blade_init_accel,
-	blade_wait_engine,
-	blade_fill_rect,
-	blade_copy_rect,
-};
-
 /*
  * BladeXP specific acceleration functions
  */
@@ -405,13 +395,6 @@ static void xp_copy_rect(struct tridentf
 	t_outb(par, 0x01, 0x2124);
 }
 
-static struct accel_switch accel_xp = {
-	xp_init_accel,
-	xp_wait_engine,
-	xp_fill_rect,
-	xp_copy_rect,
-};
-
 /*
  * Image specific acceleration functions
  */
@@ -491,13 +474,6 @@ static void image_copy_rect(struct tride
 		 0x80000000 | 1 << 22 | 1 << 10 | 1 << 7 | direction);
 }
 
-static struct accel_switch accel_image = {
-	image_init_accel,
-	image_wait_engine,
-	image_fill_rect,
-	image_copy_rect,
-};
-
 /*
  * Accel functions called by the upper layers
  */
@@ -524,18 +500,18 @@ static void tridentfb_fillrect(struct fb
 		break;
 	}
 
-	acc->fill_rect(par, fr->dx, fr->dy, fr->width,
+	par->fill_rect(par, fr->dx, fr->dy, fr->width,
 		       fr->height, col, fr->rop);
-	acc->wait_engine(par);
+	par->wait_engine(par);
 }
 static void tridentfb_copyarea(struct fb_info *info,
 			       const struct fb_copyarea *ca)
 {
 	struct tridentfb_par *par = info->par;
 
-	acc->copy_rect(par, ca->sx, ca->sy, ca->dx, ca->dy,
+	par->copy_rect(par, ca->sx, ca->sy, ca->dx, ca->dy,
 		       ca->width, ca->height);
-	acc->wait_engine(par);
+	par->wait_engine(par);
 }
 #else /* !CONFIG_FB_TRIDENT_ACCEL */
 #define tridentfb_fillrect cfb_fillrect
@@ -1029,7 +1005,7 @@ static int tridentfb_set_par(struct fb_i
 	write3X4(par, GraphEngReg, 0x80);
 
 #ifdef CONFIG_FB_TRIDENT_ACCEL
-	acc->init_accel(par, info->var.xres, bpp);
+	par->init_accel(par, info->var.xres, bpp);
 #endif
 
 	switch (bpp) {
@@ -1290,11 +1266,20 @@ static int __devinit trident_pci_probe(s
 	chip3D = is3Dchip(chip_id);
 
 	if (is_xp(chip_id)) {
-		acc = &accel_xp;
+		default_par->init_accel = xp_init_accel;
+		default_par->wait_engine = xp_wait_engine;
+		default_par->fill_rect = xp_fill_rect;
+		default_par->copy_rect = xp_copy_rect;
 	} else if (is_blade(chip_id)) {
-		acc = &accel_blade;
+		default_par->init_accel = blade_init_accel;
+		default_par->wait_engine = blade_wait_engine;
+		default_par->fill_rect = blade_fill_rect;
+		default_par->copy_rect = blade_copy_rect;
 	} else {
-		acc = &accel_image;
+		default_par->init_accel = image_init_accel;
+		default_par->wait_engine = image_wait_engine;
+		default_par->fill_rect = image_fill_rect;
+		default_par->copy_rect = image_copy_rect;
 	}
 
 	default_par->chip_id = chip_id;
@@ -1365,7 +1350,7 @@ static int __devinit trident_pci_probe(s
 	if (err < 0)
 		goto out_unmap2;
 
-	if (defaultaccel && acc)
+	if (defaultaccel && default_par->init_accel)
 		info->var.accel_flags |= FB_ACCELF_TEXT;
 	else
 		info->var.accel_flags &= ~FB_ACCELF_TEXT;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

