From: akpm@linux-foundation.org
Subject: + fbdev-clean-up-exit-patch-of-fb_set_var.patch added to -mm tree
Date: Mon, 07 May 2007 15:26:50 -0700
Message-ID: <200705072226.l47MQor4006943@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966682AbXEGW1W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 18:27:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     fbdev: clean up exit patch of fb_set_var
has been added to the -mm tree.  Its filename is
     fbdev-clean-up-exit-patch-of-fb_set_var.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: clean up exit patch of fb_set_var
From: "Antonino A. Daplas" <adaplas@gmail.com>

Clean up exit patch of fb_set_var():

- consolidate all return values into a single local variable
- ensure that return values are valid error codes
- fix fb_set_var() returning success when fb_check_caps() failed

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff -puN drivers/video/fbmem.c~fbdev-clean-up-exit-patch-of-fb_set_var drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-clean-up-exit-patch-of-fb_set_var
+++ a/drivers/video/fbmem.c
@@ -799,11 +799,11 @@ static int fb_check_caps(struct fb_info 
 int
 fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
 {
-	int err, flags = info->flags;
+	int flags = info->flags;
+	int ret = 0;
 
 	if (var->activate & FB_ACTIVATE_INV_MODE) {
 		struct fb_videomode mode1, mode2;
-		int ret = 0;
 
 		fb_var_to_videomode(&mode1, var);
 		fb_var_to_videomode(&mode2, &info->var);
@@ -821,7 +821,9 @@ fb_set_var(struct fb_info *info, struct 
 		if (!ret)
 		    fb_delete_videomode(&mode1, &info->modelist);
 
-		return ret;
+
+		ret = (ret) ? -EINVAL : 0;
+		goto done;
 	}
 
 	if ((var->activate & FB_ACTIVATE_FORCE) ||
@@ -830,20 +832,21 @@ fb_set_var(struct fb_info *info, struct 
 
 		if (!info->fbops->fb_check_var) {
 			*var = info->var;
-			return 0;
+			goto done;
 		}
 
-		if ((err = info->fbops->fb_check_var(var, info)))
-			return err;
+		ret = info->fbops->fb_check_var(var, info);
+
+		if (ret)
+			goto done;
 
 		if ((var->activate & FB_ACTIVATE_MASK) == FB_ACTIVATE_NOW) {
 			struct fb_videomode mode;
-			int err = 0;
 
 			if (info->fbops->fb_get_caps) {
-				err = fb_check_caps(info, var, activate);
+				ret = fb_check_caps(info, var, activate);
 
-				if (err)
+				if (ret)
 					goto done;
 			}
 
@@ -853,16 +856,14 @@ fb_set_var(struct fb_info *info, struct 
 				info->fbops->fb_set_par(info);
 
 			fb_pan_display(info, &info->var);
-
 			fb_set_cmap(&info->cmap, info);
-
 			fb_var_to_videomode(&mode, &info->var);
 
 			if (info->modelist.prev && info->modelist.next &&
 			    !list_empty(&info->modelist))
-				err = fb_add_videomode(&mode, &info->modelist);
+				ret = fb_add_videomode(&mode, &info->modelist);
 
-			if (!err && (flags & FBINFO_MISC_USEREVENT)) {
+			if (!ret && (flags & FBINFO_MISC_USEREVENT)) {
 				struct fb_event event;
 				int evnt = (activate & FB_ACTIVATE_ALL) ?
 					FB_EVENT_MODE_CHANGE_ALL :
@@ -876,7 +877,7 @@ fb_set_var(struct fb_info *info, struct 
 	}
 
  done:
-	return 0;
+	return ret;
 }
 
 int
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
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
svgalib-move-fb_get_caps-to-svgalib.patch
arkfb-fix-compiler-warnings.patch
vt8623fb-fix-compile-warnings.patch
pm2fb-accelerated-fillrect-and-copyarea.patch
use-menuconfig-objects-ii-video-logo.patch
vgacon-disallow-console-operations-when-in-kd_graphics.patch
vga16fb-actually-support-widths-in-multiples-of-8.patch
skeletonfb-more-corrections.patch
pm2fb-removal-of-pm2fb_par-fields.patch
skeletonfb-improvements.patch
pm2fb-fix-of-jumps-in-pm2fb_probe.patch
xilinxfb-xilinx-framebuffer-device-driver.patch
