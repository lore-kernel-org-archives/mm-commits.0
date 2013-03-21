From: akpm@linux-foundation.org
Subject: [to-be-updated] aio-do-fget-after-aio_get_req.patch removed from -mm tree
Date: Thu, 21 Mar 2013 15:27:55 -0700
Message-ID: <20130321222755.A68DF5A42C5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:49719 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932958Ab3CUW16 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:27:58 -0400
Received: by mail-vc0-f201.google.com with SMTP id hf12so310535vcb.2
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:27:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: do fget() after aio_get_req()
has been removed from the -mm tree.  Its filename was
     aio-do-fget-after-aio_get_req.patch

This patch was dropped because an updated version will be merged

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
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Theodore Ts'o <tytso@mit.edu>
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
 
@@ -1266,7 +1263,6 @@ static int io_submit_one(struct kioctx *
 			 bool compat)
 {
 	struct kiocb *req;
-	struct file *file;
 	ssize_t ret;
 
 	/* enforce forwards compatibility on users */
@@ -1285,16 +1281,16 @@ static int io_submit_one(struct kioctx *
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
aio-fix-aio_read_events_ring-types.patch
aio-document-clarify-aio_read_events-and-shadow_tail.patch
aio-correct-calculation-of-available-events.patch
aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
aio-fix-ringbuffer-calculation-so-we-dont-wrap.patch

