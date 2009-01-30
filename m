From: akpm@linux-foundation.org
Subject: + gx1fb-properly-alloc-cmap-and-plug-cmap-leak.patch added to -mm tree
Date: Fri, 30 Jan 2009 13:16:27 -0800
Message-ID: <200901302116.n0ULGRX6017175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754076AbZA3VQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 16:16:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, dilinger@debian.org, jordan.crouse@amd.com, marco-laporta@tiscali.it


The patch titled
     gx1fb: properly alloc cmap and plug cmap leak
has been added to the -mm tree.  Its filename is
     gx1fb-properly-alloc-cmap-and-plug-cmap-leak.patch

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
Subject: gx1fb: properly alloc cmap and plug cmap leak
From: Andres Salomon <dilinger@queued.net>

We weren't properly allocating the cmap for depths greater than 8bpp,
which caused pain for things like DirectFB.  Also, we never freed the cmap
memory upon module unload..

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Marco La Porta <marco-laporta@tiscali.it>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/gx1fb_core.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN drivers/video/geode/gx1fb_core.c~gx1fb-properly-alloc-cmap-and-plug-cmap-leak drivers/video/geode/gx1fb_core.c
--- a/drivers/video/geode/gx1fb_core.c~gx1fb-properly-alloc-cmap-and-plug-cmap-leak
+++ a/drivers/video/geode/gx1fb_core.c
@@ -136,13 +136,10 @@ static int gx1fb_set_par(struct fb_info 
 {
 	struct geodefb_par *par = info->par;
 
-	if (info->var.bits_per_pixel == 16) {
+	if (info->var.bits_per_pixel == 16)
 		info->fix.visual = FB_VISUAL_TRUECOLOR;
-		fb_dealloc_cmap(&info->cmap);
-	} else {
+	else
 		info->fix.visual = FB_VISUAL_PSEUDOCOLOR;
-		fb_alloc_cmap(&info->cmap, 1<<info->var.bits_per_pixel, 0);
-	}
 
 	info->fix.line_length = gx1_line_delta(info->var.xres, info->var.bits_per_pixel);
 
@@ -315,6 +312,10 @@ static struct fb_info * __init gx1fb_ini
 	if (!par->panel_x)
 		par->enable_crt = 1; /* fall back to CRT if no panel is specified */
 
+	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0) {
+		framebuffer_release(info);
+		return NULL;
+	}
 	return info;
 }
 
@@ -374,8 +375,11 @@ static int __init gx1fb_probe(struct pci
 		release_mem_region(gx1_gx_base() + 0x8300, 0x100);
 	}
 
-	if (info)
+	if (info) {
+		fb_dealloc_cmap(&info->cmap);
 		framebuffer_release(info);
+	}
+
 	return ret;
 }
 
@@ -395,6 +399,7 @@ static void gx1fb_remove(struct pci_dev 
 	iounmap(par->dc_regs);
 	release_mem_region(gx1_gx_base() + 0x8300, 0x100);
 
+	fb_dealloc_cmap(&info->cmap);
 	pci_set_drvdata(pdev, NULL);
 
 	framebuffer_release(info);
_

Patches currently in -mm which might be from dilinger@queued.net are

jffs2-force-the-jffs2-gc-daemon-to-behave-a-bit-better.patch
gxfb-properly-alloc-cmap-and-plug-cmap-leak.patch
gx1fb-properly-alloc-cmap-and-plug-cmap-leak.patch

