From: akpm@linux-foundation.org
Subject: + fasync-rationalize-return-values.patch added to -mm tree
Date: Mon, 09 Feb 2009 16:33:54 -0800
Message-ID: <200902100033.n1A0XtYO005665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752651AbZBJAeY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 19:34:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: corbet@lwn.net, hch@lst.de, jens.axboe@oracle.com, mpm@selenic.com, viro@zeniv.linux.org.uk


The patch titled
     fasync: rationalize return values
has been added to the -mm tree.  Its filename is
     fasync-rationalize-return-values.patch

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
Subject: fasync: rationalize return values
From: Jonathan Corbet <corbet@lwn.net>

Most fasync implementations do something like:

     return fasync_helper(...);

But fasync_helper() will return a positive value at times - a feature used
in at least one place.  Thus, a number of other drivers do:

     err = fasync_helper(...);
     if (err < 0)
             return err;
     return 0;

In the interests of consistency and more concise code, it makes sense to
map positive return values onto zero where ->fasync() is called.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Acked-by: Matt Mackall <mpm@selenic.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sonypi.c              |    7 +------
 drivers/gpu/drm/drm_fops.c         |    6 +-----
 drivers/hid/usbhid/hiddev.c        |    5 +----
 drivers/ieee1394/dv1394.c          |    6 +-----
 drivers/input/evdev.c              |    5 +----
 drivers/input/joydev.c             |    5 +----
 drivers/input/mousedev.c           |    5 +----
 drivers/input/serio/serio_raw.c    |    4 +---
 drivers/net/wan/cosa.c             |    4 ++--
 drivers/platform/x86/sony-laptop.c |    7 +------
 drivers/scsi/sg.c                  |    4 +---
 fs/fcntl.c                         |    2 ++
 fs/ioctl.c                         |    2 +-
 fs/pipe.c                          |   17 +++--------------
 sound/core/control.c               |    7 ++-----
 sound/core/pcm_native.c            |    4 +---
 sound/core/timer.c                 |    6 +-----
 17 files changed, 22 insertions(+), 74 deletions(-)

diff -puN drivers/char/sonypi.c~fasync-rationalize-return-values drivers/char/sonypi.c
--- a/drivers/char/sonypi.c~fasync-rationalize-return-values
+++ a/drivers/char/sonypi.c
@@ -888,12 +888,7 @@ found:
 
 static int sonypi_misc_fasync(int fd, struct file *filp, int on)
 {
-	int retval;
-
-	retval = fasync_helper(fd, filp, on, &sonypi_device.fifo_async);
-	if (retval < 0)
-		return retval;
-	return 0;
+	return fasync_helper(fd, filp, on, &sonypi_device.fifo_async);
 }
 
 static int sonypi_misc_release(struct inode *inode, struct file *file)
