From: akpm@linux-foundation.org
Subject: + aio-percpu-ioctx-refcount.patch added to -mm tree
Date: Thu, 03 Jan 2013 15:41:08 -0800
Message-ID: <20130103234109.608A082004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:61293 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab3ACXlL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jan 2013 18:41:11 -0500
Received: by mail-gg0-f201.google.com with SMTP id o6so1692788ggm.2
        for <mm-commits@vger.kernel.org>; Thu, 03 Jan 2013 15:41:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, viro@zeniv.linux.org.uk, zab@redhat.com


The patch titled
     Subject: aio: percpu ioctx refcount
has been added to the -mm tree.  Its filename is
     aio-percpu-ioctx-refcount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -340,7 +340,7 @@ static void free_ioctx(struct kioctx *ct
 
 static void put_ioctx(struct kioctx *ctx)
 {
-	if (unlikely(atomic_dec_and_test(&ctx->users)))
+	if (percpu_ref_put(&ctx->users))
 		free_ioctx(ctx);
 }
 
@@ -369,8 +369,11 @@ static struct kioctx *ioctx_alloc(unsign
 
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
@@ -442,7 +445,7 @@ static void kill_ioctx_rcu(struct rcu_he
  */
 static void kill_ioctx(struct kioctx *ctx)
 {
-	if (!atomic_xchg(&ctx->dead, 1)) {
+	if (percpu_ref_kill(&ctx->users)) {
 		hlist_del_rcu(&ctx->list);
 		/* Between hlist_del_rcu() and dropping the initial ref */
 		synchronize_rcu();
@@ -488,12 +491,6 @@ void exit_aio(struct mm_struct *mm)
 	struct hlist_node *p, *n;
 
 	hlist_for_each_entry_safe(ctx, p, n, &mm->ioctx_list, list) {
-		if (1 != atomic_read(&ctx->users))
-			printk(KERN_DEBUG
-				"exit_aio:ioctx still alive: %d %d %d\n",
-				atomic_read(&ctx->users),
-				atomic_read(&ctx->dead),
-				atomic_read(&ctx->reqs_available));
 		/*
 		 * We don't need to bother with munmap() here -
 		 * exit_mmap(mm) is coming and it'll unmap everything.
@@ -504,7 +501,7 @@ void exit_aio(struct mm_struct *mm)
 		 */
 		ctx->mmap_size = 0;
 
-		if (!atomic_xchg(&ctx->dead, 1)) {
+		if (percpu_ref_kill(&ctx->users)) {
 			hlist_del_rcu(&ctx->list);
 			call_rcu(&ctx->rcu_head, kill_ioctx_rcu);
 		}
@@ -616,7 +613,7 @@ static struct kioctx *lookup_ioctx(unsig
 
 	hlist_for_each_entry_rcu(ctx, n, &mm->ioctx_list, list)
 		if (ctx->user_id == ctx_id){
-			atomic_inc(&ctx->users);
+			percpu_ref_get(&ctx->users);
 			ret = ctx;
 			break;
 		}
@@ -830,7 +827,7 @@ static bool aio_read_events(struct kioct
 	if (ret > 0)
 		*i += ret;
 
-	if (unlikely(atomic_read(&ctx->dead)))
+	if (unlikely(percpu_ref_dead(&ctx->users)))
 		ret = -EINVAL;
 
 	if (!*i)
_

Patches currently in -mm which might be from koverstreet@google.com are

mm-remove-old-aio-use_mm-comment.patch
aio-remove-dead-code-from-aioh.patch
gadget-remove-only-user-of-aio-retry.patch
aio-remove-retry-based-aio.patch
char-add-aio_readwrite-to-dev-nullzero.patch
aio-kill-return-value-of-aio_complete.patch
aio-kiocb_cancel.patch
aio-move-private-stuff-out-of-aioh.patch
aio-dprintk-pr_debug.patch
aio-do-fget-after-aio_get_req.patch
aio-make-aio_put_req-lockless.patch
aio-refcounting-cleanup.patch
wait-add-wait_event_hrtimeout.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-use-flush_dcache_page.patch
aio-use-cancellation-list-lazily.patch
aio-change-reqs_active-to-include-unreaped-completions.patch
aio-kill-batch-allocation.patch
aio-kill-struct-aio_ring_info.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-smoosh-struct-kiocb.patch

