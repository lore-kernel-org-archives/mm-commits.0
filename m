From: akpm@linux-foundation.org
Subject: - cpuidle-take2-hookup-acpi-c-states-driver-with-cpuidle.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:54:14 -0800
Message-ID: <200702282354.l1SNsEP9031180@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48584 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690AbXB1Xzi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:55:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, abelay@novell.com, ak@suse.de, davej@codemonkey.org.uk, lenb@kernel.org, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     cpuidle take2: Hookup ACPI C-states driver with cpuidle
has been removed from the -mm tree.  Its filename was
     cpuidle-take2-hookup-acpi-c-states-driver-with-cpuidle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpuidle take2: Hookup ACPI C-states driver with cpuidle
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Hookup ACPI C-states onto generic cpuidle infrastructure.

drivers/acpi/procesor_idle.c is now a ACPI C-states driver that registers as a
driver in cpuidle infrastructure and the policy part is removed from
drivers/acpi/processor_idle.c.  We use governor in cpuidle instead.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Adam Belay <abelay@novell.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_core.c |    3 
 drivers/acpi/processor_idle.c |  498 +++++++++++++++++++++-----------
 include/acpi/processor.h      |    2 
 3 files changed, 337 insertions(+), 166 deletions(-)

diff -puN drivers/acpi/processor_core.c~cpuidle-take2-hookup-acpi-c-states-driver-with-cpuidle drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~cpuidle-take2-hookup-acpi-c-states-driver-with-cpuidle
+++ a/drivers/acpi/processor_core.c
@@ -44,6 +44,7 @@
 #include <linux/seq_file.h>
 #include <linux/dmi.h>
 #include <linux/moduleparam.h>
+#include <linux/cpuidle.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
@@ -1028,11 +1029,13 @@ static int __init acpi_processor_init(vo
 
 	acpi_processor_ppc_init();
 
+	cpuidle_register_driver(&acpi_idle_driver);
 	return 0;
 }
 
 static void __exit acpi_processor_exit(void)
 {
+	cpuidle_unregister_driver(&acpi_idle_driver);
 
 	acpi_processor_ppc_exit();
 
diff -puN drivers/acpi/processor_idle.c~cpuidle-take2-hookup-acpi-c-states-driver-with-cpuidle drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~cpuidle-take2-hookup-acpi-c-states-driver-with-cpuidle
+++ a/drivers/acpi/processor_idle.c
@@ -40,6 +40,7 @@
 #include <linux/sched.h>	/* need_resched() */
 #include <linux/latency.h>
 #include <linux/clockchips.h>
+#include <linux/cpuidle.h>
 
 /*
  * Include the apic definitions for x86 to have the APIC timer related defines
@@ -70,25 +71,15 @@
 #define _COMPONENT              ACPI_PROCESSOR_COMPONENT
 ACPI_MODULE_NAME("processor_idle");
 #define ACPI_PROCESSOR_FILE_POWER	"power"
-#define US_TO_PM_TIMER_TICKS(t)		((t * (PM_TIMER_FREQUENCY/1000)) / 1000)
-#define C2_OVERHEAD			4	/* 1us (3.579 ticks per us) */
-#define C3_OVERHEAD			4	/* 1us (3.579 ticks per us) */
-static void (*pm_idle_save) (void) __read_mostly;
+#define PM_TIMER_TICKS_TO_US(p)		(((p) * 1000)/(PM_TIMER_FREQUENCY/1000))
+#define C2_OVERHEAD			1	/* 1us */
+#define C3_OVERHEAD			1	/* 1us */
+
 module_param(max_cstate, uint, 0644);
 
 static unsigned int nocst __read_mostly;
 module_param(nocst, uint, 0000);
 
-/*
- * bm_history -- bit-mask with a bit per jiffy of bus-master activity
- * 1000 HZ: 0xFFFFFFFF: 32 jiffies = 32ms
- * 800 HZ: 0xFFFFFFFF: 32 jiffies = 40ms
- * 100 HZ: 0x0000000F: 4 jiffies = 40ms
- * reduce history for more aggressive entry into C3
- */
-static unsigned int bm_history __read_mostly =
-    (HZ >= 800 ? 0xFFFFFFFF : ((1U << (HZ / 25)) - 1));
-module_param(bm_history, uint, 0644);
 /* --------------------------------------------------------------------------
                                 Power Management
    -------------------------------------------------------------------------- */
@@ -174,88 +165,6 @@ static struct dmi_system_id __cpuinitdat
 	{},
 };
 
