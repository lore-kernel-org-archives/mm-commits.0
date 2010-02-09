From: akpm@linux-foundation.org
Subject: + viafb-video-address-setting-revisited.patch added to -mm tree
Date: Tue, 09 Feb 2010 15:41:00 -0800
Message-ID: <201002092341.o19Nf0rP008554@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751940Ab0BIXle (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2010 18:41:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: video address setting revisited
has been added to the -mm tree.  Its filename is
     viafb-video-address-setting-revisited.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: video address setting revisited
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Set always the correct video address.  Especially do panning right on
multiple IGAs.

This should have no effect on single monitor mode (no SAMM, no dual fb). 
For SAMM without dual fb this might break something as I really cannot
image what we are supposed to do for different resolutions with a single
framebuffer as we can't get data out of nowhere (no, they are not set up
in something one would call "expanded").  Previously I got for that funny
colored pictures as the second IGA pointed to video memory that was never
written to.  After the patch it'll work as cloning if the first and second
mode are identical (this was working already without SAMM).  Finally for
dual fb this should push us a step in the right direction.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/hw.c       |    2 --
 drivers/video/via/viafbdev.c |   21 ++++++++++++++-------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff -puN drivers/video/via/hw.c~viafb-video-address-setting-revisited drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-video-address-setting-revisited
+++ a/drivers/video/via/hw.c
@@ -2206,8 +2206,6 @@ int viafb_setmode(struct VideoModeTable 
 		outb(VPIT.SR[i - 1], VIASR + 1);
 	}
 
-	viafb_set_primary_address(0);
-	viafb_set_secondary_address(viafb_SAMM_ON ? viafb_second_offset : 0);
 	viafb_set_iga_path();
 
 	/* Write CRTC */
diff -puN drivers/video/via/viafbdev.c~viafb-video-address-setting-revisited drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-video-address-setting-revisited
+++ a/drivers/video/via/viafbdev.c
@@ -50,6 +50,8 @@ static void apply_second_mode_setting(st
 	*sec_var);
 static void retrieve_device_setting(struct viafb_ioctl_setting
 	*setting_info);
+static int viafb_pan_display(struct fb_var_screeninfo *var,
+	struct fb_info *info);
 
 static struct fb_ops viafb_ops;
 
@@ -182,6 +184,7 @@ static int viafb_set_par(struct fb_info 
 			info->flags |= FBINFO_HWACCEL_DISABLED;
 		viafb_setmode(vmode_entry, info->var.bits_per_pixel,
 			vmode_entry1, viafb_bpp1);
+		viafb_pan_display(&info->var, info);
 	}
 
 	return 0;
@@ -410,15 +413,19 @@ static int viafb_setcmap(struct fb_cmap 
 static int viafb_pan_display(struct fb_var_screeninfo *var,
 	struct fb_info *info)
 {
-	unsigned int offset;
-
-	DEBUG_MSG(KERN_INFO "viafb_pan_display!\n");
+	struct viafb_par *viapar = info->par;
+	u32 vram_addr = (var->yoffset * var->xres_virtual + var->xoffset)
+		* (var->bits_per_pixel / 8) + viapar->vram_addr;
 
-	offset = (var->xoffset + (var->yoffset * var->xres_virtual)) *
-	    var->bits_per_pixel / 16;
+	DEBUG_MSG(KERN_DEBUG "viafb_pan_display, address = %d\n", vram_addr);
+	if (!viafb_dual_fb) {
+		viafb_set_primary_address(vram_addr);
+		viafb_set_secondary_address(vram_addr);
+	} else if (viapar->iga_path == IGA1)
+		viafb_set_primary_address(vram_addr);
+	else
+		viafb_set_secondary_address(vram_addr);
 
-	DEBUG_MSG(KERN_INFO "\nviafb_pan_display,offset =%d ", offset);
-	viafb_set_primary_address(offset);
 	return 0;
 }
 
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-deprecate-private-ioctls.patch
viafb-remove-dead-code.patch
viafb-split-global-index-up.patch
viafb-split-global-index-up-fix.patch
viafb-remove-the-remaining-via_res_-uses.patch
viafb-some-dvi-cleanup.patch
viafb-yet-another-dead-code-removal.patch
viafb-reorder-initialization-for-dual-framebuffer-mode.patch
viafb-video-address-setting-revisited.patch
viafb-make-viafb_set_par-more-dual-framebuffer-compatible.patch
drivers-video-via-fix-continuation-line-formats.patch

