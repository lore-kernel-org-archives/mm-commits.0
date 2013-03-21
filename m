From: akpm@linux-foundation.org
Subject: + aio-use-flush_dcache_page.patch added to -mm tree
Date: Thu, 21 Mar 2013 15:38:06 -0700
Message-ID: <20130321223807.00F235A4286@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:33080 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3CUWiJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:38:09 -0400
Received: by mail-ve0-f201.google.com with SMTP id 14so310784vea.2
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:38:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com


The patch titled
     Subject: aio: use flush_dcache_page()
has been added to the -mm tree.  Its filename is
     aio-use-flush_dcache_page.patch

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
Subject: aio: use flush_dcache_page()

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

 fs/aio.c |   45 +++++++++++++++++----------------------------
 1 file changed, 17 insertions(+), 28 deletions(-)

diff -puN fs/aio.c~aio-use-flush_dcache_page fs/aio.c
--- a/fs/aio.c~aio-use-flush_dcache_page
+++ a/fs/aio.c
@@ -211,33 +211,15 @@ static int aio_setup_ring(struct kioctx
 	ring->incompat_features = AIO_RING_INCOMPAT_FEATURES;
 	ring->header_length = sizeof(struct aio_ring);
 	kunmap_atomic(ring);
+	flush_dcache_page(info->ring_pages[0]);
 
 	return 0;
 }
 
-
-/* aio_ring_event: returns a pointer to the event at the given index from
- * kmap_atomic().  Release the pointer with put_aio_ring_event();
- */
 #define AIO_EVENTS_PER_PAGE	(PAGE_SIZE / sizeof(struct io_event))
 #define AIO_EVENTS_FIRST_PAGE	((PAGE_SIZE - sizeof(struct aio_ring)) / sizeof(struct io_event))
 #define AIO_EVENTS_OFFSET	(AIO_EVENTS_PER_PAGE - AIO_EVENTS_FIRST_PAGE)
 
-#define aio_ring_event(info, nr) ({					\
-	unsigned pos = (nr) + AIO_EVENTS_OFFSET;			\
-	struct io_event *__event;					\
-	__event = kmap_atomic(						\
-			(info)->ring_pages[pos / AIO_EVENTS_PER_PAGE]); \
-	__event += pos % AIO_EVENTS_PER_PAGE;				\
-	__event;							\
-})
-
-#define put_aio_ring_event(event) do {		\
-	struct io_event *__event = (event);	\
-	(void)__event;				\
-	kunmap_atomic((void *)((unsigned long)__event & PAGE_MASK)); \
-} while(0)
-
 static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
 			struct io_event *res)
 {
@@ -648,9 +630,9 @@ void aio_complete(struct kiocb *iocb, lo
 	struct kioctx	*ctx = iocb->ki_ctx;
 	struct aio_ring_info	*info;
 	struct aio_ring	*ring;
-	struct io_event	*event;
+	struct io_event	*ev_page, *event;
 	unsigned long	flags;
-	unsigned long	tail;
+	unsigned tail, pos;
 
 	/*
 	 * Special case handling for sync iocbs:
@@ -689,19 +671,24 @@ void aio_complete(struct kiocb *iocb, lo
 	if (kiocbIsCancelled(iocb))
 		goto put_rq;
 
-	ring = kmap_atomic(info->ring_pages[0]);
-
 	tail = info->tail;
-	event = aio_ring_event(info, tail);
+	pos = tail + AIO_EVENTS_OFFSET;
+
 	if (++tail >= info->nr)
 		tail = 0;
 
+	ev_page = kmap_atomic(info->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
+	event = ev_page + pos % AIO_EVENTS_PER_PAGE;
+
 	event->obj = (u64)(unsigned long)iocb->ki_obj.user;
 	event->data = iocb->ki_user_data;
 	event->res = res;
 	event->res2 = res2;
 
-	pr_debug("%p[%lu]: %p: %p %Lx %lx %lx\n",
+	kunmap_atomic(ev_page);
+	flush_dcache_page(info->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
+
+	pr_debug("%p[%u]: %p: %p %Lx %lx %lx\n",
 		 ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
 		 res, res2);
 
@@ -711,12 +698,13 @@ void aio_complete(struct kiocb *iocb, lo
 	smp_wmb();	/* make event visible before updating tail */
 
 	info->tail = tail;
-	ring->tail = tail;
 
-	put_aio_ring_event(event);
+	ring = kmap_atomic(info->ring_pages[0]);
+	ring->tail = tail;
 	kunmap_atomic(ring);
+	flush_dcache_page(info->ring_pages[0]);
 
-	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
+	pr_debug("added to ring %p at [%u]\n", iocb, tail);
 
 	/*
 	 * Check if the user asked us to deliver the result through an
@@ -804,6 +792,7 @@ static long aio_read_events_ring(struct
 	ring = kmap_atomic(info->ring_pages[0]);
 	ring->head = head;
 	kunmap_atomic(ring);
+	flush_dcache_page(info->ring_pages[0]);
 
 	pr_debug("%li  h%u t%u\n", ret, head, info->tail);
 out:
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

