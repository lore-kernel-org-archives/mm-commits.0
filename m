From: akpm@linux-foundation.org
Subject: [merged] aio-use-flush_dcache_page.patch removed from -mm tree
Date: Wed, 08 May 2013 11:35:31 -0700
Message-ID: <20130508183531.E3B705A415E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:41783 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176Ab3EHSfd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:35:33 -0400
Received: by mail-ye0-f201.google.com with SMTP id m14so207796yen.2
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:35:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: use flush_dcache_page()
has been removed from the -mm tree.  Its filename was
     aio-use-flush_dcache_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio: use flush_dcache_page()

This wasn't causing problems before because it's not needed on x86, but it
is needed on other architectures.

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
@@ -649,9 +631,9 @@ void aio_complete(struct kiocb *iocb, lo
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
@@ -690,19 +672,24 @@ void aio_complete(struct kiocb *iocb, lo
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
 
@@ -712,12 +699,13 @@ void aio_complete(struct kiocb *iocb, lo
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
@@ -807,6 +795,7 @@ static long aio_read_events_ring(struct
 	ring = kmap_atomic(info->ring_pages[0]);
 	ring->head = head;
 	kunmap_atomic(ring);
+	flush_dcache_page(info->ring_pages[0]);
 
 	pr_debug("%li  h%u t%u\n", ret, head, info->tail);
 out:
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

