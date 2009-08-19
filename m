From: akpm@linux-foundation.org
Subject: + aioc-move-export-macros-to-line-after-function.patch added to -mm tree
Date: Wed, 19 Aug 2009 14:51:49 -0700
Message-ID: <200908192151.n7JLpncI020399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001AbZHSVwL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Aug 2009 17:52:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, bcrl@kvack.org, hsweeten@visionengravers.com, zach.brown@oracle.com


The patch titled
     aio.c: move EXPORT* macros to line after function
has been added to the -mm tree.  Its filename is
     aioc-move-export-macros-to-line-after-function.patch

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
@@ -1037,6 +1040,7 @@ put_rq:
 	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL(aio_complete);
 
 /* aio_read_evt
  *	Pull an event off of the ioctx's event ring.  Returns the number of 
@@ -1825,9 +1829,3 @@ SYSCALL_DEFINE5(io_getevents, aio_contex
 	asmlinkage_protect(5, ret, ctx_id, min_nr, nr, events, timeout);
 	return ret;
 }
-
-__initcall(aio_setup);
