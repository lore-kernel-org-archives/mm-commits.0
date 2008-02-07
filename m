From: akpm@linux-foundation.org
Subject: - sigio-driven-i-o-with-inotify-queues.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:20:53 -0800
Message-ID: <200802070020.m170KYGt006153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36612 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934010AbYBGAVn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:21:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: antipov@dev.rtsoft.ru, mtk-manpages@gmx.net, rlove@google.com, ttb@tentacle.dhs.org, mm-commits@vger.kernel.org


The patch titled
     SIGIO-driven I/O with inotify queues
has been removed from the -mm tree.  Its filename was
     sigio-driven-i-o-with-inotify-queues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SIGIO-driven I/O with inotify queues
From: Dmitry Antipov <antipov@dev.rtsoft.ru>

Add SIGIO-driven I/O for descriptors returned by inotify_init().  The thing
may be enabled by convenient fcntl (fd, F_SETFL, O_ASYNC) call.

Signed-off-by: Dmitry Antipov <antipov@dev.rtsoft.ru>
Cc: Robert Love <rlove@google.com>
Cc: John McCutchan <ttb@tentacle.dhs.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inotify_user.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN fs/inotify_user.c~sigio-driven-i-o-with-inotify-queues fs/inotify_user.c
--- a/fs/inotify_user.c~sigio-driven-i-o-with-inotify-queues
+++ a/fs/inotify_user.c
@@ -79,6 +79,7 @@ struct inotify_device {
 	atomic_t		count;		/* reference count */
 	struct user_struct	*user;		/* user who opened this dev */
 	struct inotify_handle	*ih;		/* inotify handle */
+	struct fasync_struct    *fa;            /* async notification */
 	unsigned int		queue_size;	/* size of the queue (bytes) */
 	unsigned int		event_count;	/* number of pending events */
 	unsigned int		max_events;	/* maximum number of events */
@@ -315,6 +316,7 @@ static void inotify_dev_queue_event(stru
 	dev->queue_size += sizeof(struct inotify_event) + kevent->event.len;
 	list_add_tail(&kevent->list, &dev->events);
 	wake_up_interruptible(&dev->wq);
+	kill_fasync(&dev->fa, SIGIO, POLL_IN);
 
 out:
 	mutex_unlock(&dev->ev_mutex);
@@ -503,6 +505,13 @@ static ssize_t inotify_read(struct file 
 	return ret;
 }
 
+static int inotify_fasync(int fd, struct file *file, int on)
+{
+	struct inotify_device *dev = file->private_data;
+
+	return fasync_helper(fd, file, on, &dev->fa) >= 0 ? 0 : -EIO;
+}
+
 static int inotify_release(struct inode *ignored, struct file *file)
 {
 	struct inotify_device *dev = file->private_data;
@@ -515,6 +524,9 @@ static int inotify_release(struct inode 
 		inotify_dev_event_dequeue(dev);
 	mutex_unlock(&dev->ev_mutex);
 
+	if (file->f_flags & FASYNC)
+		inotify_fasync(-1, file, 0);
+
 	/* free this device: the put matching the get in inotify_init() */
 	put_inotify_dev(dev);
 
@@ -543,6 +555,7 @@ static long inotify_ioctl(struct file *f
 static const struct file_operations inotify_fops = {
 	.poll           = inotify_poll,
 	.read           = inotify_read,
+	.fasync         = inotify_fasync,
 	.release        = inotify_release,
 	.unlocked_ioctl = inotify_ioctl,
 	.compat_ioctl	= inotify_ioctl,
@@ -590,6 +603,7 @@ asmlinkage long sys_inotify_init(void)
 		goto out_free_dev;
 	}
 	dev->ih = ih;
+	dev->fa = NULL;
 
 	filp->f_op = &inotify_fops;
 	filp->f_path.mnt = mntget(inotify_mnt);
_

Patches currently in -mm which might be from antipov@dev.rtsoft.ru are

origin.patch
