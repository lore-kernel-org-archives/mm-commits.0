From: akpm@linux-foundation.org
Subject: + revert-fbmem-dont-call-copy_from-to_user-with-mutex-held.patch added to -mm tree
Date: Tue, 12 May 2009 14:27:06 -0700
Message-ID: <200905122127.n4CLR6qY023457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755530AbZELV3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 17:29:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, geert@linux-m68k.org, righi.andrea@gmail.com


The patch titled
     revert "fbmem: don't call copy_from/to_user() with mutex held"
has been added to the -mm tree.  Its filename is
     revert-fbmem-dont-call-copy_from-to_user-with-mutex-held.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "fbmem: don't call copy_from/to_user() with mutex held"
From: Krzysztof Helt <krzysztof.h1@wp.pl>

A conversion of the BLK to the fb_info->lock mutex brought some circular
locking dependencies.  Despite extensive effort to fix these problems
there are still some bugs left.  The last effort unveiled a problem
described below.  It is not fixable without rethinking how locking should
be done inside the fbdev layer.  

Short summary of the lock dep is:

1. sys_munmap() obtains [mm->mmap_sem] and calls indirectly
  :: fb_release() obtains [fb_info->lock]

2. fb_ioctl() obtains [fb_info->lock] and calls indirectly
  :: fb_notifier_call_chain() obtains [fb_notifier_list->rwsem]

3. driver_probe_device() calls indirectly
  :: register_framebuffer() calls indirectly
    :: fb_notifier_call_chain() obtains [fb_notifier_list->rwsem] and calls indirectly
      :: sysfs_create_dir() obtains [sysfs_mutex]

4. sysfs_readdir() obtains [sysfs_mutex] and calls indirectly
  :: copy_to_user() obtains [mm->mmap_sem]

Revert the BKL to mutex conversion patch
(3e680aae4e53ab54cdbb0c29257dae0cbb158e1c) while keeping the patch which
made the fb_ioctl and the fb_compat_ioctl using a common function
(a684e7d33096892093456dd56a582cfc3bfad648).

This patch: revert

: commit 1f5e31d7e55ac7fbd4ec5e5b20c8868b0e4564c9
: Author: Andrea Righi <righi.andrea@gmail.com>
: Date:   Wed Feb 4 15:12:03 2009 -0800
: 
:     fbmem: don't call copy_from/to_user() with mutex held

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Andrea Righi <righi.andrea@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbcmap.c |   20 +----
 drivers/video/fbmem.c  |  135 +++++++++++++++++++--------------------
 include/linux/fb.h     |   15 ----
 3 files changed, 72 insertions(+), 98 deletions(-)

diff -puN drivers/video/fbcmap.c~revert-fbmem-dont-call-copy_from-to_user-with-mutex-held drivers/video/fbcmap.c
--- a/drivers/video/fbcmap.c~revert-fbmem-dont-call-copy_from-to_user-with-mutex-held
+++ a/drivers/video/fbcmap.c
@@ -250,6 +250,10 @@ int fb_set_user_cmap(struct fb_cmap_user
 	int rc, size = cmap->len * sizeof(u16);
 	struct fb_cmap umap;
 
+	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
+			        !info->fbops->fb_setcmap))
+		return -EINVAL;
+
 	memset(&umap, 0, sizeof(struct fb_cmap));
 	rc = fb_alloc_cmap(&umap, cmap->len, cmap->transp != NULL);
 	if (rc)
@@ -258,23 +262,11 @@ int fb_set_user_cmap(struct fb_cmap_user
 	    copy_from_user(umap.green, cmap->green, size) ||
 	    copy_from_user(umap.blue, cmap->blue, size) ||
 	    (cmap->transp && copy_from_user(umap.transp, cmap->transp, size))) {
-		rc = -EFAULT;
-		goto out;
+		fb_dealloc_cmap(&umap);
+		return -EFAULT;
 	}
 	umap.start = cmap->start;
-	if (!lock_fb_info(info)) {
-		rc = -ENODEV;
-		goto out;
-	}
-	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
-				!info->fbops->fb_setcmap)) {
-		rc = -EINVAL;
-		goto out1;
-	}
 	rc = fb_set_cmap(&umap, info);
-out1:
-	unlock_fb_info(info);
-out:
 	fb_dealloc_cmap(&umap);
 	return rc;
 }
