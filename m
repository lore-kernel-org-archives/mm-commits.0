From: akpm@linux-foundation.org
Subject: [merged] atmel_lcdfb-new-alternate-pixel-clock-formula.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:26:40 -0800
Message-ID: <200911131926.nADJQeLP028784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932128AbZKMT0l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:26:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@atmel.com, hskinnemoen@atmel.com, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     atmel_lcdfb: new alternate pixel clock formula
has been removed from the -mm tree.  Its filename was
     atmel_lcdfb-new-alternate-pixel-clock-formula.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_lcdfb: new alternate pixel clock formula
From: Nicolas Ferre <nicolas.ferre@atmel.com>

at91sam9g45 non ES lots have an alternate pixel clock calculation formula.
Introduce this one with condition on the cpu_is_xxxxx() macros.

Newer 9g45 SOC will not have good pixel clock calculation without this
fix.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-new-alternate-pixel-clock-formula drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-new-alternate-pixel-clock-formula
+++ a/drivers/video/atmel_lcdfb.c
@@ -484,6 +484,7 @@ static int atmel_lcdfb_set_par(struct fb
 	unsigned long value;
 	unsigned long clk_value_khz;
 	unsigned long bits_per_line;
+	unsigned long pix_factor = 2;
 
 	might_sleep();
 
@@ -516,20 +517,24 @@ static int atmel_lcdfb_set_par(struct fb
 	/* Now, the LCDC core... */
 
 	/* Set pixel clock */
+	if (cpu_is_at91sam9g45() && !cpu_is_at91sam9g45es())
+		pix_factor = 1;
+
 	clk_value_khz = clk_get_rate(sinfo->lcdc_clk) / 1000;
 
 	value = DIV_ROUND_UP(clk_value_khz, PICOS2KHZ(info->var.pixclock));
 
-	if (value < 2) {
+	if (value < pix_factor) {
 		dev_notice(info->device, "Bypassing pixel clock divider\n");
 		lcdc_writel(sinfo, ATMEL_LCDC_LCDCON1, ATMEL_LCDC_BYPASS);
 	} else {
-		value = (value / 2) - 1;
+		value = (value / pix_factor) - 1;
 		dev_dbg(info->device, "  * programming CLKVAL = 0x%08lx\n",
 				value);
 		lcdc_writel(sinfo, ATMEL_LCDC_LCDCON1,
 				value << ATMEL_LCDC_CLKVAL_OFFSET);
-		info->var.pixclock = KHZ2PICOS(clk_value_khz / (2 * (value + 1)));
+		info->var.pixclock =
+			KHZ2PICOS(clk_value_khz / (pix_factor * (value + 1)));
 		dev_dbg(info->device, "  updated pixclk:     %lu KHz\n",
 					PICOS2KHZ(info->var.pixclock));
 	}
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

linux-next.patch
atmel-mci-change-use-of-dma-slave-interface.patch
mmc-atmel-mci-new-mci2-module-support-in-atmel-mci-driver.patch

