From: akpm@linux-foundation.org
Subject: + gxfb-properly-alloc-cmap-and-plug-cmap-leak.patch added to -mm tree
Date: Fri, 30 Jan 2009 13:16:25 -0800
Message-ID: <200901302116.n0ULGPgk017132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618AbZA3VQi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 16:16:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, dilinger@debian.org, jordan.crouse@amd.com, marco-laporta@tiscali.it


The patch titled
     gxfb: properly alloc cmap and plug cmap leak
has been added to the -mm tree.  Its filename is
     gxfb-properly-alloc-cmap-and-plug-cmap-leak.patch

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
Subject: gxfb: properly alloc cmap and plug cmap leak
From: Andres Salomon <dilinger@queued.net>

We weren't properly allocating the cmap for depths greater than 8bpp,
which caused pain for things like DirectFB.  Also, we never freed the cmap
memory upon module unload..

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Marco La Porta <marco-laporta@tiscali.it>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/gxfb_core.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN drivers/video/geode/gxfb_core.c~gxfb-properly-alloc-cmap-and-plug-cmap-leak drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~gxfb-properly-alloc-cmap-and-plug-cmap-leak
+++ a/drivers/video/geode/gxfb_core.c
@@ -171,13 +171,10 @@ static int gxfb_check_var(struct fb_var_
 
 static int gxfb_set_par(struct fb_info *info)
 {
-	if (info->var.bits_per_pixel > 8) {
+	if (info->var.bits_per_pixel > 8)
 		info->fix.visual = FB_VISUAL_TRUECOLOR;
-		fb_dealloc_cmap(&info->cmap);
-	} else {
+	else
 		info->fix.visual = FB_VISUAL_PSEUDOCOLOR;
-		fb_alloc_cmap(&info->cmap, 1<<info->var.bits_per_pixel, 0);
-	}
 
 	info->fix.line_length = gx_line_delta(info->var.xres, info->var.bits_per_pixel);
 
@@ -331,6 +328,11 @@ static struct fb_info * __init gxfb_init
 
 	info->var.grayscale	= 0;
 
+	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0) {
+		framebuffer_release(info);
+		return NULL;
+	}
+
 	return info;
 }
 
@@ -443,8 +445,10 @@ static int __init gxfb_probe(struct pci_
 		pci_release_region(pdev, 1);
 	}
 
-	if (info)
+	if (info) {
+		fb_dealloc_cmap(&info->cmap);
 		framebuffer_release(info);
+	}
 	return ret;
 }
 
@@ -467,6 +471,7 @@ static void gxfb_remove(struct pci_dev *
 	iounmap(par->gp_regs);
 	pci_release_region(pdev, 1);
 
+	fb_dealloc_cmap(&info->cmap);
 	pci_set_drvdata(pdev, NULL);
 
 	framebuffer_release(info);
_

Patches currently in -mm which might be from dilinger@queued.net are

jffs2-force-the-jffs2-gc-daemon-to-behave-a-bit-better.patch
gxfb-properly-alloc-cmap-and-plug-cmap-leak.patch
gx1fb-properly-alloc-cmap-and-plug-cmap-leak.patch

