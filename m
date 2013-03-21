From: akpm@linux-foundation.org
Subject: [to-be-updated] aio-percpu-reqs_available.patch removed from -mm tree
Date: Thu, 21 Mar 2013 15:28:42 -0700
Message-ID: <20130321222842.93FB031C15E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:55680 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab3CUW2o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:28:44 -0400
Received: by mail-yh0-f74.google.com with SMTP id i57so12345yha.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:28:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: percpu reqs_available
has been removed from the -mm tree.  Its filename was
     aio-percpu-reqs_available.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio: percpu reqs_available

See the previous patch ("aio: reqs_active -> reqs_available") for why we
want to do this - this basically implements a per cpu allocator for
reqs_available that doesn't actually allocate anything.

Note that we need to increase the size of the ringbuffer we allocate,
since a single thread won't necessarily be able to use all the
reqs_available slots - some (up to about half) might be on other per cpu
lists, unavailable for the current thread.

We size the ringbuffer based on the nr_events userspace passed to
io_setup(), so this is a slight behaviour change - but nr_events wasn't
being used as a hard limit before, it was being rounded up to the next
page before so this doesn't change the actual semantics.

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

 fs/aio.c |   92 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 85 insertions(+), 7 deletions(-)

diff -puN fs/aio.c~aio-percpu-reqs_available fs/aio.c
--- a/fs/aio.c~aio-percpu-reqs_available
+++ a/fs/aio.c
@@ -26,6 +26,7 @@
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/mmu_context.h>
+#include <linux/percpu.h>
 #include <linux/slab.h>
 #include <linux/timer.h>
 #include <linux/aio.h>
