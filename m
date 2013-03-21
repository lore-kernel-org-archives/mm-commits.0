From: akpm@linux-foundation.org
Subject: [to-be-updated] gadget-remove-only-user-of-aio-retry.patch removed from -mm tree
Date: Thu, 21 Mar 2013 15:27:27 -0700
Message-ID: <20130321222727.A0B8531C15E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:56552 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab3CUW13 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:27:29 -0400
Received: by mail-ve0-f201.google.com with SMTP id 14so310068vea.4
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:27:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zab@redhat.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, koverstreet@google.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: gadget: remove only user of aio retry
has been removed from the -mm tree.  Its filename was
     gadget-remove-only-user-of-aio-retry.patch

This patch was dropped because an updated version will be merged

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
Cc: Jeff Moyer <jmoyer@redhat.com>
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
+	struct kiocb 		*iocb;
+	struct mm_struct 	*mm;
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

aio-remove-retry-based-aio.patch
char-add-aio_readwrite-to-dev-nullzero.patch
aio-kill-return-value-of-aio_complete.patch
aio-kiocb_cancel.patch
aio-move-private-stuff-out-of-aioh.patch
aio-dprintk-pr_debug.patch
aio-do-fget-after-aio_get_req.patch
aio-make-aio_put_req-lockless.patch
aio-refcounting-cleanup.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-use-flush_dcache_page.patch
aio-use-cancellation-list-lazily.patch
aio-change-reqs_active-to-include-unreaped-completions.patch
aio-kill-batch-allocation.patch
aio-kill-struct-aio_ring_info.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
aio-fix-ringbuffer-calculation-so-we-dont-wrap.patch

