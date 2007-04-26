From: akpm@linux-foundation.org
Subject: + fbdev-advertise-limitation-of-drawing-engine.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:33:08 -0700
Message-ID: <200704260033.l3Q0X8cq016982@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423447AbXDZAdM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:33:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     fbdev: advertise limitation of drawing engine
has been added to the -mm tree.  Its filename is
     fbdev-advertise-limitation-of-drawing-engine.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: advertise limitation of drawing engine
From: "Antonino A. Daplas" <adaplas@gmail.com>

A few drivers are not capable of blitting rectangles of any dimension.
vga16fb can only blit 8-pixel wide rectangles, while s3fb (in tileblitting
mode) can only blit 8x16 rectangles.  For example, loading a 12x22 font in
vga16fb will result in a corrupt display.

Advertise this limitation/capability in info->pixmap.blit_x and blit_y.  These
fields are 32-bit arrays (font max is 32x32 only), ie, if bit 7 is set, then
width/height of 7+1 is supported.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    6 ++++++
 include/linux/fb.h    |    4 ++++
 2 files changed, 10 insertions(+)

diff -puN drivers/video/fbmem.c~fbdev-advertise-limitation-of-drawing-engine drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-advertise-limitation-of-drawing-engine
+++ a/drivers/video/fbmem.c
@@ -1321,6 +1321,12 @@ register_framebuffer(struct fb_info *fb_
 	}	
 	fb_info->pixmap.offset = 0;
 
+	if (!fb_info->pixmap.blit_x)
+		fb_info->pixmap.blit_x = ~(u32)0;
+
+	if (!fb_info->pixmap.blit_y)
+		fb_info->pixmap.blit_y = ~(u32)0;
+
 	if (!fb_info->modelist.prev || !fb_info->modelist.next)
 		INIT_LIST_HEAD(&fb_info->modelist);
 
diff -puN include/linux/fb.h~fbdev-advertise-limitation-of-drawing-engine include/linux/fb.h
--- a/include/linux/fb.h~fbdev-advertise-limitation-of-drawing-engine
+++ a/include/linux/fb.h
@@ -558,6 +558,10 @@ struct fb_pixmap {
 	u32 scan_align;		/* alignment per scanline		*/
 	u32 access_align;	/* alignment per read/write (bits)	*/
 	u32 flags;		/* see FB_PIXMAP_*			*/
+	u32 blit_x;             /* supported bit block dimensions (1-32)*/
+	u32 blit_y;             /* Format: blit_x = 1 << (width - 1)    */
+	                        /*         blit_y = 1 << (height - 1)   */
+	                        /* if 0, will be set to 0xffffffff (all)*/
 	/* access methods */
 	void (*writeio)(struct fb_info *info, void __iomem *dst, void *src, unsigned int size);
 	void (*readio) (struct fb_info *info, void *dst, void __iomem *src, unsigned int size);
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
