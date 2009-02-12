From: akpm@linux-foundation.org
Subject: [merged] lxfb-properly-alloc-cmap-in-all-cases-and-dont-leak-the-memory.patch removed from -mm tree
Date: Thu, 12 Feb 2009 12:25:07 -0800
Message-ID: <200902122025.n1CKP7Bm014199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755125AbZBLUZw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Feb 2009 15:25:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marco-laporta@tiscali.it, dilinger@debian.org, jordan@cosmicpenguin.net, mm-commits@vger.kernel.org


The patch titled
     lxfb: properly alloc cmap in all cases and don't leak the memory
has been removed from the -mm tree.  Its filename was
     lxfb-properly-alloc-cmap-in-all-cases-and-dont-leak-the-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lxfb: properly alloc cmap in all cases and don't leak the memory
From: Marco La Porta <marco-laporta@tiscali.it>

We weren't properly allocating the cmap for depths greater than 8bpp,
which caused pain for things like DirectFB.  Also, we never freed the cmap
memory upon module unload..

[dilinger@debian.org: dropped unnecessary code and clean up patch]
[dilinger@debian.org: add error checking and handling]
Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb_core.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN drivers/video/geode/lxfb_core.c~lxfb-properly-alloc-cmap-in-all-cases-and-dont-leak-the-memory drivers/video/geode/lxfb_core.c
--- a/drivers/video/geode/lxfb_core.c~lxfb-properly-alloc-cmap-in-all-cases-and-dont-leak-the-memory
+++ a/drivers/video/geode/lxfb_core.c
@@ -278,13 +278,10 @@ static int lxfb_check_var(struct fb_var_
 
 static int lxfb_set_par(struct fb_info *info)
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
 
 	info->fix.line_length = lx_get_pitch(info->var.xres,
 		info->var.bits_per_pixel);
@@ -451,6 +448,11 @@ static struct fb_info * __init lxfb_init
 
 	info->pseudo_palette	= (void *)par + sizeof(struct lxfb_par);
 
+	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0) {
+		framebuffer_release(info);
+		return NULL;
+	}
+
 	info->var.grayscale	= 0;
 
 	return info;
@@ -579,8 +581,10 @@ err:
 		pci_release_region(pdev, 3);
 	}
 
-	if (info)
+	if (info) {
+		fb_dealloc_cmap(&info->cmap);
 		framebuffer_release(info);
+	}
 
 	return ret;
 }
@@ -604,6 +608,7 @@ static void lxfb_remove(struct pci_dev *
 	iounmap(par->vp_regs);
 	pci_release_region(pdev, 3);
 
+	fb_dealloc_cmap(&info->cmap);
 	pci_set_drvdata(pdev, NULL);
 	framebuffer_release(info);
 }
_

Patches currently in -mm which might be from marco-laporta@tiscali.it are

origin.patch

