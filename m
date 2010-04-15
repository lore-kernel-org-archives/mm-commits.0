From: akpm@linux-foundation.org
Subject: [merged] cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch removed from -mm tree
Date: Thu, 15 Apr 2010 11:38:30 -0400
Message-ID: <201004151840.o3FIe8FB024368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856Ab0DOSrM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Apr 2010 14:47:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sgruszka@redhat.com, a.p.zijlstra@chello.nl, balbir@in.ibm.com, mingo@elte.hu, oleg@redhat.com, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     cpu-timers: assure to not iterate over all threads in fastpath_timer_check()
has been removed from the -mm tree.  Its filename was
     cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu-timers: assure to not iterate over all threads in fastpath_timer_check()
From: Stanislaw Gruszka <sgruszka@redhat.com>

Spread p->sighand->siglock locking scope to assure fastpath_timer_check()
never iterate over each threads.  Without locking there is small
possibility that signal->cputimer will stop running while we write values
to signal->cputime_expires.

Calling thread_group_cputime() from fastpath_timer_check() is not only bad
because it is slow, also it is racy with __exit_signal() which can lead to
invalid signal->{s,u}time values.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN kernel/posix-cpu-timers.c~cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check
+++ a/kernel/posix-cpu-timers.c
@@ -549,7 +549,7 @@ static inline int expires_gt(cputime_t e
 /*
  * Insert the timer on the appropriate list before any timers that
  * expire later.  This must be called with the tasklist_lock held
- * for reading, and interrupts disabled.
+ * for reading, interrupts disabled and p->sighand->siglock taken.
  */
 static void arm_timer(struct k_itimer *timer)
 {
@@ -568,9 +568,6 @@ static void arm_timer(struct k_itimer *t
 	}
 	head += CPUCLOCK_WHICH(timer->it_clock);
 
-	BUG_ON(!irqs_disabled());
-	spin_lock(&p->sighand->siglock);
-
 	listpos = head;
 	list_for_each_entry(next, head, entry) {
 		if (cpu_time_before(timer->it_clock, nt->expires, next->expires))
@@ -605,8 +602,6 @@ static void arm_timer(struct k_itimer *t
 			break;
 		}
 	}
-
-	spin_unlock(&p->sighand->siglock);
 }
 
 /*
@@ -719,7 +714,6 @@ int posix_cpu_timer_set(struct k_itimer 
 		ret = TIMER_RETRY;
 	} else
 		list_del_init(&timer->it.cpu.entry);
-	spin_unlock(&p->sighand->siglock);
 
 	/*
 	 * We need to sample the current value to convert the new
@@ -773,6 +767,7 @@ int posix_cpu_timer_set(struct k_itimer 
 		 * disable this firing since we are already reporting
 		 * it as an overrun (thanks to bump_cpu_timer above).
 		 */
+		spin_unlock(&p->sighand->siglock);
 		read_unlock(&tasklist_lock);
 		goto out;
 	}
@@ -792,6 +787,7 @@ int posix_cpu_timer_set(struct k_itimer 
 		arm_timer(timer);
 	}
 
+	spin_unlock(&p->sighand->siglock);
 	read_unlock(&tasklist_lock);
 
 	/*
@@ -1209,6 +1205,7 @@ void posix_cpu_timer_schedule(struct k_i
 			goto out;
 		}
 		read_lock(&tasklist_lock); /* arm_timer needs it.  */
+		spin_lock(&p->sighand->siglock);
 	} else {
 		read_lock(&tasklist_lock);
 		if (unlikely(p->signal == NULL)) {
@@ -1229,6 +1226,7 @@ void posix_cpu_timer_schedule(struct k_i
 			clear_dead_task(timer, now);
 			goto out_unlock;
 		}
+		spin_lock(&p->sighand->siglock);
 		cpu_timer_sample_group(timer->it_clock, p, &now);
 		bump_cpu_timer(timer, now);
 		/* Leave the tasklist_lock locked for the call below.  */
@@ -1237,7 +1235,9 @@ void posix_cpu_timer_schedule(struct k_i
 	/*
 	 * Now re-arm for the new expiry time.
 	 */
+	BUG_ON(!irqs_disabled());
 	arm_timer(timer);
+	spin_unlock(&p->sighand->siglock);
 
 out_unlock:
 	read_unlock(&tasklist_lock);
_

Patches currently in -mm which might be from sgruszka@redhat.com are

linux-next.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
posix-cpu-timers-avoid-task-signal-=-null-checks.patch
ia64-ptrace_attach_sync_user_rbs-avoid-task-signal-=-null-checks.patch
exit-__exit_signal-use-thread_group_leader-consistently.patch
kill-the-obsolete-thread_group_cputime_free-and-taskstats_tgid_init-helpers.patch
exit-move-taskstats_tgid_free-from-__exit_signal-to-free_signal_struct.patch
check_unshare_flags-kill-the-bogus-clone_sighand-sig-count-check.patch

