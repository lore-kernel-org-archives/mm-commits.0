From: akpm@linux-foundation.org
Subject: - fb-push-down-the-bkl-in-the-ioctl-handler.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:35:41 -0700
Message-ID: <200810202035.m9KKZfIO011200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753923AbYJTUhE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:37:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, adaplas@pol.net, alan@redhat.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fb: push down the BKL in the ioctl handler
has been removed from the -mm tree.  Its filename was
     fb-push-down-the-bkl-in-the-ioctl-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fb: push down the BKL in the ioctl handler
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Framebuffer is heavily BKL dependant at the moment so just wrap the ioctl
handler in the driver as we push down.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |  141 ++++++++++++++++++++++++----------------
 1 file changed, 86 insertions(+), 55 deletions(-)

diff -puN drivers/video/fbmem.c~fb-push-down-the-bkl-in-the-ioctl-handler drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fb-push-down-the-bkl-in-the-ioctl-handler
+++ a/drivers/video/fbmem.c
@@ -1002,101 +1002,132 @@ fb_blank(struct fb_info *info, int blank
  	return ret;
 }
 
-static int 
-fb_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
+static long
+fb_ioctl(struct file *file, unsigned int cmd,
 	 unsigned long arg)
 {
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
-	struct fb_info *info = registered_fb[fbidx];
-	struct fb_ops *fb = info->fbops;
+	struct fb_info *info;
+	struct fb_ops *fb;
 	struct fb_var_screeninfo var;
 	struct fb_fix_screeninfo fix;
 	struct fb_con2fbmap con2fb;
 	struct fb_cmap_user cmap;
 	struct fb_event event;
 	void __user *argp = (void __user *)arg;
-	int i;
-	
-	if (!fb)
+	long ret = 0;
+
+	lock_kernel();
+	info = registered_fb[fbidx];
+	fb = info->fbops;
+
+	if (!fb) {
+		unlock_kernel();
 		return -ENODEV;
+	}
 	switch (cmd) {
 	case FBIOGET_VSCREENINFO:
-		return copy_to_user(argp, &info->var,
+		ret = copy_to_user(argp, &info->var,
 				    sizeof(var)) ? -EFAULT : 0;
+		break;
 	case FBIOPUT_VSCREENINFO:
-		if (copy_from_user(&var, argp, sizeof(var)))
-			return -EFAULT;
+		if (copy_from_user(&var, argp, sizeof(var))) {
+			ret =  -EFAULT;
+			break;
+		}
 		acquire_console_sem();
 		info->flags |= FBINFO_MISC_USEREVENT;
-		i = fb_set_var(info, &var);
+		ret = fb_set_var(info, &var);
 		info->flags &= ~FBINFO_MISC_USEREVENT;
 		release_console_sem();
-		if (i) return i;
-		if (copy_to_user(argp, &var, sizeof(var)))
-			return -EFAULT;
-		return 0;
+		if (ret == 0 && copy_to_user(argp, &var, sizeof(var)))
+			ret = -EFAULT;
+		break;
 	case FBIOGET_FSCREENINFO:
-		return copy_to_user(argp, &info->fix,
+		ret = copy_to_user(argp, &info->fix,
 				    sizeof(fix)) ? -EFAULT : 0;
+		break;
 	case FBIOPUTCMAP:
 		if (copy_from_user(&cmap, argp, sizeof(cmap)))
-			return -EFAULT;
-		return (fb_set_user_cmap(&cmap, info));
+			ret = -EFAULT;
+		else
+			ret = fb_set_user_cmap(&cmap, info);
+		break;
 	case FBIOGETCMAP:
 		if (copy_from_user(&cmap, argp, sizeof(cmap)))
-			return -EFAULT;
-		return fb_cmap_to_user(&info->cmap, &cmap);
+			ret = -EFAULT;
+		else
+			ret = fb_cmap_to_user(&info->cmap, &cmap);
+		break;
 	case FBIOPAN_DISPLAY:
-		if (copy_from_user(&var, argp, sizeof(var)))
-			return -EFAULT;
+		if (copy_from_user(&var, argp, sizeof(var))) {
+			ret = -EFAULT;
+			break;
+		}
 		acquire_console_sem();
-		i = fb_pan_display(info, &var);
+		ret = fb_pan_display(info, &var);
 		release_console_sem();
-		if (i)
-			return i;
-		if (copy_to_user(argp, &var, sizeof(var)))
-			return -EFAULT;
-		return 0;
+		if (ret == 0 && copy_to_user(argp, &var, sizeof(var)))
+			ret = -EFAULT;
+		break;
 	case FBIO_CURSOR:
-		return -EINVAL;
+		ret = -EINVAL;
+		break;
 	case FBIOGET_CON2FBMAP:
 		if (copy_from_user(&con2fb, argp, sizeof(con2fb)))
-			return -EFAULT;
-		if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
-		    return -EINVAL;
-		con2fb.framebuffer = -1;
-		event.info = info;
-		event.data = &con2fb;
-		fb_notifier_call_chain(FB_EVENT_GET_CONSOLE_MAP, &event);
-		return copy_to_user(argp, &con2fb,
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
 				    sizeof(con2fb)) ? -EFAULT : 0;
+		}
+		break;
 	case FBIOPUT_CON2FBMAP:
-		if (copy_from_user(&con2fb, argp, sizeof(con2fb)))
-			return - EFAULT;
-		if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
-		    return -EINVAL;
-		if (con2fb.framebuffer < 0 || con2fb.framebuffer >= FB_MAX)
-		    return -EINVAL;
-		if (!registered_fb[con2fb.framebuffer])
-		    request_module("fb%d", con2fb.framebuffer);
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
-		    return -EINVAL;
+			request_module("fb%d", con2fb.framebuffer);
+		if (!registered_fb[con2fb.framebuffer]) {
+			ret = -EINVAL;
+			break;
+		}
 		event.info = info;
 		event.data = &con2fb;
-		return fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP,
+		ret = fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP,
 					      &event);
+		break;
 	case FBIOBLANK:
 		acquire_console_sem();
 		info->flags |= FBINFO_MISC_USEREVENT;
-		i = fb_blank(info, arg);
+		ret = fb_blank(info, arg);
 		info->flags &= ~FBINFO_MISC_USEREVENT;
 		release_console_sem();
-		return i;
+		break;;
 	default:
 		if (fb->fb_ioctl == NULL)
-			return -EINVAL;
-		return fb->fb_ioctl(info, cmd, arg);
+			ret = -ENOTTY;
+		else
+			ret = fb->fb_ioctl(info, cmd, arg);
 	}
+	unlock_kernel();
+	return ret;
 }
 
 #ifdef CONFIG_COMPAT
