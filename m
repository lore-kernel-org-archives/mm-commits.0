From: akpm@linux-foundation.org
Subject: + fbdev-pass-struct-fb_info-to-fb_read-and-fb_write.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:32:59 -0700
Message-ID: <200704260032.l3Q0Wxf9016963@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423436AbXDZAdC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:33:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     fbdev: pass struct fb_info to fb_read and fb_write
has been added to the -mm tree.  Its filename is
     fbdev-pass-struct-fb_info-to-fb_read-and-fb_write.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: pass struct fb_info to fb_read and fb_write
From: "Antonino A. Daplas" <adaplas@gmail.com>

It is unnecessary to pass struct file to fb_read() and fb_write() in struct
fb_ops. For consistency with the other methods, pass struct fb_info instead.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/arcfb.c       |   14 ++------------
 drivers/video/epson1355fb.c |   18 ++----------------
 drivers/video/fbmem.c       |    4 ++--
 drivers/video/hecubafb.c    |   12 +-----------
 drivers/video/pvr2fb.c      |    4 ++--
 include/linux/fb.h          |    6 ++++--
 6 files changed, 13 insertions(+), 45 deletions(-)

diff -puN drivers/video/arcfb.c~fbdev-pass-struct-fb_info-to-fb_read-and-fb_write drivers/video/arcfb.c
--- a/drivers/video/arcfb.c~fbdev-pass-struct-fb_info-to-fb_read-and-fb_write
+++ a/drivers/video/arcfb.c
@@ -440,14 +440,11 @@ static int arcfb_ioctl(struct fb_info *i
  * the fb. it's inefficient for them to do anything less than 64*8
  * writes since we update the lcd in each write() anyway.
  */
-static ssize_t arcfb_write(struct file *file, const char __user *buf, size_t count,
-				loff_t *ppos)
+static ssize_t arcfb_write(struct fb_info *info, const char __user *buf,
+			   size_t count, loff_t *ppos)
 {
 	/* modded from epson 1355 */
 
-	struct inode *inode;
-	int fbidx;
-	struct fb_info *info;
 	unsigned long p;
 	int err=-EINVAL;
 	unsigned int fbmemlength,x,y,w,h, bitppos, startpos, endpos, bitcount;
@@ -455,13 +452,6 @@ static ssize_t arcfb_write(struct file *
 	unsigned int xres;
 
 	p = *ppos;
-	inode = file->f_path.dentry->d_inode;
-	fbidx = iminor(inode);
-	info = registered_fb[fbidx];
-
-	if (!info || !info->screen_base)
-		return -ENODEV;
-
 	par = info->par;
 	xres = info->var.xres;
 	fbmemlength = (xres * info->var.yres)/8;
diff -puN drivers/video/epson1355fb.c~fbdev-pass-struct-fb_info-to-fb_read-and-fb_write drivers/video/epson1355fb.c
--- a/drivers/video/epson1355fb.c~fbdev-pass-struct-fb_info-to-fb_read-and-fb_write
+++ a/drivers/video/epson1355fb.c
@@ -403,17 +403,10 @@ static inline unsigned long copy_to_user
 
 
 static ssize_t
-epson1355fb_read(struct file *file, char *buf, size_t count, loff_t * ppos)
+epson1355fb_read(struct fb_info *info, char *buf, size_t count, loff_t * ppos)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int fbidx = iminor(inode);
-	struct fb_info *info = registered_fb[fbidx];
 	unsigned long p = *ppos;
 
-	/* from fbmem.c except for our own copy_*_user */
-	if (!info || !info->screen_base)
-		return -ENODEV;
-
 	if (p >= info->fix.smem_len)
 		return 0;
 	if (count >= info->fix.smem_len)
@@ -434,20 +427,13 @@ epson1355fb_read(struct file *file, char
 }
 
 static ssize_t
-epson1355fb_write(struct file *file, const char *buf,
+epson1355fb_write(struct fb_info *info, const char *buf,
 		  size_t count, loff_t * ppos)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int fbidx = iminor(inode);
-	struct fb_info *info = registered_fb[fbidx];
 	unsigned long p = *ppos;
 	int err;
 
 	/* from fbmem.c except for our own copy_*_user */
-	if (!info || !info->screen_base)
-		return -ENODEV;
-
-	/* from fbmem.c except for our own copy_*_user */
 	if (p > info->fix.smem_len)
 		return -ENOSPC;
 	if (count >= info->fix.smem_len)
diff -puN drivers/video/fbmem.c~fbdev-pass-struct-fb_info-to-fb_read-and-fb_write drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-pass-struct-fb_info-to-fb_read-and-fb_write
+++ a/drivers/video/fbmem.c
@@ -588,7 +588,7 @@ fb_read(struct file *file, char __user *
 		return -EPERM;
 
 	if (info->fbops->fb_read)
-		return info->fbops->fb_read(file, buf, count, ppos);
+		return info->fbops->fb_read(info, buf, count, ppos);
 	
 	total_size = info->screen_size;
 
@@ -663,7 +663,7 @@ fb_write(struct file *file, const char _
 		return -EPERM;
 
 	if (info->fbops->fb_write)
-		return info->fbops->fb_write(file, buf, count, ppos);
+		return info->fbops->fb_write(info, buf, count, ppos);
 	
 	total_size = info->screen_size;
 
diff -puN drivers/video/hecubafb.c~fbdev-pass-struct-fb_info-to-fb_read-and-fb_write drivers/video/hecubafb.c
--- a/drivers/video/hecubafb.c~fbdev-pass-struct-fb_info-to-fb_read-and-fb_write
+++ a/drivers/video/hecubafb.c
@@ -267,12 +267,9 @@ static void hecubafb_imageblit(struct fb
  * this is the slow path from userspace. they can seek and write to
  * the fb. it's inefficient to do anything less than a full screen draw
  */
-static ssize_t hecubafb_write(struct file *file, const char __user *buf,
+static ssize_t hecubafb_write(struct fb_info *info, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
-	struct inode *inode;
-	int fbidx;
-	struct fb_info *info;
 	unsigned long p;
 	int err=-EINVAL;
 	struct hecubafb_par *par;
@@ -280,13 +277,6 @@ static ssize_t hecubafb_write(struct fil
 	unsigned int fbmemlength;
 
 	p = *ppos;
-	inode = file->f_dentry->d_inode;
-	fbidx = iminor(inode);
-	info = registered_fb[fbidx];
-
-	if (!info || !info->screen_base)
-		return -ENODEV;
-
 	par = info->par;
 	xres = info->var.xres;
 	fbmemlength = (xres * info->var.yres)/8;
diff -puN drivers/video/pvr2fb.c~fbdev-pass-struct-fb_info-to-fb_read-and-fb_write drivers/video/pvr2fb.c
--- a/drivers/video/pvr2fb.c~fbdev-pass-struct-fb_info-to-fb_read-and-fb_write
+++ a/drivers/video/pvr2fb.c
@@ -214,7 +214,7 @@ static int pvr2_init_cable(void);
 static int pvr2_get_param(const struct pvr2_params *p, const char *s,
                             int val, int size);
 #ifdef CONFIG_SH_DMA
-static ssize_t pvr2fb_write(struct file *file, const char *buf,
+static ssize_t pvr2fb_write(struct fb_info *info, const char *buf,
 			    size_t count, loff_t *ppos);
 #endif
 
@@ -674,7 +674,7 @@ static int pvr2_init_cable(void)
 }
 
 #ifdef CONFIG_SH_DMA
-static ssize_t pvr2fb_write(struct file *file, const char *buf,
+static ssize_t pvr2fb_write(struct fb_info *info, const char *buf,
 			    size_t count, loff_t *ppos)
 {
 	unsigned long dst, start, end, len;
diff -puN include/linux/fb.h~fbdev-pass-struct-fb_info-to-fb_read-and-fb_write include/linux/fb.h
--- a/include/linux/fb.h~fbdev-pass-struct-fb_info-to-fb_read-and-fb_write
+++ a/include/linux/fb.h
@@ -591,8 +591,10 @@ struct fb_ops {
 	/* For framebuffers with strange non linear layouts or that do not
 	 * work with normal memory mapped access
 	 */
-	ssize_t (*fb_read)(struct file *file, char __user *buf, size_t count, loff_t *ppos);
-	ssize_t (*fb_write)(struct file *file, const char __user *buf, size_t count, loff_t *ppos);
+	ssize_t (*fb_read)(struct fb_info *info, char __user *buf,
+			   size_t count, loff_t *ppos);
+	ssize_t (*fb_write)(struct fb_info *info, const char __user *buf,
+			    size_t count, loff_t *ppos);
 
 	/* checks var and eventually tweaks it to something supported,
 	 * DO NOT MODIFY PAR */
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
