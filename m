From: akpm@linux-foundation.org
Subject: + atmel_lcdfb-lcdc-startup-fix.patch added to -mm tree
Date: Mon, 26 Nov 2007 22:30:47 -0800
Message-ID: <200711270630.lAR6Uljk031171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48095 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716AbXK0GcC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 01:32:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anti.sullin@artecdesign.ee, adaplas@pol.net, andrew@sanpeople.com, hskinnemoen@atmel.com, nicolas.ferre@atmel.com


The patch titled
     atmel_lcdfb: LCDC startup fix
has been added to the -mm tree.  Its filename is
     atmel_lcdfb-lcdc-startup-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atmel_lcdfb: LCDC startup fix
From: Anti Sullin <anti.sullin@artecdesign.ee>

This patch adds an additional loop, that delays turning off the DMA
until the LCDC core has been turned off. This prevents the picture
to be shifted some random length when the kernel re-initializes
the LCDC.

Without this patch, the LCDC keeps running for some small time after the
PWRCON:LCD_PWR has been cleared ; the FIFO suffers an underrun and on
re-starting the LCDC the FIFO data stays shifted.

This behavior has been seen and fixed on AT91SAM9261-EK and two custom
AT91SAM9261 boards, all of them having different LCD panels.

Thanks a lot to Anti Sullin for submitting this patch (long
time ago).

Signed-off-by: Anti Sullin <anti.sullin@artecdesign.ee>
Signed-off-by: Andrew Victor <andrew@sanpeople.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-lcdc-startup-fix drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-lcdc-startup-fix
+++ a/drivers/video/atmel_lcdfb.c
@@ -268,6 +268,10 @@ static int atmel_lcdfb_set_par(struct fb
 	/* Turn off the LCD controller and the DMA controller */
 	lcdc_writel(sinfo, ATMEL_LCDC_PWRCON, sinfo->guard_time << ATMEL_LCDC_GUARDT_OFFSET);
 
+	/* Wait for the LCDC core to become idle */
+	while (lcdc_readl(sinfo, ATMEL_LCDC_PWRCON) & ATMEL_LCDC_BUSY)
+		msleep(10);
+
 	lcdc_writel(sinfo, ATMEL_LCDC_DMACON, 0);
 
 	if (info->var.bits_per_pixel == 1)
_

Patches currently in -mm which might be from anti.sullin@artecdesign.ee are

atmel_lcdfb-lcdc-startup-fix.patch
