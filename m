From: akpm@linux-foundation.org
Subject: [merged] aio-remove-unused-aio_run_iocbs.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:10:01 -0800
Message-ID: <201101132012.p0DKCgwv030319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756782Ab1AMUNW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:13:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     aio: remove unused aio_run_iocbs()
has been removed from the -mm tree.  Its filename was
     aio-remove-unused-aio_run_iocbs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aio: remove unused aio_run_iocbs()
From: Jeff Moyer <jmoyer@redhat.com>

aio_run_iocbs() is not used at all, so get rid of it.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff -puN fs/aio.c~aio-remove-unused-aio_run_iocbs fs/aio.c
--- a/fs/aio.c~aio-remove-unused-aio_run_iocbs
+++ a/fs/aio.c
@@ -798,29 +798,12 @@ static void aio_queue_work(struct kioctx
 	queue_delayed_work(aio_wq, &ctx->wq, timeout);
 }
 
-
-/*
- * aio_run_iocbs:
- * 	Process all pending retries queued on the ioctx
- * 	run list.
- * Assumes it is operating within the aio issuer's mm
- * context.
- */
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