-static inline u32 ticks_elapsed(u32 t1, u32 t2)
-{
-	if (t2 >= t1)
-		return (t2 - t1);
-	else if (!(acpi_gbl_FADT.flags & ACPI_FADT_32BIT_TIMER))
-		return (((0x00FFFFFF - t1) + t2) & 0x00FFFFFF);
-	else
-		return ((0xFFFFFFFF - t1) + t2);
-}
-
-static void
-acpi_processor_power_activate(struct acpi_processor *pr,
-			      struct acpi_processor_cx *new)
-{
-	struct acpi_processor_cx *old;
-
-	if (!pr || !new)
-		return;
-
-	old = pr->power.state;
-
-	if (old)
-		old->promotion.count = 0;
-	new->demotion.count = 0;
-
-	/* Cleanup from old state. */
-	if (old) {
-		switch (old->type) {
-		case ACPI_STATE_C3:
-			/* Disable bus master reload */
-			if (new->type != ACPI_STATE_C3 && pr->flags.bm_check)
-				acpi_set_register(ACPI_BITREG_BUS_MASTER_RLD, 0);
-			break;
-		}
-	}
-
-	/* Prepare to use new state. */
-	switch (new->type) {
-	case ACPI_STATE_C3:
-		/* Enable bus master reload */
-		if (old->type != ACPI_STATE_C3 && pr->flags.bm_check)
-			acpi_set_register(ACPI_BITREG_BUS_MASTER_RLD, 1);
-		break;
-	}
-
-	pr->power.state = new;
-
-	return;
-}
-
-static void acpi_safe_halt(void)
-{
-	current_thread_info()->status &= ~TS_POLLING;
-	/*
-	 * TS_POLLING-cleared state must be visible before we
-	 * test NEED_RESCHED:
-	 */
-	smp_mb();
-	if (!need_resched())
-		safe_halt();
-	current_thread_info()->status |= TS_POLLING;
-}
-
-static atomic_t c3_cpu_count;
-
-/* Common C-state entry for C2, C3, .. */
-static void acpi_cstate_enter(struct acpi_processor_cx *cstate)
-{
-	if (cstate->space_id == ACPI_CSTATE_FFH) {
-		/* Call into architectural FFH based C-state */
-		acpi_processor_ffh_cstate_enter(cstate);
-	} else {
-		int unused;
-		/* IO port based C-state */
-		inb(cstate->address);
-		/* Dummy wait op - must do something useless after P_LVL2 read
-		   because chipsets cannot guarantee that STPCLK# signal
-		   gets asserted in time to freeze execution properly. */
-		unused = inl(acpi_gbl_FADT.xpm_timer_block.address);
-	}
-}
-
 #ifdef ARCH_APICTIMER_STOPS_ON_C3
 
 /*
@@ -917,7 +826,7 @@ static void acpi_processor_power_verify_
 	 * Normalize the C2 latency to expidite policy
 	 */
 	cx->valid = 1;
-	cx->latency_ticks = US_TO_PM_TIMER_TICKS(cx->latency);
+	cx->latency_ticks = cx->latency;
 
 	return;
 }
@@ -991,7 +900,7 @@ static void acpi_processor_power_verify_
 	 * use this in our C3 policy
 	 */
 	cx->valid = 1;
-	cx->latency_ticks = US_TO_PM_TIMER_TICKS(cx->latency);
+	cx->latency_ticks = cx->latency;
 
 	return;
 }
