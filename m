From: akpm@linux-foundation.org
Subject: + drivers-tty-compute-current-directly.patch added to -mm tree
Date: Thu, 05 Jan 2017 16:19:24 -0800
Message-ID: <586ee28c.GW14N4+kUk43sPlQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58664 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754750AbdAFASK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 19:18:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, gregkh@linuxfoundation.org, mark.rutland@arm.com, mingo@elte.hu, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/tty: compute current directly
has been added to the -mm tree.  Its filename is
     drivers-tty-compute-current-directly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-tty-compute-current-directly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-tty-compute-current-directly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: drivers/tty: compute current directly

This patch effectively replaces the tsk pointer dereference (which is
obviously == current), to directly use get_current() macro.  This is to
make the removal of setting foreign task states smoother and painfully
obvious.  Performance win on some archs such as x86-64 and ppc64 -- arm64
is no longer an issue:

    https://lkml.org/lkml/2016/12/30/230

Link: http://lkml.kernel.org/r/1483479794-14013-3-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/tty_ldsem.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/tty/tty_ldsem.c~drivers-tty-compute-current-directly drivers/tty/tty_ldsem.c
--- a/drivers/tty/tty_ldsem.c~drivers-tty-compute-current-directly
+++ a/drivers/tty/tty_ldsem.c
@@ -200,7 +200,6 @@ static struct ld_semaphore __sched *
 down_read_failed(struct ld_semaphore *sem, long count, long timeout)
 {
 	struct ldsem_waiter waiter;
-	struct task_struct *tsk = current;
 	long adjust = -LDSEM_ACTIVE_BIAS + LDSEM_WAIT_BIAS;
 
 	/* set up my own style of waitqueue */
@@ -221,8 +220,8 @@ down_read_failed(struct ld_semaphore *se
 	list_add_tail(&waiter.list, &sem->read_wait);
 	sem->wait_readers++;
 
-	waiter.task = tsk;
-	get_task_struct(tsk);
+	waiter.task = current;
+	get_task_struct(current);
 
 	/* if there are no active locks, wake the new lock owner(s) */
 	if ((count & LDSEM_ACTIVE_MASK) == 0)
@@ -232,7 +231,7 @@ down_read_failed(struct ld_semaphore *se
 
 	/* wait to be given the lock */
 	for (;;) {
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		set_task_state(current, TASK_UNINTERRUPTIBLE);
 
 		if (!waiter.task)
 			break;
@@ -241,7 +240,7 @@ down_read_failed(struct ld_semaphore *se
 		timeout = schedule_timeout(timeout);
 	}
 
-	__set_task_state(tsk, TASK_RUNNING);
+	__set_task_state(current, TASK_RUNNING);
 
 	if (!timeout) {
 		/* lock timed out but check if this task was just
@@ -268,7 +267,6 @@ static struct ld_semaphore __sched *
 down_write_failed(struct ld_semaphore *sem, long count, long timeout)
 {
 	struct ldsem_waiter waiter;
-	struct task_struct *tsk = current;
 	long adjust = -LDSEM_ACTIVE_BIAS;
 	int locked = 0;
 
@@ -289,16 +287,16 @@ down_write_failed(struct ld_semaphore *s
 
 	list_add_tail(&waiter.list, &sem->write_wait);
 
-	waiter.task = tsk;
+	waiter.task = current;
 
-	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+	set_task_state(current, TASK_UNINTERRUPTIBLE);
 	for (;;) {
 		if (!timeout)
 			break;
 		raw_spin_unlock_irq(&sem->wait_lock);
 		timeout = schedule_timeout(timeout);
 		raw_spin_lock_irq(&sem->wait_lock);
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		set_task_state(current, TASK_UNINTERRUPTIBLE);
 		locked = writer_trylock(sem);
 		if (locked)
 			break;
@@ -309,7 +307,7 @@ down_write_failed(struct ld_semaphore *s
 	list_del(&waiter.list);
 	raw_spin_unlock_irq(&sem->wait_lock);
 
-	__set_task_state(tsk, TASK_RUNNING);
+	__set_task_state(current, TASK_RUNNING);
 
 	/* lock wait may have timed out */
 	if (!locked)
_

Patches currently in -mm which might be from dave@stgolabs.net are

kernel-exit-compute-current-directly.patch
drivers-tty-compute-current-directly.patch
kernel-locking-compute-current-directly.patch
sched-remove-set_task_state.patch

