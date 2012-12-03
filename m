From: akpm@linux-foundation.org
Subject: [merged] wait-add-wait_event_lock_irq-interface.patch removed from -mm tree
Date: Mon, 03 Dec 2012 14:01:36 -0800
Message-ID: <20121203220139.96B4C20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:55672 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab2LCWBn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2012 17:01:43 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so8805wib.1
        for <mm-commits@vger.kernel.org>; Mon, 03 Dec 2012 14:01:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lczerner@redhat.com, a.p.zijlstra@chello.nl, axboe@kernel.dk, david@fromorbit.com, dhowells@redhat.com, jmoyer@redhat.com, mingo@elte.hu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: wait: add wait_event_lock_irq() interface
has been removed from the -mm tree.  Its filename was
     wait-add-wait_event_lock_irq-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lukas Czerner <lczerner@redhat.com>
Subject: wait: add wait_event_lock_irq() interface

New wait_event{_interruptible}_lock_irq{_cmd} macros added.  This commit
moves the private wait_event_lock_irq() macro from MD to regular wait
includes, introduces new macro wait_event_lock_irq_cmd() instead of using
the old method with omitting cmd parameter which is ugly and makes a use
of new macros in the MD.  It also introduces the _interruptible_ variant.

The use of new interface is when one have a special lock to protect data
structures used in the condition, or one also needs to invoke "cmd" before
putting it to sleep.  "cmd" is always invoked before checking the
"condition" so in case it will change the condition outcome we would not
have to sleep unnecessarily.

All new macros are expected to be called with the lock taken.  The lock is
released before sleep and is reacquired afterwards.  We will leave the
macro with the lock held.

Note to DM: IMO this should also fix theoretical race on waitqueue while
using simultaneously wait_event_lock_irq() and wait_event() because of
lack of locking around current state setting and wait queue removal.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: Neil Brown <neilb@suse.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c      |    2 
 drivers/md/md.h      |   26 ------
 drivers/md/raid1.c   |   15 +--
 drivers/md/raid10.c  |   15 +--
 drivers/md/raid5.c   |   12 +-
 include/linux/wait.h |  166 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 186 insertions(+), 50 deletions(-)

diff -puN drivers/md/md.c~wait-add-wait_event_lock_irq-interface drivers/md/md.c
--- a/drivers/md/md.c~wait-add-wait_event_lock_irq-interface
+++ a/drivers/md/md.c
@@ -452,7 +452,7 @@ void md_flush_request(struct mddev *mdde
 	spin_lock_irq(&mddev->write_lock);
 	wait_event_lock_irq(mddev->sb_wait,
 			    !mddev->flush_bio,
-			    mddev->write_lock, /*nothing*/);
+			    mddev->write_lock);
 	mddev->flush_bio = bio;
 	spin_unlock_irq(&mddev->write_lock);
 
