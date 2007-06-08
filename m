From: akpm@linux-foundation.org
Subject: - sunxvr500fb-fix-pseudo_palette-array-size.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:35:54 -0700
Message-ID: <200706081735.l58HZsrR006408@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38976 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699AbXFHRli (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:41:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sunxvr500fb: fix pseudo_palette array size
has been removed from the -mm tree.  Its filename was
     sunxvr500fb-fix-pseudo_palette-array-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sunxvr500fb: fix pseudo_palette array size
From: "Antonino A. Daplas" <adaplas@gmail.com>

- the pseudo_palette is only 16 elements long.
- the pseudo_palette has only 16 elements. Do not write if regno (the array
  index) is more than 15.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sunxvr500.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/sunxvr500.c~sunxvr500fb-fix-pseudo_palette-array-size drivers/video/sunxvr500.c
--- a/drivers/video/sunxvr500.c~sunxvr500fb-fix-pseudo_palette-array-size
+++ a/drivers/video/sunxvr500.c
@@ -50,7 +50,7 @@ struct e3d_info {
 	u32			fb8_0_off;
 	u32			fb8_1_off;
 
-	u32			pseudo_palette[256];
+	u32			pseudo_palette[16];
 };
 
 static int __devinit e3d_get_props(struct e3d_info *ep)
@@ -126,7 +126,9 @@ static int e3d_setcolreg(unsigned regno,
 	blue_8 = blue >> 8;
 
 	value = (blue_8 << 24) | (green_8 << 16) | (red_8 << 8);
-	((u32 *)info->pseudo_palette)[regno] = value;
+
+	if (info->fix.visual == FB_VISUAL_TRUECOLOR && regno < 16)
+		((u32 *)info->pseudo_palette)[regno] = value;
 
 
 	red_10 = red >> 6;
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
git-newsetup.patch
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
fm2fb-the-pseudo_palette-is-only-16-elements-long.patch
gbefb-the-pseudo_palette-is-only-16-elements-long.patch
macfb-fix-pseudo_palette-size-and-overrun.patch
offb-the-pseudo_palette-is-only-16-elements-long.patch
platinumfb-the-pseudo_palette-is-only-16-elements.patch
pvr2fb-fix-pseudo_palette-array-overrun-and-typecast.patch
q40fb-the-pseudo_palette-is-only-16-elements-long.patch
sgivwfb-the-pseudo_palette-is-only-16-elements-long.patch
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
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
matroxfb-color-setting-fixes-fix.patch
fb-epson1355fb-kill-off-dead-sh-support.patch
