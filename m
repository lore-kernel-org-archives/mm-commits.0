From: akpm@linux-foundation.org
Subject: + aio-remove-unused-aio_run_iocbs.patch added to -mm tree
Date: Wed, 05 Jan 2011 13:29:00 -0800
Message-ID: <201101052129.p05LT0Qi019536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663Ab1AEV3L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2011 16:29:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmoyer@redhat.com


The patch titled
     aio: remove unused aio_run_iocbs()
has been added to the -mm tree.  Its filename is
     aio-remove-unused-aio_run_iocbs.patch

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
Subject: aio: remove unused aio_run_iocbs()
From: Jeff Moyer <jmoyer@redhat.com>

aio_run_iocbs() is not used at all, so get rid of it.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff -puN fs/aio.c~aio-remove-unused-aio_run_iocbs fs/aio.c
--- a/fs/aio.c~aio-remove-unused-aio_run_iocbs
+++ a/fs/aio.c
@@ -798,30 +798,14 @@ static void aio_queue_work(struct kioctx
 	queue_delayed_work(aio_wq, &ctx->wq, timeout);
 }
 
-
 /*
- * aio_run_iocbs:
+ * aio_run_all_iocbs:
  * 	Process all pending retries queued on the ioctx
- * 	run list.
+ * 	run list, and keep running them until the list
+ * 	stays empty.
  * Assumes it is operating within the aio issuer's mm
  * context.
  */
-static inline void aio_run_iocbs(struct kioctx *ctx)
-{
-	int requeue;
-
-	spin_lock_irq(&ctx->ctx_lock);
-
-	requeue = __aio_run_iocbs(ctx);
-	spin_unlock_irq(&ctx->ctx_lock);
-	if (requeue)
-		aio_queue_work(ctx);
-}
