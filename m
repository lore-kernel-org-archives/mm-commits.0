From: akpm@linux-foundation.org
Subject: [merged] wait-add-wait_event_lock_irq-interface-v3.patch removed from -mm tree
Date: Mon, 03 Dec 2012 14:01:47 -0800
Message-ID: <20121203220147.ABA63100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:42895 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab2LCWBt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2012 17:01:49 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so290461vbi.1
        for <mm-commits@vger.kernel.org>; Mon, 03 Dec 2012 14:01:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lczerner@redhat.com, axboe@kernel.dk, jmoyer@redhat.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: wait: add wait_event_lock_irq() interface
has been removed from the -mm tree.  Its filename was
     wait-add-wait_event_lock_irq-interface-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lukas Czerner <lczerner@redhat.com>
Subject: wait: add wait_event_lock_irq() interface

v3: swap cmd and schedule so we call cmd before schedule

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/wait.h |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN include/linux/wait.h~wait-add-wait_event_lock_irq-interface-v3 include/linux/wait.h
--- a/include/linux/wait.h~wait-add-wait_event_lock_irq-interface-v3
+++ a/include/linux/wait.h
@@ -555,14 +555,13 @@ do {									\
 do {									\
 	DEFINE_WAIT(__wait);						\
 									\
-	cmd;								\
 	for (;;) {							\
 		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
 		if (condition)						\
 			break;						\
 		spin_unlock_irq(&lock);					\
-		schedule();						\
 		cmd;							\
+		schedule();						\
 		spin_lock_irq(&lock);					\
 	}								\
 	finish_wait(&wq, &__wait);					\
@@ -575,8 +574,8 @@ do {									\
  *			     taken.
  * @wq: the waitqueue to wait on
  * @condition: a C expression for the event to wait for
- * @lock: a locked spinlock_t, which will be released before schedule()
- *	  and cmd reacquired afterwards.
+ * @lock: a locked spinlock_t, which will be released before cmd
+ *	  and schedule() and reacquired afterwards.
  * @cmd: a command which is invoked outside the critical section before
  *	 sleep
  *
@@ -588,7 +587,7 @@ do {									\
  * change the result of the wait condition.
  *
  * This is supposed to be called while holding the lock. The lock is
- * dropped before going to sleep and invoking the cmd and is reacquired
+ * dropped before invoking the cmd and going to sleep and is reacquired
  * afterwards.
  */
 #define wait_event_lock_irq_cmd(wq, condition, lock, cmd)		\
@@ -631,7 +630,6 @@ do {									\
 do {									\
 	DEFINE_WAIT(__wait);						\
 									\
-	cmd;								\
 	for (;;) {							\
 		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
 		if (condition)						\
@@ -641,8 +639,8 @@ do {									\
 			break;						\
 		}							\
 		spin_unlock_irq(&lock);					\
-		schedule();						\
 		cmd;							\
+		schedule();						\
 		spin_lock_irq(&lock);					\
 	}								\
 	finish_wait(&wq, &__wait);					\
@@ -654,8 +652,8 @@ do {									\
  *		be called with the lock taken.
  * @wq: the waitqueue to wait on
  * @condition: a C expression for the event to wait for
- * @lock: a locked spinlock_t, which will be released before schedule()
- *	  and cmd reacquired afterwards.
+ * @lock: a locked spinlock_t, which will be released before cmd and
+ *	  schedule() and reacquired afterwards.
  * @cmd: a command which is invoked outside the critical section before
  *	 sleep
  *
@@ -667,7 +665,7 @@ do {									\
  * change the result of the wait condition.
  *
  * This is supposed to be called while holding the lock. The lock is
- * dropped before going to sleep and invoking the cmd and is reacquired
+ * dropped before invoking the cmd and going to sleep and is reacquired
  * afterwards.
  *
  * The macro will return -ERESTARTSYS if it was interrupted by a signal
_

Patches currently in -mm which might be from lczerner@redhat.com are

linux-next.patch

