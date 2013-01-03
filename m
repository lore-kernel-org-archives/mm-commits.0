From: akpm@linux-foundation.org
Subject: + aio-do-fget-after-aio_get_req.patch added to -mm tree
Date: Thu, 03 Jan 2013 15:39:51 -0800
Message-ID: <20130103233952.C076E200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f201.google.com ([74.125.82.201]:37231 "EHLO
	mail-we0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3ACXj4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jan 2013 18:39:56 -0500
Received: by mail-we0-f201.google.com with SMTP id t11so985742wey.4
        for <mm-commits@vger.kernel.org>; Thu, 03 Jan 2013 15:39:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, viro@zeniv.linux.org.uk, zab@redhat.com


The patch titled
     Subject: aio: do fget() after aio_get_req()
has been added to the -mm tree.  Its filename is
     aio-do-fget-after-aio_get_req.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN fs/aio.c~aio-do-fget-after-aio_get_req fs/aio.c
--- a/fs/aio.c~aio-do-fget-after-aio_get_req
+++ a/fs/aio.c
@@ -584,6 +584,8 @@ static inline void really_put_req(struct
 {
 	assert_spin_locked(&ctx->ctx_lock);
 
+	if (req->ki_filp)
+		fput(req->ki_filp);
 	if (req->ki_eventfd != NULL)
 		eventfd_ctx_put(req->ki_eventfd);
 	if (req->ki_dtor)
@@ -602,9 +604,6 @@ static inline void really_put_req(struct
  */
 static void __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 {
-	pr_debug("(%p): f_count=%ld\n",
-		 req, atomic_long_read(&req->ki_filp->f_count));
-
 	assert_spin_locked(&ctx->ctx_lock);
 
 	req->ki_users--;
@@ -615,8 +614,6 @@ static void __aio_put_req(struct kioctx 
 	req->ki_cancel = NULL;
 	req->ki_retry = NULL;
 
-	fput(req->ki_filp);
-	req->ki_filp = NULL;
 	really_put_req(ctx, req);
 }
 
@@ -1264,7 +1261,6 @@ static int io_submit_one(struct kioctx *
 			 bool compat)
 {
 	struct kiocb *req;
-	struct file *file;
 	ssize_t ret;
 
 	/* enforce forwards compatibility on users */
@@ -1283,16 +1279,16 @@ static int io_submit_one(struct kioctx *
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

mm-remove-old-aio-use_mm-comment.patch
aio-remove-dead-code-from-aioh.patch
gadget-remove-only-user-of-aio-retry.patch
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
wait-add-wait_event_hrtimeout-fix.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-use-flush_dcache_page.patch
aio-use-cancellation-list-lazily.patch
aio-change-reqs_active-to-include-unreaped-completions.patch
aio-kill-batch-allocation.patch
aio-kill-struct-aio_ring_info.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
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
aio-smoosh-struct-kiocb.patch

