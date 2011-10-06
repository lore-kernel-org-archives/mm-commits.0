From: akpm@google.com
Subject: + x86-reduce-clock-calibration-time-during-slave-cpu-startup.patch added to -mm tree
Date: Thu, 06 Oct 2011 15:51:22 -0700
Message-ID: <201110062251.p96MpMxY017184@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:61143 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759329Ab1JFWvi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Oct 2011 18:51:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com, hpa@zytor.com, john.stultz@linaro.org, mingo@redhat.com, tglx@linutronix.de


The patch titled
     Subject: x86: reduce clock calibration time during slave cpu startup
has been added to the -mm tree.  Its filename is
     x86-reduce-clock-calibration-time-during-slave-cpu-startup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jack Steiner <steiner@sgi.com>
Subject: x86: reduce clock calibration time during slave cpu startup

Reduce the startup time for slave cpus.

Adds hooks for an arch-specific function for clock calibration.  These
hooks are used on x86.  If a newly started cpu has the same phys_proc_id
as a core already active, uses the TSC for the delay loop and has a
CONSTANT_TSC, use the already-calculated value of loops_per_jiffy.

This patch reduces the time required to start slave cpus on a 4096 cpu
system from: 465 sec OLD 62 sec NEW

This reduces boot time on a 4096p system by almost 7 minutes.  Nice...

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 arch/x86/kernel/smpboot.c |   16 +++++++++++-----
 arch/x86/kernel/tsc.c     |   19 +++++++++++++++++++
 init/calibrate.c          |   15 +++++++++++++++
 3 files changed, 45 insertions(+), 5 deletions(-)

diff -puN arch/x86/kernel/smpboot.c~x86-reduce-clock-calibration-time-during-slave-cpu-startup arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c~x86-reduce-clock-calibration-time-during-slave-cpu-startup
+++ a/arch/x86/kernel/smpboot.c
@@ -207,23 +207,29 @@ static void __cpuinit smp_callin(void)
 	 * Need to setup vector mappings before we enable interrupts.
 	 */
 	setup_vector_irq(smp_processor_id());
+
+	/*
+	 * Save our processor parameters. Note: this information
+	 * is needed for clock calibration.
+	 */
+	smp_store_cpu_info(cpuid);
+
 	/*
 	 * Get our bogomips.
+	 * Update loops_per_jiffy in cpu_data. Previous call to
+	 * smp_store_cpu_info() stored a value that is close but not as
+	 * accurate as the value just calculated.
 	 *
 	 * Need to enable IRQs because it can take longer and then
 	 * the NMI watchdog might kill us.
 	 */
 	local_irq_enable();
 	calibrate_delay();
+	cpu_data(cpuid).loops_per_jiffy = loops_per_jiffy;
 	local_irq_disable();
 	pr_debug("Stack at about %p\n", &cpuid);
 
 	/*
-	 * Save our processor parameters
-	 */
-	smp_store_cpu_info(cpuid);
-
-	/*
 	 * This must be done before setting cpu_online_mask
 	 * or calling notify_cpu_starting.
 	 */
diff -puN arch/x86/kernel/tsc.c~x86-reduce-clock-calibration-time-during-slave-cpu-startup arch/x86/kernel/tsc.c
--- a/arch/x86/kernel/tsc.c~x86-reduce-clock-calibration-time-during-slave-cpu-startup
+++ a/arch/x86/kernel/tsc.c
@@ -995,3 +995,22 @@ void __init tsc_init(void)
 	check_system_tsc_reliable();
 }
 
+/*
+ * If we have a constant TSC and are using the TSC for the delay loop,
+ * we can skip clock calibration if another cpu in the same socket has already
+ * been calibrated. This assumes that CONSTANT_TSC applies to all
+ * cpus in the socket - this should be a safe assumption.
+ */
+unsigned long __cpuinit calibrate_delay_is_known(void)
+{
+	int i, cpu = smp_processor_id();
+
+	if (!tsc_disabled && !cpu_has(&cpu_data(cpu), X86_FEATURE_CONSTANT_TSC))
+		return 0;
+
+	for_each_online_cpu(i)
+		if (cpu_data(i).phys_proc_id == cpu_data(cpu).phys_proc_id)
+			return cpu_data(i).loops_per_jiffy;
+	return 0;
+}
+
diff -puN init/calibrate.c~x86-reduce-clock-calibration-time-during-slave-cpu-startup init/calibrate.c
--- a/init/calibrate.c~x86-reduce-clock-calibration-time-during-slave-cpu-startup
+++ a/init/calibrate.c
@@ -246,6 +246,19 @@ recalibrate:
 
 static DEFINE_PER_CPU(unsigned long, cpu_loops_per_jiffy) = { 0 };
 
+/*
+ * Check if cpu calibration delay is already known. For example,
+ * some processors with multi-core sockets may have all cores
+ * with the same calibration delay.
+ *
+ * Architectures should override this function if a faster calibration
+ * method is available.
+ */
+unsigned long __attribute__((weak)) __cpuinit calibrate_delay_is_known(void)
+{
+	return 0;
+}
+
 void __cpuinit calibrate_delay(void)
 {
 	unsigned long lpj;
@@ -265,6 +278,8 @@ void __cpuinit calibrate_delay(void)
 		lpj = lpj_fine;
 		pr_info("Calibrating delay loop (skipped), "
 			"value calculated using timer frequency.. ");
+	} else if ((lpj = calibrate_delay_is_known())) {
+		;
 	} else if ((lpj = calibrate_delay_direct()) != 0) {
 		if (!printed)
 			pr_info("Calibrating delay using timer "
_
Subject: Subject: x86: reduce clock calibration time during slave cpu startup

Patches currently in -mm which might be from steiner@sgi.com are

linux-next.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup.patch

