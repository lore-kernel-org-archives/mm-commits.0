From: akpm@linux-foundation.org
Subject: + fbdev-imx31-fix-panning-error-handling-clean-up.patch added to -mm tree
Date: Wed, 01 Apr 2009 12:53:16 -0700
Message-ID: <200904011953.n31JrG62030329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018AbZDAT41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:56:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lg@denx.de, dan.j.williams@intel.com, krzysztof.h1@poczta.fm, s.hauer@pengutronix.de


The patch titled
     fbdev: i.MX31: fix panning, error handling, clean up
has been added to the -mm tree.  Its filename is
     fbdev-imx31-fix-panning-error-handling-clean-up.patch

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
Subject: fbdev: i.MX31: fix panning, error handling, clean up
From: Guennadi Liakhovetski <lg@denx.de>

1. check for errors returned from clk_get()
2. fix "Unbalanced enable for IRQ 160"
3. fix transmit descriptor handling in panning
4. clean frame buffer on blank - useful for OLED displays
5. formatting clean up

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mx3fb.c |   56 ++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff -puN drivers/video/mx3fb.c~fbdev-imx31-fix-panning-error-handling-clean-up drivers/video/mx3fb.c
--- a/drivers/video/mx3fb.c~fbdev-imx31-fix-panning-error-handling-clean-up
+++ a/drivers/video/mx3fb.c
@@ -400,12 +400,12 @@ static void sdc_disable_channel(struct m
 static int sdc_set_window_pos(struct mx3fb_data *mx3fb, enum ipu_channel channel,
 			      int16_t x_pos, int16_t y_pos)
 {
-	x_pos += mx3fb->h_start_width;
-	y_pos += mx3fb->v_start_width;
-
 	if (channel != IDMAC_SDC_0)
 		return -EINVAL;
 
+	x_pos += mx3fb->h_start_width;
+	y_pos += mx3fb->v_start_width;
+
 	mx3fb_write_reg(mx3fb, (x_pos << 16) | y_pos, SDC_BG_POS);
 	return 0;
 }
@@ -491,11 +491,13 @@ static int sdc_init_panel(struct mx3fb_d
 	 * 2^4 to get fractional part, as long as we stay under ~250MHz and on
 	 * i.MX31 it (HSP_CLK) is <= 178MHz. Currently 128.267MHz
 	 */
-	dev_dbg(mx3fb->dev, "pixel clk = %d\n", pixel_clk);
-
 	ipu_clk = clk_get(mx3fb->dev, NULL);
-	div = clk_get_rate(ipu_clk) * 16 / pixel_clk;
-	clk_put(ipu_clk);
+	if (!IS_ERR(ipu_clk)) {
+		div = clk_get_rate(ipu_clk) * 16 / pixel_clk;
+		clk_put(ipu_clk);
+	} else {
+		div = 0;
+	}
 
 	if (div < 0x40) {	/* Divider less than 4 */
 		dev_dbg(mx3fb->dev,
@@ -503,6 +505,9 @@ static int sdc_init_panel(struct mx3fb_d
 		div = 0x40;
 	}
 
+	dev_dbg(mx3fb->dev, "pixel clk = %u, divider %u.%u\n",
+		pixel_clk, div >> 4, (div & 7) * 125);
+
 	spin_lock_irqsave(&mx3fb->lock, lock_flags);
 
 	/*
@@ -515,16 +520,16 @@ static int sdc_init_panel(struct mx3fb_d
 	/* DI settings */
 	old_conf = mx3fb_read_reg(mx3fb, DI_DISP_IF_CONF) & 0x78FFFFFF;
 	old_conf |= sig.datamask_en << DI_D3_DATAMSK_SHIFT |
-	    sig.clksel_en << DI_D3_CLK_SEL_SHIFT |
-	    sig.clkidle_en << DI_D3_CLK_IDLE_SHIFT;
+		sig.clksel_en << DI_D3_CLK_SEL_SHIFT |
+		sig.clkidle_en << DI_D3_CLK_IDLE_SHIFT;
 	mx3fb_write_reg(mx3fb, old_conf, DI_DISP_IF_CONF);
 
 	old_conf = mx3fb_read_reg(mx3fb, DI_DISP_SIG_POL) & 0xE0FFFFFF;
 	old_conf |= sig.data_pol << DI_D3_DATA_POL_SHIFT |
-	    sig.clk_pol << DI_D3_CLK_POL_SHIFT |
-	    sig.enable_pol << DI_D3_DRDY_SHARP_POL_SHIFT |
-	    sig.Hsync_pol << DI_D3_HSYNC_POL_SHIFT |
-	    sig.Vsync_pol << DI_D3_VSYNC_POL_SHIFT;
+		sig.clk_pol << DI_D3_CLK_POL_SHIFT |
+		sig.enable_pol << DI_D3_DRDY_SHARP_POL_SHIFT |
+		sig.Hsync_pol << DI_D3_HSYNC_POL_SHIFT |
+		sig.Vsync_pol << DI_D3_VSYNC_POL_SHIFT;
 	mx3fb_write_reg(mx3fb, old_conf, DI_DISP_SIG_POL);
 
 	switch (pixel_fmt) {
@@ -721,7 +726,6 @@ static int mx3fb_set_par(struct fb_info 
 	struct idmac_channel *ichan = mx3_fbi->idmac_channel;
 	struct idmac_video_param *video = &ichan->params.video;
 	struct scatterlist *sg = mx3_fbi->sg;
-	size_t screen_size;
 
 	dev_dbg(mx3fb->dev, "%s [%c]\n", __func__, list_empty(&ichan->queue) ? '-' : '+');
 
@@ -745,12 +749,10 @@ static int mx3fb_set_par(struct fb_info 
 		}
 	}
 
-	screen_size = fbi->fix.line_length * fbi->var.yres;
-
 	sg_init_table(&sg[0], 1);
 	sg_init_table(&sg[1], 1);
 
-	sg_dma_address(&sg[0])	= fbi->fix.smem_start;
+	sg_dma_address(&sg[0]) = fbi->fix.smem_start;
 	sg_set_page(&sg[0], virt_to_page(fbi->screen_base),
 		    fbi->fix.smem_len,
 		    offset_in_page(fbi->screen_base));
@@ -927,7 +929,7 @@ static int mx3fb_setcolreg(unsigned int 
 	u32 val;
 	int ret = 1;
 
-	dev_dbg(fbi->device, "%s\n", __func__);
+	dev_dbg(fbi->device, "%s, regno = %u\n", __func__, regno);
 
 	mutex_lock(&mx3_fbi->mutex);
 	/*
@@ -973,9 +975,8 @@ static int mx3fb_blank(int blank, struct
 	struct mx3fb_info *mx3_fbi = fbi->par;
 	struct mx3fb_data *mx3fb = mx3_fbi->mx3fb;
 
-	dev_dbg(fbi->device, "%s\n", __func__);
-
-	dev_dbg(fbi->device, "blank = %d\n", blank);
+	dev_dbg(fbi->device, "%s, blank = %d, base %p, len %u\n", __func__,
+		blank, fbi->screen_base, fbi->fix.smem_len);
 
 	if (mx3_fbi->blank == blank)
 		return 0;
@@ -988,8 +989,11 @@ static int mx3fb_blank(int blank, struct
 	case FB_BLANK_VSYNC_SUSPEND:
 	case FB_BLANK_HSYNC_SUSPEND:
 	case FB_BLANK_NORMAL:
-		sdc_disable_channel(mx3_fbi);
 		sdc_set_brightness(mx3fb, 0);
+		memset((char *)fbi->screen_base, 0, fbi->fix.smem_len);
+		/* Give LCD time to update - enough for 50 and 60 Hz */
+		msleep(25);
+		sdc_disable_channel(mx3_fbi);
 		break;
 	case FB_BLANK_UNBLANK:
 		sdc_enable_channel(mx3_fbi);
@@ -1063,6 +1067,7 @@ static int mx3fb_pan_display(struct fb_v
 		mutex_unlock(&mx3_fbi->mutex);
 		dev_info(fbi->device, "Panning failed due to %s\n", ret < 0 ?
 			 "user interrupt" : "timeout");
+		disable_irq(mx3_fbi->idmac_channel->eof_irq);
 		return ret ? : -ETIMEDOUT;
 	}
 
@@ -1073,6 +1078,9 @@ static int mx3fb_pan_display(struct fb_v
 		    virt_to_page(fbi->screen_base + offset), fbi->fix.smem_len,
 		    offset_in_page(fbi->screen_base + offset));
 
+	if (mx3_fbi->txd)
+		async_tx_ack(mx3_fbi->txd);
+
 	txd = dma_chan->device->device_prep_slave_sg(dma_chan, sg +
 		mx3_fbi->cur_ipu_buf, 1, DMA_TO_DEVICE, DMA_PREP_INTERRUPT);
 	if (!txd) {
@@ -1099,8 +1107,6 @@ static int mx3fb_pan_display(struct fb_v
 		return -EIO;
 	}
 
-	if (mx3_fbi->txd)
-		async_tx_ack(mx3_fbi->txd);
 	mx3_fbi->txd = txd;
 
 	fbi->var.xoffset = var->xoffset;
@@ -1506,7 +1512,7 @@ static struct platform_driver mx3fb_driv
  * example:
  * 	video=mx3fb:bpp=16
  */
-static int mx3fb_setup(void)
+static int __init mx3fb_setup(void)
 {
 #ifndef MODULE
 	char *opt, *options = NULL;
_

Patches currently in -mm which might be from lg@denx.de are

origin.patch
linux-next.patch
fbdev-imx31-fix-panning-error-handling-clean-up.patch

