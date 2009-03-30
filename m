From: akpm@linux-foundation.org
Subject: [merged] aio-lookup_ioctx-can-return-the-wrong-value-when-looking-up-a-bogus-context.patch removed from -mm tree
Date: Mon, 30 Mar 2009 01:01:14 -0700
Message-ID: <200903300801.n2U81EbJ017347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425AbZC3IGK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 04:06:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmoyer@redhat.com, bcrl@kvack.org, jens.axboe@oracle.com, stable@kernel.org, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio: lookup_ioctx can return the wrong value when looking up a bogus context
has been removed from the -mm tree.  Its filename was
     aio-lookup_ioctx-can-return-the-wrong-value-when-looking-up-a-bogus-context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aio: lookup_ioctx can return the wrong value when looking up a bogus context
From: Jeff Moyer <jmoyer@redhat.com>

The libaio test harness turned up a problem whereby lookup_ioctx on a bogus io
context was returning the 1 valid io context from the list
(harness/cases/3.p).  Because of that, an extra put_iocontext was done, and
when the process exited, it hit a BUG_ON in the put_iocontext macro called
from exit_aio (since we expect a users count of 1 and instead get 0).

The problem was introduced by:

commit abf137dd7712132ee56d5b3143c2ff61a72a5faa
aio: make the lookup_ioctx() lockless

Thanks to Zach for pointing out that hlist_for_each_entry_rcu will not return
with a NULL tpos at the end of the loop, even if the entry was not found.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Zach Brown <zach.brown@oracle.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/aio.c~aio-lookup_ioctx-can-return-the-wrong-value-when-looking-up-a-bogus-context fs/aio.c
--- a/fs/aio.c~aio-lookup_ioctx-can-return-the-wrong-value-when-looking-up-a-bogus-context
+++ a/fs/aio.c
@@ -587,7 +587,7 @@ int aio_put_req(struct kiocb *req)
 static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 {
 	struct mm_struct *mm = current->mm;
-	struct kioctx *ctx = NULL;
+	struct kioctx *ctx, *ret = NULL;
 	struct hlist_node *n;
 
 	rcu_read_lock();
@@ -595,12 +595,13 @@ static struct kioctx *lookup_ioctx(unsig
 	hlist_for_each_entry_rcu(ctx, n, &mm->ioctx_list, list) {
 		if (ctx->user_id == ctx_id && !ctx->dead) {
 			get_ioctx(ctx);
+			ret = ctx;
 			break;
 		}
 	}
 
 	rcu_read_unlock();
-	return ctx;
+	return ret;
 }
 
 /*
_

Patches currently in -mm which might be from jmoyer@redhat.com are

autofs4-cleanup-expire-code-duplication.patch

