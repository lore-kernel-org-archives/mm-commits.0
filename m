From: akpm@linux-foundation.org
Subject: + aio-fix-race-between-io_destroy-and-io_submit.patch added to -mm tree
Date: Wed, 23 Feb 2011 16:20:53 -0800
Message-ID: <201102240020.p1O0Krk7000840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755328Ab1BXAVh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Feb 2011 19:21:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, jmoyer@redhat.com, npiggin@kernel.dk


The patch titled
     aio: fix race between io_destroy() and io_submit()
has been added to the -mm tree.  Its filename is
     aio-fix-race-between-io_destroy-and-io_submit.patch

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
Subject: aio: fix race between io_destroy() and io_submit()
From: Jan Kara <jack@suse.cz>

A race can occur when io_submit() races with io_destroy():

 CPU1						CPU2
io_submit()
  do_io_submit()
    ...
    ctx = lookup_ioctx(ctx_id);
						io_destroy()
    Now do_io_submit() holds the last reference to ctx.
    ...
    queue new AIO
    put_ioctx(ctx) - frees ctx with active AIOs

We solve this issue by checking whether ctx is being destroyed in AIO
submission path after adding new AIO to ctx.  Then we are guaranteed that
either io_destroy() waits for new AIO or we see that ctx is being
destroyed and bail out.

Cc: Nick Piggin <npiggin@kernel.dk>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN fs/aio.c~aio-fix-race-between-io_destroy-and-io_submit fs/aio.c
--- a/fs/aio.c~aio-fix-race-between-io_destroy-and-io_submit
+++ a/fs/aio.c
@@ -1642,6 +1642,23 @@ static int io_submit_one(struct kioctx *
 		goto out_put_req;
 
 	spin_lock_irq(&ctx->ctx_lock);
+	/*
+	 * We could have raced with io_destroy() and are currently holding a
+	 * reference to ctx which should be destroyed. We cannot submit IO
+	 * since ctx gets freed as soon as io_submit() puts its reference.  The
+	 * check here is reliable: io_destroy() sets ctx->dead before waiting
+	 * for outstanding IO and the barrier between these two is realized by
+	 * unlock of mm->ioctx_lock and lock of ctx->ctx_lock.  Analogously we
+	 * increment ctx->reqs_active before checking for ctx->dead and the
+	 * barrier is realized by unlock and lock of ctx->ctx_lock. Thus if we
+	 * don't see ctx->dead set here, io_destroy() waits for our IO to
+	 * finish.
+	 */
+	if (ctx->dead) {
+		spin_unlock_irq(&ctx->ctx_lock);
+		ret = -EINVAL;
+		goto out_put_req;
+	}
 	aio_run_iocb(req);
 	if (!list_empty(&ctx->run_list)) {
 		/* drain the run list */
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
aio-fix-rcu-ioctx-lookup.patch
aio-fix-race-between-io_destroy-and-io_submit.patch
ext3-use-little-endian-bitops.patch
udf-use-little-endian-bitops.patch
bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh.patch

