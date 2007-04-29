From: akpm@linux-foundation.org
Subject: + s3fb-implement-fb_get_caps.patch added to -mm tree
Date: Sun, 29 Apr 2007 02:33:35 -0700
Message-ID: <200704290933.l3T9XZh3012962@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755104AbXD2Jdk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Apr 2007 05:33:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     s3fb: implement fb_get_caps
has been added to the -mm tree.  Its filename is
     s3fb-implement-fb_get_caps.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: s3fb: implement fb_get_caps
From: "Antonino A. Daplas" <adaplas@gmail.com>

Implement fb_get_caps().  This will allow the driver to tell upper layer that
it can only support 256 8x16 bitmaps when in tileblitting mode
(var->bits_per_pixel == 0);

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3fb.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN drivers/video/s3fb.c~s3fb-implement-fb_get_caps drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~s3fb-implement-fb_get_caps
+++ a/drivers/video/s3fb.c
@@ -799,6 +799,23 @@ static int s3fb_pan_display(struct fb_va
 	return 0;
 }
 
+/* Get capabilities of accelerator based on the mode */
+
+static void s3fb_get_caps(struct fb_info *info, struct fb_blit_caps *caps,
+			  struct fb_var_screeninfo *var)
+{
+	if (var->bits_per_pixel == 0) {
+		/* can only support 256 8x16 bitmap */
+		caps->x = 1 << (8 - 1);
+		caps->y = 1 << (16 - 1);
+		caps->len = 256;
+	} else {
+		caps->x = ~(u32)0;
+		caps->y = ~(u32)0;
+		caps->len = ~(u32)0;
+	}
+}
+
 /* ------------------------------------------------------------------------- */
 
 /* Frame buffer operations */
@@ -815,6 +832,7 @@ static struct fb_ops s3fb_ops = {
 	.fb_fillrect	= s3fb_fillrect,
 	.fb_copyarea	= cfb_copyarea,
 	.fb_imageblit	= s3fb_imageblit,
+	.fb_get_caps    = s3fb_get_caps,
 };
 
 /* ------------------------------------------------------------------------- */
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
