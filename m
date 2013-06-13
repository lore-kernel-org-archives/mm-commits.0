From: akpm@linux-foundation.org
Subject: [merged]
 aio-use-call_rcu-instead-of-synchronize_rcu-in-kill_ioctx.patch removed
 from -mm tree
Date: Thu, 13 Jun 2013 11:57:58 -0700
Message-ID: <51ba1636.wbyo7Y2QQ5nLLuXQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab3FMS57 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:57:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zab@redhat.com, viro@zeniv.linux.org.uk, smani@micron.com, sbradshaw@micron.com, rusty@rustcorp.com.au, mfasheh@suse.com, jmoyer@redhat.com, jlbec@evilplan.org, gregkh@linuxfoundation.org, bcrl@kvack.org, balbi@ti.com, axboe@kernel.dk, asamymuthupa@micron.com, koverstreet@google.com

Subject: [merged] aio-use-call_rcu-instead-of-synchronize_rcu-in-kill_ioctx.patch removed from -mm tree
To: koverstreet@google.com,asamymuthupa@micron.com,axboe@kernel.dk,balbi@ti.com,bcrl@kvack.org,gregkh@linuxfoundation.org,jlbec@evilplan.org,jmoyer@redhat.com,mfasheh@suse.com,rusty@rustcorp.com.au,sbradshaw@micron.com,smani@micron.com,viro@zeniv.linux.org.uk,zab@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:57:58 -0700


The patch titled
     Subject: aio: fix io_destroy() regression by using call_rcu()
has been removed from the -mm tree.  Its filename was
     aio-use-call_rcu-instead-of-synchronize_rcu-in-kill_ioctx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio: fix io_destroy() regression by using call_rcu()

There was a regression introduced by 36f5588 ("aio: refcounting cleanup"),
reported by Jens Axboe - the refcounting cleanup switched to using RCU in
the shutdown path, but the synchronize_rcu() was done in the context of
the io_destroy() syscall greatly increasing the time it could block.

This patch switches it to call_rcu() and makes shutdown asynchronous (more
asynchronous than it was originally; before the refcount changes
io_destroy() would still wait on pending kiocbs).

Note that there's a global quota on the max outstanding kiocbs, and that
quota must be manipulated synchronously; otherwise io_setup() could return
-EAGAIN when there isn't quota available, and userspace won't have any way
of waiting until shutdown of the old kioctxs has finished (besides busy
looping).

So we release our quota before kioctx shutdown has finished, which should
be fine since the quota never corresponded to anything real anyways.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Reported-by: Jens Axboe <axboe@kernel.dk>
Tested-by: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Tested-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff -puN fs/aio.c~aio-use-call_rcu-instead-of-synchronize_rcu-in-kill_ioctx fs/aio.c
--- a/fs/aio.c~aio-use-call_rcu-instead-of-synchronize_rcu-in-kill_ioctx
+++ a/fs/aio.c
@@ -141,9 +141,6 @@ static void aio_free_ring(struct kioctx
 	for (i = 0; i < ctx->nr_pages; i++)
 		put_page(ctx->ring_pages[i]);
 
-	if (ctx->mmap_size)
-		vm_munmap(ctx->mmap_base, ctx->mmap_size);
-
 	if (ctx->ring_pages && ctx->ring_pages != ctx->internal_pages)
 		kfree(ctx->ring_pages);
 }
@@ -322,11 +319,6 @@ static void free_ioctx(struct kioctx *ct
 
 	aio_free_ring(ctx);
 
-	spin_lock(&aio_nr_lock);
-	BUG_ON(aio_nr - ctx->max_reqs > aio_nr);
-	aio_nr -= ctx->max_reqs;
-	spin_unlock(&aio_nr_lock);
-
 	pr_debug("freeing %p\n", ctx);
 
 	/*
@@ -435,17 +427,24 @@ static void kill_ioctx(struct kioctx *ct
 {
 	if (!atomic_xchg(&ctx->dead, 1)) {
 		hlist_del_rcu(&ctx->list);
-		/* Between hlist_del_rcu() and dropping the initial ref */
-		synchronize_rcu();
 
 		/*
-		 * We can't punt to workqueue here because put_ioctx() ->
-		 * free_ioctx() will unmap the ringbuffer, and that has to be
-		 * done in the original process's context. kill_ioctx_rcu/work()
-		 * exist for exit_aio(), as in that path free_ioctx() won't do
-		 * the unmap.
+		 * It'd be more correct to do this in free_ioctx(), after all
+		 * the outstanding kiocbs have finished - but by then io_destroy
+		 * has already returned, so io_setup() could potentially return
+		 * -EAGAIN with no ioctxs actually in use (as far as userspace
+		 *  could tell).
 		 */
-		kill_ioctx_work(&ctx->rcu_work);
+		spin_lock(&aio_nr_lock);
+		BUG_ON(aio_nr - ctx->max_reqs > aio_nr);
+		aio_nr -= ctx->max_reqs;
+		spin_unlock(&aio_nr_lock);
+
+		if (ctx->mmap_size)
+			vm_munmap(ctx->mmap_base, ctx->mmap_size);
+
+		/* Between hlist_del_rcu() and dropping the initial ref */
+		call_rcu(&ctx->rcu_head, kill_ioctx_rcu);
 	}
 }
 
@@ -495,10 +494,7 @@ void exit_aio(struct mm_struct *mm)
 		 */
 		ctx->mmap_size = 0;
 
-		if (!atomic_xchg(&ctx->dead, 1)) {
-			hlist_del_rcu(&ctx->list);
-			call_rcu(&ctx->rcu_head, kill_ioctx_rcu);
-		}
+		kill_ioctx(ctx);
 	}
 }
 
_

Patches currently in -mm which might be from koverstreet@google.com are

origin.patch
linux-next.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch

