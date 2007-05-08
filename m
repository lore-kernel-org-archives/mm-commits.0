From: akpm@linux-foundation.org
Subject: + arkfb-fix-compile-error-if-config_mtrr=n.patch added to -mm tree
Date: Tue, 08 May 2007 11:17:35 -0700
Message-ID: <200705081817.l48IHZBl030271@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967017AbXEHSRm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 14:17:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com, santiago@crfreenet.org


The patch titled
     arkfb: Fix compile error if CONFIG_MTRR=n
has been added to the -mm tree.  Its filename is
     arkfb-fix-compile-error-if-config_mtrr=n.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arkfb: Fix compile error if CONFIG_MTRR=n
From: "Antonino A. Daplas" <adaplas@gmail.com>

Fix compile error if CONFIG_MTRR=n

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Acked-by: Ondrej Zajicek <santiago@crfreenet.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/arkfb.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/video/arkfb.c~arkfb-fix-compile-error-if-config_mtrr=n drivers/video/arkfb.c
--- a/drivers/video/arkfb.c~arkfb-fix-compile-error-if-config_mtrr=n
+++ a/drivers/video/arkfb.c
@@ -1055,12 +1055,10 @@ err_enable_device:
 static void __devexit ark_pci_remove(struct pci_dev *dev)
 {
 	struct fb_info *info = pci_get_drvdata(dev);
+	struct arkfb_info *par = info->par;
 
 	if (info) {
-
 #ifdef CONFIG_MTRR
-		struct arkfb_info *par = info->par;
-
 		if (par->mtrr_reg >= 0) {
 			mtrr_del(par->mtrr_reg, 0, 0);
 			par->mtrr_reg = -1;
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
skeletonfb-various-corrections.patch
epson1355fbc-fix-error-handling-code.patch
nvidiafb-vga-state-save-and-restore.patch
savagefb-rework-i2c-bit-access.patch
savagefb-vga-state-save-and-restore.patch
fbdev-link-vgastateo-using-kconfig.patch
fbcon-delay-screen-update-when-setting-the-mode-of.patch
nvidiafb-fix-sparse-warning.patch
rivafb-fix-io-access.patch
fbdev-kill-sparse-warning-in-deferred-io.patch
fbdev-add-sparse-annotations-in-svgalibc.patch
arcfb-kill-sparse-warning.patch
s3fb-add-sparse-annotations.patch
hecubafb-kill-sparse-warnings.patch
i810fb-fix-incorrect-frequency-mask.patch
vt-add-documentation-for-new-boot-sysfs-options.patch
skeletonfb-documentation-error-fixes.patch
fbdev-add-drawing-functions-for-framebuffers-in-system.patch
arcfb-use-sys-instead-of-cfb-drawing-functions.patch
hecubafb-use-sys-instead-of-cfb-drawing-functions.patch
vfb-use-sys-instead-of-cfb-drawing-functions.patch
fbdev-pass-struct-fb_info-to-fb_read-and-fb_write.patch
fbdev-add-fb_read-fb_write-functions-for-framebuffers.patch
arcfb-us-fb_sys_read.patch
hecubafb-us-fb_sys_read.patch
vfb-us-fb_sys_read-and-fb_sys_write.patch
fbdev-consolidate-common-drawing-functions-into-a.patch
fbdev-advertise-limitation-of-drawing-engine.patch
fbcon-font-setting-should-check-limitation-of-driver.patch
vga16fb-restrict-to-blit-rectangles-with-widths-of.patch
s3fb-limit-8x16-rectangles-when-tileblitting-is-enabled.patch
fbdev-add-tile-operation-to-get-the-maximum-length.patch
s3fb-implement-fb_get_tilemax.patch
fbcon-check-if-the-character-count-can-be-handled.patch
fbdev-save-the-activate-field-before-calling-fb_check_var.patch
s3fb-driver-fixes.patch
vmlfb-framebuffer-driver-for-intel-vermilion-range.patch
nvidiafb-rivafb-switch-to-pci_get-refcounting.patch
pm2fb-3dlabs-permedia-2v-reference-board-added.patch
pm2fb-permedia-2v-memory-clock-setting.patch
pm2fb-pixclock-setting-restriction.patch
nvidiafb-prevent-triggering-of-softlockup.patch
fbdev-fbcon-check-if-mode-can-handle-new-screen.patch
s3fb-implement-fb_get_caps.patch
vga-vgastate-fix.patch
nvidiafb-fix-return-value-of-nvidiafb_open.patch
atyfb-increase-spll-delay.patch
atyfb-reorganize-clock-init.patch
atyfb-halve-xclk-with-mobility-and-32bit-memory.patch
fbdev-clean-up-exit-patch-of-fb_set_var.patch
fbcon-check-console-fb-mapping-in-fbcon_get_requirement.patch
pm2fb-reset-transparency-settings.patch
pm2fb-memclock-setting-corrections.patch
s3fb-updates.patch
pm2fb-accelerated-fillrect-and-copyarea.patch
use-menuconfig-objects-ii-video-logo.patch
vgacon-disallow-console-operations-when-in-kd_graphics.patch
vga16fb-actually-support-widths-in-multiples-of-8.patch
skeletonfb-more-corrections.patch
pm2fb-removal-of-pm2fb_par-fields.patch
skeletonfb-improvements.patch
pm2fb-fix-of-jumps-in-pm2fb_probe.patch
xilinxfb-xilinx-framebuffer-device-driver.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
svgalib-move-fb_get_caps-to-svgalib.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
vt8623fb-fix-compile-warnings.patch
