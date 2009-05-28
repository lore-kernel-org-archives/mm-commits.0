From: akpm@linux-foundation.org
Subject: + p9100-use-standard-fields-for-framebuffer-physical-address-and-length.patch added to -mm tree
Date: Wed, 27 May 2009 23:47:44 -0700
Message-ID: <200905280647.n4S6liow017822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757378AbZE1GsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 02:48:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, davem@davemloft.net


The patch titled
     p9100: use standard fields for framebuffer physical address and length
has been added to the -mm tree.  Its filename is
     p9100-use-standard-fields-for-framebuffer-physical-address-and-length.patch

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
Subject: p9100: use standard fields for framebuffer physical address and length
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Use standard fields fbinfo.fix.smem_start and fbinfo.fix.smem_len for
physical address and length of framebuffer.

This also fixes output of the 'fbset -i' command - address and length of
the framebuffer are displayed correctly.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/p9100.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff -puN drivers/video/p9100.c~p9100-use-standard-fields-for-framebuffer-physical-address-and-length drivers/video/p9100.c
--- a/drivers/video/p9100.c~p9100-use-standard-fields-for-framebuffer-physical-address-and-length
+++ a/drivers/video/p9100.c
@@ -134,9 +134,7 @@ struct p9100_par {
 	u32			flags;
 #define P9100_FLAG_BLANKED	0x00000001
 
-	unsigned long		physbase;
 	unsigned long		which_io;
-	unsigned long		fbsize;
 };
 
 /**
@@ -224,18 +222,16 @@ static int p9100_mmap(struct fb_info *in
 	struct p9100_par *par = (struct p9100_par *)info->par;
 
 	return sbusfb_mmap_helper(p9100_mmap_map,
-				  par->physbase, par->fbsize,
+				  info->fix.smem_start, info->fix.smem_len,
 				  par->which_io, vma);
 }
 
 static int p9100_ioctl(struct fb_info *info, unsigned int cmd,
 		       unsigned long arg)
 {
-	struct p9100_par *par = (struct p9100_par *) info->par;
-
 	/* Make it look like a cg3. */
 	return sbusfb_ioctl_helper(cmd, arg, info,
-				   FBTYPE_SUN3COLOR, 8, par->fbsize);
+				   FBTYPE_SUN3COLOR, 8, info->fix.smem_len);
 }
 
 /*
@@ -271,7 +267,7 @@ static int __devinit p9100_probe(struct 
 	spin_lock_init(&par->lock);
 
 	/* This is the framebuffer and the only resource apps can mmap.  */
-	par->physbase = op->resource[2].start;
+	info->fix.smem_start = op->resource[2].start;
 	par->which_io = op->resource[2].flags & IORESOURCE_BITS;
 
 	sbusfb_fill_var(&info->var, dp, 8);
@@ -280,7 +276,7 @@ static int __devinit p9100_probe(struct 
 	info->var.blue.length = 8;
 
 	linebytes = of_getintprop_default(dp, "linebytes", info->var.xres);
-	par->fbsize = PAGE_ALIGN(linebytes * info->var.yres);
+	info->fix.smem_len = PAGE_ALIGN(linebytes * info->var.yres);
 
 	par->regs = of_ioremap(&op->resource[0], 0,
 			       sizeof(struct p9100_regs), "p9100 regs");
@@ -290,7 +286,7 @@ static int __devinit p9100_probe(struct 
 	info->flags = FBINFO_DEFAULT;
 	info->fbops = &p9100_ops;
 	info->screen_base = of_ioremap(&op->resource[2], 0,
-				       par->fbsize, "p9100 ram");
+				       info->fix.smem_len, "p9100 ram");
 	if (!info->screen_base)
 		goto out_unmap_regs;
 
@@ -311,7 +307,7 @@ static int __devinit p9100_probe(struct 
 
 	printk(KERN_INFO "%s: p9100 at %lx:%lx\n",
 	       dp->full_name,
-	       par->which_io, par->physbase);
+	       par->which_io, info->fix.smem_start);
 
 	return 0;
 
@@ -319,7 +315,7 @@ out_dealloc_cmap:
 	fb_dealloc_cmap(&info->cmap);
 
 out_unmap_screen:
-	of_iounmap(&op->resource[2], info->screen_base, par->fbsize);
+	of_iounmap(&op->resource[2], info->screen_base, info->fix.smem_len);
 
 out_unmap_regs:
 	of_iounmap(&op->resource[0], par->regs, sizeof(struct p9100_regs));
@@ -340,7 +336,7 @@ static int __devexit p9100_remove(struct
 	fb_dealloc_cmap(&info->cmap);
 
 	of_iounmap(&op->resource[0], par->regs, sizeof(struct p9100_regs));
-	of_iounmap(&op->resource[2], info->screen_base, par->fbsize);
+	of_iounmap(&op->resource[2], info->screen_base, info->fix.smem_len);
 
 	framebuffer_release(info);
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

revert-fbdev-fix-info-lock-deadlock-in-fbcon_event_notify.patch
revert-fbdev-uninline-lock_fb_info.patch
revert-fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency.patch
revert-fbmem-dont-call-copy_from-to_user-with-mutex-held.patch
fbdev-move-back-to-bkl-solution.patch
linux-next.patch
intelfb-fix-color-map-setting-with-an-lvds-display.patch
chipsfb-remove-redundant-assignment.patch
igafb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch
offb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch
acornfb-remove-fb_mmap-function.patch
s3c-fb-fix-resource-releasing-on-error-during-probing.patch
bw2-use-standard-fields-for-framebuffer-physical-address-and-length.patch
cg14-use-standard-fields-for-framebuffer-physical-address-and-length.patch
cg3-use-standard-fields-for-framebuffer-physical-address-and-length.patch
cg6-use-standard-fields-for-framebuffer-physical-address-and-length.patch
leo-use-standard-fields-for-framebuffer-physical-address-and-length.patch
p9100-use-standard-fields-for-framebuffer-physical-address-and-length.patch
tcx-use-standard-fields-for-framebuffer-physical-address-and-length.patch

