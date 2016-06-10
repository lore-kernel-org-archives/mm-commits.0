From: akpm@linux-foundation.org
Subject: +
 task_work-use-read_once-lockless_dereference-avoid-pi_lock-if-task_works.patch added to -mm tree
Date: Fri, 10 Jun 2016 15:06:16 -0700
Message-ID: <575b39d8.rtbTR6sCBXcwg/XO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbcFJWGR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jun 2016 18:06:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, parri.andrea@gmail.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: task_work: use READ_ONCE/lockless_dereference, avoid pi_lock if !task_works
has been added to the -mm tree.  Its filename is
     task_work-use-read_once-lockless_dereference-avoid-pi_lock-if-task_works.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/task_work-use-read_once-lockless_dereference-avoid-pi_lock-if-task_works.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/task_work-use-read_once-lockless_dereference-avoid-pi_lock-if-task_works.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: task_work: use READ_ONCE/lockless_dereference, avoid pi_lock if !task_works

Change task_work_cancel() to use lockless_dereference(), this is what the
code really wants but we didn't have this helper when it was written.

Also add the fast-path task->task_works == NULL check, in the likely case
this task has no pending works and we can avoid spin_lock(task->pi_lock).

While at it, change other users of ACCESS_ONCE() to use READ_ONCE().

Link: http://lkml.kernel.org/r/20160610150042.GA13868@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Andrea Parri <parri.andrea@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/task_work.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN kernel/task_work.c~task_work-use-read_once-lockless_dereference-avoid-pi_lock-if-task_works kernel/task_work.c
--- a/kernel/task_work.c~task_work-use-read_once-lockless_dereference-avoid-pi_lock-if-task_works
+++ a/kernel/task_work.c
@@ -29,7 +29,7 @@ task_work_add(struct task_struct *task,
 	struct callback_head *head;
 
 	do {
-		head = ACCESS_ONCE(task->task_works);
+		head = READ_ONCE(task->task_works);
 		if (unlikely(head == &work_exited))
 			return -ESRCH;
 		work->next = head;
@@ -57,6 +57,9 @@ task_work_cancel(struct task_struct *tas
 	struct callback_head **pprev = &task->task_works;
 	struct callback_head *work;
 	unsigned long flags;
+
+	if (likely(!task->task_works))
+		return NULL;
 	/*
 	 * If cmpxchg() fails we continue without updating pprev.
 	 * Either we raced with task_work_add() which added the
@@ -64,8 +67,7 @@ task_work_cancel(struct task_struct *tas
 	 * we raced with task_work_run(), *pprev == NULL/exited.
 	 */
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
-	while ((work = ACCESS_ONCE(*pprev))) {
-		smp_read_barrier_depends();
+	while ((work = lockless_dereference(*pprev))) {
 		if (work->func != func)
 			pprev = &work->next;
 		else if (cmpxchg(pprev, work, work->next) == work)
@@ -95,7 +97,7 @@ void task_work_run(void)
 		 * work_exited unless the list is empty.
 		 */
 		do {
-			work = ACCESS_ONCE(task->task_works);
+			work = READ_ONCE(task->task_works);
 			head = !work && (task->flags & PF_EXITING) ?
 				&work_exited : NULL;
 		} while (cmpxchg(&task->task_works, work, head) != work);
_

Patches currently in -mm which might be from oleg@redhat.com are

proc_oom_score-remove-tasklist_lock-and-pid_alive.patch
task_work-use-read_once-lockless_dereference-avoid-pi_lock-if-task_works.patch

