From: akpm@linux-foundation.org
Subject: + fbdev-bfin-t350mcqb-fb-fix-fbmem-allocation-with-blanking-lines.patch added to -mm tree
Date: Mon, 10 May 2010 15:07:40 -0700
Message-ID: <201005102207.o4AM7e3Z025422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756239Ab0EJWIE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 May 2010 18:08:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, stable@kernel.org, vapier@gentoo.org


The patch titled
     fbdev: bfin-t350mcqb-fb: fix fbmem allocation with blanking lines
has been added to the -mm tree.  Its filename is
     fbdev-bfin-t350mcqb-fb-fix-fbmem-allocation-with-blanking-lines.patch

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

fbdev-bfin-t350mcqb-fb-fix-fbmem-allocation-with-blanking-lines.patch
linux-next.patch
backlight-new-driver-for-the-adp8860-backlight-parts.patch
fbdev-bfin-lq035q1-fb-respect-new-ppi-mode-platform-field.patch

