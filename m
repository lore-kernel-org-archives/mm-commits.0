Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337BA26E6E5
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 03:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760498877; cv=none; b=t9mBDpW3qU7+BzxSJPeKkY/fMGOphIIao5N/utf5nc7A3oiQZnOF+kgwf3IJvtP7JRMicjZ3iE2/AD9iZI6MuPjw7i7nEK1QSsW52aka4Fc3ORzId5F9odE/6KCDyiZwUda/F2uW0UTMBiwQ4zl3qsrWbR9vUiDqU+21RDTcZHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760498877; c=relaxed/simple;
	bh=1F4D66bfvgsnlxaSik4QJ7F3uCC7jGXmwcN2vNGzc44=;
	h=Date:To:From:Subject:Message-Id; b=W725A694GbYLHhWPRNxNUfWez2A+BcbOKY742gCDbr7/Mva5+JmbkTlCQigw5Qbtz87PmFNhmEJkwbXmNhKuq0mZYKLSByUT2Z7DCC4VGSkuyNj2QrtftXHe1AhzdAyuKBDyzRVN6KeK5LgI4KMWKMP8AC1Q5gCKP6qk1PHrna8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wjsyyg/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wjsyyg/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07B7C4CEE7;
	Wed, 15 Oct 2025 03:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760498876;
	bh=1F4D66bfvgsnlxaSik4QJ7F3uCC7jGXmwcN2vNGzc44=;
	h=Date:To:From:Subject:From;
	b=wjsyyg/S7dcxPLyYEc2Ni8CDDPTyMmLzsXkBglflHUnTP2T44iQHySSRaILiey28e
	 BxXNnOGevz6rY0Ip7/rMmALcaYp6oKti+b43EH4EgmyskuGX37JI0fncYuB331WhWE
	 iUbcSclkWJKABamyoNzlHp5ma1LsysZQYd1Q9glo=
Date: Tue, 14 Oct 2025 20:27:56 -0700
To: mm-commits@vger.kernel.org,zhanjie9@hisilicon.com,yangyicong@hisilicon.com,will@kernel.org,wangjinchao600@gmail.com,thorsten.blum@linux.dev,suzuki.poulose@arm.com,pjw@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mingo@kernel.org,maz@kernel.org,masahiroy@kernel.org,mark.rutland@arm.com,lihuafei1@huawei.com,johannes@sipsolutions.net,dianders@chromium.org,catalin.marinas@arm.com,aou@eecs.berkeley.edu,anup@brainfault.org,alex@ghiti.fr,cuiyunhui@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-move-arm64-watchdog_hld-into-common-code.patch added to mm-nonmm-unstable branch
Message-Id: <20251015032756.A07B7C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog: move arm64 watchdog_hld into common code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-move-arm64-watchdog_hld-into-common-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-move-arm64-watchdog_hld-into-common-code.patch

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
From: Yunhui Cui <cuiyunhui@bytedance.com>
Subject: watchdog: move arm64 watchdog_hld into common code
Date: Tue, 14 Oct 2025 11:14:24 +0800

Patch series "Add HARDLOCKUP_DETECTOR_PERF support for RISC-V", v4.

Move the contents of arch/arm64/watchdog_hld.c into kernel/watchdog_perf.c
to create a generic implementation.  Then use that on RISC-V.


This patch (of 2):

Move the contents of arch/arm64/watchdog_hld.c to kernel/watchdog_perf.c
to create a generic implementation that can be reused by other arch, such
as RISC-V.

Link: https://lkml.kernel.org/r/20251014031425.93284-1-cuiyunhui@bytedance.com
Link: https://lkml.kernel.org/r/20251014031425.93284-2-cuiyunhui@bytedance.com
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Anup Patel <anup@brainfault.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jie Zhan <zhanjie9@hisilicon.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig               |    1 
 arch/arm64/kernel/Makefile       |    1 
 arch/arm64/kernel/watchdog_hld.c |   94 -----------------------------
 drivers/perf/arm_pmu.c           |   10 ++-
 include/linux/perf/arm_pmu.h     |    2 
 kernel/watchdog_perf.c           |   83 +++++++++++++++++++++++++
 lib/Kconfig.debug                |    8 ++
 7 files changed, 101 insertions(+), 98 deletions(-)

