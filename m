From: akpm@linux-foundation.org
Subject: [to-be-updated] aio-kill-ki_key.patch removed from -mm tree
Date: Thu, 21 Mar 2013 15:29:02 -0700
Message-ID: <20130321222902.A2DF731C15E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:64439 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab3CUW3E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:29:04 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so310719qcr.4
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:29:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: kill ki_key
has been removed from the -mm tree.  Its filename was
     aio-kill-ki_key.patch

This patch was dropped because an updated version will be merged

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
@@ -1206,7 +1206,7 @@ static int io_submit_one(struct kioctx *
 		}
 	}
 
-	ret = put_user(req->ki_key, &user_iocb->aio_key);
+	ret = put_user(KIOCB_KEY, &user_iocb->aio_key);
 	if (unlikely(ret)) {
 		pr_debug("EFAULT: aio_key\n");
 		goto out_put_req;
@@ -1327,10 +1327,13 @@ static struct kiocb *lookup_kiocb(struct
 
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

aio-kill-ki_retry.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-aio_read_events_ring-types.patch
aio-document-clarify-aio_read_events-and-shadow_tail.patch
aio-correct-calculation-of-available-events.patch
aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
aio-fix-ringbuffer-calculation-so-we-dont-wrap.patch

