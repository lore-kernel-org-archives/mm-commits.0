From: akpm@linux-foundation.org
Subject: - imxfb-fast-read-flag-and-nonstandard-field-configurable.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:45:22 -0700
Message-ID: <200710162045.l9GKjMOs016258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44413 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965802AbXJPU5H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:57:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pisa@cmp.felk.cvut.cz, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     imxfb: fast read flag and nonstandard field configurable
has been removed from the -mm tree.  Its filename was
     imxfb-fast-read-flag-and-nonstandard-field-configurable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: imxfb: fast read flag and nonstandard field configurable
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>

The i.MX frame-buffer read operation should be faster for all configurations
then drawing each individual character again in response to scroll events.

The nonstandard fields allows to configure frame-buffer special options flags
for different display configurations by board specific initialization code.

One of such specific options is reversed order of pixels in each individual
byte.  i.MX frame-buffer seems to be designed for big-endian use first.  The
byte order is correctly configured for little-endian ordering, but if 1, 2 or
4 bits per pixel are used, pixels ordering is incompatible to Linux generic
frame-buffer drawing functions.

The patch "Allow generic BitBLT functions to work with swapped pixel order in
bytes" introduces required functionality into FBDEV core.  The pixels ordering
selection has to be enabled at compile time CONFIG_FB_CFB_REV_PIXELS_IN_BYTE
and for each display configuration which requires it by flag
FB_NONSTD_REV_PIX_IN_B in "nonstd" field of info structure.

This patch provides way for board specific code to select this option.

Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/imxfb.c            |    3 ++-
 include/asm-arm/arch-imx/imxfb.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/imxfb.c~imxfb-fast-read-flag-and-nonstandard-field-configurable drivers/video/imxfb.c
--- a/drivers/video/imxfb.c~imxfb-fast-read-flag-and-nonstandard-field-configurable
+++ a/drivers/video/imxfb.c
@@ -466,7 +466,7 @@ static int __init imxfb_init_fbinfo(stru
 	info->var.vmode	= FB_VMODE_NONINTERLACED;
 
 	info->fbops			= &imxfb_ops;
-	info->flags			= FBINFO_FLAG_DEFAULT;
+	info->flags			= FBINFO_FLAG_DEFAULT | FBINFO_READS_FAST;
 
 	fbi->rgb[RGB_16]		= &def_rgb_16;
 	fbi->rgb[RGB_8]			= &def_rgb_8;
@@ -479,6 +479,7 @@ static int __init imxfb_init_fbinfo(stru
 	info->var.yres_virtual		= inf->yres;
 	fbi->max_bpp			= inf->bpp;
 	info->var.bits_per_pixel	= inf->bpp;
+	info->var.nonstd		= inf->nonstd;
 	info->var.pixclock		= inf->pixclock;
 	info->var.hsync_len		= inf->hsync_len;
 	info->var.left_margin		= inf->left_margin;
diff -puN include/asm-arm/arch-imx/imxfb.h~imxfb-fast-read-flag-and-nonstandard-field-configurable include/asm-arm/arch-imx/imxfb.h
--- a/include/asm-arm/arch-imx/imxfb.h~imxfb-fast-read-flag-and-nonstandard-field-configurable
+++ a/include/asm-arm/arch-imx/imxfb.h
@@ -7,6 +7,7 @@ struct imxfb_mach_info {
 	u_short		xres;
 	u_short		yres;
 
+	u_int		nonstd;
 	u_char		bpp;
 	u_char		hsync_len;
 	u_char		left_margin;
_

Patches currently in -mm which might be from pisa@cmp.felk.cvut.cz are

origin.patch
