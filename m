From: akpm@linux-foundation.org
Subject: [merged] posix_cpu_timers_exit_group-do-not-use-thread_group_cputimer.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:28:23 -0700
Message-ID: <200908101928.n7AJSNIu027548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752474AbZHJT2u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:28:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sgruszka@redhat.com, a.p.zijlstra@chello.nl, roland@redhat.com, tglx@linutronix.de, vmayatsk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     posix_cpu_timers_exit_group(): do not use thread_group_cputimer()
has been removed from the -mm tree.  Its filename was
     posix_cpu_timers_exit_group-do-not-use-thread_group_cputimer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix_cpu_timers_exit_group(): do not use thread_group_cputimer()
From: Stanislaw Gruszka <sgruszka@redhat.com>

When the process exits we don't have to run new cputimer nor use running
one (as it not accounts when tsk->exit_state != 0) to get process CPU
times.  As there is only one thread we can just use CPU times fields from
task and signal structs.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Roland McGrath <roland@redhat.com>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/posix-cpu-timers.c~posix_cpu_timers_exit_group-do-not-use-thread_group_cputimer kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~posix_cpu_timers_exit_group-do-not-use-thread_group_cputimer
+++ a/kernel/posix-cpu-timers.c
@@ -521,11 +521,12 @@ void posix_cpu_timers_exit(struct task_s
 }
 void posix_cpu_timers_exit_group(struct task_struct *tsk)
 {
-	struct task_cputime cputime;
+	struct signal_struct *const sig = tsk->signal;
 
-	thread_group_cputimer(tsk, &cputime);
 	cleanup_timers(tsk->signal->cpu_timers,
-		       cputime.utime, cputime.stime, cputime.sum_exec_runtime);
+		       cputime_add(tsk->utime, sig->utime),
+		       cputime_add(tsk->stime, sig->stime),
+		       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
 }
 
 static void clear_dead_task(struct k_itimer *timer, union cpu_time_count now)
_

Patches currently in -mm which might be from sgruszka@redhat.com are

origin.patch
linux-next.patch

