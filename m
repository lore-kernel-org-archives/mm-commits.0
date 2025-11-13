Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF60326947
	for <mm-commits@vger.kernel.org>; Thu, 13 Nov 2025 22:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074114; cv=none; b=amz5oLuyxVzU4I0hPM8o3gq8PEX7/plmitJC3QFwW43keRENF4k3LL7oqcDnuckPQ9lrv0vqS581Fo+ZBnc3pJKBK0Na0KSrMubkMSUXqiFmnBcyap/d3mRe1k+0z8UQASk+y0JSiACPa9s1KaAcLZ3MBAIZSKB4Uxu7HSpIy0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074114; c=relaxed/simple;
	bh=zUTjr5RdNJb76BVh+XFjl3WL0JetunuH+xFwMiCEwpY=;
	h=Date:To:From:Subject:Message-Id; b=DuiJqCiikzJF1TTjgfWktwuJWLmsWpBD/TSIPjgsY7s2YHyz3IvhwW5r0RL88/vYyQAeAYWGtnrDFIVkDXrUpsDoU9u00GbuPwIcofBRzhE60j+S1mDYYhHU2IHk1YFsVaM+DoOPIYbqUufMazYVJyZycLmcmEYS5piBmEk1xmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=coJ12oMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="coJ12oMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC38AC4CEF7;
	Thu, 13 Nov 2025 22:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763074114;
	bh=zUTjr5RdNJb76BVh+XFjl3WL0JetunuH+xFwMiCEwpY=;
	h=Date:To:From:Subject:From;
	b=coJ12oMRil+92JhX2dl0LpoSVrkvn8GR0BmrcbIv1bQDGSJao+lFCPD+LRq39Oafk
	 egwVHJPpIdsJc5TmINC1nwNboGncmLZfPApEVU5ARj8/UkPpyJD4jppOh4DWQxuH3J
	 3wN2D1RZ/YFhtotfE9v4Q278xdlk5VKs+BprEOEQ=
Date: Thu, 13 Nov 2025 14:48:33 -0800
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,ioworker0@gmail.com,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung.patch added to mm-nonmm-unstable branch
Message-Id: <20251113224833.EC38AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hung_task: add hung_task_sys_info sysctl to dump sys info on task-hung
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

Link: https://lkml.kernel.org/r/20251113111039.22701-3-feng.tang@linux.alibaba.com
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Suggested-by: Petr Mladek <pmladek@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    5 +
 kernel/hung_task.c                          |   62 +++++++++++-------
 2 files changed, 43 insertions(+), 24 deletions(-)

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
@@ -217,11 +223,8 @@ static inline void debug_show_blocker(st
 }
 #endif
 
-static void check_hung_task(struct task_struct *t, unsigned long timeout,
-		unsigned long prev_detect_count)
+static void check_hung_task(struct task_struct *t, unsigned long timeout)
 {
-	unsigned long total_hung_task;
-
 	if (!task_is_hung(t, timeout))
 		return;
 
@@ -231,20 +234,13 @@ static void check_hung_task(struct task_
 	 */
 	sysctl_hung_task_detect_count++;
 
-	total_hung_task = sysctl_hung_task_detect_count - prev_detect_count;
 	trace_sched_process_hang(t);
 
-	if (sysctl_hung_task_panic && total_hung_task >= sysctl_hung_task_panic) {
-		console_verbose();
-		hung_task_show_lock = true;
-		hung_task_call_panic = true;
-	}
-
 	/*
 	 * Ok, the task did not get scheduled for more than 2 minutes,
 	 * complain:
 	 */
-	if (sysctl_hung_task_warnings || hung_task_call_panic) {
+	if (sysctl_hung_task_warnings) {
 		if (sysctl_hung_task_warnings > 0)
 			sysctl_hung_task_warnings--;
 		pr_err("INFO: task %s:%d blocked for more than %ld seconds.\n",
@@ -259,10 +255,7 @@ static void check_hung_task(struct task_
 			" disables this message.\n");
 		sched_show_task(t);
 		debug_show_blocker(t, timeout);
-		hung_task_show_lock = true;
 
-		if (sysctl_hung_task_all_cpu_backtrace)
-			hung_task_show_all_bt = true;
 		if (!sysctl_hung_task_warnings)
 			pr_info("Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings\n");
 	}
@@ -302,8 +295,11 @@ static void check_hung_uninterruptible_t
 {
 	int max_count = sysctl_hung_task_check_count;
 	unsigned long last_break = jiffies;
+	unsigned long total_hung_task;
 	struct task_struct *g, *t;
 	unsigned long prev_detect_count = sysctl_hung_task_detect_count;
+	int need_warning = sysctl_hung_task_warnings;
+	unsigned long si_mask = hung_task_si_mask;
 
 	/*
 	 * If the system crashed already then all bets are off,
@@ -312,7 +308,7 @@ static void check_hung_uninterruptible_t
 	if (test_taint(TAINT_DIE) || did_panic)
 		return;
 
-	hung_task_show_lock = false;
+
 	rcu_read_lock();
 	for_each_process_thread(g, t) {
 
@@ -324,18 +320,29 @@ static void check_hung_uninterruptible_t
 			last_break = jiffies;
 		}
 
-		check_hung_task(t, timeout, prev_detect_count);
+		check_hung_task(t, timeout);
 	}
  unlock:
 	rcu_read_unlock();
-	if (hung_task_show_lock)
-		debug_show_all_locks();
 
-	if (hung_task_show_all_bt) {
-		hung_task_show_all_bt = false;
-		trigger_all_cpu_backtrace();
+	total_hung_task = sysctl_hung_task_detect_count - prev_detect_count;
+	if (!total_hung_task)
+		return;
+
+	if (sysctl_hung_task_panic && total_hung_task >= sysctl_hung_task_panic) {
+		console_verbose();
+		hung_task_call_panic = true;
+	}
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
@@ -434,6 +441,13 @@ static const struct ctl_table hung_task_
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

docs-panic-correct-some-sys_ifo-names-in-sysctl-doc.patch
hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung.patch
watchdog-add-sys_info-sysctls-to-dump-sys-info-on-system-lockup.patch
sys_info-add-a-default-kernel-sys_info-mask.patch