diff -puN drivers/gpu/drm/drm_fops.c~fasync-rationalize-return-values drivers/gpu/drm/drm_fops.c
--- a/drivers/gpu/drm/drm_fops.c~fasync-rationalize-return-values
+++ a/drivers/gpu/drm/drm_fops.c
@@ -337,14 +337,10 @@ int drm_fasync(int fd, struct file *filp
 {
 	struct drm_file *priv = filp->private_data;
 	struct drm_device *dev = priv->minor->dev;
-	int retcode;
 
 	DRM_DEBUG("fd = %d, device = 0x%lx\n", fd,
 		  (long)old_encode_dev(priv->minor->device));
-	retcode = fasync_helper(fd, filp, on, &dev->buf_async);
-	if (retcode < 0)
-		return retcode;
-	return 0;
+	return fasync_helper(fd, filp, on, &dev->buf_async);
 }
 EXPORT_SYMBOL(drm_fasync);
 
diff -puN drivers/hid/usbhid/hiddev.c~fasync-rationalize-return-values drivers/hid/usbhid/hiddev.c
--- a/drivers/hid/usbhid/hiddev.c~fasync-rationalize-return-values
+++ a/drivers/hid/usbhid/hiddev.c
@@ -227,12 +227,9 @@ void hiddev_report_event(struct hid_devi
  */
 static int hiddev_fasync(int fd, struct file *file, int on)
 {
-	int retval;
 	struct hiddev_list *list = file->private_data;
 
-	retval = fasync_helper(fd, file, on, &list->fasync);
-
-	return retval < 0 ? retval : 0;
+	return fasync_helper(fd, file, on, &list->fasync);
 }
 
 
diff -puN drivers/ieee1394/dv1394.c~fasync-rationalize-return-values drivers/ieee1394/dv1394.c
--- a/drivers/ieee1394/dv1394.c~fasync-rationalize-return-values
+++ a/drivers/ieee1394/dv1394.c
@@ -1325,11 +1325,7 @@ static int dv1394_fasync(int fd, struct 
 
 	struct video_card *video = file_to_video_card(file);
 
-	int retval = fasync_helper(fd, file, on, &video->fasync);
-
-	if (retval < 0)
-		return retval;
-        return 0;
+	return fasync_helper(fd, file, on, &video->fasync);
 }
 
 static ssize_t dv1394_write(struct file *file, const char __user *buffer, size_t count, loff_t *ppos)
diff -puN drivers/input/evdev.c~fasync-rationalize-return-values drivers/input/evdev.c
--- a/drivers/input/evdev.c~fasync-rationalize-return-values
+++ a/drivers/input/evdev.c
@@ -94,11 +94,8 @@ static void evdev_event(struct input_han
 static int evdev_fasync(int fd, struct file *file, int on)
 {
 	struct evdev_client *client = file->private_data;
-	int retval;
-
-	retval = fasync_helper(fd, file, on, &client->fasync);
 
-	return retval < 0 ? retval : 0;
+	return fasync_helper(fd, file, on, &client->fasync);
 }
 
 static int evdev_flush(struct file *file, fl_owner_t id)
diff -puN drivers/input/joydev.c~fasync-rationalize-return-values drivers/input/joydev.c
--- a/drivers/input/joydev.c~fasync-rationalize-return-values
+++ a/drivers/input/joydev.c
@@ -159,12 +159,9 @@ static void joydev_event(struct input_ha
 
 static int joydev_fasync(int fd, struct file *file, int on)
 {
-	int retval;
 	struct joydev_client *client = file->private_data;
 
-	retval = fasync_helper(fd, file, on, &client->fasync);
-
-	return retval < 0 ? retval : 0;
+	return fasync_helper(fd, file, on, &client->fasync);
 }
 
 static void joydev_free(struct device *dev)
diff -puN drivers/input/mousedev.c~fasync-rationalize-return-values drivers/input/mousedev.c
--- a/drivers/input/mousedev.c~fasync-rationalize-return-values
+++ a/drivers/input/mousedev.c
@@ -413,12 +413,9 @@ static void mousedev_event(struct input_
 
 static int mousedev_fasync(int fd, struct file *file, int on)
 {
-	int retval;
 	struct mousedev_client *client = file->private_data;
 
-	retval = fasync_helper(fd, file, on, &client->fasync);
-
-	return retval < 0 ? retval : 0;
+	return fasync_helper(fd, file, on, &client->fasync);
 }
 
 static void mousedev_free(struct device *dev)
diff -puN drivers/input/serio/serio_raw.c~fasync-rationalize-return-values drivers/input/serio/serio_raw.c
--- a/drivers/input/serio/serio_raw.c~fasync-rationalize-return-values
+++ a/drivers/input/serio/serio_raw.c
@@ -58,10 +58,8 @@ static unsigned int serio_raw_no;
 static int serio_raw_fasync(int fd, struct file *file, int on)
 {
 	struct serio_raw_list *list = file->private_data;
-	int retval;
 
-	retval = fasync_helper(fd, file, on, &list->fasync);
-	return retval < 0 ? retval : 0;
+	return fasync_helper(fd, file, on, &list->fasync);
 }
 
 static struct serio_raw *serio_raw_locate(int minor)
diff -puN drivers/net/wan/cosa.c~fasync-rationalize-return-values drivers/net/wan/cosa.c
--- a/drivers/net/wan/cosa.c~fasync-rationalize-return-values
+++ a/drivers/net/wan/cosa.c
@@ -999,8 +999,8 @@ static struct fasync_struct *fasync[256]
 static int cosa_fasync(struct inode *inode, struct file *file, int on)
 {
         int port = iminor(inode);
-        int rv = fasync_helper(inode, file, on, &fasync[port]);
-        return rv < 0 ? rv : 0;
+
+	return fasync_helper(inode, file, on, &fasync[port]);
 }
 #endif
 
diff -puN drivers/platform/x86/sony-laptop.c~fasync-rationalize-return-values drivers/platform/x86/sony-laptop.c
--- a/drivers/platform/x86/sony-laptop.c~fasync-rationalize-return-values
+++ a/drivers/platform/x86/sony-laptop.c
@@ -1917,12 +1917,7 @@ static struct sonypi_compat_s sonypi_com
 
 static int sonypi_misc_fasync(int fd, struct file *filp, int on)
 {
-	int retval;
-
-	retval = fasync_helper(fd, filp, on, &sonypi_compat.fifo_async);
-	if (retval < 0)
-		return retval;
-	return 0;
+	return fasync_helper(fd, filp, on, &sonypi_compat.fifo_async);
 }
 
 static int sonypi_misc_release(struct inode *inode, struct file *file)
diff -puN drivers/scsi/sg.c~fasync-rationalize-return-values drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~fasync-rationalize-return-values
+++ a/drivers/scsi/sg.c
@@ -1148,7 +1148,6 @@ sg_poll(struct file *filp, poll_table * 
 static int
 sg_fasync(int fd, struct file *filp, int mode)
 {
-	int retval;
 	Sg_device *sdp;
 	Sg_fd *sfp;
 
@@ -1157,8 +1156,7 @@ sg_fasync(int fd, struct file *filp, int
 	SCSI_LOG_TIMEOUT(3, printk("sg_fasync: %s, mode=%d\n",
 				   sdp->disk->disk_name, mode));
 
-	retval = fasync_helper(fd, filp, mode, &sfp->async_qp);
-	return (retval < 0) ? retval : 0;
+	return fasync_helper(fd, filp, mode, &sfp->async_qp);
 }
 
 static int
diff -puN fs/fcntl.c~fasync-rationalize-return-values fs/fcntl.c
--- a/fs/fcntl.c~fasync-rationalize-return-values
+++ a/fs/fcntl.c
@@ -184,6 +184,8 @@ static int setfl(int fd, struct file * f
 		error = filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0);
 		if (error < 0)
 			goto out;
+		if (error > 0)
+			error = 0;
 	}
 	spin_lock(&filp->f_lock);
 	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
diff -puN fs/ioctl.c~fasync-rationalize-return-values fs/ioctl.c
--- a/fs/ioctl.c~fasync-rationalize-return-values
+++ a/fs/ioctl.c
@@ -432,7 +432,7 @@ static int ioctl_fioasync(unsigned int f
 		else
 			error = -ENOTTY;
 	}
-	return error;
+	return error < 0 ? error : 0;
 }
 
 static int ioctl_fsfreeze(struct file *filp)
diff -puN fs/pipe.c~fasync-rationalize-return-values fs/pipe.c
--- a/fs/pipe.c~fasync-rationalize-return-values
+++ a/fs/pipe.c
@@ -667,10 +667,7 @@ pipe_read_fasync(int fd, struct file *fi
 	retval = fasync_helper(fd, filp, on, &inode->i_pipe->fasync_readers);
 	mutex_unlock(&inode->i_mutex);
 
-	if (retval < 0)
-		return retval;
-
-	return 0;
+	return retval;
 }
 
 
@@ -684,10 +681,7 @@ pipe_write_fasync(int fd, struct file *f
 	retval = fasync_helper(fd, filp, on, &inode->i_pipe->fasync_writers);
 	mutex_unlock(&inode->i_mutex);
 
-	if (retval < 0)
-		return retval;
-
-	return 0;
+	return retval;
 }
 
 
@@ -707,14 +701,9 @@ pipe_rdwr_fasync(int fd, struct file *fi
 			fasync_helper(-1, filp, 0, &pipe->fasync_readers);
 	}
 	mutex_unlock(&inode->i_mutex);
-
-	if (retval < 0)
-		return retval;
-
-	return 0;
+	return retval;
 }
 
-
 static int
 pipe_read_release(struct inode *inode, struct file *filp)
 {
diff -puN sound/core/control.c~fasync-rationalize-return-values sound/core/control.c
--- a/sound/core/control.c~fasync-rationalize-return-values
+++ a/sound/core/control.c
@@ -1373,12 +1373,9 @@ EXPORT_SYMBOL(snd_ctl_unregister_ioctl_c
 static int snd_ctl_fasync(int fd, struct file * file, int on)
 {
 	struct snd_ctl_file *ctl;
-	int err;
+
 	ctl = file->private_data;
-	err = fasync_helper(fd, file, on, &ctl->fasync);
-	if (err < 0)
-		return err;
-	return 0;
+	return fasync_helper(fd, file, on, &ctl->fasync);
 }
 
 /*
diff -puN sound/core/pcm_native.c~fasync-rationalize-return-values sound/core/pcm_native.c
--- a/sound/core/pcm_native.c~fasync-rationalize-return-values
+++ a/sound/core/pcm_native.c
@@ -3246,9 +3246,7 @@ static int snd_pcm_fasync(int fd, struct
 	err = fasync_helper(fd, file, on, &runtime->fasync);
 out:
 	unlock_kernel();
-	if (err < 0)
-		return err;
-	return 0;
+	return err;
 }
 
 /*
diff -puN sound/core/timer.c~fasync-rationalize-return-values sound/core/timer.c
--- a/sound/core/timer.c~fasync-rationalize-return-values
+++ a/sound/core/timer.c
@@ -1825,13 +1825,9 @@ static long snd_timer_user_ioctl(struct 
 static int snd_timer_user_fasync(int fd, struct file * file, int on)
 {
 	struct snd_timer_user *tu;
-	int err;
 
 	tu = file->private_data;
-	err = fasync_helper(fd, file, on, &tu->fasync);
-        if (err < 0)
-		return err;
-	return 0;
+	return fasync_helper(fd, file, on, &tu->fasync);
 }
 
 static ssize_t snd_timer_user_read(struct file *file, char __user *buffer,
_

Patches currently in -mm which might be from corbet@lwn.net are

linux-next.patch
pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch
revert-protect-f_flags-against-races-and-eliminate-fasync-bkl-usage.patch
fasync-rename-struct-file-f_ep_lock.patch
fasync-use-f_lock-to-protect-f_flags.patch
fasync-move-bit-handling-to-f_op-fasync.patch
fasync-rationalize-return-values.patch

