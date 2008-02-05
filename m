From: akpm@linux-foundation.org
Subject: - latencyc-use-qos-infrastructure.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:34:12 -0800
Message-ID: <200802052233.m15MXrxC012462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49424 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758161AbYBEWo6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgross@linux.intel.com, arjan@infradead.org, lenb@kernel.org, linville@tuxdriver.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     latency.c: use QoS infrastructure
has been removed from the -mm tree.  Its filename was
     latencyc-use-qos-infrastructure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: latency.c: use QoS infrastructure
From: Mark Gross <mgross@linux.intel.com>

Replace latency.c use with pm_qos_params use.

Signed-off-by: mark gross <mgross@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c  |   18 +
 drivers/net/wireless/ipw2100.c |   12 -
 include/linux/latency.h        |   25 --
 kernel/Makefile                |    2 
 kernel/latency.c               |  280 -------------------------------
 sound/core/pcm_native.c        |   11 -
 6 files changed, 26 insertions(+), 322 deletions(-)

diff -puN drivers/acpi/processor_idle.c~latencyc-use-qos-infrastructure drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~latencyc-use-qos-infrastructure
+++ a/drivers/acpi/processor_idle.c
@@ -38,7 +38,7 @@
 #include <linux/dmi.h>
 #include <linux/moduleparam.h>
 #include <linux/sched.h>	/* need_resched() */
-#include <linux/latency.h>
+#include <linux/pm_qos_params.h>
 #include <linux/clockchips.h>
 #include <linux/cpuidle.h>
 
@@ -648,7 +648,8 @@ static void acpi_processor_idle(void)
 	if (cx->promotion.state &&
 	    ((cx->promotion.state - pr->power.states) <= max_cstate)) {
 		if (sleep_ticks > cx->promotion.threshold.ticks &&
-		  cx->promotion.state->latency <= system_latency_constraint()) {
+		  cx->promotion.state->latency <=
+				pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY)) {
 			cx->promotion.count++;
 			cx->demotion.count = 0;
 			if (cx->promotion.count >=
@@ -692,7 +693,8 @@ static void acpi_processor_idle(void)
 	 * or if the latency of the current state is unacceptable
 	 */
 	if ((pr->power.state - pr->power.states) > max_cstate ||
-		pr->power.state->latency > system_latency_constraint()) {
+		pr->power.state->latency >
+				pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY)) {
 		if (cx->demotion.state)
 			next_state = cx->demotion.state;
 	}
@@ -1200,7 +1202,7 @@ static int acpi_processor_power_seq_show
 		   "maximum allowed latency: %d usec\n",
 		   pr->power.state ? pr->power.state - pr->power.states : 0,
 		   max_cstate, (unsigned)pr->power.bm_activity,
-		   system_latency_constraint());
+		   pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY));
 
 	seq_puts(seq, "states:\n");
 
@@ -1718,8 +1720,9 @@ int __cpuinit acpi_processor_power_init(
 			       "ACPI: processor limited to max C-state %d\n",
 			       max_cstate);
 		first_run++;
-#if !defined (CONFIG_CPU_IDLE) && defined (CONFIG_SMP)
-		register_latency_notifier(&acpi_processor_latency_notifier);
+#if !defined(CONFIG_CPU_IDLE) && defined(CONFIG_SMP)
+		pm_qos_add_notifier(PM_QOS_CPU_DMA_LATENCY,
+				&acpi_processor_latency_notifier);
 #endif
 	}
 
@@ -1806,7 +1809,8 @@ int acpi_processor_power_exit(struct acp
 		 */
 		cpu_idle_wait();
 #ifdef CONFIG_SMP
-		unregister_latency_notifier(&acpi_processor_latency_notifier);
+		pm_qos_remove_notifier(PM_QOS_CPU_DMA_LATENCY,
+				&acpi_processor_latency_notifier);
 #endif
 	}
 #endif
diff -puN drivers/net/wireless/ipw2100.c~latencyc-use-qos-infrastructure drivers/net/wireless/ipw2100.c
--- a/drivers/net/wireless/ipw2100.c~latencyc-use-qos-infrastructure
+++ a/drivers/net/wireless/ipw2100.c
@@ -162,7 +162,7 @@ that only one external action is invoked
 #include <linux/firmware.h>
 #include <linux/acpi.h>
 #include <linux/ctype.h>
-#include <linux/latency.h>
+#include <linux/pm_qos_params.h>
 
 #include "ipw2100.h"
 
