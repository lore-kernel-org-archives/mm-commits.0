From: akpm@linux-foundation.org
Subject: + matroxfb-color-setting-fixes.patch added to -mm tree
Date: Tue, 05 Jun 2007 10:56:24 -0700
Message-ID: <200706051756.l55HuOjJ032030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59301 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752040AbXFER4f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 13:56:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com, vandrove@vc.cvut.cz


The patch titled
     matroxfb: color setting fixes
has been added to the -mm tree.  Its filename is
     matroxfb-color-setting-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: matroxfb: color setting fixes
From: "Antonino A. Daplas" <adaplas@gmail.com>

- the pseudo_palette is only 16 elements long.
- do not write to the pseudo_palette if regno (array index) is more than 15
- remove code that writes to the 17th entry of the pseudo_palette

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/matrox/matroxfb_accel.c |    9 ++-------
 drivers/video/matrox/matroxfb_base.c  |    4 ++++
 drivers/video/matrox/matroxfb_base.h  |    2 +-
 drivers/video/matrox/matroxfb_crtc2.c |    6 ------
 drivers/video/matrox/matroxfb_crtc2.h |    2 +-
 5 files changed, 8 insertions(+), 15 deletions(-)

diff -puN drivers/video/matrox/matroxfb_accel.c~matroxfb-color-setting-fixes drivers/video/matrox/matroxfb_accel.c
--- a/drivers/video/matrox/matroxfb_accel.c~matroxfb-color-setting-fixes
+++ a/drivers/video/matrox/matroxfb_accel.c
@@ -145,13 +145,10 @@ void matrox_cfbX_init(WPMINFO2) {
 					ACCESS_FBINFO(fbops).fb_imageblit = matroxfb_imageblit;
 				}
 				break;
-		case 16:	if (ACCESS_FBINFO(fbcon).var.green.length == 5) {
+		case 16:	if (ACCESS_FBINFO(fbcon).var.green.length == 5)
 					maccess = 0xC0000001;
-					ACCESS_FBINFO(cmap[16]) = 0x7FFF7FFF;
-				} else {
+				else
 					maccess = 0x40000001;
-					ACCESS_FBINFO(cmap[16]) = 0xFFFFFFFF;
-				}
 				mopmode = M_OPMODE_16BPP;
 				if (accel) {
 					ACCESS_FBINFO(fbops).fb_copyarea = matroxfb_copyarea;
@@ -161,7 +158,6 @@ void matrox_cfbX_init(WPMINFO2) {
 				break;
 		case 24:	maccess = 0x00000003;
 				mopmode = M_OPMODE_24BPP;
-				ACCESS_FBINFO(cmap[16]) = 0xFFFFFFFF;
 				if (accel) {
 					ACCESS_FBINFO(fbops).fb_copyarea = matroxfb_copyarea;
 					ACCESS_FBINFO(fbops).fb_fillrect = matroxfb_fillrect;
@@ -170,7 +166,6 @@ void matrox_cfbX_init(WPMINFO2) {
 				break;
 		case 32:	maccess = 0x00000002;
 				mopmode = M_OPMODE_32BPP;
-				ACCESS_FBINFO(cmap[16]) = 0xFFFFFFFF;
 				if (accel) {
 					ACCESS_FBINFO(fbops).fb_copyarea = matroxfb_copyarea;
 					ACCESS_FBINFO(fbops).fb_fillrect = matroxfb_fillrect;
diff -puN drivers/video/matrox/matroxfb_base.c~matroxfb-color-setting-fixes drivers/video/matrox/matroxfb_base.c
--- a/drivers/video/matrox/matroxfb_base.c~matroxfb-color-setting-fixes
+++ a/drivers/video/matrox/matroxfb_base.c
@@ -679,6 +679,8 @@ static int matroxfb_setcolreg(unsigned r
 		mga_outb(M_DAC_VAL, blue);
 		break;
 	case 16:
+		if (regno >= 16)
+			break;
 		{
 			u_int16_t col =
 				(red << ACCESS_FBINFO(fbcon).var.red.offset)     |
@@ -690,6 +692,8 @@ static int matroxfb_setcolreg(unsigned r
 		break;
 	case 24:
 	case 32:
+		if (regno >= 16)
+			break;
 		ACCESS_FBINFO(cmap[regno]) =
 			(red   << ACCESS_FBINFO(fbcon).var.red.offset)   |
 			(green << ACCESS_FBINFO(fbcon).var.green.offset) |
diff -puN drivers/video/matrox/matroxfb_base.h~matroxfb-color-setting-fixes drivers/video/matrox/matroxfb_base.h
--- a/drivers/video/matrox/matroxfb_base.h~matroxfb-color-setting-fixes
+++ a/drivers/video/matrox/matroxfb_base.h
@@ -518,7 +518,7 @@ struct matrox_fb_info {
 					dll:1;
 				      } memory;
 			      } values;
-	u_int32_t cmap[17];
+	u_int32_t cmap[16];
 };
 
 #define info2minfo(info) container_of(info, struct matrox_fb_info, fbcon)
diff -puN drivers/video/matrox/matroxfb_crtc2.c~matroxfb-color-setting-fixes drivers/video/matrox/matroxfb_crtc2.c
--- a/drivers/video/matrox/matroxfb_crtc2.c~matroxfb-color-setting-fixes
+++ a/drivers/video/matrox/matroxfb_crtc2.c
@@ -163,11 +163,6 @@ static void matroxfb_dh_disable(struct m
 	ACCESS_FBINFO(hw).crtc2.ctl = 0x00000004;
 }
 
-static void matroxfb_dh_cfbX_init(struct matroxfb_dh_fb_info* m2info) {
-	/* no acceleration for secondary head... */
-	m2info->cmap[16] = 0xFFFFFFFF;
-}
-
 static void matroxfb_dh_pan_var(struct matroxfb_dh_fb_info* m2info,
 		struct fb_var_screeninfo* var) {
 	unsigned int pos;
@@ -385,7 +380,6 @@ static int matroxfb_dh_set_par(struct fb
 			}
 		}
 		up_read(&ACCESS_FBINFO(altout).lock);
-		matroxfb_dh_cfbX_init(m2info);
 	}
 	m2info->initialized = 1;
 	return 0;
diff -puN drivers/video/matrox/matroxfb_crtc2.h~matroxfb-color-setting-fixes drivers/video/matrox/matroxfb_crtc2.h
--- a/drivers/video/matrox/matroxfb_crtc2.h~matroxfb-color-setting-fixes
+++ a/drivers/video/matrox/matroxfb_crtc2.h
@@ -28,7 +28,7 @@ struct matroxfb_dh_fb_info {
 
 	unsigned int		interlaced:1;
 
-	u_int32_t cmap[17];
+	u_int32_t cmap[16];
 };
 
 #endif /* __MATROXFB_CRTC2_H__ */
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
