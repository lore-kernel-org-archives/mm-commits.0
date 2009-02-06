From: akpm@linux-foundation.org
Subject: [merged] fbmem-copy_from-to_user-with-mutex-held-v3.patch removed from -mm tree
Date: Fri, 06 Feb 2009 11:37:42 -0800
Message-ID: <200902061937.n16JbghK011253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753690AbZBFTkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 14:40:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: righi.andrea@gmail.com, davej@redhat.com, hannes@saeurebad.de, harvey.harrison@gmail.com, krzysztof.h1@wp.pl, rjw@sisk.pl, stefanr@s5r6.in-berlin.de, mm-commits@vger.kernel.org


The patch titled
     fbmem: don't call copy_from/to_user() with mutex held
has been removed from the -mm tree.  Its filename was
     fbmem-copy_from-to_user-with-mutex-held-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbmem: don't call copy_from/to_user() with mutex held
From: Andrea Righi <righi.andrea@gmail.com>

Avoid calling copy_from/to_user() with fb_info->lock mutex held in fbmem
ioctl().

fb_mmap() is called under mm->mmap_sem (A) held, that also acquires
fb_info->lock (B); fb_ioctl() takes fb_info->lock (B) and does
copy_from/to_user() that might acquire mm->mmap_sem (A), causing a
deadlock.

NOTE: it doesn't push down the fb_info->lock in each own driver's
fb_ioctl(), so there are still potential deadlocks elsewhere.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Johannes Weiner <hannes@saeurebad.de>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbcmap.c |   20 ++++-
 drivers/video/fbmem.c  |  135 +++++++++++++++++++--------------------
 include/linux/fb.h     |   15 ++++
 3 files changed, 98 insertions(+), 72 deletions(-)

diff -puN drivers/video/fbcmap.c~fbmem-copy_from-to_user-with-mutex-held-v3 drivers/video/fbcmap.c
--- a/drivers/video/fbcmap.c~fbmem-copy_from-to_user-with-mutex-held-v3
+++ a/drivers/video/fbcmap.c
@@ -250,10 +250,6 @@ int fb_set_user_cmap(struct fb_cmap_user
 	int rc, size = cmap->len * sizeof(u16);
 	struct fb_cmap umap;
 
-	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
-			        !info->fbops->fb_setcmap))
-		return -EINVAL;
-
 	memset(&umap, 0, sizeof(struct fb_cmap));
 	rc = fb_alloc_cmap(&umap, cmap->len, cmap->transp != NULL);
 	if (rc)
@@ -262,11 +258,23 @@ int fb_set_user_cmap(struct fb_cmap_user
 	    copy_from_user(umap.green, cmap->green, size) ||
 	    copy_from_user(umap.blue, cmap->blue, size) ||
 	    (cmap->transp && copy_from_user(umap.transp, cmap->transp, size))) {
-		fb_dealloc_cmap(&umap);
-		return -EFAULT;
+		rc = -EFAULT;
+		goto out;
 	}
 	umap.start = cmap->start;
+	if (!lock_fb_info(info)) {
+		rc = -ENODEV;
+		goto out;
+	}
+	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
+				!info->fbops->fb_setcmap)) {
+		rc = -EINVAL;
+		goto out1;
+	}
 	rc = fb_set_cmap(&umap, info);
+out1:
+	unlock_fb_info(info);
+out:
 	fb_dealloc_cmap(&umap);
 	return rc;
 }
