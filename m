Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90661A9FA8
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671957; cv=none; b=Z0iJ0T54IUKhcvJOQGC29Cy2lDH7K3WjG0EVlH53ghnLmjivXH1vDdGo799Y/RxJ+NfkO1QNOT/PVfeEeDdGE+b4HsFwco0Ylec6AkoeCsTFZJDM1uZ2RRmerW2JL8Ib0fTEiinXqRNH5iGnM8KfH/G49GFBEF8/v28Yp6e5w4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671957; c=relaxed/simple;
	bh=jvP6P1JjwRLKL4VOeSieqZriOa0yg1pbpAyEgAK9kXw=;
	h=Date:To:From:Subject:Message-Id; b=TH8NS6bFlHQVNPYNlPXtL5xSVvh9ugzikrZhjXx7DYieLRsuu/gdbP7aeFxWkmyi1nlTCM/nrnKrZ617vEPGYS/tpB+5XueSonKRYhjK72SN/b4RYntqGIf6RJxFKDQEumwJC6Ce7l+Il7qAfoVyU/VgHEPdma7MF689Z1B7ig8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x/UKQgTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x/UKQgTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D264C4CEF7;
	Sat, 28 Mar 2026 04:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671957;
	bh=jvP6P1JjwRLKL4VOeSieqZriOa0yg1pbpAyEgAK9kXw=;
	h=Date:To:From:Subject:From;
	b=x/UKQgTcrQh2PtoMZGBjobXCZsTRnSch8PDSUoBHmuZpA3wIUa5q7Lr5ZzQPl4pmB
	 hksd8yUVhLs5O0NGZNMZaRtj+dUo54vZxPHM4WYkFhksXj1hlzj2ycgfttXx65u5KH
	 kpzj8bekssCF1Z4B2VJQGfPZHd3sxmlFoBUK/8d0=
Date: Fri, 27 Mar 2026 21:25:57 -0700
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,skhan@linuxfoundation.org,pmladek@suse.com,max.kellermann@ionos.com,lihuafei1@huawei.com,irogers@google.com,eranian@google.com,dianders@chromium.org,cuiyunhui@bytedance.com,corbet@lwn.net,mrungta@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-return-early-in-watchdog_hardlockup_check.patch removed from -mm tree
Message-Id: <20260328042557.9D264C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog: return early in watchdog_hardlockup_check()
has been removed from the -mm tree.  Its filename was
     watchdog-return-early-in-watchdog_hardlockup_check.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mayank Rungta <mrungta@google.com>
Subject: watchdog: return early in watchdog_hardlockup_check()
Date: Thu, 12 Mar 2026 16:22:02 -0700

Patch series "watchdog/hardlockup: Improvements to hardlockup", v2.

This series addresses limitations in the hardlockup detector
implementations and updates the documentation to reflect actual behavior
and recent changes.

The changes are structured as follows:

Refactoring (Patch 1)
=====================
Patch 1 refactors watchdog_hardlockup_check() to return early if no
lockup is detected. This reduces the indentation level of the main
logic block, serving as a clean base for the subsequent changes.

Hardlockup Detection Improvements (Patches 2 & 4)
=================================================
The hardlockup detector logic relies on updating saved interrupt counts to
determine if the CPU is making progress.

Patch 1 ensures that the saved interrupt count is updated unconditionally
before checking the "touched" flag.  This prevents stale comparisons which
can delay detection.  This is a logic fix that ensures the detector
remains accurate even when the watchdog is frequently touched.

Patch 3 improves the Buddy detector's timeliness.  The current checking
interval (every 3rd sample) causes high variability in detection time (up
to 24s).  This patch changes the Buddy detector to check at every hrtimer
interval (4s) with a missed-interrupt threshold of 3, narrowing the
detection window to a consistent 8-12 second range.

Documentation Updates (Patches 3 & 5)
=====================================
The current documentation does not fully capture the variable nature of
detection latency or the details of the Buddy system.

Patch 3 removes the strict "10 seconds" definition of a hardlockup, which
was misleading given the periodic nature of the detector.  It adds a
"Detection Overhead" section to the admin guide, using "Best Case" and
"Worst Case" scenarios to illustrate that detection time can vary
significantly (e.g., ~6s to ~20s).

Patch 5 adds a dedicated section for the Buddy detector, which was
previously undocumented.  It details the mechanism, the new timing logic,
and known limitations.


This patch (of 5):

Invert the `is_hardlockup(cpu)` check in `watchdog_hardlockup_check()` to
return early when a hardlockup is not detected.  This flattens the main
logic block, reducing the indentation level and making the code easier to
read and maintain.

This refactoring serves as a preparation patch for future hardlockup
changes.

Link: https://lkml.kernel.org/r/20260312-hardlockup-watchdog-fixes-v2-0-45bd8a0cc7ed@google.com
Link: https://lkml.kernel.org/r/20260312-hardlockup-watchdog-fixes-v2-1-45bd8a0cc7ed@google.com
Signed-off-by: Mayank Rungta <mrungta@google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Stephane Erainan <eranian@google.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |  121 ++++++++++++++++++++++----------------------
 1 file changed, 61 insertions(+), 60 deletions(-)

