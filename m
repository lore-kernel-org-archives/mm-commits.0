From: akpm@linux-foundation.org
Subject: [merged] tcx-use-standard-fields-for-framebuffer-physical-address-and-length.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:39:49 -0700
Message-ID: <200906171839.n5HIdns6005784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756941AbZFQSp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:45:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     tcx: use standard fields for framebuffer physical address and length
has been removed from the -mm tree.  Its filename was
     tcx-use-standard-fields-for-framebuffer-physical-address-and-length.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tcx: use standard fields for framebuffer physical address and length
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Use standard fields fbinfo.fix.smem_start and fbinfo.fix.smem_len for
physical address and length of framebuffer.

This also fixes output of the 'fbset -i' command - address and length of
the framebuffer are displayed correctly.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tcx.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff -puN drivers/video/tcx.c~tcx-use-standard-fields-for-framebuffer-physical-address-and-length drivers/video/tcx.c
--- a/drivers/video/tcx.c~tcx-use-standard-fields-for-framebuffer-physical-address-and-length
+++ a/drivers/video/tcx.c
@@ -116,17 +116,16 @@ struct tcx_par {
 	u32			flags;
 #define TCX_FLAG_BLANKED	0x00000001
 
-	unsigned long		physbase;
 	unsigned long		which_io;
-	unsigned long		fbsize;
 
 	struct sbus_mmap_map	mmap_map[TCX_MMAP_ENTRIES];
 	int			lowdepth;
 };
 
 /* Reset control plane so that WID is 8-bit plane. */
-static void __tcx_set_control_plane(struct tcx_par *par)
+static void __tcx_set_control_plane(struct fb_info *info)
 {
+	struct tcx_par *par = info->par;
 	u32 __iomem *p, *pend;
 
 	if (par->lowdepth)
@@ -135,7 +134,7 @@ static void __tcx_set_control_plane(stru
 	p = par->cplane;
 	if (p == NULL)
 		return;
-	for (pend = p + par->fbsize; p < pend; p++) {
+	for (pend = p + info->fix.smem_len; p < pend; p++) {
 		u32 tmp = sbus_readl(p);
 
 		tmp &= 0xffffff;
@@ -149,7 +148,7 @@ static void tcx_reset(struct fb_info *in
 	unsigned long flags;
 
 	spin_lock_irqsave(&par->lock, flags);
-	__tcx_set_control_plane(par);
+	__tcx_set_control_plane(info);
 	spin_unlock_irqrestore(&par->lock, flags);
 }
 
@@ -304,7 +303,7 @@ static int tcx_mmap(struct fb_info *info
 	struct tcx_par *par = (struct tcx_par *)info->par;
 
 	return sbusfb_mmap_helper(par->mmap_map,
-				  par->physbase, par->fbsize,
+				  info->fix.smem_start, info->fix.smem_len,
 				  par->which_io, vma);
 }
 
@@ -316,7 +315,7 @@ static int tcx_ioctl(struct fb_info *inf
 	return sbusfb_ioctl_helper(cmd, arg, info,
 				   FBTYPE_TCXCOLOR,
 				   (par->lowdepth ? 8 : 24),
-				   par->fbsize);
+				   info->fix.smem_len);
 }
 
 /*
@@ -358,10 +357,10 @@ static void tcx_unmap_regs(struct of_dev
 			   par->bt, sizeof(struct bt_regs));
 	if (par->cplane)
 		of_iounmap(&op->resource[4],
-			   par->cplane, par->fbsize * sizeof(u32));
+			   par->cplane, info->fix.smem_len * sizeof(u32));
 	if (info->screen_base)
 		of_iounmap(&op->resource[0],
-			   info->screen_base, par->fbsize);
+			   info->screen_base, info->fix.smem_len);
 }
 
 static int __devinit tcx_probe(struct of_device *op,
@@ -391,7 +390,7 @@ static int __devinit tcx_probe(struct of
 
 	linebytes = of_getintprop_default(dp, "linebytes",
 					  info->var.xres);
-	par->fbsize = PAGE_ALIGN(linebytes * info->var.yres);
+	info->fix.smem_len = PAGE_ALIGN(linebytes * info->var.yres);
 
 	par->tec = of_ioremap(&op->resource[7], 0,
 				  sizeof(struct tcx_tec), "tcx tec");
@@ -400,7 +399,7 @@ static int __devinit tcx_probe(struct of
 	par->bt = of_ioremap(&op->resource[8], 0,
 				 sizeof(struct bt_regs), "tcx dac");
 	info->screen_base = of_ioremap(&op->resource[0], 0,
-					   par->fbsize, "tcx ram");
+					   info->fix.smem_len, "tcx ram");
 	if (!par->tec || !par->thc ||
 	    !par->bt || !info->screen_base)
 		goto out_unmap_regs;
@@ -408,7 +407,7 @@ static int __devinit tcx_probe(struct of
 	memcpy(&par->mmap_map, &__tcx_mmap_map, sizeof(par->mmap_map));
 	if (!par->lowdepth) {
 		par->cplane = of_ioremap(&op->resource[4], 0,
-					     par->fbsize * sizeof(u32),
+					     info->fix.smem_len * sizeof(u32),
 					     "tcx cplane");
 		if (!par->cplane)
 			goto out_unmap_regs;
@@ -419,7 +418,7 @@ static int __devinit tcx_probe(struct of
 		par->mmap_map[6].size = SBUS_MMAP_EMPTY;
 	}
 
-	par->physbase = op->resource[0].start;
+	info->fix.smem_start = op->resource[0].start;
 	par->which_io = op->resource[0].flags & IORESOURCE_BITS;
 
 	for (i = 0; i < TCX_MMAP_ENTRIES; i++) {
@@ -473,7 +472,7 @@ static int __devinit tcx_probe(struct of
 	printk(KERN_INFO "%s: TCX at %lx:%lx, %s\n",
 	       dp->full_name,
 	       par->which_io,
-	       par->physbase,
+	       info->fix.smem_start,
 	       par->lowdepth ? "8-bit only" : "24-bit depth");
 
 	return 0;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
intelfb-fix-color-map-setting-with-an-lvds-display.patch
intelfb-fix-setting-of-active-pipe-with-lvds-displays.patch

