From: akpm@linux-foundation.org
Subject: [merged]
 softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:17:53 -0700
Message-ID: <543c1751.ShZmjB24KEqskA05%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaJMSRx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:17:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chaiw.fnst@cn.fujitsu.com, dzickus@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: softlockup: make detector be aware of task switch of processes hogging cpu
has been removed from the -mm tree.  Its filename was
     softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: chai wen <chaiw.fnst@cn.fujitsu.com>
Subject: softlockup: make detector be aware of task switch of processes hogging cpu

For now, soft lockup detector warns once for each case of process
softlockup.  But the thread 'watchdog/n' may not always get the cpu at the
time slot between the task switch of two processes hogging that cpu to
reset soft_watchdog_warn.

An example would be two processes hogging the cpu.  Process A causes the
softlockup warning and is killed manually by a user.  Process B
immediately becomes the new process hogging the cpu preventing the
softlockup code from resetting the soft_watchdog_warn variable.

This case is a false negative of "warn only once for a process", as there
may be a different process that is going to hog the cpu.  Resolve this by
saving/checking the task pointer of the hogging process and use that to
reset soft_watchdog_warn too.

[dzickus@redhat.com: update comment]
Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff -puN kernel/watchdog.c~softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu kernel/watchdog.c
--- a/kernel/watchdog.c~softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu
+++ a/kernel/watchdog.c
@@ -47,6 +47,7 @@ static DEFINE_PER_CPU(bool, softlockup_t
 static DEFINE_PER_CPU(bool, soft_watchdog_warn);
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
 static DEFINE_PER_CPU(unsigned long, soft_lockup_hrtimer_cnt);
+static DEFINE_PER_CPU(struct task_struct *, softlockup_task_ptr_saved);
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 static DEFINE_PER_CPU(bool, hard_watchdog_warn);
 static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
@@ -333,8 +334,22 @@ static enum hrtimer_restart watchdog_tim
 			return HRTIMER_RESTART;
 
 		/* only warn once */
-		if (__this_cpu_read(soft_watchdog_warn) == true)
+		if (__this_cpu_read(soft_watchdog_warn) == true) {
+			/*
+			 * When multiple processes are causing softlockups the
+			 * softlockup detector only warns on the first one
+			 * because the code relies on a full quiet cycle to
+			 * re-arm.  The second process prevents the quiet cycle
+			 * and never gets reported.  Use task pointers to detect
+			 * this.
+			 */
+			if (__this_cpu_read(softlockup_task_ptr_saved) !=
+			    current) {
+				__this_cpu_write(soft_watchdog_warn, false);
+				__touch_watchdog();
+			}
 			return HRTIMER_RESTART;
+		}
 
 		if (softlockup_all_cpu_backtrace) {
 			/* Prevent multiple soft-lockup reports if one cpu is already
@@ -350,6 +365,7 @@ static enum hrtimer_restart watchdog_tim
 		pr_emerg("BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
 			smp_processor_id(), duration,
 			current->comm, task_pid_nr(current));
+		__this_cpu_write(softlockup_task_ptr_saved, current);
 		print_modules();
 		print_irqtrace_events(current);
 		if (regs)
_

Patches currently in -mm which might be from chaiw.fnst@cn.fujitsu.com are

origin.patch
linux-next.patch

