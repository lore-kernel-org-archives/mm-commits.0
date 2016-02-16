From: akpm@linux-foundation.org
Subject: + fsnotify-turn-fsnotify-reaper-thread-into-a-workqueue-job.patch added to -mm tree
Date: Tue, 16 Feb 2016 13:06:15 -0800
Message-ID: <56c38f47.VQfbLvWLh1nRQSCo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964880AbcBPVGQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Feb 2016 16:06:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@poochiereds.net, eparis@parisplace.org, guaneryu@gmail.com, jack@suse.com, jeff.layton@primarydata.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: turn fsnotify reaper thread into a workqueue job
has been added to the -mm tree.  Its filename is
     fsnotify-turn-fsnotify-reaper-thread-into-a-workqueue-job.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsnotify-turn-fsnotify-reaper-thread-into-a-workqueue-job.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsnotify-turn-fsnotify-reaper-thread-into-a-workqueue-job.patch

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
Subject: fsnotify: turn fsnotify reaper thread into a workqueue job

We don't require a dedicated thread for fsnotify cleanup.  Switch it over
to a workqueue job instead that runs on the system_unbound_wq.

In the interest of not thrashing the queued job too often when there are a
lot of marks being removed, we delay the reaper job slightly when queueing
it, to allow several to gather on the list.

Signed-off-by: Jeff Layton <jeff.layton@primarydata.com>
Cc: Jan Kara <jack@suse.com>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Eryu Guan <guaneryu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/mark.c |   51 ++++++++++++++++-----------------------------
 1 file changed, 19 insertions(+), 32 deletions(-)

diff -puN fs/notify/mark.c~fsnotify-turn-fsnotify-reaper-thread-into-a-workqueue-job fs/notify/mark.c
--- a/fs/notify/mark.c~fsnotify-turn-fsnotify-reaper-thread-into-a-workqueue-job
+++ a/fs/notify/mark.c
@@ -91,10 +91,14 @@
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
 
+#define FSNOTIFY_REAPER_DELAY	(1)	/* 1 jiffy */
+
 struct srcu_struct fsnotify_mark_srcu;
 static DEFINE_SPINLOCK(destroy_lock);
 static LIST_HEAD(destroy_list);
-static DECLARE_WAIT_QUEUE_HEAD(destroy_waitq);
+
+static void fsnotify_mark_destroy(struct work_struct *work);
+static DECLARE_DELAYED_WORK(reaper_work, fsnotify_mark_destroy);
 
 void fsnotify_get_mark(struct fsnotify_mark *mark)
 {
@@ -189,7 +193,8 @@ void fsnotify_free_mark(struct fsnotify_
 	spin_lock(&destroy_lock);
 	list_add(&mark->g_list, &destroy_list);
 	spin_unlock(&destroy_lock);
-	wake_up(&destroy_waitq);
+	queue_delayed_work(system_unbound_wq, &reaper_work,
+				FSNOTIFY_REAPER_DELAY);
 
 	/*
 	 * Some groups like to know that marks are being freed.  This is a
@@ -388,7 +393,8 @@ err:
 	spin_lock(&destroy_lock);
 	list_add(&mark->g_list, &destroy_list);
 	spin_unlock(&destroy_lock);
-	wake_up(&destroy_waitq);
+	queue_delayed_work(system_unbound_wq, &reaper_work,
+				FSNOTIFY_REAPER_DELAY);
 
 	return ret;
 }
@@ -493,39 +499,20 @@ void fsnotify_init_mark(struct fsnotify_
 	mark->free_mark = free_mark;
 }
 
-static int fsnotify_mark_destroy(void *ignored)
+static void fsnotify_mark_destroy(struct work_struct *work)
 {
 	struct fsnotify_mark *mark, *next;
 	struct list_head private_destroy_list;
 
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
+	spin_lock(&destroy_lock);
+	/* exchange the list head */
+	list_replace_init(&destroy_list, &private_destroy_list);
+	spin_unlock(&destroy_lock);
 
-	thread = kthread_run(fsnotify_mark_destroy, NULL,
-			     "fsnotify_mark");
-	if (IS_ERR(thread))
-		panic("unable to start fsnotify mark destruction thread.");
+	synchronize_srcu(&fsnotify_mark_srcu);
 
-	return 0;
+	list_for_each_entry_safe(mark, next, &private_destroy_list, g_list) {
+		list_del_init(&mark->g_list);
+		fsnotify_put_mark(mark);
+	}
 }
-device_initcall(fsnotify_mark_init);
_

Patches currently in -mm which might be from jlayton@poochiereds.net are

revert-fsnotify-destroy-marks-with-call_srcu-instead-of-dedicated-thread.patch
fsnotify-turn-fsnotify-reaper-thread-into-a-workqueue-job.patch

