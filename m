From: akpm@osdl.org
Subject: - hotplug-cpu-clean-up-hotcpu_notifier-use.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:05:33 -0800
Message-ID: <200612072305.kB7N5XP0030165@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52531 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163907AbWLGXFp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:05:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     hotplug CPU: clean up hotcpu_notifier() use
has been removed from the -mm tree.  Its filename was
     hotplug-cpu-clean-up-hotcpu_notifier-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hotplug CPU: clean up hotcpu_notifier() use
From: Ingo Molnar <mingo@elte.hu>

There was lots of #ifdef noise in the kernel due to hotcpu_notifier(fn,
prio) not correctly marking 'fn' as used in the !HOTPLUG_CPU case, and thus
generating compiler warnings of unused symbols, hence forcing people to add
#ifdefs.

the compiler can skip truly unused functions just fine:

    text    data     bss     dec     hex filename
 1624412  728710 3674856 6027978  5bfaca vmlinux.before
 1624412  728710 3674856 6027978  5bfaca vmlinux.after

[akpm@osdl.org: topology.c fix]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/cpu/mcheck/therm_throt.c |    2 --
 arch/i386/kernel/cpuid.c                  |    2 --
 arch/i386/kernel/microcode.c              |    2 --
 arch/i386/kernel/msr.c                    |    2 --
 arch/ia64/kernel/palinfo.c                |    2 --
 arch/ia64/kernel/salinfo.c                |    2 --
 arch/s390/appldata/appldata_base.c        |    2 --
 arch/x86_64/kernel/mce.c                  |    2 --
 arch/x86_64/kernel/mce_amd.c              |    4 ++--
 arch/x86_64/kernel/vsyscall.c             |    2 --
 block/ll_rw_blk.c                         |    4 ----
 drivers/base/topology.c                   |    2 --
 drivers/cpufreq/cpufreq.c                 |    2 --
 fs/buffer.c                               |    2 --
 include/linux/cpu.h                       |    6 +++---
 kernel/cpuset.c                           |    4 ----
 kernel/profile.c                          |    3 +--
 kernel/sched.c                            |    3 ---
 kernel/workqueue.c                        |    2 --
 lib/radix-tree.c                          |    2 --
 mm/page_alloc.c                           |    4 ----
 mm/swap.c                                 |    2 ++
 mm/vmscan.c                               |    2 --
 net/core/dev.c                            |    2 --
 net/core/flow.c                           |    2 --
 25 files changed, 8 insertions(+), 56 deletions(-)

