From: akpm@linux-foundation.org
Subject: + fbcon-delay-screen-update-when-setting-the-mode-of.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:32:40 -0700
Message-ID: <200704260032.l3Q0We5V016916@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423415AbXDZAcm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:32:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     fbcon: delay screen update when setting the mode of all consoles
has been added to the -mm tree.  Its filename is
     fbcon-delay-screen-update-when-setting-the-mode-of.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbcon: delay screen update when setting the mode of all consoles
From: "Antonino A. Daplas" <adaplas@gmail.com>

If the current framebuffer console is rotated (rotate != 0), doing an
"fbset -a" will corrupt the current console.  Fix by updating the current
console only after all non-visible consoles have been updated.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbcon-delay-screen-update-when-setting-the-mode-of drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-delay-screen-update-when-setting-the-mode-of
+++ a/drivers/video/console/fbcon.c
@@ -2849,7 +2849,7 @@ static void fbcon_set_all_vcs(struct fb_
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct vc_data *vc;
 	struct display *p;
-	int i, rows, cols;
+	int i, rows, cols, fg = -1;
 
 	if (!ops || ops->currcon < 0)
 		return;
@@ -2860,34 +2860,23 @@ static void fbcon_set_all_vcs(struct fb_
 		    registered_fb[con2fb_map[i]] != info)
 			continue;
 
+		if (CON_IS_VISIBLE(vc)) {
+			fg = i;
+			continue;
+		}
+
 		p = &fb_display[vc->vc_num];
 		set_blitting_type(vc, info);
 		var_to_display(p, &info->var, info);
-		cols = FBCON_SWAP(ops->rotate, info->var.xres, info->var.yres);
-		rows = FBCON_SWAP(ops->rotate, info->var.yres, info->var.xres);
+		cols = FBCON_SWAP(p->rotate, info->var.xres, info->var.yres);
+		rows = FBCON_SWAP(p->rotate, info->var.yres, info->var.xres);
 		cols /= vc->vc_font.width;
 		rows /= vc->vc_font.height;
 		vc_resize(vc, cols, rows);
-
-		if (CON_IS_VISIBLE(vc)) {
-			updatescrollmode(p, info, vc);
-			scrollback_max = 0;
-			scrollback_current = 0;
-
-			if (!fbcon_is_inactive(vc, info)) {
-			    ops->var.xoffset = ops->var.yoffset =
-				p->yscroll = 0;
-			    ops->update_start(info);
-			}
-
-			fbcon_set_palette(vc, color_table);
-			update_screen(vc);
-			if (softback_buf)
-				fbcon_update_softback(vc);
-		}
 	}
 
-	ops->p = &fb_display[ops->currcon];
+	if (fg != -1)
+		fbcon_modechanged(info);
 }
 
 static int fbcon_mode_deleted(struct fb_info *info,
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
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