@@ -1057,18 +966,6 @@ static int acpi_processor_get_power_info
 	pr->power.count = acpi_processor_power_verify(pr);
 
 	/*
-	 * Set Default Policy
-	 * ------------------
-	 * Now that we know which states are supported, set the default
-	 * policy.  Note that this policy can be changed dynamically
-	 * (e.g. encourage deeper sleeps to conserve battery life when
-	 * not on AC).
-	 */
-	result = acpi_processor_set_power_policy(pr);
-	if (result)
-		return result;
-
-	/*
 	 * if one state of type C2 or C3 is available, mark this
 	 * CPU as being "idle manageable"
 	 */
@@ -1085,9 +982,6 @@ static int acpi_processor_get_power_info
 
 int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 {
-	int result = 0;
-
-
 	if (!pr)
 		return -EINVAL;
 
@@ -1098,16 +992,8 @@ int acpi_processor_cst_has_changed(struc
 	if (!pr->flags.power_setup_done)
 		return -ENODEV;
 
-	/* Fall back to the default idle loop */
-	pm_idle = pm_idle_save;
-	synchronize_sched();	/* Relies on interrupts forcing exit from idle. */
-
-	pr->flags.power = 0;
-	result = acpi_processor_get_power_info(pr);
-	if ((pr->flags.power == 1) && (pr->flags.power_setup_done))
-		pm_idle = acpi_processor_idle;
-
-	return result;
+	acpi_processor_get_power_info(pr);
+	return cpuidle_force_redetect(&per_cpu(cpuidle_devices, pr->id));
 }
 
 /* proc interface */
@@ -1193,30 +1079,6 @@ static const struct file_operations acpi
 	.release = single_release,
 };
 
-#ifdef CONFIG_SMP
-static void smp_callback(void *v)
-{
-	/* we already woke the CPU up, nothing more to do */
-}
-
-/*
- * This function gets called when a part of the kernel has a new latency
- * requirement.  This means we need to get all processors out of their C-state,
- * and then recalculate a new suitable C-state. Just do a cross-cpu IPI; that
- * wakes them all right up.
- */
-static int acpi_processor_latency_notify(struct notifier_block *b,
-		unsigned long l, void *v)
-{
-	smp_call_function(smp_callback, NULL, 0, 1);
-	return NOTIFY_OK;
-}
-
-static struct notifier_block acpi_processor_latency_notifier = {
-	.notifier_call = acpi_processor_latency_notify,
-};
-#endif
-
 int __cpuinit acpi_processor_power_init(struct acpi_processor *pr,
 			      struct acpi_device *device)
 {
@@ -1233,9 +1095,6 @@ int __cpuinit acpi_processor_power_init(
 			       "ACPI: processor limited to max C-state %d\n",
 			       max_cstate);
 		first_run++;
-#ifdef CONFIG_SMP
-		register_latency_notifier(&acpi_processor_latency_notifier);
-#endif
 	}
 
 	if (!pr)
