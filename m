From: akpm@linux-foundation.org
Subject: + imx31-eventually-fix-framebuffer-locking-regressions.patch added to -mm tree
Date: Fri, 31 Jul 2009 16:21:27 -0700
Message-ID: <200907312321.n6VNLRVi021126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416AbZGaXVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Jul 2009 19:21:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@gmx.de, krzysztof.h1@poczta.fm, s.hauer@pengutronix.de


The patch titled
     i.MX31: fix framebuffer locking regressions
has been added to the -mm tree.  Its filename is
     imx31-eventually-fix-framebuffer-locking-regressions.patch

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
Subject: i.MX31: fix framebuffer locking regressions
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Recent framebuffer locking patches first made affected systems unbootable,
then the dead-lock has been fixed but as of 2.6.31-rc4 the framebuffer on
mx3 machines doesn't work. Fix this.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mx3fb.c |   86 ++++++++++++++++++++++++++--------------
 1 file changed, 56 insertions(+), 30 deletions(-)

diff -puN drivers/video/mx3fb.c~imx31-eventually-fix-framebuffer-locking-regressions drivers/video/mx3fb.c
--- a/drivers/video/mx3fb.c~imx31-eventually-fix-framebuffer-locking-regressions
+++ a/drivers/video/mx3fb.c
@@ -669,7 +669,8 @@ static uint32_t bpp_to_pixfmt(int bpp)
 }
 
 static int mx3fb_blank(int blank, struct fb_info *fbi);
