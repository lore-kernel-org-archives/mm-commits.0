From: akpm@linux-foundation.org
Subject: + leo-use-standard-fields-for-framebuffer-physical-address-and-length.patch added to -mm tree
Date: Wed, 27 May 2009 23:47:42 -0700
Message-ID: <200905280647.n4S6lgUg017746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756516AbZE1GsM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 02:48:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, davem@davemloft.net


The patch titled
     leo: use standard fields for framebuffer physical address and length
has been added to the -mm tree.  Its filename is
     leo-use-standard-fields-for-framebuffer-physical-address-and-length.patch

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
Subject: leo: use standard fields for framebuffer physical address and length
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Use standard fields fbinfo.fix.smem_start and fbinfo.fix.smem_len for
physical address and length of framebuffer.

This also fixes output of the 'fbset -i' command - address and length of
the framebuffer are displayed correctly.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/leo.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN drivers/video/leo.c~leo-use-standard-fields-for-framebuffer-physical-address-and-length drivers/video/leo.c
--- a/drivers/video/leo.c~leo-use-standard-fields-for-framebuffer-physical-address-and-length
+++ a/drivers/video/leo.c
@@ -191,9 +191,7 @@ struct leo_par {
 	u32			flags;
 #define LEO_FLAG_BLANKED	0x00000001
 
-	unsigned long		physbase;
 	unsigned long		which_io;
-	unsigned long		fbsize;
 };
 
 static void leo_wait(struct leo_lx_krn __iomem *lx_krn)
@@ -420,16 +418,14 @@ static int leo_mmap(struct fb_info *info
 	struct leo_par *par = (struct leo_par *)info->par;
 
 	return sbusfb_mmap_helper(leo_mmap_map,
-				  par->physbase, par->fbsize,
+				  info->fix.smem_start, info->fix.smem_len,
 				  par->which_io, vma);
 }
 
 static int leo_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg)
 {
-	struct leo_par *par = (struct leo_par *) info->par;
-
 	return sbusfb_ioctl_helper(cmd, arg, info,
-				   FBTYPE_SUNLEO, 32, par->fbsize);
+				   FBTYPE_SUNLEO, 32, info->fix.smem_len);
 }
 
 /*
@@ -569,7 +565,7 @@ static int __devinit leo_probe(struct of
 
 	spin_lock_init(&par->lock);
 
-	par->physbase = op->resource[0].start;
+	info->fix.smem_start = op->resource[0].start;
 	par->which_io = op->resource[0].flags & IORESOURCE_BITS;
 
 	sbusfb_fill_var(&info->var, dp, 32);
@@ -577,7 +573,7 @@ static int __devinit leo_probe(struct of
 
 	linebytes = of_getintprop_default(dp, "linebytes",
 					  info->var.xres);
-	par->fbsize = PAGE_ALIGN(linebytes * info->var.yres);
+	info->fix.smem_len = PAGE_ALIGN(linebytes * info->var.yres);
 
 	par->lc_ss0_usr =
 		of_ioremap(&op->resource[0], LEO_OFF_LC_SS0_USR,
@@ -627,7 +623,7 @@ static int __devinit leo_probe(struct of
 
 	printk(KERN_INFO "%s: leo at %lx:%lx\n",
 	       dp->full_name,
-	       par->which_io, par->physbase);
+	       par->which_io, info->fix.smem_start);
 
 	return 0;
 
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

