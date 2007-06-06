From: akpm@linux-foundation.org
Subject: + matroxfb-color-setting-fixes-fix.patch added to -mm tree
Date: Wed, 06 Jun 2007 11:00:44 -0700
Message-ID: <200706061800.l56I0irj003010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42754 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbXFFSA4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 14:00:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com, VANDROVE@vc.cvut.cz


The patch titled
     matroxfb: color setting fixes fix
has been added to the -mm tree.  Its filename is
     matroxfb-color-setting-fixes-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: matroxfb: color setting fixes fix
From: "Antonino A. Daplas" <adaplas@gmail.com>

Remove more code that writes to cmap[16].

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Cc: Petr Vandrovec <VANDROVE@vc.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/matrox/matroxfb_accel.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/matrox/matroxfb_accel.c~matroxfb-color-setting-fixes-fix drivers/video/matrox/matroxfb_accel.c
--- a/drivers/video/matrox/matroxfb_accel.c~matroxfb-color-setting-fixes-fix
+++ a/drivers/video/matrox/matroxfb_accel.c
@@ -91,7 +91,6 @@ static inline void matrox_cfb4_pal(u_int
 	for (i = 0; i < 16; i++) {
 		pal[i] = i * 0x11111111U;
 	}
-	pal[i] = 0xFFFFFFFF;
 }
 
 static inline void matrox_cfb8_pal(u_int32_t* pal) {
@@ -100,7 +99,6 @@ static inline void matrox_cfb8_pal(u_int
 	for (i = 0; i < 16; i++) {
 		pal[i] = i * 0x01010101U;
 	}
-	pal[i] = 0x0F0F0F0F;
 }
 
 static void matroxfb_copyarea(struct fb_info* info, const struct fb_copyarea* area);
_

Patches currently in -mm which might be from adaplas@gmail.com are

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
matroxfb-color-setting-fixes.patch
pm3fb-fillrect-acceleration.patch
i386-set-6-bit-dac-channel-properties-in-vesa-video.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
matroxfb-color-setting-fixes-fix.patch
