From: akpm@linux-foundation.org
Subject: + posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch added to -mm tree
Date: Mon, 19 May 2008 23:32:59 -0700
Message-ID: <200805200632.m4K6Wxti008971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758456AbYETGe1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 02:34:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, johnstul@us.ibm.com, roland@redhat.com, tglx@linutronix.de


The patch titled
     posix timers: timer_delete: remove the bogus "->it_process != NULL" check
has been added to the -mm tree.  Its filename is
     posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch

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
Subject: posix timers: timer_delete: remove the bogus "->it_process != NULL" check
From: Oleg Nesterov <oleg@tv-sign.ru>

sys_timer_delete() and itimer_delete() check "timer->it_process != NULL",
this looks completely bogus.  ->it_process == NULL means that this timer
is already under destruction or it is not fully initialized, this must not
happen.

	sys_timer_delete: the timer is locked, and lock_timer() can't succeed
	if ->it_process == NULL.

	itimer_delete: it is called by exit_itimers() when there are no other
	threads which can play with signal_struct->posix_timers.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check
+++ a/kernel/posix-timers.c
@@ -856,11 +856,10 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	if (timer->it_process) {
-		if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-			put_task_struct(timer->it_process);
-		timer->it_process = NULL;
-	}
+	if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
+		put_task_struct(timer->it_process);
+	timer->it_process = NULL;
+
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
 	return 0;
@@ -885,11 +884,10 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	if (timer->it_process) {
-		if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-			put_task_struct(timer->it_process);
-		timer->it_process = NULL;
-	}
+	if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
+		put_task_struct(timer->it_process);
+	timer->it_process = NULL;
+
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
 }
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

signals-fix-sigqueue_free-vs-__exit_signal-race.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-sigqueue_free-dont-free-sigqueue-if-it-is-queued.patch
signals-introduce-sigqueue_cancelled.patch
posix-timers-use-sigqueue_cancelled-when-the-timer-is-destroyed.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

