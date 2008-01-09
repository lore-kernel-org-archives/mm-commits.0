From: akpm@linux-foundation.org
Subject: + fb-nvidiafb-try-harder-at-initial-mode-setting.patch added to -mm tree
Date: Wed, 09 Jan 2008 14:49:25 -0800
Message-ID: <200801092249.m09MnQeL025205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34665 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753461AbYAIWte (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2008 17:49:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, adaplas@gmail.com


The patch titled
     fb: nvidiafb: Try harder at initial mode setting.
has been added to the -mm tree.  Its filename is
     fb-nvidiafb-try-harder-at-initial-mode-setting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fb: nvidiafb: Try harder at initial mode setting.
From: Paul Mundt <lethal@linux-sh.org>

The current nvidiafb_check_var() simply bails out if the selected mode is
out of range of the panel dimensions.  A good question would be why the
bogus mode is being selected in the first place -- the panel dimensions
that are read back are certainly bogus, but alas, I have no idea where to
even begin looking at the i2c/EDID/DDC mess:

nvidiafb: Device ID: 10de0165
nvidiafb: CRTC0 analog not found
nvidiafb: CRTC1 analog not found
nvidiafb: EDID found from BUS1
nvidiafb: CRTC 0 is currently programmed for DFP
nvidiafb: Using DFP on CRTC 0
nvidiafb: Panel size is 1280 x 1024
nvidiafb: Panel is TMDS
nvidiafb: unable to setup MTRR
nvidiafb: Flat panel dithering disabled
nvidiafb: PCI nVidia NV16 framebuffer (64MB @ 0xC0000000)

In my .config I presently have:

CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_NVIDIA_I2C=y

I've not tried fiddling with these options, as I haven't the vaguest idea
what I should be looking at.

As a workaround, simply groveling for a new mode based on the probed
dimensions seems to work ok.  While it would be nice to debug this further
and sort out why the panel information is bogus, I think it's still worth
retrying the mode based on the panel information at hand as a last-ditch
effort, rather than simply bailing out completely.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Antonino A. Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nvidia.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff -puN drivers/video/nvidia/nvidia.c~fb-nvidiafb-try-harder-at-initial-mode-setting drivers/video/nvidia/nvidia.c
--- a/drivers/video/nvidia/nvidia.c~fb-nvidiafb-try-harder-at-initial-mode-setting
+++ a/drivers/video/nvidia/nvidia.c
@@ -849,9 +849,27 @@ static int nvidiafb_check_var(struct fb_
 	if (!mode_valid && info->monspecs.modedb_len)
 		return -EINVAL;
 
+	/*
+	 * If we're on a flat panel, check if the mode is outside of the
+	 * panel dimensions. If so, cap it and try for the next best mode
+	 * before bailing out.
+	 */
 	if (par->fpWidth && par->fpHeight && (par->fpWidth < var->xres ||
-					      par->fpHeight < var->yres))
-		return -EINVAL;
+					      par->fpHeight < var->yres)) {
+		const struct fb_videomode *mode;
+
+		var->xres = par->fpWidth;
+		var->yres = par->fpHeight;
+
+		mode = fb_find_best_mode(var, &info->modelist);
+		if (!mode) {
+			printk(KERN_ERR PFX "mode out of range of flat "
+			       "panel dimensions\n");
+			return -EINVAL;
+		}
+
+		fb_videomode_to_var(var, mode);
+	}
 
 	if (var->yres_virtual < var->yres)
 		var->yres_virtual = var->yres;
_

Patches currently in -mm which might be from lethal@linux-sh.org are

git-acpi.patch
hp6xx-hp7xx-clean-up-drivers-input-keyboardtouchscreen-kconfigs.patch
git-sh.patch
nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
avoid-overflows-in-kernel-timec.patch
rtc-ds1302-rtc-support.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
fb-defio-nopage.patch
fb-nvidiafb-try-harder-at-initial-mode-setting.patch
use-bootmem_exclusive-for-kdump.patch
sanitize-the-type-of-struct-useru_ar0.patch
