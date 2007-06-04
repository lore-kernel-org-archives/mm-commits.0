From: akpm@linux-foundation.org
Subject: + sisfb-fix-pseudo_palette-array-size-and-overrun.patch added to -mm tree
Date: Mon, 04 Jun 2007 13:41:04 -0700
Message-ID: <200706042041.l54Kf44b018513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60729 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754150AbXFDUlM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 16:41:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     sisfb: fix pseudo_palette array size and overrun
has been added to the -mm tree.  Its filename is
     sisfb-fix-pseudo_palette-array-size-and-overrun.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sisfb: fix pseudo_palette array size and overrun
From: "Antonino A. Daplas" <adaplas@gmail.com>

- the pseudo_palette is only 16 elements long.
- do not write to the pseudo_palette if regno (array index) is more than 15.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sis/sis.h      |    2 +-
 drivers/video/sis/sis_main.c |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/video/sis/sis.h~sisfb-fix-pseudo_palette-array-size-and-overrun drivers/video/sis/sis.h
--- a/drivers/video/sis/sis.h~sisfb-fix-pseudo_palette-array-size-and-overrun
+++ a/drivers/video/sis/sis.h
@@ -479,7 +479,7 @@ struct sis_video_info {
 	struct fb_var_screeninfo default_var;
 
 	struct fb_fix_screeninfo sisfb_fix;
-	u32		pseudo_palette[17];
+	u32		pseudo_palette[16];
 
 	struct sisfb_monitor {
 		u16 hmin;
diff -puN drivers/video/sis/sis_main.c~sisfb-fix-pseudo_palette-array-size-and-overrun drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~sisfb-fix-pseudo_palette-array-size-and-overrun
+++ a/drivers/video/sis/sis_main.c
@@ -1405,12 +1405,18 @@ sisfb_setcolreg(unsigned regno, unsigned
 		}
 		break;
 	case 16:
+		if (regno >= 16)
+			break;
+
 		((u32 *)(info->pseudo_palette))[regno] =
 				(red & 0xf800)          |
 				((green & 0xfc00) >> 5) |
 				((blue & 0xf800) >> 11);
 		break;
 	case 32:
+		if (regno >= 16)
+			break;
+
 		red >>= 8;
 		green >>= 8;
 		blue >>= 8;
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
