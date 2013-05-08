From: akpm@linux-foundation.org
Subject: [merged] aio-do-fget-after-aio_get_req.patch removed from -mm tree
Date: Wed, 08 May 2013 11:35:16 -0700
Message-ID: <20130508183516.E531231C088@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:54817 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176Ab3EHSfT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:35:19 -0400
Received: by mail-ye0-f201.google.com with SMTP id m14so207770yen.2
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:35:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: do fget() after aio_get_req()
has been removed from the -mm tree.  Its filename was
     aio-do-fget-after-aio_get_req.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio: do fget() after aio_get_req()

aio_get_req() will fail if we have the maximum number of requests
outstanding, which depending on the application may not be uncommon.  So
avoid doing an unnecessary fget().

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
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN fs/aio.c~aio-do-fget-after-aio_get_req fs/aio.c
--- a/fs/aio.c~aio-do-fget-after-aio_get_req
+++ a/fs/aio.c
@@ -587,6 +587,8 @@ static inline void really_put_req(struct
 {
 	assert_spin_locked(&ctx->ctx_lock);
 
+	if (req->ki_filp)
+		fput(req->ki_filp);
 	if (req->ki_eventfd != NULL)
 		eventfd_ctx_put(req->ki_eventfd);
 	if (req->ki_dtor)
@@ -605,9 +607,6 @@ static inline void really_put_req(struct
  */
 static void __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 {
-	pr_debug("(%p): f_count=%ld\n",
-		 req, atomic_long_read(&req->ki_filp->f_count));
-
 	assert_spin_locked(&ctx->ctx_lock);
 
 	req->ki_users--;
@@ -618,8 +617,6 @@ static void __aio_put_req(struct kioctx
 	req->ki_cancel = NULL;
 	req->ki_retry = NULL;
 
-	fput(req->ki_filp);
-	req->ki_filp = NULL;
 	really_put_req(ctx, req);
 }
 
@@ -1270,7 +1267,6 @@ static int io_submit_one(struct kioctx *
 			 bool compat)
 {
 	struct kiocb *req;
-	struct file *file;
 	ssize_t ret;
 
 	/* enforce forwards compatibility on users */
@@ -1289,16 +1285,16 @@ static int io_submit_one(struct kioctx *
 		return -EINVAL;
 	}
 
-	file = fget(iocb->aio_fildes);
-	if (unlikely(!file))
-		return -EBADF;
-
 	req = aio_get_req(ctx, batch);  /* returns with 2 references to req */
-	if (unlikely(!req)) {
-		fput(file);
+	if (unlikely(!req))
 		return -EAGAIN;
+
+	req->ki_filp = fget(iocb->aio_fildes);
+	if (unlikely(!req->ki_filp)) {
+		ret = -EBADF;
+		goto out_put_req;
 	}
-	req->ki_filp = file;
+
 	if (iocb->aio_flags & IOCB_FLAG_RESFD) {
 		/*
 		 * If the IOCB_FLAG_RESFD flag of aio_flags is set, get an
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

