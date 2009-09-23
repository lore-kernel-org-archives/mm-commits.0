From: akpm@linux-foundation.org
Subject: [merged] aioc-move-export-macros-to-line-after-function.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:53:05 -0700
Message-ID: <200909231953.n8NJr5E7030456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753666AbZIWUAy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:00:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, bcrl@kvack.org, hsweeten@visionengravers.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio.c: move EXPORT* macros to line after function
has been removed from the -mm tree.  Its filename was
     aioc-move-export-macros-to-line-after-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aio.c: move EXPORT* macros to line after function
From: "H Hartley Sweeten" <hartleys@visionengravers.com>

As mentioned in Documentation/CodingStyle, move EXPORT* macro's
to the line immediately after the closing function brace line.

Also, move the __initcall() similarly.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN fs/aio.c~aioc-move-export-macros-to-line-after-function fs/aio.c
--- a/fs/aio.c~aioc-move-export-macros-to-line-after-function
+++ a/fs/aio.c
@@ -78,6 +78,7 @@ static int __init aio_setup(void)
 
 	return 0;
 }
+__initcall(aio_setup);
 
 static void aio_free_ring(struct kioctx *ctx)
 {
@@ -380,6 +381,7 @@ ssize_t wait_on_sync_kiocb(struct kiocb 
 	__set_current_state(TASK_RUNNING);
 	return iocb->ki_user_data;
 }
+EXPORT_SYMBOL(wait_on_sync_kiocb);
 
 /* exit_aio: called when the last user of mm goes away.  At this point, 
  * there is no way for any new requests to be submited or any of the 
@@ -573,6 +575,7 @@ int aio_put_req(struct kiocb *req)
 	spin_unlock_irq(&ctx->ctx_lock);
 	return ret;
 }
+EXPORT_SYMBOL(aio_put_req);
 
 static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 {
@@ -992,6 +995,7 @@ put_rq:
 	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL(aio_complete);
 
 /* aio_read_evt
  *	Pull an event off of the ioctx's event ring.  Returns the number of 
@@ -1780,9 +1784,3 @@ SYSCALL_DEFINE5(io_getevents, aio_contex
 	asmlinkage_protect(5, ret, ctx_id, min_nr, nr, events, timeout);
 	return ret;
 }
-
-__initcall(aio_setup);
