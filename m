From: akpm@linux-foundation.org
Subject: + fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch added to -mm tree
Date: Tue, 05 Aug 2008 02:00:46 -0700
Message-ID: <200808050900.m7590kFx026688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756708AbYHEJBR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 05:01:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     fb: convert lock/unlock_kernel() into local fb mutex
has been added to the -mm tree.  Its filename is
     fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fb: convert lock/unlock_kernel() into local fb mutex
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Change lock_kernel()/unlock_kernel() to local fb mutex.  Each frame buffer
instance has its own mutex.

The one line try_to_load() function is unrolled to request_module() in two
places for readability.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |   43 +++++++++++++++++-----------------------
 include/linux/fb.h    |    1 
 2 files changed, 20 insertions(+), 24 deletions(-)

diff -puN drivers/video/fbmem.c~fb-convert-lock-unlock_kernel-into-local-fb-mutex drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fb-convert-lock-unlock_kernel-into-local-fb-mutex
+++ a/drivers/video/fbmem.c
@@ -837,13 +837,6 @@ fb_write(struct file *file, const char _
 	return (cnt) ? cnt : err;
 }
 
-#ifdef CONFIG_KMOD
-static void try_to_load(int fb)
-{
-	request_module("fb%d", fb);
-}
-#endif /* CONFIG_KMOD */
-
 int
 fb_pan_display(struct fb_info *info, struct fb_var_screeninfo *var)
 {
@@ -1026,12 +1019,12 @@ fb_ioctl(struct file *file, unsigned int
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
@@ -1112,7 +1105,7 @@ fb_ioctl(struct file *file, unsigned int
 		}
 #ifdef CONFIG_KMOD
 		if (!registered_fb[con2fb.framebuffer])
-			try_to_load(con2fb.framebuffer);
+			request_module("fb%d", con2fb.framebuffer);
 #endif /* CONFIG_KMOD */
 		if (!registered_fb[con2fb.framebuffer]) {
 			ret = -EINVAL;
@@ -1136,7 +1129,7 @@ fb_ioctl(struct file *file, unsigned int
 		else
 			ret = fb->fb_ioctl(info, cmd, arg);
 	}
-	unlock_kernel();
+	mutex_unlock(&info->lock);
 	return ret;
 }
 
@@ -1263,7 +1256,7 @@ fb_compat_ioctl(struct file *file, unsig
 	struct fb_ops *fb = info->fbops;
 	long ret = -ENOIOCTLCMD;
 
-	lock_kernel();
+	mutex_lock(&info->lock);
 	switch(cmd) {
 	case FBIOGET_VSCREENINFO:
 	case FBIOPUT_VSCREENINFO:
@@ -1289,7 +1282,7 @@ fb_compat_ioctl(struct file *file, unsig
 			ret = fb->fb_compat_ioctl(info, cmd, arg);
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&info->lock);
 	return ret;
 }
 #endif
@@ -1311,13 +1304,13 @@ fb_mmap(struct file *file, struct vm_are
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
@@ -1326,13 +1319,13 @@ fb_mmap(struct file *file, struct vm_are
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
@@ -1356,15 +1349,16 @@ fb_open(struct inode *inode, struct file
 
 	if (fbidx >= FB_MAX)
 		return -ENODEV;
-	lock_kernel();
+	info = registered_fb[fbidx];
 #ifdef CONFIG_KMOD
-	if (!(info = registered_fb[fbidx]))
-		try_to_load(fbidx);
+	if (!info)
+		request_module("fb%d", fbidx);
 #endif /* CONFIG_KMOD */
 	if (!(info = registered_fb[fbidx])) {
 		res = -ENODEV;
 		goto out;
 	}
+	mutex_lock(&info->lock);
 	if (!try_module_get(info->fbops->owner)) {
 		res = -ENODEV;
 		goto out;
@@ -1376,7 +1370,7 @@ fb_open(struct inode *inode, struct file
 			module_put(info->fbops->owner);
 	}
 out:
-	unlock_kernel();
+	mutex_unlock(&info->lock);
 	return res;
 }
 
@@ -1385,11 +1379,11 @@ fb_release(struct inode *inode, struct f
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
 
@@ -1468,6 +1462,7 @@ register_framebuffer(struct fb_info *fb_
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
backlight-add-more-information-output-to-pwm_backlight.patch
fbcon-fix-scrolling-after-logo-is-cleared.patch
drivers-video-fsl-diu-fbc-add-missing-of_node_put.patch
git-alsa-tiwai.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
x86-fdiv-bug-detection-fix.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch

