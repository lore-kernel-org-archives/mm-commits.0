From: akpm@linux-foundation.org
Subject: - posix-timers-lock_timer-kill-the-bogus-it_id-check.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:27:53 -0700
Message-ID: <200810092227.m99MRre7006020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370AbYJIW26 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:28:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix-timers: lock_timer: kill the bogus ->it_id check
has been removed from the -mm tree.  Its filename was
     posix-timers-lock_timer-kill-the-bogus-it_id-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix-timers: lock_timer: kill the bogus ->it_id check
From: Oleg Nesterov <oleg@tv-sign.ru>

lock_timer() checks that the timer found by idr_find(timer_id) has ->it_id
== timer_id.  This buys nothing.  This check can fail only if
sys_timer_create() unlocked idr_lock after idr_get_new(), but didn't set
->it_id = new_timer_id yet.  But in that case ->it_process == NULL so
lock_timer() can't succeed anyway.

Also remove a couple of unneeded typecasts.

Note that with or without this patch we have a small problem. 
sys_timer_create() doesn't ensure that the result of setting (say)
->it_sigev_notify must be visible if lock_timer() succeeds.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-lock_timer-kill-the-bogus-it_id-check kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-lock_timer-kill-the-bogus-it_id-check
+++ a/kernel/posix-timers.c
@@ -490,8 +490,7 @@ sys_timer_create(const clockid_t which_c
 		goto out;
 	}
 	spin_lock_irq(&idr_lock);
-	error = idr_get_new(&posix_timers_id, (void *) new_timer,
-			    &new_timer_id);
+	error = idr_get_new(&posix_timers_id, new_timer, &new_timer_id);
 	spin_unlock_irq(&idr_lock);
 	if (error) {
 		if (error == -EAGAIN)
@@ -583,12 +582,12 @@ static struct k_itimer * lock_timer(time
 	 */
 
 	spin_lock_irqsave(&idr_lock, *flags);
-	timr = (struct k_itimer *) idr_find(&posix_timers_id, (int) timer_id);
+	timr = idr_find(&posix_timers_id, (int) timer_id);
 	if (timr) {
 		spin_lock(&timr->it_lock);
 
-		if ((timr->it_id != timer_id) || !(timr->it_process) ||
-				!same_thread_group(timr->it_process, current)) {
+		if (!timr->it_process ||
+		    !same_thread_group(timr->it_process, current)) {
 			spin_unlock(&timr->it_lock);
 			spin_unlock_irqrestore(&idr_lock, *flags);
 			timr = NULL;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

git-tip.patch
posix-timers-use-struct-pid-instead-of-struct-task_struct.patch
posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer.patch
posix-timers-simplify-de_thread-exit_itimers-path.patch
signal-procfs-lock_task_sighand-do-not-need-rcu_read_lock.patch
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
add-config_core_dump_default_elf_headers.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch
pid_ns-de_thread-kill-the-now-unneeded-child_reaper-change.patch
pid_ns-kill-the-now-unused-task_child_reaper.patch

