From: akpm@linux-foundation.org
Subject: [merged] posix_cpu_timers-consolidate-timer-list-cleanups.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:37:40 -0700
Message-ID: <51db1504.rlp4lmtQWInc3V0B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3GHThl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, sgruszka@redhat.com, oleg@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl, fweisbec@gmail.com

Subject: [merged] posix_cpu_timers-consolidate-timer-list-cleanups.patch removed from -mm tree
To: fweisbec@gmail.com,a.p.zijlstra@chello.nl,mingo@elte.hu,oleg@redhat.com,sgruszka@redhat.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:40 -0700


The patch titled
     Subject: posix_cpu_timers: consolidate timer list cleanups
has been removed from the -mm tree.  Its filename was
     posix_cpu_timers-consolidate-timer-list-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: posix_cpu_timers: consolidate timer list cleanups

Cleaning up the posix cpu timers on task exit shares some common code
among timer list types, most notably the list traversal and expiry time
update.

Unify this in a common helper.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |   48 ++++++++++++++----------------------
 1 file changed, 19 insertions(+), 29 deletions(-)

diff -puN kernel/posix-cpu-timers.c~posix_cpu_timers-consolidate-timer-list-cleanups kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~posix_cpu_timers-consolidate-timer-list-cleanups
+++ a/kernel/posix-cpu-timers.c
@@ -399,6 +399,21 @@ static int posix_cpu_timer_del(struct k_
 	return ret;
 }
 
+static void cleanup_timers_list(struct list_head *head,
+				unsigned long long curr)
+{
+	struct cpu_timer_list *timer, *next;
+
+	list_for_each_entry_safe(timer, next, head, entry) {
+		list_del_init(&timer->entry);
+		if (timer->expires < curr) {
+			timer->expires = 0;
+		} else {
+			timer->expires -= curr;
+		}
+	}
+}
+
 /*
  * Clean out CPU timers still ticking when a thread exited.  The task
  * pointer is cleared, and the expiry time is replaced with the residual
@@ -409,37 +424,12 @@ static void cleanup_timers(struct list_h
 			   cputime_t utime, cputime_t stime,
 			   unsigned long long sum_exec_runtime)
 {
-	struct cpu_timer_list *timer, *next;
-	cputime_t ptime = utime + stime;
 
-	list_for_each_entry_safe(timer, next, head, entry) {
-		list_del_init(&timer->entry);
-		if (timer->expires < cputime_to_expires(ptime)) {
-			timer->expires = 0;
-		} else {
-			timer->expires -= cputime_to_expires(ptime);
-		}
-	}
-
-	++head;
-	list_for_each_entry_safe(timer, next, head, entry) {
-		list_del_init(&timer->entry);
-		if (timer->expires < cputime_to_expires(utime)) {
-			timer->expires = 0;
-		} else {
-			timer->expires -= cputime_to_expires(utime);
-		}
-	}
+	cputime_t ptime = utime + stime;
 
-	++head;
-	list_for_each_entry_safe(timer, next, head, entry) {
-		list_del_init(&timer->entry);
-		if (timer->expires < sum_exec_runtime) {
-			timer->expires = 0;
-		} else {
-			timer->expires -= sum_exec_runtime;
-		}
-	}
+	cleanup_timers_list(head, cputime_to_expires(ptime));
+	cleanup_timers_list(++head, cputime_to_expires(utime));
+	cleanup_timers_list(++head, sum_exec_runtime);
 }
 
 /*
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

