From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?kernel-hung=5Ftaskc-introduce-sysctl-to-print-all-traces-wh?=
 =?US-ASCII?Q?en-a-hung-task-is-detected.patch?= removed from -mm tree
Date: Mon, 08 Jun 2020 15:32:00 -0700
Message-ID: <20200608223200.K4LUygbOF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726740AbgFHWcB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:32:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gpiccoli@canonical.com, keescook@chromium.org, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp


The patch titled
     Subject: kernel/hung_task.c: introduce sysctl to print all traces when a hung task is detected
has been removed from the -mm tree.  Its filename was
     kernel-hung_taskc-introduce-sysctl-to-print-all-traces-when-a-hung-task-is-detected.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: kernel/hung_task.c: introduce sysctl to print all traces when a hung task is detected

Commit 401c636a0eeb ("kernel/hung_task.c: show all hung tasks before
panic") introduced a change in that we started to show all CPUs backtraces
when a hung task is detected _and_ the sysctl/kernel parameter
"hung_task_panic" is set.  The idea is good, because usually when
observing deadlocks (that may lead to hung tasks), the culprit is another
task holding a lock and not necessarily the task detected as hung.

The problem with this approach is that dumping backtraces is a slightly
expensive task, specially printing that on console (and specially in many
CPU machines, as servers commonly found nowadays).  So, users that plan to
collect a kdump to investigate the hung tasks and narrow down the deadlock
definitely don't need the CPUs backtrace on dmesg/console, which will
delay the panic and pollute the log (crash tool would easily grab all CPUs
traces with 'bt -a' command).

Also, there's the reciprocal scenario: some users may be interested in
seeing the CPUs backtraces but not have the system panic when a hung task
is detected.  The current approach hence is almost as embedding a policy
in the kernel, by forcing the CPUs backtraces' dump (only) on
hung_task_panic.

This patch decouples the panic event on hung task from the CPUs backtraces
dump, by creating (and documenting) a new sysctl called
"hung_task_all_cpu_backtrace", analog to the approach taken on soft/hard
lockups, that have both a panic and an "all_cpu_backtrace" sysctl to allow
individual control.  The new mechanism for dumping the CPUs backtraces on
hung task detection respects "hung_task_warnings" by not dumping the
traces in case there's no warnings left.

Link: http://lkml.kernel.org/r/20200327223646.20779-1-gpiccoli@canonical.com
Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |   14 ++++++++++++
 include/linux/sched/sysctl.h                |    7 ++++++
 kernel/hung_task.c                          |   20 ++++++++++++++++--
 kernel/sysctl.c                             |   11 +++++++++
 4 files changed, 50 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~kernel-hung_taskc-introduce-sysctl-to-print-all-traces-when-a-hung-task-is-detected
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -335,6 +335,20 @@ Path for the hotplug policy agent.
 Default value is "``/sbin/hotplug``".
 
 
+hung_task_all_cpu_backtrace:
+================
+
+If this option is set, the kernel will send an NMI to all CPUs to dump
+their backtraces when a hung task is detected. This file shows up if
+CONFIG_DETECT_HUNG_TASK and CONFIG_SMP are enabled.
+
+0: Won't show all CPUs backtraces when a hung task is detected.
+This is the default behavior.
+
+1: Will non-maskably interrupt all CPUs and dump their backtraces when
+a hung task is detected.
+
+
 hung_task_panic
 ===============
 
--- a/include/linux/sched/sysctl.h~kernel-hung_taskc-introduce-sysctl-to-print-all-traces-when-a-hung-task-is-detected
+++ a/include/linux/sched/sysctl.h
@@ -7,6 +7,13 @@
 struct ctl_table;
 
 #ifdef CONFIG_DETECT_HUNG_TASK
+
+#ifdef CONFIG_SMP
+extern unsigned int sysctl_hung_task_all_cpu_backtrace;
+#else
+#define sysctl_hung_task_all_cpu_backtrace 0
+#endif /* CONFIG_SMP */
+
 extern int	     sysctl_hung_task_check_count;
 extern unsigned int  sysctl_hung_task_panic;
 extern unsigned long sysctl_hung_task_timeout_secs;
--- a/kernel/hung_task.c~kernel-hung_taskc-introduce-sysctl-to-print-all-traces-when-a-hung-task-is-detected
+++ a/kernel/hung_task.c
@@ -53,9 +53,18 @@ int __read_mostly sysctl_hung_task_warni
 static int __read_mostly did_panic;
 static bool hung_task_show_lock;
 static bool hung_task_call_panic;
+static bool hung_task_show_all_bt;
 
 static struct task_struct *watchdog_task;
 
+#ifdef CONFIG_SMP
+/*
+ * Should we dump all CPUs backtraces in a hung task event?
+ * Defaults to 0, can be changed via sysctl.
+ */
+unsigned int __read_mostly sysctl_hung_task_all_cpu_backtrace;
+#endif /* CONFIG_SMP */
+
 /*
  * Should we panic (and reboot, if panic_timeout= is set) when a
  * hung task is detected:
@@ -127,6 +136,9 @@ static void check_hung_task(struct task_
 			" disables this message.\n");
 		sched_show_task(t);
 		hung_task_show_lock = true;
+
+		if (sysctl_hung_task_all_cpu_backtrace)
+			hung_task_show_all_bt = true;
 	}
 
 	touch_nmi_watchdog();
@@ -191,10 +203,14 @@ static void check_hung_uninterruptible_t
 	rcu_read_unlock();
 	if (hung_task_show_lock)
 		debug_show_all_locks();
-	if (hung_task_call_panic) {
+
+	if (hung_task_show_all_bt) {
+		hung_task_show_all_bt = false;
 		trigger_all_cpu_backtrace();
-		panic("hung_task: blocked tasks");
 	}
+
+	if (hung_task_call_panic)
+		panic("hung_task: blocked tasks");
 }
 
 static long hung_timeout_jiffies(unsigned long last_checked,
--- a/kernel/sysctl.c~kernel-hung_taskc-introduce-sysctl-to-print-all-traces-when-a-hung-task-is-detected
+++ a/kernel/sysctl.c
@@ -2437,6 +2437,17 @@ static struct ctl_table kern_table[] = {
 	},
 #endif
 #ifdef CONFIG_DETECT_HUNG_TASK
+#ifdef CONFIG_SMP
+	{
+		.procname	= "hung_task_all_cpu_backtrace",
+		.data		= &sysctl_hung_task_all_cpu_backtrace,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif /* CONFIG_SMP */
 	{
 		.procname	= "hung_task_panic",
 		.data		= &sysctl_hung_task_panic,
_

Patches currently in -mm which might be from gpiccoli@canonical.com are
