From: akpm@linux-foundation.org
Subject: + posix_cpu_timers-consolidate-expired-timers-check.patch added to -mm tree
Date: Mon, 18 Mar 2013 14:25:08 -0700
Message-ID: <20130318212508.D374F5A435D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:41985 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933126Ab3CRVZK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Mar 2013 17:25:10 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so445339vcb.3
        for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2013 14:25:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@redhat.com, sgruszka@redhat.com, tglx@linutronix.de


The patch titled
     Subject: posix_cpu_timers: consolidate expired timers check
has been added to the -mm tree.  Its filename is
     posix_cpu_timers-consolidate-expired-timers-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -812,6 +812,28 @@ static void posix_cpu_timer_get(struct k
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
@@ -820,54 +842,20 @@ static void posix_cpu_timer_get(struct k
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
@@ -967,7 +955,6 @@ static inline int task_cputime_zero(cons
 static void check_process_timers(struct task_struct *tsk,
 				 struct list_head *firing)
 {
-	int maxfire;
 	struct signal_struct *const sig = tsk->signal;
 	unsigned long long utime, ptime, virt_expires, prof_expires;
 	unsigned long long sum_sched_runtime, sched_expires;
@@ -982,49 +969,10 @@ static void check_process_timers(struct
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

linux-next.patch
irq_workh-fix-warning-when-config_irq_work=n.patch
printk-provide-a-wake_up_klogd-off-case.patch
printk-provide-a-wake_up_klogd-off-case-fix.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
selftests-add-basic-posix-timers-selftests.patch
mm-trace-filemap-add-and-del.patch
mm-trace-filemap-add-and-del-v2.patch
printk-tracing-rework-console-tracing.patch

