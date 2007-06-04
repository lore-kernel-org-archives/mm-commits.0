From: akpm@linux-foundation.org
Subject: + macfb-fix-pseudo_palette-size-and-overrun.patch added to -mm tree
Date: Mon, 04 Jun 2007 13:40:19 -0700
Message-ID: <200706042040.l54KeJpX018417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44738 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753372AbXFDUki (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 16:40:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     macfb: fix pseudo_palette size and overrun
has been added to the -mm tree.  Its filename is
     macfb-fix-pseudo_palette-size-and-overrun.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: macfb: fix pseudo_palette size and overrun
From: "Antonino A. Daplas" <adaplas@gmail.com>

- the pseudo_palette is only 16 elements long.
- do not write to the pseudo_palette if regno (array index) is more than 15.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/macfb.c |   93 +++++++++++++++++++++-------------------
 1 files changed, 50 insertions(+), 43 deletions(-)

diff -puN drivers/video/macfb.c~macfb-fix-pseudo_palette-size-and-overrun drivers/video/macfb.c
--- a/drivers/video/macfb.c~macfb-fix-pseudo_palette-size-and-overrun
+++ a/drivers/video/macfb.c
@@ -170,7 +170,7 @@ static struct fb_fix_screeninfo macfb_fi
 };
 
 static struct fb_info fb_info;
-static u32 pseudo_palette[17];
+static u32 pseudo_palette[16];
 static int inverse   = 0;
 static int vidtest   = 0;
 
@@ -529,56 +529,63 @@ static int macfb_setcolreg(unsigned regn
 	if (regno >= fb_info->cmap.len)
 		return 1;
 
-	switch (fb_info->var.bits_per_pixel) {
-	case 1:
-		/* We shouldn't get here */
-		break;
-	case 2:
-	case 4:
-	case 8:
-		if (macfb_setpalette)
-			macfb_setpalette(regno, red, green, blue, fb_info);
-		else
-			return 1;
-		break;
-	case 16:
-		if (fb_info->var.red.offset == 10) {
-			/* 1:5:5:5 */
-			((u32*) (fb_info->pseudo_palette))[regno] =
+	if (fb_info->var.bits_per_pixel <= 8) {
+		switch (fb_info->var.bits_per_pixel) {
+		case 1:
+			/* We shouldn't get here */
+			break;
+		case 2:
+		case 4:
+		case 8:
+			if (macfb_setpalette)
+				macfb_setpalette(regno, red, green, blue,
+						 fb_info);
+			else
+				return 1;
+			break;
+		}
+	} else if (regno < 16) {
+		switch (fb_info->var.bits_per_pixel) {
+		case 16:
+			if (fb_info->var.red.offset == 10) {
+				/* 1:5:5:5 */
+				((u32*) (fb_info->pseudo_palette))[regno] =
 					((red   & 0xf800) >>  1) |
 					((green & 0xf800) >>  6) |
 					((blue  & 0xf800) >> 11) |
 					((transp != 0) << 15);
-		} else {
-			/* 0:5:6:5 */
-			((u32*) (fb_info->pseudo_palette))[regno] =
+			} else {
+				/* 0:5:6:5 */
+				((u32*) (fb_info->pseudo_palette))[regno] =
 					((red   & 0xf800)      ) |
 					((green & 0xfc00) >>  5) |
 					((blue  & 0xf800) >> 11);
+			}
+			break;
+			/* I'm pretty sure that one or the other of these
+			   doesn't exist on 68k Macs */
+		case 24:
+			red   >>= 8;
+			green >>= 8;
+			blue  >>= 8;
+			((u32 *)(fb_info->pseudo_palette))[regno] =
+				(red   << fb_info->var.red.offset)   |
+				(green << fb_info->var.green.offset) |
+				(blue  << fb_info->var.blue.offset);
+			break;
+		case 32:
+			red   >>= 8;
+			green >>= 8;
+			blue  >>= 8;
+			((u32 *)(fb_info->pseudo_palette))[regno] =
+				(red   << fb_info->var.red.offset)   |
+				(green << fb_info->var.green.offset) |
+				(blue  << fb_info->var.blue.offset);
+			break;
 		}
-		break;	
-		/* I'm pretty sure that one or the other of these
-		   doesn't exist on 68k Macs */
-	case 24:
-		red   >>= 8;
-		green >>= 8;
-		blue  >>= 8;
-		((u32 *)(fb_info->pseudo_palette))[regno] =
-			(red   << fb_info->var.red.offset)   |
-			(green << fb_info->var.green.offset) |
-			(blue  << fb_info->var.blue.offset);
-		break;
-	case 32:
-		red   >>= 8;
-		green >>= 8;
-		blue  >>= 8;
-		((u32 *)(fb_info->pseudo_palette))[regno] =
-			(red   << fb_info->var.red.offset)   |
-			(green << fb_info->var.green.offset) |
-			(blue  << fb_info->var.blue.offset);
-		break;
-    }
-    return 0;
+	}
+
+	return 0;
 }
 
 static struct fb_ops macfb_ops = {
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
