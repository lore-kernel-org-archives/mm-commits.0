From: akpm@linux-foundation.org
Subject: + wait-add-wait_event_lock_irq-interface-v3.patch added to -mm tree
Date: Fri, 30 Nov 2012 13:44:58 -0800
Message-ID: <20121130214458.AA49082004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:63433 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2K3Vo7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Nov 2012 16:44:59 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so105829ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 30 Nov 2012 13:44:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lczerner@redhat.com, axboe@kernel.dk, jmoyer@redhat.com, neilb@suse.de


The patch titled
     Subject: wait: add wait_event_lock_irq() interface
has been added to the -mm tree.  Its filename is
     wait-add-wait_event_lock_irq-interface-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
wait-add-wait_event_lock_irq-interface.patch
wait-add-wait_event_lock_irq-interface-fix.patch
wait-add-wait_event_lock_irq-interface-v3.patch
loop-limit-the-number-of-requests-in-the-bio-list.patch

