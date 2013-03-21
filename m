From: akpm@linux-foundation.org
Subject: [to-be-updated] aio-document-clarify-aio_read_events-and-shadow_tail.patch removed from -mm tree
Date: Thu, 21 Mar 2013 15:29:25 -0700
Message-ID: <20130321222925.6D7EA5A42C2@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:56174 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab3CUW30 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:29:26 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so311082qen.0
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:29:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: document, clarify aio_read_events() and shadow_tail
has been removed from the -mm tree.  Its filename was
     aio-document-clarify-aio_read_events-and-shadow_tail.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio: document, clarify aio_read_events() and shadow_tail

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff -puN fs/aio.c~aio-document-clarify-aio_read_events-and-shadow_tail fs/aio.c
--- a/fs/aio.c~aio-document-clarify-aio_read_events-and-shadow_tail
+++ a/fs/aio.c
@@ -103,6 +103,19 @@ struct kioctx {
 	struct {
 		struct mutex	ring_lock;
 		wait_queue_head_t wait;
+
+		/*
+		 * Copy of the real tail, that aio_complete uses - to reduce
+		 * cacheline bouncing. The real tail will tend to be much more
+		 * contended - since typically events are delivered one at a
+		 * time, and then aio_read_events() slurps them up a bunch at a
+		 * time - so it's helpful if aio_read_events() isn't also
+		 * contending for the tail. So, aio_complete() updates
+		 * shadow_tail whenever it updates tail.
+		 *
+		 * Also needed because tail is used as a hacky lock and isn't
+		 * always the real tail.
+		 */
 		unsigned	shadow_tail;
 	} ____cacheline_aligned_in_smp;
 
@@ -860,10 +873,7 @@ static long aio_read_events_ring(struct
 	long ret = 0;
 	int copy_ret;
 
-	if (!mutex_trylock(&ctx->ring_lock)) {
-		__set_current_state(TASK_RUNNING);
-		mutex_lock(&ctx->ring_lock);
-	}
+	mutex_lock(&ctx->ring_lock);
 
 	ring = kmap_atomic(ctx->ring_pages[0]);
 	head = ring->head;
@@ -874,8 +884,6 @@ static long aio_read_events_ring(struct
 	if (head == ctx->shadow_tail)
 		goto out;
 
-	__set_current_state(TASK_RUNNING);
-
 	while (ret < nr) {
 		long avail = (head < ctx->shadow_tail
 			      ? ctx->shadow_tail : ctx->nr) - head;
@@ -954,6 +962,20 @@ static long read_events(struct kioctx *c
 		until = timespec_to_ktime(ts);
 	}
 
+	/*
+	 * Note that aio_read_events() is being called as the conditional - i.e.
+	 * we're calling it after prepare_to_wait() has set task state to
+	 * TASK_INTERRUPTIBLE.
+	 *
+	 * But aio_read_events() can block, and if it blocks it's going to flip
+	 * the task state back to TASK_RUNNING.
+	 *
+	 * This should be ok, provided it doesn't flip the state back to
+	 * TASK_RUNNING and return 0 too much - that causes us to spin. That
+	 * will only happen if the mutex_lock() call blocks, and we then find
+	 * the ringbuffer empty. So in practice we should be ok, but it's
+	 * something to be aware of when touching this code.
+	 */
 	wait_event_interruptible_hrtimeout(ctx->wait,
 			aio_read_events(ctx, min_nr, nr, event, &ret), until);
 
_

Patches currently in -mm which might be from koverstreet@google.com are

aio-correct-calculation-of-available-events.patch
aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
aio-fix-ringbuffer-calculation-so-we-dont-wrap.patch

