From: akpm@linux-foundation.org
Subject: - blackfin-video-driver-update-the-bf52x-ezkit-video-framebuffer-driver-according-to-lkml-review.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:18:00 -0700
Message-ID: <200803312018.m2VKI0MP024012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756341AbYCaUTB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:19:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cooloney@kernel.org, adaplas@pol.net, geert@linux-m68k.org, michael.hennerich@analog.com, mm-commits@vger.kernel.org


The patch titled
     blackfin video driver: update the BF52x EZKIT video framebuffer driver according to LKML review
has been removed from the -mm tree.  Its filename was
     blackfin-video-driver-update-the-bf52x-ezkit-video-framebuffer-driver-according-to-lkml-review.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin video driver: update the BF52x EZKIT video framebuffer driver according to LKML review
From: Bryan Wu <cooloney@kernel.org>

- Allocate pseudo_palette together with fbinfo
- Code cleanup

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bfin-t350mcqb-fb.c |   36 +++++++++++------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff -puN drivers/video/bfin-t350mcqb-fb.c~blackfin-video-driver-update-the-bf52x-ezkit-video-framebuffer-driver-according-to-lkml-review drivers/video/bfin-t350mcqb-fb.c
--- a/drivers/video/bfin-t350mcqb-fb.c~blackfin-video-driver-update-the-bf52x-ezkit-video-framebuffer-driver-according-to-lkml-review
+++ a/drivers/video/bfin-t350mcqb-fb.c
@@ -91,6 +91,7 @@ struct bfin_t350mcqbfb_info {
 	int lq043_open_cnt;
 	int irq;
 	spinlock_t lock;	/* lock */
+	u32 pseudo_pal[16];
 };
 
 static int nocursor;
@@ -182,13 +183,13 @@ static void bfin_t350mcqb_config_dma(str
 
 }
 
-static int bfin_t350mcqb_request_ports(int action)
-{
-	u16 ppi0_req_8[] = {P_PPI0_CLK, P_PPI0_FS1, P_PPI0_FS2,
+static	u16 ppi0_req_8[] = {P_PPI0_CLK, P_PPI0_FS1, P_PPI0_FS2,
 			    P_PPI0_D0, P_PPI0_D1, P_PPI0_D2,
 			    P_PPI0_D3, P_PPI0_D4, P_PPI0_D5,
 			    P_PPI0_D6, P_PPI0_D7, 0};
 
+static int bfin_t350mcqb_request_ports(int action)
+{
 	if (action) {
 		if (peripheral_request_list(ppi0_req_8, DRIVER_NAME)) {
 			printk(KERN_ERR "Requesting Peripherals faild\n");
@@ -520,16 +521,7 @@ static int __init bfin_t350mcqb_probe(st
 
 	fbinfo->fbops = &bfin_t350mcqb_fb_ops;
 
-	fbinfo->pseudo_palette = kmalloc(sizeof(u32) * 16, GFP_KERNEL);
-	if (!fbinfo->pseudo_palette) {
-		printk(KERN_ERR DRIVER_NAME
-		       "Fail to allocate pseudo_palette\n");
-
-		ret = -ENOMEM;
-		goto out4;
-	}
-
-	memset(fbinfo->pseudo_palette, 0, sizeof(u32) * 16);
+	fbinfo->pseudo_palette = &info->pseudo_pal;
 
 	if (fb_alloc_cmap(&fbinfo->cmap, BFIN_LCD_NBR_PALETTE_ENTRIES, 0)
 	    < 0) {
@@ -537,7 +529,7 @@ static int __init bfin_t350mcqb_probe(st
 		       "Fail to allocate colormap (%d entries)\n",
 		       BFIN_LCD_NBR_PALETTE_ENTRIES);
 		ret = -EFAULT;
-		goto out5;
+		goto out4;
 	}
 
 	if (bfin_t350mcqb_request_ports(1)) {
@@ -552,11 +544,11 @@ static int __init bfin_t350mcqb_probe(st
 		goto out7;
 	}
 
-	if (request_irq(info->irq, (void *)bfin_t350mcqb_irq_error, IRQF_DISABLED,
-			"PPI ERROR", info) < 0) {
+	ret = request_irq(info->irq, bfin_t350mcqb_irq_error, IRQF_DISABLED,
+			"PPI ERROR", info);
+	if (ret < 0) {
 		printk(KERN_ERR DRIVER_NAME
 		       ": unable to request PPI ERROR IRQ\n");
-		ret = -EFAULT;
 		goto out7;
 	}
 
@@ -584,8 +576,6 @@ out7:
 	bfin_t350mcqb_request_ports(0);
 out6:
 	fb_dealloc_cmap(&fbinfo->cmap);
-out5:
-	kfree(fbinfo->pseudo_palette);
 out4:
 	dma_free_coherent(NULL, fbinfo->fix.smem_len, info->fb_buffer,
 			  info->dma_handle);
@@ -605,6 +595,8 @@ static int bfin_t350mcqb_remove(struct p
 	struct fb_info *fbinfo = platform_get_drvdata(pdev);
 	struct bfin_t350mcqbfb_info *info = fbinfo->par;
 
+	unregister_framebuffer(fbinfo);
+
 	free_dma(CH_PPI);
 	free_irq(info->irq, info);
 
@@ -612,7 +604,6 @@ static int bfin_t350mcqb_remove(struct p
 		dma_free_coherent(NULL, fbinfo->fix.smem_len, info->fb_buffer,
 				  info->dma_handle);
 
-	kfree(fbinfo->pseudo_palette);
 	fb_dealloc_cmap(&fbinfo->cmap);
 
 #ifndef NO_BL_SUPPORT
@@ -620,10 +611,11 @@ static int bfin_t350mcqb_remove(struct p
 	backlight_device_unregister(bl_dev);
 #endif
 
-	unregister_framebuffer(fbinfo);
