From: akpm@linux-foundation.org
Subject: [merged] fbdev-bfin-t350mcqb-fb-fix-fbmem-allocation-with-blanking-lines.patch removed from -mm tree
Date: Wed, 12 May 2010 10:58:42 -0400
Message-ID: <201005121800.o4CI0AYY011569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868Ab0ELSAX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 14:00:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, stable@kernel.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: bfin-t350mcqb-fb: fix fbmem allocation with blanking lines
has been removed from the -mm tree.  Its filename was
     fbdev-bfin-t350mcqb-fb-fix-fbmem-allocation-with-blanking-lines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: bfin-t350mcqb-fb: fix fbmem allocation with blanking lines
From: Michael Hennerich <michael.hennerich@analog.com>

The current allocation does not include the memory required for blanking
lines.  So avoid memory corruption when multiple devices are using the DMA
memory near each other.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bfin-t350mcqb-fb.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/video/bfin-t350mcqb-fb.c~fbdev-bfin-t350mcqb-fb-fix-fbmem-allocation-with-blanking-lines drivers/video/bfin-t350mcqb-fb.c
--- a/drivers/video/bfin-t350mcqb-fb.c~fbdev-bfin-t350mcqb-fb-fix-fbmem-allocation-with-blanking-lines
+++ a/drivers/video/bfin-t350mcqb-fb.c
@@ -488,9 +488,9 @@ static int __devinit bfin_t350mcqb_probe
 	fbinfo->fbops = &bfin_t350mcqb_fb_ops;
 	fbinfo->flags = FBINFO_FLAG_DEFAULT;
 
-	info->fb_buffer =
-	    dma_alloc_coherent(NULL, fbinfo->fix.smem_len, &info->dma_handle,
-			       GFP_KERNEL);
+	info->fb_buffer = dma_alloc_coherent(NULL, fbinfo->fix.smem_len +
+				ACTIVE_VIDEO_MEM_OFFSET,
+				&info->dma_handle, GFP_KERNEL);
 
 	if (NULL == info->fb_buffer) {
 		printk(KERN_ERR DRIVER_NAME
@@ -568,8 +568,8 @@ out7:
 out6:
 	fb_dealloc_cmap(&fbinfo->cmap);
 out4:
-	dma_free_coherent(NULL, fbinfo->fix.smem_len, info->fb_buffer,
-			  info->dma_handle);
+	dma_free_coherent(NULL, fbinfo->fix.smem_len + ACTIVE_VIDEO_MEM_OFFSET,
+			 info->fb_buffer, info->dma_handle);
 out3:
 	framebuffer_release(fbinfo);
 out2:
@@ -592,8 +592,9 @@ static int __devexit bfin_t350mcqb_remov
 	free_irq(info->irq, info);
 
 	if (info->fb_buffer != NULL)
-		dma_free_coherent(NULL, fbinfo->fix.smem_len, info->fb_buffer,
-				  info->dma_handle);
+		dma_free_coherent(NULL, fbinfo->fix.smem_len +
+			ACTIVE_VIDEO_MEM_OFFSET, info->fb_buffer,
+			info->dma_handle);
 
 	fb_dealloc_cmap(&fbinfo->cmap);
 
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

origin.patch
linux-next.patch
backlight-new-driver-for-the-adp8860-backlight-parts.patch
ad525x_dpot-simplify-duplicated-sysfs-defines.patch
ad525x_dpot-extend-write-argument-to-16bits.patch
ad525x_dpot-add-support-for-spi-parts.patch
ad525x_dpot-add-support-for-ad524x-pots.patch
ad525x_dpot-add-support-for-adn2860-and-ad528x-pots.patch
ad525x_dpot-add-support-for-one-time-programmable-pots.patch
fbdev-bfin-lq035q1-fb-respect-new-ppi-mode-platform-field.patch

