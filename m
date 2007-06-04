From: akpm@linux-foundation.org
Subject: + fm2fb-the-pseudo_palette-is-only-16-elements-long.patch added to -mm tree
Date: Mon, 04 Jun 2007 13:40:13 -0700
Message-ID: <200706042040.l54KeDg5018411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46161 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753387AbXFDUkp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 16:40:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com, geert@linux-m68k.org


The patch titled
     fm2fb: the pseudo_palette is only 16 elements long
has been added to the -mm tree.  Its filename is
     fm2fb-the-pseudo_palette-is-only-16-elements-long.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fm2fb: the pseudo_palette is only 16 elements long
From: "Antonino A. Daplas" <adaplas@gmail.com>

The pseudo_palette is only 16 elements long.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fm2fb.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/video/fm2fb.c~fm2fb-the-pseudo_palette-is-only-16-elements-long drivers/video/fm2fb.c
--- a/drivers/video/fm2fb.c~fm2fb-the-pseudo_palette-is-only-16-elements-long
+++ a/drivers/video/fm2fb.c
@@ -195,13 +195,15 @@ static int fm2fb_blank(int blank, struct
 static int fm2fb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
                          u_int transp, struct fb_info *info)
 {
-	if (regno > info->cmap.len)
-		return 1;
-	red >>= 8;
-	green >>= 8;
-	blue >>= 8;
+	if (regno < 16) {
+		red >>= 8;
+		green >>= 8;
+		blue >>= 8;
+
+		((u32*)(info->pseudo_palette))[regno] = (red << 16) |
+			(green << 8) | blue;
+	}
 
-	((u32*)(info->pseudo_palette))[regno] = (red << 16) | (green << 8) | blue;
 	return 0;
 }
 
@@ -237,7 +239,7 @@ static int __devinit fm2fb_probe(struct 
 	if (!zorro_request_device(z,"fm2fb"))
 		return -ENXIO;
 
-	info = framebuffer_alloc(256 * sizeof(u32), &z->dev);
+	info = framebuffer_alloc(16 * sizeof(u32), &z->dev);
 	if (!info) {
 		zorro_release_device(z);
 		return -ENOMEM;
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
