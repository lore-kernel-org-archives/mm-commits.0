From: akpm@linux-foundation.org
Subject: - eventfd-kaio-integration-fix.patch removed from -mm tree
Date: Sat, 12 Apr 2008 19:39:37 -0700
Message-ID: <200804130239.m3D2dbIS032404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755343AbYDMCj5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Apr 2008 22:39:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, jroberson@chesapeake.net, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     eventfd/kaio integration fix
has been removed from the -mm tree.  Its filename was
     eventfd-kaio-integration-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eventfd/kaio integration fix
From: Davide Libenzi <davidel@xmailserver.org>

Jeff Roberson discovered a race when using kaio eventfd based notifications. 
When it occurs it can lead tomissed wakeups and hung userspace.

This patch fixes the race by moving the notification inside the spinlocked
section of kaio.  The operation is safe since eventfd spinlock and kaio one
are unrelated.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Jeff Roberson <jroberson@chesapeake.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN fs/aio.c~eventfd-kaio-integration-fix fs/aio.c
--- a/fs/aio.c~eventfd-kaio-integration-fix
+++ a/fs/aio.c
@@ -936,14 +936,6 @@ int aio_complete(struct kiocb *iocb, lon
 		return 1;
 	}
 
-	/*
-	 * Check if the user asked us to deliver the result through an
-	 * eventfd. The eventfd_signal() function is safe to be called
-	 * from IRQ context.
-	 */
-	if (!IS_ERR(iocb->ki_eventfd))
-		eventfd_signal(iocb->ki_eventfd, 1);
-
 	info = &ctx->ring_info;
 
 	/* add a completion event to the ring buffer.
@@ -992,6 +984,15 @@ int aio_complete(struct kiocb *iocb, lon
 	kunmap_atomic(ring, KM_IRQ1);
 
 	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
+
+	/*
+	 * Check if the user asked us to deliver the result through an
+	 * eventfd. The eventfd_signal() function is safe to be called
+	 * from IRQ context.
+	 */
+	if (!IS_ERR(iocb->ki_eventfd))
+		eventfd_signal(iocb->ki_eventfd, 1);
+
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	ret = __aio_put_req(ctx, iocb);
_

Patches currently in -mm which might be from davidel@xmailserver.org are

epoll-avoid-kmemcheck-warning.patch
fs-timerfdc-should-include-linux-syscallsh.patch
signals-send_signal-be-paranoid-about-signalfd_notify.patch

