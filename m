From: akpm@linux-foundation.org
Subject: + aio-fix-ringbuffer-calculation-so-we-dont-wrap.patch added to -mm tree
Date: Mon, 18 Mar 2013 14:18:42 -0700
Message-ID: <20130318211842.821CB31C26E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:47192 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab3CRVSn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Mar 2013 17:18:43 -0400
Received: by mail-ye0-f201.google.com with SMTP id m12so620433yen.2
        for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2013 14:18:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, bcrl@kvack.org, jwboyer@redhat.com, tytso@mit.edu, zab@redhat.com


The patch titled
     Subject: aio: fix ringbuffer calculation so we don't wrap
has been added to the -mm tree.  Its filename is
     aio-fix-ringbuffer-calculation-so-we-dont-wrap.patch

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
Subject: aio: fix ringbuffer calculation so we don't wrap

When calculating the size of the ringbuffer, aio_setup_ring() adds 2 to
nr_events so that the head and tail entries don't overlap when the
ringbuffer fills up.

But then later the code uses the calculated ringbuffer size for the
maximum number of outstanding kiocbs, so this buffer doesn't actually get
used.  Ouch.

Fix it so the ringbuffer size and maximum number of requests are distinct
again, and document things while we're at it.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Zach Brown <zab@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   69 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 23 deletions(-)

