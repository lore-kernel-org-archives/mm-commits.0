From: akpm@linux-foundation.org
Subject: [merged] aio-add-kiocb_cancel.patch removed from -mm tree
Date: Wed, 08 May 2013 11:35:06 -0700
Message-ID: <20130508183506.E046A31C1EA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:51714 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176Ab3EHSfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:35:08 -0400
Received: by mail-gg0-f201.google.com with SMTP id k25so207939ggl.2
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:35:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: add kiocb_cancel()
has been removed from the -mm tree.  Its filename was
     aio-add-kiocb_cancel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio: add kiocb_cancel()

Minor refactoring, to get rid of some duplicated code

[akpm@linux-foundation.org: fix warning]
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

 fs/aio.c |   79 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 43 insertions(+), 36 deletions(-)

diff -puN fs/aio.c~aio-add-kiocb_cancel fs/aio.c
--- a/fs/aio.c~aio-add-kiocb_cancel
+++ a/fs/aio.c
@@ -220,6 +220,29 @@ static inline void put_ioctx(struct kioc
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
+		res->obj = (u64)(unsigned long)kiocb->ki_obj.user;
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
@@ -290,25 +313,19 @@ out_freectx:
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
@@ -1416,7 +1433,7 @@ static struct kiocb *lookup_kiocb(struct
 SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 		struct io_event __user *, result)
 {
-	int (*cancel)(struct kiocb *iocb, struct io_event *res);
+	struct io_event res;
 	struct kioctx *ctx;
 	struct kiocb *kiocb;
 	u32 key;
@@ -1431,32 +1448,22 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t
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

