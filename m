From: akpm@linux-foundation.org
Subject: + nvidiafb-ensure-that-crtc-registers-are-accessible.patch added to -mm tree
Date: Mon, 09 Apr 2007 12:38:14 -0700
Message-ID: <200704091938.l39JcEpo021595@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57159 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930AbXDITiQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 15:38:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     nvidiafb: ensure that CRTC registers are accessible
has been added to the -mm tree.  Its filename is
     nvidiafb-ensure-that-crtc-registers-are-accessible.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 4 insertions(+), 3 deletions(-)

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

fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch
intelfb-fix-ring-space-calculation.patch
nvidiafb-bring-back-generic-ddc-reading.patch
fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
fbdev-fix-obvious-bug-in-show_pan.patch
neofb-fill-transp-msb_right-with-the-correct.patch
atyfb-kill-dead-code.patch
fbdev-mm-deferred-io-support.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-mm-deferred-io-support-fix-2.patch
fbdev-hecuba-framebuffer-driver.patch
fbdev-hecuba-framebuffer-driver-fix.patch
nvidiafb-fix-reversed-ddc-port.patch
vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch
fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch
rivafb-nvidiafb-enable-hardware-monitoring.patch
rivafb-handle-i2c-bus-creation-failure.patch
rivafb-nvidiafb-various-cleanups.patch
rivafb-fixed-reversed-ddc-ports.patch
nvidiafb-ensure-that-crtc-registers-are-accessible.patch
nvidiafb-access-crt-registers-safely.patch
