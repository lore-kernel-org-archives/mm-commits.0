From: akpm@linux-foundation.org
Subject: [to-be-updated] aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch removed from -mm tree
Date: Thu, 21 Mar 2013 15:29:31 -0700
Message-ID: <20130321222931.830E531C15E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:62488 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068Ab3CUW3c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:29:32 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so310656vcb.3
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:29:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bcrl@kvack.org, jwboyer@redhat.com, koverstreet@google.com, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: fix kioctx not being freed after cancellation at exit time
has been removed from the -mm tree.  Its filename was
     aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Benjamin LaHaise <bcrl@kvack.org>
Subject: aio: fix kioctx not being freed after cancellation at exit time

The recent changes overhauling fs/aio.c introduced a bug that results in the
kioctx not being freed when outstanding kiocbs are cancelled at exit_aio()
time.  Specifically, a kiocb that is cancelled has its completion events
discarded by batch_complete_aio(), which then fails to wake up the process
stuck in free_ioctx().  Fix this by removing the event suppression in
batch_complete_aio() and modify the wait_event() condition in free_ioctx()
appropriately.

This patch was tested with the cancel operation in the thread based code
posted yesterday.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Zach Brown <zab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff -puN fs/aio.c~aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time fs/aio.c
--- a/fs/aio.c~aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time
+++ a/fs/aio.c
@@ -335,7 +335,9 @@ static void free_ioctx(struct kioctx *ct
 	kunmap_atomic(ring);
 
 	while (atomic_read(&ctx->reqs_available) < ctx->nr) {
-		wait_event(ctx->wait, head != ctx->shadow_tail);
+		wait_event(ctx->wait,
+			   (head != ctx->shadow_tail) ||
+			   (atomic_read(&ctx->reqs_available) >= ctx->nr));
 
 		avail = (head <= ctx->shadow_tail ?
 			 ctx->shadow_tail : ctx->nr) - head;
@@ -748,17 +750,6 @@ void batch_complete_aio(struct batch_com
 			n = rb_parent(n);
 		}
 
-		if (unlikely(xchg(&req->ki_cancel,
-				  KIOCB_CANCELLED) == KIOCB_CANCELLED)) {
-			/*
-			 * Can't use the percpu reqs_available here - could race
-			 * with free_ioctx()
-			 */
-			atomic_inc(&req->ki_ctx->reqs_available);
-			aio_put_req(req);
-			continue;
-		}