@@ -1252,6 +1111,7 @@ int __cpuinit acpi_processor_power_init(
 
 	acpi_processor_get_power_info(pr);
 
+
 	/*
 	 * Install the idle handler if processor power management is supported.
 	 * Note that we use previously set idle handler will be used on
@@ -1264,11 +1124,6 @@ int __cpuinit acpi_processor_power_init(
 				printk(" C%d[C%d]", i,
 				       pr->power.states[i].type);
 		printk(")\n");
-
-		if (pr->id == 0) {
-			pm_idle_save = pm_idle;
-			pm_idle = acpi_processor_idle;
-		}
 	}
 
 	/* 'power' [R] */
@@ -1296,21 +1151,332 @@ int acpi_processor_power_exit(struct acp
 	if (acpi_device_dir(device))
 		remove_proc_entry(ACPI_PROCESSOR_FILE_POWER,
 				  acpi_device_dir(device));
+	return 0;
+}
 
-	/* Unregister the idle handler when processor #0 is removed. */
-	if (pr->id == 0) {
-		pm_idle = pm_idle_save;
+/**
+ * ticks_elapsed - a helper function that determines how many ticks (in US)
+ *		   have elapsed between two PM Timer timestamps
+ * @t1: the start time
+ * @t2: the end time
+ */
+static inline u32 ticks_elapsed(u32 t1, u32 t2)
+{
+	if (t2 >= t1)
+		return PM_TIMER_TICKS_TO_US(t2 - t1);
+	else if (!(acpi_gbl_FADT.flags & ACPI_FADT_32BIT_TIMER))
+		return PM_TIMER_TICKS_TO_US(((0x00FFFFFF - t1) + t2) & 0x00FFFFFF);
+	else
+		return PM_TIMER_TICKS_TO_US((0xFFFFFFFF - t1) + t2);
+}
 
-		/*
-		 * We are about to unload the current idle thread pm callback
-		 * (pm_idle), Wait for all processors to update cached/local
-		 * copies of pm_idle before proceeding.
-		 */
-		cpu_idle_wait();
-#ifdef CONFIG_SMP
-		unregister_latency_notifier(&acpi_processor_latency_notifier);
+/**
+ * acpi_idle_update_bm_rld - updates the BM_RLD bit depending on target state
+ * @pr: the processor
+ * @target: the new target state
+ */
+static inline void acpi_idle_update_bm_rld(struct acpi_processor *pr,
+					   struct acpi_processor_cx *target)
+{
+	if (pr->flags.bm_rld_set && target->type != ACPI_STATE_C3) {
+		acpi_set_register(ACPI_BITREG_BUS_MASTER_RLD, 0);
+		pr->flags.bm_rld_set = 0;
+	}
+
+	if (!pr->flags.bm_rld_set && target->type == ACPI_STATE_C3) {
+		acpi_set_register(ACPI_BITREG_BUS_MASTER_RLD, 1);
+		pr->flags.bm_rld_set = 1;
+	}
+}
+
+/**
+ * acpi_idle_do_entry - a helper function that does C2 and C3 type entry
+ * @cx: cstate data
+ */
+static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
+{
+	if (cx->space_id == ACPI_CSTATE_FFH) {
+		/* Call into architectural FFH based C-state */
+		acpi_processor_ffh_cstate_enter(cx);
+	} else {
+		int unused;
+		/* IO port based C-state */
+		inb(cx->address);
+		/* Dummy wait op - must do something useless after P_LVL2 read
+		   because chipsets cannot guarantee that STPCLK# signal
+		   gets asserted in time to freeze execution properly. */
+		unused = inl(acpi_gbl_FADT.xpm_timer_block.address);
+	}
+}
+
+/**
+ * acpi_idle_enter_c1 - enters an ACPI C1 state-type
+ * @dev: the target CPU
+ * @state: the state data
+ *
+ * This is equivalent to the HALT instruction.
+ */
+static int acpi_idle_enter_c1(struct cpuidle_device *dev,
+			      struct cpuidle_state *state)
+{
+	struct acpi_processor *pr;
+	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
+	pr = processors[smp_processor_id()];
+
+	if (unlikely(!pr))
+		return 0;
+
+	if (pr->flags.bm_check)
+		acpi_idle_update_bm_rld(pr, cx);
+
+	current_thread_info()->status &= ~TS_POLLING;
+	/*
+	 * TS_POLLING-cleared state must be visible before we test
+	 * NEED_RESCHED:
+	 */
+	smp_mb();
+	if (!need_resched())
+		safe_halt();
+	current_thread_info()->status |= TS_POLLING;
+
+	cx->usage++;
+
+	return 0;
+}
+
+/**
+ * acpi_idle_enter_c2 - enters an ACPI C2 state-type
+ * @dev: the target CPU
+ * @state: the state data
+ */
+static int acpi_idle_enter_c2(struct cpuidle_device *dev,
+			      struct cpuidle_state *state)
+{
+	struct acpi_processor *pr;
+	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
+	u32 t1, t2;
+	pr = processors[smp_processor_id()];
+
+	if (unlikely(!pr))
+		return 0;
+
+	if (pr->flags.bm_check)
+		acpi_idle_update_bm_rld(pr, cx);
+
+	local_irq_disable();
+	current_thread_info()->status &= ~TS_POLLING;
+	/*
+	 * TS_POLLING-cleared state must be visible before we test
+	 * NEED_RESCHED:
+	 */
+	smp_mb();
+
+	if (unlikely(need_resched())) {
+		current_thread_info()->status |= TS_POLLING;
+		local_irq_enable();
+		return 0;
+	}
+
+	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+	acpi_state_timer_broadcast(pr, cx, 1);
+	acpi_idle_do_entry(cx);
+	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+
+#ifdef CONFIG_GENERIC_TIME
+	/* TSC halts in C2, so notify users */
+	mark_tsc_unstable("possible TSC halt in C2");
 #endif
+
+	local_irq_enable();
+	current_thread_info()->status |= TS_POLLING;
+
+	cx->usage++;
+
+	acpi_state_timer_broadcast(pr, cx, 0);
+	return ticks_elapsed(t1, t2);
+}
+
+static int c3_cpu_count;
+static DEFINE_SPINLOCK(c3_lock);
+
+/**
+ * acpi_idle_enter_c3 - enters an ACPI C3 state-type
+ * @dev: the target CPU
+ * @state: the state data
+ *
+ * Similar to C2 entry, except special bus master handling is needed.
+ */
+static int acpi_idle_enter_c3(struct cpuidle_device *dev,
+			      struct cpuidle_state *state)
+{
+	struct acpi_processor *pr;
+	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
+	u32 t1, t2;
+	pr = processors[smp_processor_id()];
+
+	if (unlikely(!pr))
+		return 0;
+
+	if (pr->flags.bm_check)
+		acpi_idle_update_bm_rld(pr, cx);
+
+	local_irq_disable();
+	current_thread_info()->status &= ~TS_POLLING;
+	/*
+	 * TS_POLLING-cleared state must be visible before we test
+	 * NEED_RESCHED:
+	 */
+	smp_mb();
+
+	if (unlikely(need_resched())) {
+		current_thread_info()->status |= TS_POLLING;
+		local_irq_enable();
+		return 0;
 	}
 
+	/* disable bus master */
+	if (pr->flags.bm_check) {
+		spin_lock(&c3_lock);
+			c3_cpu_count++;
+		if (c3_cpu_count == num_online_cpus()) {
+			/*
+			 * All CPUs are trying to go to C3
+			 * Disable bus master arbitration
+			 */
+			acpi_set_register(ACPI_BITREG_ARB_DISABLE, 1);
+		}
+		spin_unlock(&c3_lock);
+	} else {
+		/* SMP with no shared cache... Invalidate cache  */
+		ACPI_FLUSH_CPU_CACHE();
+	}
+
+	/* Get start time (ticks) */
+	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+	acpi_state_timer_broadcast(pr, cx, 1);
+	acpi_idle_do_entry(cx);
+	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+
+	if (pr->flags.bm_check) {
+		spin_lock(&c3_lock);
+		/* Enable bus master arbitration */
+		if (c3_cpu_count == num_online_cpus())
+			acpi_set_register(ACPI_BITREG_ARB_DISABLE, 0);
+		c3_cpu_count--;
+		spin_unlock(&c3_lock);
+	}
+
+#ifdef CONFIG_GENERIC_TIME
+	/* TSC halts in C3, so notify users */
+	mark_tsc_unstable("TSC halts in C3");
+#endif
+
+	local_irq_enable();
+	current_thread_info()->status |= TS_POLLING;
+
+	cx->usage++;
+
+	acpi_state_timer_broadcast(pr, cx, 0);
+	return ticks_elapsed(t1, t2);
+}
+
+/**
+ * acpi_idle_bm_check - checks if bus master activity was detected
+ */
+static int acpi_idle_bm_check(void)
+{
+	u32 bm_status = 0;
+
+	acpi_get_register(ACPI_BITREG_BUS_MASTER_STATUS, &bm_status);
+	if (bm_status)
+		acpi_set_register(ACPI_BITREG_BUS_MASTER_STATUS, 1);
+	/*
+	 * PIIX4 Erratum #18: Note that BM_STS doesn't always reflect
+	 * the true state of bus mastering activity; forcing us to
+	 * manually check the BMIDEA bit of each IDE channel.
+	 */
+	else if (errata.piix4.bmisx) {
+		if ((inb_p(errata.piix4.bmisx + 0x02) & 0x01)
+		    || (inb_p(errata.piix4.bmisx + 0x0A) & 0x01))
+			bm_status = 1;
+	}
+	return bm_status;
+}
+
+/**
+ * acpi_idle_init - attaches the driver to a CPU
+ * @dev: the CPU
+ */
+static int acpi_idle_init(struct cpuidle_device *dev)
+{
+	int cpu = dev->cpu;
+	int i, count = 0;
+	struct acpi_processor_cx *cx;
+	struct cpuidle_state *state;
+
+	struct acpi_processor *pr = processors[cpu];
+
+	if (!pr->flags.power_setup_done)
+		return -EINVAL;
+
+	if (pr->flags.power == 0) {
+		return -EINVAL;
+	}
+
+	for (i = 1; i < ACPI_PROCESSOR_MAX_POWER; i++) {
+		cx = &pr->power.states[i];
+		state = &dev->states[count];
+
+		if (!cx->valid)
+			continue;
+
+#ifdef CONFIG_HOTPLUG_CPU
+		if ((cx->type != ACPI_STATE_C1) && (num_online_cpus() > 1) &&
+		    !pr->flags.has_cst &&
+		    !(acpi_gbl_FADT.flags & ACPI_FADT_C2_MP_SUPPORTED))
+			continue;
+#endif
+		cpuidle_set_statedata(state, cx);
+
+		state->exit_latency = cx->latency;
+		state->target_residency = cx->latency * 6;
+		state->power_usage = cx->power;
+
+		state->flags = 0;
+		switch (cx->type) {
+			case ACPI_STATE_C1:
+			state->flags |= CPUIDLE_FLAG_SHALLOW;
+			state->enter = acpi_idle_enter_c1;
+			break;
+
+			case ACPI_STATE_C2:
+			state->flags |= CPUIDLE_FLAG_BALANCED;
+			state->flags |= CPUIDLE_FLAG_TIME_VALID;
+			state->enter = acpi_idle_enter_c2;
+			break;
+
+			case ACPI_STATE_C3:
+			state->flags |= CPUIDLE_FLAG_DEEP;
+			state->flags |= CPUIDLE_FLAG_TIME_VALID;
+			state->flags |= CPUIDLE_FLAG_CHECK_BM;
+			state->enter = acpi_idle_enter_c3;
+			break;
+		}
+
+		count++;
+	}
+
+	if (!count)
+		return -EINVAL;
+
+	dev->state_count = count;
 	return 0;
 }
+
+struct cpuidle_driver acpi_idle_driver = {
+	.name =		"acpi_idle",
+	.init =		acpi_idle_init,
+	.redetect =	acpi_idle_init,
+	.bm_check =	acpi_idle_bm_check,
+	.owner =	THIS_MODULE,
+};
diff -puN include/acpi/processor.h~cpuidle-take2-hookup-acpi-c-states-driver-with-cpuidle include/acpi/processor.h
--- a/include/acpi/processor.h~cpuidle-take2-hookup-acpi-c-states-driver-with-cpuidle
+++ a/include/acpi/processor.h
@@ -161,6 +161,7 @@ struct acpi_processor_flags {
 	u8 bm_check:1;
 	u8 has_cst:1;
 	u8 power_setup_done:1;
+	u8 bm_rld_set:1;
 };
 
 struct acpi_processor {
@@ -275,6 +276,7 @@ int acpi_processor_power_init(struct acp
 int acpi_processor_cst_has_changed(struct acpi_processor *pr);
 int acpi_processor_power_exit(struct acpi_processor *pr,
 			      struct acpi_device *device);
+extern struct cpuidle_driver acpi_idle_driver;
 
 /* in processor_thermal.c */
 int acpi_processor_get_limit_info(struct acpi_processor *pr);
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-acpi.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