@@ -1701,7 +1701,7 @@ static int ipw2100_up(struct ipw2100_pri
 	/* the ipw2100 hardware really doesn't want power management delays
 	 * longer than 175usec
 	 */
-	modify_acceptable_latency("ipw2100", 175);
+	pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100", 175);
 
 	/* If the interrupt is enabled, turn it off... */
 	spin_lock_irqsave(&priv->low_lock, flags);
@@ -1856,7 +1856,8 @@ static void ipw2100_down(struct ipw2100_
 	ipw2100_disable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->low_lock, flags);
 
-	modify_acceptable_latency("ipw2100", INFINITE_LATENCY);
+	pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100",
+			PM_QOS_DEFAULT_VALUE);
 
 	/* We have to signal any supplicant if we are disassociating */
 	if (associated)
@@ -6554,7 +6555,8 @@ static int __init ipw2100_init(void)
 	if (ret)
 		goto out;
 
-	set_acceptable_latency("ipw2100", INFINITE_LATENCY);
+	pm_qos_add_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100",
+			PM_QOS_DEFAULT_VALUE);
 #ifdef CONFIG_IPW2100_DEBUG
 	ipw2100_debug_level = debug;
 	ret = driver_create_file(&ipw2100_pci_driver.driver,
@@ -6576,7 +6578,7 @@ static void __exit ipw2100_exit(void)
 			   &driver_attr_debug_level);
 #endif
 	pci_unregister_driver(&ipw2100_pci_driver);
-	remove_acceptable_latency("ipw2100");
+	pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100");
 }
 
 module_init(ipw2100_init);
diff -puN include/linux/latency.h~latencyc-use-qos-infrastructure /dev/null
--- a/include/linux/latency.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * latency.h: Explicit system-wide latency-expectation infrastructure
- *
- * (C) Copyright 2006 Intel Corporation
- * Author: Arjan van de Ven <arjan@linux.intel.com>
- *
- */
-
-#ifndef _INCLUDE_GUARD_LATENCY_H_
-#define _INCLUDE_GUARD_LATENCY_H_
-
-#include <linux/notifier.h>
-
-void set_acceptable_latency(char *identifier, int usecs);
-void modify_acceptable_latency(char *identifier, int usecs);
-void remove_acceptable_latency(char *identifier);
-void synchronize_acceptable_latency(void);
-int system_latency_constraint(void);
-
-int register_latency_notifier(struct notifier_block * nb);
-int unregister_latency_notifier(struct notifier_block * nb);
-
-#define INFINITE_LATENCY 1000000
-
-#endif
diff -puN kernel/Makefile~latencyc-use-qos-infrastructure kernel/Makefile
--- a/kernel/Makefile~latencyc-use-qos-infrastructure
+++ a/kernel/Makefile
@@ -8,7 +8,7 @@ obj-y     = sched.o fork.o exec_domain.o
 	    signal.o sys.o kmod.o workqueue.o pid.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
-	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o \
+	    hrtimer.o rwsem.o nsproxy.o srcu.o \
 	    utsname.o notifier.o ksysfs.o pm_qos_params.o
 
 obj-$(CONFIG_SYSCTL) += sysctl_check.o
