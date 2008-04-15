From: akpm@linux-foundation.org
Subject: + aio-io_getevents-should-return-if-io_destroy-is-invoked.patch added to -mm tree
Date: Tue, 15 Apr 2008 12:55:26 -0700
Message-ID: <200804151955.m3FJtQ0s012543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762385AbYDOT4G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 15:56:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmoyer@redhat.com, bcrl@kvack.org, x@xman.org, zach.brown@oracle.com


The patch titled
     aio: io_getevents() should return if io_destroy() is invoked
has been added to the -mm tree.  Its filename is
     aio-io_getevents-should-return-if-io_destroy-is-invoked.patch

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
Subject: aio: io_getevents() should return if io_destroy() is invoked
From: Jeff Moyer <jmoyer@redhat.com>

This patch wakes up a thread waiting in io_getevents if another thread
destroys the context.  This was tested using a small program that spawns a
thread to wait in io_getevents while the parent thread destroys the io context
and then waits for the getevents thread to exit.  Without this patch, the
program hangs indefinitely.  With the patch, the program exits as expected.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Christopher Smith <x@xman.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN fs/aio.c~aio-io_getevents-should-return-if-io_destroy-is-invoked fs/aio.c
--- a/fs/aio.c~aio-io_getevents-should-return-if-io_destroy-is-invoked
+++ a/fs/aio.c
@@ -1177,7 +1177,10 @@ retry:
 				break;
 			if (min_nr <= i)
 				break;
-			ret = 0;
+			if (unlikely(ctx->dead)) {
+				ret = -EINVAL;
+				break;
+			}
 			if (to.timed_out)	/* Only check after read evt */
 				break;
 			/* Try to only show up in io wait if there are ops
@@ -1242,6 +1245,13 @@ static void io_destroy(struct kioctx *io
 
 	aio_cancel_all(ioctx);
 	wait_for_all_aios(ioctx);
+
+	/*
+	 * Wake up any waiters.  The setting of ctx->dead must be seen
+	 * by other CPUs at this point.  Right now, we rely on the
+	 * locking done by the above calls to ensure this consistency.
+	 */
+	wake_up(&ioctx->wait);
 	put_ioctx(ioctx);	/* once for the lookup */
 }
 
_

Patches currently in -mm which might be from jmoyer@redhat.com are

aio-io_getevents-should-return-if-io_destroy-is-invoked.patch

