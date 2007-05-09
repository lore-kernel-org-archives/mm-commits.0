From: akpm@linux-foundation.org
Subject: - nvidiafb-ensure-that-crtc-registers-are-accessible.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:30 -0700
Message-ID: <200705090300.l4930UER010573@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032844AbXEIDAc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     nvidiafb: ensure that CRTC registers are accessible
has been removed from the -mm tree.  Its filename was
     nvidiafb-ensure-that-crtc-registers-are-accessible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nvidiafb: ensure that CRTC registers are accessible
From: "Antonino A. Daplas" <adaplas@gmail.com>

- Ensure that CRTC registers are accessible by unlocking them on set_par(),
  otherwise i2c reading will fail.

- The function nvidia_vga_protect(), does not protect the VGA registers, but
  turns off the screen.  Rename it to nvidia_screen_off().

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nvidia.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/video/nvidia/nvidia.c~nvidiafb-ensure-that-crtc-registers-are-accessible drivers/video/nvidia/nvidia.c
--- a/drivers/video/nvidia/nvidia.c~nvidiafb-ensure-that-crtc-registers-are-accessible
+++ a/drivers/video/nvidia/nvidia.c
@@ -200,7 +200,7 @@ static int nvidia_panel_tweak(struct nvi
    return tweak;
 }
 
-static void nvidia_vga_protect(struct nvidia_par *par, int on)
+static void nvidia_screen_off(struct nvidia_par *par, int on)
 {
 	unsigned char tmp;
 
@@ -649,7 +649,7 @@ static int nvidiafb_set_par(struct fb_in
 		NVLockUnlock(par, 0);
 	}
 
-	nvidia_vga_protect(par, 1);
+	nvidia_screen_off(par, 1);
 
 	nvidia_write_regs(par, &par->ModeReg);
 	NVSetStartAddress(par, 0);
@@ -687,7 +687,7 @@ static int nvidiafb_set_par(struct fb_in
 
 	par->cursor_reset = 1;
 
-	nvidia_vga_protect(par, 0);
+	nvidia_screen_off(par, 0);
 
 #ifdef CONFIG_BOOTX_TEXT
 	/* Update debug text engine */
@@ -696,6 +696,7 @@ static int nvidiafb_set_par(struct fb_in
 			     info->var.bits_per_pixel, info->fix.line_length);
 #endif
 
+	NVLockUnlock(par, 0);
 	NVTRACE_LEAVE();
 	return 0;
 }
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
