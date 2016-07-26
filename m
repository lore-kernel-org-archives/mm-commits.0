From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 26 Jul 2016 15:39:28 -0700
Message-ID: <5797e6a0.C24SBkoOXDfekmR/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802AbcGZWj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:39:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/kernel/time.c                   |   22 -------
 arch/arm/mach-mxs/Kconfig                |    4 -
 arch/x86/kernel/x86_init.c               |    4 -
 arch/x86/lib/csum-wrappers_64.c          |    5 -
 arch/x86/lib/usercopy_64.c               |    4 -
 arch/x86/platform/intel-mid/pwr.c        |   11 ---
 drivers/clocksource/arm_global_timer.c   |   33 ----------
 drivers/clocksource/exynos_mct.c         |   35 -----------
 drivers/clocksource/time-armada-370-xp.c |   11 ---
 drivers/clocksource/timer-atlas7.c       |   33 ----------
 drivers/cpufreq/intel_pstate.c           |    7 --
 drivers/idle/intel_idle.c                |    7 --
 drivers/powercap/intel_rapl.c            |    6 -
 include/linux/irqchip/arm-gic-v3.h       |   18 -----
 kernel/time/timer.c                      |   64 ---------------------
 15 files changed, 264 deletions(-)

diff -puN arch/arc/kernel/time.c~linux-next-git-rejects arch/arc/kernel/time.c
--- a/arch/arc/kernel/time.c~linux-next-git-rejects
+++ a/arch/arc/kernel/time.c
@@ -322,15 +322,6 @@ static int __init arc_clockevent_setup(s
 	struct clock_event_device *evt = this_cpu_ptr(&arc_clockevent_device);
 	int ret;
 
-<<<<<<< HEAD
-	ret = register_cpu_notifier(&arc_timer_cpu_nb);
-	if (ret) {
-		pr_err("Failed to register cpu notifier");
-		return ret;
-	}
-
-=======
->>>>>>> linux-next/akpm-base
 	arc_timer_irq = irq_of_parse_and_map(node, 0);
 	if (arc_timer_irq <= 0) {
 		pr_err("clockevent: missing irq");
@@ -342,14 +333,6 @@ static int __init arc_clockevent_setup(s
 		pr_err("clockevent: missing clk");
 		return ret;
 	}
-<<<<<<< HEAD
-
-	evt->irq = arc_timer_irq;
-	evt->cpumask = cpumask_of(smp_processor_id());
-	clockevents_config_and_register(evt, arc_timer_freq,
-					0, ARC_TIMER_MAX);
-=======
->>>>>>> linux-next/akpm-base
 
 	/* Needs apriori irq_set_percpu_devid() done in intc map function */
 	ret = request_percpu_irq(arc_timer_irq, timer_irq_handler,
@@ -359,10 +342,6 @@ static int __init arc_clockevent_setup(s
 		return ret;
 	}
 
-<<<<<<< HEAD
-	enable_percpu_irq(arc_timer_irq, 0);
-
-=======
 	ret = cpuhp_setup_state(CPUHP_AP_ARC_TIMER_STARTING,
 				"AP_ARC_TIMER_STARTING",
 				arc_timer_starting_cpu,
@@ -371,7 +350,6 @@ static int __init arc_clockevent_setup(s
 		pr_err("Failed to setup hotplug state");
 		return ret;
 	}
->>>>>>> linux-next/akpm-base
 	return 0;
 }
 
diff -puN arch/arm/mach-mxs/Kconfig~linux-next-git-rejects arch/arm/mach-mxs/Kconfig
--- a/arch/arm/mach-mxs/Kconfig~linux-next-git-rejects
+++ a/arch/arm/mach-mxs/Kconfig
@@ -15,11 +15,7 @@ config SOC_IMX28
 config ARCH_MXS
 	bool "Freescale MXS (i.MX23, i.MX28) support"
 	depends on ARCH_MULTI_V5
-<<<<<<< HEAD
-	select ARCH_REQUIRE_GPIOLIB
-=======
 	select GPIOLIB
->>>>>>> linux-next/akpm-base
 	select MXS_TIMER
 	select PINCTRL
 	select SOC_BUS
diff -puN arch/x86/kernel/x86_init.c~linux-next-git-rejects arch/x86/kernel/x86_init.c
--- a/arch/x86/kernel/x86_init.c~linux-next-git-rejects
+++ a/arch/x86/kernel/x86_init.c
@@ -91,11 +91,7 @@ struct x86_cpuinit_ops x86_cpuinit = {
 static void default_nmi_init(void) { };
 static int default_i8042_detect(void) { return 1; };
 
-<<<<<<< HEAD
-struct x86_platform_ops x86_platform = {
-=======
 struct x86_platform_ops x86_platform __ro_after_init = {
->>>>>>> linux-next/akpm-base
 	.calibrate_cpu			= native_calibrate_cpu,
 	.calibrate_tsc			= native_calibrate_tsc,
 	.get_wallclock			= mach_get_cmos_time,
diff -puN arch/x86/lib/csum-wrappers_64.c~linux-next-git-rejects arch/x86/lib/csum-wrappers_64.c
--- a/arch/x86/lib/csum-wrappers_64.c~linux-next-git-rejects
+++ a/arch/x86/lib/csum-wrappers_64.c
@@ -5,13 +5,8 @@
  * Wrappers of assembly checksum functions for x86-64.
  */
 #include <asm/checksum.h>
-<<<<<<< HEAD
-#include <linux/module.h>
-#include <linux/uaccess.h>
-=======
 #include <linux/uaccess.h>
 #include <linux/export.h>
->>>>>>> linux-next/akpm-base
 #include <asm/smap.h>
 
 /**
diff -puN arch/x86/lib/usercopy_64.c~linux-next-git-rejects arch/x86/lib/usercopy_64.c
--- a/arch/x86/lib/usercopy_64.c~linux-next-git-rejects
+++ a/arch/x86/lib/usercopy_64.c
@@ -5,11 +5,7 @@
  * Copyright 1997 Linus Torvalds
  * Copyright 2002 Andi Kleen <ak@suse.de>
  */
-<<<<<<< HEAD
-#include <linux/module.h>
-=======
 #include <linux/export.h>
->>>>>>> linux-next/akpm-base
 #include <linux/uaccess.h>
 
 /*
diff -puN arch/x86/platform/intel-mid/pwr.c~linux-next-git-rejects arch/x86/platform/intel-mid/pwr.c
--- a/arch/x86/platform/intel-mid/pwr.c~linux-next-git-rejects
+++ a/arch/x86/platform/intel-mid/pwr.c
@@ -21,16 +21,9 @@
 
 #include <linux/delay.h>
 #include <linux/errno.h>
-<<<<<<< HEAD
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-=======
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
->>>>>>> linux-next/akpm-base
 #include <linux/mutex.h>
 #include <linux/pci.h>
 
@@ -413,10 +406,6 @@ static const struct pci_device_id mid_pw
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_TANGIER), (kernel_ulong_t)&mid_info },
 	{}
 };
-<<<<<<< HEAD
-MODULE_DEVICE_TABLE(pci, mid_pwr_pci_ids);
-=======
->>>>>>> linux-next/akpm-base
 
 static struct pci_driver mid_pwr_pci_driver = {
 	.name		= "intel_mid_pwr",
diff -puN drivers/clocksource/arm_global_timer.c~linux-next-git-rejects drivers/clocksource/arm_global_timer.c
--- a/drivers/clocksource/arm_global_timer.c~linux-next-git-rejects
+++ a/drivers/clocksource/arm_global_timer.c
@@ -255,27 +255,6 @@ static int __init gt_clocksource_init(vo
 	return clocksource_register_hz(&gt_clocksource, gt_clk_rate);
 }
 
-<<<<<<< HEAD
-static int gt_cpu_notify(struct notifier_block *self, unsigned long action,
-			 void *hcpu)
-{
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_STARTING:
-		gt_clockevents_init(this_cpu_ptr(gt_evt));
-		break;
-	case CPU_DYING:
-		gt_clockevents_stop(this_cpu_ptr(gt_evt));
-		break;
-	}
-
-	return NOTIFY_OK;
-}
-static struct notifier_block gt_cpu_nb = {
-	.notifier_call = gt_cpu_notify,
-};
-
-=======
->>>>>>> linux-next/akpm-base
 static int __init global_timer_of_register(struct device_node *np)
 {
 	struct clk *gt_clk;
@@ -342,18 +321,6 @@ static int __init global_timer_of_regist
 	if (err)
 		goto out_irq;
 
-<<<<<<< HEAD
-	/* Immediately configure the timer on the boot CPU */
-	err = gt_clocksource_init();
-	if (err)
-		goto out_irq;
-	
-	err = gt_clockevents_init(this_cpu_ptr(gt_evt));
-	if (err)
-		goto out_irq;
-
-=======
->>>>>>> linux-next/akpm-base
 	gt_delay_timer_init();
 
 	return 0;
diff -puN drivers/clocksource/exynos_mct.c~linux-next-git-rejects drivers/clocksource/exynos_mct.c
--- a/drivers/clocksource/exynos_mct.c~linux-next-git-rejects
+++ a/drivers/clocksource/exynos_mct.c
@@ -497,36 +497,6 @@ static int exynos4_mct_dying_cpu(unsigne
 	return 0;
 }
 
-<<<<<<< HEAD
-static int exynos4_mct_cpu_notify(struct notifier_block *self,
-					   unsigned long action, void *hcpu)
-{
-	struct mct_clock_event_device *mevt;
-
-	/*
-	 * Grab cpu pointer in each case to avoid spurious
-	 * preemptible warnings
-	 */
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_STARTING:
-		mevt = this_cpu_ptr(&percpu_mct_tick);
-		exynos4_local_timer_setup(mevt);
-		break;
-	case CPU_DYING:
-		mevt = this_cpu_ptr(&percpu_mct_tick);
-		exynos4_local_timer_stop(mevt);
-		break;
-	}
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block exynos4_mct_cpu_nb = {
-	.notifier_call = exynos4_mct_cpu_notify,
-};
-
-=======
->>>>>>> linux-next/akpm-base
 static int __init exynos4_timer_resources(struct device_node *np, void __iomem *base)
 {
 	int err, cpu;
@@ -584,11 +554,6 @@ static int __init exynos4_timer_resource
 	if (err)
 		goto out_irq;
 
-<<<<<<< HEAD
-	/* Immediately configure the timer on the boot CPU */
-	exynos4_local_timer_setup(mevt);
-=======
->>>>>>> linux-next/akpm-base
 	return 0;
 
 out_irq:
diff -puN drivers/clocksource/time-armada-370-xp.c~linux-next-git-rejects drivers/clocksource/time-armada-370-xp.c
--- a/drivers/clocksource/time-armada-370-xp.c~linux-next-git-rejects
+++ a/drivers/clocksource/time-armada-370-xp.c
@@ -301,11 +301,6 @@ static int __init armada_370_xp_timer_co
 		pr_err("Failed to initialize clocksource mmio");
 		return res;
 	}
-<<<<<<< HEAD
-
-	register_cpu_notifier(&armada_370_xp_timer_cpu_nb);
-=======
->>>>>>> linux-next/akpm-base
 
 	armada_370_xp_evt = alloc_percpu(struct clock_event_device);
 	if (!armada_370_xp_evt)
@@ -324,18 +319,12 @@ static int __init armada_370_xp_timer_co
 		return res;
 	}
 
-<<<<<<< HEAD
-	res = armada_370_xp_timer_setup(this_cpu_ptr(armada_370_xp_evt));
-	if (res) {
-		pr_err("Failed to setup timer");
-=======
 	res = cpuhp_setup_state(CPUHP_AP_ARMADA_TIMER_STARTING,
 				"AP_ARMADA_TIMER_STARTING",
 				armada_370_xp_timer_starting_cpu,
 				armada_370_xp_timer_dying_cpu);
 	if (res) {
 		pr_err("Failed to setup hotplug state and timer");
->>>>>>> linux-next/akpm-base
 		return res;
 	}
 
diff -puN drivers/clocksource/timer-atlas7.c~linux-next-git-rejects drivers/clocksource/timer-atlas7.c
--- a/drivers/clocksource/timer-atlas7.c~linux-next-git-rejects
+++ a/drivers/clocksource/timer-atlas7.c
@@ -214,49 +214,16 @@ static int sirfsoc_local_timer_dying_cpu
 	return 0;
 }
 
-<<<<<<< HEAD
-static int sirfsoc_cpu_notify(struct notifier_block *self,
-			      unsigned long action, void *hcpu)
-{
-	/*
-	 * Grab cpu pointer in each case to avoid spurious
-	 * preemptible warnings
-	 */
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_STARTING:
-		sirfsoc_local_timer_setup(this_cpu_ptr(sirfsoc_clockevent));
-		break;
-	case CPU_DYING:
-		sirfsoc_local_timer_stop(this_cpu_ptr(sirfsoc_clockevent));
-		break;
-	}
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block sirfsoc_cpu_nb = {
-	.notifier_call = sirfsoc_cpu_notify,
-};
-
-=======
->>>>>>> linux-next/akpm-base
 static int __init sirfsoc_clockevent_init(void)
 {
 	sirfsoc_clockevent = alloc_percpu(struct clock_event_device);
 	BUG_ON(!sirfsoc_clockevent);
 
-<<<<<<< HEAD
-	BUG_ON(register_cpu_notifier(&sirfsoc_cpu_nb));
-
-	/* Immediately configure the timer on the boot CPU */
-	return sirfsoc_local_timer_setup(this_cpu_ptr(sirfsoc_clockevent));
-=======
 	/* Install and invoke hotplug callbacks */
 	return cpuhp_setup_state(CPUHP_AP_MARCO_TIMER_STARTING,
 				 "AP_MARCO_TIMER_STARTING",
 				 sirfsoc_local_timer_starting_cpu,
 				 sirfsoc_local_timer_dying_cpu);
->>>>>>> linux-next/akpm-base
 }
 
 /* initialize the kernel jiffy timer source */
diff -puN drivers/cpufreq/intel_pstate.c~linux-next-git-rejects drivers/cpufreq/intel_pstate.c
--- a/drivers/cpufreq/intel_pstate.c~linux-next-git-rejects
+++ a/drivers/cpufreq/intel_pstate.c
@@ -1367,19 +1367,12 @@ static const struct x86_cpu_id intel_pst
 	ICPU(INTEL_FAM6_SKYLAKE_DESKTOP,	core_params),
 	ICPU(INTEL_FAM6_BROADWELL_XEON_D,	core_params),
 	ICPU(INTEL_FAM6_XEON_PHI_KNL,		knl_params),
-<<<<<<< HEAD
-=======
 	ICPU(INTEL_FAM6_ATOM_GOLDMONT,		bxt_params),
->>>>>>> linux-next/akpm-base
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_pstate_cpu_ids);
 
-<<<<<<< HEAD
-static const struct x86_cpu_id intel_pstate_cpu_oob_ids[] = {
-=======
 static const struct x86_cpu_id intel_pstate_cpu_oob_ids[] __initconst = {
->>>>>>> linux-next/akpm-base
 	ICPU(INTEL_FAM6_BROADWELL_XEON_D, core_params),
 	{}
 };
diff -puN drivers/idle/intel_idle.c~linux-next-git-rejects drivers/idle/intel_idle.c
--- a/drivers/idle/intel_idle.c~linux-next-git-rejects
+++ a/drivers/idle/intel_idle.c
@@ -1055,11 +1055,7 @@ static const struct idle_cpu idle_cpu_dn
 static const struct x86_cpu_id intel_idle_ids[] __initconst = {
 	ICPU(INTEL_FAM6_NEHALEM_EP,		idle_cpu_nehalem),
 	ICPU(INTEL_FAM6_NEHALEM,		idle_cpu_nehalem),
-<<<<<<< HEAD
-	ICPU(INTEL_FAM6_WESTMERE2,		idle_cpu_nehalem),
-=======
 	ICPU(INTEL_FAM6_NEHALEM_G,		idle_cpu_nehalem),
->>>>>>> linux-next/akpm-base
 	ICPU(INTEL_FAM6_WESTMERE,		idle_cpu_nehalem),
 	ICPU(INTEL_FAM6_WESTMERE_EP,		idle_cpu_nehalem),
 	ICPU(INTEL_FAM6_NEHALEM_EX,		idle_cpu_nehalem),
@@ -1089,10 +1085,7 @@ static const struct x86_cpu_id intel_idl
 	ICPU(INTEL_FAM6_SKYLAKE_X,		idle_cpu_skx),
 	ICPU(INTEL_FAM6_XEON_PHI_KNL,		idle_cpu_knl),
 	ICPU(INTEL_FAM6_ATOM_GOLDMONT,		idle_cpu_bxt),
-<<<<<<< HEAD
-=======
 	ICPU(INTEL_FAM6_ATOM_DENVERTON,		idle_cpu_dnv),
->>>>>>> linux-next/akpm-base
 	{}
 };
 
diff -puN drivers/powercap/intel_rapl.c~linux-next-git-rejects drivers/powercap/intel_rapl.c
--- a/drivers/powercap/intel_rapl.c~linux-next-git-rejects
+++ a/drivers/powercap/intel_rapl.c
@@ -1134,10 +1134,7 @@ static const struct x86_cpu_id rapl_ids[
 	RAPL_CPU(INTEL_FAM6_SANDYBRIDGE_X,	rapl_defaults_core),
 
 	RAPL_CPU(INTEL_FAM6_IVYBRIDGE,		rapl_defaults_core),
-<<<<<<< HEAD
-=======
 	RAPL_CPU(INTEL_FAM6_IVYBRIDGE_X,	rapl_defaults_core),
->>>>>>> linux-next/akpm-base
 
 	RAPL_CPU(INTEL_FAM6_HASWELL_CORE,	rapl_defaults_core),
 	RAPL_CPU(INTEL_FAM6_HASWELL_ULT,	rapl_defaults_core),
@@ -1160,10 +1157,7 @@ static const struct x86_cpu_id rapl_ids[
 	RAPL_CPU(INTEL_FAM6_ATOM_MERRIFIELD1,	rapl_defaults_tng),
 	RAPL_CPU(INTEL_FAM6_ATOM_MERRIFIELD2,	rapl_defaults_ann),
 	RAPL_CPU(INTEL_FAM6_ATOM_GOLDMONT,	rapl_defaults_core),
-<<<<<<< HEAD
-=======
 	RAPL_CPU(INTEL_FAM6_ATOM_DENVERTON,	rapl_defaults_core),
->>>>>>> linux-next/akpm-base
 
 	RAPL_CPU(INTEL_FAM6_XEON_PHI_KNL,	rapl_defaults_hsw_server),
 	{}
diff -puN include/linux/irqchip/arm-gic-v3.h~linux-next-git-rejects include/linux/irqchip/arm-gic-v3.h
--- a/include/linux/irqchip/arm-gic-v3.h~linux-next-git-rejects
+++ a/include/linux/irqchip/arm-gic-v3.h
@@ -265,20 +265,6 @@
 
 #define GITS_BASER_NR_REGS		8
 
-<<<<<<< HEAD
-#define GITS_BASER_VALID		(1UL << 63)
-#define GITS_BASER_INDIRECT		(1UL << 62)
-#define GITS_BASER_nCnB			(0UL << 59)
-#define GITS_BASER_nC			(1UL << 59)
-#define GITS_BASER_RaWt			(2UL << 59)
-#define GITS_BASER_RaWb			(3UL << 59)
-#define GITS_BASER_WaWt			(4UL << 59)
-#define GITS_BASER_WaWb			(5UL << 59)
-#define GITS_BASER_RaWaWt		(6UL << 59)
-#define GITS_BASER_RaWaWb		(7UL << 59)
-#define GITS_BASER_CACHEABILITY_MASK	(7UL << 59)
-#define GITS_BASER_TYPE_SHIFT		(56)
-=======
 #define GITS_BASER_VALID			(1UL << 63)
 #define GITS_BASER_INDIRECT			(1ULL << 62)
 
@@ -302,7 +288,6 @@
 #define GITS_BASER_RaWaWb	GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWaWb)
 
 #define GITS_BASER_TYPE_SHIFT			(56)
->>>>>>> linux-next/akpm-base
 #define GITS_BASER_TYPE(r)		(((r) >> GITS_BASER_TYPE_SHIFT) & 7)
 #define GITS_BASER_ENTRY_SIZE_SHIFT		(48)
 #define GITS_BASER_ENTRY_SIZE(r)	((((r) >> GITS_BASER_ENTRY_SIZE_SHIFT) & 0xff) + 1)
@@ -316,10 +301,7 @@
 #define GITS_BASER_PAGE_SIZE_MASK	(3UL << GITS_BASER_PAGE_SIZE_SHIFT)
 #define GITS_BASER_PAGES_MAX		256
 #define GITS_BASER_PAGES_SHIFT		(0)
-<<<<<<< HEAD
-=======
 #define GITS_BASER_NR_PAGES(r)		(((r) & 0xff) + 1)
->>>>>>> linux-next/akpm-base
 
 #define GITS_BASER_TYPE_NONE		0
 #define GITS_BASER_TYPE_DEVICE		1
diff -puN kernel/time/timer.c~linux-next-git-rejects kernel/time/timer.c
--- a/kernel/time/timer.c~linux-next-git-rejects
+++ a/kernel/time/timer.c
@@ -506,7 +506,6 @@ static int calc_wheel_index(unsigned lon
 	}
 	return idx;
 }
-<<<<<<< HEAD
 
 /*
  * Enqueue the timer into the hash bucket, mark it pending in
@@ -532,33 +531,6 @@ __internal_add_timer(struct timer_base *
 static void
 trigger_dyntick_cpu(struct timer_base *base, struct timer_list *timer)
 {
-=======
-
-/*
- * Enqueue the timer into the hash bucket, mark it pending in
- * the bitmap and store the index in the timer flags.
- */
-static void enqueue_timer(struct timer_base *base, struct timer_list *timer,
-			  unsigned int idx)
-{
-	hlist_add_head(&timer->entry, base->vectors + idx);
-	__set_bit(idx, base->pending_map);
-	timer_set_idx(timer, idx);
-}
-
-static void
-__internal_add_timer(struct timer_base *base, struct timer_list *timer)
-{
-	unsigned int idx;
-
-	idx = calc_wheel_index(timer->expires, base->clk);
-	enqueue_timer(base, timer, idx);
-}
-
-static void
-trigger_dyntick_cpu(struct timer_base *base, struct timer_list *timer)
-{
->>>>>>> linux-next/akpm-base
 	if (!IS_ENABLED(CONFIG_NO_HZ_COMMON) || !base->nohz_active)
 		return;
 
@@ -1399,27 +1371,6 @@ static int __collect_expired_timers(stru
  * Find the next pending bucket of a level. Search from level start (@offset)
  * + @clk upwards and if nothing there, search from start of the level
  * (@offset) up to @offset + clk.
-<<<<<<< HEAD
- */
-static int next_pending_bucket(struct timer_base *base, unsigned offset,
-			       unsigned clk)
-{
-	unsigned pos, start = offset + clk;
-	unsigned end = offset + LVL_SIZE;
-
-	pos = find_next_bit(base->pending_map, end, start);
-	if (pos < end)
-		return pos - start;
-
-	pos = find_next_bit(base->pending_map, start, offset);
-	return pos < start ? pos + LVL_SIZE - start : -1;
-}
-
-/*
- * Search the first expiring timer in the various clock levels. Caller must
- * hold base->lock.
- */
-=======
  */
 static int next_pending_bucket(struct timer_base *base, unsigned offset,
 			       unsigned clk)
@@ -1439,7 +1390,6 @@ static int next_pending_bucket(struct ti
  * Search the first expiring timer in the various clock levels. Caller must
  * hold base->lock.
  */
->>>>>>> linux-next/akpm-base
 static unsigned long __next_timer_interrupt(struct timer_base *base)
 {
 	unsigned long clk, next, adj;
@@ -1871,22 +1821,8 @@ int timers_dead_cpu(unsigned int cpu)
 		 */
 		spin_lock_irq(&new_base->lock);
 		spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
-<<<<<<< HEAD
-
-		BUG_ON(old_base->running_timer);
-
-		for (i = 0; i < WHEEL_SIZE; i++)
-			migrate_timer_list(new_base, old_base->vectors + i);
-
-		spin_unlock(&old_base->lock);
-		spin_unlock_irq(&new_base->lock);
-		put_cpu_ptr(&timer_bases);
-	}
-}
-=======
 
 		BUG_ON(old_base->running_timer);
->>>>>>> linux-next/akpm-base
 
 		for (i = 0; i < WHEEL_SIZE; i++)
 			migrate_timer_list(new_base, old_base->vectors + i);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler-fix.patch
mm.patch
mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch
mm-bail-out-in-shrin_inactive_list-fix.patch
revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements-checkpatch-fixes.patch
mm-optimize-copy_page_to-from_iter_iovec-fix.patch
mm-optimize-copy_page_to-from_iter_iovec-fix-fix.patch
treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch
printk-create-pr_level-functions-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
allow-kdump-with-crash_kexec_post_notifiers-fix.patch
kexec-add-resriction-on-the-kexec_load-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