diff -puN arch/i386/kernel/cpu/mcheck/therm_throt.c~hotplug-cpu-clean-up-hotcpu_notifier-use arch/i386/kernel/cpu/mcheck/therm_throt.c
--- a/arch/i386/kernel/cpu/mcheck/therm_throt.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/arch/i386/kernel/cpu/mcheck/therm_throt.c
@@ -116,7 +116,6 @@ static __cpuinit int thermal_throttle_ad
 	return sysfs_create_group(&sys_dev->kobj, &thermal_throttle_attr_group);
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 static __cpuinit void thermal_throttle_remove_dev(struct sys_device *sys_dev)
 {
 	return sysfs_remove_group(&sys_dev->kobj, &thermal_throttle_attr_group);
@@ -153,7 +152,6 @@ static struct notifier_block thermal_thr
 {
 	.notifier_call = thermal_throttle_cpu_callback,
 };
-#endif /* CONFIG_HOTPLUG_CPU */
 
 static __init int thermal_throttle_init_device(void)
 {
diff -puN arch/i386/kernel/cpuid.c~hotplug-cpu-clean-up-hotcpu_notifier-use arch/i386/kernel/cpuid.c
--- a/arch/i386/kernel/cpuid.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/arch/i386/kernel/cpuid.c
@@ -167,7 +167,6 @@ static int cpuid_device_create(int i)
 	return err;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 static int cpuid_class_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
@@ -187,7 +186,6 @@ static struct notifier_block __cpuinitda
 {
 	.notifier_call = cpuid_class_cpu_callback,
 };
-#endif /* !CONFIG_HOTPLUG_CPU */
 
 static int __init cpuid_init(void)
 {
diff -puN arch/i386/kernel/microcode.c~hotplug-cpu-clean-up-hotcpu_notifier-use arch/i386/kernel/microcode.c
--- a/arch/i386/kernel/microcode.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/arch/i386/kernel/microcode.c
@@ -703,7 +703,6 @@ static struct sysdev_driver mc_sysdev_dr
 	.resume = mc_sysdev_resume,
 };
 
-#ifdef CONFIG_HOTPLUG_CPU
 static __cpuinit int
 mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 {
@@ -726,7 +725,6 @@ mc_cpu_callback(struct notifier_block *n
 static struct notifier_block mc_cpu_notifier = {
 	.notifier_call = mc_cpu_callback,
 };
-#endif
 
 static int __init microcode_init (void)
 {
diff -puN arch/i386/kernel/msr.c~hotplug-cpu-clean-up-hotcpu_notifier-use arch/i386/kernel/msr.c
--- a/arch/i386/kernel/msr.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/arch/i386/kernel/msr.c
@@ -250,7 +250,6 @@ static int msr_device_create(int i)
 	return err;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 static int msr_class_cpu_callback(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
 {
@@ -271,7 +270,6 @@ static struct notifier_block __cpuinitda
 {
 	.notifier_call = msr_class_cpu_callback,
 };
-#endif
 
 static int __init msr_init(void)
 {
diff -puN arch/ia64/kernel/palinfo.c~hotplug-cpu-clean-up-hotcpu_notifier-use arch/ia64/kernel/palinfo.c
--- a/arch/ia64/kernel/palinfo.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/arch/ia64/kernel/palinfo.c
@@ -952,7 +952,6 @@ remove_palinfo_proc_entries(unsigned int
 	}
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 static int palinfo_cpu_callback(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
@@ -974,7 +973,6 @@ static struct notifier_block palinfo_cpu
 	.notifier_call = palinfo_cpu_callback,
 	.priority = 0,
 };
-#endif
 
 static int __init
 palinfo_init(void)
diff -puN arch/ia64/kernel/salinfo.c~hotplug-cpu-clean-up-hotcpu_notifier-use arch/ia64/kernel/salinfo.c
--- a/arch/ia64/kernel/salinfo.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/arch/ia64/kernel/salinfo.c
@@ -575,7 +575,6 @@ static struct file_operations salinfo_da
 	.write   = salinfo_log_write,
 };
 
-#ifdef	CONFIG_HOTPLUG_CPU
 static int __devinit
 salinfo_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 {
@@ -620,7 +619,6 @@ static struct notifier_block salinfo_cpu
 	.notifier_call = salinfo_cpu_callback,
 	.priority = 0,
 };
-#endif	/* CONFIG_HOTPLUG_CPU */
 
 static int __init
 salinfo_init(void)
diff -puN arch/s390/appldata/appldata_base.c~hotplug-cpu-clean-up-hotcpu_notifier-use arch/s390/appldata/appldata_base.c
--- a/arch/s390/appldata/appldata_base.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/arch/s390/appldata/appldata_base.c
@@ -561,7 +561,6 @@ appldata_offline_cpu(int cpu)
 	spin_unlock(&appldata_timer_lock);
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 static int __cpuinit
 appldata_cpu_notify(struct notifier_block *self,
 		    unsigned long action, void *hcpu)
@@ -582,7 +581,6 @@ appldata_cpu_notify(struct notifier_bloc
 static struct notifier_block appldata_nb = {
 	.notifier_call = appldata_cpu_notify,
 };
-#endif
 
 /*
  * appldata_init()
diff -puN arch/x86_64/kernel/mce.c~hotplug-cpu-clean-up-hotcpu_notifier-use arch/x86_64/kernel/mce.c
--- a/arch/x86_64/kernel/mce.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/arch/x86_64/kernel/mce.c
@@ -641,7 +641,6 @@ static __cpuinit int mce_create_device(u
 	return err;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 static void mce_remove_device(unsigned int cpu)
 {
 	int i;
@@ -674,7 +673,6 @@ mce_cpu_callback(struct notifier_block *
 static struct notifier_block mce_cpu_notifier = {
 	.notifier_call = mce_cpu_callback,
 };
-#endif
 
 static __init int mce_init_device(void)
 {
diff -puN arch/x86_64/kernel/mce_amd.c~hotplug-cpu-clean-up-hotcpu_notifier-use arch/x86_64/kernel/mce_amd.c
--- a/arch/x86_64/kernel/mce_amd.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/arch/x86_64/kernel/mce_amd.c
@@ -551,7 +551,6 @@ out:
 	return err;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 /*
  * let's be hotplug friendly.
  * in case of multiple core processors, the first core always takes ownership
@@ -594,12 +593,14 @@ static void threshold_remove_bank(unsign
 
 	sprintf(name, "threshold_bank%i", bank);
 
+#ifdef CONFIG_SMP
 	/* sibling symlink */
 	if (shared_bank[bank] && b->blocks->cpu != cpu) {
 		sysfs_remove_link(&per_cpu(device_mce, cpu).kobj, name);
 		per_cpu(threshold_banks, cpu)[bank] = NULL;
 		return;
 	}
+#endif
 
 	/* remove all sibling symlinks before unregistering */
 	for_each_cpu_mask(i, b->cpus) {
@@ -656,7 +657,6 @@ static int threshold_cpu_callback(struct
 static struct notifier_block threshold_cpu_notifier = {
 	.notifier_call = threshold_cpu_callback,
 };
-#endif /* CONFIG_HOTPLUG_CPU */
 
 static __init int threshold_init_device(void)
 {
diff -puN arch/x86_64/kernel/vsyscall.c~hotplug-cpu-clean-up-hotcpu_notifier-use arch/x86_64/kernel/vsyscall.c
--- a/arch/x86_64/kernel/vsyscall.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/arch/x86_64/kernel/vsyscall.c
@@ -275,7 +275,6 @@ static void __cpuinit cpu_vsyscall_init(
 	vsyscall_set_cpu(raw_smp_processor_id());
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 static int __cpuinit
 cpu_vsyscall_notifier(struct notifier_block *n, unsigned long action, void *arg)
 {
@@ -284,7 +283,6 @@ cpu_vsyscall_notifier(struct notifier_bl
 		smp_call_function_single(cpu, cpu_vsyscall_init, NULL, 0, 1);
 	return NOTIFY_DONE;
 }
-#endif
 
 static void __init map_vsyscall(void)
 {
diff -puN block/ll_rw_blk.c~hotplug-cpu-clean-up-hotcpu_notifier-use block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/block/ll_rw_blk.c
@@ -3459,8 +3459,6 @@ static void blk_done_softirq(struct soft
 	}
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-
 static int blk_cpu_notify(struct notifier_block *self, unsigned long action,
 			  void *hcpu)
 {
@@ -3486,8 +3484,6 @@ static struct notifier_block __devinitda
 	.notifier_call	= blk_cpu_notify,
 };
 
-#endif /* CONFIG_HOTPLUG_CPU */
-
 /**
  * blk_complete_request - end I/O on a request
  * @req:      the request being processed
diff -puN drivers/base/topology.c~hotplug-cpu-clean-up-hotcpu_notifier-use drivers/base/topology.c
--- a/drivers/base/topology.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/drivers/base/topology.c
@@ -108,7 +108,6 @@ static int __cpuinit topology_add_dev(un
 	return rc;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 static void __cpuinit topology_remove_dev(unsigned int cpu)
 {
 	struct sys_device *sys_dev = get_cpu_sysdev(cpu);
@@ -136,7 +135,6 @@ static int __cpuinit topology_cpu_callba
 	}
 	return rc ? NOTIFY_BAD : NOTIFY_OK;
 }
-#endif
 
 static int __cpuinit topology_sysfs_init(void)
 {
diff -puN drivers/cpufreq/cpufreq.c~hotplug-cpu-clean-up-hotcpu_notifier-use drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/drivers/cpufreq/cpufreq.c
@@ -1537,7 +1537,6 @@ int cpufreq_update_policy(unsigned int c
 }
 EXPORT_SYMBOL(cpufreq_update_policy);
 
-#ifdef CONFIG_HOTPLUG_CPU
 static int cpufreq_cpu_callback(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
@@ -1577,7 +1576,6 @@ static struct notifier_block __cpuinitda
 {
     .notifier_call = cpufreq_cpu_callback,
 };
-#endif /* CONFIG_HOTPLUG_CPU */
 
 /*********************************************************************
  *               REGISTER / UNREGISTER CPUFREQ DRIVER                *
diff -puN fs/buffer.c~hotplug-cpu-clean-up-hotcpu_notifier-use fs/buffer.c
--- a/fs/buffer.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/fs/buffer.c
@@ -2972,7 +2972,6 @@ init_buffer_head(void *data, struct kmem
 	}
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 static void buffer_exit_cpu(int cpu)
 {
 	int i;
@@ -2994,7 +2993,6 @@ static int buffer_cpu_notify(struct noti
 		buffer_exit_cpu((unsigned long)hcpu);
 	return NOTIFY_OK;
 }
-#endif /* CONFIG_HOTPLUG_CPU */
 
 void __init buffer_init(void)
 {
diff -puN include/linux/cpu.h~hotplug-cpu-clean-up-hotcpu_notifier-use include/linux/cpu.h
--- a/include/linux/cpu.h~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/include/linux/cpu.h
@@ -89,9 +89,9 @@ int cpu_down(unsigned int cpu);
 #define lock_cpu_hotplug()	do { } while (0)
 #define unlock_cpu_hotplug()	do { } while (0)
 #define lock_cpu_hotplug_interruptible() 0
-#define hotcpu_notifier(fn, pri)	do { } while (0)
-#define register_hotcpu_notifier(nb)	do { } while (0)
-#define unregister_hotcpu_notifier(nb)	do { } while (0)
+#define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
+#define register_hotcpu_notifier(nb)	do { (void)(nb); } while (0)
+#define unregister_hotcpu_notifier(nb)	do { (void)(nb); } while (0)
 
 /* CPUs don't go offline once they're online w/o CONFIG_HOTPLUG_CPU */
 static inline int cpu_is_offline(int cpu) { return 0; }
diff -puN kernel/cpuset.c~hotplug-cpu-clean-up-hotcpu_notifier-use kernel/cpuset.c
--- a/kernel/cpuset.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/kernel/cpuset.c
@@ -2044,7 +2044,6 @@ out:
 	return err;
 }
 
-#if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_MEMORY_HOTPLUG)
 /*
  * If common_cpu_mem_hotplug_unplug(), below, unplugs any CPUs
  * or memory nodes, we need to walk over the cpuset hierarchy,
@@ -2108,9 +2107,7 @@ static void common_cpu_mem_hotplug_unplu
 	mutex_unlock(&callback_mutex);
 	mutex_unlock(&manage_mutex);
 }
-#endif
 
-#ifdef CONFIG_HOTPLUG_CPU
 /*
  * The top_cpuset tracks what CPUs and Memory Nodes are online,
  * period.  This is necessary in order to make cpusets transparent
@@ -2127,7 +2124,6 @@ static int cpuset_handle_cpuhp(struct no
 	common_cpu_mem_hotplug_unplug();
 	return 0;
 }
-#endif
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 /*
diff -puN kernel/profile.c~hotplug-cpu-clean-up-hotcpu_notifier-use kernel/profile.c
--- a/kernel/profile.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/kernel/profile.c
@@ -319,7 +319,6 @@ out:
 	put_cpu();
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 static int __devinit profile_cpu_callback(struct notifier_block *info,
 					unsigned long action, void *__cpu)
 {
@@ -372,10 +371,10 @@ static int __devinit profile_cpu_callbac
 	}
 	return NOTIFY_OK;
 }
-#endif /* CONFIG_HOTPLUG_CPU */
 #else /* !CONFIG_SMP */
 #define profile_flip_buffers()		do { } while (0)
 #define profile_discard_flip_buffers()	do { } while (0)
+#define profile_cpu_callback		NULL
 
 void profile_hits(int type, void *__pc, unsigned int nr_hits)
 {
diff -puN kernel/sched.c~hotplug-cpu-clean-up-hotcpu_notifier-use kernel/sched.c
--- a/kernel/sched.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/kernel/sched.c
@@ -6740,8 +6740,6 @@ SYSDEV_ATTR(sched_smt_power_savings, 064
 	    sched_smt_power_savings_store);
 #endif
 
-
-#ifdef CONFIG_HOTPLUG_CPU
 /*
  * Force a reinitialization of the sched domains hierarchy.  The domains
  * and groups cannot be updated in place without racing with the balancing
@@ -6774,7 +6772,6 @@ static int update_sched_domains(struct n
 
 	return NOTIFY_OK;
 }
-#endif
 
 void __init sched_init_smp(void)
 {
diff -puN kernel/workqueue.c~hotplug-cpu-clean-up-hotcpu_notifier-use kernel/workqueue.c
--- a/kernel/workqueue.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/kernel/workqueue.c
@@ -655,7 +655,6 @@ int current_is_keventd(void)
 
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 /* Take the work from this (downed) CPU. */
 static void take_over_work(struct workqueue_struct *wq, unsigned int cpu)
 {
@@ -738,7 +737,6 @@ static int __devinit workqueue_cpu_callb
 
 	return NOTIFY_OK;
 }
-#endif
 
 void init_workqueues(void)
 {
diff -puN lib/radix-tree.c~hotplug-cpu-clean-up-hotcpu_notifier-use lib/radix-tree.c
--- a/lib/radix-tree.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/lib/radix-tree.c
@@ -996,7 +996,6 @@ static __init void radix_tree_init_maxin
 		height_to_maxindex[i] = __maxindex(i);
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 static int radix_tree_callback(struct notifier_block *nfb,
                             unsigned long action,
                             void *hcpu)
@@ -1016,7 +1015,6 @@ static int radix_tree_callback(struct no
        }
        return NOTIFY_OK;
 }
-#endif /* CONFIG_HOTPLUG_CPU */
 
 void __init radix_tree_init(void)
 {
diff -puN mm/page_alloc.c~hotplug-cpu-clean-up-hotcpu_notifier-use mm/page_alloc.c
--- a/mm/page_alloc.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/mm/page_alloc.c
@@ -701,7 +701,6 @@ void drain_node_pages(int nodeid)
 }
 #endif
 
-#if defined(CONFIG_PM) || defined(CONFIG_HOTPLUG_CPU)
 static void __drain_pages(unsigned int cpu)
 {
 	unsigned long flags;
@@ -723,7 +722,6 @@ static void __drain_pages(unsigned int c
 		}
 	}
 }
-#endif /* CONFIG_PM || CONFIG_HOTPLUG_CPU */
 
 #ifdef CONFIG_PM
 
@@ -2907,7 +2905,6 @@ void __init free_area_init(unsigned long
 			__pa(PAGE_OFFSET) >> PAGE_SHIFT, NULL);
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 static int page_alloc_cpu_notify(struct notifier_block *self,
 				 unsigned long action, void *hcpu)
 {
@@ -2922,7 +2919,6 @@ static int page_alloc_cpu_notify(struct 
 	}
 	return NOTIFY_OK;
 }
-#endif /* CONFIG_HOTPLUG_CPU */
 
 void __init page_alloc_init(void)
 {
diff -puN mm/swap.c~hotplug-cpu-clean-up-hotcpu_notifier-use mm/swap.c
--- a/mm/swap.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/mm/swap.c
@@ -514,5 +514,7 @@ void __init swap_setup(void)
 	 * Right now other parts of the system means that we
 	 * _really_ don't want to cluster much more
 	 */
+#ifdef CONFIG_HOTPLUG_CPU
 	hotcpu_notifier(cpu_swap_callback, 0);
+#endif
 }
diff -puN mm/vmscan.c~hotplug-cpu-clean-up-hotcpu_notifier-use mm/vmscan.c
--- a/mm/vmscan.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/mm/vmscan.c
@@ -1513,7 +1513,6 @@ out:
 }
 #endif
 
-#ifdef CONFIG_HOTPLUG_CPU
 /* It's optimal to keep kswapds on the same CPUs as their memory, but
    not required for correctness.  So if the last cpu in a node goes
    away, we get changed to run anywhere: as the first one comes back,
@@ -1534,7 +1533,6 @@ static int __devinit cpu_callback(struct
 	}
 	return NOTIFY_OK;
 }
-#endif /* CONFIG_HOTPLUG_CPU */
 
 /*
  * This kswapd start function will be called by init and node-hot-add.
diff -puN net/core/dev.c~hotplug-cpu-clean-up-hotcpu_notifier-use net/core/dev.c
--- a/net/core/dev.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/net/core/dev.c
@@ -3340,7 +3340,6 @@ void unregister_netdev(struct net_device
 
 EXPORT_SYMBOL(unregister_netdev);
 
-#ifdef CONFIG_HOTPLUG_CPU
 static int dev_cpu_callback(struct notifier_block *nfb,
 			    unsigned long action,
 			    void *ocpu)
@@ -3384,7 +3383,6 @@ static int dev_cpu_callback(struct notif
 
 	return NOTIFY_OK;
 }
-#endif /* CONFIG_HOTPLUG_CPU */
 
 #ifdef CONFIG_NET_DMA
 /**
diff -puN net/core/flow.c~hotplug-cpu-clean-up-hotcpu_notifier-use net/core/flow.c
--- a/net/core/flow.c~hotplug-cpu-clean-up-hotcpu_notifier-use
+++ a/net/core/flow.c
@@ -340,7 +340,6 @@ static void __devinit flow_cache_cpu_pre
 	tasklet_init(tasklet, flow_cache_flush_tasklet, 0);
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 static int flow_cache_cpu(struct notifier_block *nfb,
 			  unsigned long action,
 			  void *hcpu)
@@ -349,7 +348,6 @@ static int flow_cache_cpu(struct notifie
 		__flow_cache_shrink((unsigned long)hcpu, 0);
 	return NOTIFY_OK;
 }
-#endif /* CONFIG_HOTPLUG_CPU */
 
 static int __init flow_cache_init(void)
 {
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
cpei-gets-warning-at-kernel-irq-migrationc27-move_masked_irq.patch
time-re-add-verify_pmtmr_rate.patch
debug-add-sysrq_always_enabled-boot-option.patch
lockdep-filter-off-by-default.patch
lockdep-improve-verbose-messages.patch
lockdep-improve-lockdep_reset.patch
lockdep-clean-up-very_verbose-define.patch
lockdep-use-chain-hash-on-config_debug_lockdep-too.patch
lockdep-print-irq-trace-info-on-asserts.patch
lockdep-fix-possible-races-while-disabling-lock-debugging.patch
remove-the-old-bd_mutex-lockdep-annotation.patch
new-bd_mutex-lockdep-annotation.patch
remove-lock_key-approach-to-managing-nested-bd_mutex-locks.patch
simplify-some-aspects-of-bd_mutex-nesting.patch
use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning.patch
avoid-lockdep-warning-in-md.patch
fix-generic-warn_on-message.patch
schedc-correct-comment-for-this_rq_lock-routine.patch
sched-fix-migration-cost-estimator.patch
sched-domain-move-sched-group-allocations-to-percpu-area.patch
move_task_off_dead_cpu-should-be-called-with-disabled-ints.patch
sched-domain-increase-the-smt-busy-rebalance-interval.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
sched-improve-migration-accuracy.patch
sched-improve-migration-accuracy-tidy.patch
sched-decrease-number-of-load-balances.patch
sched-remove-lb_stopbalance-counter.patch
sched-optimize-activate_task-for-rt-task.patch
kernel-schedc-whitespace-cleanups.patch
kernel-schedc-whitespace-cleanups-more.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
time-uninline-jiffiesh.patch
time-uninline-jiffiesh-fix.patch
time-fix-msecs_to_jiffies-bug.patch
time-fix-timeout-overflow.patch
cleanup-uninline-irq_enter-and-move-it-into-a-function.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-remove-incorrect-warning-in-kernel-timerc.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-hrtimers-clean-up-callback-tracking.patch
updated-hrtimers-move-and-add-documentation.patch
updated-add-a-framework-to-manage-clock-event-devices.patch
updated-acpi-include-apich.patch
updated-acpi-keep-track-of-timer-broadcast.patch
updated-acpi-add-state-propagation-for-dynamic-broadcasting.patch
updated-i386-cleanup-apic-code.patch
updated-i386-convert-to-clock-event-devices.patch
updated-pm_timer-allow-early-access-and-move-externs-to-a-header-file.patch
updated-i386-rework-local-apic-calibration.patch
updated-high-res-timers-core.patch
updated-high-res-timers-core-high-res-timers-do-itimer-rearming-in-process-context.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
high-res-timers-utilize-tsc-clocksource-again.patch
high-res-timers-utilize-tsc-clocksource-again-fix.patch
updated-dynticks-core-code.patch
updated-dynticks-core-code-fix-resume-bug.patch
updated-dyntick-add-nohz-stats-to-proc-stat.patch
updated-dynticks-i386-arch-code.patch
updated-dynticks-fix-nmi-watchdog.patch
updated-high-res-timers-dynticks-enable-i386-support.patch
updated-debugging-feature-timer-stats.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
round_jiffies-infrastructure.patch
round_jiffies-infrastructure-fix.patch
clocksource-add-usage-of-config_sysfs.patch
clocksource-small-cleanup-2.patch
clocksource-small-cleanup-2-fix.patch
clocksource-small-acpi_pm-cleanup.patch
kvm-amd-svm-implementation-more-i386-fixes.patch
detect-atomic-counter-underflows.patch
debug-shared-irqs.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch

