From: akpm@linux-foundation.org
Subject: [to-be-updated] aio-reqs_active-reqs_available.patch removed from -mm tree
Date: Thu, 23 May 2013 13:50:22 -0700
Message-ID: <519e810e.O4UerwLsTl6iyNxs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759393Ab3EWUuX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 May 2013 16:50:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zab@redhat.com, viro@zeniv.linux.org.uk, tytso@mit.edu, smani@micron.com, sbradshaw@micron.com, rusty@rustcorp.com.au, mfasheh@suse.com, jmoyer@redhat.com, jlbec@evilplan.org, gregkh@linuxfoundation.org, bcrl@kvack.org, balbi@ti.com, axboe@kernel.dk, asamymuthupa@micron.com, koverstreet@google.com

Subject: [to-be-updated] aio-reqs_active-reqs_available.patch removed from -mm tree
To: koverstreet@google.com,asamymuthupa@micron.com,axboe@kernel.dk,balbi@ti.com,bcrl@kvack.org,gregkh@linuxfoundation.org,jlbec@evilplan.org,jmoyer@redhat.com,mfasheh@suse.com,rusty@rustcorp.com.au,sbradshaw@micron.com,smani@micron.com,tytso@mit.edu,viro@zeniv.linux.org.uk,zab@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 May 2013 13:50:22 -0700


The patch titled
     Subject: aio: reqs_active -> reqs_available
has been removed from the -mm tree.  Its filename was
     aio-reqs_active-reqs_available.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio: reqs_active -> reqs_available

The number of outstanding kiocbs is one of the few shared things left that
has to be touched for every kiocb - it'd be nice to make it percpu.

We can make it per cpu by treating it like an allocation problem: we have
a maximum number of kiocbs that can be outstanding (i.e.  slots) - then we
just allocate and free slots, and we know how to write per cpu allocators.

So as prep work for that, we convert reqs_active to reqs_available.

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
Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff -puN fs/aio.c~aio-reqs_active-reqs_available fs/aio.c
--- a/fs/aio.c~aio-reqs_active-reqs_available
+++ a/fs/aio.c
@@ -89,7 +89,13 @@ struct kioctx {
 	struct work_struct	rcu_work;
 
 	struct {
-		atomic_t	reqs_active;
+		/*
+		 * This counts the number of available slots in the ringbuffer,
+		 * so we avoid overflowing it: it's decremented (if positive)
+		 * when allocating a kiocb and incremented when the resulting
+		 * io_event is pulled off the ringbuffer.
+		 */
+		atomic_t	reqs_available;
 	} ____cacheline_aligned_in_smp;
 
 	struct {
@@ -306,17 +312,17 @@ static void free_ioctx(struct kioctx *ct
 	head = ring->head;
 	kunmap_atomic(ring);
 
-	while (atomic_read(&ctx->reqs_active) > 0) {
+	while (atomic_read(&ctx->reqs_available) < ctx->nr_events - 1) {
 		wait_event(ctx->wait, head != ctx->tail);
 
 		avail = (head <= ctx->tail ? ctx->tail : ctx->nr_events) - head;
 
-		atomic_sub(avail, &ctx->reqs_active);
+		atomic_add(avail, &ctx->reqs_available);
 		head += avail;
 		head %= ctx->nr_events;
 	}
 
-	WARN_ON(atomic_read(&ctx->reqs_active) < 0);
+	WARN_ON(atomic_read(&ctx->reqs_available) > ctx->nr_events - 1);
 
 	aio_free_ring(ctx);
 
@@ -380,6 +386,8 @@ static struct kioctx *ioctx_alloc(unsign
 	if (aio_setup_ring(ctx) < 0)
 		goto out_freectx;
 
+	atomic_set(&ctx->reqs_available, ctx->nr_events - 1);
+
 	/* limit the number of system wide aios */
 	spin_lock(&aio_nr_lock);
 	if (aio_nr + nr_events > aio_max_nr ||
@@ -482,7 +490,7 @@ void exit_aio(struct mm_struct *mm)
 				"exit_aio:ioctx still alive: %d %d %d\n",
 				atomic_read(&ctx->users),
 				atomic_read(&ctx->dead),
-				atomic_read(&ctx->reqs_active));
+				atomic_read(&ctx->reqs_available));
 		/*
 		 * We don't need to bother with munmap() here -
 		 * exit_mmap(mm) is coming and it'll unmap everything.
@@ -514,12 +522,9 @@ static inline struct kiocb *aio_get_req(
 {
 	struct kiocb *req;
 
-	if (atomic_read(&ctx->reqs_active) >= ctx->nr_events)
+	if (atomic_dec_if_positive(&ctx->reqs_available) <= 0)
 		return NULL;
 
-	if (atomic_inc_return(&ctx->reqs_active) > ctx->nr_events - 1)
-		goto out_put;
-
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
 	if (unlikely(!req))
 		goto out_put;
@@ -529,7 +534,7 @@ static inline struct kiocb *aio_get_req(
 
 	return req;
 out_put:
-	atomic_dec(&ctx->reqs_active);
+	atomic_inc(&ctx->reqs_available);
 	return NULL;
 }
 
@@ -600,7 +605,7 @@ void aio_complete(struct kiocb *iocb, lo
 
 	/*
 	 * Take rcu_read_lock() in case the kioctx is being destroyed, as we
-	 * need to issue a wakeup after decrementing reqs_active.
+	 * need to issue a wakeup after incrementing reqs_available.
 	 */
 	rcu_read_lock();
 
@@ -618,7 +623,7 @@ void aio_complete(struct kiocb *iocb, lo
 	 */
 	if (unlikely(xchg(&iocb->ki_cancel,
 			  KIOCB_CANCELLED) == KIOCB_CANCELLED)) {
-		atomic_dec(&ctx->reqs_active);
+		atomic_inc(&ctx->reqs_available);
 		/* Still need the wake_up in case free_ioctx is waiting */
 		goto put_rq;
 	}
@@ -756,7 +761,7 @@ static long aio_read_events_ring(struct
 
 	pr_debug("%li  h%u t%u\n", ret, head, ctx->tail);
 
-	atomic_sub(ret, &ctx->reqs_active);
+	atomic_add(ret, &ctx->reqs_available);
 out:
 	mutex_unlock(&ctx->ring_lock);
 
@@ -1140,7 +1145,7 @@ static int io_submit_one(struct kioctx *
 	aio_put_req(req);	/* drop extra ref to req */
 	return 0;
 out_put_req:
-	atomic_dec(&ctx->reqs_active);
+	atomic_inc(&ctx->reqs_available);
 	aio_put_req(req);	/* drop extra ref to req */
 	aio_put_req(req);	/* drop i/o ref to req */
 	return ret;
_

Patches currently in -mm which might be from koverstreet@google.com are

linux-next.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
block-prep-work-for-batch-completion.patch
block-aio-batch-completion-for-bios-kiocbs.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-convert-the-ioctx-list-to-radix-tree.patch

