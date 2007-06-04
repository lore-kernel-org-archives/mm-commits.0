From: akpm@linux-foundation.org
Subject: + gbefb-the-pseudo_palette-is-only-16-elements-long.patch added to -mm tree
Date: Mon, 04 Jun 2007 13:40:16 -0700
Message-ID: <200706042040.l54KeGi5018414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47373 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753219AbXFDUk1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 16:40:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     gbefb: the pseudo_palette is only 16 elements long
has been added to the -mm tree.  Its filename is
     gbefb-the-pseudo_palette-is-only-16-elements-long.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: gbefb: the pseudo_palette is only 16 elements long
From: "Antonino A. Daplas" <adaplas@gmail.com>

The pseudo_palette is only 16 elements long.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/gbefb.c |   41 ++++++++++++++++++++--------------------
 1 files changed, 21 insertions(+), 20 deletions(-)

diff -puN drivers/video/gbefb.c~gbefb-the-pseudo_palette-is-only-16-elements-long drivers/video/gbefb.c
--- a/drivers/video/gbefb.c~gbefb-the-pseudo_palette-is-only-16-elements-long
+++ a/drivers/video/gbefb.c
@@ -86,7 +86,7 @@ static int gbe_revision;
 
 static int ypan, ywrap;
 
-static uint32_t pseudo_palette[256];
+static uint32_t pseudo_palette[16];
 
 static char *mode_option __initdata = NULL;
 
@@ -854,8 +854,7 @@ static int gbefb_setcolreg(unsigned regn
 	green >>= 8;
 	blue >>= 8;
 
-	switch (info->var.bits_per_pixel) {
-	case 8:
+	if (info->var.bits_per_pixel <= 8) {
 		/* wait for the color map FIFO to have a free entry */
 		for (i = 0; i < 1000 && gbe->cm_fifo >= 63; i++)
 			udelay(10);
@@ -864,23 +863,25 @@ static int gbefb_setcolreg(unsigned regn
 			return 1;
 		}
 		gbe->cmap[regno] = (red << 24) | (green << 16) | (blue << 8);
-		break;
-	case 15:
-	case 16:
-		red >>= 3;
-		green >>= 3;
-		blue >>= 3;
-		pseudo_palette[regno] =
-			(red << info->var.red.offset) |
-			(green << info->var.green.offset) |
-			(blue << info->var.blue.offset);
-		break;
-	case 32:
-		pseudo_palette[regno] =
-			(red << info->var.red.offset) |
-			(green << info->var.green.offset) |
-			(blue << info->var.blue.offset);
-		break;
+	} else if (regno < 16) {
+		switch (info->var.bits_per_pixel) {
+		case 15:
+		case 16:
+			red >>= 3;
+			green >>= 3;
+			blue >>= 3;
+			pseudo_palette[regno] =
+				(red << info->var.red.offset) |
+				(green << info->var.green.offset) |
+				(blue << info->var.blue.offset);
+			break;
+		case 32:
+			pseudo_palette[regno] =
+				(red << info->var.red.offset) |
+				(green << info->var.green.offset) |
+				(blue << info->var.blue.offset);
+			break;
+		}
 	}
 
 	return 0;
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
fbcon-smart-blitter-usage-for-scrolling.patch
nvidiafb-adjust-flags-to-take-advantage-of-new-scroll-method.patch
fbcon-cursor-blink-control.patch
fbcon-use-struct-device-instead-of-struct-class_device.patch
fbdev-move-arch-specific-bits-to-their-respective.patch
fbdev-detect-primary-display-device.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix-2.patch
radeonfb-add-support-for-radeon-xpress-200m-rs485.patch
nvidiafb-add-proper-support-for-geforce-7600-chipset.patch
pm2fb-white-spaces-clean-up.patch
fbcon-set_con2fb_map-fixes.patch
fbcon-revise-primary-device-selection.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer-fix.patch
vt-add-comment-for-unbind_con_driver.patch
68328fb-the-pseudo_palette-is-only-16-elements-long.patch
controlfb-the-pseudo_palette-is-only-16-elements-long.patch
cyblafb-fix-pseudo_palette-array-overrun-in-setcolreg.patch
epson1355fb-color-setting-fixes.patch
ffb-the-pseudo_palette-is-only-16-elements-long.patch
fm2fb-the-pseudo_palette-is-only-16-elements-long.patch
gbefb-the-pseudo_palette-is-only-16-elements-long.patch
macfb-fix-pseudo_palette-size-and-overrun.patch
offb-the-pseudo_palette-is-only-16-elements-long.patch
platinumfb-the-pseudo_palette-is-only-16-elements.patch
pvr2fb-fix-pseudo_palette-array-overrun-and-typecast.patch
q40fb-the-pseudo_palette-is-only-16-elements-long.patch
sgivwfb-the-pseudo_palette-is-only-16-elements-long.patch
sunxvr2500fb-fix-pseudo_palette-array-size.patch
sunxvr500fb-fix-pseudo_palette-array-size.patch
tgafb-actually-allocate-memory-for-the-pseudo_palette.patch
tridentfb-fix-pseudo_palette-array-overrun-in-setcolreg.patch
tx3912fb-fix-improper-assignment-of-info-pseudo_palette.patch
atyfb-the-pseudo_palette-is-only-16-elements-long.patch
radeonfb-the-pseudo_palette-is-only-16-elements-long.patch
i810fb-the-pseudo_palette-is-only-16-elements-long.patch
intelfb-the-pseudo_palette-is-only-16-elements-long.patch
sisfb-fix-pseudo_palette-array-size-and-overrun.patch