--- a/arch/arm64/Kconfig~watchdog-move-arm64-watchdog_hld-into-common-code
+++ a/arch/arm64/Kconfig
@@ -231,6 +231,7 @@ config ARM64
 	select HAVE_GCC_PLUGINS
 	select HAVE_HARDLOCKUP_DETECTOR_PERF if PERF_EVENTS && \
 		HW_PERF_EVENTS && HAVE_PERF_EVENTS_NMI
+	select WATCHDOG_PERF_ADJUST_PERIOD if HARDLOCKUP_DETECTOR_PERF && CPU_FREQ
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_IOREMAP_PROT
 	select HAVE_IRQ_TIME_ACCOUNTING
--- a/arch/arm64/kernel/Makefile~watchdog-move-arm64-watchdog_hld-into-common-code
+++ a/arch/arm64/kernel/Makefile
@@ -44,7 +44,6 @@ obj-$(CONFIG_KUSER_HELPERS)		+= kuser32.
 obj-$(CONFIG_FUNCTION_TRACER)		+= ftrace.o entry-ftrace.o
 obj-$(CONFIG_MODULES)			+= module.o module-plts.o
 obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o perf_callchain.o
-obj-$(CONFIG_HARDLOCKUP_DETECTOR_PERF)	+= watchdog_hld.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= hw_breakpoint.o
 obj-$(CONFIG_CPU_PM)			+= sleep.o suspend.o
 obj-$(CONFIG_KGDB)			+= kgdb.o
