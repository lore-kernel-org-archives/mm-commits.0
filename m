Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A102D7D47
	for <mm-commits@vger.kernel.org>; Thu, 13 Nov 2025 22:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074116; cv=none; b=J9nwIRdgT8QmeO+fByztqdo8XjcGgURU87Zv1KvZAaJmfacbdp2N1sc+JSxJJZuwCi58yFZF8gR15koMAC8QIldSkMfTd3P0LlQBzECg+q2kHrxYPuxaEl1jOEcXs/v6XbjsNkLAS4FZgy5xNUlwzZnYCO86EdFZDLY83yr+ni0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074116; c=relaxed/simple;
	bh=ZdOhoP22a0m9swVXaNMeiWZYpqlkbj5+SWAbvmh22Ng=;
	h=Date:To:From:Subject:Message-Id; b=aUSM7FyIGepiWB6Cs37+U8bQkOIC0OSwV0fvLnkTRT6+GbWBcYbPxZ4UG4cVMShPlo7BYawezqueZjMM9+/HSSKIVsXnvu4fAx0QO2Pvhrp9jPCAOt6au+LLin0rOsntMomdW9haLIReBC7oETzaVkfr9TpAo3cfJqUsqvH2xtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WOEGataa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WOEGataa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F851C4CEF7;
	Thu, 13 Nov 2025 22:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763074115;
	bh=ZdOhoP22a0m9swVXaNMeiWZYpqlkbj5+SWAbvmh22Ng=;
	h=Date:To:From:Subject:From;
	b=WOEGataaPLeL1cmJqko8EuP9sHRYLbQcleUFWAeV3CeKrYXDsIMn9pOK+89WcJQvM
	 4CfSYNtAj0/QFR683Oi9Fe31vkxQBNGbWDwO4tmArPhYsb0S23zHrgPo3CJ/h6f0fr
	 N/ubWICi4Gc1v06yGqv2qSH4R8z7GjUx5/kv6uKc=
Date: Thu, 13 Nov 2025 14:48:34 -0800
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,ioworker0@gmail.com,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-add-sys_info-sysctls-to-dump-sys-info-on-system-lockup.patch added to mm-nonmm-unstable branch
Message-Id: <20251113224835.5F851C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog: add sys_info sysctls to dump sys info on system lockup
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-add-sys_info-sysctls-to-dump-sys-info-on-system-lockup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-add-sys_info-sysctls-to-dump-sys-info-on-system-lockup.patch

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
Subject: watchdog: add sys_info sysctls to dump sys info on system lockup
Date: Thu, 13 Nov 2025 19:10:38 +0800

When soft/hard lockup happens, developers may need different kinds of
system information (call-stacks, memory info, locks, etc.) to help
debugging.

Add 'softlockup_sys_info' and 'hardlockup_sys_info' sysctl knobs to take
human readable string like "tasks,mem,timers,locks,ftrace,...", and when
system lockup happens, all requested information will be printed out. 
(refer kernel/sys_info.c for more details).

Link: https://lkml.kernel.org/r/20251113111039.22701-4-feng.tang@linux.alibaba.com
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    5 ++
 kernel/watchdog.c                           |   44 ++++++++++++++++--
 2 files changed, 46 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~watchdog-add-sys_info-sysctls-to-dump-sys-info-on-system-lockup
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -582,6 +582,11 @@ if leaking kernel pointer values to unpr
 When ``kptr_restrict`` is set to 2, kernel pointers printed using
 %pK will be replaced with 0s regardless of privileges.
 
+softlockup_sys_info & hardlockup_sys_info
+=========================================
+A comma separated list of extra system information to be dumped when
+soft/hard lockup is detected, for example, "tasks,mem,timers,locks,...".
+Refer 'panic_sys_info' section below for more details.
 
 modprobe
 ========
--- a/kernel/watchdog.c~watchdog-add-sys_info-sysctls-to-dump-sys-info-on-system-lockup
+++ a/kernel/watchdog.c
@@ -25,6 +25,7 @@
 #include <linux/stop_machine.h>
 #include <linux/sysctl.h>
 #include <linux/tick.h>
+#include <linux/sys_info.h>
 
 #include <linux/sched/clock.h>
 #include <linux/sched/debug.h>
@@ -65,6 +66,13 @@ int __read_mostly sysctl_hardlockup_all_
 unsigned int __read_mostly hardlockup_panic =
 			IS_ENABLED(CONFIG_BOOTPARAM_HARDLOCKUP_PANIC);
 
+/*
+ * bitmasks to control what kinds of system info to be printed when
+ * hard lockup is detected, it could be task, memory, lock etc.
+ * Refer include/linux/sys_info.h for detailed bit definition.
+ */
+static unsigned long hardlockup_si_mask;
+
 #ifdef CONFIG_SYSFS
 
 static unsigned int hardlockup_count;
