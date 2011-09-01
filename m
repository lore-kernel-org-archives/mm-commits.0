From: akpm@linux-foundation.org
Subject: + aio-allocate-kiocbs-in-batches.patch added to -mm tree
Date: Wed, 31 Aug 2011 17:13:38 -0700
Message-ID: <201109010013.p810DcSR003857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755898Ab1IAAON (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Aug 2011 20:14:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmoyer@redhat.com


The patch titled
     aio: allocate kiocbs in batches
has been added to the -mm tree.  Its filename is
     aio-allocate-kiocbs-in-batches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aio: allocate kiocbs in batches
From: Jeff Moyer <jmoyer@redhat.com>

When looking at perf data for my aio-stress test runs against some
relatively fast storage, I noticed that __aio_get_req was taking up more
CPU than I expected.  The command line for aio-stress was:

  aio-stress -O -r 8 -d 256 -b 32 -l -s 16384 /dev/sdk

which means we're sending 32 iocbs to io_submit at a time.  Here's the
perf report -g output:

Events: 41K cycles
-      7.33%  aio-stress  [kernel.kallsyms]             [k] _raw_spin_lock_irq
   - _raw_spin_lock_irq
      + 75.38% scsi_request_fn
      - 10.67% __aio_get_req
           io_submit_one

The spinlock is the ctx_lock, taken when allocating the request.  This
seemed like pretty low-hanging fruit to me, so I cooked up a patch to
allocate 32 kiocbs at a time.  This is the result:

Events: 50K cycles
-      5.54%  aio-stress  [kernel.kallsyms]             [k] _raw_spin_lock_irq
   - _raw_spin_lock_irq
      + 83.23% scsi_request_fn
      - 5.14% io_submit_one

So, aio-stress now takes up ~2% less CPU.  This seems like a worth-while
thing to do, but I don't have a system handy that would show any real
performance gains from it.  The higher the number of iocbs passed to
io_submit, the more of a win this will be.

I tested this with multiple different batch sizes (1, 32, 33, 64, 256) and
it didn't blow up.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |  126 +++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 98 insertions(+), 28 deletions(-)

diff -puN fs/aio.c~aio-allocate-kiocbs-in-batches fs/aio.c
--- a/fs/aio.c~aio-allocate-kiocbs-in-batches
+++ a/fs/aio.c
@@ -440,8 +440,6 @@ void exit_aio(struct mm_struct *mm)
 static struct kiocb *__aio_get_req(struct kioctx *ctx)
 {
 	struct kiocb *req = NULL;
-	struct aio_ring *ring;
-	int okay = 0;
 
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL);
 	if (unlikely(!req))
@@ -459,40 +457,107 @@ static struct kiocb *__aio_get_req(struc
 	INIT_LIST_HEAD(&req->ki_run_list);
 	req->ki_eventfd = NULL;
 
-	/* Check if the completion queue has enough free space to
-	 * accept an event from this io.
+	return req;
+}
+
+#define KIOCB_STASH_SIZE	32
+struct kiocb_stash {
+	unsigned head;
+	unsigned tail;
+	unsigned total;
+	unsigned used;
+	struct kiocb *kiocbs[KIOCB_STASH_SIZE];
+};
+static void kiocb_stash_init(struct kiocb_stash *stash, int nr)
+{
+	stash->head = stash->tail = 0;
+	stash->total = nr;
+	stash->used = 0;
+}
+static void kiocb_stash_free(struct kiocb_stash *stash, int used)
+{
+	int i;
+
+	for (i = used; i < stash->total; i++)
+		kmem_cache_free(kiocb_cachep, stash->kiocbs[i]);
+}
+static inline unsigned kiocb_stash_avail(struct kiocb_stash *stash)
+{
+	return stash->tail - stash->head;
+}
+
+/*
+ * Allocate nr kiocbs.  This aovids taking and dropping the lock a
+ * lot during setup.
+ */
+static int kiocb_stash_refill(struct kioctx *ctx, struct kiocb_stash *stash)
+{
+	int i, nr = KIOCB_STASH_SIZE;
+	int avail;
+	int called_fput = 0;
+	struct aio_ring *ring;
+
+	/*
+	 * Allocate the requests up-front.  Later, we'll trim the list
+	 * if there isn't enough room in the completion ring.
 	 */
+	stash->head = 0;
+	if ((stash->total - stash->used) % KIOCB_STASH_SIZE)
+		/* don't need to allocate a full batch */
+		nr = stash->total - stash->used;
+
+	for (i = 0; i < nr; i++) {
+		stash->kiocbs[i] = __aio_get_req(ctx);
+		if (!stash->kiocbs[i] && !called_fput) {
+			/* Handle a potential starvation case --
+			 * should be exceedingly rare as requests will
+			 * be stuck on fput_head only if the
+			 * aio_fput_routine is delayed and the
+			 * requests were the last user of the struct
+			 * file.
+			 */
+			aio_fput_routine(NULL);
+			called_fput = 1;
+			i--;
+			continue;
+		}
+	}
+	stash->tail = i;
+
 	spin_lock_irq(&ctx->ctx_lock);
 	ring = kmap_atomic(ctx->ring_info.ring_pages[0], KM_USER0);
-	if (ctx->reqs_active < aio_ring_avail(&ctx->ring_info, ring)) {
-		list_add(&req->ki_list, &ctx->active_reqs);
+
+	avail = aio_ring_avail(&ctx->ring_info, ring) + ctx->reqs_active;
+	if (avail < stash->tail) {
+		/* Trim back the number of requests. */
+		for (i = avail; i < stash->tail; i++)
+			kmem_cache_free(kiocb_cachep, stash->kiocbs[i]);
+		stash->tail = avail;
+	}
+	for (i = 0; i < stash->tail; i++) {
+		list_add(&stash->kiocbs[i]->ki_list, &ctx->active_reqs);
 		ctx->reqs_active++;
-		okay = 1;
 	}
 	kunmap_atomic(ring, KM_USER0);
 	spin_unlock_irq(&ctx->ctx_lock);
 
-	if (!okay) {
-		kmem_cache_free(kiocb_cachep, req);
-		req = NULL;
-	}
-
-	return req;
+	if (stash->tail == 0)
+		return -1;
+	return 0;
 }
 
-static inline struct kiocb *aio_get_req(struct kioctx *ctx)
+static inline struct kiocb *aio_get_req(struct kioctx *ctx,
+					struct kiocb_stash *stash)
 {
-	struct kiocb *req;
-	/* Handle a potential starvation case -- should be exceedingly rare as 
-	 * requests will be stuck on fput_head only if the aio_fput_routine is 
-	 * delayed and the requests were the last user of the struct file.
-	 */
-	req = __aio_get_req(ctx);
-	if (unlikely(NULL == req)) {
-		aio_fput_routine(NULL);
-		req = __aio_get_req(ctx);
+	int ret;
+
+	if (kiocb_stash_avail(stash) == 0) {
+		ret = kiocb_stash_refill(ctx, stash);
+		if (ret)
+			return NULL;
 	}
-	return req;
+	stash->used++;
+	return stash->kiocbs[stash->head++];
 }
 
 static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
@@ -1515,7 +1580,8 @@ static ssize_t aio_setup_iocb(struct kio
 }
 
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
-			 struct iocb *iocb, bool compat)
+			 struct iocb *iocb, struct kiocb_stash *stash,
+			 bool compat)
 {
 	struct kiocb *req;
 	struct file *file;
@@ -1541,7 +1607,7 @@ static int io_submit_one(struct kioctx *
 	if (unlikely(!file))
 		return -EBADF;
 
-	req = aio_get_req(ctx);		/* returns with 2 references to req */
+	req = aio_get_req(ctx, stash);	/* returns with 2 references to req */
 	if (unlikely(!req)) {
 		fput(file);
 		return -EAGAIN;
@@ -1621,8 +1687,9 @@ long do_io_submit(aio_context_t ctx_id, 
 {
 	struct kioctx *ctx;
 	long ret = 0;
-	int i;
+	int i = 0;
 	struct blk_plug plug;
+	struct kiocb_stash kiocbs;
 
 	if (unlikely(nr < 0))
 		return -EINVAL;
@@ -1639,6 +1706,8 @@ long do_io_submit(aio_context_t ctx_id, 
 		return -EINVAL;
 	}
 
+	kiocb_stash_init(&kiocbs, nr);
+
 	blk_start_plug(&plug);
 
 	/*
@@ -1659,12 +1728,13 @@ long do_io_submit(aio_context_t ctx_id, 
 			break;
 		}
 
-		ret = io_submit_one(ctx, user_iocb, &tmp, compat);
+		ret = io_submit_one(ctx, user_iocb, &tmp, &kiocbs, compat);
 		if (ret)
 			break;
 	}
 	blk_finish_plug(&plug);
 
+	kiocb_stash_free(&kiocbs, i);
 	put_ioctx(ctx);
 	return i ? i : ret;
 }
_

Patches currently in -mm which might be from jmoyer@redhat.com are

aio-allocate-kiocbs-in-batches.patch
aio-allocate-kiocbs-in-batches-fix.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio.patch
dio-fix-a-wrong-comment.patch
dio-rearrange-fields-in-dio-dio_submit-to-avoid-holes.patch
dio-use-a-slab-cache-for-struct-dio.patch
dio-separate-map_bh-from-dio-v2.patch
dio-inline-the-complete-submission-path-v2.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io.patch
dio-remove-unnecessary-dio-argument-from-dio_pages_present.patch
dio-remove-unused-dio-parameter-from-dio_bio_add_page.patch
vfs-cache-request_queue-in-struct-block_device.patch
dio-optimize-cache-misses-in-the-submission-path-v2.patch

