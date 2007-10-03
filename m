From: akpm@linux-foundation.org
Subject: + nvidiafb-correctly-assign-the-i2c-class-with-the-port-reversal.patch added to -mm tree
Date: Wed, 03 Oct 2007 13:52:55 -0700
Message-ID: <200710032052.l93KqtIm008053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38680 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758499AbXJCUw6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 16:52:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     nvidiafb: Correctly assign the i2c class with the port reversal
has been added to the -mm tree.  Its filename is
     nvidiafb-correctly-assign-the-i2c-class-with-the-port-reversal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nvidiafb: Correctly assign the i2c class with the port reversal
From: "Antonino A. Daplas" <adaplas@gmail.com>

If the i2c ports are to be reversed, I2C_CLASS_HWMON assignment must also be
reversed.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/video/nvidia/nv_i2c.c~nvidiafb-correctly-assign-the-i2c-class-with-the-port-reversal drivers/video/nvidia/nv_i2c.c
--- a/drivers/video/nvidia/nv_i2c.c~nvidiafb-correctly-assign-the-i2c-class-with-the-port-reversal
+++ a/drivers/video/nvidia/nv_i2c.c
@@ -126,10 +126,12 @@ void nvidia_create_i2c_busses(struct nvi
 	par->chan[2].par = par;
 
 	par->chan[0].ddc_base = (par->reverse_i2c) ? 0x36 : 0x3e;
- 	nvidia_setup_i2c_bus(&par->chan[0], "nvidia #0", 0);
+ 	nvidia_setup_i2c_bus(&par->chan[0], "nvidia #0",
+			     (par->reverse_i2c) ? I2C_CLASS_HWMON : 0);
 
 	par->chan[1].ddc_base = (par->reverse_i2c) ? 0x3e : 0x36;
- 	nvidia_setup_i2c_bus(&par->chan[1], "nvidia #1", I2C_CLASS_HWMON);
+ 	nvidia_setup_i2c_bus(&par->chan[1], "nvidia #1",
+			     (par->reverse_i2c) ? 0 : I2C_CLASS_HWMON);
 
 	par->chan[2].ddc_base = 0x50;
  	nvidia_setup_i2c_bus(&par->chan[2], "nvidia #2", 0);
_

Patches currently in -mm which might be from adaplas@gmail.com are

fbdev-export-fb_destroy_modelist.patch
connector-change-connectors-max-message-size.patch
uvesafb-add-connector-entries.patch
uvesafb-the-driver-core.patch
uvesafb-documentation.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option-pm2fb-lowsyncs-section-mismatch-fix.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
sm501fb-update-suspend-and-resume-code.patch
sm501fb-call-fb-suspend-function-during-suspend-and-resume.patch
sm501fb-ensure-panel-interface-is-not-tristated-when-setup.patch
mbxfb-improvements-and-new-features.patch
pxafb-add-support-for-other-palette-formats.patch
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
fbdev-fix-incorrect-timings-in-some-modedb-entries.patch
tdfxfb-code-improvements.patch
tdfxfb-hardware-cursor.patch
tdfxfb-mtrr-support.patch
tdfxfb-mtrr-support-fix.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
fbdev-fb_create_modedb-non-static-int-first-=-1.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
pm2fb-permedia-2v-hardware-cursor-support.patch
pm3fb-hardware-cursor-support.patch
s3c2410fb-code-cleanup.patch
s3c2410fb-remove-fb_info-pointer-from-s3c2410fb_info.patch
s3c2410fb-multi-display-support.patch
s3c2410fb-add-margin-fields-to-s3c2410fb_display.patch
s3c2410fb-use-new-margin-fields.patch
s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display.patch
s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display.patch
s3c2410fb-use-vertical-margins-values.patch
s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display.patch
s3c2410fb-remove-lcdcon2-and-lcdcon3-register-fields.patch
s3c2410fb-fix-missing-registers-offset.patch
s3c2410fb-byte-ordering-fixes.patch
atyfb-atyfb-unshare-pseudo_palette.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers-update.patch
vt-fix-warnings-in-selectionh.patch
fbdev-change-asm-uaccessh-to-linux-uaccessh.patch
s3c2410fb-source-code-improvements.patch
s3c2410fb-adds-pixclock-to-s3c2410fb_display.patch
s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display.patch
s3c2410fb-make-use-of-default_display-settings.patch
cirrusfb-checkpatchpl-cleanup.patch
cirrusfb-remove-typedefs.patch
cirrusfb-remove-fields-from-cirrusfb_info.patch
cirrusfb-code-improvements.patch
cirrusfb-code-improvement-2nd-part.patch
pm3fb-header-file-cleanup.patch
pm2fb-hardware-cursor-support-for-the-permedia2.patch
pm2fb-panning-and-hardware-cursor-fixes.patch
vfb-make-virtual-framebuffer-mmapable.patch
fbdev-find-mode-with-the-highest-safest-refresh-rate-in-fb_find_mode.patch
nvidiafb-add-boot-option-to-reverse-i2c-port-assignment.patch
fbdev-support-for-byte-reversed-framebuffer-formats.patch
ps3-fix-black-and-white-stripes.patch
ps3fb-fix-spurious-mode-change-failures.patch
fbdev-update-documentation-fb-00-index.patch
tdfxfb-replace-busy-waiting-with-cpu_relax.patch
pm2fb-replace-busy-waiting-with-cpu_relax.patch
pm3fb-replace-busy-waiting-with-cpu_relax.patch
tdfxfb-checkpatch-fixes.patch
vt-vgacon-check-if-screen-resize-request-comes-from-userspace.patch
nvidiafb-correctly-assign-the-i2c-class-with-the-port-reversal.patch
pmagb-b-fb-improve-diagnostics.patch
fbcon-logo-disable-logo-at-boot.patch
platinumfb-fix-resource-management.patch
bf54x-lq043fb-framebuffer-driver-for-blackfin-bf54x-framebuffer-device-driver.patch
video-gfx-merge-kconfig-menus.patch
ps3av-eliminate-unneeded-temporary-variables.patch
ps3av-eliminate-ps3av_debug.patch
ps3av-use-ps3-video-mode-ids-in-autodetect-code.patch
ps3av-treat-dvi-d-like-hdmi-in-autodetect.patch
ps3av-add-autodetection-for-vesa-modes.patch
ps3av-add-quirk-database-for-broken-monitors.patch
ps3av-remove-unused-ps3av_set_mode.patch
ps3av-dont-distinguish-between-boot-and-non-boot-autodetection.patch
imxfb-fast-read-flag-and-nonstandard-field-configurable.patch
cyber2000fb-checkpatch-fixes.patch
