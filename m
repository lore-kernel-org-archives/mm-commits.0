From: akpm@linux-foundation.org
Subject: + imxfb-remove-ifdefs.patch added to -mm tree
Date: Thu, 17 May 2007 12:00:34 -0700
Message-ID: <200705171900.l4HJ0YOB030605@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47931 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756519AbXEQTCa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 15:02:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: s.hauer@pengutronix.de, adaplas@gmail.com


The patch titled
     imxfb: remove ifdefs
has been added to the -mm tree.  Its filename is
     imxfb-remove-ifdefs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: imxfb: remove ifdefs
From: Sascha Hauer <s.hauer@pengutronix.de>

Here are some small fixes for the imxfb framebuffer driver:

- remove ifndef for MX1FS2 platform which is not present in the kernel.
- REV, CLS, PS and SPL_SPR are only needed with some sharp displays.
  Only setup the corresponding io pins when such a display is connected.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/imxfb.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff -puN drivers/video/imxfb.c~imxfb-remove-ifdefs drivers/video/imxfb.c
--- a/drivers/video/imxfb.c~imxfb-remove-ifdefs
+++ a/drivers/video/imxfb.c
@@ -394,26 +394,18 @@ static void imxfb_setup_gpio(struct imxf
 
 	/* initialize GPIOs */
 	imx_gpio_mode(PD6_PF_LSCLK);
-	imx_gpio_mode(PD10_PF_SPL_SPR);
 	imx_gpio_mode(PD11_PF_CONTRAST);
 	imx_gpio_mode(PD14_PF_FLM_VSYNC);
 	imx_gpio_mode(PD13_PF_LP_HSYNC);
-	imx_gpio_mode(PD7_PF_REV);
-	imx_gpio_mode(PD8_PF_CLS);
-
-#ifndef CONFIG_MACH_PIMX1
-	/* on PiMX1 used as buffers enable signal
-	 */
-	imx_gpio_mode(PD9_PF_PS);
-#endif
-
-#ifndef CONFIG_MACH_MX1FS2
-	/* on mx1fs2 this pin is used to (de)activate the display, so we need
-	 * it as a normal gpio
-	 */
 	imx_gpio_mode(PD12_PF_ACD_OE);
-#endif
 
+	/* These are only needed for Sharp HR TFT displays */
+	if (fbi->pcr & PCR_SHARP) {
+		imx_gpio_mode(PD7_PF_REV);
+		imx_gpio_mode(PD8_PF_CLS);
+		imx_gpio_mode(PD9_PF_PS);
+		imx_gpio_mode(PD10_PF_SPL_SPR);
+	}
 }
 
 #ifdef CONFIG_PM
@@ -499,6 +491,7 @@ static int __init imxfb_init_fbinfo(stru
 	info->var.sync			= inf->sync;
 	info->var.grayscale		= inf->cmap_greyscale;
 	fbi->cmap_inverse		= inf->cmap_inverse;
+	fbi->cmap_static		= inf->cmap_static;
 	fbi->pcr			= inf->pcr;
 	fbi->lscr1			= inf->lscr1;
 	fbi->dmacr			= inf->dmacr;
_

Patches currently in -mm which might be from s.hauer@pengutronix.de are

imxfb-remove-ifdefs.patch
imxfb-fix-memory-hole.patch
