From: akpm@linux-foundation.org
Subject: + eventfd-kaio-integration-fix.patch added to -mm tree
Date: Wed, 09 Apr 2008 12:05:12 -0700
Message-ID: <200804091905.m39J5C9C025387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756477AbYDITGB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2008 15:06:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, jroberson@chesapeake.net, zach.brown@oracle.com


The patch titled
     eventfd/kaio integration fix
has been added to the -mm tree.  Its filename is
     eventfd-kaio-integration-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eventfd/kaio integration fix
From: Davide Libenzi <davidel@xmailserver.org>

Jeff Roberson discovered a race when using kaio eventfd based notifications. 
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

eventfd-kaio-integration-fix.patch
epoll-avoid-kmemcheck-warning.patch
fs-timerfdc-should-include-linux-syscallsh.patch
signals-send_signal-be-paranoid-about-signalfd_notify.patch

