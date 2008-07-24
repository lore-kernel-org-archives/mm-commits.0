From: akpm@linux-foundation.org
Subject: - tridentfb-move-global-pseudo-palette-into-structure.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:30:43 -0700
Message-ID: <200807242330.m6ONUhWk011532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756951AbYGXXau (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:30:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     tridentfb: move global pseudo palette into structure
has been removed from the -mm tree.  Its filename was
     tridentfb-move-global-pseudo-palette-into-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: move global pseudo palette into structure
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch moves pseudo palette int tridentfb_par structure and removes global
default_var.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-move-global-pseudo-palette-into-structure drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-move-global-pseudo-palette-into-structure
+++ a/drivers/video/tridentfb.c
@@ -28,16 +28,12 @@
 
 struct tridentfb_par {
 	void __iomem *io_virt;	/* iospace virtual memory address */
+	u32 pseudo_pal[16];
 };
 
 static unsigned char eng_oper;	/* engine operation... */
 static struct fb_ops tridentfb_ops;
 
-/* FIXME:kmalloc these 3 instead */
-static u32 pseudo_pal[16];
-
-static struct fb_var_screeninfo default_var;
-
 static struct fb_fix_screeninfo tridentfb_fix = {
 	.id = "Trident",
 	.type = FB_TYPE_PACKED_PIXELS,
@@ -1340,9 +1336,7 @@ static int __devinit trident_pci_probe(s
 #ifdef CONFIG_FB_TRIDENT_ACCEL
 	info->flags |= FBINFO_HWACCEL_COPYAREA | FBINFO_HWACCEL_FILLRECT;
 #endif
-	info->pseudo_palette = pseudo_pal;
-
-	if (!fb_find_mode(&default_var, info,
+	if (!fb_find_mode(&info->var, info,
 			  mode_option, NULL, 0, NULL, bpp)) {
 		err = -EINVAL;
 		goto out_unmap2;
@@ -1352,11 +1346,10 @@ static int __devinit trident_pci_probe(s
 		goto out_unmap2;
 
 	if (defaultaccel && acc)
-		default_var.accel_flags |= FB_ACCELF_TEXT;
+		info->var.accel_flags |= FB_ACCELF_TEXT;
 	else
-		default_var.accel_flags &= ~FB_ACCELF_TEXT;
-	default_var.activate |= FB_ACTIVATE_NOW;
-	info->var = default_var;
+		info->var.accel_flags &= ~FB_ACCELF_TEXT;
+	info->var.activate |= FB_ACTIVATE_NOW;
 	info->device = &dev->dev;
 	if (register_framebuffer(info) < 0) {
 		printk(KERN_ERR "tridentfb: could not register Trident framebuffer\n");
@@ -1365,8 +1358,8 @@ static int __devinit trident_pci_probe(s
 		goto out_unmap2;
 	}
 	output("fb%d: %s frame buffer device %dx%d-%dbpp\n",
-	   info->node, info->fix.id, default_var.xres,
-	   default_var.yres, default_var.bits_per_pixel);
+	   info->node, info->fix.id, info->var.xres,
+	   info->var.yres, info->var.bits_per_pixel);
 
 	pci_set_drvdata(dev, info);
 	return 0;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