@@ -178,11 +186,15 @@ static void watchdog_hardlockup_kick(voi
 
 void watchdog_hardlockup_check(unsigned int cpu, struct pt_regs *regs)
 {
+	int hardlockup_all_cpu_backtrace;
+
 	if (per_cpu(watchdog_hardlockup_touched, cpu)) {
 		per_cpu(watchdog_hardlockup_touched, cpu) = false;
 		return;
 	}
 
+	hardlockup_all_cpu_backtrace = (hardlockup_si_mask & SYS_INFO_ALL_BT) ?
+					1 : sysctl_hardlockup_all_cpu_backtrace;
 	/*
 	 * Check for a hardlockup by making sure the CPU's timer
 	 * interrupt is incrementing. The timer interrupt should have
@@ -205,7 +217,7 @@ void watchdog_hardlockup_check(unsigned
 		 * Prevent multiple hard-lockup reports if one cpu is already
 		 * engaged in dumping all cpu back traces.
 		 */
-		if (sysctl_hardlockup_all_cpu_backtrace) {
+		if (hardlockup_all_cpu_backtrace) {
 			if (test_and_set_bit_lock(0, &hard_lockup_nmi_warn))
 				return;
 		}
@@ -234,12 +246,13 @@ void watchdog_hardlockup_check(unsigned
 			trigger_single_cpu_backtrace(cpu);
 		}
 
-		if (sysctl_hardlockup_all_cpu_backtrace) {
+		if (hardlockup_all_cpu_backtrace) {
 			trigger_allbutcpu_cpu_backtrace(cpu);
 			if (!hardlockup_panic)
 				clear_bit_unlock(0, &hard_lockup_nmi_warn);
 		}
 
+		sys_info(hardlockup_si_mask & ~SYS_INFO_ALL_BT);
 		if (hardlockup_panic)
 			nmi_panic(regs, "Hard LOCKUP");
 
@@ -330,6 +343,13 @@ static void lockup_detector_update_enabl
 int __read_mostly sysctl_softlockup_all_cpu_backtrace;
 #endif
 
+/*
+ * bitmasks to control what kinds of system info to be printed when
+ * soft lockup is detected, it could be task, memory, lock etc.
+ * Refer include/linux/sys_info.h for detailed bit definition.
+ */
+static unsigned long softlockup_si_mask;
+
 static struct cpumask watchdog_allowed_mask __read_mostly;
 
 /* Global variables, exported for sysctl */
@@ -746,7 +766,7 @@ static enum hrtimer_restart watchdog_tim
 	unsigned long touch_ts, period_ts, now;
 	struct pt_regs *regs = get_irq_regs();
 	int duration;
-	int softlockup_all_cpu_backtrace = sysctl_softlockup_all_cpu_backtrace;
+	int softlockup_all_cpu_backtrace;
 	unsigned long flags;
 
 	if (!watchdog_enabled)
@@ -758,6 +778,9 @@ static enum hrtimer_restart watchdog_tim
 	if (panic_in_progress())
 		return HRTIMER_NORESTART;
 
+	softlockup_all_cpu_backtrace = (softlockup_si_mask & SYS_INFO_ALL_BT) ?
+					1 : sysctl_softlockup_all_cpu_backtrace;
+
 	watchdog_hardlockup_kick();
 
 	/* kick the softlockup detector */
@@ -846,6 +869,7 @@ static enum hrtimer_restart watchdog_tim
 		}
 
 		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
+		sys_info(softlockup_si_mask & ~SYS_INFO_ALL_BT);
 		if (softlockup_panic)
 			panic("softlockup: hung tasks");
 	}
@@ -1197,6 +1221,13 @@ static const struct ctl_table watchdog_s
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
+	{
+		.procname	= "softlockup_sys_info",
+		.data		= &softlockup_si_mask,
+		.maxlen         = sizeof(softlockup_si_mask),
+		.mode		= 0644,
+		.proc_handler	= sysctl_sys_info_handler,
+	},
 #ifdef CONFIG_SMP
 	{
 		.procname	= "softlockup_all_cpu_backtrace",
@@ -1219,6 +1250,13 @@ static const struct ctl_table watchdog_s
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
+	{
+		.procname	= "hardlockup_sys_info",
+		.data		= &hardlockup_si_mask,
+		.maxlen         = sizeof(hardlockup_si_mask),
+		.mode		= 0644,
+		.proc_handler	= sysctl_sys_info_handler,
+	},
 #ifdef CONFIG_SMP
 	{
 		.procname	= "hardlockup_all_cpu_backtrace",
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are

docs-panic-correct-some-sys_ifo-names-in-sysctl-doc.patch
hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung.patch
watchdog-add-sys_info-sysctls-to-dump-sys-info-on-system-lockup.patch
sys_info-add-a-default-kernel-sys_info-mask.patch

