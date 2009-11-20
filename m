From: akpm@linux-foundation.org
Subject: + posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch added to -mm tree
Date: Fri, 20 Nov 2009 13:15:39 -0800
Message-ID: <200911202115.nAKLFdor005119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754234AbZKTVRO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 16:17:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sgruszka@redhat.com, mingo@elte.hu, oleg@redhat.com, peterz@infradead.org, seto.hidetoshi@jp.fujitsu.com, spencer@bluehost.com, tglx@linutronix.de


The patch titled
     From: Stanislaw Gruszka <sgruszka@redhat.com>
has been added to the -mm tree.  Its filename is
     posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: From: Stanislaw Gruszka <sgruszka@redhat.com>


When process delete cpu timer or timer expires we do not clear
expiration cache sig->cputimer_expires. This create situation when in
fastpath_timer_check() we _on_ cputimer (together with loop on all
threads) just to turn in off in check_process_timers(). We not
necessary go to slowpath and not necessary loop on all threads in
fastpath - and this is repeated on every tick.

To fix we zero sig->cputimer_expires in stop_process_timers().

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Spencer Candland <spencer@bluehost.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN kernel/posix-cpu-timers.c~posix-cpu-timers-reset-expire-cache-when-no-timer-is-running kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~posix-cpu-timers-reset-expire-cache-when-no-timer-is-running
+++ a/kernel/posix-cpu-timers.c
@@ -1060,9 +1060,9 @@ static void check_thread_timers(struct t
 	}
 }
 
-static void stop_process_timers(struct task_struct *tsk)
+static void stop_process_timers(struct signal_struct *sig)
 {
-	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
+	struct thread_group_cputimer *cputimer = &sig->cputimer;
 	unsigned long flags;
 
 	if (!cputimer->running)
@@ -1071,6 +1071,10 @@ static void stop_process_timers(struct t
 	spin_lock_irqsave(&cputimer->lock, flags);
 	cputimer->running = 0;
 	spin_unlock_irqrestore(&cputimer->lock, flags);
+
+	sig->cputime_expires.prof_exp = cputime_zero;
+	sig->cputime_expires.virt_exp = cputime_zero;
+	sig->cputime_expires.sched_exp = 0;
 }
 
 static u32 onecputick;
@@ -1131,7 +1135,7 @@ static void check_process_timers(struct 
 	    list_empty(&timers[CPUCLOCK_VIRT]) &&
 	    cputime_eq(sig->it[CPUCLOCK_VIRT].expires, cputime_zero) &&
 	    list_empty(&timers[CPUCLOCK_SCHED])) {
-		stop_process_timers(tsk);
+		stop_process_timers(sig);
 		return;
 	}
 
_

Patches currently in -mm which might be from sgruszka@redhat.com are

linux-next.patch
itimers-fix-racy-writes-to-cpu_itimer-fields.patch
posix-cpu-timers-optimize-and-document-timer_create-callback.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch

