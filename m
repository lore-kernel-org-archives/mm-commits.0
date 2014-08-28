From: akpm@linux-foundation.org
Subject: [to-be-updated]
 softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu.patch removed from -mm tree
Date: Thu, 28 Aug 2014 16:02:03 -0700
Message-ID: <53ffb4eb.FvubAjgHHUU26esx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:49837 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaH1XCF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Aug 2014 19:02:05 -0400
Received: by mail-ob0-f201.google.com with SMTP id va2so420401obc.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2014 16:02:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chaiw.fnst@cn.fujitsu.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: softlockup: make detector be aware of task switch of processes hogging cpu
has been removed from the -mm tree.  Its filename was
     softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu.patch

This patch was dropped because an updated version will be merged

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
saving/checking the pid of the hogging process and use that to reset
soft_watchdog_warn too.

[dzickus@redhat.com: modified the comment and changelog to be more specific]
Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff -puN kernel/watchdog.c~softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu kernel/watchdog.c
--- a/kernel/watchdog.c~softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu
+++ a/kernel/watchdog.c
@@ -42,6 +42,7 @@ static DEFINE_PER_CPU(bool, softlockup_t
 static DEFINE_PER_CPU(bool, soft_watchdog_warn);
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
 static DEFINE_PER_CPU(unsigned long, soft_lockup_hrtimer_cnt);
+static DEFINE_PER_CPU(pid_t, softlockup_warn_pid_saved);
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 static DEFINE_PER_CPU(bool, hard_watchdog_warn);
 static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
@@ -319,6 +320,8 @@ static enum hrtimer_restart watchdog_tim
 	 */
 	duration = is_softlockup(touch_ts);
 	if (unlikely(duration)) {
+		pid_t pid = task_pid_nr(current);
+
 		/*
 		 * If a virtual machine is stopped by the host it can look to
 		 * the watchdog like a soft lockup, check to see if the host
@@ -328,8 +331,20 @@ static enum hrtimer_restart watchdog_tim
 			return HRTIMER_RESTART;
 
 		/* only warn once */
-		if (__this_cpu_read(soft_watchdog_warn) == true)
+		if (__this_cpu_read(soft_watchdog_warn) == true) {
+
+			/*
+			 * Handle the case where multiple processes are
+			 * causing softlockups but the duration is small
+			 * enough, the softlockup detector can not reset
+			 * itself in time.  Use pids to detect this.
+			 */
+			if (__this_cpu_read(softlockup_warn_pid_saved) != pid) {
+				__this_cpu_write(soft_watchdog_warn, false);
+				__touch_watchdog();
+			}
 			return HRTIMER_RESTART;
+		}
 
 		if (softlockup_all_cpu_backtrace) {
 			/* Prevent multiple soft-lockup reports if one cpu is already
@@ -344,7 +359,8 @@ static enum hrtimer_restart watchdog_tim
 
 		pr_emerg("BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
 			smp_processor_id(), duration,
-			current->comm, task_pid_nr(current));
+			current->comm, pid);
+		__this_cpu_write(softlockup_warn_pid_saved, pid);
 		print_modules();
 		print_irqtrace_events(current);
 		if (regs)
_

Patches currently in -mm which might be from chaiw.fnst@cn.fujitsu.com are

linux-next.patch

