From: akpm@linux-foundation.org
Subject: [to-be-updated] aio-correct-calculation-of-available-events.patch removed from -mm tree
Date: Thu, 21 Mar 2013 15:29:28 -0700
Message-ID: <20130321222928.72D1A31C299@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:59897 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab3CUW33 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:29:29 -0400
Received: by mail-gg0-f202.google.com with SMTP id l4so309869ggi.3
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:29:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bcrl@kvack.org, koverstreet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: correct calculation of available events
has been removed from the -mm tree.  Its filename was
     aio-correct-calculation-of-available-events.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Benjamin LaHaise <bcrl@kvack.org>
Subject: aio: correct calculation of available events

When the number of available events in the ring buffer is calculated, the
avail calculation is incorrect when head == tail.  This is harmless in
aio_read_events_ring(), but in free_ioctx() leads to the subsequent
WARN_ON(atomic_read(&ctx->reqs_available) > ctx->nr).  Correct this.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Reviewed-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/aio.c~aio-correct-calculation-of-available-events fs/aio.c
--- a/fs/aio.c~aio-correct-calculation-of-available-events
+++ a/fs/aio.c
@@ -337,7 +337,8 @@ static void free_ioctx(struct kioctx *ct
 	while (atomic_read(&ctx->reqs_available) < ctx->nr) {
 		wait_event(ctx->wait, head != ctx->shadow_tail);
 
-		avail = (head < ctx->shadow_tail ? ctx->shadow_tail : ctx->nr) - head;
+		avail = (head <= ctx->shadow_tail ?
+			 ctx->shadow_tail : ctx->nr) - head;
 
 		atomic_add(avail, &ctx->reqs_available);
 		head += avail;
@@ -885,7 +886,7 @@ static long aio_read_events_ring(struct
 		goto out;
 
 	while (ret < nr) {
-		long avail = (head < ctx->shadow_tail
+		long avail = (head <= ctx->shadow_tail
 			      ? ctx->shadow_tail : ctx->nr) - head;
 		struct io_event *ev;
 		struct page *page;
_

Patches currently in -mm which might be from bcrl@kvack.org are

aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
aio-fix-ringbuffer-calculation-so-we-dont-wrap.patch

