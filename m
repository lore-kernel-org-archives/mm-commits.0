From: akpm@linux-foundation.org
Subject: [to-be-updated] aio-fix-aio_read_events_ring-types.patch removed from -mm tree
Date: Thu, 21 Mar 2013 15:29:22 -0700
Message-ID: <20130321222922.6D2015A42C2@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:35751 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978Ab3CUW3Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:29:24 -0400
Received: by mail-ve0-f202.google.com with SMTP id m1so310173ves.3
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:29:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: fix aio_read_events_ring() types
has been removed from the -mm tree.  Its filename was
     aio-fix-aio_read_events_ring-types.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio: fix aio_read_events_ring() types

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN fs/aio.c~aio-fix-aio_read_events_ring-types fs/aio.c
--- a/fs/aio.c~aio-fix-aio_read_events_ring-types
+++ a/fs/aio.c
@@ -852,12 +852,13 @@ EXPORT_SYMBOL(aio_complete_batch);
  *	Pull an event off of the ioctx's event ring.  Returns the number of
  *	events fetched
  */
-static int aio_read_events_ring(struct kioctx *ctx,
-				struct io_event __user *event, long nr)
+static long aio_read_events_ring(struct kioctx *ctx,
+				 struct io_event __user *event, long nr)
 {
 	struct aio_ring *ring;
 	unsigned head, pos;
-	int ret = 0, copy_ret;
+	long ret = 0;
+	int copy_ret;
 
 	if (!mutex_trylock(&ctx->ring_lock)) {
 		__set_current_state(TASK_RUNNING);
@@ -876,23 +877,24 @@ static int aio_read_events_ring(struct k
 	__set_current_state(TASK_RUNNING);
 
 	while (ret < nr) {
-		unsigned i = (head < ctx->shadow_tail ? ctx->shadow_tail : ctx->nr) - head;
+		long avail = (head < ctx->shadow_tail
+			      ? ctx->shadow_tail : ctx->nr) - head;
 		struct io_event *ev;
 		struct page *page;
 
 		if (head == ctx->shadow_tail)
 			break;
 
-		i = min_t(int, i, nr - ret);
-		i = min_t(int, i, AIO_EVENTS_PER_PAGE -
-			  ((head + AIO_EVENTS_OFFSET) % AIO_EVENTS_PER_PAGE));
+		avail = min(avail, nr - ret);
+		avail = min_t(long, avail, AIO_EVENTS_PER_PAGE -
+			      ((head + AIO_EVENTS_OFFSET) % AIO_EVENTS_PER_PAGE));
 
 		pos = head + AIO_EVENTS_OFFSET;
 		page = ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE];
 		pos %= AIO_EVENTS_PER_PAGE;
 
 		ev = kmap(page);
-		copy_ret = copy_to_user(event + ret, ev + pos, sizeof(*ev) * i);
+		copy_ret = copy_to_user(event + ret, ev + pos, sizeof(*ev) * avail);
 		kunmap(page);
 
 		if (unlikely(copy_ret)) {
@@ -900,8 +902,8 @@ static int aio_read_events_ring(struct k
 			goto out;
 		}
 
-		ret += i;
-		head += i;
+		ret += avail;
+		head += avail;
 		head %= ctx->nr;
 	}
 
@@ -910,7 +912,7 @@ static int aio_read_events_ring(struct k
 	kunmap_atomic(ring);
 	flush_dcache_page(ctx->ring_pages[0]);
 
-	pr_debug("%d  h%u t%u\n", ret, head, ctx->shadow_tail);
+	pr_debug("%li  h%u t%u\n", ret, head, ctx->shadow_tail);
 
 	put_reqs_available(ctx, ret);
 out:
_

Patches currently in -mm which might be from koverstreet@google.com are

aio-document-clarify-aio_read_events-and-shadow_tail.patch
aio-correct-calculation-of-available-events.patch
aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
aio-fix-ringbuffer-calculation-so-we-dont-wrap.patch

