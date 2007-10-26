From: akpm@linux-foundation.org
Subject: + sigio-driven-i-o-with-inotify-queues.patch added to -mm tree
Date: Fri, 26 Oct 2007 13:29:03 -0700
Message-ID: <200710262029.l9QKT3ZO012935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33741 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753891AbXJZU3k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 16:29:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: antipov@dev.rtsoft.ru, mtk-manpages@gmx.net, rlove@google.com, ttb@tentacle.dhs.org


The patch titled
     SIGIO-driven I/O with inotify queues
has been added to the -mm tree.  Its filename is
     sigio-driven-i-o-with-inotify-queues.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

sigio-driven-i-o-with-inotify-queues.patch
