From: akpm@linux-foundation.org
Subject: [merged] cg6-use-standard-fields-for-framebuffer-physical-address-and-length.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:21:55 -0700
Message-ID: <200906162221.n5GMLtUZ016959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756662AbZFPWW0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:22:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     cg6: use standard fields for framebuffer physical address and length
has been removed from the -mm tree.  Its filename was
     cg6-use-standard-fields-for-framebuffer-physical-address-and-length.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cg6: use standard fields for framebuffer physical address and length
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Use standard fields fbinfo.fix.smem_start and fbinfo.fix.smem_len for
physical address and length of framebuffer.

This also fixes output of the 'fbset -i' command - address and length of
the framebuffer are displayed correctly.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cg6.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff -puN drivers/video/cg6.c~cg6-use-standard-fields-for-framebuffer-physical-address-and-length drivers/video/cg6.c
--- a/drivers/video/cg6.c~cg6-use-standard-fields-for-framebuffer-physical-address-and-length
+++ a/drivers/video/cg6.c
@@ -263,9 +263,7 @@ struct cg6_par {
 	u32			flags;
 #define CG6_FLAG_BLANKED	0x00000001
 
-	unsigned long		physbase;
 	unsigned long		which_io;
-	unsigned long		fbsize;
 };
 
 static int cg6_sync(struct fb_info *info)
@@ -596,16 +594,14 @@ static int cg6_mmap(struct fb_info *info
 	struct cg6_par *par = (struct cg6_par *)info->par;
 
 	return sbusfb_mmap_helper(cg6_mmap_map,
-				  par->physbase, par->fbsize,
+				  info->fix.smem_start, info->fix.smem_len,
 				  par->which_io, vma);
 }
 
 static int cg6_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg)
 {
-	struct cg6_par *par = (struct cg6_par *)info->par;
-
 	return sbusfb_ioctl_helper(cmd, arg, info,
-				   FBTYPE_SUNFAST_COLOR, 8, par->fbsize);
+				   FBTYPE_SUNFAST_COLOR, 8, info->fix.smem_len);
 }
 
 /*
@@ -631,12 +627,12 @@ static void __devinit cg6_init_fix(struc
 		break;
 	};
 	if (((conf >> CG6_FHC_REV_SHIFT) & CG6_FHC_REV_MASK) >= 11) {
-		if (par->fbsize <= 0x100000)
+		if (info->fix.smem_len <= 0x100000)
 			cg6_card_name = "TGX";
 		else
 			cg6_card_name = "TGX+";
 	} else {
-		if (par->fbsize <= 0x100000)
+		if (info->fix.smem_len <= 0x100000)
 			cg6_card_name = "GX";
 		else
 			cg6_card_name = "GX+";
@@ -738,7 +734,8 @@ static void cg6_unmap_regs(struct of_dev
 		of_iounmap(&op->resource[0], par->fhc, sizeof(u32));
 
 	if (info->screen_base)
-		of_iounmap(&op->resource[0], info->screen_base, par->fbsize);
+		of_iounmap(&op->resource[0], info->screen_base,
+			   info->fix.smem_len);
 }
 
 static int __devinit cg6_probe(struct of_device *op,
@@ -759,7 +756,7 @@ static int __devinit cg6_probe(struct of
 
 	spin_lock_init(&par->lock);
 
-	par->physbase = op->resource[0].start;
+	info->fix.smem_start = op->resource[0].start;
 	par->which_io = op->resource[0].flags & IORESOURCE_BITS;
 
 	sbusfb_fill_var(&info->var, dp, 8);
@@ -769,11 +766,11 @@ static int __devinit cg6_probe(struct of
 
 	linebytes = of_getintprop_default(dp, "linebytes",
 					  info->var.xres);
-	par->fbsize = PAGE_ALIGN(linebytes * info->var.yres);
+	info->fix.smem_len = PAGE_ALIGN(linebytes * info->var.yres);
 
 	dblbuf = of_getintprop_default(dp, "dblbuf", 0);
 	if (dblbuf)
-		par->fbsize *= 4;
+		info->fix.smem_len *= 4;
 
 	par->fbc = of_ioremap(&op->resource[0], CG6_FBC_OFFSET,
 				4096, "cgsix fbc");
@@ -792,7 +789,7 @@ static int __devinit cg6_probe(struct of
 	info->fbops = &cg6_ops;
 
 	info->screen_base = of_ioremap(&op->resource[0], CG6_RAM_OFFSET,
-					par->fbsize, "cgsix ram");
+					info->fix.smem_len, "cgsix ram");
 	if (!par->fbc || !par->tec || !par->thc ||
 	    !par->bt || !par->fhc || !info->screen_base)
 		goto out_unmap_regs;
@@ -817,7 +814,7 @@ static int __devinit cg6_probe(struct of
 
 	printk(KERN_INFO "%s: CGsix [%s] at %lx:%lx\n",
 	       dp->full_name, info->fix.id,
-	       par->which_io, par->physbase);
+	       par->which_io, info->fix.smem_start);
 
 	return 0;
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
chipsfb-remove-redundant-assignment.patch
igafb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch
offb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch
acornfb-remove-fb_mmap-function.patch
s3c-fb-fix-resource-releasing-on-error-during-probing.patch
fbdev-use-framebuffer_release-for-freeing-fb_info-structures.patch
tcx-use-standard-fields-for-framebuffer-physical-address-and-length.patch

