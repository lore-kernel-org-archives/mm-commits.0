From: akpm@linux-foundation.org
Subject: + aio-kill-struct-aio_ring_info.patch added to -mm tree
Date: Thu, 21 Mar 2013 15:38:18 -0700
Message-ID: <20130321223819.04CC65A4286@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:32785 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab3CUWiV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:38:21 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so23103qcs.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:38:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com


The patch titled
     Subject: aio: kill struct aio_ring_info
has been added to the -mm tree.  Its filename is
     aio-kill-struct-aio_ring_info.patch

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
Subject: aio: kill struct aio_ring_info

struct aio_ring_info was kind of odd, the only place it's used is where
it's embedded in struct kioctx - there's no real need for it.

The next patch rearranges struct kioctx and puts various things on their
own cachelines - getting rid of struct aio_ring_info now makes that
reordering a bit clearer.

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

 fs/aio.c |  156 +++++++++++++++++++++++++----------------------------
 1 file changed, 75 insertions(+), 81 deletions(-)

diff -puN fs/aio.c~aio-kill-struct-aio_ring_info fs/aio.c
--- a/fs/aio.c~aio-kill-struct-aio_ring_info
+++ a/fs/aio.c
@@ -58,18 +58,6 @@ struct aio_ring {
 }; /* 128 bytes + ring size */
 
 #define AIO_RING_PAGES	8
