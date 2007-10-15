From: akpm@linux-foundation.org
Subject: + fbcon-delay-the-start-of-the-cursor-timer-until-a-con_switch.patch added to -mm tree
Date: Mon, 15 Oct 2007 15:38:05 -0700
Message-ID: <200710152238.l9FMc6RF028817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39023 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753154AbXJOWiL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 18:38:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     fbcon: delay the start of the cursor timer until a con_switch()
has been added to the -mm tree.  Its filename is
     fbcon-delay-the-start-of-the-cursor-timer-until-a-con_switch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbcon: delay the start of the cursor timer until a con_switch()
From: Antonino Daplas <adaplas@gmail.com>

As reported in Bugzilla Bug 9093, upon switching to X, a small rectangular
cursor can still be seen blinking in the upper left part of the screen.  It is
fbcon's text cursor.  This is caused by a strange ioctl(..., KDSETMODE,
KD_TEXT) call done by something in userspace, perhaps by X itself, while the
tty is still in graphics mode.  And when the tty is in KD_TEXT mode, the
cursor timer is restarted.

Although this is a userspace problem, we can work around it by delaying the
restart of the cursor timer until an fbcon_switch() is called.  In other
words, the cursor timer will not be restarted even if a KD_TEXT mode switch is
requested.

Regression potential: Present but low

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/console/fbcon.c~fbcon-delay-the-start-of-the-cursor-timer-until-a-con_switch drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-delay-the-start-of-the-cursor-timer-until-a-con_switch
+++ a/drivers/video/console/fbcon.c
@@ -2405,7 +2405,7 @@ static int fbcon_blank(struct vc_data *v
 			update_screen(vc);
 	}
 
-	if (fbcon_is_inactive(vc, info) ||
+	if (mode_switch || fbcon_is_inactive(vc, info) ||
 	    ops->blank_state != FB_BLANK_UNBLANK)
 		fbcon_del_cursor_timer(info);
 	else
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
fbcon-logo-disable-logo-at-boot-fix.patch
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
svgalib-mode-selection-updates.patch
s3fb-do-not-allow-incorrect-pixclock-settings.patch
fbdev-copyarea-function-taught-to-fully-support-swapped-pixel-order-in-byte.patch
fbcon-delay-the-start-of-the-cursor-timer-until-a-con_switch.patch
cyber2000fb-checkpatch-fixes.patch
