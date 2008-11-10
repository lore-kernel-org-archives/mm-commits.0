From: akpm@linux-foundation.org
Subject: - fbdev-fix-fb_compat_ioctl-deadlocks.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:32:50 -0800
Message-ID: <200811102032.mAAKWoRS024178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753250AbYKJUdo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:33:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, alan@lxorguk.ukuu.org.uk, krzysztof.h1@wp.pl, mpatocka@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: fix fb_compat_ioctl() deadlocks
has been removed from the -mm tree.  Its filename was
     fbdev-fix-fb_compat_ioctl-deadlocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: fix fb_compat_ioctl() deadlocks
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

commit 3e680aae4e53ab54cdbb0c29257dae0cbb158e1c ("fb: convert
lock/unlock_kernel() into local fb mutex") introduced several deadlocks
in the fb_compat_ioctl() path, as mutex_lock() doesn't allow recursion,
unlike lock_kernel().  This broke frame buffer applications on 64-bit
systems with a 32-bit userland.

commit 120a37470c2831fea49fdebaceb5a7039f700ce6 ("framebuffer compat_ioctl
deadlock") fixed one of the deadlocks.

This patch fixes the remaining deadlocks:
  - Revert commit 120a37470c2831fea49fdebaceb5a7039f700ce6,
  - Extract the core logic of fb_ioctl() into a new function do_fb_ioctl(),
  - Change all callsites of fb_ioctl() where info->lock is already held to
    call do_fb_ioctl() instead,
  - Add sparse annotations to all routines that take info->lock.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |   63 ++++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff -puN drivers/video/fbmem.c~fbdev-fix-fb_compat_ioctl-deadlocks drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-fix-fb_compat_ioctl-deadlocks
+++ a/drivers/video/fbmem.c
@@ -1002,13 +1002,9 @@ fb_blank(struct fb_info *info, int blank
  	return ret;
 }
 
-static long
-fb_ioctl(struct file *file, unsigned int cmd,
-	 unsigned long arg)
+static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
+			unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int fbidx = iminor(inode);
-	struct fb_info *info;
 	struct fb_ops *fb;
 	struct fb_var_screeninfo var;
 	struct fb_fix_screeninfo fix;
@@ -1018,14 +1014,10 @@ fb_ioctl(struct file *file, unsigned int
 	void __user *argp = (void __user *)arg;
 	long ret = 0;
 
-	info = registered_fb[fbidx];
-	mutex_lock(&info->lock);
 	fb = info->fbops;
-
-	if (!fb) {
-		mutex_unlock(&info->lock);
+	if (!fb)
 		return -ENODEV;
-	}
+
 	switch (cmd) {
 	case FBIOGET_VSCREENINFO:
 		ret = copy_to_user(argp, &info->var,
@@ -1126,6 +1118,21 @@ fb_ioctl(struct file *file, unsigned int
 		else
 			ret = fb->fb_ioctl(info, cmd, arg);
 	}
+	return ret;
+}
+
+static long fb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+__acquires(&info->lock)
+__releases(&info->lock)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	int fbidx = iminor(inode);
+	struct fb_info *info;
+	long ret;
+
+	info = registered_fb[fbidx];
+	mutex_lock(&info->lock);
+	ret = do_fb_ioctl(info, cmd, arg);
 	mutex_unlock(&info->lock);
 	return ret;
 }
@@ -1157,8 +1164,8 @@ struct fb_cmap32 {
 	compat_caddr_t	transp;
 };
 
-static int fb_getput_cmap(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static int fb_getput_cmap(struct fb_info *info, unsigned int cmd,
+			  unsigned long arg)
 {
 	struct fb_cmap_user __user *cmap;
 	struct fb_cmap32 __user *cmap32;
@@ -1181,7 +1188,7 @@ static int fb_getput_cmap(struct inode *
 	    put_user(compat_ptr(data), &cmap->transp))
 		return -EFAULT;
 
-	err = fb_ioctl(file, cmd, (unsigned long) cmap);
+	err = do_fb_ioctl(info, cmd, (unsigned long) cmap);
 
 	if (!err) {
 		if (copy_in_user(&cmap32->start,
@@ -1223,8 +1230,8 @@ static int do_fscreeninfo_to_user(struct
 	return err;
 }
 
-static int fb_get_fscreeninfo(struct inode *inode, struct file *file,
-				unsigned int cmd, unsigned long arg)
+static int fb_get_fscreeninfo(struct fb_info *info, unsigned int cmd,
+			      unsigned long arg)
 {
 	mm_segment_t old_fs;
 	struct fb_fix_screeninfo fix;
@@ -1235,7 +1242,7 @@ static int fb_get_fscreeninfo(struct ino
 
 	old_fs = get_fs();
 	set_fs(KERNEL_DS);
-	err = fb_ioctl(file, cmd, (unsigned long) &fix);
+	err = do_fb_ioctl(info, cmd, (unsigned long) &fix);
 	set_fs(old_fs);
 
 	if (!err)
@@ -1244,8 +1251,10 @@ static int fb_get_fscreeninfo(struct ino
 	return err;
 }
 
-static long
-fb_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static long fb_compat_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
+__acquires(&info->lock)
+__releases(&info->lock)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
@@ -1262,16 +1271,16 @@ fb_compat_ioctl(struct file *file, unsig
 	case FBIOPUT_CON2FBMAP:
 		arg = (unsigned long) compat_ptr(arg);
 	case FBIOBLANK:
-		mutex_unlock(&info->lock);
-		return fb_ioctl(file, cmd, arg);
+		ret = do_fb_ioctl(info, cmd, arg);
+		break;
 
 	case FBIOGET_FSCREENINFO:
-		ret = fb_get_fscreeninfo(inode, file, cmd, arg);
+		ret = fb_get_fscreeninfo(info, cmd, arg);
 		break;
 
 	case FBIOGETCMAP:
 	case FBIOPUTCMAP:
-		ret = fb_getput_cmap(inode, file, cmd, arg);
+		ret = fb_getput_cmap(info, cmd, arg);
 		break;
 
 	default:
@@ -1286,6 +1295,8 @@ fb_compat_ioctl(struct file *file, unsig
 
 static int
 fb_mmap(struct file *file, struct vm_area_struct * vma)
+__acquires(&info->lock)
+__releases(&info->lock)
 {
 	int fbidx = iminor(file->f_path.dentry->d_inode);
 	struct fb_info *info = registered_fb[fbidx];
@@ -1339,6 +1350,8 @@ fb_mmap(struct file *file, struct vm_are
 
 static int
 fb_open(struct inode *inode, struct file *file)
+__acquires(&info->lock)
+__releases(&info->lock)
 {
 	int fbidx = iminor(inode);
 	struct fb_info *info;
@@ -1374,6 +1387,8 @@ out:
 
 static int 
 fb_release(struct inode *inode, struct file *file)
+__acquires(&info->lock)
+__releases(&info->lock)
 {
 	struct fb_info * const info = file->private_data;
 
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are


