From: akpm@linux-foundation.org
Subject: - fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:35:43 -0700
Message-ID: <200810202035.m9KKZhso011205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754142AbYJTUql (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, righi.andrea@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fb: convert lock/unlock_kernel() into local fb mutex
has been removed from the -mm tree.  Its filename was
     fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fb: convert lock/unlock_kernel() into local fb mutex
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Change lock_kernel()/unlock_kernel() to local fb mutex.  Each frame buffer
instance has its own mutex.

The one line try_to_load() function is unrolled to request_module() in two
places for readability.

[righi.andrea@gmail.com: fb: fix NULL pointer BUG dereference in fb_open()]
Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |   39 ++++++++++++++++++++-------------------
 include/linux/fb.h    |    1 +
 2 files changed, 21 insertions(+), 19 deletions(-)

diff -puN drivers/video/fbmem.c~fb-convert-lock-unlock_kernel-into-local-fb-mutex drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fb-convert-lock-unlock_kernel-into-local-fb-mutex
+++ a/drivers/video/fbmem.c
@@ -1018,12 +1018,12 @@ fb_ioctl(struct file *file, unsigned int
 	void __user *argp = (void __user *)arg;
 	long ret = 0;
 
-	lock_kernel();
 	info = registered_fb[fbidx];
+	mutex_lock(&info->lock);
 	fb = info->fbops;
 
 	if (!fb) {
-		unlock_kernel();
+		mutex_unlock(&info->lock);
 		return -ENODEV;
 	}
 	switch (cmd) {
@@ -1126,7 +1126,7 @@ fb_ioctl(struct file *file, unsigned int
 		else
 			ret = fb->fb_ioctl(info, cmd, arg);
 	}
-	unlock_kernel();
+	mutex_unlock(&info->lock);
 	return ret;
 }
 
@@ -1253,7 +1253,7 @@ fb_compat_ioctl(struct file *file, unsig
 	struct fb_ops *fb = info->fbops;
 	long ret = -ENOIOCTLCMD;
 
-	lock_kernel();
+	mutex_lock(&info->lock);
 	switch(cmd) {
 	case FBIOGET_VSCREENINFO:
 	case FBIOPUT_VSCREENINFO:
@@ -1279,7 +1279,7 @@ fb_compat_ioctl(struct file *file, unsig
 			ret = fb->fb_compat_ioctl(info, cmd, arg);
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&info->lock);
 	return ret;
 }
 #endif
@@ -1301,13 +1301,13 @@ fb_mmap(struct file *file, struct vm_are
 		return -ENODEV;
 	if (fb->fb_mmap) {
 		int res;
-		lock_kernel();
+		mutex_lock(&info->lock);
 		res = fb->fb_mmap(info, vma);
-		unlock_kernel();
+		mutex_unlock(&info->lock);
 		return res;
 	}
 
-	lock_kernel();
+	mutex_lock(&info->lock);
 
 	/* frame buffer memory */
 	start = info->fix.smem_start;
@@ -1316,13 +1316,13 @@ fb_mmap(struct file *file, struct vm_are
 		/* memory mapped io */
 		off -= len;
 		if (info->var.accel_flags) {
-			unlock_kernel();
+			mutex_unlock(&info->lock);
 			return -EINVAL;
 		}
 		start = info->fix.mmio_start;
 		len = PAGE_ALIGN((start & ~PAGE_MASK) + info->fix.mmio_len);
 	}
-	unlock_kernel();
+	mutex_unlock(&info->lock);
 	start &= PAGE_MASK;
 	if ((vma->vm_end - vma->vm_start + off) > len)
 		return -EINVAL;
@@ -1346,13 +1346,13 @@ fb_open(struct inode *inode, struct file
 
 	if (fbidx >= FB_MAX)
 		return -ENODEV;
-	lock_kernel();
-	if (!(info = registered_fb[fbidx]))
+	info = registered_fb[fbidx];
+	if (!info)
 		request_module("fb%d", fbidx);
-	if (!(info = registered_fb[fbidx])) {
-		res = -ENODEV;
-		goto out;
-	}
+	info = registered_fb[fbidx];
+	if (!info)
+		return -ENODEV;
+	mutex_lock(&info->lock);
 	if (!try_module_get(info->fbops->owner)) {
 		res = -ENODEV;
 		goto out;
@@ -1368,7 +1368,7 @@ fb_open(struct inode *inode, struct file
 		fb_deferred_io_open(info, inode, file);
 #endif
 out:
-	unlock_kernel();
+	mutex_unlock(&info->lock);
 	return res;
 }
 
@@ -1377,11 +1377,11 @@ fb_release(struct inode *inode, struct f
 {
 	struct fb_info * const info = file->private_data;
 
-	lock_kernel();
+	mutex_lock(&info->lock);
 	if (info->fbops->fb_release)
 		info->fbops->fb_release(info,1);
 	module_put(info->fbops->owner);
-	unlock_kernel();
+	mutex_unlock(&info->lock);
 	return 0;
 }
 
@@ -1460,6 +1460,7 @@ register_framebuffer(struct fb_info *fb_
 		if (!registered_fb[i])
 			break;
 	fb_info->node = i;
+	mutex_init(&fb_info->lock);
 
 	fb_info->dev = device_create(fb_class, fb_info->device,
 				     MKDEV(FB_MAJOR, i), NULL, "fb%d", i);
diff -puN include/linux/fb.h~fb-convert-lock-unlock_kernel-into-local-fb-mutex include/linux/fb.h
--- a/include/linux/fb.h~fb-convert-lock-unlock_kernel-into-local-fb-mutex
+++ a/include/linux/fb.h
@@ -808,6 +808,7 @@ struct fb_tile_ops {
 struct fb_info {
 	int node;
 	int flags;
+	struct mutex lock;		/* Lock for open/release/ioctl funcs */
 	struct fb_var_screeninfo var;	/* Current var */
 	struct fb_fix_screeninfo fix;	/* Current fix */
 	struct fb_monspecs monspecs;	/* Current Monitor specs */
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

