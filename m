From: akpm@linux-foundation.org
Subject: + aio-kill-ki_retry.patch added to -mm tree
Date: Thu, 21 Mar 2013 15:38:46 -0700
Message-ID: <20130321223847.06B8031C121@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:47175 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab3CUWit (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:38:49 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so311431qen.4
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:38:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com


The patch titled
     Subject: aio: kill ki_retry
has been added to the -mm tree.  Its filename is
     aio-kill-ki_retry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio: kill ki_retry

Thanks to Zach Brown's work to rip out the retry infrastructure, we don't
need this anymore - ki_retry was only called right after the kiocb was
initialized.

This also refactors and trims some duplicated code, as well as cleaning up
the refcounting/error handling a bit.

[akpm@linux-foundation.org: use fmode_t in aio_run_iocb()]
Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
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

 fs/aio.c            |  218 +++++++++++++++---------------------------
 include/linux/aio.h |   26 -----
 2 files changed, 82 insertions(+), 162 deletions(-)

diff -puN fs/aio.c~aio-kill-ki_retry fs/aio.c
--- a/fs/aio.c~aio-kill-ki_retry
+++ a/fs/aio.c
@@ -1005,24 +1005,15 @@ static void aio_advance_iovec(struct kio
 	BUG_ON(ret > 0 && iocb->ki_left == 0);
 }
 
-static ssize_t aio_rw_vect_retry(struct kiocb *iocb)
+typedef ssize_t (aio_rw_op)(struct kiocb *, const struct iovec *,
+			    unsigned long, loff_t);
+
+static ssize_t aio_rw_vect_retry(struct kiocb *iocb, int rw, aio_rw_op *rw_op)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
-	ssize_t (*rw_op)(struct kiocb *, const struct iovec *,
-			 unsigned long, loff_t);
 	ssize_t ret = 0;
-	unsigned short opcode;
-
-	if ((iocb->ki_opcode == IOCB_CMD_PREADV) ||
-		(iocb->ki_opcode == IOCB_CMD_PREAD)) {
-		rw_op = file->f_op->aio_read;
-		opcode = IOCB_CMD_PREADV;
-	} else {
-		rw_op = file->f_op->aio_write;
-		opcode = IOCB_CMD_PWRITEV;
-	}
 
 	/* This matches the pread()/pwrite() logic */
 	if (iocb->ki_pos < 0)
@@ -1038,7 +1029,7 @@ static ssize_t aio_rw_vect_retry(struct
 	/* retry all partial writes.  retry partial reads as long as its a
 	 * regular file. */
 	} while (ret > 0 && iocb->ki_left > 0 &&
-		 (opcode == IOCB_CMD_PWRITEV ||
+		 (rw == WRITE ||
 		  (!S_ISFIFO(inode->i_mode) && !S_ISSOCK(inode->i_mode))));
 
 	/* This means we must have transferred all that we could */
@@ -1048,7 +1039,7 @@ static ssize_t aio_rw_vect_retry(struct
 
 	/* If we managed to write some out we return that, rather than
 	 * the eventual error. */
-	if (opcode == IOCB_CMD_PWRITEV
+	if (rw == WRITE
 	    && ret < 0 && ret != -EIOCBQUEUED
 	    && iocb->ki_nbytes - iocb->ki_left)
 		ret = iocb->ki_nbytes - iocb->ki_left;
@@ -1056,73 +1047,41 @@ static ssize_t aio_rw_vect_retry(struct
 	return ret;
 }
 
-static ssize_t aio_fdsync(struct kiocb *iocb)
-{
-	struct file *file = iocb->ki_filp;
-	ssize_t ret = -EINVAL;
-
-	if (file->f_op->aio_fsync)
-		ret = file->f_op->aio_fsync(iocb, 1);
-	return ret;
-}
-
-static ssize_t aio_fsync(struct kiocb *iocb)
-{
-	struct file *file = iocb->ki_filp;
-	ssize_t ret = -EINVAL;
-
-	if (file->f_op->aio_fsync)
-		ret = file->f_op->aio_fsync(iocb, 0);
-	return ret;
-}
-
-static ssize_t aio_setup_vectored_rw(int type, struct kiocb *kiocb, bool compat)
+static ssize_t aio_setup_vectored_rw(int rw, struct kiocb *kiocb, bool compat)
 {
 	ssize_t ret;
 
+	kiocb->ki_nr_segs = kiocb->ki_nbytes;
+
 #ifdef CONFIG_COMPAT
 	if (compat)
-		ret = compat_rw_copy_check_uvector(type,
+		ret = compat_rw_copy_check_uvector(rw,
 				(struct compat_iovec __user *)kiocb->ki_buf,
-				kiocb->ki_nbytes, 1, &kiocb->ki_inline_vec,
+				kiocb->ki_nr_segs, 1, &kiocb->ki_inline_vec,
 				&kiocb->ki_iovec);
 	else
 #endif
-		ret = rw_copy_check_uvector(type,
+		ret = rw_copy_check_uvector(rw,
 				(struct iovec __user *)kiocb->ki_buf,
-				kiocb->ki_nbytes, 1, &kiocb->ki_inline_vec,
+				kiocb->ki_nr_segs, 1, &kiocb->ki_inline_vec,
 				&kiocb->ki_iovec);
 	if (ret < 0)
-		goto out;
-
-	ret = rw_verify_area(type, kiocb->ki_filp, &kiocb->ki_pos, ret);
-	if (ret < 0)
-		goto out;
+		return ret;
 
-	kiocb->ki_nr_segs = kiocb->ki_nbytes;
-	kiocb->ki_cur_seg = 0;
-	/* ki_nbytes/left now reflect bytes instead of segs */
+	/* ki_nbytes now reflect bytes instead of segs */
 	kiocb->ki_nbytes = ret;
-	kiocb->ki_left = ret;
-
-	ret = 0;
-out:
-	return ret;
+	return 0;
 }
 
-static ssize_t aio_setup_single_vector(int type, struct file * file, struct kiocb *kiocb)
+static ssize_t aio_setup_single_vector(int rw, struct kiocb *kiocb)
 {
-	int bytes;
-
-	bytes = rw_verify_area(type, file, &kiocb->ki_pos, kiocb->ki_left);
-	if (bytes < 0)
-		return bytes;
+	if (unlikely(!access_ok(!rw, kiocb->ki_buf, kiocb->ki_nbytes)))
+		return -EFAULT;
 
 	kiocb->ki_iovec = &kiocb->ki_inline_vec;
 	kiocb->ki_iovec->iov_base = kiocb->ki_buf;
-	kiocb->ki_iovec->iov_len = bytes;
+	kiocb->ki_iovec->iov_len = kiocb->ki_nbytes;
 	kiocb->ki_nr_segs = 1;
-	kiocb->ki_cur_seg = 0;
 	return 0;
 }
 
@@ -1131,81 +1090,81 @@ static ssize_t aio_setup_single_vector(i
  *	Performs the initial checks and aio retry method
  *	setup for the kiocb at the time of io submission.
  */
-static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
+static ssize_t aio_run_iocb(struct kiocb *req, bool compat)
 {
-	struct file *file = kiocb->ki_filp;
-	ssize_t ret = 0;
+	struct file *file = req->ki_filp;
+	ssize_t ret;
+	int rw;
+	fmode_t mode;
+	aio_rw_op *rw_op;
 
-	switch (kiocb->ki_opcode) {
+	switch (req->ki_opcode) {
 	case IOCB_CMD_PREAD:
-		ret = -EBADF;
-		if (unlikely(!(file->f_mode & FMODE_READ)))
-			break;
-		ret = -EFAULT;
-		if (unlikely(!access_ok(VERIFY_WRITE, kiocb->ki_buf,
-			kiocb->ki_left)))
-			break;
-		ret = aio_setup_single_vector(READ, file, kiocb);
-		if (ret)
-			break;
-		ret = -EINVAL;
-		if (file->f_op->aio_read)
-			kiocb->ki_retry = aio_rw_vect_retry;
-		break;
-	case IOCB_CMD_PWRITE:
-		ret = -EBADF;
-		if (unlikely(!(file->f_mode & FMODE_WRITE)))
-			break;
-		ret = -EFAULT;
-		if (unlikely(!access_ok(VERIFY_READ, kiocb->ki_buf,
-			kiocb->ki_left)))
-			break;
-		ret = aio_setup_single_vector(WRITE, file, kiocb);
-		if (ret)
-			break;
-		ret = -EINVAL;
-		if (file->f_op->aio_write)
-			kiocb->ki_retry = aio_rw_vect_retry;
-		break;
 	case IOCB_CMD_PREADV:
-		ret = -EBADF;
-		if (unlikely(!(file->f_mode & FMODE_READ)))
-			break;
-		ret = aio_setup_vectored_rw(READ, kiocb, compat);
-		if (ret)
-			break;
-		ret = -EINVAL;
-		if (file->f_op->aio_read)
-			kiocb->ki_retry = aio_rw_vect_retry;
-		break;
+		mode	= FMODE_READ;
+		rw	= READ;
+		rw_op	= file->f_op->aio_read;
+		goto rw_common;
+
+	case IOCB_CMD_PWRITE:
 	case IOCB_CMD_PWRITEV:
-		ret = -EBADF;
-		if (unlikely(!(file->f_mode & FMODE_WRITE)))
-			break;
-		ret = aio_setup_vectored_rw(WRITE, kiocb, compat);
+		mode	= FMODE_WRITE;
+		rw	= WRITE;
+		rw_op	= file->f_op->aio_write;
+		goto rw_common;
+rw_common:
+		if (unlikely(!(file->f_mode & mode)))
+			return -EBADF;
+
+		if (!rw_op)
+			return -EINVAL;
+
+		ret = (req->ki_opcode == IOCB_CMD_PREADV ||
+		       req->ki_opcode == IOCB_CMD_PWRITEV)
+			? aio_setup_vectored_rw(rw, req, compat)
+			: aio_setup_single_vector(rw, req);
 		if (ret)
-			break;
-		ret = -EINVAL;
-		if (file->f_op->aio_write)
-			kiocb->ki_retry = aio_rw_vect_retry;
+			return ret;
+
+		ret = rw_verify_area(rw, file, &req->ki_pos, req->ki_nbytes);
+		if (ret < 0)
+			return ret;
+
+		req->ki_nbytes = ret;
+		req->ki_left = ret;
+
+		ret = aio_rw_vect_retry(req, rw, rw_op);
 		break;
+
 	case IOCB_CMD_FDSYNC:
-		ret = -EINVAL;
-		if (file->f_op->aio_fsync)
-			kiocb->ki_retry = aio_fdsync;
+		if (!file->f_op->aio_fsync)
+			return -EINVAL;
+
+		ret = file->f_op->aio_fsync(req, 1);
 		break;
+
 	case IOCB_CMD_FSYNC:
-		ret = -EINVAL;
-		if (file->f_op->aio_fsync)
-			kiocb->ki_retry = aio_fsync;
+		if (!file->f_op->aio_fsync)
+			return -EINVAL;
+
+		ret = file->f_op->aio_fsync(req, 0);
 		break;
+
 	default:
 		pr_debug("EINVAL: no operation provided\n");
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
-	if (!kiocb->ki_retry)
-		return ret;
+	if (ret != -EIOCBQUEUED) {
+		/*
+		 * There's no easy way to restart the syscall since other AIO's
+		 * may be already running. Just fail this IO with EINTR.
+		 */
+		if (unlikely(ret == -ERESTARTSYS || ret == -ERESTARTNOINTR ||
+			     ret == -ERESTARTNOHAND || ret == -ERESTART_RESTARTBLOCK))
+			ret = -EINTR;
+		aio_complete(req, ret, 0);
+	}
 
 	return 0;
 }
@@ -1232,7 +1191,7 @@ static int io_submit_one(struct kioctx *
 		return -EINVAL;
 	}
 
-	req = aio_get_req(ctx);  /* returns with 2 references to req */
+	req = aio_get_req(ctx);
 	if (unlikely(!req))
 		return -EAGAIN;
 
@@ -1271,25 +1230,12 @@ static int io_submit_one(struct kioctx *
 	req->ki_left = req->ki_nbytes = iocb->aio_nbytes;
 	req->ki_opcode = iocb->aio_lio_opcode;
 
-	ret = aio_setup_iocb(req, compat);
+	ret = aio_run_iocb(req, compat);
 	if (ret)
 		goto out_put_req;
 
-	ret = req->ki_retry(req);
-	if (ret != -EIOCBQUEUED) {
-		/*
-		 * There's no easy way to restart the syscall since other AIO's
-		 * may be already running. Just fail this IO with EINTR.
-		 */
-		if (unlikely(ret == -ERESTARTSYS || ret == -ERESTARTNOINTR ||
-			     ret == -ERESTARTNOHAND || ret == -ERESTART_RESTARTBLOCK))
-			ret = -EINTR;
-		aio_complete(req, ret, 0);
-	}
-
 	aio_put_req(req);	/* drop extra ref to req */
 	return 0;
-
 out_put_req:
 	put_reqs_available(ctx, 1);
 	aio_put_req(req);	/* drop extra ref to req */
diff -puN include/linux/aio.h~aio-kill-ki_retry include/linux/aio.h
--- a/include/linux/aio.h~aio-kill-ki_retry
+++ a/include/linux/aio.h
@@ -29,38 +29,12 @@ struct kiocb;
 
 typedef int (kiocb_cancel_fn)(struct kiocb *, struct io_event *);
 
-/* is there a better place to document function pointer methods? */
-/**
- * ki_retry	-	iocb forward progress callback
- * @kiocb:	The kiocb struct to advance by performing an operation.
- *
- * This callback is called when the AIO core wants a given AIO operation
- * to make forward progress.  The kiocb argument describes the operation
- * that is to be performed.  As the operation proceeds, perhaps partially,
- * ki_retry is expected to update the kiocb with progress made.  Typically
- * ki_retry is set in the AIO core and it itself calls file_operations
- * helpers.
- *
- * ki_retry's return value determines when the AIO operation is completed
- * and an event is generated in the AIO event ring.  Except the special
- * return values described below, the value that is returned from ki_retry
- * is transferred directly into the completion ring as the operation's
- * resulting status.  Once this has happened ki_retry *MUST NOT* reference
- * the kiocb pointer again.
- *
- * If ki_retry returns -EIOCBQUEUED it has made a promise that aio_complete()
- * will be called on the kiocb pointer in the future.  The AIO core will
- * not ask the method again -- ki_retry must ensure forward progress.
- * aio_complete() must be called once and only once in the future, multiple
- * calls may result in undefined behaviour.
- */
 struct kiocb {
 	atomic_t		ki_users;
 
 	struct file		*ki_filp;
 	struct kioctx		*ki_ctx;	/* NULL for sync ops */
 	kiocb_cancel_fn		*ki_cancel;
-	ssize_t			(*ki_retry)(struct kiocb *);
 	void			(*ki_dtor)(struct kiocb *);
 
 	union {
_

Patches currently in -mm which might be from koverstreet@google.com are

mm-remove-old-aio-use_mm-comment.patch
aio-remove-dead-code-from-aioh.patch
gadget-remove-only-user-of-aio-retry.patch
aio-remove-retry-based-aio.patch
char-add-aio_readwrite-to-dev-nullzero.patch
aio-kill-return-value-of-aio_complete.patch
aio-add-kiocb_cancel.patch
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
block-prep-work-for-batch-completion.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

