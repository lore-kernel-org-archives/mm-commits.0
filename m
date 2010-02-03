From: akpm@linux-foundation.org
Subject: [merged] mx3fb-some-debug-and-initialisation-fixes.patch removed from -mm tree
Date: Wed, 03 Feb 2010 09:54:37 -0800
Message-ID: <201002031754.o13Hsb3V008902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932778Ab0BCRz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 12:55:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maramaopercheseimorto@gmail.com, s.hauer@pengutronix.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mx3fb: some debug and initialisation fixes
has been removed from the -mm tree.  Its filename was
     mx3fb-some-debug-and-initialisation-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mx3fb: some debug and initialisation fixes
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>

Fix the kernel oops when dev_dbg is called with mx3_fbi->txd == NULL

Fix the late initialisation of mx3fb->backlight_level.  If not, in the
chain of function started by init_fb_chan(), in __blank() call
sdc_set_brightness(mx3fb, mx3fb->backlight_level) that will shut down the
CONTRAST PWM output.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Acked-by: Guennadi Liakhovetski <g.liakhovetski <at> gmx.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mx3fb.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/video/mx3fb.c~mx3fb-some-debug-and-initialisation-fixes drivers/video/mx3fb.c
--- a/drivers/video/mx3fb.c~mx3fb-some-debug-and-initialisation-fixes
+++ a/drivers/video/mx3fb.c
@@ -324,8 +324,11 @@ static void sdc_enable_channel(struct mx
 	unsigned long flags;
 	dma_cookie_t cookie;
 
-	dev_dbg(mx3fb->dev, "mx3fbi %p, desc %p, sg %p\n", mx3_fbi,
-		to_tx_desc(mx3_fbi->txd), to_tx_desc(mx3_fbi->txd)->sg);
+	if (mx3_fbi->txd)
+		dev_dbg(mx3fb->dev, "mx3fbi %p, desc %p, sg %p\n", mx3_fbi,
+			to_tx_desc(mx3_fbi->txd), to_tx_desc(mx3_fbi->txd)->sg);
+	else
+		dev_dbg(mx3fb->dev, "mx3fbi %p, txd = NULL\n", mx3_fbi);
 
 	/* This enables the channel */
 	if (mx3_fbi->cookie < 0) {
@@ -646,6 +649,7 @@ static int sdc_set_global_alpha(struct m
 
 static void sdc_set_brightness(struct mx3fb_data *mx3fb, uint8_t value)
 {
+	dev_dbg(mx3fb->dev, "%s: value = %d\n", __func__, value);
 	/* This might be board-specific */
 	mx3fb_write_reg(mx3fb, 0x03000000UL | value << 16, SDC_PWM_CTRL);
 	return;
@@ -1486,12 +1490,12 @@ static int mx3fb_probe(struct platform_d
 		goto ersdc0;
 	}
 
+	mx3fb->backlight_level = 255;
+
 	ret = init_fb_chan(mx3fb, to_idmac_chan(chan));
 	if (ret < 0)
 		goto eisdc0;
 
-	mx3fb->backlight_level = 255;