diff --git a/arch/arm64/kernel/watchdog_hld.c a/arch/arm64/kernel/watchdog_hld.c
deleted file mode 100644
--- a/arch/arm64/kernel/watchdog_hld.c
+++ /dev/null
@@ -1,94 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <linux/nmi.h>
-#include <linux/cpufreq.h>
-#include <linux/perf/arm_pmu.h>
-
-/*
- * Safe maximum CPU frequency in case a particular platform doesn't implement
- * cpufreq driver. Although, architecture doesn't put any restrictions on
- * maximum frequency but 5 GHz seems to be safe maximum given the available
- * Arm CPUs in the market which are clocked much less than 5 GHz. On the other
- * hand, we can't make it much higher as it would lead to a large hard-lockup
- * detection timeout on parts which are running slower (eg. 1GHz on
- * Developerbox) and doesn't possess a cpufreq driver.
- */
-#define SAFE_MAX_CPU_FREQ	5000000000UL // 5 GHz
-u64 hw_nmi_get_sample_period(int watchdog_thresh)
-{
-	unsigned int cpu = smp_processor_id();
-	unsigned long max_cpu_freq;
-
-	max_cpu_freq = cpufreq_get_hw_max_freq(cpu) * 1000UL;
-	if (!max_cpu_freq)
-		max_cpu_freq = SAFE_MAX_CPU_FREQ;
-
-	return (u64)max_cpu_freq * watchdog_thresh;
-}
-
-bool __init arch_perf_nmi_is_available(void)
-{
-	/*
-	 * hardlockup_detector_perf_init() will success even if Pseudo-NMI turns off,
-	 * however, the pmu interrupts will act like a normal interrupt instead of
-	 * NMI and the hardlockup detector would be broken.
-	 */
-	return arm_pmu_irq_is_nmi();
-}
-
-static int watchdog_perf_update_period(void *data)
-{
-	int cpu = smp_processor_id();
-	u64 max_cpu_freq, new_period;
-
-	max_cpu_freq = cpufreq_get_hw_max_freq(cpu) * 1000UL;
-	if (!max_cpu_freq)
-		return 0;
-
-	new_period = watchdog_thresh * max_cpu_freq;
-	hardlockup_detector_perf_adjust_period(new_period);
-
-	return 0;
-}
-
-static int watchdog_freq_notifier_callback(struct notifier_block *nb,
-					   unsigned long val, void *data)
-{
-	struct cpufreq_policy *policy = data;
-	int cpu;
-
-	if (val != CPUFREQ_CREATE_POLICY)
-		return NOTIFY_DONE;
-
-	/*
-	 * Let each online CPU related to the policy update the period by their
-	 * own. This will serialize with the framework on start/stop the lockup
-	 * detector (softlockup_{start,stop}_all) and avoid potential race
-	 * condition. Otherwise we may have below theoretical race condition:
-	 * (core 0/1 share the same policy)
-	 * [core 0]                      [core 1]
-	 *                               hardlockup_detector_event_create()
-	 *                                 hw_nmi_get_sample_period()
-	 * (cpufreq registered, notifier callback invoked)
-	 * watchdog_freq_notifier_callback()
-	 *   watchdog_perf_update_period()
-	 *   (since core 1's event's not yet created,
-	 *    the period is not set)
-	 *                                 perf_event_create_kernel_counter()
-	 *                                 (event's period is SAFE_MAX_CPU_FREQ)
-	 */
-	for_each_cpu(cpu, policy->cpus)
-		smp_call_on_cpu(cpu, watchdog_perf_update_period, NULL, false);
-
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block watchdog_freq_notifier = {
-	.notifier_call = watchdog_freq_notifier_callback,
-};
-
-static int __init init_watchdog_freq_notifier(void)
-{
-	return cpufreq_register_notifier(&watchdog_freq_notifier,
-					 CPUFREQ_POLICY_NOTIFIER);
-}
-core_initcall(init_watchdog_freq_notifier);
--- a/drivers/perf/arm_pmu.c~watchdog-move-arm64-watchdog_hld-into-common-code
+++ a/drivers/perf/arm_pmu.c
@@ -17,6 +17,7 @@
 #include <linux/cpu_pm.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
+#include <linux/nmi.h>
 #include <linux/perf/arm_pmu.h>
 #include <linux/slab.h>
 #include <linux/sched/clock.h>
@@ -696,10 +697,17 @@ static int armpmu_get_cpu_irq(struct arm
 	return per_cpu(hw_events->irq, cpu);
 }
 
-bool arm_pmu_irq_is_nmi(void)
+#ifdef CONFIG_HARDLOCKUP_DETECTOR_PERF
+bool arch_perf_nmi_is_available(void)
 {
+	/*
+	 * watchdog_hardlockup_probe() will success even if Pseudo-NMI turns off,
+	 * however, the pmu interrupts will act like a normal interrupt instead of
+	 * NMI and the hardlockup detector would be broken.
+	 */
 	return has_nmi;
 }
+#endif
 
 /*
  * PMU hardware loses all context when a CPU goes offline.
--- a/include/linux/perf/arm_pmu.h~watchdog-move-arm64-watchdog_hld-into-common-code
+++ a/include/linux/perf/arm_pmu.h
@@ -184,8 +184,6 @@ void kvm_host_pmu_init(struct arm_pmu *p
 #define kvm_host_pmu_init(x)	do { } while(0)
 #endif
 
-bool arm_pmu_irq_is_nmi(void);
-
 /* Internal functions only for core arm_pmu code */
 struct arm_pmu *armpmu_alloc(void);
 void armpmu_free(struct arm_pmu *pmu);
--- a/kernel/watchdog_perf.c~watchdog-move-arm64-watchdog_hld-into-common-code
+++ a/kernel/watchdog_perf.c
@@ -15,6 +15,7 @@
 #include <linux/panic.h>
 #include <linux/nmi.h>
 #include <linux/atomic.h>
+#include <linux/cpufreq.h>
 #include <linux/module.h>
 #include <linux/sched/debug.h>
 
@@ -306,3 +307,85 @@ void __init hardlockup_config_perf_event
 	wd_hw_attr.type = PERF_TYPE_RAW;
 	wd_hw_attr.config = config;
 }
