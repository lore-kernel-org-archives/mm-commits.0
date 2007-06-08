From: akpm@linux-foundation.org
Subject: - i386-set-6-bit-dac-channel-properties-in-vesa-video.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:35:56 -0700
Message-ID: <200706081735.l58HZunF006433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35162 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933868AbXFHRos (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:44:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, ak@suse.de, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     i386: set 6-bit DAC channel properties in vesa video setup
has been removed from the -mm tree.  Its filename was
     i386-set-6-bit-dac-channel-properties-in-vesa-video.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: set 6-bit DAC channel properties in vesa video setup
From: "Antonino A. Daplas" <adaplas@gmail.com>

If the video BIOS is not capable of switching or failed to switch the hardware
to 8-bit DAC, the channel properties are not set.  This leads to a blank (all
black) display with vesafb at 8 bpp.  Fix by defaulting to a 6-bit DAC.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/boot/video-vesa.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff -puN arch/i386/boot/video-vesa.c~i386-set-6-bit-dac-channel-properties-in-vesa-video arch/i386/boot/video-vesa.c
--- a/arch/i386/boot/video-vesa.c~i386-set-6-bit-dac-channel-properties-in-vesa-video
+++ a/arch/i386/boot/video-vesa.c
@@ -153,19 +153,21 @@ static int vesa_set_mode(struct mode_inf
 /* Switch DAC to 8-bit mode */
 static void vesa_dac_set_8bits(void)
 {
-	u16 ax, bx;
-	u8 dac_size;
+	u8 dac_size = 6;
 
-	ax = 0x4f08;
-	bx = 0x0800;
-	asm volatile(INT10
-		     : "+a" (ax), "+b" (bx)
-		     : : "ecx", "edx", "esi", "edi");
-
-	if (ax != 0x004f)
-		return;
+	/* If possible, switch the DAC to 8-bit mode */
+	if (vginfo.capabilities & 1) {
+		u16 ax, bx;
 
-	dac_size = bx >> 8;
+		ax = 0x4f08;
+		bx = 0x0800;
+		asm volatile(INT10
+			     : "+a" (ax), "+b" (bx)
+			     : : "ecx", "edx", "esi", "edi");
+
+		if (ax == 0x004f)
+			dac_size = bx >> 8;
+	}
 
 	/* Set the color sizes to the DAC size, and offsets to 0 */
 	boot_params.screen_info.red_size = dac_size;
@@ -219,8 +221,7 @@ static void vesa_store_mode_params_graph
 	/* General parameters */
 	boot_params.screen_info.lfb_size = vginfo.total_memory;
 
-	/* If possible, switch the DAC to 8-bit mode */
-	if (vminfo.bpp <= 8 && (vginfo.capabilities & 1))
+	if (vminfo.bpp <= 8)
 		vesa_dac_set_8bits();
 
 	vesa_store_pm_info();
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
