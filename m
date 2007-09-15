From: akpm@linux-foundation.org
Subject: + nvidiafb-add-boot-option-to-reverse-i2c-port-assignment.patch added to -mm tree
Date: Fri, 14 Sep 2007 19:25:18 -0700
Message-ID: <200709150225.l8F2PIpJ002951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49622 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753869AbXIOCZ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 22:25:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com, adaplas@gail.com


The patch titled
     nvidiafb: Add boot option to reverse i2c port assignment
has been added to the -mm tree.  Its filename is
     nvidiafb-add-boot-option-to-reverse-i2c-port-assignment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nvidiafb: Add boot option to reverse i2c port assignment
From: "Antonino A. Daplas" <adaplas@gmail.com>

There are a few nvidia hardware where the i2c port assignments are reversed,
i.e., the 1st i2c port is assigned to the secondary display and the 2nd i2c
port to the primary display.  In most cases, if only 1 display is attached, or
if only 1 flatpanel and 1 analog display is attached, the port reversal is of
no consequence.  However if 2 flatpanels are attached, it can cause display
problems.

There is no sane way of determining if the hardware reversed the i2c port
assignment, so the simplest fix is to add a boot/module option, "reverse_i2c
to explicitly reverse the i2c port.

This also restores i2c ordering back to the pre-2.6.22 state.

Signed-off-by: Antonino Daplas <adaplas@gail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nv_i2c.c  |    8 ++++----
 drivers/video/nvidia/nv_type.h |    1 +
 drivers/video/nvidia/nvidia.c  |    6 ++++++
 3 files changed, 11 insertions(+), 4 deletions(-)

diff -puN drivers/video/nvidia/nv_i2c.c~nvidiafb-add-boot-option-to-reverse-i2c-port-assignment drivers/video/nvidia/nv_i2c.c
--- a/drivers/video/nvidia/nv_i2c.c~nvidiafb-add-boot-option-to-reverse-i2c-port-assignment
+++ a/drivers/video/nvidia/nv_i2c.c
@@ -125,11 +125,11 @@ void nvidia_create_i2c_busses(struct nvi
 	par->chan[1].par = par;
 	par->chan[2].par = par;
 
-	par->chan[0].ddc_base = 0x36;
- 	nvidia_setup_i2c_bus(&par->chan[0], "nvidia #0", I2C_CLASS_HWMON);
+	par->chan[0].ddc_base = (par->reverse_i2c) ? 0x36 : 0x3e;
+ 	nvidia_setup_i2c_bus(&par->chan[0], "nvidia #0", 0);
 
-	par->chan[1].ddc_base = 0x3e;
- 	nvidia_setup_i2c_bus(&par->chan[1], "nvidia #1", 0);
+	par->chan[1].ddc_base = (par->reverse_i2c) ? 0x3e : 0x36;
+ 	nvidia_setup_i2c_bus(&par->chan[1], "nvidia #1", I2C_CLASS_HWMON);
 
 	par->chan[2].ddc_base = 0x50;
  	nvidia_setup_i2c_bus(&par->chan[2], "nvidia #2", 0);
diff -puN drivers/video/nvidia/nv_type.h~nvidiafb-add-boot-option-to-reverse-i2c-port-assignment drivers/video/nvidia/nv_type.h
--- a/drivers/video/nvidia/nv_type.h~nvidiafb-add-boot-option-to-reverse-i2c-port-assignment
+++ a/drivers/video/nvidia/nv_type.h
@@ -135,6 +135,7 @@ struct nvidia_par {
 	int paneltweak;
 	int LVDS;
 	int pm_state;
+	int reverse_i2c;
 	u32 crtcSync_read;
 	u32 fpSyncs;
 	u32 dmaPut;
diff -puN drivers/video/nvidia/nvidia.c~nvidiafb-add-boot-option-to-reverse-i2c-port-assignment drivers/video/nvidia/nvidia.c
--- a/drivers/video/nvidia/nvidia.c~nvidiafb-add-boot-option-to-reverse-i2c-port-assignment
+++ a/drivers/video/nvidia/nvidia.c
@@ -79,6 +79,7 @@ static int noscale __devinitdata = 0;
 static int paneltweak __devinitdata = 0;
 static int vram __devinitdata = 0;
 static int bpp __devinitdata = 8;
+static int reverse_i2c __devinitdata;
 #ifdef CONFIG_MTRR
 static int nomtrr __devinitdata = 0;
 #endif
@@ -1305,6 +1306,7 @@ static int __devinit nvidiafb_probe(stru
 	par->CRTCnumber = forceCRTC;
 	par->FpScale = (!noscale);
 	par->paneltweak = paneltweak;
+	par->reverse_i2c = reverse_i2c;
 
 	/* enable IO and mem if not already done */
 	pci_read_config_word(pd, PCI_COMMAND, &cmd);
@@ -1486,6 +1488,8 @@ static int __devinit nvidiafb_setup(char
 			noaccel = 1;
 		} else if (!strncmp(this_opt, "noscale", 7)) {
 			noscale = 1;
+		} else if (!strncmp(this_opt, "reverse_i2c", 11)) {
+			reverse_i2c = 1;
 		} else if (!strncmp(this_opt, "paneltweak:", 11)) {
 			paneltweak = simple_strtoul(this_opt+11, NULL, 0);
 		} else if (!strncmp(this_opt, "vram:", 5)) {
@@ -1582,6 +1586,8 @@ MODULE_PARM_DESC(mode_option, "Specify i
 module_param(bpp, int, 0);
 MODULE_PARM_DESC(bpp, "pixel width in bits"
 		 "(default=8)");
+module_param(reverse_i2c, int, 0);
+MODULE_PARM_DESC(reverse_i2c, "reverse port assignment of the i2c bus");
 #ifdef CONFIG_MTRR
 module_param(nomtrr, bool, 0);
 MODULE_PARM_DESC(nomtrr, "Disables MTRR support (0 or 1=disabled) "
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
