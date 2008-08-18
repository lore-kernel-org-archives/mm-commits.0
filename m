From: akpm@linux-foundation.org
Subject: - wait_task_inactive-fix-the-config_smp-version.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:55:36 -0700
Message-ID: <200808181955.m7IJtamd009381@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161AbYHRT4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:56:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     wait_task_inactive: fix the !CONFIG_SMP version
has been removed from the -mm tree.  Its filename was
     wait_task_inactive-fix-the-config_smp-version.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wait_task_inactive: fix the !CONFIG_SMP version
From: Oleg Nesterov <oleg@tv-sign.ru>

The semantics of wait_task_inactive() was changed, update the !SMP
version accordingly.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/sched.h~wait_task_inactive-fix-the-config_smp-version include/linux/sched.h
--- a/include/linux/sched.h~wait_task_inactive-fix-the-config_smp-version
+++ a/include/linux/sched.h
@@ -1809,7 +1809,9 @@ extern unsigned long wait_task_inactive(
 static inline unsigned long wait_task_inactive(struct task_struct *p,
 					       long match_state)
 {
-	return 1;
+	if (match_state && unlikely(p->state != match_state))
+		return 0;
+	return p->nvcsw | LONG_MIN; /* sets MSB */
 }
 #endif
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
sched-do_wait_for_common-use-signal_pending_state.patch
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