diff -puN drivers/video/fbmem.c~fbmem-copy_from-to_user-with-mutex-held-v3 drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbmem-copy_from-to_user-with-mutex-held-v3
+++ a/drivers/video/fbmem.c
@@ -1013,132 +1013,139 @@ static long do_fb_ioctl(struct fb_info *
 	struct fb_var_screeninfo var;
 	struct fb_fix_screeninfo fix;
 	struct fb_con2fbmap con2fb;
+	struct fb_cmap cmap_from;
 	struct fb_cmap_user cmap;
 	struct fb_event event;
 	void __user *argp = (void __user *)arg;
 	long ret = 0;
 
-	fb = info->fbops;
-	if (!fb)
-		return -ENODEV;
-
 	switch (cmd) {
 	case FBIOGET_VSCREENINFO:
-		ret = copy_to_user(argp, &info->var,
-				    sizeof(var)) ? -EFAULT : 0;
+		if (!lock_fb_info(info))
+			return -ENODEV;
+		var = info->var;
+		unlock_fb_info(info);
+
+		ret = copy_to_user(argp, &var, sizeof(var)) ? -EFAULT : 0;
 		break;
 	case FBIOPUT_VSCREENINFO:
-		if (copy_from_user(&var, argp, sizeof(var))) {
-			ret =  -EFAULT;
-			break;
-		}
+		if (copy_from_user(&var, argp, sizeof(var)))
+			return -EFAULT;
+		if (!lock_fb_info(info))
+			return -ENODEV;
 		acquire_console_sem();
 		info->flags |= FBINFO_MISC_USEREVENT;
 		ret = fb_set_var(info, &var);
 		info->flags &= ~FBINFO_MISC_USEREVENT;
 		release_console_sem();
-		if (ret == 0 && copy_to_user(argp, &var, sizeof(var)))
+		unlock_fb_info(info);
+		if (!ret && copy_to_user(argp, &var, sizeof(var)))
 			ret = -EFAULT;
 		break;
 	case FBIOGET_FSCREENINFO:
-		ret = copy_to_user(argp, &info->fix,
-				    sizeof(fix)) ? -EFAULT : 0;
+		if (!lock_fb_info(info))
+			return -ENODEV;
+		fix = info->fix;
+		unlock_fb_info(info);
+
+		ret = copy_to_user(argp, &fix, sizeof(fix)) ? -EFAULT : 0;
 		break;
 	case FBIOPUTCMAP:
 		if (copy_from_user(&cmap, argp, sizeof(cmap)))
-			ret = -EFAULT;
-		else
-			ret = fb_set_user_cmap(&cmap, info);
+			return -EFAULT;
+		ret = fb_set_user_cmap(&cmap, info);
 		break;
 	case FBIOGETCMAP:
 		if (copy_from_user(&cmap, argp, sizeof(cmap)))
-			ret = -EFAULT;
-		else
-			ret = fb_cmap_to_user(&info->cmap, &cmap);
+			return -EFAULT;
+		if (!lock_fb_info(info))
+			return -ENODEV;
+		cmap_from = info->cmap;
+		unlock_fb_info(info);
+		ret = fb_cmap_to_user(&cmap_from, &cmap);
 		break;
 	case FBIOPAN_DISPLAY:
-		if (copy_from_user(&var, argp, sizeof(var))) {
-			ret = -EFAULT;
-			break;
-		}
+		if (copy_from_user(&var, argp, sizeof(var)))
+			return -EFAULT;
+		if (!lock_fb_info(info))
+			return -ENODEV;
 		acquire_console_sem();
 		ret = fb_pan_display(info, &var);
 		release_console_sem();
+		unlock_fb_info(info);
 		if (ret == 0 && copy_to_user(argp, &var, sizeof(var)))
-			ret = -EFAULT;
+			return -EFAULT;
 		break;
 	case FBIO_CURSOR:
 		ret = -EINVAL;
 		break;
 	case FBIOGET_CON2FBMAP:
 		if (copy_from_user(&con2fb, argp, sizeof(con2fb)))
-			ret = -EFAULT;
-		else if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
-			ret = -EINVAL;
-		else {
-			con2fb.framebuffer = -1;
-			event.info = info;
-			event.data = &con2fb;
-			fb_notifier_call_chain(FB_EVENT_GET_CONSOLE_MAP,
-								&event);
-			ret = copy_to_user(argp, &con2fb,
-				    sizeof(con2fb)) ? -EFAULT : 0;
-		}
+			return -EFAULT;
+		if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
+			return -EINVAL;
+		con2fb.framebuffer = -1;
+		event.data = &con2fb;
+
+		if (!lock_fb_info(info))
+			return -ENODEV;
+		event.info = info;
+		fb_notifier_call_chain(FB_EVENT_GET_CONSOLE_MAP, &event);
+		unlock_fb_info(info);
+
+		ret = copy_to_user(argp, &con2fb, sizeof(con2fb)) ? -EFAULT : 0;
 		break;
 	case FBIOPUT_CON2FBMAP:
-		if (copy_from_user(&con2fb, argp, sizeof(con2fb))) {
-			ret = -EFAULT;
-			break;
-		}
-		if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES) {
-			ret = -EINVAL;
-			break;
-		}
-		if (con2fb.framebuffer < 0 || con2fb.framebuffer >= FB_MAX) {
-			ret = -EINVAL;
-			break;
-		}
+		if (copy_from_user(&con2fb, argp, sizeof(con2fb)))
+			return -EFAULT;
+		if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
+			return -EINVAL;
+		if (con2fb.framebuffer < 0 || con2fb.framebuffer >= FB_MAX)
+			return -EINVAL;
 		if (!registered_fb[con2fb.framebuffer])
 			request_module("fb%d", con2fb.framebuffer);
 		if (!registered_fb[con2fb.framebuffer]) {
 			ret = -EINVAL;
 			break;
 		}
-		event.info = info;
 		event.data = &con2fb;
+		if (!lock_fb_info(info))
+			return -ENODEV;
+		event.info = info;
 		ret = fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP,
 					      &event);
