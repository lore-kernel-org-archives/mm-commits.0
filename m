From: akpm@linux-foundation.org
Subject: - posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:33:53 -0700
Message-ID: <200808122033.m7CKXrWn011834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752108AbYHLUvC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:51:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, markmc@redhat.com, mingo@elte.hu, oliver.pntr@gmail.com, roland@redhat.com, stable@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix-timers: do_schedule_next_timer: fix the setting of ->si_overrun
has been removed from the -mm tree.  Its filename was
     posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix-timers: do_schedule_next_timer: fix the setting of ->si_overrun
From: Oleg Nesterov <oleg@tv-sign.ru>

do_schedule_next_timer() sets info->si_overrun = timr->it_overrun_last,
this discards the already accumulated overruns.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mark McLoughlin <markmc@redhat.com>
Cc: Oliver Pinter <oliver.pntr@gmail.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/posix-timers.c~posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun
+++ a/kernel/posix-timers.c
@@ -304,7 +304,7 @@ void do_schedule_next_timer(struct sigin
 		else
 			schedule_next_timer(timr);
 
-		info->si_overrun = timr->it_overrun_last;
+		info->si_overrun += timr->it_overrun_last;
 	}
 
 	if (timr)
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
sched-do_wait_for_common-use-signal_pending_state.patch
wait_task_inactive-dont-consider-task-nivcsw.patch
wait_task_inactive-improve-the-returned-value-for-nvcsw-==-0.patch
wait_task_inactive-fix-the-config_smp-version.patch
posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch
posix-timers-always-do-get_task_structtimer-it_process.patch
posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch
posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch
posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch
posix-timers-sys_timer_create-cleanup-the-error-handling.patch
posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch
posix-timers-lock_timer-kill-the-bogus-it_id-check.patch
posix-timers-lock_timer-make-it-readable.patch
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

