From: akpm@linux-foundation.org
Subject: + posix-timers-fix-posix_timer_event-vs-dequeue_signal-race.patch added to -mm tree
Date: Mon, 28 Jul 2008 21:51:51 -0700
Message-ID: <200807290451.m6T4ppbR014927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804AbYG2Ew5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 00:52:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, markmc@redhat.com, oliver.pntr@gmail.com, roland@redhat.com, stable@kernel.org, tglx@linutronix.de


The patch titled
     posix-timers: fix posix_timer_event() vs dequeue_signal() race
has been added to the -mm tree.  Its filename is
     posix-timers-fix-posix_timer_event-vs-dequeue_signal-race.patch

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
Subject: posix-timers: fix posix_timer_event() vs dequeue_signal() race
From: Oleg Nesterov <oleg@tv-sign.ru>

The bug was reported and analysed by Mark McLoughlin <markmc@redhat.com>,
the patch is based on his and Roland's suggestions.

posix_timer_event() always rewrites the pre-allocated siginfo before
sending the signal.  Most of the written info is the same all the time,
but memset(0) is very wrong.  If ->sigq is queued we can race with
collect_signal() which can fail to find this siginfo looking at .si_signo,
or copy_siginfo() can copy the wrong .si_code/si_tid/etc.

In short, sys_timer_settime() can in fact stop the active timer, or the
user can receive the siginfo with the wrong .si_xxx values.

Move "memset(->info, 0)" from posix_timer_event() to alloc_posix_timer(),
change send_sigqueue() to set .si_overrun = 0 when ->sigq is not queued. 
It would be nice to move the whole sigq->info initialization from send to
create path, but this is not easy to do without uglifying timer_create()
further.

As Roland rightly pointed out, we need more cleanups/fixes here, see the
"FIXME" comment in the patch.  Hopefully this patch makes sense anyway,
and it can mask the most bad implications.

Reported-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Tested-by: Mark McLoughlin <markmc@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oliver Pinter <oliver.pntr@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   17 +++++++++++++----
 kernel/signal.c       |    1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-fix-posix_timer_event-vs-dequeue_signal-race kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-fix-posix_timer_event-vs-dequeue_signal-race
+++ a/kernel/posix-timers.c
@@ -311,14 +311,22 @@ void do_schedule_next_timer(struct sigin
 		unlock_timer(timr, flags);
 }
 
-int posix_timer_event(struct k_itimer *timr,int si_private)
+int posix_timer_event(struct k_itimer *timr, int si_private)
 {
-	memset(&timr->sigq->info, 0, sizeof(siginfo_t));
+	/*
+	 * FIXME: if ->sigq is queued we can race with
+	 * dequeue_signal()->do_schedule_next_timer().
+	 *
+	 * If dequeue_signal() sees the "right" value of
+	 * si_sys_private it calls do_schedule_next_timer().
+	 * We re-queue ->sigq and drop ->it_lock().
+	 * do_schedule_next_timer() locks the timer
+	 * and re-schedules it while ->sigq is pending.
+	 * Not really bad, but not that we want.
+	 */
 	timr->sigq->info.si_sys_private = si_private;
-	/* Send signal to the process that owns this timer.*/
 
 	timr->sigq->info.si_signo = timr->it_sigev_signo;
-	timr->sigq->info.si_errno = 0;
 	timr->sigq->info.si_code = SI_TIMER;
 	timr->sigq->info.si_tid = timr->it_id;
 	timr->sigq->info.si_value = timr->it_sigev_value;
@@ -450,6 +458,7 @@ static struct k_itimer * alloc_posix_tim
 		kmem_cache_free(posix_timers_cache, tmr);
 		tmr = NULL;
 	}
+	memset(&tmr->sigq->info, 0, sizeof(siginfo_t));
 	return tmr;
 }
 
diff -puN kernel/signal.c~posix-timers-fix-posix_timer_event-vs-dequeue_signal-race kernel/signal.c
--- a/kernel/signal.c~posix-timers-fix-posix_timer_event-vs-dequeue_signal-race
+++ a/kernel/signal.c
@@ -1304,6 +1304,7 @@ int send_sigqueue(struct sigqueue *q, st
 		q->info.si_overrun++;
 		goto out;
 	}
+	q->info.si_overrun = 0;
 
 	signalfd_notify(t, sig);
 	pending = group ? &t->signal->shared_pending : &t->pending;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
posix-timers-fix-posix_timer_event-vs-dequeue_signal-race.patch
posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch

