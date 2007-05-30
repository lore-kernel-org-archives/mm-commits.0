From: akpm@linux-foundation.org
Subject: + neofb-fix-pseudo_palette-array-overrun-in-neofb_setcolreg.patch added to -mm tree
Date: Wed, 30 May 2007 15:43:47 -0700
Message-ID: <200705302243.l4UMhlFm007007@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645AbXE3Wn7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 18:43:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com, penberg@cs.helsinki.fi, teanropo@jyu.fi


The patch titled
     neofb: Fix pseudo_palette array overrun in neofb_setcolreg
has been added to the -mm tree.  Its filename is
     neofb-fix-pseudo_palette-array-overrun-in-neofb_setcolreg.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: neofb: Fix pseudo_palette array overrun in neofb_setcolreg
From: "Antonino A. Daplas" <adaplas@gmail.com>

The pseudo_palette has room for 16 entries only, but in truecolor mode, it
attempts to add 256.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Cc: Tero Roponen <teanropo@jyu.fi>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/neofb.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff -puN drivers/video/neofb.c~neofb-fix-pseudo_palette-array-overrun-in-neofb_setcolreg drivers/video/neofb.c
--- a/drivers/video/neofb.c~neofb-fix-pseudo_palette-array-overrun-in-neofb_setcolreg
+++ a/drivers/video/neofb.c
@@ -1286,34 +1286,36 @@ static int neofb_setcolreg(u_int regno, 
 	if (regno >= fb->cmap.len || regno > 255)
 		return -EINVAL;
 
-	switch (fb->var.bits_per_pixel) {
-	case 8:
+	if (fb->var.bits_per_pixel <= 8) {
 		outb(regno, 0x3c8);
 
 		outb(red >> 10, 0x3c9);
 		outb(green >> 10, 0x3c9);
 		outb(blue >> 10, 0x3c9);
-		break;
-	case 16:
-		((u32 *) fb->pseudo_palette)[regno] =
+	} else if (regno < 16) {
+		switch (fb->var.bits_per_pixel) {
+		case 16:
+			((u32 *) fb->pseudo_palette)[regno] =
 				((red & 0xf800)) | ((green & 0xfc00) >> 5) |
 				((blue & 0xf800) >> 11);
-		break;
-	case 24:
-		((u32 *) fb->pseudo_palette)[regno] =
+			break;
+		case 24:
+			((u32 *) fb->pseudo_palette)[regno] =
 				((red & 0xff00) << 8) | ((green & 0xff00)) |
 				((blue & 0xff00) >> 8);
-		break;
+			break;
 #ifdef NO_32BIT_SUPPORT_YET
-	case 32:
-		((u32 *) fb->pseudo_palette)[regno] =
+		case 32:
+			((u32 *) fb->pseudo_palette)[regno] =
 				((transp & 0xff00) << 16) | ((red & 0xff00) << 8) |
 				((green & 0xff00)) | ((blue & 0xff00) >> 8);
-		break;
+			break;
 #endif
-	default:
-		return 1;
+		default:
+			return 1;
+		}
 	}
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from adaplas@gmail.com are

skeletonfb-fix-of-xxxfb_setup-ifdef.patch
vt8623fb-arkfb-null-pointer-dereference-fix.patch
cfag12864bfb-use-sys_-instead-of-cfb_-framebuffer-accessors.patch
fbdev-move-declaration-of-fb_class-to-linux-fbh.patch
neofb-fix-pseudo_palette-array-overrun-in-neofb_setcolreg.patch
fbcon-smart-blitter-usage-for-scrolling.patch
nvidiafb-adjust-flags-to-take-advantage-of-new-scroll-method.patch
fbcon-cursor-blink-control.patch
fbcon-use-struct-device-instead-of-struct-class_device.patch
fbdev-move-arch-specific-bits-to-their-respective.patch
fbdev-detect-primary-display-device.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix.patch
