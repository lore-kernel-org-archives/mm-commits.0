From: akpm@linux-foundation.org
Subject: [to-be-updated]
 aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
 removed from -mm tree
Date: Thu, 23 May 2013 13:50:30 -0700
Message-ID: <519e8116.zaQ2fzeQbHKj/Jdu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759409Ab3EWUub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 May 2013 16:50:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zab@redhat.com, koverstreet@google.com, jwboyer@redhat.com, bcrl@kvack.org

Subject: [to-be-updated] aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch removed from -mm tree
To: bcrl@kvack.org,jwboyer@redhat.com,koverstreet@google.com,zab@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 May 2013 13:50:30 -0700


The patch titled
     Subject: aio: fix kioctx not being freed after cancellation at exit time
has been removed from the -mm tree.  Its filename was
     aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

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
Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Zach Brown <zab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff -puN fs/aio.c~aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time fs/aio.c
--- a/fs/aio.c~aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time
+++ a/fs/aio.c
@@ -349,7 +349,9 @@ static void free_ioctx(struct kioctx *ct
 	kunmap_atomic(ring);
 
 	while (atomic_read(&ctx->reqs_available) < ctx->nr_events - 1) {
-		wait_event(ctx->wait, head != ctx->shadow_tail);
+		wait_event(ctx->wait,
+			   (head != ctx->shadow_tail) ||
+			   (atomic_read(&ctx->reqs_available) >= ctx->nr_events - 1));
 
 		avail = (head <= ctx->shadow_tail
 			 ? ctx->shadow_tail : ctx->nr_events) - head;
@@ -774,17 +776,6 @@ void batch_complete_aio(struct batch_com
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
