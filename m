From: akpm@linux-foundation.org
Subject: + aio-wake-all-waiters-when-destroying-ctx.patch added to -mm tree
Date: Fri, 11 Mar 2011 16:52:09 -0800
Message-ID: <201103120052.p2C0q9jX005762@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752768Ab1CLAxJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Mar 2011 19:53:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@purestorage.com, jmoyer@redhat.com, stable@kernel.org


The patch titled
     aio: wake all waiters when destroying ctx
has been added to the -mm tree.  Its filename is
     aio-wake-all-waiters-when-destroying-ctx.patch

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
Subject: aio: wake all waiters when destroying ctx
From: Roland Dreier <roland@purestorage.com>

The test program below will hang because io_getevents() uses
add_wait_queue_exclusive(), which means the wake_up() in io_destroy() only
wakes up one of the threads.  Fix this by using wake_up_all() in the aio
code paths where we want to make sure no one gets stuck.

	// t.c -- compile with gcc -lpthread -laio t.c

	#include <libaio.h>
	#include <pthread.h>
	#include <stdio.h>
	#include <unistd.h>

	static const int nthr = 2;

	void *getev(void *ctx)
	{
		struct io_event ev;
		io_getevents(ctx, 1, 1, &ev, NULL);
		printf("io_getevents returned\n");
		return NULL;
	}

	int main(int argc, char *argv[])
	{
		io_context_t ctx = 0;
		pthread_t thread[nthr];
		int i;

		io_setup(1024, &ctx);

		for (i = 0; i < nthr; ++i)
			pthread_create(&thread[i], NULL, getev, ctx);

		sleep(1);

		io_destroy(ctx);

		for (i = 0; i < nthr; ++i)
			pthread_join(thread[i], NULL);

		return 0;
	}

Signed-off-by: Roland Dreier <roland@purestorage.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/aio.c~aio-wake-all-waiters-when-destroying-ctx fs/aio.c
--- a/fs/aio.c~aio-wake-all-waiters-when-destroying-ctx
+++ a/fs/aio.c
@@ -509,7 +509,7 @@ static inline void really_put_req(struct
 	ctx->reqs_active--;
 
 	if (unlikely(!ctx->reqs_active && ctx->dead))
-		wake_up(&ctx->wait);
+		wake_up_all(&ctx->wait);
 }
 
 static void aio_fput_routine(struct work_struct *data)
@@ -1218,7 +1218,7 @@ static void io_destroy(struct kioctx *io
 	 * by other CPUs at this point.  Right now, we rely on the
 	 * locking done by the above calls to ensure this consistency.
 	 */
-	wake_up(&ioctx->wait);
+	wake_up_all(&ioctx->wait);
 	put_ioctx(ioctx);	/* once for the lookup */
 }
 
_

Patches currently in -mm which might be from roland@purestorage.com are

linux-next.patch
aio-wake-all-waiters-when-destroying-ctx.patch