--- a/kernel/watchdog.c~watchdog-return-early-in-watchdog_hardlockup_check
+++ a/kernel/watchdog.c
@@ -187,6 +187,8 @@ static void watchdog_hardlockup_kick(voi
 void watchdog_hardlockup_check(unsigned int cpu, struct pt_regs *regs)
 {
 	int hardlockup_all_cpu_backtrace;
+	unsigned int this_cpu;
+	unsigned long flags;
 
 	if (per_cpu(watchdog_hardlockup_touched, cpu)) {
 		per_cpu(watchdog_hardlockup_touched, cpu) = false;
@@ -201,74 +203,73 @@ void watchdog_hardlockup_check(unsigned
 	 * fired multiple times before we overflow'd. If it hasn't
 	 * then this is a good indication the cpu is stuck
 	 */
-	if (is_hardlockup(cpu)) {
-		unsigned int this_cpu = smp_processor_id();
-		unsigned long flags;
+	if (!is_hardlockup(cpu)) {
+		per_cpu(watchdog_hardlockup_warned, cpu) = false;
+		return;
+	}
 
 #ifdef CONFIG_SYSFS
-		++hardlockup_count;
+	++hardlockup_count;
 #endif
-		/*
-		 * A poorly behaving BPF scheduler can trigger hard lockup by
-		 * e.g. putting numerous affinitized tasks in a single queue and
-		 * directing all CPUs at it. The following call can return true
-		 * only once when sched_ext is enabled and will immediately
-		 * abort the BPF scheduler and print out a warning message.
-		 */
-		if (scx_hardlockup(cpu))
-			return;
+	/*
+	 * A poorly behaving BPF scheduler can trigger hard lockup by
+	 * e.g. putting numerous affinitized tasks in a single queue and
+	 * directing all CPUs at it. The following call can return true
+	 * only once when sched_ext is enabled and will immediately
+	 * abort the BPF scheduler and print out a warning message.
+	 */
+	if (scx_hardlockup(cpu))
+		return;
 
-		/* Only print hardlockups once. */
-		if (per_cpu(watchdog_hardlockup_warned, cpu))
-			return;
+	/* Only print hardlockups once. */
+	if (per_cpu(watchdog_hardlockup_warned, cpu))
+		return;
 
-		/*
-		 * Prevent multiple hard-lockup reports if one cpu is already
-		 * engaged in dumping all cpu back traces.
-		 */
-		if (hardlockup_all_cpu_backtrace) {
-			if (test_and_set_bit_lock(0, &hard_lockup_nmi_warn))
-				return;
-		}
-
-		/*
-		 * NOTE: we call printk_cpu_sync_get_irqsave() after printing
-		 * the lockup message. While it would be nice to serialize
-		 * that printout, we really want to make sure that if some
-		 * other CPU somehow locked up while holding the lock associated
-		 * with printk_cpu_sync_get_irqsave() that we can still at least
-		 * get the message about the lockup out.
-		 */
-		pr_emerg("CPU%u: Watchdog detected hard LOCKUP on cpu %u\n", this_cpu, cpu);
-		printk_cpu_sync_get_irqsave(flags);
-
-		print_modules();
-		print_irqtrace_events(current);
-		if (cpu == this_cpu) {
-			if (regs)
-				show_regs(regs);
-			else
-				dump_stack();
-			printk_cpu_sync_put_irqrestore(flags);
-		} else {
-			printk_cpu_sync_put_irqrestore(flags);
-			trigger_single_cpu_backtrace(cpu);
-		}
-
-		if (hardlockup_all_cpu_backtrace) {
-			trigger_allbutcpu_cpu_backtrace(cpu);
-			if (!hardlockup_panic)
-				clear_bit_unlock(0, &hard_lockup_nmi_warn);
-		}
-
-		sys_info(hardlockup_si_mask & ~SYS_INFO_ALL_BT);
-		if (hardlockup_panic)
-			nmi_panic(regs, "Hard LOCKUP");
+	/*
+	 * Prevent multiple hard-lockup reports if one cpu is already
+	 * engaged in dumping all cpu back traces.
+	 */
+	if (hardlockup_all_cpu_backtrace) {
+		if (test_and_set_bit_lock(0, &hard_lockup_nmi_warn))
+			return;
+	}
 
-		per_cpu(watchdog_hardlockup_warned, cpu) = true;
+	/*
+	 * NOTE: we call printk_cpu_sync_get_irqsave() after printing
+	 * the lockup message. While it would be nice to serialize
+	 * that printout, we really want to make sure that if some
+	 * other CPU somehow locked up while holding the lock associated
+	 * with printk_cpu_sync_get_irqsave() that we can still at least
+	 * get the message about the lockup out.
+	 */
+	this_cpu = smp_processor_id();
+	pr_emerg("CPU%u: Watchdog detected hard LOCKUP on cpu %u\n", this_cpu, cpu);
+	printk_cpu_sync_get_irqsave(flags);
+
+	print_modules();
+	print_irqtrace_events(current);
+	if (cpu == this_cpu) {
+		if (regs)
+			show_regs(regs);
+		else
+			dump_stack();
+		printk_cpu_sync_put_irqrestore(flags);
 	} else {
-		per_cpu(watchdog_hardlockup_warned, cpu) = false;
+		printk_cpu_sync_put_irqrestore(flags);
+		trigger_single_cpu_backtrace(cpu);
+	}
+
+	if (hardlockup_all_cpu_backtrace) {
+		trigger_allbutcpu_cpu_backtrace(cpu);
+		if (!hardlockup_panic)
+			clear_bit_unlock(0, &hard_lockup_nmi_warn);
 	}
+
+	sys_info(hardlockup_si_mask & ~SYS_INFO_ALL_BT);
+	if (hardlockup_panic)
+		nmi_panic(regs, "Hard LOCKUP");
+
+	per_cpu(watchdog_hardlockup_warned, cpu) = true;
 }
 
 #else /* CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER */
_

Patches currently in -mm which might be from mrungta@google.com are


