From: akpm@linux-foundation.org
Subject: [merged] posix_cpu_timers-consolidate-expired-timers-check.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:37:42 -0700
Message-ID: <51db1506.gRwUzuksMRM2I/SY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab3GHThn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, sgruszka@redhat.com, oleg@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl, fweisbec@gmail.com

Subject: [merged] posix_cpu_timers-consolidate-expired-timers-check.patch removed from -mm tree
To: fweisbec@gmail.com,a.p.zijlstra@chello.nl,mingo@elte.hu,oleg@redhat.com,sgruszka@redhat.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:42 -0700


The patch titled
     Subject: posix_cpu_timers: consolidate expired timers check
has been removed from the -mm tree.  Its filename was
     posix_cpu_timers-consolidate-expired-timers-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: posix_cpu_timers: consolidate expired timers check

Consolidate the common code amongst per thread and per process timers list
on tick time.

List traversal, expiry check and subsequent updates can be shared in a
common helper.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |  118 ++++++++++--------------------------
 1 file changed, 33 insertions(+), 85 deletions(-)

diff -puN kernel/posix-cpu-timers.c~posix_cpu_timers-consolidate-expired-timers-check kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~posix_cpu_timers-consolidate-expired-timers-check
+++ a/kernel/posix-cpu-timers.c
@@ -862,6 +862,28 @@ static void posix_cpu_timer_get(struct k
 	}
 }
 
+static unsigned long long
+check_timers_list(struct list_head *timers,
+		  struct list_head *firing,
+		  unsigned long long curr)
+{
+	int maxfire = 20;
+
+	while (!list_empty(timers)) {
+		struct cpu_timer_list *t;
+
+		t = list_first_entry(timers, struct cpu_timer_list, entry);
+
+		if (!--maxfire || curr < t->expires)
+			return t->expires;
+
+		t->firing = 1;
+		list_move_tail(&t->entry, firing);
+	}
+
+	return 0;
+}
+
 /*
  * Check for any per-thread CPU timers that have fired and move them off
  * the tsk->cpu_timers[N] list onto the firing list.  Here we update the
@@ -870,54 +892,20 @@ static void posix_cpu_timer_get(struct k
 static void check_thread_timers(struct task_struct *tsk,
 				struct list_head *firing)
 {
-	int maxfire;
 	struct list_head *timers = tsk->cpu_timers;
 	struct signal_struct *const sig = tsk->signal;
+	struct task_cputime *tsk_expires = &tsk->cputime_expires;
+	unsigned long long expires;
 	unsigned long soft;
 
-	maxfire = 20;
-	tsk->cputime_expires.prof_exp = 0;
-	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_first_entry(timers,
-						      struct cpu_timer_list,
-						      entry);
-		if (!--maxfire || prof_ticks(tsk) < t->expires) {
-			tsk->cputime_expires.prof_exp = expires_to_cputime(t->expires);
-			break;
-		}
-		t->firing = 1;
-		list_move_tail(&t->entry, firing);
-	}
+	expires = check_timers_list(timers, firing, prof_ticks(tsk));
+	tsk_expires->prof_exp = expires_to_cputime(expires);
 
-	++timers;
-	maxfire = 20;
-	tsk->cputime_expires.virt_exp = 0;
-	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_first_entry(timers,
-						      struct cpu_timer_list,
-						      entry);
-		if (!--maxfire || virt_ticks(tsk) < t->expires) {
-			tsk->cputime_expires.virt_exp = expires_to_cputime(t->expires);
-			break;
-		}
-		t->firing = 1;
-		list_move_tail(&t->entry, firing);
-	}
+	expires = check_timers_list(++timers, firing, virt_ticks(tsk));
+	tsk_expires->virt_exp = expires_to_cputime(expires);
 
-	++timers;
-	maxfire = 20;
-	tsk->cputime_expires.sched_exp = 0;
-	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_first_entry(timers,
-						      struct cpu_timer_list,
-						      entry);
-		if (!--maxfire || tsk->se.sum_exec_runtime < t->expires) {
-			tsk->cputime_expires.sched_exp = t->expires;
-			break;
-		}
-		t->firing = 1;
-		list_move_tail(&t->entry, firing);
-	}
+	tsk_expires->sched_exp = check_timers_list(++timers, firing,
+						   tsk->se.sum_exec_runtime);
 
 	/*
 	 * Check for the special case thread timers.
@@ -1002,7 +990,6 @@ static void check_cpu_itimer(struct task
 static void check_process_timers(struct task_struct *tsk,
 				 struct list_head *firing)
 {
-	int maxfire;
 	struct signal_struct *const sig = tsk->signal;
 	unsigned long long utime, ptime, virt_expires, prof_expires;
 	unsigned long long sum_sched_runtime, sched_expires;
@@ -1017,49 +1004,10 @@ static void check_process_timers(struct
 	utime = cputime_to_expires(cputime.utime);
 	ptime = utime + cputime_to_expires(cputime.stime);
 	sum_sched_runtime = cputime.sum_exec_runtime;
-	maxfire = 20;
-	prof_expires = 0;
-	while (!list_empty(timers)) {
-		struct cpu_timer_list *tl = list_first_entry(timers,
-						      struct cpu_timer_list,
-						      entry);
-		if (!--maxfire || ptime < tl->expires) {
-			prof_expires = tl->expires;
-			break;
-		}
-		tl->firing = 1;
-		list_move_tail(&tl->entry, firing);
-	}
 
-	++timers;
-	maxfire = 20;
-	virt_expires = 0;
-	while (!list_empty(timers)) {
-		struct cpu_timer_list *tl = list_first_entry(timers,
-						      struct cpu_timer_list,
-						      entry);
-		if (!--maxfire || utime < tl->expires) {
-			virt_expires = tl->expires;
-			break;
-		}
-		tl->firing = 1;
-		list_move_tail(&tl->entry, firing);
-	}
-
-	++timers;
-	maxfire = 20;
-	sched_expires = 0;
-	while (!list_empty(timers)) {
-		struct cpu_timer_list *tl = list_first_entry(timers,
-						      struct cpu_timer_list,
-						      entry);
-		if (!--maxfire || sum_sched_runtime < tl->expires) {
-			sched_expires = tl->expires;
-			break;
-		}
-		tl->firing = 1;
-		list_move_tail(&tl->entry, firing);
-	}
+	prof_expires = check_timers_list(timers, firing, ptime);
+	virt_expires = check_timers_list(++timers, firing, utime);
+	sched_expires = check_timers_list(++timers, firing, sum_sched_runtime);
 
 	/*
 	 * Check for the special case process timers.
_

Patches currently in -mm which might be from fweisbec@gmail.com are

origin.patch
linux-next.patch
ptrace-x86-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-arm-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-sh-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints.patch
ptrace-x86-simplify-the-disable-logic-in-ptrace_write_dr7.patch
ptrace-x86-dont-delay-disable-till-second-pass-in-ptrace_write_dr7.patch
ptrace-x86-introduce-ptrace_register_breakpoint.patch
ptrace-x86-ptrace_write_dr7-should-create-bp-if-disabled.patch
ptrace-x86-cleanup-ptrace_set_debugreg.patch
ptrace-ptrace_detach-should-do-flush_ptrace_hw_breakpointchild.patch
ptrace-x86-flush_ptrace_hw_breakpoint-shoule-clear-the-virtual-debug-registers.patch