diff -puN drivers/md/md.h~wait-add-wait_event_lock_irq-interface drivers/md/md.h
--- a/drivers/md/md.h~wait-add-wait_event_lock_irq-interface
+++ a/drivers/md/md.h
@@ -553,32 +553,6 @@ struct md_thread {
 
 #define THREAD_WAKEUP  0
 
-#define __wait_event_lock_irq(wq, condition, lock, cmd) 		\
-do {									\
-	wait_queue_t __wait;						\
-	init_waitqueue_entry(&__wait, current);				\
-									\
-	add_wait_queue(&wq, &__wait);					\
-	for (;;) {							\
-		set_current_state(TASK_UNINTERRUPTIBLE);		\
-		if (condition)						\
-			break;						\
-		spin_unlock_irq(&lock);					\
-		cmd;							\
-		schedule();						\
-		spin_lock_irq(&lock);					\
-	}								\
-	current->state = TASK_RUNNING;					\
-	remove_wait_queue(&wq, &__wait);				\
-} while (0)
-
-#define wait_event_lock_irq(wq, condition, lock, cmd) 			\
-do {									\
-	if (condition)	 						\
-		break;							\
-	__wait_event_lock_irq(wq, condition, lock, cmd);		\
-} while (0)
-
 static inline void safe_put_page(struct page *p)
 {
 	if (p) put_page(p);
diff -puN drivers/md/raid1.c~wait-add-wait_event_lock_irq-interface drivers/md/raid1.c
--- a/drivers/md/raid1.c~wait-add-wait_event_lock_irq-interface
+++ a/drivers/md/raid1.c
@@ -822,7 +822,7 @@ static void raise_barrier(struct r1conf 
 
 	/* Wait until no block IO is waiting */
 	wait_event_lock_irq(conf->wait_barrier, !conf->nr_waiting,
-			    conf->resync_lock, );
+			    conf->resync_lock);
 
 	/* block any new IO from starting */
 	conf->barrier++;
@@ -830,7 +830,7 @@ static void raise_barrier(struct r1conf 
 	/* Now wait for all pending IO to complete */
 	wait_event_lock_irq(conf->wait_barrier,
 			    !conf->nr_pending && conf->barrier < RESYNC_DEPTH,
-			    conf->resync_lock, );
+			    conf->resync_lock);
 
 	spin_unlock_irq(&conf->resync_lock);
 }
@@ -864,8 +864,7 @@ static void wait_barrier(struct r1conf *
 				    (conf->nr_pending &&
 				     current->bio_list &&
 				     !bio_list_empty(current->bio_list)),
-				    conf->resync_lock,
-			);
+				    conf->resync_lock);
 		conf->nr_waiting--;
 	}
 	conf->nr_pending++;
@@ -898,10 +897,10 @@ static void freeze_array(struct r1conf *
 	spin_lock_irq(&conf->resync_lock);
 	conf->barrier++;
 	conf->nr_waiting++;
-	wait_event_lock_irq(conf->wait_barrier,
-			    conf->nr_pending == conf->nr_queued+1,
-			    conf->resync_lock,
-			    flush_pending_writes(conf));
+	wait_event_lock_irq_cmd(conf->wait_barrier,
+				conf->nr_pending == conf->nr_queued+1,
+				conf->resync_lock,
+				flush_pending_writes(conf));
 	spin_unlock_irq(&conf->resync_lock);
 }
 static void unfreeze_array(struct r1conf *conf)
diff -puN drivers/md/raid10.c~wait-add-wait_event_lock_irq-interface drivers/md/raid10.c
--- a/drivers/md/raid10.c~wait-add-wait_event_lock_irq-interface
+++ a/drivers/md/raid10.c
@@ -952,7 +952,7 @@ static void raise_barrier(struct r10conf
 
 	/* Wait until no block IO is waiting (unless 'force') */
 	wait_event_lock_irq(conf->wait_barrier, force || !conf->nr_waiting,
-			    conf->resync_lock, );
+			    conf->resync_lock);
 
 	/* block any new IO from starting */
 	conf->barrier++;
@@ -960,7 +960,7 @@ static void raise_barrier(struct r10conf
 	/* Now wait for all pending IO to complete */
 	wait_event_lock_irq(conf->wait_barrier,
 			    !conf->nr_pending && conf->barrier < RESYNC_DEPTH,
-			    conf->resync_lock, );
+			    conf->resync_lock);
 
 	spin_unlock_irq(&conf->resync_lock);
 }
@@ -993,8 +993,7 @@ static void wait_barrier(struct r10conf 
 				    (conf->nr_pending &&
 				     current->bio_list &&
 				     !bio_list_empty(current->bio_list)),
-				    conf->resync_lock,
-			);
+				    conf->resync_lock);
 		conf->nr_waiting--;
 	}
 	conf->nr_pending++;
