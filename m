From: akpm@linux-foundation.org
Subject: [merged] gx1fb-properly-alloc-cmap-and-plug-cmap-leak.patch removed from -mm tree
Date: Thu, 12 Feb 2009 12:25:12 -0800
Message-ID: <200902122025.n1CKPCsS014231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756963AbZBLUZ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Feb 2009 15:25:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, jordan@cosmicpenguin.net, marco-laporta@tiscali.it, mm-commits@vger.kernel.org


The patch titled
     gx1fb: properly alloc cmap and plug cmap leak
has been removed from the -mm tree.  Its filename was
     gx1fb-properly-alloc-cmap-and-plug-cmap-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gx1fb: properly alloc cmap and plug cmap leak
From: Andres Salomon <dilinger@queued.net>

We weren't properly allocating the cmap for depths greater than 8bpp,
which caused pain for things like DirectFB.  Also, we never freed the cmap
memory upon module unload..

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Marco La Porta <marco-laporta@tiscali.it>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
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

origin.patch
jffs2-force-the-jffs2-gc-daemon-to-behave-a-bit-better.patch
drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch
tdfxfb-fix-memory-leaks-in-removal-path.patch
tridentfb-fix-memory-leaks-in-removal-path.patch
vfb-fix-memory-leaks-in-removal-path.patch
skeletonfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
sm501fb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
sstfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
stifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
valkyriefb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
sunxvr500-fix-cmap-memory-leaks.patch
tgafb-fix-cmap-memory-leak.patch
68328fb-fix-cmap-memory-leaks.patch
amba-clcd-fix-cmap-memory-leaks.patch
amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch

