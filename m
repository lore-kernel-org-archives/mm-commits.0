From: akpm@linux-foundation.org
Subject: - vga16fb-restrict-to-blit-rectangles-with-widths-of.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:39 -0700
Message-ID: <200705090301.l4931dcO010731@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033223AbXEIDBl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vga16fb: restrict to blit rectangles with widths of multiples of 8 pixels
has been removed from the -mm tree.  Its filename was
     vga16fb-restrict-to-blit-rectangles-with-widths-of.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vga16fb: restrict to blit rectangles with widths of multiples of 8 pixels
From: "Antonino A. Daplas" <adaplas@gmail.com>

Advertise that vga16fb can only handle widths that are 8-pixel-multiple only
(software limitation). To ensure that a legal font is available, SELECT an
8x16 font in Kconfig.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig   |    1 +
 drivers/video/vga16fb.c |    2 ++
 2 files changed, 3 insertions(+)

diff -puN drivers/video/Kconfig~vga16fb-restrict-to-blit-rectangles-with-widths-of drivers/video/Kconfig
--- a/drivers/video/Kconfig~vga16fb-restrict-to-blit-rectangles-with-widths-of
+++ a/drivers/video/Kconfig
@@ -519,6 +519,7 @@ config FB_VGA16
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	select VGASTATE
+	select FONT_8x16 if FRAMEBUFFER_CONSOLE
 	help
 	  This is the frame buffer device driver for VGA 16 color graphic
 	  cards. Say Y if you have such a card.
diff -puN drivers/video/vga16fb.c~vga16fb-restrict-to-blit-rectangles-with-widths-of drivers/video/vga16fb.c
--- a/drivers/video/vga16fb.c~vga16fb-restrict-to-blit-rectangles-with-widths-of
+++ a/drivers/video/vga16fb.c
@@ -1378,6 +1378,8 @@ static int __init vga16fb_probe(struct p
 	info->fbops = &vga16fb_ops;
 	info->var = vga16fb_defined;
 	info->fix = vga16fb_fix;
+	/* supports 8-pixel wide blit rectangles only */
+	info->pixmap.blit_x = 1 << (8 - 1);
 	info->flags = FBINFO_FLAG_DEFAULT |
 		FBINFO_HWACCEL_YPAN;
 
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