@@ -1027,10 +1026,10 @@ static void freeze_array(struct r10conf 
 	spin_lock_irq(&conf->resync_lock);
 	conf->barrier++;
 	conf->nr_waiting++;
-	wait_event_lock_irq(conf->wait_barrier,
-			    conf->nr_pending == conf->nr_queued+1,
-			    conf->resync_lock,
-			    flush_pending_writes(conf));
+	wait_event_lock_irq_cmd(conf->wait_barrier,
+				conf->nr_pending == conf->nr_queued+1,
+				conf->resync_lock,
+				flush_pending_writes(conf));
 
 	spin_unlock_irq(&conf->resync_lock);
 }
diff -puN drivers/md/raid5.c~wait-add-wait_event_lock_irq-interface drivers/md/raid5.c
--- a/drivers/md/raid5.c~wait-add-wait_event_lock_irq-interface
+++ a/drivers/md/raid5.c
@@ -496,7 +496,7 @@ get_active_stripe(struct r5conf *conf, s
 	do {
 		wait_event_lock_irq(conf->wait_for_stripe,
 				    conf->quiesce == 0 || noquiesce,
-				    conf->device_lock, /* nothing */);
+				    conf->device_lock);
 		sh = __find_stripe(conf, sector, conf->generation - previous);
 		if (!sh) {
 			if (!conf->inactive_blocked)
@@ -510,8 +510,7 @@ get_active_stripe(struct r5conf *conf, s
 						    (atomic_read(&conf->active_stripes)
 						     < (conf->max_nr_stripes *3/4)
 						     || !conf->inactive_blocked),
-						    conf->device_lock,
-						    );
+						    conf->device_lock);
 				conf->inactive_blocked = 0;
 			} else
 				init_stripe(sh, sector, previous);
@@ -1682,8 +1681,7 @@ static int resize_stripes(struct r5conf 
 		spin_lock_irq(&conf->device_lock);
 		wait_event_lock_irq(conf->wait_for_stripe,
 				    !list_empty(&conf->inactive_list),
-				    conf->device_lock,
-				    );
+				    conf->device_lock);
 		osh = get_free_stripe(conf);
 		spin_unlock_irq(&conf->device_lock);
 		atomic_set(&nsh->count, 1);
@@ -4054,7 +4052,7 @@ static int chunk_aligned_read(struct mdd
 		spin_lock_irq(&conf->device_lock);
 		wait_event_lock_irq(conf->wait_for_stripe,
 				    conf->quiesce == 0,
-				    conf->device_lock, /* nothing */);
+				    conf->device_lock);
 		atomic_inc(&conf->active_aligned_reads);
 		spin_unlock_irq(&conf->device_lock);
 
@@ -6490,7 +6488,7 @@ static void raid5_quiesce(struct mddev *
 		wait_event_lock_irq(conf->wait_for_stripe,
 				    atomic_read(&conf->active_stripes) == 0 &&
 				    atomic_read(&conf->active_aligned_reads) == 0,
-				    conf->device_lock, /* nothing */);
+				    conf->device_lock);
 		conf->quiesce = 1;
 		spin_unlock_irq(&conf->device_lock);
 		/* allow reshape to continue */
diff -puN include/linux/wait.h~wait-add-wait_event_lock_irq-interface include/linux/wait.h
--- a/include/linux/wait.h~wait-add-wait_event_lock_irq-interface
+++ a/include/linux/wait.h
@@ -550,6 +550,172 @@ do {									\
 	__ret;								\
 })
 
