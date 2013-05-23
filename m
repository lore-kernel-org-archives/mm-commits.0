From: akpm@linux-foundation.org
Subject: +
 aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch added
 to -mm tree
Date: Thu, 23 May 2013 14:02:01 -0700
Message-ID: <519e83c9.Mc2ABMt/zYTjaW95%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758643Ab3EWVCC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 May 2013 17:02:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zab@redhat.com, koverstreet@google.com, jwboyer@redhat.com, bcrl@kvack.org

Subject: + aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch added to -mm tree
To: bcrl@kvack.org,jwboyer@redhat.com,koverstreet@google.com,zab@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 23 May 2013 14:02:01 -0700


The patch titled
     Subject: aio: fix kioctx not being freed after cancellation at exit time
has been added to the -mm tree.  Its filename is
     aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
+			   (head != ctx->tail) ||
+			   (atomic_read(&ctx->reqs_active) <= 0);
 
 		avail = (head <= ctx->tail ? ctx->tail : ctx->nr_events) - head;
 
_

Patches currently in -mm which might be from bcrl@kvack.org are

aio-fix-io_getevents-documentation.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
aio-convert-the-ioctx-list-to-radix-tree.patch