diff -puN drivers/video/fbmem.c~revert-fbmem-dont-call-copy_from-to_user-with-mutex-held drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~revert-fbmem-dont-call-copy_from-to_user-with-mutex-held
+++ a/drivers/video/fbmem.c
@@ -1013,139 +1013,132 @@ static long do_fb_ioctl(struct fb_info *
 	struct fb_var_screeninfo var;
 	struct fb_fix_screeninfo fix;
 	struct fb_con2fbmap con2fb;
-	struct fb_cmap cmap_from;
 	struct fb_cmap_user cmap;
 	struct fb_event event;
 	void __user *argp = (void __user *)arg;
 	long ret = 0;
 
+	fb = info->fbops;
+	if (!fb)
+		return -ENODEV;
+
 	switch (cmd) {
 	case FBIOGET_VSCREENINFO:
-		if (!lock_fb_info(info))
-			return -ENODEV;
-		var = info->var;
-		unlock_fb_info(info);
-
-		ret = copy_to_user(argp, &var, sizeof(var)) ? -EFAULT : 0;
+		ret = copy_to_user(argp, &info->var,
+				    sizeof(var)) ? -EFAULT : 0;
 		break;
 	case FBIOPUT_VSCREENINFO:
-		if (copy_from_user(&var, argp, sizeof(var)))
-			return -EFAULT;
-		if (!lock_fb_info(info))
-			return -ENODEV;
+		if (copy_from_user(&var, argp, sizeof(var))) {
+			ret =  -EFAULT;
+			break;
+		}
 		acquire_console_sem();
 		info->flags |= FBINFO_MISC_USEREVENT;
 		ret = fb_set_var(info, &var);
 		info->flags &= ~FBINFO_MISC_USEREVENT;
 		release_console_sem();
-		unlock_fb_info(info);
-		if (!ret && copy_to_user(argp, &var, sizeof(var)))
+		if (ret == 0 && copy_to_user(argp, &var, sizeof(var)))
 			ret = -EFAULT;
 		break;
 	case FBIOGET_FSCREENINFO:
-		if (!lock_fb_info(info))
-			return -ENODEV;
-		fix = info->fix;
-		unlock_fb_info(info);
-
-		ret = copy_to_user(argp, &fix, sizeof(fix)) ? -EFAULT : 0;
+		ret = copy_to_user(argp, &info->fix,
+				    sizeof(fix)) ? -EFAULT : 0;
 		break;
 	case FBIOPUTCMAP:
 		if (copy_from_user(&cmap, argp, sizeof(cmap)))
-			return -EFAULT;
-		ret = fb_set_user_cmap(&cmap, info);
+			ret = -EFAULT;
+		else
+			ret = fb_set_user_cmap(&cmap, info);
 		break;
 	case FBIOGETCMAP:
 		if (copy_from_user(&cmap, argp, sizeof(cmap)))
-			return -EFAULT;
-		if (!lock_fb_info(info))
-			return -ENODEV;
-		cmap_from = info->cmap;
-		unlock_fb_info(info);
-		ret = fb_cmap_to_user(&cmap_from, &cmap);
+			ret = -EFAULT;
+		else
+			ret = fb_cmap_to_user(&info->cmap, &cmap);
 		break;
 	case FBIOPAN_DISPLAY:
-		if (copy_from_user(&var, argp, sizeof(var)))
-			return -EFAULT;
-		if (!lock_fb_info(info))
-			return -ENODEV;
+		if (copy_from_user(&var, argp, sizeof(var))) {
+			ret = -EFAULT;
+			break;
+		}
 		acquire_console_sem();
 		ret = fb_pan_display(info, &var);
 		release_console_sem();
-		unlock_fb_info(info);
 		if (ret == 0 && copy_to_user(argp, &var, sizeof(var)))
-			return -EFAULT;
+			ret = -EFAULT;
 		break;
 	case FBIO_CURSOR:
 		ret = -EINVAL;
 		break;
 	case FBIOGET_CON2FBMAP:
 		if (copy_from_user(&con2fb, argp, sizeof(con2fb)))
-			return -EFAULT;
-		if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
-			return -EINVAL;
-		con2fb.framebuffer = -1;
-		event.data = &con2fb;
-
-		if (!lock_fb_info(info))
-			return -ENODEV;
-		event.info = info;
-		fb_notifier_call_chain(FB_EVENT_GET_CONSOLE_MAP, &event);
-		unlock_fb_info(info);
-
-		ret = copy_to_user(argp, &con2fb, sizeof(con2fb)) ? -EFAULT : 0;
+			ret = -EFAULT;
+		else if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
+			ret = -EINVAL;
+		else {
+			con2fb.framebuffer = -1;
+			event.info = info;
+			event.data = &con2fb;
+			fb_notifier_call_chain(FB_EVENT_GET_CONSOLE_MAP,
+								&event);
+			ret = copy_to_user(argp, &con2fb,
+				    sizeof(con2fb)) ? -EFAULT : 0;
+		}
 		break;
 	case FBIOPUT_CON2FBMAP:
-		if (copy_from_user(&con2fb, argp, sizeof(con2fb)))
-			return -EFAULT;
-		if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
-			return -EINVAL;
-		if (con2fb.framebuffer < 0 || con2fb.framebuffer >= FB_MAX)
-			return -EINVAL;
+		if (copy_from_user(&con2fb, argp, sizeof(con2fb))) {
+			ret = -EFAULT;
+			break;
+		}
+		if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES) {
+			ret = -EINVAL;
+			break;
+		}
+		if (con2fb.framebuffer < 0 || con2fb.framebuffer >= FB_MAX) {
+			ret = -EINVAL;
+			break;
+		}
 		if (!registered_fb[con2fb.framebuffer])
 			request_module("fb%d", con2fb.framebuffer);
 		if (!registered_fb[con2fb.framebuffer]) {
 			ret = -EINVAL;
 			break;
 		}
-		event.data = &con2fb;
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		event.info = info;
+		event.data = &con2fb;
 		ret = fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP,
 					      &event);
