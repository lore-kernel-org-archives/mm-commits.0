From: akpm@linux-foundation.org
Subject: + posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch added to -mm tree
Date: Mon, 19 May 2008 23:33:01 -0700
Message-ID: <200805200633.m4K6X1K8008974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756835AbYETGuv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 02:50:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, johnstul@us.ibm.com, roland@redhat.com, tglx@linutronix.de


The patch titled
     posix timers: release_posix_timer: kill the bogus put_task_struct(->it_process);
has been added to the -mm tree.  Its filename is
     posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch

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
Subject: posix timers: release_posix_timer: kill the bogus put_task_struct(->it_process);
From: Oleg Nesterov <oleg@tv-sign.ru>

release_posix_timer() can't be called with ->it_process != NULL.  Once
sys_timer_create() sets ->it_process it must not call
release_posix_timer(), otherwise we can race with another thread doing
sys_timer_delete(), this timer is visible to idr_find() and unlocked.

The same is true for two other callers (actually, for any possible
caller), sys_timer_delete() and itimer_delete().  They must clear
->it_process before unlock_timer() + release_posix_timer().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process
+++ a/kernel/posix-timers.c
@@ -449,9 +449,6 @@ static void release_posix_timer(struct k
 		spin_unlock_irqrestore(&idr_lock, flags);
 	}
 	sigqueue_free(tmr->sigq);
-	if (unlikely(tmr->it_process) &&
-	    tmr->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-		put_task_struct(tmr->it_process);
 	kmem_cache_free(posix_timers_cache, tmr);
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

