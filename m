From: akpm@linux-foundation.org
Subject: + aio-kill-ki_key.patch added to -mm tree
Date: Thu, 21 Mar 2013 15:38:43 -0700
Message-ID: <20130321223844.04C6431C121@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:42482 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab3CUWiq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:38:46 -0400
Received: by mail-vb0-f73.google.com with SMTP id fj18so311099vbb.4
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:38:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com


The patch titled
     Subject: aio: kill ki_key
has been added to the -mm tree.  Its filename is
     aio-kill-ki_key.patch

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
Subject: aio: kill ki_key

ki_key wasn't actually used for anything previously - it was always 0.
Drop it to trim struct kiocb a bit.

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

 fs/aio.c            |    7 +++++--
 include/linux/aio.h |    9 ++++-----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN fs/aio.c~aio-kill-ki_key fs/aio.c
--- a/fs/aio.c~aio-kill-ki_key
+++ a/fs/aio.c
@@ -1257,7 +1257,7 @@ static int io_submit_one(struct kioctx *
 		}
 	}
 
-	ret = put_user(req->ki_key, &user_iocb->aio_key);
+	ret = put_user(KIOCB_KEY, &user_iocb->aio_key);
 	if (unlikely(ret)) {
 		pr_debug("EFAULT: aio_key\n");
 		goto out_put_req;
@@ -1378,10 +1378,13 @@ static struct kiocb *lookup_kiocb(struct
 
 	assert_spin_locked(&ctx->ctx_lock);
 
+	if (key != KIOCB_KEY)
+		return NULL;
+
 	/* TODO: use a hash or array, this sucks. */
 	list_for_each(pos, &ctx->active_reqs) {
 		struct kiocb *kiocb = list_kiocb(pos);
-		if (kiocb->ki_obj.user == iocb && kiocb->ki_key == key)
+		if (kiocb->ki_obj.user == iocb)
 			return kiocb;
 	}
 	return NULL;
diff -puN include/linux/aio.h~aio-kill-ki_key include/linux/aio.h
--- a/include/linux/aio.h~aio-kill-ki_key
+++ a/include/linux/aio.h
@@ -12,7 +12,7 @@
 struct kioctx;
 struct kiocb;
 
-#define KIOCB_SYNC_KEY		(~0U)
+#define KIOCB_KEY		0
 
 /*
  * We use ki_cancel == KIOCB_CANCELLED to indicate that a kiocb has been either
@@ -56,10 +56,9 @@ typedef int (kiocb_cancel_fn)(struct kio
  */
 struct kiocb {
 	atomic_t		ki_users;
-	unsigned		ki_key;		/* id of this request */
 
 	struct file		*ki_filp;
-	struct kioctx		*ki_ctx;	/* may be NULL for sync ops */
+	struct kioctx		*ki_ctx;	/* NULL for sync ops */
 	kiocb_cancel_fn		*ki_cancel;
 	ssize_t			(*ki_retry)(struct kiocb *);
 	void			(*ki_dtor)(struct kiocb *);
@@ -95,14 +94,14 @@ struct kiocb {
 
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
 {
-	return kiocb->ki_key == KIOCB_SYNC_KEY;
+	return kiocb->ki_ctx == NULL;
 }
 
 static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
 {
 	*kiocb = (struct kiocb) {
 			.ki_users = ATOMIC_INIT(1),
-			.ki_key = KIOCB_SYNC_KEY,
+			.ki_ctx = NULL,
 			.ki_filp = filp,
 			.ki_obj.tsk = current,
 		};
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