-		unlock_fb_info(info);
 		break;
 	case FBIOBLANK:
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		acquire_console_sem();
 		info->flags |= FBINFO_MISC_USEREVENT;
 		ret = fb_blank(info, arg);
 		info->flags &= ~FBINFO_MISC_USEREVENT;
 		release_console_sem();
-		unlock_fb_info(info);
-		break;
+		break;;
 	default:
-		if (!lock_fb_info(info))
-			return -ENODEV;
-		fb = info->fbops;
-		if (fb->fb_ioctl)
-			ret = fb->fb_ioctl(info, cmd, arg);
-		else
+		if (fb->fb_ioctl == NULL)
 			ret = -ENOTTY;
-		unlock_fb_info(info);
+		else
+			ret = fb->fb_ioctl(info, cmd, arg);
 	}
 	return ret;
 }
 
 static long fb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+__acquires(&info->lock)
+__releases(&info->lock)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
-	struct fb_info *info = registered_fb[fbidx];
+	struct fb_info *info;
+	long ret;
 
-	return do_fb_ioctl(info, cmd, arg);
+	info = registered_fb[fbidx];
+	mutex_lock(&info->lock);
+	ret = do_fb_ioctl(info, cmd, arg);
+	mutex_unlock(&info->lock);
+	return ret;
 }
 
 #ifdef CONFIG_COMPAT
@@ -1264,6 +1257,8 @@ static int fb_get_fscreeninfo(struct fb_
 
 static long fb_compat_ioctl(struct file *file, unsigned int cmd,
 			    unsigned long arg)
+__acquires(&info->lock)
+__releases(&info->lock)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
@@ -1271,6 +1266,7 @@ static long fb_compat_ioctl(struct file 
 	struct fb_ops *fb = info->fbops;
 	long ret = -ENOIOCTLCMD;
 
+	mutex_lock(&info->lock);
 	switch(cmd) {
 	case FBIOGET_VSCREENINFO:
 	case FBIOPUT_VSCREENINFO:
@@ -1296,6 +1292,7 @@ static long fb_compat_ioctl(struct file 
 			ret = fb->fb_compat_ioctl(info, cmd, arg);
 		break;
 	}
+	mutex_unlock(&info->lock);
 	return ret;
 }
 #endif
diff -puN include/linux/fb.h~revert-fbmem-dont-call-copy_from-to_user-with-mutex-held include/linux/fb.h
--- a/include/linux/fb.h~revert-fbmem-dont-call-copy_from-to_user-with-mutex-held
+++ a/include/linux/fb.h
@@ -965,21 +965,6 @@ extern struct fb_info *registered_fb[FB_
 extern int num_registered_fb;
 extern struct class *fb_class;
 
-static inline int lock_fb_info(struct fb_info *info)
-{
-	mutex_lock(&info->lock);
-	if (!info->fbops) {
-		mutex_unlock(&info->lock);
-		return 0;
-	}
-	return 1;
-}
-
-static inline void unlock_fb_info(struct fb_info *info)
-{
-	mutex_unlock(&info->lock);
-}
