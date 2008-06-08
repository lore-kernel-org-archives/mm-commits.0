From: akpm@linux-foundation.org
Subject: + atmel_lcdfb-avoid-division-by-zero.patch added to -mm tree
Date: Sun, 08 Jun 2008 14:04:04 -0700
Message-ID: <200806082104.m58L44TR020403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902AbYFHVEl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 17:04:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, adaplas@pol.net, hskinnemoen@atmel.com, krzysztof.h1@poczta.fm, linux@maxim.org.za


The patch titled
     atmel_lcdfb: avoid division by zero
has been added to the -mm tree.  Its filename is
     atmel_lcdfb-avoid-division-by-zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_lcdfb: avoid division by zero
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Avoid division by zero in  atmel_lcdfb_check_var() function.

If pixclock is not specified while passing a var structure in
the check_var() funtion, a division by zero occurs (when
translating pixclock to KHz).

This patch adds a checking of this value and try to choose a
video mode in the modelist.

The mode found in the probe function in added to the modelist.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |   36 ++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-avoid-division-by-zero drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-avoid-division-by-zero
+++ a/drivers/video/atmel_lcdfb.c
@@ -256,6 +256,21 @@ static int atmel_lcdfb_alloc_video_memor
 	return 0;
 }
 
+static const struct fb_videomode *atmel_lcdfb_choose_mode(struct fb_var_screeninfo *var,
+						     struct fb_info *info)
+{
+	struct fb_videomode varfbmode;
+	const struct fb_videomode *fbmode = NULL;
+
+	fb_var_to_videomode(&varfbmode, var);
+	fbmode = fb_find_nearest_mode(&varfbmode, &info->modelist);
+	if (fbmode) {
+		fb_videomode_to_var(var, fbmode);
+	}
+	return fbmode;
+}
+
+
 /**
  *      atmel_lcdfb_check_var - Validates a var passed in.
  *      @var: frame buffer variable screen structure
@@ -289,6 +304,15 @@ static int atmel_lcdfb_check_var(struct 
 	clk_value_khz = clk_get_rate(sinfo->lcdc_clk) / 1000;
 
 	dev_dbg(dev, "%s:\n", __func__);
+
+	if (!(var->pixclock && var->bits_per_pixel)) {
+		/* choose a suitable mode if possible */
+		if (!atmel_lcdfb_choose_mode(var, info)) {
+			dev_err(dev, "needed value not specified\n");
+			return -EINVAL;
+		}
+	}
+
 	dev_dbg(dev, "  resolution: %ux%u\n", var->xres, var->yres);
 	dev_dbg(dev, "  pixclk:     %lu KHz\n", PICOS2KHZ(var->pixclock));
 	dev_dbg(dev, "  bpp:        %u\n", var->bits_per_pixel);
@@ -299,6 +323,13 @@ static int atmel_lcdfb_check_var(struct 
 		return -EINVAL;
 	}
 
+	/* Do not allow to have real resoulution larger than virtual */
+	if (var->xres > var->xres_virtual)
+		var->xres_virtual = var->xres;
+
+	if (var->yres > var->yres_virtual)
+		var->yres_virtual = var->yres;
+
 	/* Force same alignment for each line */
 	var->xres = (var->xres + 3) & ~3UL;
 	var->xres_virtual = (var->xres_virtual + 3) & ~3UL;
@@ -740,6 +771,7 @@ static int __init atmel_lcdfb_probe(stru
 	struct fb_info *info;
 	struct atmel_lcdfb_info *sinfo;
 	struct atmel_lcdfb_info *pdata_sinfo;
+	struct fb_videomode fbmode;
 	struct resource *regs = NULL;
 	struct resource *map = NULL;
 	int ret;
@@ -906,6 +938,10 @@ static int __init atmel_lcdfb_probe(stru
 		goto free_cmap;
 	}
 
+	/* add selected videomode to modelist */
+	fb_var_to_videomode(&fbmode, &info->var);
+	fb_add_videomode(&fbmode, &info->modelist);
+
 	/* Power up the LCDC screen */
 	if (sinfo->atmel_lcdfb_power_control)
 		sinfo->atmel_lcdfb_power_control(1);
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

linux-next.patch
atmel_lcdfb-fifo-underflow-management.patch
atmel_lcdfb-fifo-underflow-management-rework.patch
atmel_lcdfb-avoid-division-by-zero.patch

