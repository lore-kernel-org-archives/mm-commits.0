From: akpm@linux-foundation.org
Subject: +
 fsnotify-destroy-marks-with-call_srcu-instead-of-dedicated-thread.patch
 added to -mm tree
Date: Thu, 19 Nov 2015 12:15:30 -0800
Message-ID: <564e2de2.gZTjkQU9NZ1lYhyO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030201AbbKSUPb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Nov 2015 15:15:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@poochiereds.net, eparis@parisplace.org, jack@suse.com, jeff.layton@primarydata.com, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: destroy marks with call_srcu instead of dedicated thread
has been added to the -mm tree.  Its filename is
     fsnotify-destroy-marks-with-call_srcu-instead-of-dedicated-thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsnotify-destroy-marks-with-call_srcu-instead-of-dedicated-thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsnotify-destroy-marks-with-call_srcu-instead-of-dedicated-thread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeff Layton <jlayton@poochiereds.net>
Subject: fsnotify: destroy marks with call_srcu instead of dedicated thread

At the time that this code was originally written, call_srcu didn't exist,
so this thread was required to ensure that we waited for that SRCU grace
period to settle before finally freeing the object.

It does exist now however and we can much more efficiently use call_srcu
to handle this.  That also allows us to potentially use srcu_barrier to
ensure that they are all of the callbacks have run before proceeding.  In
order to conserve space, we union the rcu_head with the g_list.

This will be necessary for nfsd which will allocate marks from a dedicated
slabcache.  We have to be able to ensure that all of the objects are
destroyed before destroying the cache.  That's fairly

Signed-off-by: Jeff Layton <jeff.layton@primarydata.com>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Jan Kara <jack@suse.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/mark.c                 |   66 ++++++-----------------------
 include/linux/fsnotify_backend.h |    5 +-
 2 files changed, 18 insertions(+), 53 deletions(-)

diff -puN fs/notify/mark.c~fsnotify-destroy-marks-with-call_srcu-instead-of-dedicated-thread fs/notify/mark.c
--- a/fs/notify/mark.c~fsnotify-destroy-marks-with-call_srcu-instead-of-dedicated-thread
+++ a/fs/notify/mark.c
@@ -92,9 +92,6 @@
 #include "fsnotify.h"
 
 struct srcu_struct fsnotify_mark_srcu;
-static DEFINE_SPINLOCK(destroy_lock);
-static LIST_HEAD(destroy_list);
-static DECLARE_WAIT_QUEUE_HEAD(destroy_waitq);
 
 void fsnotify_get_mark(struct fsnotify_mark *mark)
 {
@@ -168,10 +165,19 @@ void fsnotify_detach_mark(struct fsnotif
 	atomic_dec(&group->num_marks);
 }
 
+static void
+fsnotify_mark_free_rcu(struct rcu_head *rcu)
+{
+	struct fsnotify_mark	*mark;
+
+	mark = container_of(rcu, struct fsnotify_mark, g_rcu);
+	fsnotify_put_mark(mark);
+}
+
 /*
- * Free fsnotify mark. The freeing is actually happening from a kthread which
- * first waits for srcu period end. Caller must have a reference to the mark
- * or be protected by fsnotify_mark_srcu.
+ * Free fsnotify mark. The freeing is actually happening from a call_srcu
+ * callback. Caller must have a reference to the mark or be protected by
+ * fsnotify_mark_srcu.
  */
 void fsnotify_free_mark(struct fsnotify_mark *mark)
 {
@@ -186,10 +192,7 @@ void fsnotify_free_mark(struct fsnotify_
 	mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
 	spin_unlock(&mark->lock);
 
-	spin_lock(&destroy_lock);
-	list_add(&mark->g_list, &destroy_list);
-	spin_unlock(&destroy_lock);
-	wake_up(&destroy_waitq);
+	call_srcu(&fsnotify_mark_srcu, &mark->g_rcu, fsnotify_mark_free_rcu);
 
 	/*
 	 * Some groups like to know that marks are being freed.  This is a
@@ -385,11 +388,7 @@ err:
 
 	spin_unlock(&mark->lock);
 
-	spin_lock(&destroy_lock);
-	list_add(&mark->g_list, &destroy_list);
-	spin_unlock(&destroy_lock);
-	wake_up(&destroy_waitq);
-
+	call_srcu(&fsnotify_mark_srcu, &mark->g_rcu, fsnotify_mark_free_rcu);
 	return ret;
 }
 
@@ -492,40 +491,3 @@ void fsnotify_init_mark(struct fsnotify_
 	atomic_set(&mark->refcnt, 1);
 	mark->free_mark = free_mark;
 }
-
-static int fsnotify_mark_destroy(void *ignored)
-{
-	struct fsnotify_mark *mark, *next;
-	struct list_head private_destroy_list;
-
-	for (;;) {
-		spin_lock(&destroy_lock);
-		/* exchange the list head */
-		list_replace_init(&destroy_list, &private_destroy_list);
-		spin_unlock(&destroy_lock);
-
-		synchronize_srcu(&fsnotify_mark_srcu);
-
-		list_for_each_entry_safe(mark, next, &private_destroy_list, g_list) {
-			list_del_init(&mark->g_list);
-			fsnotify_put_mark(mark);
-		}
-
-		wait_event_interruptible(destroy_waitq, !list_empty(&destroy_list));
-	}
-
-	return 0;
-}
-
-static int __init fsnotify_mark_init(void)
-{
-	struct task_struct *thread;
-
-	thread = kthread_run(fsnotify_mark_destroy, NULL,
-			     "fsnotify_mark");
-	if (IS_ERR(thread))
-		panic("unable to start fsnotify mark destruction thread.");
