From: akpm@linux-foundation.org
Subject: [merged]
 aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
 removed from -mm tree
Date: Tue, 28 May 2013 12:37:25 -0700
Message-ID: <51a50775.bTzTmqJIY9K66UQX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab3E1Th0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:37:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zab@redhat.com, koverstreet@google.com, jwboyer@redhat.com, bcrl@kvack.org

Subject: [merged] aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch removed from -mm tree
To: bcrl@kvack.org,jwboyer@redhat.com,koverstreet@google.com,zab@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:37:25 -0700


The patch titled
     Subject: aio: fix kioctx not being freed after cancellation at exit time
has been removed from the -mm tree.  Its filename was
     aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Benjamin LaHaise <bcrl@kvack.org>
Subject: aio: fix kioctx not being freed after cancellation at exit time

The recent changes overhauling fs/aio.c introduced a bug that results in
the kioctx not being freed when outstanding kiocbs are cancelled at
exit_aio() time.  Specifically, a kiocb that is cancelled has its
completion events discarded by batch_complete_aio(), which then fails to
wake up the process stuck in free_ioctx().  Fix this by modifying the
wait_event() condition in free_ioctx() appropriately.

This patch was tested with the cancel operation in the thread based code
posted yesterday.

[akpm@linux-foundation.org: fix build]
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Zach Brown <zab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/aio.c~aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time fs/aio.c
--- a/fs/aio.c~aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time
+++ a/fs/aio.c
@@ -307,7 +307,9 @@ static void free_ioctx(struct kioctx *ct
 	kunmap_atomic(ring);
 
 	while (atomic_read(&ctx->reqs_active) > 0) {
-		wait_event(ctx->wait, head != ctx->tail);
+		wait_event(ctx->wait,
+				head != ctx->tail ||
+				atomic_read(&ctx->reqs_active) <= 0);
 
 		avail = (head <= ctx->tail ? ctx->tail : ctx->nr_events) - head;
 
_

Patches currently in -mm which might be from bcrl@kvack.org are