+
+#define __wait_event_lock_irq(wq, condition, lock, cmd)			\
+do {									\
+	DEFINE_WAIT(__wait);						\
+									\
+	cmd;								\
+	for (;;) {							\
+		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		spin_unlock_irq(&lock);					\
+		schedule();						\
+		cmd;							\
+		spin_lock_irq(&lock);					\
+	}								\
+	finish_wait(&wq, &__wait);					\
+} while (0)
+
+/**
+ * wait_event_lock_irq_cmd - sleep until a condition gets true. The
+ *			     condition is checked under the lock. This
+ *			     is expected to be called with the lock
+ *			     taken.
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @lock: a locked spinlock_t, which will be released before schedule()
+ *	  and cmd reacquired afterwards.
+ * @cmd: a command which is invoked outside the critical section before
+ *	 sleep
+ *
+ * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * This is supposed to be called while holding the lock. The lock is
+ * dropped before going to sleep and invoking the cmd and is reacquired
+ * afterwards.
+ */
+#define wait_event_lock_irq_cmd(wq, condition, lock, cmd)		\
+do {									\
+	if (condition)							\
+		break;							\
+	__wait_event_lock_irq(wq, condition, lock, cmd);		\
+} while (0)
+
+/**
+ * wait_event_lock_irq - sleep until a condition gets true. The
+ *			 condition is checked under the lock. This
+ *			 is expected to be called with the lock
+ *			 taken.
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @lock: a locked spinlock_t, which will be released before schedule()
+ *	  and reacquired afterwards.
+ *
+ * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * This is supposed to be called while holding the lock. The lock is
+ * dropped before going to sleep and is reacquired afterwards.
+ */
+#define wait_event_lock_irq(wq, condition, lock)			\
+do {									\
+	if (condition)							\
+		break;							\
+	__wait_event_lock_irq(wq, condition, lock, );			\
+} while (0)
+
+
+#define __wait_event_interruptible_lock_irq(wq, condition,		\
+					    lock, ret, cmd)		\
+do {									\
+	DEFINE_WAIT(__wait);						\
+									\
+	cmd;								\
+	for (;;) {							\
+		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		if (signal_pending(current)) {				\
+			ret = -ERESTARTSYS;				\
+			break;						\
+		}							\
+		spin_unlock_irq(&lock);					\
+		schedule();						\
+		cmd;							\
+		spin_lock_irq(&lock);					\
+	}								\
+	finish_wait(&wq, &__wait);					\
+} while (0)
+
+/**
+ * wait_event_interruptible_lock_irq_cmd - sleep until a condition gets true.
+ *		The condition is checked under the lock. This is expected to
+ *		be called with the lock taken.
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @lock: a locked spinlock_t, which will be released before schedule()
+ *	  and cmd reacquired afterwards.
+ * @cmd: a command which is invoked outside the critical section before
+ *	 sleep
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the
+ * @condition evaluates to true or a signal is received. The @condition is
+ * checked each time the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * This is supposed to be called while holding the lock. The lock is
+ * dropped before going to sleep and invoking the cmd and is reacquired
+ * afterwards.
+ *
+ * The macro will return -ERESTARTSYS if it was interrupted by a signal
+ * and 0 if @condition evaluated to true.
+ */
+#define wait_event_interruptible_lock_irq_cmd(wq, condition, lock, cmd)	\
+({									\
+	int __ret = 0;							\
+									\
+	if (!(condition))						\
+		__wait_event_interruptible_lock_irq(wq, condition,	\
+						    lock, __ret, cmd);	\
+	__ret;								\
+})
+
+/**
+ * wait_event_interruptible_lock_irq - sleep until a condition gets true.
+ *		The condition is checked under the lock. This is expected
+ *		to be called with the lock taken.
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @lock: a locked spinlock_t, which will be released before schedule()
+ *	  and reacquired afterwards.
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the
+ * @condition evaluates to true or signal is received. The @condition is
+ * checked each time the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * This is supposed to be called while holding the lock. The lock is
+ * dropped before going to sleep and is reacquired afterwards.
+ *
+ * The macro will return -ERESTARTSYS if it was interrupted by a signal
+ * and 0 if @condition evaluated to true.
+ */
+#define wait_event_interruptible_lock_irq(wq, condition, lock)		\
+({									\
+	int __ret = 0;							\
+									\
+	if (!(condition))						\
+		__wait_event_interruptible_lock_irq(wq, condition,	\
+						    lock, __ret, );	\
+	__ret;								\
+})
+
+
 /*
  * These are the old interfaces to sleep waiting for an event.
  * They are racy.  DO NOT use them, use the wait_event* interfaces above.
_

Patches currently in -mm which might be from lczerner@redhat.com are

linux-next.patch

