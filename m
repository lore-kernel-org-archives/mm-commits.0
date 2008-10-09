From: akpm@linux-foundation.org
Subject: - posix-timers-lock_timer-make-it-readable.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:27:57 -0700
Message-ID: <200810092227.m99MRv4j006023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751552AbYJIW3C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:29:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix-timers: lock_timer: make it readable
has been removed from the -mm tree.  Its filename was
     posix-timers-lock_timer-make-it-readable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix-timers: lock_timer: make it readable
From: Oleg Nesterov <oleg@tv-sign.ru>

Cleanup.  Imho makes the code much more understandable.  At least this
patch lessens both the source and compiled code.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-lock_timer-make-it-readable kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-lock_timer-make-it-readable
+++ a/kernel/posix-timers.c
@@ -572,7 +572,7 @@ out:
  * the find to the timer lock.  To avoid a dead lock, the timer id MUST
  * be release with out holding the timer lock.
  */
-static struct k_itimer * lock_timer(timer_t timer_id, unsigned long *flags)
+static struct k_itimer *lock_timer(timer_t timer_id, unsigned long *flags)
 {
 	struct k_itimer *timr;
 	/*
@@ -580,23 +580,20 @@ static struct k_itimer * lock_timer(time
 	 * flags part over to the timer lock.  Must not let interrupts in
 	 * while we are moving the lock.
 	 */
-
 	spin_lock_irqsave(&idr_lock, *flags);
-	timr = idr_find(&posix_timers_id, (int) timer_id);
+	timr = idr_find(&posix_timers_id, (int)timer_id);
 	if (timr) {
 		spin_lock(&timr->it_lock);
-
-		if (!timr->it_process ||
-		    !same_thread_group(timr->it_process, current)) {
-			spin_unlock(&timr->it_lock);
-			spin_unlock_irqrestore(&idr_lock, *flags);
-			timr = NULL;
-		} else
+		if (timr->it_process &&
+		    same_thread_group(timr->it_process, current)) {
 			spin_unlock(&idr_lock);
-	} else
-		spin_unlock_irqrestore(&idr_lock, *flags);
+			return timr;
+		}
+		spin_unlock(&timr->it_lock);
+	}
+	spin_unlock_irqrestore(&idr_lock, *flags);
 
-	return timr;
+	return NULL;
 }
 
 /*
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

