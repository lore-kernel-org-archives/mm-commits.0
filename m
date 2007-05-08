From: akpm@linux-foundation.org
Subject: + relay-use-plain-timer-instead-of-delayed-work.patch added to -mm tree
Date: Tue, 08 May 2007 14:03:35 -0700
Message-ID: <200705082103.l48L3ZEv001619@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967170AbXEHVDn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:03:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zanussi@comcast.net, oleg@tv-sign.ru, satyam.sharma@gmail.com


The patch titled
     relay: use plain timer instead of delayed work
has been added to the -mm tree.  Its filename is
     relay-use-plain-timer-instead-of-delayed-work.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: relay: use plain timer instead of delayed work
From: Tom Zanussi <zanussi@comcast.net>

relay doesn't need to use schedule_delayed_work() for waking readers
when a simple timer will do.

Signed-off-by: Tom Zanussi <zanussi@comcast.net>
Cc: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/relay.h |    3 ++-
 kernel/relay.c        |   35 ++++++++++++++++-------------------
 2 files changed, 18 insertions(+), 20 deletions(-)

diff -puN include/linux/relay.h~relay-use-plain-timer-instead-of-delayed-work include/linux/relay.h
--- a/include/linux/relay.h~relay-use-plain-timer-instead-of-delayed-work
+++ a/include/linux/relay.h
@@ -12,6 +12,7 @@
 
 #include <linux/types.h>
 #include <linux/sched.h>
+#include <linux/timer.h>
 #include <linux/wait.h>
 #include <linux/list.h>
 #include <linux/fs.h>
@@ -38,7 +39,7 @@ struct rchan_buf
 	size_t subbufs_consumed;	/* count of sub-buffers consumed */
 	struct rchan *chan;		/* associated channel */
 	wait_queue_head_t read_wait;	/* reader wait queue */
-	struct delayed_work wake_readers; /* reader wake-up work struct */
+	struct timer_list timer; 	/* reader wake-up timer */
 	struct dentry *dentry;		/* channel file dentry */
 	struct kref kref;		/* channel buffer refcount */
 	struct page **page_array;	/* array of current buffer pages */
diff -puN kernel/relay.c~relay-use-plain-timer-instead-of-delayed-work kernel/relay.c
--- a/kernel/relay.c~relay-use-plain-timer-instead-of-delayed-work
+++ a/kernel/relay.c
@@ -310,16 +310,13 @@ static struct rchan_callbacks default_ch
 
 /**
  *	wakeup_readers - wake up readers waiting on a channel
- *	@work: work struct that contains the the channel buffer
+ *	@data: contains the the channel buffer
  *
- *	This is the work function used to defer reader waking.  The
- *	reason waking is deferred is that calling directly from write
- *	causes problems if you're writing from say the scheduler.
+ *	This is the timer function used to defer reader waking.
  */
-static void wakeup_readers(struct work_struct *work)
+static void wakeup_readers(unsigned long data)
 {
-	struct rchan_buf *buf =
-		container_of(work, struct rchan_buf, wake_readers.work);
+	struct rchan_buf *buf = (struct rchan_buf *)data;
 	wake_up_interruptible(&buf->read_wait);
 }
 
@@ -337,11 +334,9 @@ static void __relay_reset(struct rchan_b
 	if (init) {
 		init_waitqueue_head(&buf->read_wait);
 		kref_init(&buf->kref);
-		INIT_DELAYED_WORK(&buf->wake_readers, NULL);
-	} else {
-		cancel_delayed_work(&buf->wake_readers);
-		flush_scheduled_work();
-	}
+		setup_timer(&buf->timer, wakeup_readers, (unsigned long)buf);
+	} else
+		del_timer_sync(&buf->timer);
 
 	buf->subbufs_produced = 0;
 	buf->subbufs_consumed = 0;
@@ -447,8 +442,7 @@ end:
 static void relay_close_buf(struct rchan_buf *buf)
 {
 	buf->finalized = 1;
-	cancel_delayed_work(&buf->wake_readers);
-	flush_scheduled_work();
+	del_timer_sync(&buf->timer);
 	kref_put(&buf->kref, relay_remove_buf);
 }
 
@@ -608,11 +602,14 @@ size_t relay_switch_subbuf(struct rchan_
 		buf->dentry->d_inode->i_size += buf->chan->subbuf_size -
 			buf->padding[old_subbuf];
 		smp_mb();
-		if (waitqueue_active(&buf->read_wait)) {
-			PREPARE_DELAYED_WORK(&buf->wake_readers,
-					     wakeup_readers);
-			schedule_delayed_work(&buf->wake_readers, 1);
-		}
+		if (waitqueue_active(&buf->read_wait))
+			/*
+			 * Calling wake_up_interruptible() from here
+			 * will deadlock if we happen to be logging
+			 * from the scheduler (trying to re-grab
+			 * rq->lock), so defer it.
+			 */
+			__mod_timer(&buf->timer, jiffies + 1);
 	}
 
 	old = buf->data;
_

Patches currently in -mm which might be from zanussi@comcast.net are

relay-use-plain-timer-instead-of-delayed-work.patch