+		unlock_fb_info(info);
 		break;
 	case FBIOBLANK:
+		if (!lock_fb_info(info))
+			return -ENODEV;
 		acquire_console_sem();
 		info->flags |= FBINFO_MISC_USEREVENT;
 		ret = fb_blank(info, arg);
 		info->flags &= ~FBINFO_MISC_USEREVENT;
 		release_console_sem();
-		break;;
+		unlock_fb_info(info);
+		break;
 	default:
-		if (fb->fb_ioctl == NULL)
-			ret = -ENOTTY;
-		else
+		if (!lock_fb_info(info))
+			return -ENODEV;
+		fb = info->fbops;
+		if (fb->fb_ioctl)
 			ret = fb->fb_ioctl(info, cmd, arg);
+		else
+			ret = -ENOTTY;
+		unlock_fb_info(info);
 	}
 	return ret;
 }
 
 static long fb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-__acquires(&info->lock)
-__releases(&info->lock)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
-	struct fb_info *info;
-	long ret;
+	struct fb_info *info = registered_fb[fbidx];
 
-	info = registered_fb[fbidx];
-	mutex_lock(&info->lock);
-	ret = do_fb_ioctl(info, cmd, arg);
-	mutex_unlock(&info->lock);
-	return ret;
+	return do_fb_ioctl(info, cmd, arg);
 }
 
 #ifdef CONFIG_COMPAT
@@ -1257,8 +1264,6 @@ static int fb_get_fscreeninfo(struct fb_
 
 static long fb_compat_ioctl(struct file *file, unsigned int cmd,
 			    unsigned long arg)
-__acquires(&info->lock)
-__releases(&info->lock)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
@@ -1266,7 +1271,6 @@ __releases(&info->lock)
 	struct fb_ops *fb = info->fbops;
 	long ret = -ENOIOCTLCMD;
 
-	mutex_lock(&info->lock);
 	switch(cmd) {
 	case FBIOGET_VSCREENINFO:
 	case FBIOPUT_VSCREENINFO:
@@ -1292,7 +1296,6 @@ __releases(&info->lock)
 			ret = fb->fb_compat_ioctl(info, cmd, arg);
 		break;
 	}
-	mutex_unlock(&info->lock);
 	return ret;
 }
 #endif
diff -puN include/linux/fb.h~fbmem-copy_from-to_user-with-mutex-held-v3 include/linux/fb.h
--- a/include/linux/fb.h~fbmem-copy_from-to_user-with-mutex-held-v3
+++ a/include/linux/fb.h
@@ -960,6 +960,21 @@ extern struct fb_info *registered_fb[FB_
 extern int num_registered_fb;
 extern struct class *fb_class;
 
+static inline int lock_fb_info(struct fb_info *info)
+{
+	mutex_lock(&info->lock);
+	if (!info->fbops) {
+		mutex_unlock(&info->lock);
+		return 0;
+	}
+	return 1;
+}
+
+static inline void unlock_fb_info(struct fb_info *info)
+{
+	mutex_unlock(&info->lock);
+}
+
 static inline void __fb_pad_aligned_buffer(u8 *dst, u32 d_pitch,
 					   u8 *src, u32 s_pitch, u32 height)
 {
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

origin.patch
fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency.patch
fbdev-uninline-lock_fb_info.patch

