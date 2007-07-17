From: akpm@linux-foundation.org
Subject: - macfb-fix-pseudo_palette-size-and-overrun.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:22 -0700
Message-ID: <200707172307.l6HN7MC8012183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50520 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762794AbXGQXPM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     macfb: fix pseudo_palette size and overrun
has been removed from the -mm tree.  Its filename was
     macfb-fix-pseudo_palette-size-and-overrun.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: macfb: fix pseudo_palette size and overrun
From: "Antonino A. Daplas" <adaplas@gmail.com>

- the pseudo_palette is only 16 elements long.
- do not write to the pseudo_palette if regno (array index) is more than 15.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/macfb.c |   93 +++++++++++++++++++++-------------------
 1 file changed, 50 insertions(+), 43 deletions(-)

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
