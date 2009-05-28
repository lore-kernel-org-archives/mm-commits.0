From: akpm@linux-foundation.org
Subject: + cg14-use-standard-fields-for-framebuffer-physical-address-and-length.patch added to -mm tree
Date: Wed, 27 May 2009 23:47:36 -0700
Message-ID: <200905280647.n4S6la5w017699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbZE1GsE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 02:48:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, davem@davemloft.net


The patch titled
     cg14: use standard fields for framebuffer physical address and length
has been added to the -mm tree.  Its filename is
     cg14-use-standard-fields-for-framebuffer-physical-address-and-length.patch

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
Subject: cg14: use standard fields for framebuffer physical address and length
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Use standard fields fbinfo.fix.smem_start and fbinfo.fix.smem_len for
physical address and length of framebuffer.

This also fixes output of the 'fbset -i' command - address and length of
the framebuffer is displayed correctly.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cg14.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN drivers/video/cg14.c~cg14-use-standard-fields-for-framebuffer-physical-address-and-length drivers/video/cg14.c
--- a/drivers/video/cg14.c~cg14-use-standard-fields-for-framebuffer-physical-address-and-length
+++ a/drivers/video/cg14.c
@@ -196,9 +196,7 @@ struct cg14_par {
 	u32			flags;
 #define CG14_FLAG_BLANKED	0x00000001
 
-	unsigned long		physbase;
 	unsigned long		iospace;
-	unsigned long		fbsize;
 
 	struct sbus_mmap_map	mmap_map[CG14_MMAP_ENTRIES];
 
@@ -271,7 +269,7 @@ static int cg14_mmap(struct fb_info *inf
 	struct cg14_par *par = (struct cg14_par *) info->par;
 
 	return sbusfb_mmap_helper(par->mmap_map,
-				  par->physbase, par->fbsize,
+				  info->fix.smem_start, info->fix.smem_len,
 				  par->iospace, vma);
 }
 
@@ -343,7 +341,8 @@ static int cg14_ioctl(struct fb_info *in
 
 	default:
 		ret = sbusfb_ioctl_helper(cmd, arg, info,
-					  FBTYPE_MDICOLOR, 8, par->fbsize);
+					  FBTYPE_MDICOLOR, 8,
+					  info->fix.smem_len);
 		break;
 	};
 
@@ -462,7 +461,7 @@ static void cg14_unmap_regs(struct of_de
 			   par->cursor, sizeof(struct cg14_cursor));
 	if (info->screen_base)
 		of_iounmap(&op->resource[1],
-			   info->screen_base, par->fbsize);
+			   info->screen_base, info->fix.smem_len);
 }
 
 static int __devinit cg14_probe(struct of_device *op, const struct of_device_id *match)
@@ -488,14 +487,14 @@ static int __devinit cg14_probe(struct o
 
 	linebytes = of_getintprop_default(dp, "linebytes",
 					  info->var.xres);
-	par->fbsize = PAGE_ALIGN(linebytes * info->var.yres);
+	info->fix.smem_len = PAGE_ALIGN(linebytes * info->var.yres);
 
 	if (!strcmp(dp->parent->name, "sbus") ||
 	    !strcmp(dp->parent->name, "sbi")) {
-		par->physbase = op->resource[0].start;
+		info->fix.smem_start = op->resource[0].start;
 		par->iospace = op->resource[0].flags & IORESOURCE_BITS;
 	} else {
-		par->physbase = op->resource[1].start;
+		info->fix.smem_start = op->resource[1].start;
 		par->iospace = op->resource[0].flags & IORESOURCE_BITS;
 	}
 
@@ -507,7 +506,7 @@ static int __devinit cg14_probe(struct o
 				 sizeof(struct cg14_cursor), "cg14 cursor");
 
 	info->screen_base = of_ioremap(&op->resource[1], 0,
-				       par->fbsize, "cg14 ram");
+				       info->fix.smem_len, "cg14 ram");
 
 	if (!par->regs || !par->clut || !par->cursor || !info->screen_base)
 		goto out_unmap_regs;
@@ -557,7 +556,7 @@ static int __devinit cg14_probe(struct o
 
 	printk(KERN_INFO "%s: cgfourteen at %lx:%lx, %dMB\n",
 	       dp->full_name,
-	       par->iospace, par->physbase,
+	       par->iospace, info->fix.smem_start,
 	       par->ramsize >> 20);
 
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

