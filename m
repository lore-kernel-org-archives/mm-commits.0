From: akpm@linux-foundation.org
Subject: - aio-io_getevents-should-return-if-io_destroy-is-invoked.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:50:34 -0700
Message-ID: <200804282150.m3SLoYJw017485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964933AbYD1Vv6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:51:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmoyer@redhat.com, bcrl@kvack.org, stable@kernel.org, x@xman.org, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio: io_getevents() should return if io_destroy() is invoked
has been removed from the -mm tree.  Its filename was
     aio-io_getevents-should-return-if-io_destroy-is-invoked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN fs/aio.c~aio-io_getevents-should-return-if-io_destroy-is-invoked fs/aio.c
--- a/fs/aio.c~aio-io_getevents-should-return-if-io_destroy-is-invoked
+++ a/fs/aio.c
@@ -1166,7 +1166,10 @@ retry:
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
@@ -1231,6 +1234,13 @@ static void io_destroy(struct kioctx *io
 
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

origin.patch
aio-remove-misleading-comment-from-ioctx_lookup.patch