+
+#ifdef CONFIG_WATCHDOG_PERF_ADJUST_PERIOD
+/*
+ * Safe maximum CPU frequency in case a particular platform doesn't implement
+ * cpufreq driver. Although, architecture doesn't put any restrictions on
+ * maximum frequency but 5 GHz seems to be safe maximum given the available
+ * CPUs in the market which are clocked much less than 5 GHz. On the other
+ * hand, we can't make it much higher as it would lead to a large hard-lockup
+ * detection timeout on parts which are running slower (eg. 1GHz on
+ * Developerbox) and doesn't possess a cpufreq driver.
+ */
+#define SAFE_MAX_CPU_FREQ	5000000000UL // 5 GHz
+__weak u64 hw_nmi_get_sample_period(int watchdog_thresh)
+{
+	unsigned int cpu = smp_processor_id();
+	unsigned long max_cpu_freq;
+
+	max_cpu_freq = cpufreq_get_hw_max_freq(cpu) * 1000UL;
+	if (!max_cpu_freq)
+		max_cpu_freq = SAFE_MAX_CPU_FREQ;
+
+	return (u64)max_cpu_freq * watchdog_thresh;
+}
+
+static int watchdog_perf_update_period(void *data)
+{
+	int cpu = smp_processor_id();
+	u64 max_cpu_freq, new_period;
+
+	max_cpu_freq = cpufreq_get_hw_max_freq(cpu) * 1000UL;
+	if (!max_cpu_freq)
+		return 0;
+
+	new_period = watchdog_thresh * max_cpu_freq;
+	hardlockup_detector_perf_adjust_period(new_period);
+
+	return 0;
+}
+
+static int watchdog_freq_notifier_callback(struct notifier_block *nb,
+					   unsigned long val, void *data)
+{
+	struct cpufreq_policy *policy = data;
+	int cpu;
+
+	if (val != CPUFREQ_CREATE_POLICY)
+		return NOTIFY_DONE;
+
+	/*
+	 * Let each online CPU related to the policy update the period by their
+	 * own. This will serialize with the framework on start/stop the lockup
+	 * detector (softlockup_{start,stop}_all) and avoid potential race
+	 * condition. Otherwise we may have below theoretical race condition:
+	 * (core 0/1 share the same policy)
+	 * [core 0]                      [core 1]
+	 *                               hardlockup_detector_event_create()
+	 *                                 hw_nmi_get_sample_period()
+	 * (cpufreq registered, notifier callback invoked)
+	 * watchdog_freq_notifier_callback()
+	 *   watchdog_perf_update_period()
+	 *   (since core 1's event's not yet created,
+	 *    the period is not set)
+	 *                                 perf_event_create_kernel_counter()
+	 *                                 (event's period is SAFE_MAX_CPU_FREQ)
+	 */
+	for_each_cpu(cpu, policy->cpus)
+		smp_call_on_cpu(cpu, watchdog_perf_update_period, NULL, false);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block watchdog_freq_notifier = {
+	.notifier_call = watchdog_freq_notifier_callback,
+};
+
+static int __init init_watchdog_freq_notifier(void)
+{
+	return cpufreq_register_notifier(&watchdog_freq_notifier,
+					 CPUFREQ_POLICY_NOTIFIER);
+}
+core_initcall(init_watchdog_freq_notifier);
+#endif
--- a/lib/Kconfig.debug~watchdog-move-arm64-watchdog_hld-into-common-code
+++ a/lib/Kconfig.debug
@@ -1183,6 +1183,14 @@ config HARDLOCKUP_DETECTOR_PERF
 	depends on !HAVE_HARDLOCKUP_DETECTOR_ARCH
 	select HARDLOCKUP_DETECTOR_COUNTS_HRTIMER
 
+config WATCHDOG_PERF_ADJUST_PERIOD
+	bool
+	help
+	  Adjust the watchdog hardlockup detector's period based on CPU max
+	  frequency. Uses cpufreq if available; falls back to a safe 5 GHz
+	  default otherwise. Registers a cpufreq notifier to update the period
+	  automatically.
+
 config HARDLOCKUP_DETECTOR_BUDDY
 	bool
 	depends on HARDLOCKUP_DETECTOR
_

Patches currently in -mm which might be from cuiyunhui@bytedance.com are

watchdog-move-arm64-watchdog_hld-into-common-code.patch
riscv-add-hardlockup_detector_perf-support.patch

