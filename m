From: akpm@linux-foundation.org
Subject: + tgafb-actually-allocate-memory-for-the-pseudo_palette.patch added to -mm tree
Date: Mon, 04 Jun 2007 13:40:43 -0700
Message-ID: <200706042040.l54Kehwx018460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58189 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754143AbXFDUlQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 16:41:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com, macro@linux-mips.org


The patch titled
     tgafb: actually allocate memory for the pseudo_palette
has been added to the -mm tree.  Its filename is
     tgafb-actually-allocate-memory-for-the-pseudo_palette.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tgafb: actually allocate memory for the pseudo_palette
From: "Antonino A. Daplas" <adaplas@gmail.com>

No memory allocation was done for the pseudo_palette.  Allocate one for it.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Acked-by: "Maciej W. Rozycki" <macro@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tgafb.c |    2 +-
 include/video/tgafb.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/tgafb.c~tgafb-actually-allocate-memory-for-the-pseudo_palette drivers/video/tgafb.c
--- a/drivers/video/tgafb.c~tgafb-actually-allocate-memory-for-the-pseudo_palette
+++ a/drivers/video/tgafb.c
@@ -1635,7 +1635,7 @@ tgafb_register(struct device *dev)
 		      FBINFO_HWACCEL_IMAGEBLIT | FBINFO_HWACCEL_FILLRECT;
 	info->fbops = &tgafb_ops;
 	info->screen_base = par->tga_fb_base;
-	info->pseudo_palette = (void *)(par + 1);
+	info->pseudo_palette = par->palette;
 
 	/* This should give a reasonable default video mode.  */
 	if (tga_bus_pci) {
diff -puN include/video/tgafb.h~tgafb-actually-allocate-memory-for-the-pseudo_palette include/video/tgafb.h
--- a/include/video/tgafb.h~tgafb-actually-allocate-memory-for-the-pseudo_palette
+++ a/include/video/tgafb.h
@@ -216,6 +216,7 @@ struct tga_par {
 	u32 pll_freq;			/* pixclock in mhz */
 	u32 bits_per_pixel;		/* bits per pixel */
 	u32 sync_on_green;		/* set if sync is on green */
+	u32 palette[16];
 };
 
 
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