diff -puN fs/aio.c~aio-fix-ringbuffer-calculation-so-we-dont-wrap fs/aio.c
--- a/fs/aio.c~aio-fix-ringbuffer-calculation-so-we-dont-wrap
+++ a/fs/aio.c
@@ -75,13 +75,21 @@ struct kioctx {
 
 	struct __percpu kioctx_cpu *cpu;
 
-	unsigned		req_batch;
-
-	unsigned		nr;
+	/* Size of ringbuffer, in units of struct io_event */
+	unsigned		nr_events;
 
-	/* sys_io_setup currently limits this to an unsigned int */
+	/*
+	 * Maximum number of outstanding requests:
+	 * sys_io_setup currently limits this to an unsigned int
+	 */
 	unsigned		max_reqs;
 
+	/*
+	 * For percpu reqs_available, number of slots we move to/from global
+	 * counter at a time:
+	 */
+	unsigned		req_batch;
+
 	unsigned long		mmap_base;
 	unsigned long		mmap_size;
 
@@ -92,6 +100,14 @@ struct kioctx {
 	struct work_struct	rcu_work;
 
 	struct {
+		/*
+		 * This counts the number of available slots in the ringbuffer,
+		 * so we avoid overflowing it: it's decremented (if positive)
+		 * when allocating a kiocb and incremented when the resulting
+		 * io_event is pulled off the ringbuffer.
+		 *
+		 * We batch accesses to it with a percpu version.
+		 */
 		atomic_t	reqs_available;
 	} ____cacheline_aligned_in_smp;
 
@@ -172,9 +188,6 @@ static int aio_setup_ring(struct kioctx
 	unsigned long size, populate;
 	int nr_pages;
 
-	nr_events = max(nr_events, num_possible_cpus() * 4);
-	nr_events *= 2;
-
 	/* Compensate for the ring buffer's head/tail overlap entry */
 	nr_events += 2;	/* 1 is required, 2 for good luck */
 
@@ -187,7 +200,7 @@ static int aio_setup_ring(struct kioctx
 
 	nr_events = (PAGE_SIZE * nr_pages - sizeof(struct aio_ring)) / sizeof(struct io_event);
 
-	ctx->nr = 0;
+	ctx->nr_events = 0;
 	ctx->ring_pages = ctx->internal_pages;
 	if (nr_pages > AIO_RING_PAGES) {
 		ctx->ring_pages = kcalloc(nr_pages, sizeof(struct page *),
@@ -222,7 +235,7 @@ static int aio_setup_ring(struct kioctx
 		mm_populate(ctx->mmap_base, populate);
 
 	ctx->user_id = ctx->mmap_base;
-	ctx->nr = nr_events;		/* trusted copy */
+	ctx->nr_events = nr_events; /* trusted copy */
 
 	ring = kmap_atomic(ctx->ring_pages[0]);
 	ring->nr = nr_events;	/* user copy */
@@ -334,20 +347,20 @@ static void free_ioctx(struct kioctx *ct
 	head = ring->head;
 	kunmap_atomic(ring);
 
-	while (atomic_read(&ctx->reqs_available) < ctx->nr) {
+	while (atomic_read(&ctx->reqs_available) < ctx->max_reqs) {
 		wait_event(ctx->wait,
 			   (head != ctx->shadow_tail) ||
-			   (atomic_read(&ctx->reqs_available) >= ctx->nr));
+			   (atomic_read(&ctx->reqs_available) >= ctx->max_reqs));
 
 		avail = (head <= ctx->shadow_tail ?
-			 ctx->shadow_tail : ctx->nr) - head;
+			 ctx->shadow_tail : ctx->nr_events) - head;
 
 		atomic_add(avail, &ctx->reqs_available);
 		head += avail;
-		head %= ctx->nr;
+		head %= ctx->nr_events;
 	}
 
-	WARN_ON(atomic_read(&ctx->reqs_available) > ctx->nr);
+	WARN_ON(atomic_read(&ctx->reqs_available) > ctx->max_reqs);
 
 	aio_free_ring(ctx);
 
@@ -383,6 +396,18 @@ static struct kioctx *ioctx_alloc(unsign
 	struct kioctx *ctx;
 	int err = -ENOMEM;
 
+	/*
+	 * We keep track of the number of available ringbuffer slots, to prevent
+	 * overflow (reqs_available), and we also use percpu counters for this.
+	 *
+	 * So since up to half the slots might be on other cpu's percpu counters
+	 * and unavailable, double nr_events so userspace sees what they
+	 * expected: additionally, we move req_batch slots to/from percpu
+	 * counters at a time, so make sure that isn't 0:
+	 */
+	nr_events = max(nr_events, num_possible_cpus() * 4);
+	nr_events *= 2;
+
 	/* Prevent overflows */
 	if ((nr_events > (0x10000000U / sizeof(struct io_event))) ||
 	    (nr_events > (0x10000000U / sizeof(struct kiocb)))) {
@@ -398,6 +423,8 @@ static struct kioctx *ioctx_alloc(unsign
 		return ERR_PTR(-ENOMEM);
 
 	ctx->max_reqs = nr_events;
+	atomic_set(&ctx->reqs_available, nr_events);
+	ctx->req_batch = nr_events / (num_possible_cpus() * 4);
 
 	percpu_ref_init(&ctx->users);
 	rcu_read_lock();
@@ -417,10 +444,6 @@ static struct kioctx *ioctx_alloc(unsign
 	if (aio_setup_ring(ctx) < 0)
 		goto out_freepcpu;
 
-	atomic_set(&ctx->reqs_available, ctx->nr);
-	ctx->req_batch = ctx->nr / (num_possible_cpus() * 4);
-	BUG_ON(!ctx->req_batch);
-
 	/* limit the number of system wide aios */
 	spin_lock(&aio_nr_lock);
 	if (aio_nr + nr_events > aio_max_nr ||
@@ -437,7 +460,7 @@ static struct kioctx *ioctx_alloc(unsign
 	spin_unlock(&mm->ioctx_lock);
 
 	pr_debug("allocated ioctx %p[%ld]: mm=%p mask=0x%x\n",
-		 ctx, ctx->user_id, mm, ctx->nr);
+		 ctx, ctx->user_id, mm, ctx->nr_events);
 	return ctx;
 
 out_cleanup:
@@ -657,7 +680,7 @@ static inline unsigned kioctx_ring_put(s
 	struct io_event	*ev_page, *event;
 	unsigned pos = tail + AIO_EVENTS_OFFSET;
 
-	if (++tail >= ctx->nr)
+	if (++tail >= ctx->nr_events)
 		tail = 0;
 
 	ev_page = kmap_atomic(ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
@@ -871,14 +894,14 @@ static long aio_read_events_ring(struct
 	head = ring->head;
 	kunmap_atomic(ring);
 
-	pr_debug("h%u t%u m%u\n", head, ctx->shadow_tail, ctx->nr);
+	pr_debug("h%u t%u m%u\n", head, ctx->shadow_tail, ctx->nr_events);
 
 	if (head == ctx->shadow_tail)
 		goto out;
 
 	while (ret < nr) {
 		long avail = (head <= ctx->shadow_tail
-			      ? ctx->shadow_tail : ctx->nr) - head;
+			      ? ctx->shadow_tail : ctx->nr_events) - head;
 		struct io_event *ev;
 		struct page *page;
 
@@ -904,7 +927,7 @@ static long aio_read_events_ring(struct
 
 		ret += avail;
 		head += avail;
-		head %= ctx->nr;
+		head %= ctx->nr_events;
 	}
 
 	ring = kmap_atomic(ctx->ring_pages[0]);
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
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-aio_read_events_ring-types.patch
aio-document-clarify-aio_read_events-and-shadow_tail.patch
aio-correct-calculation-of-available-events.patch
aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
aio-fix-ringbuffer-calculation-so-we-dont-wrap.patch

