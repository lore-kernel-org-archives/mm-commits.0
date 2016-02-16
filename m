From: akpm@linux-foundation.org
Subject: +
 revert-fsnotify-destroy-marks-with-call_srcu-instead-of-dedicated-thread.patch added to -mm tree
Date: Tue, 16 Feb 2016 13:06:13 -0800
Message-ID: <56c38f45.CpHDN1qdaecj1+vA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964850AbcBPVGO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Feb 2016 16:06:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@poochiereds.net, eparis@parisplace.org, guaneryu@gmail.com, jack@suse.com, jeff.layton@primarydata.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "fsnotify: destroy marks with call_srcu instead of dedicated thread"
has been added to the -mm tree.  Its filename is
     revert-fsnotify-destroy-marks-with-call_srcu-instead-of-dedicated-thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-fsnotify-destroy-marks-with-call_srcu-instead-of-dedicated-thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-fsnotify-destroy-marks-with-call_srcu-instead-of-dedicated-thread.patch

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
Subject: Revert "fsnotify: destroy marks with call_srcu instead of dedicated thread"

This reverts c510eff6bebaa244e ("fsnotify: destroy marks with call_srcu
instead of dedicated thread").

Eryu reported that he was seeing some OOM kills kick in when running a
testcase that adds and removes inotify marks on a file in a tight loop.

The above commit changed the code to use call_srcu to clean up the marks. 
While that does (in principle) work, the srcu callback job is limited to
cleaning up entries in small batches and only once per jiffy.  It's easily
possible to overwhelm that machinery with too many call_srcu callbacks,
and Eryu's reproduer did just that.

There's also another potential problem with using call_srcu here.  While
you can obviously sleep while holding the srcu_read_lock, the callbacks
run under local_bh_disable, so you can't sleep there.

It's possible when putting the last reference to the fsnotify_mark that
we'll end up putting a chain of references including the fsnotify_group,
uid, and associated keys.  While I don't see any obvious ways that that
could occurs, it's probably still best to avoid using call_srcu here after
all.

This patch reverts the above patch.  A later patch will take a different
approach to eliminated the dedicated thread here.

Signed-off-by: Jeff Layton <jeff.layton@primarydata.com>
Reported-by: Eryu Guan <guaneryu@gmail.com>
Cc: Jan Kara <jack@suse.com>
Cc: Eric Paris <eparis@parisplace.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/mark.c                 |   66 ++++++++++++++++++++++-------
 include/linux/fsnotify_backend.h |    5 --
 2 files changed, 53 insertions(+), 18 deletions(-)

diff -puN fs/notify/mark.c~revert-fsnotify-destroy-marks-with-call_srcu-instead-of-dedicated-thread fs/notify/mark.c
--- a/fs/notify/mark.c~revert-fsnotify-destroy-marks-with-call_srcu-instead-of-dedicated-thread
+++ a/fs/notify/mark.c
@@ -92,6 +92,9 @@
 #include "fsnotify.h"
 
 struct srcu_struct fsnotify_mark_srcu;
+static DEFINE_SPINLOCK(destroy_lock);
+static LIST_HEAD(destroy_list);
+static DECLARE_WAIT_QUEUE_HEAD(destroy_waitq);
 
 void fsnotify_get_mark(struct fsnotify_mark *mark)
 {
@@ -165,19 +168,10 @@ void fsnotify_detach_mark(struct fsnotif
 	atomic_dec(&group->num_marks);
 }
 
-static void
-fsnotify_mark_free_rcu(struct rcu_head *rcu)
-{
-	struct fsnotify_mark	*mark;
-
-	mark = container_of(rcu, struct fsnotify_mark, g_rcu);
-	fsnotify_put_mark(mark);
-}
-
 /*
- * Free fsnotify mark. The freeing is actually happening from a call_srcu
- * callback. Caller must have a reference to the mark or be protected by
- * fsnotify_mark_srcu.
+ * Free fsnotify mark. The freeing is actually happening from a kthread which
+ * first waits for srcu period end. Caller must have a reference to the mark
+ * or be protected by fsnotify_mark_srcu.
  */
 void fsnotify_free_mark(struct fsnotify_mark *mark)
 {
@@ -192,7 +186,10 @@ void fsnotify_free_mark(struct fsnotify_
 	mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
 	spin_unlock(&mark->lock);
 
-	call_srcu(&fsnotify_mark_srcu, &mark->g_rcu, fsnotify_mark_free_rcu);
+	spin_lock(&destroy_lock);
+	list_add(&mark->g_list, &destroy_list);
+	spin_unlock(&destroy_lock);
+	wake_up(&destroy_waitq);
 
 	/*
 	 * Some groups like to know that marks are being freed.  This is a
@@ -388,7 +385,11 @@ err:
 
 	spin_unlock(&mark->lock);
 
-	call_srcu(&fsnotify_mark_srcu, &mark->g_rcu, fsnotify_mark_free_rcu);
+	spin_lock(&destroy_lock);
+	list_add(&mark->g_list, &destroy_list);
+	spin_unlock(&destroy_lock);
+	wake_up(&destroy_waitq);
+
 	return ret;
 }
 
@@ -491,3 +492,40 @@ void fsnotify_init_mark(struct fsnotify_
 	atomic_set(&mark->refcnt, 1);
 	mark->free_mark = free_mark;
 }
+
+static int fsnotify_mark_destroy(void *ignored)
+{
+	struct fsnotify_mark *mark, *next;
+	struct list_head private_destroy_list;
+
+	for (;;) {
+		spin_lock(&destroy_lock);
+		/* exchange the list head */
+		list_replace_init(&destroy_list, &private_destroy_list);
+		spin_unlock(&destroy_lock);
+
+		synchronize_srcu(&fsnotify_mark_srcu);
+
+		list_for_each_entry_safe(mark, next, &private_destroy_list, g_list) {
+			list_del_init(&mark->g_list);
+			fsnotify_put_mark(mark);
+		}
+
+		wait_event_interruptible(destroy_waitq, !list_empty(&destroy_list));
+	}
+
+	return 0;
+}
+
+static int __init fsnotify_mark_init(void)
+{
+	struct task_struct *thread;
+
+	thread = kthread_run(fsnotify_mark_destroy, NULL,
+			     "fsnotify_mark");
+	if (IS_ERR(thread))
+		panic("unable to start fsnotify mark destruction thread.");
+
+	return 0;
+}
+device_initcall(fsnotify_mark_init);
diff -puN include/linux/fsnotify_backend.h~revert-fsnotify-destroy-marks-with-call_srcu-instead-of-dedicated-thread include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~revert-fsnotify-destroy-marks-with-call_srcu-instead-of-dedicated-thread
+++ a/include/linux/fsnotify_backend.h
@@ -220,10 +220,7 @@ struct fsnotify_mark {
 	/* List of marks by group->i_fsnotify_marks. Also reused for queueing
 	 * mark into destroy_list when it's waiting for the end of SRCU period
 	 * before it can be freed. [group->mark_mutex] */
-	union {
-		struct list_head g_list;
-		struct rcu_head g_rcu;
-	};
+	struct list_head g_list;
 	/* Protects inode / mnt pointers, flags, masks */
 	spinlock_t lock;
 	/* List of marks for inode / vfsmount [obj_lock] */
_

Patches currently in -mm which might be from jlayton@poochiereds.net are

revert-fsnotify-destroy-marks-with-call_srcu-instead-of-dedicated-thread.patch
fsnotify-turn-fsnotify-reaper-thread-into-a-workqueue-job.patch

