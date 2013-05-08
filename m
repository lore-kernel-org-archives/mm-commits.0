From: akpm@linux-foundation.org
Subject: [merged] gadget-remove-only-user-of-aio-retry.patch removed from -mm tree
Date: Wed, 08 May 2013 11:34:54 -0700
Message-ID: <20130508183454.E65085A415E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:38515 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758196Ab3EHSe5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:34:57 -0400
Received: by mail-qe0-f74.google.com with SMTP id 1so207871qec.1
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:34:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zab@redhat.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, koverstreet@google.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: gadget: remove only user of aio retry
has been removed from the -mm tree.  Its filename was
     gadget-remove-only-user-of-aio-retry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zach Brown <zab@redhat.com>
Subject: gadget: remove only user of aio retry

This removes the only in-tree user of aio retry.  This will let us remove
the retry code from the aio core.

Removing retry is relatively easy as the USB gadget wasn't using it to
retry IOs at all.  It always fully submitted the IO in the context of the
initial io_submit() call.  It only used the AIO retry facility to get the
submitter's mm context for copying the result of a read back to user
space.  This is easy to implement with use_mm() and a work struct, much
like kvm does with async_pf_execute() for get_user_pages().

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Zach Brown <zab@redhat.com>
Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/inode.c |   38 ++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff -puN drivers/usb/gadget/inode.c~gadget-remove-only-user-of-aio-retry drivers/usb/gadget/inode.c
--- a/drivers/usb/gadget/inode.c~gadget-remove-only-user-of-aio-retry
+++ a/drivers/usb/gadget/inode.c
@@ -24,6 +24,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
+#include <linux/mmu_context.h>
 
 #include <linux/device.h>
 #include <linux/moduleparam.h>
@@ -513,6 +514,9 @@ static long ep_ioctl(struct file *fd, un
 struct kiocb_priv {
 	struct usb_request	*req;
 	struct ep_data		*epdata;
+	struct kiocb		*iocb;
+	struct mm_struct	*mm;
+	struct work_struct	work;
 	void			*buf;
 	const struct iovec	*iv;
 	unsigned long		nr_segs;
@@ -540,15 +544,12 @@ static int ep_aio_cancel(struct kiocb *i
 	return value;
 }
 
-static ssize_t ep_aio_read_retry(struct kiocb *iocb)
+static ssize_t ep_copy_to_user(struct kiocb_priv *priv)
 {
-	struct kiocb_priv	*priv = iocb->private;
 	ssize_t			len, total;
 	void			*to_copy;
 	int			i;
 
-	/* we "retry" to get the right mm context for this: */
-
 	/* copy stuff into user buffers */
 	total = priv->actual;
 	len = 0;
@@ -568,9 +569,26 @@ static ssize_t ep_aio_read_retry(struct
 		if (total == 0)
 			break;
 	}
+
+	return len;
+}
+
+static void ep_user_copy_worker(struct work_struct *work)
+{
+	struct kiocb_priv *priv = container_of(work, struct kiocb_priv, work);
+	struct mm_struct *mm = priv->mm;
+	struct kiocb *iocb = priv->iocb;
+	size_t ret;
+
+	use_mm(mm);
+	ret = ep_copy_to_user(priv);
+	unuse_mm(mm);
+
+	/* completing the iocb can drop the ctx and mm, don't touch mm after */
+	aio_complete(iocb, ret, ret);
+
 	kfree(priv->buf);
 	kfree(priv);
-	return len;
 }
 
 static void ep_aio_complete(struct usb_ep *ep, struct usb_request *req)
@@ -596,14 +614,14 @@ static void ep_aio_complete(struct usb_e
 		aio_complete(iocb, req->actual ? req->actual : req->status,
 				req->status);
 	} else {
-		/* retry() won't report both; so we hide some faults */
+		/* ep_copy_to_user() won't report both; we hide some faults */
 		if (unlikely(0 != req->status))
 			DBG(epdata->dev, "%s fault %d len %d\n",
 				ep->name, req->status, req->actual);
 
 		priv->buf = req->buf;
 		priv->actual = req->actual;
-		kick_iocb(iocb);
+		schedule_work(&priv->work);
 	}
 	spin_unlock(&epdata->dev->lock);
 
@@ -633,8 +651,10 @@ fail:
 		return value;
 	}
 	iocb->private = priv;
+	priv->iocb = iocb;
 	priv->iv = iv;
 	priv->nr_segs = nr_segs;
+	INIT_WORK(&priv->work, ep_user_copy_worker);
 
 	value = get_ready_ep(iocb->ki_filp->f_flags, epdata);
 	if (unlikely(value < 0)) {
@@ -646,6 +666,7 @@ fail:
 	get_ep(epdata);
 	priv->epdata = epdata;
 	priv->actual = 0;
+	priv->mm = current->mm; /* mm teardown waits for iocbs in exit_aio() */
 
 	/* each kiocb is coupled to one usb_request, but we can't
 	 * allocate or submit those if the host disconnected.
@@ -674,7 +695,7 @@ fail:
 		kfree(priv);
 		put_ep(epdata);
 	} else
-		value = (iv ? -EIOCBRETRY : -EIOCBQUEUED);
+		value = -EIOCBQUEUED;
 	return value;
 }
 
@@ -692,7 +713,6 @@ ep_aio_read(struct kiocb *iocb, const st
 	if (unlikely(!buf))
 		return -ENOMEM;
 
-	iocb->ki_retry = ep_aio_read_retry;
 	return ep_aio_rwtail(iocb, buf, iocb->ki_left, epdata, iov, nr_segs);
 }
 
_

Patches currently in -mm which might be from zab@redhat.com are

origin.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
block-prep-work-for-batch-completion.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

