From: akpm@linux-foundation.org
Subject: + arkfb-fix-compiler-warnings.patch added to -mm tree
Date: Mon, 07 May 2007 15:27:09 -0700
Message-ID: <200705072227.l47MR9B7006970@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967036AbXEGW1n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 18:27:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     arkfb: fix compiler warnings
has been added to the -mm tree.  Its filename is
     arkfb-fix-compiler-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arkfb: fix compiler warnings
From: "Antonino A. Daplas" <adaplas@gmail.com>

- add sparse annotations
- check return value of pci_enable_device()
- fix if CONFIG_PM=n

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/arkfb.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff -puN drivers/video/arkfb.c~arkfb-fix-compiler-warnings drivers/video/arkfb.c
--- a/drivers/video/arkfb.c~arkfb-fix-compiler-warnings
+++ a/drivers/video/arkfb.c
@@ -131,21 +131,22 @@ MODULE_PARM_DESC(mtrr, "FIFO threshold")
 static void arkfb_settile(struct fb_info *info, struct fb_tilemap *map)
 {
 	const u8 *font = map->data;
-	u8* fb = (u8 *) info->screen_base;
+	u8 __iomem *fb = (u8 __iomem *)info->screen_base;
 	int i, c;
 
 	if ((map->width != 8) || (map->height != 16) ||
 	    (map->depth != 1) || (map->length != 256)) {
-	    	printk(KERN_ERR "fb%d: unsupported font parameters: width %d, height %d, depth %d, length %d\n",
-			info->node, map->width, map->height, map->depth, map->length);
+	    	printk(KERN_ERR "fb%d: unsupported font parameters: width %d, "
+		       "height %d, depth %d, length %d\n", info->node,
+		       map->width, map->height, map->depth, map->length);
 		return;
 	}
 
 	fb += 2;
 	for (c = 0; c < map->length; c++) {
 		for (i = 0; i < map->height; i++) {
-			fb[i * 4] = font[i];
-			fb[i * 4 + (128*8)] = font[i];
+			fb_writeb(font[i], &fb[i * 4]);
+			fb_writeb(font[i], &fb[i * 4 + (128 * 8)]);
 		}
 		fb += 128;
 
@@ -1080,6 +1081,7 @@ static void __devexit ark_pci_remove(str
 }
 
 
+#ifdef CONFIG_PM
 /* PCI suspend */
 
 static int ark_pci_suspend (struct pci_dev* dev, pm_message_t state)
@@ -1131,17 +1133,24 @@ static int ark_pci_resume (struct pci_de
 
 	pci_set_power_state(dev, PCI_D0);
 	pci_restore_state(dev);
-	pci_enable_device(dev);
+
+	if (pci_enable_device(dev))
+		goto fail;
+
 	pci_set_master(dev);
 
 	arkfb_set_par(info);
 	fb_set_suspend(info, 0);
 
 	mutex_unlock(&(par->open_lock));
+fail:
 	release_console_sem();
 	return 0;
 }
-
+#else
+#define ark_pci_suspend NULL
+#define ark_pci_resume NULL
+#endif /* CONFIG_PM */
 
 /* List of boards that we are trying to support */
 
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