@@ -59,6 +60,10 @@ struct aio_ring {
 
 #define AIO_RING_PAGES	8
 
+struct kioctx_cpu {
+	unsigned		reqs_available;
+};
+
 struct kioctx {
 	atomic_t		users;
 	atomic_t		dead;
@@ -67,6 +72,10 @@ struct kioctx {
 	unsigned long		user_id;
 	struct hlist_node	list;
 
+	struct __percpu kioctx_cpu *cpu;
+
+	unsigned		req_batch;
+
 	unsigned		nr;
 
 	/* sys_io_setup currently limits this to an unsigned int */
@@ -149,6 +158,9 @@ static int aio_setup_ring(struct kioctx
 	unsigned long size, populate;
 	int nr_pages;
 
+	nr_events = max(nr_events, num_possible_cpus() * 4);
+	nr_events *= 2;
+
 	/* Compensate for the ring buffer's head/tail overlap entry */
 	nr_events += 2;	/* 1 is required, 2 for good luck */
 
@@ -268,6 +280,8 @@ static int kiocb_cancel(struct kioctx *c
 static void free_ioctx_rcu(struct rcu_head *head)
 {
 	struct kioctx *ctx = container_of(head, struct kioctx, rcu_head);
+
+	free_percpu(ctx->cpu);
 	kmem_cache_free(kioctx_cachep, ctx);
 }
 
@@ -281,7 +295,7 @@ static void free_ioctx(struct kioctx *ct
 	struct aio_ring *ring;
 	struct io_event res;
 	struct kiocb *req;
-	unsigned head, avail;
+	unsigned cpu, head, avail;
 
 	spin_lock_irq(&ctx->ctx_lock);
 
@@ -295,6 +309,13 @@ static void free_ioctx(struct kioctx *ct
 
 	spin_unlock_irq(&ctx->ctx_lock);
 
+	for_each_possible_cpu(cpu) {
+		struct kioctx_cpu *kcpu = per_cpu_ptr(ctx->cpu, cpu);
+
+		atomic_add(kcpu->reqs_available, &ctx->reqs_available);
+		kcpu->reqs_available = 0;
+	}
+
 	ring = kmap_atomic(ctx->ring_pages[0]);
 	head = ring->head;
 	kunmap_atomic(ring);
@@ -370,10 +391,16 @@ static struct kioctx *ioctx_alloc(unsign
 
 	INIT_LIST_HEAD(&ctx->active_reqs);
 
-	if (aio_setup_ring(ctx) < 0)
+	ctx->cpu = alloc_percpu(struct kioctx_cpu);
+	if (!ctx->cpu)
 		goto out_freectx;
 
+	if (aio_setup_ring(ctx) < 0)
+		goto out_freepcpu;
+
 	atomic_set(&ctx->reqs_available, ctx->nr);
+	ctx->req_batch = ctx->nr / (num_possible_cpus() * 4);
+	BUG_ON(!ctx->req_batch);
 
 	/* limit the number of system wide aios */
 	spin_lock(&aio_nr_lock);
@@ -397,6 +424,8 @@ static struct kioctx *ioctx_alloc(unsign
 out_cleanup:
 	err = -EAGAIN;
 	aio_free_ring(ctx);
+out_freepcpu:
+	free_percpu(ctx->cpu);
 out_freectx:
 	kmem_cache_free(kioctx_cachep, ctx);
 	pr_debug("error allocating ioctx %d\n", err);
@@ -495,6 +524,52 @@ void exit_aio(struct mm_struct *mm)
 	}
 }
 
+static void put_reqs_available(struct kioctx *ctx, unsigned nr)
+{
+	struct kioctx_cpu *kcpu;
+
+	preempt_disable();
+	kcpu = this_cpu_ptr(ctx->cpu);
+
+	kcpu->reqs_available += nr;
+	while (kcpu->reqs_available >= ctx->req_batch * 2) {
+		kcpu->reqs_available -= ctx->req_batch;
+		atomic_add(ctx->req_batch, &ctx->reqs_available);
+	}
+
+	preempt_enable();
+}
+
+static bool get_reqs_available(struct kioctx *ctx)
+{
+	struct kioctx_cpu *kcpu;
+	bool ret = false;
+
+	preempt_disable();
+	kcpu = this_cpu_ptr(ctx->cpu);
+
+	if (!kcpu->reqs_available) {
+		int old, avail = atomic_read(&ctx->reqs_available);
+
+		do {
+			if (avail < ctx->req_batch)
+				goto out;
+
+			old = avail;
+			avail = atomic_cmpxchg(&ctx->reqs_available,
+					       avail, avail - ctx->req_batch);
+		} while (avail != old);
+
+		kcpu->reqs_available += ctx->req_batch;
+	}
+
+	ret = true;
+	kcpu->reqs_available--;
+out:
+	preempt_enable();
+	return ret;
+}
+
 /* aio_get_req
  *	Allocate a slot for an aio request.  Increments the ki_users count
  * of the kioctx so that the kioctx stays around until all requests are
@@ -509,7 +584,7 @@ static inline struct kiocb *aio_get_req(
 {
 	struct kiocb *req;
 
-	if (atomic_dec_if_positive(&ctx->reqs_available) <= 0)
+	if (!get_reqs_available(ctx))
 		return NULL;
 
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
@@ -518,10 +593,9 @@ static inline struct kiocb *aio_get_req(
 
 	atomic_set(&req->ki_users, 2);
 	req->ki_ctx = ctx;
-
 	return req;
 out_put:
-	atomic_inc(&ctx->reqs_available);
+	put_reqs_available(ctx, 1);
 	return NULL;
 }
 
@@ -610,6 +684,10 @@ void aio_complete(struct kiocb *iocb, lo
 	 */
 	if (unlikely(xchg(&iocb->ki_cancel,
 			  KIOCB_CANCELLED) == KIOCB_CANCELLED)) {
+		/*
+		 * Can't use the percpu reqs_available here - could race with
+		 * free_ioctx()
+		 */
 		atomic_inc(&ctx->reqs_available);
 		/* Still need the wake_up in case free_ioctx is waiting */
 		goto put_rq;
@@ -750,7 +828,7 @@ static int aio_read_events_ring(struct k
 
 	pr_debug("%d  h%u t%u\n", ret, head, ctx->tail);
 
-	atomic_add(ret, &ctx->reqs_available);
+	put_reqs_available(ctx, ret);
 out:
 	mutex_unlock(&ctx->ring_lock);
 
@@ -1169,7 +1247,7 @@ static int io_submit_one(struct kioctx *
 	return 0;
 
 out_put_req:
-	atomic_inc(&ctx->reqs_available);
+	put_reqs_available(ctx, 1);
 	aio_put_req(req);	/* drop extra ref to req */
 	aio_put_req(req);	/* drop i/o ref to req */
 	return ret;
_

Patches currently in -mm which might be from koverstreet@google.com are

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

