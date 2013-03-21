From: akpm@linux-foundation.org
Subject: [to-be-updated] aio-percpu-ioctx-refcount.patch removed from -mm tree
Date: Thu, 21 Mar 2013 15:28:50 -0700
Message-ID: <20130321222850.A542F5A42C5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:56992 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab3CUW2w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:28:52 -0400
Received: by mail-vc0-f201.google.com with SMTP id hf12so310590vcb.2
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:28:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: percpu ioctx refcount
has been removed from the -mm tree.  Its filename was
     aio-percpu-ioctx-refcount.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio: percpu ioctx refcount

This just converts the ioctx refcount to the new generic dynamic percpu
refcount code.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff -puN fs/aio.c~aio-percpu-ioctx-refcount fs/aio.c
--- a/fs/aio.c~aio-percpu-ioctx-refcount
+++ a/fs/aio.c
@@ -36,6 +36,7 @@
 #include <linux/eventfd.h>
 #include <linux/blkdev.h>
 #include <linux/compat.h>
+#include <linux/percpu-refcount.h>
 
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
@@ -65,8 +66,7 @@ struct kioctx_cpu {
 };
 
 struct kioctx {
-	atomic_t		users;
-	atomic_t		dead;
+	struct percpu_ref	users;
 
 	/* This needs improving */
 	unsigned long		user_id;
@@ -353,7 +353,7 @@ static void free_ioctx(struct kioctx *ct
 
 static void put_ioctx(struct kioctx *ctx)
 {
-	if (unlikely(atomic_dec_and_test(&ctx->users)))
+	if (percpu_ref_put(&ctx->users))
 		free_ioctx(ctx);
 }
 
@@ -382,8 +382,11 @@ static struct kioctx *ioctx_alloc(unsign
 
 	ctx->max_reqs = nr_events;
 
-	atomic_set(&ctx->users, 2);
-	atomic_set(&ctx->dead, 0);
+	percpu_ref_init(&ctx->users);
+	rcu_read_lock();
+	percpu_ref_get(&ctx->users);
+	rcu_read_unlock();
+
 	spin_lock_init(&ctx->ctx_lock);
 	spin_lock_init(&ctx->completion_lock);
 	mutex_init(&ctx->ring_lock);
@@ -455,7 +458,7 @@ static void kill_ioctx_rcu(struct rcu_he
  */
 static void kill_ioctx(struct kioctx *ctx)
 {
-	if (!atomic_xchg(&ctx->dead, 1)) {
+	if (percpu_ref_kill(&ctx->users)) {
 		hlist_del_rcu(&ctx->list);
 		/* Between hlist_del_rcu() and dropping the initial ref */
 		synchronize_rcu();
@@ -501,12 +504,6 @@ void exit_aio(struct mm_struct *mm)
 	struct hlist_node *n;
 
 	hlist_for_each_entry_safe(ctx, n, &mm->ioctx_list, list) {
-		if (1 != atomic_read(&ctx->users))
-			printk(KERN_DEBUG
-				"exit_aio:ioctx still alive: %d %d %d\n",
-				atomic_read(&ctx->users),
-				atomic_read(&ctx->dead),
-				atomic_read(&ctx->reqs_available));
 		/*
 		 * We don't need to bother with munmap() here -
 		 * exit_mmap(mm) is coming and it'll unmap everything.
@@ -517,7 +514,7 @@ void exit_aio(struct mm_struct *mm)
 		 */
 		ctx->mmap_size = 0;
 
-		if (!atomic_xchg(&ctx->dead, 1)) {
+		if (percpu_ref_kill(&ctx->users)) {
 			hlist_del_rcu(&ctx->list);
 			call_rcu(&ctx->rcu_head, kill_ioctx_rcu);
 		}
@@ -628,7 +625,7 @@ static struct kioctx *lookup_ioctx(unsig
 
 	hlist_for_each_entry_rcu(ctx, &mm->ioctx_list, list) {
 		if (ctx->user_id == ctx_id){
-			atomic_inc(&ctx->users);
+			percpu_ref_get(&ctx->users);
 			ret = ctx;
 			break;
 		}
@@ -843,7 +840,7 @@ static bool aio_read_events(struct kioct
 	if (ret > 0)
 		*i += ret;
 
-	if (unlikely(atomic_read(&ctx->dead)))
+	if (unlikely(percpu_ref_dead(&ctx->users)))
 		ret = -EINVAL;
 
 	if (!*i)
_

Patches currently in -mm which might be from koverstreet@google.com are

aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-aio_read_events_ring-types.patch
aio-document-clarify-aio_read_events-and-shadow_tail.patch
aio-correct-calculation-of-available-events.patch
aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
aio-fix-ringbuffer-calculation-so-we-dont-wrap.patch

