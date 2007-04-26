From: akpm@linux-foundation.org
Subject: + savagefb-rework-i2c-bit-access.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:32:35 -0700
Message-ID: <200704260032.l3Q0WZ4N016904@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423408AbXDZAci (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:32:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     savagefb: rework i2c bit access
has been added to the -mm tree.  Its filename is
     savagefb-rework-i2c-bit-access.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: savagefb: rework i2c bit access
From: "Antonino A. Daplas" <adaplas@gmail.com>

Use already defined VGAwCR/VGArCR functions to access the i2c bus.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/savage/savagefb-i2c.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff -puN drivers/video/savage/savagefb-i2c.c~savagefb-rework-i2c-bit-access drivers/video/savage/savagefb-i2c.c
--- a/drivers/video/savage/savagefb-i2c.c~savagefb-rework-i2c-bit-access
+++ a/drivers/video/savage/savagefb-i2c.c
@@ -41,10 +41,6 @@
 #define SAVAGE4_I2C_SCL_IN	0x00000008
 #define SAVAGE4_I2C_SDA_IN	0x00000010
 
-#define SET_CR_IX(base, val)	writeb((val), base + 0x8000 + VGA_CR_IX)
-#define SET_CR_DATA(base, val)	writeb((val), base + 0x8000 + VGA_CR_DATA)
-#define GET_CR_DATA(base)	readb(base + 0x8000 + VGA_CR_DATA)
-
 static void savage4_gpio_setscl(void *data, int val)
 {
 	struct savagefb_i2c_chan *chan = data;
@@ -92,15 +88,15 @@ static void prosavage_gpio_setscl(void* 
 	struct savagefb_i2c_chan *chan = data;
 	u32			  r;
 
-	SET_CR_IX(chan->ioaddr, chan->reg);
-	r = GET_CR_DATA(chan->ioaddr);
+	r = VGArCR(chan->reg, chan->par);
 	r |= PROSAVAGE_I2C_ENAB;
 	if (val) {
 		r |= PROSAVAGE_I2C_SCL_OUT;
 	} else {
 		r &= ~PROSAVAGE_I2C_SCL_OUT;
 	}
-	SET_CR_DATA(chan->ioaddr, r);
+
+	VGAwCR(chan->reg, r, chan->par);
 }
 
 static void prosavage_gpio_setsda(void* data, int val)
@@ -108,31 +104,29 @@ static void prosavage_gpio_setsda(void* 
 	struct savagefb_i2c_chan *chan = data;
 	unsigned int r;
 
-	SET_CR_IX(chan->ioaddr, chan->reg);
-	r = GET_CR_DATA(chan->ioaddr);
+	r = VGArCR(chan->reg, chan->par);
 	r |= PROSAVAGE_I2C_ENAB;
 	if (val) {
 		r |= PROSAVAGE_I2C_SDA_OUT;
 	} else {
 		r &= ~PROSAVAGE_I2C_SDA_OUT;
 	}
-	SET_CR_DATA(chan->ioaddr, r);
+
+	VGAwCR(chan->reg, r, chan->par);
 }
 
 static int prosavage_gpio_getscl(void* data)
 {
 	struct savagefb_i2c_chan *chan = data;
 
-	SET_CR_IX(chan->ioaddr, chan->reg);
-	return (0 != (GET_CR_DATA(chan->ioaddr) & PROSAVAGE_I2C_SCL_IN));
+	return (VGArCR(chan->reg, chan->par) & PROSAVAGE_I2C_SCL_IN) ? 1 : 0;
 }
 
 static int prosavage_gpio_getsda(void* data)
 {
 	struct savagefb_i2c_chan *chan = data;
 
-	SET_CR_IX(chan->ioaddr, chan->reg);
-	return (0 != (GET_CR_DATA(chan->ioaddr) & PROSAVAGE_I2C_SDA_IN));
+	return (VGArCR(chan->reg, chan->par) & PROSAVAGE_I2C_SDA_IN) ? 1 : 0;
 }
 
 static int savage_setup_i2c_bus(struct savagefb_i2c_chan *chan,
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
