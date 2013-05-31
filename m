From: akpm@linux-foundation.org
Subject: + aio-use-call_rcu-instead-of-synchronize_rcu-in-kill_ioctx.patch added to -mm tree
Date: Fri, 31 May 2013 12:40:53 -0700
Message-ID: <51a8fcc5.UopgST5apNaW6+JG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab3EaTky (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 15:40:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zab@redhat.com, viro@zeniv.linux.org.uk, smani@micron.com, sbradshaw@micron.com, rusty@rustcorp.com.au, mfasheh@suse.com, jmoyer@redhat.com, jlbec@evilplan.org, gregkh@linuxfoundation.org, bcrl@kvack.org, balbi@ti.com, axboe@kernel.dk, asamymuthupa@micron.com, koverstreet@google.com

Subject: + aio-use-call_rcu-instead-of-synchronize_rcu-in-kill_ioctx.patch added to -mm tree
To: koverstreet@google.com,asamymuthupa@micron.com,axboe@kernel.dk,balbi@ti.com,bcrl@kvack.org,gregkh@linuxfoundation.org,jlbec@evilplan.org,jmoyer@redhat.com,mfasheh@suse.com,rusty@rustcorp.com.au,sbradshaw@micron.com,smani@micron.com,viro@zeniv.linux.org.uk,zab@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 12:40:53 -0700


The patch titled
     Subject: aio: Use call_rcu() instead of synchronize_rcu() in kill_ioctx()
has been added to the -mm tree.  Its filename is
     aio-use-call_rcu-instead-of-synchronize_rcu-in-kill_ioctx.patch

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
Subject: aio: Use call_rcu() instead of synchronize_rcu() in kill_ioctx()

Just making ioctx shutdown asynchronous so as not to block io_destroy()
- and percpu refcounts for the ioctx are going to need a RCU barrier in
the same place anyways.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
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

linux-next.patch
aio-use-call_rcu-instead-of-synchronize_rcu-in-kill_ioctx.patch

