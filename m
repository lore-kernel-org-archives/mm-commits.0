From: akpm@linux-foundation.org
Subject: + aio-smoosh-struct-kiocb.patch added to -mm tree
Date: Thu, 03 Jan 2013 15:42:02 -0800
Message-ID: <20130103234203.3B77D82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:45702 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab3ACXmF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jan 2013 18:42:05 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so1723403qaq.5
        for <mm-commits@vger.kernel.org>; Thu, 03 Jan 2013 15:42:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, viro@zeniv.linux.org.uk, zab@redhat.com


The patch titled
     Subject: aio: smoosh struct kiocb
has been added to the -mm tree.  Its filename is
     aio-smoosh-struct-kiocb.patch

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
Subject: aio: smoosh struct kiocb

This patch squishes struct kiocb down to 160 bytes, from 208 previously -
mainly, some of the fields aren't needed until after aio_complete() is
called.

Also, reorder the fields to reduce the amount of memory that has to be
zeroed in aio_get_req(), and to keep members next to each other that are
used in the same place.

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

 fs/aio.c            |   24 +++++++++-------
 include/linux/aio.h |   61 ++++++++++++++++++++++--------------------
 2 files changed, 47 insertions(+), 38 deletions(-)

diff -puN fs/aio.c~aio-smoosh-struct-kiocb fs/aio.c
--- a/fs/aio.c~aio-smoosh-struct-kiocb
+++ a/fs/aio.c
@@ -570,12 +570,13 @@ static inline struct kiocb *aio_get_req(
 	if (!get_reqs_available(ctx))
 		return NULL;
 
-	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
+	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL);
 	if (unlikely(!req))
 		goto out_put;
 
-	atomic_set(&req->ki_users, 1);
+	memset(req, 0, offsetof(struct kiocb, ki_ctx));
 	req->ki_ctx = ctx;
+	atomic_set(&req->ki_users, 1);
 	return req;
 out_put:
 	put_reqs_available(ctx, 1);
@@ -633,8 +634,8 @@ static inline unsigned kioctx_ring_put(s
 	ev_page = kmap_atomic(ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
 	event = ev_page + pos % AIO_EVENTS_PER_PAGE;
 
-	event->obj	= (u64) req->ki_obj.user;
 	event->data	= req->ki_user_data;
+	event->obj	= (u64) req->ki_obj.user;
 	event->res	= req->ki_res;
 	event->res2	= req->ki_res2;
 
@@ -1245,13 +1246,16 @@ static int io_submit_one(struct kioctx *
 		goto out_put_req;
 	}
 
-	req->ki_obj.user = user_iocb;
-	req->ki_user_data = iocb->aio_data;
-	req->ki_pos = iocb->aio_offset;
-
-	req->ki_buf = (char __user *)(unsigned long)iocb->aio_buf;
-	req->ki_left = req->ki_nbytes = iocb->aio_nbytes;
-	req->ki_opcode = iocb->aio_lio_opcode;
+	req->ki_user_data	= iocb->aio_data;
+	req->ki_obj.user	= user_iocb;
+
+	req->ki_opcode		= iocb->aio_lio_opcode;
+	req->ki_pos		= iocb->aio_offset;
+	req->ki_nbytes		= iocb->aio_nbytes;
+	req->ki_left		= iocb->aio_nbytes;
+	req->ki_buf		= (char __user *) iocb->aio_buf;
+	req->ki_nr_segs		= 0;
+	req->ki_cur_seg		= 0;
 
 	ret = aio_run_iocb(req, compat);
 	if (ret)
diff -puN include/linux/aio.h~aio-smoosh-struct-kiocb include/linux/aio.h
--- a/include/linux/aio.h~aio-smoosh-struct-kiocb
+++ a/include/linux/aio.h
@@ -20,45 +20,50 @@ struct batch_complete;
 typedef int (kiocb_cancel_fn)(struct kiocb *, struct io_event *);
 
 struct kiocb {
-	struct rb_node		ki_node;
+	struct list_head	ki_list;	/* the aio core uses this
+						 * for cancellation */
+	kiocb_cancel_fn		*ki_cancel;
+	void			(*ki_dtor)(struct kiocb *);
+	void			*private;
+	struct iovec		*ki_iovec;
+
+	/*
+	 * If the aio_resfd field of the userspace iocb is not zero,
+	 * this is the underlying eventfd context to deliver events to.
+	 */
+	struct eventfd_ctx	*ki_eventfd;
+	struct kioctx		*ki_ctx;	/* NULL for sync ops */
+	struct file		*ki_filp;
 
 	atomic_t		ki_users;
 
-	struct file		*ki_filp;
-	struct kioctx		*ki_ctx;	/* NULL for sync ops */
-	kiocb_cancel_fn		*ki_cancel;
-	void			(*ki_dtor)(struct kiocb *);
+	/* State that we remember to be able to restart/retry  */
+	unsigned		ki_opcode;
 
+	__u64			ki_user_data;	/* user's data for completion */
 	union {
 		void __user		*user;
 		struct task_struct	*tsk;
 	} ki_obj;
 
-	__u64			ki_user_data;	/* user's data for completion */
-	long			ki_res;
-	long			ki_res2;
-
-	loff_t			ki_pos;
+	union {
+	struct {
+		loff_t		ki_pos;
+		size_t		ki_nbytes;	/* copy of iocb->aio_nbytes */
+		size_t		ki_left;	/* remaining bytes */
+		char __user	*ki_buf;	/* remaining iocb->aio_buf */
+		unsigned long	ki_nr_segs;
+		unsigned long	ki_cur_seg;
+	};
+
+	struct {
+		long		ki_res;
+		long		ki_res2;
+		struct rb_node	ki_node;
+	};
+	};
 
-	void			*private;
-	/* State that we remember to be able to restart/retry  */
-	unsigned short		ki_opcode;
-	size_t			ki_nbytes; 	/* copy of iocb->aio_nbytes */
-	char 			__user *ki_buf;	/* remaining iocb->aio_buf */
-	size_t			ki_left; 	/* remaining bytes */
 	struct iovec		ki_inline_vec;	/* inline vector */
- 	struct iovec		*ki_iovec;
- 	unsigned long		ki_nr_segs;
- 	unsigned long		ki_cur_seg;
-
-	struct list_head	ki_list;	/* the aio core uses this
-						 * for cancellation */
-
-	/*
-	 * If the aio_resfd field of the userspace iocb is not zero,
-	 * this is the underlying eventfd context to deliver events to.
-	 */
-	struct eventfd_ctx	*ki_eventfd;
 };
 
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
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