diff -puN kernel/latency.c~latencyc-use-qos-infrastructure /dev/null
--- a/kernel/latency.c
+++ /dev/null
@@ -1,280 +0,0 @@
-/*
- * latency.c: Explicit system-wide latency-expectation infrastructure
- *
- * The purpose of this infrastructure is to allow device drivers to set
- * latency constraint they have and to collect and summarize these
- * expectations globally. The cummulated result can then be used by
- * power management and similar users to make decisions that have
- * tradoffs with a latency component.
- *
- * An example user of this are the x86 C-states; each higher C state saves
- * more power, but has a higher exit latency. For the idle loop power
- * code to make a good decision which C-state to use, information about
- * acceptable latencies is required.
- *
- * An example announcer of latency is an audio driver that knowns it
- * will get an interrupt when the hardware has 200 usec of samples
- * left in the DMA buffer; in that case the driver can set a latency
- * constraint of, say, 150 usec.
- *
- * Multiple drivers can each announce their maximum accepted latency,
- * to keep these appart, a string based identifier is used.
- *
- *
- * (C) Copyright 2006 Intel Corporation
- * Author: Arjan van de Ven <arjan@linux.intel.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; version 2
- * of the License.
- */
-
-#include <linux/latency.h>
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/notifier.h>
-#include <linux/jiffies.h>
-#include <asm/atomic.h>
-
-struct latency_info {
-	struct list_head list;
-	int usecs;
-	char *identifier;
-};
-
-/*
- * locking rule: all modifications to current_max_latency and
- * latency_list need to be done while holding the latency_lock.
- * latency_lock needs to be taken _irqsave.
- */
-static atomic_t current_max_latency;
-static DEFINE_SPINLOCK(latency_lock);
-
-static LIST_HEAD(latency_list);
-static BLOCKING_NOTIFIER_HEAD(latency_notifier);
-
-/*
- * This function returns the maximum latency allowed, which
- * happens to be the minimum of all maximum latencies on the
- * list.
- */
-static int __find_max_latency(void)
-{
-	int min = INFINITE_LATENCY;
-	struct latency_info *info;
-
-	list_for_each_entry(info, &latency_list, list) {
-		if (info->usecs < min)
-			min = info->usecs;
-	}
-	return min;
-}
-
-/**
- * set_acceptable_latency - sets the maximum latency acceptable
- * @identifier: string that identifies this driver
- * @usecs: maximum acceptable latency for this driver
- *
- * This function informs the kernel that this device(driver)
- * can accept at most usecs latency. This setting is used for
- * power management and similar tradeoffs.
- *
- * This function sleeps and can only be called from process
- * context.
- * Calling this function with an existing identifier is valid
- * and will cause the existing latency setting to be changed.
- */
-void set_acceptable_latency(char *identifier, int usecs)
-{
-	struct latency_info *info, *iter;
-	unsigned long flags;
-	int found_old = 0;
-
-	info = kzalloc(sizeof(struct latency_info), GFP_KERNEL);
-	if (!info)
-		return;
-	info->usecs = usecs;
-	info->identifier = kstrdup(identifier, GFP_KERNEL);
-	if (!info->identifier)
-		goto free_info;
-
-	spin_lock_irqsave(&latency_lock, flags);
-	list_for_each_entry(iter, &latency_list, list) {
-		if (strcmp(iter->identifier, identifier)==0) {
-			found_old = 1;
-			iter->usecs = usecs;
-			break;
-		}
-	}
-	if (!found_old)
-		list_add(&info->list, &latency_list);
-
-	if (usecs < atomic_read(&current_max_latency))
-		atomic_set(&current_max_latency, usecs);
-
-	spin_unlock_irqrestore(&latency_lock, flags);
-
-	blocking_notifier_call_chain(&latency_notifier,
-		atomic_read(&current_max_latency), NULL);
-
-	/*
-	 * if we inserted the new one, we're done; otherwise there was
-	 * an existing one so we need to free the redundant data
-	 */
-	if (!found_old)
-		return;
-
-	kfree(info->identifier);
-free_info:
-	kfree(info);
-}
-EXPORT_SYMBOL_GPL(set_acceptable_latency);
-
-/**
- * modify_acceptable_latency - changes the maximum latency acceptable
- * @identifier: string that identifies this driver
- * @usecs: maximum acceptable latency for this driver
- *
- * This function informs the kernel that this device(driver)
- * can accept at most usecs latency. This setting is used for
- * power management and similar tradeoffs.
- *
- * This function does not sleep and can be called in any context.
- * Trying to use a non-existing identifier silently gets ignored.
- *
- * Due to the atomic nature of this function, the modified latency
- * value will only be used for future decisions; past decisions
- * can still lead to longer latencies in the near future.
- */
-void modify_acceptable_latency(char *identifier, int usecs)
-{
-	struct latency_info *iter;
-	unsigned long flags;
-
-	spin_lock_irqsave(&latency_lock, flags);
-	list_for_each_entry(iter, &latency_list, list) {
-		if (strcmp(iter->identifier, identifier) == 0) {
-			iter->usecs = usecs;
-			break;
-		}
-	}
-	if (usecs < atomic_read(&current_max_latency))
-		atomic_set(&current_max_latency, usecs);
-	spin_unlock_irqrestore(&latency_lock, flags);
-}
-EXPORT_SYMBOL_GPL(modify_acceptable_latency);
-
-/**
- * remove_acceptable_latency - removes the maximum latency acceptable
- * @identifier: string that identifies this driver
- *
- * This function removes a previously set maximum latency setting
- * for the driver and frees up any resources associated with the
- * bookkeeping needed for this.
- *
- * This function does not sleep and can be called in any context.
- * Trying to use a non-existing identifier silently gets ignored.
- */
-void remove_acceptable_latency(char *identifier)
-{
-	unsigned long flags;
-	int newmax = 0;
-	struct latency_info *iter, *temp;
-
-	spin_lock_irqsave(&latency_lock, flags);
-
-	list_for_each_entry_safe(iter,  temp, &latency_list, list) {
-		if (strcmp(iter->identifier, identifier) == 0) {
-			list_del(&iter->list);
-			newmax = iter->usecs;
-			kfree(iter->identifier);
-			kfree(iter);
-			break;
-		}
-	}
-
-	/* If we just deleted the system wide value, we need to
-	 * recalculate with a full search
-	 */
-	if (newmax == atomic_read(&current_max_latency)) {
-		newmax = __find_max_latency();
-		atomic_set(&current_max_latency, newmax);
-	}
-	spin_unlock_irqrestore(&latency_lock, flags);
-}
-EXPORT_SYMBOL_GPL(remove_acceptable_latency);
-
-/**
- * system_latency_constraint - queries the system wide latency maximum
- *
- * This function returns the system wide maximum latency in
- * microseconds.
- *
- * This function does not sleep and can be called in any context.
- */
-int system_latency_constraint(void)
-{
-	return atomic_read(&current_max_latency);
-}
-EXPORT_SYMBOL_GPL(system_latency_constraint);
-
-/**
- * synchronize_acceptable_latency - recalculates all latency decisions
- *
- * This function will cause a callback to various kernel pieces that
- * will make those pieces rethink their latency decisions. This implies
- * that if there are overlong latencies in hardware state already, those
- * latencies get taken right now. When this call completes no overlong
- * latency decisions should be active anymore.
- *
- * Typical usecase of this is after a modify_acceptable_latency() call,
- * which in itself is non-blocking and non-synchronizing.
- *
- * This function blocks and should not be called with locks held.
- */
-
-void synchronize_acceptable_latency(void)
-{
-	blocking_notifier_call_chain(&latency_notifier,
-		atomic_read(&current_max_latency), NULL);
-}
-EXPORT_SYMBOL_GPL(synchronize_acceptable_latency);
-
-/*
- * Latency notifier: this notifier gets called when a non-atomic new
- * latency value gets set. The expectation nof the caller of the
- * non-atomic set is that when the call returns, future latencies
- * are within bounds, so the functions on the notifier list are
- * expected to take the overlong latencies immediately, inside the
- * callback, and not make a overlong latency decision anymore.
- *
- * The callback gets called when the new latency value is made
- * active so system_latency_constraint() returns the new latency.
- */
-int register_latency_notifier(struct notifier_block * nb)
-{
-	return blocking_notifier_chain_register(&latency_notifier, nb);
-}
-EXPORT_SYMBOL_GPL(register_latency_notifier);
-
-int unregister_latency_notifier(struct notifier_block * nb)
-{
-	return blocking_notifier_chain_unregister(&latency_notifier, nb);
-}
-EXPORT_SYMBOL_GPL(unregister_latency_notifier);
-
-static __init int latency_init(void)
-{
-	atomic_set(&current_max_latency, INFINITE_LATENCY);
-	/*
-	 * we don't want by default to have longer latencies than 2 ticks,
-	 * since that would cause lost ticks
-	 */
-	set_acceptable_latency("kernel", 2*1000000/HZ);
-	return 0;
-}
-
-module_init(latency_init);
diff -puN sound/core/pcm_native.c~latencyc-use-qos-infrastructure sound/core/pcm_native.c
--- a/sound/core/pcm_native.c~latencyc-use-qos-infrastructure
+++ a/sound/core/pcm_native.c
@@ -23,7 +23,7 @@
 #include <linux/file.h>
 #include <linux/slab.h>
 #include <linux/time.h>
