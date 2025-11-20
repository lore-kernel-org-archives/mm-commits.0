Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF71314A7E
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676285; cv=none; b=X1emlwQHtqZ0GFrzvfkkI4YWQre9H6s/wMqOgC5bOrpziAIVcTJ5W1cJlwImiATE8qg4bHYbMnWJUYhbSb03zUoxhGeb//w1rX5D9FuruuSUeALUypOCPM544F6bf1Jn4Xov/GAS4Pg4qKHnc651TdF2xhKmL38T+jifvI0oP8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676285; c=relaxed/simple;
	bh=b6S35cwxr/E9yp2OdxdDcc05XtFYZPJ9mjJujhFgQJg=;
	h=Date:To:From:Subject:Message-Id; b=JRaFeIXTUbuQua5MtBJQu9B8lgsJkgn02TAQYa+Ey/hqqfa1RHbRsTwPd3/55lqm52WoSl5XmWsL/T8837Q+lSo7wVxOf7zfbqFfWDwCVmuAjazaGqntGWJir3a/tEWdWfUA7Rktj35p+aYHcGO5ea/PG8iPEgp4fEg4gc69DyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RKZAHxVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RKZAHxVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7087EC113D0;
	Thu, 20 Nov 2025 22:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676285;
	bh=b6S35cwxr/E9yp2OdxdDcc05XtFYZPJ9mjJujhFgQJg=;
	h=Date:To:From:Subject:From;
	b=RKZAHxVd7s1gLR73LMspPVhjfTyL/kjaMqpt3XXA5WOaxc+L8I7MK6CGbecb471xp
	 s+IkmrfFK+s9UjNawLkfROPIIZ/sq4zv3oNQN/0rUc2evegeqH4k458BW5ifp5ONou
	 aPjfs4agRO2afGuKM1P/msLbxqEV1EdDcO02D0hc=
Date: Thu, 20 Nov 2025 14:04:44 -0800
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,ioworker0@gmail.com,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-add-sys_info-sysctls-to-dump-sys-info-on-system-lockup.patch removed from -mm tree
Message-Id: <20251120220445.7087EC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog: add sys_info sysctls to dump sys info on system lockup
has been removed from the -mm tree.  Its filename was
     watchdog-add-sys_info-sysctls-to-dump-sys-info-on-system-lockup.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Petr Mladek <pmladek@suse.com>
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


