From: akpm@linux-foundation.org
Subject: + aio-use-xchg-instead-of-completion_lock.patch added to -mm tree
Date: Thu, 03 Jan 2013 15:41:13 -0800
Message-ID: <20130103234118.73DDF100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:49819 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab3ACXlU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jan 2013 18:41:20 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so1692776vcd.1
        for <mm-commits@vger.kernel.org>; Thu, 03 Jan 2013 15:41:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, viro@zeniv.linux.org.uk, zab@redhat.com


The patch titled
     Subject: aio: use xchg() instead of completion_lock
has been added to the -mm tree.  Its filename is
     aio-use-xchg-instead-of-completion_lock.patch

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
Subject: aio: use xchg() instead of completion_lock

So, for sticking kiocb completions on the kioctx ringbuffer, we need a
lock - it unfortunately can't be lockless.

When the kioctx is shared between threads on different cpus and the rate
of completions is high, this lock sees quite a bit of contention - in
terms of cacheline contention it's the hottest thing in the aio subsystem.

That means, with a regular spinlock, we're going to take a cache miss to
grab the lock, then another cache miss when we touch the data the lock
protects - if it's on the same cacheline as the lock, other cpus spinning
on the lock are going to be pulling it out from under us as we're using
it.

So, we use an old trick to get rid of this second forced cache miss - make
the data the lock protects be the lock itself, so we grab them both at
once.

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

 fs/aio.c |   44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff -puN fs/aio.c~aio-use-xchg-instead-of-completion_lock fs/aio.c
--- a/fs/aio.c~aio-use-xchg-instead-of-completion_lock
+++ a/fs/aio.c
@@ -102,11 +102,11 @@ struct kioctx {
 	struct {
 		struct mutex	ring_lock;
 		wait_queue_head_t wait;
+		unsigned	shadow_tail;
 	} ____cacheline_aligned_in_smp;
 
 	struct {
 		unsigned	tail;
-		spinlock_t	completion_lock;
 	} ____cacheline_aligned_in_smp;
 
 	struct page		*internal_pages[AIO_RING_PAGES];
@@ -308,9 +308,9 @@ static void free_ioctx(struct kioctx *ct
 	kunmap_atomic(ring);
 
 	while (atomic_read(&ctx->reqs_available) < ctx->nr) {
-		wait_event(ctx->wait, head != ctx->tail);
+		wait_event(ctx->wait, head != ctx->shadow_tail);
 
-		avail = (head < ctx->tail ? ctx->tail : ctx->nr) - head;
+		avail = (head < ctx->shadow_tail ? ctx->shadow_tail : ctx->nr) - head;
 
 		atomic_add(avail, &ctx->reqs_available);
 		head += avail;
@@ -375,7 +375,6 @@ static struct kioctx *ioctx_alloc(unsign
 	rcu_read_unlock();
 
 	spin_lock_init(&ctx->ctx_lock);
-	spin_lock_init(&ctx->completion_lock);
 	mutex_init(&ctx->ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
@@ -673,18 +672,19 @@ void aio_complete(struct kiocb *iocb, lo
 		 * free_ioctx()
 		 */
 		atomic_inc(&ctx->reqs_available);
+		smp_mb__after_atomic_inc();
 		/* Still need the wake_up in case free_ioctx is waiting */
 		goto put_rq;
 	}
 
 	/*
-	 * Add a completion event to the ring buffer. Must be done holding
-	 * ctx->ctx_lock to prevent other code from messing with the tail
-	 * pointer since we might be called from irq context.
+	 * Add a completion event to the ring buffer; ctx->tail is both our lock
+	 * and the canonical version of the tail pointer.
 	 */
-	spin_lock_irqsave(&ctx->completion_lock, flags);
+	local_irq_save(flags);
+	while ((tail = xchg(&ctx->tail, UINT_MAX)) == UINT_MAX)
+		cpu_relax();
 
-	tail = ctx->tail;
 	pos = tail + AIO_EVENTS_OFFSET;
 
 	if (++tail >= ctx->nr)
@@ -710,14 +710,18 @@ void aio_complete(struct kiocb *iocb, lo
 	 */
 	smp_wmb();	/* make event visible before updating tail */
 
-	ctx->tail = tail;
+	ctx->shadow_tail = tail;
 
 	ring = kmap_atomic(ctx->ring_pages[0]);
 	ring->tail = tail;
 	kunmap_atomic(ring);
 	flush_dcache_page(ctx->ring_pages[0]);
 
-	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	/* unlock, make new tail visible before checking waitlist */
+	smp_mb();
+
+	ctx->tail = tail;
+	local_irq_restore(flags);
 
 	pr_debug("added to ring %p at [%u]\n", iocb, tail);
 
@@ -733,14 +737,6 @@ put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	aio_put_req(iocb);
 
-	/*
-	 * We have to order our ring_info tail store above and test
-	 * of the wait list below outside the wait lock.  This is
-	 * like in wake_up_bit() where clearing a bit has to be
-	 * ordered with the unlocked test.
-	 */
-	smp_mb();
-
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 
@@ -768,19 +764,19 @@ static int aio_read_events_ring(struct k
 	head = ring->head;
 	kunmap_atomic(ring);
 
-	pr_debug("h%u t%u m%u\n", head, ctx->tail, ctx->nr);
+	pr_debug("h%u t%u m%u\n", head, ctx->shadow_tail, ctx->nr);
 
-	if (head == ctx->tail)
+	if (head == ctx->shadow_tail)
 		goto out;
 
 	__set_current_state(TASK_RUNNING);
 
 	while (ret < nr) {
-		unsigned i = (head < ctx->tail ? ctx->tail : ctx->nr) - head;
+		unsigned i = (head < ctx->shadow_tail ? ctx->shadow_tail : ctx->nr) - head;
 		struct io_event *ev;
 		struct page *page;
 
-		if (head == ctx->tail)
+		if (head == ctx->shadow_tail)
 			break;
 
 		i = min_t(int, i, nr - ret);
@@ -810,7 +806,7 @@ static int aio_read_events_ring(struct k
 	kunmap_atomic(ring);
 	flush_dcache_page(ctx->ring_pages[0]);
 
-	pr_debug("%d  h%u t%u\n", ret, head, ctx->tail);
+	pr_debug("%d  h%u t%u\n", ret, head, ctx->shadow_tail);
 
 	put_reqs_available(ctx, ret);
 out:
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

