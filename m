From: akpm@linux-foundation.org
Subject: + aio-kiocb_cancel.patch added to -mm tree
Date: Thu, 03 Jan 2013 15:39:35 -0800
Message-ID: <20130103233936.C530320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:57897 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab3ACXjl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jan 2013 18:39:41 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so986518eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 03 Jan 2013 15:39:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, viro@zeniv.linux.org.uk, zab@redhat.com


The patch titled
     Subject: aio: add kiocb_cancel()
has been added to the -mm tree.  Its filename is
     aio-kiocb_cancel.patch

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
Subject: aio: add kiocb_cancel()

Minor refactoring, to get rid of some duplicated code

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

 fs/aio.c |   79 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 43 insertions(+), 36 deletions(-)

diff -puN fs/aio.c~aio-kiocb_cancel fs/aio.c
--- a/fs/aio.c~aio-kiocb_cancel
+++ a/fs/aio.c
@@ -217,6 +217,29 @@ static inline void put_ioctx(struct kioc
 		__put_ioctx(kioctx);
 }
 
+static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
+			struct io_event *res)
+{
+	int (*cancel)(struct kiocb *, struct io_event *);
+	int ret = -EINVAL;
+
+	cancel = kiocb->ki_cancel;
+	kiocbSetCancelled(kiocb);
+	if (cancel) {
+		kiocb->ki_users++;
+		spin_unlock_irq(&ctx->ctx_lock);
+
+		memset(res, 0, sizeof(*res));
+		res->obj = (u64) kiocb->ki_obj.user;
+		res->data = kiocb->ki_user_data;
+		ret = cancel(kiocb, res);
+
+		spin_lock_irq(&ctx->ctx_lock);
+	}
+
+	return ret;
+}
+
 /* ioctx_alloc
  *	Allocates and initializes an ioctx.  Returns an ERR_PTR if it failed.
  */
@@ -287,25 +310,19 @@ out_freectx:
  */
 static void kill_ctx(struct kioctx *ctx)
 {
-	int (*cancel)(struct kiocb *, struct io_event *);
 	struct task_struct *tsk = current;
 	DECLARE_WAITQUEUE(wait, tsk);
 	struct io_event res;
+	struct kiocb *req;
 
 	spin_lock_irq(&ctx->ctx_lock);
 	ctx->dead = 1;
 	while (!list_empty(&ctx->active_reqs)) {
-		struct list_head *pos = ctx->active_reqs.next;
-		struct kiocb *iocb = list_kiocb(pos);
-		list_del_init(&iocb->ki_list);
-		cancel = iocb->ki_cancel;
-		kiocbSetCancelled(iocb);
-		if (cancel) {
-			iocb->ki_users++;
-			spin_unlock_irq(&ctx->ctx_lock);
-			cancel(iocb, &res);
-			spin_lock_irq(&ctx->ctx_lock);
-		}
+		req = list_first_entry(&ctx->active_reqs,
+					struct kiocb, ki_list);
+
+		list_del_init(&req->ki_list);
+		kiocb_cancel(ctx, req, &res);
 	}
 
 	if (!ctx->reqs_active)
@@ -1409,7 +1426,7 @@ static struct kiocb *lookup_kiocb(struct
 SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 		struct io_event __user *, result)
 {
-	int (*cancel)(struct kiocb *iocb, struct io_event *res);
+	struct io_event res;
 	struct kioctx *ctx;
 	struct kiocb *kiocb;
 	u32 key;
@@ -1424,32 +1441,22 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t
 		return -EINVAL;
 
 	spin_lock_irq(&ctx->ctx_lock);
-	ret = -EAGAIN;
+
 	kiocb = lookup_kiocb(ctx, iocb, key);
-	if (kiocb && kiocb->ki_cancel) {
-		cancel = kiocb->ki_cancel;
-		kiocb->ki_users ++;
-		kiocbSetCancelled(kiocb);
-	} else
-		cancel = NULL;
+	if (kiocb)
+		ret = kiocb_cancel(ctx, kiocb, &res);
+	else
+		ret = -EINVAL;
+
 	spin_unlock_irq(&ctx->ctx_lock);
 
-	if (NULL != cancel) {
-		struct io_event tmp;
-		pr_debug("calling cancel\n");
-		memset(&tmp, 0, sizeof(tmp));
-		tmp.obj = (u64)(unsigned long)kiocb->ki_obj.user;
-		tmp.data = kiocb->ki_user_data;
-		ret = cancel(kiocb, &tmp);
-		if (!ret) {
-			/* Cancellation succeeded -- copy the result
-			 * into the user's buffer.
-			 */
-			if (copy_to_user(result, &tmp, sizeof(tmp)))
-				ret = -EFAULT;
-		}
-	} else
-		ret = -EINVAL;
+	if (!ret) {
+		/* Cancellation succeeded -- copy the result
+		 * into the user's buffer.
+		 */
+		if (copy_to_user(result, &res, sizeof(res)))
+			ret = -EFAULT;
+	}
 
 	put_ioctx(ctx);
 
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

