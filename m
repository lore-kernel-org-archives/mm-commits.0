From: akpm@linux-foundation.org
Subject: + fbdev-save-the-activate-field-before-calling-fb_check_var.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:33:19 -0700
Message-ID: <200704260033.l3Q0XJgf017005@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423449AbXDZAdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:33:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     fbdev: save the activate field before calling fb_check_var()
has been added to the -mm tree.  Its filename is
     fbdev-save-the-activate-field-before-calling-fb_check_var.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: save the activate field before calling fb_check_var()
From: "Antonino A. Daplas" <adaplas@gmail.com>

Some drivers may reset the var->activate field on fb_check_var(). This can
lead to undefined behavior. For example, doing fbset -a <option> with vga16fb
will only modify the active console instead of modifying all.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/fbmem.c~fbdev-save-the-activate-field-before-calling-fb_check_var drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-save-the-activate-field-before-calling-fb_check_var
+++ a/drivers/video/fbmem.c
@@ -803,6 +803,8 @@ fb_set_var(struct fb_info *info, struct 
 
 	if ((var->activate & FB_ACTIVATE_FORCE) ||
 	    memcmp(&info->var, var, sizeof(struct fb_var_screeninfo))) {
+		u32 activate = var->activate;
+
 		if (!info->fbops->fb_check_var) {
 			*var = info->var;
 			return 0;
@@ -831,7 +833,7 @@ fb_set_var(struct fb_info *info, struct 
 
 			if (!err && (flags & FBINFO_MISC_USEREVENT)) {
 				struct fb_event event;
-				int evnt = (var->activate & FB_ACTIVATE_ALL) ?
+				int evnt = (activate & FB_ACTIVATE_ALL) ?
 					FB_EVENT_MODE_CHANGE_ALL :
 					FB_EVENT_MODE_CHANGE;
 
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