-static int mx3fb_map_video_memory(struct fb_info *fbi, unsigned int mem_len);
+static int mx3fb_map_video_memory(struct fb_info *fbi, unsigned int mem_len,
+				  bool lock);
 static int mx3fb_unmap_video_memory(struct fb_info *fbi);
 
 /**
@@ -711,12 +712,7 @@ static void mx3fb_dma_done(void *arg)
 	complete(&mx3_fbi->flip_cmpl);
 }
 
-/**
- * mx3fb_set_par() - set framebuffer parameters and change the operating mode.
- * @fbi:	framebuffer information pointer.
- * @return:	0 on success or negative error code on failure.
- */
-static int mx3fb_set_par(struct fb_info *fbi)
+static int __set_par(struct fb_info *fbi, bool lock)
 {
 	u32 mem_len;
 	struct ipu_di_signal_cfg sig_cfg;
@@ -727,10 +723,6 @@ static int mx3fb_set_par(struct fb_info 
 	struct idmac_video_param *video = &ichan->params.video;
 	struct scatterlist *sg = mx3_fbi->sg;
 
-	dev_dbg(mx3fb->dev, "%s [%c]\n", __func__, list_empty(&ichan->queue) ? '-' : '+');
-
-	mutex_lock(&mx3_fbi->mutex);
-
 	/* Total cleanup */
 	if (mx3_fbi->txd)
 		sdc_disable_channel(mx3_fbi);
@@ -742,10 +734,8 @@ static int mx3fb_set_par(struct fb_info 
 		if (fbi->fix.smem_start)
 			mx3fb_unmap_video_memory(fbi);
 
-		if (mx3fb_map_video_memory(fbi, mem_len) < 0) {
-			mutex_unlock(&mx3_fbi->mutex);
+		if (mx3fb_map_video_memory(fbi, mem_len, lock) < 0)
 			return -ENOMEM;
-		}
 	}
 
 	sg_init_table(&sg[0], 1);
@@ -791,7 +781,6 @@ static int mx3fb_set_par(struct fb_info 
 				   fbi->var.vsync_len,
 				   fbi->var.lower_margin +
 				   fbi->var.vsync_len, sig_cfg) != 0) {
-			mutex_unlock(&mx3_fbi->mutex);
 			dev_err(fbi->device,
 				"mx3fb: Error initializing panel.\n");
 			return -EINVAL;
@@ -810,9 +799,30 @@ static int mx3fb_set_par(struct fb_info 
 	if (mx3_fbi->blank == FB_BLANK_UNBLANK)
 		sdc_enable_channel(mx3_fbi);
 
+	return 0;
+}
+
+/**
+ * mx3fb_set_par() - set framebuffer parameters and change the operating mode.
+ * @fbi:	framebuffer information pointer.
+ * @return:	0 on success or negative error code on failure.
+ */
+static int mx3fb_set_par(struct fb_info *fbi)
+{
+	struct mx3fb_info *mx3_fbi = fbi->par;
+	struct mx3fb_data *mx3fb = mx3_fbi->mx3fb;
+	struct idmac_channel *ichan = mx3_fbi->idmac_channel;
+	int ret;
+
+	dev_dbg(mx3fb->dev, "%s [%c]\n", __func__, list_empty(&ichan->queue) ? '-' : '+');
+
+	mutex_lock(&mx3_fbi->mutex);
+
+	ret = __set_par(fbi, true);
+
 	mutex_unlock(&mx3_fbi->mutex);
 
-	return 0;
+	return ret;
 }
 
 /**
@@ -966,21 +976,11 @@ static int mx3fb_setcolreg(unsigned int 
 	return ret;
 }
 
-/**
- * mx3fb_blank() - blank the display.
- */
-static int mx3fb_blank(int blank, struct fb_info *fbi)
+static void __blank(int blank, struct fb_info *fbi)
 {
 	struct mx3fb_info *mx3_fbi = fbi->par;
 	struct mx3fb_data *mx3fb = mx3_fbi->mx3fb;
 
-	dev_dbg(fbi->device, "%s, blank = %d, base %p, len %u\n", __func__,
-		blank, fbi->screen_base, fbi->fix.smem_len);
-
-	if (mx3_fbi->blank == blank)
-		return 0;
-
-	mutex_lock(&mx3_fbi->mutex);
 	mx3_fbi->blank = blank;
 
 	switch (blank) {
@@ -999,6 +999,23 @@ static int mx3fb_blank(int blank, struct
 		sdc_set_brightness(mx3fb, mx3fb->backlight_level);
 		break;
 	}
+}
+
+/**
+ * mx3fb_blank() - blank the display.
+ */
+static int mx3fb_blank(int blank, struct fb_info *fbi)
+{
+	struct mx3fb_info *mx3_fbi = fbi->par;
+
+	dev_dbg(fbi->device, "%s, blank = %d, base %p, len %u\n", __func__,
+		blank, fbi->screen_base, fbi->fix.smem_len);
+
+	if (mx3_fbi->blank == blank)
+		return 0;
+
+	mutex_lock(&mx3_fbi->mutex);
+	__blank(blank, fbi);
 	mutex_unlock(&mx3_fbi->mutex);
 
 	return 0;
@@ -1198,6 +1215,7 @@ static int mx3fb_resume(struct platform_
  * mx3fb_map_video_memory() - allocates the DRAM memory for the frame buffer.
  * @fbi:	framebuffer information pointer
  * @mem_len:	length of mapped memory
+ * @lock:	do not lock during initialisation
  * @return:	Error code indicating success or failure
  *
  * This buffer is remapped into a non-cached, non-buffered, memory region to
@@ -1205,7 +1223,8 @@ static int mx3fb_resume(struct platform_
  * area is remapped, all virtual memory access to the video memory should occur
  * at the new region.
  */
-static int mx3fb_map_video_memory(struct fb_info *fbi, unsigned int mem_len)
+static int mx3fb_map_video_memory(struct fb_info *fbi, unsigned int mem_len,
+				  bool lock)
 {
 	int retval = 0;
 	dma_addr_t addr;
@@ -1221,10 +1240,12 @@ static int mx3fb_map_video_memory(struct
 		goto err0;
 	}
 
-	mutex_lock(&fbi->mm_lock);
+	if (lock)
+		mutex_lock(&fbi->mm_lock);
 	fbi->fix.smem_start = addr;
 	fbi->fix.smem_len = mem_len;
-	mutex_unlock(&fbi->mm_lock);
+	if (lock)
+		mutex_unlock(&fbi->mm_lock);
 
 	dev_dbg(fbi->device, "allocated fb @ p=0x%08x, v=0x%p, size=%d.\n",
 		(uint32_t) fbi->fix.smem_start, fbi->screen_base, fbi->fix.smem_len);
@@ -1365,6 +1386,11 @@ static int init_fb_chan(struct mx3fb_dat
 	init_completion(&mx3fbi->flip_cmpl);
 	disable_irq(ichan->eof_irq);
 	dev_dbg(mx3fb->dev, "disabling irq %d\n", ichan->eof_irq);
+	ret = __set_par(fbi, false);
+	if (ret < 0)
+		goto esetpar;
+
+	__blank(FB_BLANK_UNBLANK, fbi);
 
 	dev_info(dev, "registered, using mode %s\n", fb_mode);
 
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

linux-next.patch
imx31-eventually-fix-framebuffer-locking-regressions.patch
imx31-fix-framebuffer-locking-regressions.patch
mmc-make-the-configuration-memory-resource-optional.patch
tmio_mmc-optionally-support-using-platform-clock.patch
sh-switch-migo-r-to-use-the-tmio-mmc-driver-instead-of-spi.patch
spi-remove-imx-spi-driver.patch
spi-add-spi-driver-for-most-known-imx-socs.patch

