From: akpm@linux-foundation.org
Subject: [to-be-updated] aio-kill-struct-aio_ring_info.patch removed from -mm tree
Date: Thu, 21 Mar 2013 15:28:31 -0700
Message-ID: <20130321222831.AA22831C26C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:40506 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab3CUW2d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:28:33 -0400
Received: by mail-vc0-f201.google.com with SMTP id hf12so310702vcb.0
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:28:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: kill struct aio_ring_info
has been removed from the -mm tree.  Its filename was
     aio-kill-struct-aio_ring_info.patch

This patch was dropped because an updated version will be merged

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

 fs/aio.c |  154 +++++++++++++++++++++++++----------------------------
 1 file changed, 73 insertions(+), 81 deletions(-)

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
@@ -86,12 +74,27 @@ struct kioctx {
 	atomic_t		reqs_active;
 	struct list_head	active_reqs;	/* used for cancellation */
 
+	unsigned		nr;
+
 	/* sys_io_setup currently limits this to an unsigned int */
 	unsigned		max_reqs;
 
-	struct aio_ring_info	ring_info;
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
@@ -123,26 +126,21 @@ __initcall(aio_setup);
 
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
@@ -160,45 +158,44 @@ static int aio_setup_ring(struct kioctx
 
 	nr_events = (PAGE_SIZE * nr_pages - sizeof(struct aio_ring)) / sizeof(struct io_event);
 
-	info->nr = 0;
-	info->ring_pages = info->internal_pages;
+	ctx->nr = 0;
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
+	ctx->nr = nr_events;		/* trusted copy */
 
-	info->nr = nr_events;		/* trusted copy */
-
-	ring = kmap_atomic(info->ring_pages[0]);
+	ring = kmap_atomic(ctx->ring_pages[0]);
 	ring->nr = nr_events;	/* user copy */
 	ring->id = ctx->user_id;
 	ring->head = ring->tail = 0;
@@ -207,7 +204,7 @@ static int aio_setup_ring(struct kioctx
 	ring->incompat_features = AIO_RING_INCOMPAT_FEATURES;
 	ring->header_length = sizeof(struct aio_ring);
 	kunmap_atomic(ring);
-	flush_dcache_page(info->ring_pages[0]);
+	flush_dcache_page(ctx->ring_pages[0]);
 
 	return 0;
 }
@@ -278,7 +275,6 @@ static void free_ioctx_rcu(struct rcu_he
  */
 static void free_ioctx(struct kioctx *ctx)
 {
-	struct aio_ring_info *info = &ctx->ring_info;
 	struct aio_ring *ring;
 	struct io_event res;
 	struct kiocb *req;
@@ -296,18 +292,18 @@ static void free_ioctx(struct kioctx *ct
 
 	spin_unlock_irq(&ctx->ctx_lock);
 
-	ring = kmap_atomic(info->ring_pages[0]);
+	ring = kmap_atomic(ctx->ring_pages[0]);
 	head = ring->head;
 	kunmap_atomic(ring);
 
 	while (atomic_read(&ctx->reqs_active) > 0) {
-		wait_event(ctx->wait, head != info->tail);
+		wait_event(ctx->wait, head != ctx->tail);
 
-		avail = (head < info->tail ? info->tail : info->nr) - head;
+		avail = (head < ctx->tail ? ctx->tail : ctx->nr) - head;
 
 		atomic_sub(avail, &ctx->reqs_active);
 		head += avail;
-		head %= info->nr;
+		head %= ctx->nr;
 	}
 
 	WARN_ON(atomic_read(&ctx->reqs_active) < 0);
@@ -366,7 +362,7 @@ static struct kioctx *ioctx_alloc(unsign
 	atomic_set(&ctx->dead, 0);
 	spin_lock_init(&ctx->ctx_lock);
 	spin_lock_init(&ctx->completion_lock);
-	mutex_init(&ctx->ring_info.ring_lock);
+	mutex_init(&ctx->ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
 	INIT_LIST_HEAD(&ctx->active_reqs);
@@ -390,7 +386,7 @@ static struct kioctx *ioctx_alloc(unsign
 	spin_unlock(&mm->ioctx_lock);
 
 	pr_debug("allocated ioctx %p[%ld]: mm=%p mask=0x%x\n",
-		ctx, ctx->user_id, mm, ctx->ring_info.nr);
+		 ctx, ctx->user_id, mm, ctx->nr);
 	return ctx;
 
 out_cleanup:
@@ -485,7 +481,7 @@ void exit_aio(struct mm_struct *mm)
 		 * just set it to 0; aio_free_ring() is the only
 		 * place that uses ->mmap_size, so it's safe.
 		 */
-		ctx->ring_info.mmap_size = 0;
+		ctx->mmap_size = 0;
 
 		if (!atomic_xchg(&ctx->dead, 1)) {
 			hlist_del_rcu(&ctx->list);
@@ -508,10 +504,10 @@ static inline struct kiocb *aio_get_req(
 {
 	struct kiocb *req;
 
-	if (atomic_read(&ctx->reqs_active) >= ctx->ring_info.nr)
+	if (atomic_read(&ctx->reqs_active) >= ctx->nr)
 		return NULL;
 
-	if (atomic_inc_return(&ctx->reqs_active) > ctx->ring_info.nr)
+	if (atomic_inc_return(&ctx->reqs_active) > ctx->nr)
 		goto out_put;
 
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
@@ -572,7 +568,6 @@ static struct kioctx *lookup_ioctx(unsig
 void aio_complete(struct kiocb *iocb, long res, long res2)
 {
 	struct kioctx	*ctx = iocb->ki_ctx;
-	struct aio_ring_info	*info;
 	struct aio_ring	*ring;
 	struct io_event	*ev_page, *event;
 	unsigned long	flags;
@@ -593,8 +588,6 @@ void aio_complete(struct kiocb *iocb, lo
 		return;
 	}
 
-	info = &ctx->ring_info;
-
 	/*
 	 * Take rcu_read_lock() in case the kioctx is being destroyed, as we
 	 * need to issue a wakeup after decrementing reqs_active.
@@ -627,13 +620,13 @@ void aio_complete(struct kiocb *iocb, lo
 	 */
 	spin_lock_irqsave(&ctx->completion_lock, flags);
 
-	tail = info->tail;
+	tail = ctx->tail;
 	pos = tail + AIO_EVENTS_OFFSET;
 
-	if (++tail >= info->nr)
+	if (++tail >= ctx->nr)
 		tail = 0;
 
-	ev_page = kmap_atomic(info->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
+	ev_page = kmap_atomic(ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
 	event = ev_page + pos % AIO_EVENTS_PER_PAGE;
 
 	event->obj = (u64)(unsigned long)iocb->ki_obj.user;
@@ -642,7 +635,7 @@ void aio_complete(struct kiocb *iocb, lo
 	event->res2 = res2;
 
 	kunmap_atomic(ev_page);
-	flush_dcache_page(info->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
+	flush_dcache_page(ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
 
 	pr_debug("%p[%u]: %p: %p %Lx %lx %lx\n",
 		 ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
@@ -653,12 +646,12 @@ void aio_complete(struct kiocb *iocb, lo
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
 
@@ -698,33 +691,32 @@ EXPORT_SYMBOL(aio_complete);
 static int aio_read_events_ring(struct kioctx *ctx,
 				struct io_event __user *event, long nr)
 {
-	struct aio_ring_info *info = &ctx->ring_info;
 	struct aio_ring *ring;
 	unsigned head, pos;
 	int ret = 0, copy_ret;
 
-	if (!mutex_trylock(&info->ring_lock)) {
+	if (!mutex_trylock(&ctx->ring_lock)) {
 		__set_current_state(TASK_RUNNING);
-		mutex_lock(&info->ring_lock);
+		mutex_lock(&ctx->ring_lock);
 	}
 
-	ring = kmap_atomic(info->ring_pages[0]);
+	ring = kmap_atomic(ctx->ring_pages[0]);
 	head = ring->head;
 	kunmap_atomic(ring);
 
-	pr_debug("h%u t%u m%u\n", head, info->tail, info->nr);
+	pr_debug("h%u t%u m%u\n", head, ctx->tail, ctx->nr);
 
-	if (head == info->tail)
+	if (head == ctx->tail)
 		goto out;
 
 	__set_current_state(TASK_RUNNING);
 
 	while (ret < nr) {
-		unsigned i = (head < info->tail ? info->tail : info->nr) - head;
+		unsigned i = (head < ctx->tail ? ctx->tail : ctx->nr) - head;
 		struct io_event *ev;
 		struct page *page;
 
-		if (head == info->tail)
+		if (head == ctx->tail)
 			break;
 
 		i = min_t(int, i, nr - ret);
@@ -732,7 +724,7 @@ static int aio_read_events_ring(struct k
 			  ((head + AIO_EVENTS_OFFSET) % AIO_EVENTS_PER_PAGE));
 
 		pos = head + AIO_EVENTS_OFFSET;
-		page = info->ring_pages[pos / AIO_EVENTS_PER_PAGE];
+		page = ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE];
 		pos %= AIO_EVENTS_PER_PAGE;
 
 		ev = kmap(page);
@@ -746,19 +738,19 @@ static int aio_read_events_ring(struct k
 
 		ret += i;
 		head += i;
-		head %= info->nr;
+		head %= ctx->nr;
 	}
 
-	ring = kmap_atomic(info->ring_pages[0]);
+	ring = kmap_atomic(ctx->ring_pages[0]);
 	ring->head = head;
 	kunmap_atomic(ring);
-	flush_dcache_page(info->ring_pages[0]);
+	flush_dcache_page(ctx->ring_pages[0]);
 
-	pr_debug("%d  h%u t%u\n", ret, head, info->tail);
+	pr_debug("%d  h%u t%u\n", ret, head, ctx->tail);
 
 	atomic_sub(ret, &ctx->reqs_active);
 out:
-	mutex_unlock(&info->ring_lock);
+	mutex_unlock(&ctx->ring_lock);
 
 	return ret;
 }
_

Patches currently in -mm which might be from koverstreet@google.com are

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

