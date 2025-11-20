Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EA033C52C
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676284; cv=none; b=HhMdksSAO3fp4B0tctP8QLBKz+CSkmIMXFfdhEWkX+RqXPh47CxiIX6VmK8IOHhE+0Aoc/S9+tbfyKXeDv53hqFhCFihHLZ65OJBHCWlPlCL8WoZam37AUsa/DQED7MpIKoDReK0eh/e5Bo56rc/dFBa9mbef1AgsHk24/aH6G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676284; c=relaxed/simple;
	bh=Nd9sj+WuiekdcEEBkXCrxnGOX7RCEWg0YuNO6NKC6ZM=;
	h=Date:To:From:Subject:Message-Id; b=MvBAMnzeM8B9tmiiPJe68HFCc3JOA2MQObhW1ISkMBe4u4orqP3o0AcpHj3bwFJU2l28vAEAI36Mkc2ixS6UOVSm+B+cqMNTjPZKsZ+GNNOecX+VPnTWX/z6TOS0Tgiius8K7sy/VyxDd4Sk1jcJcP/P/v4YGnu0yyas8OsJQpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cGriDOmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cGriDOmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5037C4CEF1;
	Thu, 20 Nov 2025 22:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676283;
	bh=Nd9sj+WuiekdcEEBkXCrxnGOX7RCEWg0YuNO6NKC6ZM=;
	h=Date:To:From:Subject:From;
	b=cGriDOmHGZIQfoLCplDl9WbXmxIFlSpEaPwleaOq+kRf/6CWyIH6LOkHlPidP1sxP
	 539RjeDSCUpf9ihoUBVQNMyYoSmwfHTh3mB4duhag44caiQhFyGwfmdlGH83HZVMPF
	 AMwYVYsRTgeL95f4zwegwJDw7wBs01Eo8F+I4aNc=
Date: Thu, 20 Nov 2025 14:04:43 -0800
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,lance.yang@linux.dev,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung.patch removed from -mm tree
Message-Id: <20251120220443.C5037C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task: add hung_task_sys_info sysctl to dump sys info on task-hung
has been removed from the -mm tree.  Its filename was
     hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Feng Tang <feng.tang@linux.alibaba.com>
Subject: hung_task: add hung_task_sys_info sysctl to dump sys info on task-hung
Date: Thu, 13 Nov 2025 19:10:37 +0800

When task-hung happens, developers may need different kinds of system
information (call-stacks, memory info, locks, etc.) to help debugging.

Add 'hung_task_sys_info' sysctl knob to take human readable string like
"tasks,mem,timers,locks,ftrace,...", and when task-hung happens, all
requested information will be dumped.  (refer kernel/sys_info.c for more
details).

Meanwhile, the newly introduced sys_info() call is used to unify some
existing info-dumping knobs.

[feng.tang@linux.alibaba.com: maintain consistecy established behavior, per Lance and Petr]
  Link: https://lkml.kernel.org/r/aRncJo1mA5Zk77Hr@U-2FWC9VHC-2323.local
Link: https://lkml.kernel.org/r/20251113111039.22701-3-feng.tang@linux.alibaba.com
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Suggested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    5 ++
 kernel/hung_task.c                          |   40 ++++++++++++------
 2 files changed, 33 insertions(+), 12 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -422,6 +422,11 @@ the system boot.
 
 This file shows up if ``CONFIG_DETECT_HUNG_TASK`` is enabled.
 
+hung_task_sys_info
+==================
+A comma separated list of extra system information to be dumped when
+hung task is detected, for example, "tasks,mem,timers,locks,...".
+Refer 'panic_sys_info' section below for more details.
 
 hung_task_timeout_secs
 ======================
--- a/kernel/hung_task.c~hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung
+++ a/kernel/hung_task.c
@@ -24,6 +24,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/hung_task.h>
 #include <linux/rwsem.h>
+#include <linux/sys_info.h>
 
 #include <trace/events/sched.h>
 
@@ -59,12 +60,17 @@ static unsigned long __read_mostly sysct
 static int __read_mostly sysctl_hung_task_warnings = 10;
 
 static int __read_mostly did_panic;
-static bool hung_task_show_lock;
 static bool hung_task_call_panic;
-static bool hung_task_show_all_bt;
 
 static struct task_struct *watchdog_task;
 
+/*
+ * A bitmask to control what kinds of system info to be printed when
+ * a hung task is detected, it could be task, memory, lock etc. Refer
+ * include/linux/sys_info.h for detailed bit definition.
+ */
+static unsigned long hung_task_si_mask;
+
 #ifdef CONFIG_SMP
 /*
  * Should we dump all CPUs backtraces in a hung task event?
@@ -236,7 +242,6 @@ static void check_hung_task(struct task_
 
 	if (sysctl_hung_task_panic && total_hung_task >= sysctl_hung_task_panic) {
 		console_verbose();
-		hung_task_show_lock = true;
 		hung_task_call_panic = true;
 	}
 
@@ -259,10 +264,7 @@ static void check_hung_task(struct task_
 			" disables this message.\n");
 		sched_show_task(t);
 		debug_show_blocker(t, timeout);
-		hung_task_show_lock = true;
 
-		if (sysctl_hung_task_all_cpu_backtrace)
-			hung_task_show_all_bt = true;
 		if (!sysctl_hung_task_warnings)
 			pr_info("Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings\n");
 	}
@@ -304,6 +306,8 @@ static void check_hung_uninterruptible_t
 	unsigned long last_break = jiffies;
 	struct task_struct *g, *t;
 	unsigned long prev_detect_count = sysctl_hung_task_detect_count;
+	int need_warning = sysctl_hung_task_warnings;
+	unsigned long si_mask = hung_task_si_mask;
 
 	/*
 	 * If the system crashed already then all bets are off,
@@ -312,7 +316,7 @@ static void check_hung_uninterruptible_t
 	if (test_taint(TAINT_DIE) || did_panic)
 		return;
 
-	hung_task_show_lock = false;
+
 	rcu_read_lock();
 	for_each_process_thread(g, t) {
 
@@ -328,14 +332,19 @@ static void check_hung_uninterruptible_t
 	}
  unlock:
 	rcu_read_unlock();
-	if (hung_task_show_lock)
-		debug_show_all_locks();
 
-	if (hung_task_show_all_bt) {
-		hung_task_show_all_bt = false;
-		trigger_all_cpu_backtrace();
+	if (!(sysctl_hung_task_detect_count - prev_detect_count))
+		return;
+
+	if (need_warning || hung_task_call_panic) {
+		si_mask |= SYS_INFO_LOCKS;
+
+		if (sysctl_hung_task_all_cpu_backtrace)
+			si_mask |= SYS_INFO_ALL_BT;
 	}
 
+	sys_info(si_mask);
+
 	if (hung_task_call_panic)
 		panic("hung_task: blocked tasks");
 }
@@ -434,6 +443,13 @@ static const struct ctl_table hung_task_
 		.mode		= 0444,
 		.proc_handler	= proc_doulongvec_minmax,
 	},
+	{
+		.procname	= "hung_task_sys_info",
+		.data		= &hung_task_si_mask,
+		.maxlen         = sizeof(hung_task_si_mask),
+		.mode		= 0644,
+		.proc_handler	= sysctl_sys_info_handler,
+	},
 };
 
 static void __init hung_task_sysctl_init(void)
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are