@@ -1150,7 +1181,7 @@ static int fb_getput_cmap(struct inode *
 	    put_user(compat_ptr(data), &cmap->transp))
 		return -EFAULT;
 
-	err = fb_ioctl(inode, file, cmd, (unsigned long) cmap);
+	err = fb_ioctl(file, cmd, (unsigned long) cmap);
 
 	if (!err) {
 		if (copy_in_user(&cmap32->start,
@@ -1204,7 +1235,7 @@ static int fb_get_fscreeninfo(struct ino
 
 	old_fs = get_fs();
 	set_fs(KERNEL_DS);
-	err = fb_ioctl(inode, file, cmd, (unsigned long) &fix);
+	err = fb_ioctl(file, cmd, (unsigned long) &fix);
 	set_fs(old_fs);
 
 	if (!err)
@@ -1231,7 +1262,7 @@ fb_compat_ioctl(struct file *file, unsig
 	case FBIOPUT_CON2FBMAP:
 		arg = (unsigned long) compat_ptr(arg);
 	case FBIOBLANK:
-		ret = fb_ioctl(inode, file, cmd, arg);
+		ret = fb_ioctl(file, cmd, arg);
 		break;
 
 	case FBIOGET_FSCREENINFO:
@@ -1358,7 +1389,7 @@ static const struct file_operations fb_f
 	.owner =	THIS_MODULE,
 	.read =		fb_read,
 	.write =	fb_write,
-	.ioctl =	fb_ioctl,
+	.unlocked_ioctl = fb_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = fb_compat_ioctl,
 #endif
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
linux-next.patch
max3100-spi-uart-driver.patch
max3100-spi-uart-driver-fix.patch