-struct aio_ring_info {
-	unsigned long		mmap_base;
-	unsigned long		mmap_size;
-
-	struct page		**ring_pages;
-	struct mutex		ring_lock;
-	long			nr_pages;
-
-	unsigned		nr, tail;
-
-	struct page		*internal_pages[AIO_RING_PAGES];
-};
 
 struct kioctx {
 	atomic_t		users;
@@ -90,14 +78,30 @@ struct kioctx {
 	 * This is what userspace passed to io_setup(), it's not used for
 	 * anything but counting against the global max_reqs quota.
 	 *
-	 * The real limit is ring->nr - 1, which will be larger (see
+	 * The real limit is nr_events - 1, which will be larger (see
 	 * aio_setup_ring())
 	 */
 	unsigned		max_reqs;
 
-	struct aio_ring_info	ring_info;
+	/* Size of ringbuffer, in units of struct io_event */
+	unsigned		nr_events;
+
+	unsigned long		mmap_base;
+	unsigned long		mmap_size;
+
+	struct page		**ring_pages;
+	long			nr_pages;
 
-	spinlock_t		completion_lock;
+	struct {
+		struct mutex	ring_lock;
+	} ____cacheline_aligned;
+
+	struct {
+		unsigned	tail;
+		spinlock_t	completion_lock;
+	} ____cacheline_aligned;
+
+	struct page		*internal_pages[AIO_RING_PAGES];
 
 	struct rcu_head		rcu_head;
 	struct work_struct	rcu_work;
@@ -129,26 +133,21 @@ __initcall(aio_setup);
 
 static void aio_free_ring(struct kioctx *ctx)
 {
-	struct aio_ring_info *info = &ctx->ring_info;
 	long i;
 
-	for (i=0; i<info->nr_pages; i++)
-		put_page(info->ring_pages[i]);
+	for (i = 0; i < ctx->nr_pages; i++)
+		put_page(ctx->ring_pages[i]);
 
-	if (info->mmap_size) {
-		vm_munmap(info->mmap_base, info->mmap_size);
-	}
+	if (ctx->mmap_size)
+		vm_munmap(ctx->mmap_base, ctx->mmap_size);
 
-	if (info->ring_pages && info->ring_pages != info->internal_pages)
-		kfree(info->ring_pages);
-	info->ring_pages = NULL;
-	info->nr = 0;
+	if (ctx->ring_pages && ctx->ring_pages != ctx->internal_pages)
+		kfree(ctx->ring_pages);
 }
 
 static int aio_setup_ring(struct kioctx *ctx)
 {
 	struct aio_ring *ring;
-	struct aio_ring_info *info = &ctx->ring_info;
 	unsigned nr_events = ctx->max_reqs;
 	struct mm_struct *mm = current->mm;
 	unsigned long size, populate;
@@ -166,45 +165,44 @@ static int aio_setup_ring(struct kioctx
 
 	nr_events = (PAGE_SIZE * nr_pages - sizeof(struct aio_ring)) / sizeof(struct io_event);
 
-	info->nr = 0;
-	info->ring_pages = info->internal_pages;
+	ctx->nr_events = 0;
+	ctx->ring_pages = ctx->internal_pages;
 	if (nr_pages > AIO_RING_PAGES) {
-		info->ring_pages = kcalloc(nr_pages, sizeof(struct page *), GFP_KERNEL);
-		if (!info->ring_pages)
+		ctx->ring_pages = kcalloc(nr_pages, sizeof(struct page *),
+					  GFP_KERNEL);
+		if (!ctx->ring_pages)
 			return -ENOMEM;
 	}
 
-	info->mmap_size = nr_pages * PAGE_SIZE;
-	pr_debug("attempting mmap of %lu bytes\n", info->mmap_size);
+	ctx->mmap_size = nr_pages * PAGE_SIZE;
+	pr_debug("attempting mmap of %lu bytes\n", ctx->mmap_size);
 	down_write(&mm->mmap_sem);
-	info->mmap_base = do_mmap_pgoff(NULL, 0, info->mmap_size, 
-					PROT_READ|PROT_WRITE,
-					MAP_ANONYMOUS|MAP_PRIVATE, 0,
-					&populate);
-	if (IS_ERR((void *)info->mmap_base)) {
+	ctx->mmap_base = do_mmap_pgoff(NULL, 0, ctx->mmap_size,
+				       PROT_READ|PROT_WRITE,
+				       MAP_ANONYMOUS|MAP_PRIVATE, 0, &populate);
+	if (IS_ERR((void *)ctx->mmap_base)) {
 		up_write(&mm->mmap_sem);
-		info->mmap_size = 0;
+		ctx->mmap_size = 0;
 		aio_free_ring(ctx);
 		return -EAGAIN;
 	}
 
-	pr_debug("mmap address: 0x%08lx\n", info->mmap_base);
-	info->nr_pages = get_user_pages(current, mm, info->mmap_base, nr_pages,
-					1, 0, info->ring_pages, NULL);
+	pr_debug("mmap address: 0x%08lx\n", ctx->mmap_base);
+	ctx->nr_pages = get_user_pages(current, mm, ctx->mmap_base, nr_pages,
+				       1, 0, ctx->ring_pages, NULL);
 	up_write(&mm->mmap_sem);
 
-	if (unlikely(info->nr_pages != nr_pages)) {
+	if (unlikely(ctx->nr_pages != nr_pages)) {
 		aio_free_ring(ctx);
 		return -EAGAIN;
 	}
 	if (populate)
-		mm_populate(info->mmap_base, populate);
+		mm_populate(ctx->mmap_base, populate);
 
-	ctx->user_id = info->mmap_base;
+	ctx->user_id = ctx->mmap_base;
+	ctx->nr_events = nr_events; /* trusted copy */
 
-	info->nr = nr_events;		/* trusted copy */
-
-	ring = kmap_atomic(info->ring_pages[0]);
+	ring = kmap_atomic(ctx->ring_pages[0]);
 	ring->nr = nr_events;	/* user copy */
 	ring->id = ctx->user_id;
 	ring->head = ring->tail = 0;
@@ -213,7 +211,7 @@ static int aio_setup_ring(struct kioctx
 	ring->incompat_features = AIO_RING_INCOMPAT_FEATURES;
 	ring->header_length = sizeof(struct aio_ring);
 	kunmap_atomic(ring);
-	flush_dcache_page(info->ring_pages[0]);
+	flush_dcache_page(ctx->ring_pages[0]);
 
 	return 0;
 }
@@ -284,7 +282,6 @@ static void free_ioctx_rcu(struct rcu_he
  */
 static void free_ioctx(struct kioctx *ctx)
 {
-	struct aio_ring_info *info = &ctx->ring_info;
 	struct aio_ring *ring;
 	struct io_event res;
 	struct kiocb *req;
@@ -302,18 +299,18 @@ static void free_ioctx(struct kioctx *ct
 
 	spin_unlock_irq(&ctx->ctx_lock);
 
-	ring = kmap_atomic(info->ring_pages[0]);
+	ring = kmap_atomic(ctx->ring_pages[0]);
 	head = ring->head;
 	kunmap_atomic(ring);
 
 	while (atomic_read(&ctx->reqs_active) > 0) {
-		wait_event(ctx->wait, head != info->tail);
+		wait_event(ctx->wait, head != ctx->tail);
 
-		avail = (head <= info->tail ? info->tail : info->nr) - head;
+		avail = (head <= ctx->tail ? ctx->tail : ctx->nr_events) - head;
 
 		atomic_sub(avail, &ctx->reqs_active);
 		head += avail;
-		head %= info->nr;
+		head %= ctx->nr_events;
 	}
 
 	WARN_ON(atomic_read(&ctx->reqs_active) < 0);
@@ -372,7 +369,7 @@ static struct kioctx *ioctx_alloc(unsign
 	atomic_set(&ctx->dead, 0);
 	spin_lock_init(&ctx->ctx_lock);
 	spin_lock_init(&ctx->completion_lock);
-	mutex_init(&ctx->ring_info.ring_lock);
+	mutex_init(&ctx->ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
 	INIT_LIST_HEAD(&ctx->active_reqs);
@@ -396,7 +393,7 @@ static struct kioctx *ioctx_alloc(unsign
 	spin_unlock(&mm->ioctx_lock);
 
 	pr_debug("allocated ioctx %p[%ld]: mm=%p mask=0x%x\n",
-		ctx, ctx->user_id, mm, ctx->ring_info.nr);
+		 ctx, ctx->user_id, mm, ctx->nr_events);
 	return ctx;
 
 out_cleanup:
@@ -491,7 +488,7 @@ void exit_aio(struct mm_struct *mm)
 		 * just set it to 0; aio_free_ring() is the only
 		 * place that uses ->mmap_size, so it's safe.
 		 */
-		ctx->ring_info.mmap_size = 0;
+		ctx->mmap_size = 0;
 
 		if (!atomic_xchg(&ctx->dead, 1)) {
 			hlist_del_rcu(&ctx->list);
@@ -514,10 +511,10 @@ static inline struct kiocb *aio_get_req(
 {
 	struct kiocb *req;
 
-	if (atomic_read(&ctx->reqs_active) >= ctx->ring_info.nr)
+	if (atomic_read(&ctx->reqs_active) >= ctx->nr_events)
 		return NULL;
 
-	if (atomic_inc_return(&ctx->reqs_active) > ctx->ring_info.nr - 1)
+	if (atomic_inc_return(&ctx->reqs_active) > ctx->nr_events - 1)
 		goto out_put;
 
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
@@ -578,7 +575,6 @@ static struct kioctx *lookup_ioctx(unsig
 void aio_complete(struct kiocb *iocb, long res, long res2)
 {
 	struct kioctx	*ctx = iocb->ki_ctx;
-	struct aio_ring_info	*info;
 	struct aio_ring	*ring;
 	struct io_event	*ev_page, *event;
 	unsigned long	flags;
@@ -599,8 +595,6 @@ void aio_complete(struct kiocb *iocb, lo
 		return;
 	}
 
-	info = &ctx->ring_info;
-
 	/*
 	 * Take rcu_read_lock() in case the kioctx is being destroyed, as we
 	 * need to issue a wakeup after decrementing reqs_active.
@@ -633,13 +627,13 @@ void aio_complete(struct kiocb *iocb, lo
 	 */
 	spin_lock_irqsave(&ctx->completion_lock, flags);
 
-	tail = info->tail;
+	tail = ctx->tail;
 	pos = tail + AIO_EVENTS_OFFSET;
 
-	if (++tail >= info->nr)
+	if (++tail >= ctx->nr_events)
 		tail = 0;
 
-	ev_page = kmap_atomic(info->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
+	ev_page = kmap_atomic(ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
 	event = ev_page + pos % AIO_EVENTS_PER_PAGE;
 
 	event->obj = (u64)(unsigned long)iocb->ki_obj.user;
@@ -648,7 +642,7 @@ void aio_complete(struct kiocb *iocb, lo
 	event->res2 = res2;
 
 	kunmap_atomic(ev_page);
-	flush_dcache_page(info->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
+	flush_dcache_page(ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
 
 	pr_debug("%p[%u]: %p: %p %Lx %lx %lx\n",
 		 ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
@@ -659,12 +653,12 @@ void aio_complete(struct kiocb *iocb, lo
 	 */
 	smp_wmb();	/* make event visible before updating tail */
 
-	info->tail = tail;
+	ctx->tail = tail;
 
-	ring = kmap_atomic(info->ring_pages[0]);
+	ring = kmap_atomic(ctx->ring_pages[0]);
 	ring->tail = tail;
 	kunmap_atomic(ring);
-	flush_dcache_page(info->ring_pages[0]);
+	flush_dcache_page(ctx->ring_pages[0]);
 
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
@@ -704,29 +698,29 @@ EXPORT_SYMBOL(aio_complete);
 static long aio_read_events_ring(struct kioctx *ctx,
 				 struct io_event __user *event, long nr)
 {
-	struct aio_ring_info *info = &ctx->ring_info;
 	struct aio_ring *ring;
 	unsigned head, pos;
 	long ret = 0;
 	int copy_ret;
 
-	mutex_lock(&info->ring_lock);
+	mutex_lock(&ctx->ring_lock);
 
-	ring = kmap_atomic(info->ring_pages[0]);
+	ring = kmap_atomic(ctx->ring_pages[0]);
 	head = ring->head;
 	kunmap_atomic(ring);
 
-	pr_debug("h%u t%u m%u\n", head, info->tail, info->nr);
+	pr_debug("h%u t%u m%u\n", head, ctx->tail, ctx->nr_events);
 
-	if (head == info->tail)
+	if (head == ctx->tail)
 		goto out;
 
 	while (ret < nr) {
-		long avail = (head <= info->tail ? info->tail : info->nr) - head;
+		long avail = (head <= ctx->tail
+			      ? ctx->tail : ctx->nr_events) - head;
 		struct io_event *ev;
 		struct page *page;
 
-		if (head == info->tail)
+		if (head == ctx->tail)
 			break;
 
 		avail = min(avail, nr - ret);
@@ -734,7 +728,7 @@ static long aio_read_events_ring(struct
 			      ((head + AIO_EVENTS_OFFSET) % AIO_EVENTS_PER_PAGE));
 
 		pos = head + AIO_EVENTS_OFFSET;
-		page = info->ring_pages[pos / AIO_EVENTS_PER_PAGE];
+		page = ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE];
 		pos %= AIO_EVENTS_PER_PAGE;
 
 		ev = kmap(page);
@@ -748,19 +742,19 @@ static long aio_read_events_ring(struct
 
 		ret += avail;
 		head += avail;
-		head %= info->nr;
+		head %= ctx->nr_events;
 	}
 
-	ring = kmap_atomic(info->ring_pages[0]);
+	ring = kmap_atomic(ctx->ring_pages[0]);
 	ring->head = head;
 	kunmap_atomic(ring);
-	flush_dcache_page(info->ring_pages[0]);
+	flush_dcache_page(ctx->ring_pages[0]);
 
-	pr_debug("%li  h%u t%u\n", ret, head, info->tail);
+	pr_debug("%li  h%u t%u\n", ret, head, ctx->tail);
 
 	atomic_sub(ret, &ctx->reqs_active);
 out:
-	mutex_unlock(&info->ring_lock);
+	mutex_unlock(&ctx->ring_lock);
 
 	return ret;
 }
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

