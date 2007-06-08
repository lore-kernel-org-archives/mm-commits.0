From: akpm@linux-foundation.org
Subject: - sunxvr2500fb-fix-pseudo_palette-array-size.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:35:52 -0700
Message-ID: <200706081735.l58HZqBS006405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48876 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935122AbXFHRmD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:42:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sunxvr2500fb: fix pseudo_palette array size
has been removed from the -mm tree.  Its filename was
     sunxvr2500fb-fix-pseudo_palette-array-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sunxvr2500fb: fix pseudo_palette array size
From: "Antonino A. Daplas" <adaplas@gmail.com>

- the pseudo_palette is only 16 elements long.
- the pseudo_palette has only 16 elements. Do not write if regno (the array
  index) is more than 15.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sunxvr2500.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/video/sunxvr2500.c~sunxvr2500fb-fix-pseudo_palette-array-size drivers/video/sunxvr2500.c
--- a/drivers/video/sunxvr2500.c~sunxvr2500fb-fix-pseudo_palette-array-size
+++ a/drivers/video/sunxvr2500.c
@@ -28,7 +28,7 @@ struct s3d_info {
 	unsigned int		depth;
 	unsigned int		fb_size;
 
-	u32			pseudo_palette[256];
+	u32			pseudo_palette[16];
 };
 
 static int __devinit s3d_get_props(struct s3d_info *sp)
@@ -52,15 +52,14 @@ static int s3d_setcolreg(unsigned regno,
 {
 	u32 value;
 
-	if (regno >= 256)
-		return 1;
+	if (regno < 16) {
+		red >>= 8;
+		green >>= 8;
+		blue >>= 8;
 
-	red >>= 8;
-	green >>= 8;
-	blue >>= 8;
-
-	value = (blue << 24) | (green << 16) | (red << 8);
-	((u32 *)info->pseudo_palette)[regno] = value;
+		value = (blue << 24) | (green << 16) | (red << 8);
+		((u32 *)info->pseudo_palette)[regno] = value;
+	}
 
 	return 0;
 }
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
