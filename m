From: akpm@linux-foundation.org
Subject: - ftrace-disable-function-tracing-bringing-up-new-cpu.patch removed from -mm tree
Date: Thu, 21 Aug 2008 09:02:58 -0700
Message-ID: <200808211602.m7LG2wOZ013066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727AbYHUQDa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 12:03:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, srostedt@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ftrace: disable function tracing bringing up new CPU
has been removed from the -mm tree.  Its filename was
     ftrace-disable-function-tracing-bringing-up-new-cpu.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ftrace: disable function tracing bringing up new CPU
From: Steven Rostedt <rostedt@goodmis.org>

Peter Zijlstra found that taking down and bringing up a new CPU caused
ftrace to crash the kernel.  This was due to some arch calls that were
being traced by the function tracer before the smp_processor_id was set
up.  Since the function tracer uses smp_processor_id it caused a triple
fault.

Instead of adding notrace all over the architecture code to prevent this
problem, it is easier to simply disable the function tracer when bringing
up a new CPU.

[akpm@linux-foundation.org: fix unused var warning]
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ftrace.h            |   11 ++++++++---
 kernel/cpu.c                      |    9 +++++++++
 kernel/trace/ftrace.c             |   23 +++++++++++++++++++++++
 kernel/trace/trace_irqsoff.c      |    3 +++
 kernel/trace/trace_sched_wakeup.c |    2 +-
 5 files changed, 44 insertions(+), 4 deletions(-)

diff -puN include/linux/ftrace.h~ftrace-disable-function-tracing-bringing-up-new-cpu include/linux/ftrace.h
--- a/include/linux/ftrace.h~ftrace-disable-function-tracing-bringing-up-new-cpu
+++ a/include/linux/ftrace.h
@@ -32,10 +32,15 @@ void clear_ftrace_function(void);
 
 extern void ftrace_stub(unsigned long a0, unsigned long a1);
 
+void ftrace_enable(void);
+void ftrace_disable(void);
+
 #else /* !CONFIG_FTRACE */
-# define register_ftrace_function(ops) do { } while (0)
-# define unregister_ftrace_function(ops) do { } while (0)
-# define clear_ftrace_function(ops) do { } while (0)
+# define register_ftrace_function(ops)		do { } while (0)
+# define unregister_ftrace_function(ops)	do { } while (0)
+# define clear_ftrace_function(ops)		do { } while (0)
+# define ftrace_enable()			do { } while (0)
+# define ftrace_disable()			do { } while (0)
 #endif /* CONFIG_FTRACE */
 
 #ifdef CONFIG_DYNAMIC_FTRACE
diff -puN kernel/cpu.c~ftrace-disable-function-tracing-bringing-up-new-cpu kernel/cpu.c
--- a/kernel/cpu.c~ftrace-disable-function-tracing-bringing-up-new-cpu
+++ a/kernel/cpu.c
@@ -14,6 +14,7 @@
 #include <linux/kthread.h>
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
+#include <linux/ftrace.h>
 
 /*
  * Represents all cpu's present in the system
@@ -343,8 +344,16 @@ static int __cpuinit _cpu_up(unsigned in
 		goto out_notify;
 	}
 
+	/*
+	 * Disable function tracing while bringing up a new CPU.
+	 * We don't want to trace functions that can not handle a
+	 * smp_processor_id() call.
+	 */
+	ftrace_disable();
+
 	/* Arch-specific enabling code. */
 	ret = __cpu_up(cpu);
+	ftrace_enable();
 	if (ret != 0)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
diff -puN kernel/trace/ftrace.c~ftrace-disable-function-tracing-bringing-up-new-cpu kernel/trace/ftrace.c
--- a/kernel/trace/ftrace.c~ftrace-disable-function-tracing-bringing-up-new-cpu
+++ a/kernel/trace/ftrace.c
@@ -151,6 +151,29 @@ static int __unregister_ftrace_function(
 	return ret;
 }
 
+static int save_ftrace_enabled;
+
+void ftrace_disable(void)
+{
+	mutex_lock(&ftrace_sysctl_lock);
+
+	save_ftrace_enabled = ftrace_enabled;
+	ftrace_enabled = 0;
+}
+
+void ftrace_enable(void)
+{
+	/* ftrace_enable must be paired with ftrace_disable */
+	if (!mutex_is_locked(&ftrace_sysctl_lock)) {
+		WARN_ON(1);
+		return;
+	}
+
+	ftrace_enabled = save_ftrace_enabled;
+
+	mutex_unlock(&ftrace_sysctl_lock);
+}
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 static struct task_struct *ftraced_task;
diff -puN kernel/trace/trace_irqsoff.c~ftrace-disable-function-tracing-bringing-up-new-cpu kernel/trace/trace_irqsoff.c
--- a/kernel/trace/trace_irqsoff.c~ftrace-disable-function-tracing-bringing-up-new-cpu
+++ a/kernel/trace/trace_irqsoff.c
@@ -76,6 +76,9 @@ irqsoff_tracer_call(unsigned long ip, un
 	long disabled;
 	int cpu;
 
+	if (unlikely(!ftrace_enabled))
+		return;
+
 	/*
 	 * Does not matter if we preempt. We test the flags
 	 * afterward, to see if irqs are disabled or not.
diff -puN kernel/trace/trace_sched_wakeup.c~ftrace-disable-function-tracing-bringing-up-new-cpu kernel/trace/trace_sched_wakeup.c
--- a/kernel/trace/trace_sched_wakeup.c~ftrace-disable-function-tracing-bringing-up-new-cpu
+++ a/kernel/trace/trace_sched_wakeup.c
@@ -45,7 +45,7 @@ wakeup_tracer_call(unsigned long ip, uns
 	int resched;
 	int cpu;
 
-	if (likely(!wakeup_task))
+	if (likely(!wakeup_task) || !ftrace_enabled)
 		return;
 
 	resched = need_resched();
_

Patches currently in -mm which might be from rostedt@goodmis.org are

linux-next.patch
rcu-just-rename-call_rcu_bh-instead-of-making-it-a-macro.patch
rcu-trace-fix-possible-mem-leak.patch
ftrace-new-continue-entry-separate-out-from-trace_entry.patch
ftrace-printk-formatting-infrastructure.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch

