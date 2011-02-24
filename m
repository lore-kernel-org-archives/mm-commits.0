From: akpm@linux-foundation.org
Subject: + aio-fix-rcu-ioctx-lookup.patch added to -mm tree
Date: Wed, 23 Feb 2011 16:20:51 -0800
Message-ID: <201102240020.p1O0Kpr6000837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755328Ab1BXAVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Feb 2011 19:21:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@gmail.com, jack@suse.cz, jmoyer@redhat.com, npiggin@kernel.dk


The patch titled
     aio: fix rcu ioctx lookup
has been added to the -mm tree.  Its filename is
     aio-fix-rcu-ioctx-lookup.patch

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
Subject: aio: fix rcu ioctx lookup
From: Nick Piggin <npiggin@gmail.com>

aio-dio-invalidate-failure GPFs in aio_put_req from io_submit.

lookup_ioctx doesn't implement the rcu lookup pattern properly. 
rcu_read_lock does not prevent refcount going to zero, so we might take a
refcount on a zero count ioctx.

Fix the bug by atomically testing for zero refcount before incrementing.

[jack@suse.cz: added comment into the code]
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Nick Piggin <npiggin@kernel.dk>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff -puN fs/aio.c~aio-fix-rcu-ioctx-lookup fs/aio.c
--- a/fs/aio.c~aio-fix-rcu-ioctx-lookup
+++ a/fs/aio.c
@@ -239,15 +239,23 @@ static void __put_ioctx(struct kioctx *c
 	call_rcu(&ctx->rcu_head, ctx_rcu_free);
 }
 
-#define get_ioctx(kioctx) do {						\
-	BUG_ON(atomic_read(&(kioctx)->users) <= 0);			\
-	atomic_inc(&(kioctx)->users);					\
-} while (0)
-#define put_ioctx(kioctx) do {						\
-	BUG_ON(atomic_read(&(kioctx)->users) <= 0);			\
-	if (unlikely(atomic_dec_and_test(&(kioctx)->users))) 		\
-		__put_ioctx(kioctx);					\
-} while (0)
+static inline void get_ioctx(struct kioctx *kioctx)
+{
+	BUG_ON(atomic_read(&kioctx->users) <= 0);
+	atomic_inc(&kioctx->users);
+}
+
+static inline int try_get_ioctx(struct kioctx *kioctx)
+{
+	return atomic_inc_not_zero(&kioctx->users);
+}
+
+static inline void put_ioctx(struct kioctx *kioctx)
+{
+	BUG_ON(atomic_read(&kioctx->users) <= 0);
+	if (unlikely(atomic_dec_and_test(&kioctx->users)))
+		__put_ioctx(kioctx);
+}
 
 /* ioctx_alloc
  *	Allocates and initializes an ioctx.  Returns an ERR_PTR if it failed.
@@ -601,8 +609,13 @@ static struct kioctx *lookup_ioctx(unsig
 	rcu_read_lock();
 
 	hlist_for_each_entry_rcu(ctx, n, &mm->ioctx_list, list) {
-		if (ctx->user_id == ctx_id && !ctx->dead) {
-			get_ioctx(ctx);
+		/*
+		 * RCU protects us against accessing freed memory but
+		 * we have to be careful not to get a reference when the
+		 * reference count already dropped to 0 (ctx->dead test
+		 * is unreliable because of races).
+		 */
+		if (ctx->user_id == ctx_id && !ctx->dead && try_get_ioctx(ctx)){
 			ret = ctx;
 			break;
 		}
_

Patches currently in -mm which might be from npiggin@gmail.com are

linux-next.patch
aio-fix-rcu-ioctx-lookup.patch