-#include <linux/latency.h>
+#include <linux/pm_qos_params.h>
 #include <linux/uio.h>
 #include <sound/core.h>
 #include <sound/control.h>
@@ -443,9 +443,11 @@ static int snd_pcm_hw_params(struct snd_
 	snd_pcm_timer_resolution_change(substream);
 	runtime->status->state = SNDRV_PCM_STATE_SETUP;
 
-	remove_acceptable_latency(substream->latency_id);
+	pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY,
+				substream->latency_id);
 	if ((usecs = period_to_usecs(runtime)) >= 0)
-		set_acceptable_latency(substream->latency_id, usecs);
+		pm_qos_add_requirement(PM_QOS_CPU_DMA_LATENCY,
+					substream->latency_id, usecs);
 	return 0;
  _error:
 	/* hardware might be unuseable from this time,
@@ -505,7 +507,8 @@ static int snd_pcm_hw_free(struct snd_pc
 	if (substream->ops->hw_free)
 		result = substream->ops->hw_free(substream);
 	runtime->status->state = SNDRV_PCM_STATE_OPEN;
-	remove_acceptable_latency(substream->latency_id);
+	pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY,
+		substream->latency_id);
 	return result;
 }
 
_

Patches currently in -mm which might be from mgross@linux.intel.com are

origin.patch
intel-iommu-pmen-support.patch
intel-iommu-pmen-support-fix.patch
intel-iommu-fault_reason_index_cleanuppatch.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
