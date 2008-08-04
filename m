From: akpm@linux-foundation.org
Subject: + posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:32:29 -0700
Message-ID: <200808042132.m74LWTBj032015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764681AbYHDVd1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:33:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de


The patch titled
     posix-timers: move the initialization of timer->sigq from send to create path
has been added to the -mm tree.  Its filename is
     posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix-timers: move the initialization of timer->sigq from send to create path
From: Oleg Nesterov <oleg@tv-sign.ru>

posix_timer_event() always populates timer->sigq with the same numbers,
move this code into sys_timer_create().

Note that with this patch we can kill it_sigev_signo and it_sigev_value.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path
+++ a/kernel/posix-timers.c
@@ -327,11 +327,6 @@ int posix_timer_event(struct k_itimer *t
 	 */
 	timr->sigq->info.si_sys_private = si_private;
 
-	timr->sigq->info.si_signo = timr->it_sigev_signo;
-	timr->sigq->info.si_code = SI_TIMER;
-	timr->sigq->info.si_tid = timr->it_id;
-	timr->sigq->info.si_value = timr->it_sigev_value;
-
 	shared = !(timr->it_sigev_notify & SIGEV_THREAD_ID);
 	ret = send_sigqueue(timr->sigq, timr->it_process, shared);
 	/* If we failed to send the signal the timer stops. */
@@ -552,6 +547,11 @@ sys_timer_create(const clockid_t which_c
 		get_task_struct(process);
 	}
 
+	new_timer->sigq->info.si_code  = SI_TIMER;
+	new_timer->sigq->info.si_tid   = new_timer->it_id;
+	new_timer->sigq->info.si_signo = new_timer->it_sigev_signo;
+	new_timer->sigq->info.si_value = new_timer->it_sigev_value;
+
 	spin_lock_irq(&current->sighand->siglock);
 	new_timer->it_process = process;
 	list_add(&new_timer->list, &current->signal->posix_timers);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
semaphore-__down_common-use-signal_pending_state.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
sched-do_wait_for_common-use-signal_pending_state.patch
wait_task_inactive-dont-consider-task-nivcsw.patch
posix-timers-fix-posix_timer_event-vs-dequeue_signal-race.patch
posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun.patch
posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch
posix-timers-always-do-get_task_structtimer-it_process.patch
posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch
posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch
posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch
posix-timers-sys_timer_create-cleanup-the-error-handling.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

