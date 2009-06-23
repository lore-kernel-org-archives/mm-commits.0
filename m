From: akpm@linux-foundation.org
Subject: + posix_cpu_timers_exit_group-do-not-use-thread_group_cputimer.patch added to -mm tree
Date: Tue, 23 Jun 2009 15:24:17 -0700
Message-ID: <200906232224.n5NMOH4x023589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753896AbZFWWYs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 18:24:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sgruszka@redhat.com, a.p.zijlstra@chello.nl, roland@redhat.com, tglx@linutronix.de, vmayatsk@redhat.com


The patch titled
     posix_cpu_timers_exit_group(): do not use thread_group_cputimer()
has been added to the -mm tree.  Its filename is
     posix_cpu_timers_exit_group-do-not-use-thread_group_cputimer.patch

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
posix_cpu_timers_exit_group-do-not-use-thread_group_cputimer.patch

