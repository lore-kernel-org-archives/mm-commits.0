From: akpm@linux-foundation.org
Subject: [merged] aio-fix-race-between-io_destroy-and-io_submit.patch removed from -mm tree
Date: Mon, 28 Feb 2011 13:10:55 -0800
Message-ID: <201102282110.p1SLAt2x029364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755194Ab1B1VLm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 16:11:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, jmoyer@redhat.com, npiggin@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     aio: fix race between io_destroy() and io_submit()
has been removed from the -mm tree.  Its filename was
     aio-fix-race-between-io_destroy-and-io_submit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
ext3-use-little-endian-bitops.patch
udf-use-little-endian-bitops.patch
bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh.patch

