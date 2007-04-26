From: akpm@linux-foundation.org
Subject: + fbdev-add-fb_read-fb_write-functions-for-framebuffers.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:33:01 -0700
Message-ID: <200704260033.l3Q0X1Sq016966@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423426AbXDZAdF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:33:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     fbdev: add fb_read/fb_write functions for framebuffers  in system RAM
has been added to the -mm tree.  Its filename is
     fbdev-add-fb_read-fb_write-functions-for-framebuffers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: add fb_read/fb_write functions for framebuffers  in system RAM
From: "Antonino A. Daplas" <adaplas@gmail.com>

The functions fb_read() and fb_write in fbmem.c assume that the framebuffer
is in IO memory.  However, we have 3 drivers (hecubafb, arcfb, and vfb)
where the framebuffer is allocated from system RAM (via vmalloc). Using
__raw_read/__raw_write (fb_readl/fb_writel) for these drivers is
illegal, especially in other platforms.

Create file read and write methods for these types of drivers.  These are
named fb_sys_read() and fb_sys_write().

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig       |    5 +
 drivers/video/Makefile      |    1 
 drivers/video/fb_sys_fops.c |  104 ++++++++++++++++++++++++++++++++++
 include/linux/fb.h          |    4 +
 4 files changed, 114 insertions(+)

diff -puN drivers/video/Kconfig~fbdev-add-fb_read-fb_write-functions-for-framebuffers drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-add-fb_read-fb_write-functions-for-framebuffers
+++ a/drivers/video/Kconfig
@@ -122,6 +122,11 @@ config FB_SYS_IMAGEBLIT
 	  blitting. This is used by drivers that don't provide their own
 	  (accelerated) version and the framebuffer is in system RAM.
 
+config FB_SYS_FOPS
+       tristate
+       depends on FB
+       default n
+
 config FB_DEFERRED_IO
 	bool
 	depends on FB
diff -puN drivers/video/Makefile~fbdev-add-fb_read-fb_write-functions-for-framebuffers drivers/video/Makefile
--- a/drivers/video/Makefile~fbdev-add-fb_read-fb_write-functions-for-framebuffers
+++ a/drivers/video/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_FB_CFB_IMAGEBLIT) += cfbimg
 obj-$(CONFIG_FB_SYS_FILLRECT)  += sysfillrect.o
 obj-$(CONFIG_FB_SYS_COPYAREA)  += syscopyarea.o
 obj-$(CONFIG_FB_SYS_IMAGEBLIT) += sysimgblt.o
+obj-$(CONFIG_FB_SYS_FOPS)      += fb_sys_fops.o
 obj-$(CONFIG_FB_SVGALIB)       += svgalib.o
 obj-$(CONFIG_FB_MACMODES)      += macmodes.o
 obj-$(CONFIG_FB_DDC)           += fb_ddc.o
diff -puN /dev/null drivers/video/fb_sys_fops.c
--- /dev/null
+++ a/drivers/video/fb_sys_fops.c
@@ -0,0 +1,104 @@
+/*
+ * linux/drivers/video/fb_sys_read.c - Generic file operations where
+ * framebuffer is in system RAM
+ *
+ * Copyright (C) 2007 Antonino Daplas <adaplas@pol.net>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ *
+ */
+#include <linux/fb.h>
+#include <linux/module.h>
+#include <asm/uaccess.h>
+
+ssize_t fb_sys_read(struct fb_info *info, char __user *buf, size_t count,
+		    loff_t *ppos)
+{
+	unsigned long p = *ppos;
+	void *src;
+	int err = 0;
+	unsigned long total_size;
+
+	if (info->state != FBINFO_STATE_RUNNING)
+		return -EPERM;
+
+	total_size = info->screen_size;
+
+	if (total_size == 0)
+		total_size = info->fix.smem_len;
+
+	if (p >= total_size)
+		return 0;
+
+	if (count >= total_size)
+		count = total_size;
+
+	if (count + p > total_size)
+		count = total_size - p;
+
+	src = (void __force *)(info->screen_base + p);
+
+	if (info->fbops->fb_sync)
+		info->fbops->fb_sync(info);
+
+	if (copy_to_user(buf, src, count))
+		err = -EFAULT;
+
+	if  (!err)
+		*ppos += count;
+
+	return (err) ? err : count;
+}
+EXPORT_SYMBOL_GPL(fb_sys_read);
+
+ssize_t fb_sys_write(struct fb_info *info, const char __user *buf,
+		     size_t count, loff_t *ppos)
+{
+	unsigned long p = *ppos;
+	void *dst;
+	int err = 0;
+	unsigned long total_size;
+
+	if (info->state != FBINFO_STATE_RUNNING)
+		return -EPERM;
+
+	total_size = info->screen_size;
+
+	if (total_size == 0)
+		total_size = info->fix.smem_len;
+
+	if (p > total_size)
+		return -EFBIG;
+
+	if (count > total_size) {
+		err = -EFBIG;
+		count = total_size;
+	}
+
+	if (count + p > total_size) {
+		if (!err)
+			err = -ENOSPC;
+
+		count = total_size - p;
+	}
+
+	dst = (void __force *) (info->screen_base + p);
+
+	if (info->fbops->fb_sync)
+		info->fbops->fb_sync(info);
+
+	if (copy_from_user(dst, buf, count))
+		err = -EFAULT;
+
+	if  (!err)
+		*ppos += count;
+
+	return (err) ? err : count;
+}
+EXPORT_SYMBOL_GPL(fb_sys_write);
+
+MODULE_AUTHOR("Antonino Daplas <adaplas@pol.net>");
+MODULE_DESCRIPTION("Generic file read (fb in system RAM)");
+MODULE_LICENSE("GPL");
diff -puN include/linux/fb.h~fbdev-add-fb_read-fb_write-functions-for-framebuffers include/linux/fb.h
--- a/include/linux/fb.h~fbdev-add-fb_read-fb_write-functions-for-framebuffers
+++ a/include/linux/fb.h
@@ -903,6 +903,10 @@ extern void cfb_imageblit(struct fb_info
 extern void sys_fillrect(struct fb_info *info, const struct fb_fillrect *rect);
 extern void sys_copyarea(struct fb_info *info, const struct fb_copyarea *area);
 extern void sys_imageblit(struct fb_info *info, const struct fb_image *image);
+extern ssize_t fb_sys_read(struct fb_info *info, char __user *buf,
+			   size_t count, loff_t *ppos);
+extern ssize_t fb_sys_write(struct fb_info *info, const char __user *buf,
+			    size_t count, loff_t *ppos);
 
 /* drivers/video/fbmem.c */
 extern int register_framebuffer(struct fb_info *fb_info);
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
