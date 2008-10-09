From: akpm@linux-foundation.org
Subject: - posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:27:22 -0700
Message-ID: <200810092227.m99MRMfe005950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984AbYJIW1x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:27:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix-timers: don't switch to ->group_leader if ->it_process dies
has been removed from the -mm tree.  Its filename was
     posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix-timers: don't switch to ->group_leader if ->it_process dies
From: Oleg Nesterov <oleg@tv-sign.ru>

posix_timer_event() drops SIGEV_THREAD_ID and switches to ->group_leader
if send_sigqueue() fails.

This is not very useful and doesn't work reliably.  send_sigqueue() can
only fail if ->it_process is dead.  But it can die before it dequeues the
SI_TIMER signal, in that case the timer stops anyway.

Remove this code.  I guess it was needed a long ago to ensure that the
timer is not destroyed when when its creator thread dies.

Q: perhaps it makes sense to change sys_timer_settime() to return an error
if ->it_process is dead?

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-dont-switch-to-group_leader-if-it_process-dies kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-dont-switch-to-group_leader-if-it_process-dies
+++ a/kernel/posix-timers.c
@@ -313,6 +313,7 @@ void do_schedule_next_timer(struct sigin
 
 int posix_timer_event(struct k_itimer *timr, int si_private)
 {
+	int shared, ret;
 	/*
 	 * FIXME: if ->sigq is queued we can race with
 	 * dequeue_signal()->do_schedule_next_timer().
@@ -331,20 +332,10 @@ int posix_timer_event(struct k_itimer *t
 	timr->sigq->info.si_tid = timr->it_id;
 	timr->sigq->info.si_value = timr->it_sigev_value;
 
-	if (timr->it_sigev_notify & SIGEV_THREAD_ID) {
-		struct task_struct *leader;
-		int ret = send_sigqueue(timr->sigq, timr->it_process, 0);
-
-		if (likely(ret >= 0))
-			return ret;
-
-		timr->it_sigev_notify = SIGEV_SIGNAL;
-		leader = timr->it_process->group_leader;
-		put_task_struct(timr->it_process);
-		timr->it_process = leader;
-	}
