From: akpm@linux-foundation.org
Subject: [merged] aio-kill-return-value-of-aio_complete.patch removed from -mm tree
Date: Wed, 08 May 2013 11:35:03 -0700
Message-ID: <20130508183503.E42115A41EF@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:34829 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160Ab3EHSfF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:35:05 -0400
Received: by mail-ye0-f202.google.com with SMTP id r13so207752yen.1
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:35:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: kill return value of aio_complete()
has been removed from the -mm tree.  Its filename was
     aio-kill-return-value-of-aio_complete.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio: kill return value of aio_complete()

Nothing used the return value, and it probably wasn't possible to use it
safely for the locked versions (aio_complete(), aio_put_req()).  Just kill
it.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Acked-by: Zach Brown <zab@redhat.com>
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
Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c            |   21 +++++++--------------
 include/linux/aio.h |    8 ++++----
 2 files changed, 11 insertions(+), 18 deletions(-)

diff -puN fs/aio.c~aio-kill-return-value-of-aio_complete fs/aio.c
--- a/fs/aio.c~aio-kill-return-value-of-aio_complete
+++ a/fs/aio.c
@@ -531,7 +531,7 @@ static inline void really_put_req(struct
 /* __aio_put_req
  *	Returns true if this put was the last user of the request.
  */
-static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
+static void __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 {
 	dprintk(KERN_DEBUG "aio_put(%p): f_count=%ld\n",
 		req, atomic_long_read(&req->ki_filp->f_count));
@@ -541,7 +541,7 @@ static int __aio_put_req(struct kioctx *
 	req->ki_users--;
 	BUG_ON(req->ki_users < 0);
 	if (likely(req->ki_users))
-		return 0;
+		return;
 	list_del(&req->ki_list);		/* remove from active_reqs */
 	req->ki_cancel = NULL;
 	req->ki_retry = NULL;
@@ -549,21 +549,18 @@ static int __aio_put_req(struct kioctx *
 	fput(req->ki_filp);
 	req->ki_filp = NULL;
 	really_put_req(ctx, req);
-	return 1;
 }
 
 /* aio_put_req
  *	Returns true if this put was the last user of the kiocb,
  *	false if the request is still in use.
  */
-int aio_put_req(struct kiocb *req)
+void aio_put_req(struct kiocb *req)
 {
 	struct kioctx *ctx = req->ki_ctx;
-	int ret;
 	spin_lock_irq(&ctx->ctx_lock);
-	ret = __aio_put_req(ctx, req);
+	__aio_put_req(ctx, req);
 	spin_unlock_irq(&ctx->ctx_lock);
-	return ret;
 }
 EXPORT_SYMBOL(aio_put_req);
 
@@ -593,10 +590,8 @@ static struct kioctx *lookup_ioctx(unsig
 
 /* aio_complete
  *	Called when the io request on the given iocb is complete.
- *	Returns true if this is the last user of the request.  The 
- *	only other user of the request can be the cancellation code.
  */
-int aio_complete(struct kiocb *iocb, long res, long res2)
+void aio_complete(struct kiocb *iocb, long res, long res2)
 {
 	struct kioctx	*ctx = iocb->ki_ctx;
 	struct aio_ring_info	*info;
@@ -604,7 +599,6 @@ int aio_complete(struct kiocb *iocb, lon
 	struct io_event	*event;
 	unsigned long	flags;
 	unsigned long	tail;
-	int		ret;
 
 	/*
 	 * Special case handling for sync iocbs:
@@ -618,7 +612,7 @@ int aio_complete(struct kiocb *iocb, lon
 		iocb->ki_user_data = res;
 		iocb->ki_users = 0;
 		wake_up_process(iocb->ki_obj.tsk);
-		return 1;
+		return;
 	}
 
 	info = &ctx->ring_info;
@@ -677,7 +671,7 @@ int aio_complete(struct kiocb *iocb, lon
 
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
-	ret = __aio_put_req(ctx, iocb);
+	__aio_put_req(ctx, iocb);
 
 	/*
 	 * We have to order our ring_info tail store above and test
@@ -691,7 +685,6 @@ put_rq:
 		wake_up(&ctx->wait);
 
 	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
-	return ret;
 }
 EXPORT_SYMBOL(aio_complete);
 
diff -puN include/linux/aio.h~aio-kill-return-value-of-aio_complete include/linux/aio.h
--- a/include/linux/aio.h~aio-kill-return-value-of-aio_complete
+++ a/include/linux/aio.h
@@ -167,16 +167,16 @@ struct kioctx {
 /* prototypes */
 #ifdef CONFIG_AIO
 extern ssize_t wait_on_sync_kiocb(struct kiocb *iocb);
-extern int aio_put_req(struct kiocb *iocb);
-extern int aio_complete(struct kiocb *iocb, long res, long res2);
+extern void aio_put_req(struct kiocb *iocb);
+extern void aio_complete(struct kiocb *iocb, long res, long res2);
 struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
 extern long do_io_submit(aio_context_t ctx_id, long nr,
 			 struct iocb __user *__user *iocbpp, bool compat);
 #else
 static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
-static inline int aio_put_req(struct kiocb *iocb) { return 0; }
-static inline int aio_complete(struct kiocb *iocb, long res, long res2) { return 0; }
+static inline void aio_put_req(struct kiocb *iocb) { }
+static inline void aio_complete(struct kiocb *iocb, long res, long res2) { }
 struct mm_struct;
 static inline void exit_aio(struct mm_struct *mm) { }
 static inline long do_io_submit(aio_context_t ctx_id, long nr,
_

Patches currently in -mm which might be from koverstreet@google.com are

origin.patch
linux-next.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

