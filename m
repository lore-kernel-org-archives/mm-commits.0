From: akpm@linux-foundation.org
Subject: [to-be-updated] lxfb-fix-it-for-directfb-usage.patch removed from -mm tree
Date: Fri, 30 Jan 2009 13:13:37 -0800
Message-ID: <200901302113.n0ULDbCx013606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230AbZA3VNz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 16:13:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marco-laporta@tiscali.it, dilinger@debian.org, dilinger@queued.net, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     lxfb: fix it for DirectFB usage
has been removed from the -mm tree.  Its filename was
     lxfb-fix-it-for-directfb-usage.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lxfb: fix it for DirectFB usage
From: "Marco La Porta" <marco-laporta@tiscali.it>

I use the Geode LX it in embedded application (e.g.  DirectFB).  With
DirectFB users like me can write a GUI working without the XServer, and in
embedded application this is a most important feature.

With DirectFB, original lxfb works only with 8 bbp, and I think the
problem was the cmap.  DirectDB get/set the cmap thought FBIOGETCMAP/
FBIOPUTCMAP ioctl calls,

1) I think the cmap must be deallocated when exiting because the mode
   can be changed and the flow will reach lxfb_set_par, allocating a cmap.
    I understand this point because DirectFB, on exit, tell me about a bad
   chunk.

2) I allocate a cmap at probe and deallocate it on exiting, and
   everything works fine for me.  I do something similar to vesafb,
   because this driver works with DirectFB, although the screen size is
   wrong in my hardware.

Cc: Andres Salomon <dilinger@queued.net>
Cc: Andres Salomon <dilinger@debian.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb_core.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff -puN drivers/video/geode/lxfb_core.c~lxfb-fix-it-for-directfb-usage drivers/video/geode/lxfb_core.c
--- a/drivers/video/geode/lxfb_core.c~lxfb-fix-it-for-directfb-usage
+++ a/drivers/video/geode/lxfb_core.c
@@ -280,10 +280,10 @@ static int lxfb_set_par(struct fb_info *
 {
 	if (info->var.bits_per_pixel > 8) {
 		info->fix.visual = FB_VISUAL_TRUECOLOR;
-		fb_dealloc_cmap(&info->cmap);
+		//fb_dealloc_cmap(&info->cmap);
 	} else {
 		info->fix.visual = FB_VISUAL_PSEUDOCOLOR;
-		fb_alloc_cmap(&info->cmap, 1<<info->var.bits_per_pixel, 0);
+		//fb_alloc_cmap(&info->cmap, 1<<info->var.bits_per_pixel, 0);
 	}
 
 	info->fix.line_length = lx_get_pitch(info->var.xres,
@@ -304,6 +304,9 @@ static int lxfb_setcolreg(unsigned regno
 			   unsigned blue, unsigned transp,
 			   struct fb_info *info)
 {
+
+
+
 	if (info->var.grayscale) {
 		/* grayscale = 0.30*R + 0.59*G + 0.11*B */
 		red = green = blue = (red * 77 + green * 151 + blue * 28) >> 8;
@@ -311,17 +314,16 @@ static int lxfb_setcolreg(unsigned regno
 
 	/* Truecolor has hardware independent palette */
 	if (info->fix.visual == FB_VISUAL_TRUECOLOR) {
-		u32 *pal = info->pseudo_palette;
-		u32 v;
-
-		if (regno >= 16)
-			return -EINVAL;
-
-		v  = chan_to_field(red, &info->var.red);
-		v |= chan_to_field(green, &info->var.green);
-		v |= chan_to_field(blue, &info->var.blue);
+		if (regno < 16) {
+			u32 *pal = info->pseudo_palette;
+			u32 v;
+
+			v  = chan_to_field(red, &info->var.red);
+			v |= chan_to_field(green, &info->var.green);
+			v |= chan_to_field(blue, &info->var.blue);
 
-		pal[regno] = v;
+			pal[regno] = v;
+		}
 	} else {
 		if (regno >= 256)
 			return -EINVAL;
@@ -451,6 +453,8 @@ static struct fb_info * __init lxfb_init
 
 	info->pseudo_palette	= (void *)par + sizeof(struct lxfb_par);
 
+	fb_alloc_cmap(&info->cmap, 256, 0);
+
 	info->var.grayscale	= 0;
 
 	return info;
@@ -605,6 +609,8 @@ static void lxfb_remove(struct pci_dev *
 	pci_release_region(pdev, 3);
 
 	pci_set_drvdata(pdev, NULL);
+
+	fb_dealloc_cmap(&info->cmap);
 	framebuffer_release(info);
 }
 
_

Patches currently in -mm which might be from marco-laporta@tiscali.it are

lxfb-fix-it-for-directfb-usage.patch

