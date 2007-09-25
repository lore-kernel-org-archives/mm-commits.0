From: akpm@linux-foundation.org
Subject: - ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch removed from -mm tree
Date: Mon, 24 Sep 2007 20:58:02 -0700
Message-ID: <200709250358.l8P3w35I031913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55822 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759406AbXIYD6j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 23:58:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     ehca_irq: misc cpuinit section annotations and #ifdef cleanups
has been removed from the -mm tree.  Its filename was
     ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ehca_irq: misc cpuinit section annotations and #ifdef cleanups
From: Satyam Sharma <satyam@infradead.org>

* Replace {un}register_cpu_notifier with {un}register_hotcpu_notifier
  thereby losing a couple of #ifdef HOTPLUG_CPU pairs.
* Move comp_pool_callback_nb declaration to below that of callback
  function so that initialization of .notifier_call and .priority can
  occur at build time itself and not runtime.
* Mark the notifier_block (and callback function, and another static
  function used by it) as __cpuinit{data} for the sake of consistency
  and remove enclosing #ifdef. (This may increase size for modular
  build of this module, however, because these are no longer dropped
  unconditionally now.)

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/ehca/ehca_irq.c |   29 +++++++++---------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff -puN drivers/infiniband/hw/ehca/ehca_irq.c~ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups drivers/infiniband/hw/ehca/ehca_irq.c
--- a/drivers/infiniband/hw/ehca/ehca_irq.c~ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups
+++ a/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -69,9 +69,6 @@
 static void queue_comp_task(struct ehca_cq *__cq);
 
 static struct ehca_comp_pool *pool;
-#ifdef CONFIG_HOTPLUG_CPU
-static struct notifier_block comp_pool_callback_nb;
-#endif
 
 static inline void comp_event_callback(struct ehca_cq *cq)
 {
@@ -760,9 +757,7 @@ static void destroy_comp_task(struct ehc
 		kthread_stop(task);
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-static void take_over_work(struct ehca_comp_pool *pool,
-			   int cpu)
+static void __cpuinit take_over_work(struct ehca_comp_pool *pool, int cpu)
 {
 	struct ehca_cpu_comp_task *cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
 	LIST_HEAD(list);
@@ -785,9 +780,9 @@ static void take_over_work(struct ehca_c
 
 }
 
-static int comp_pool_callback(struct notifier_block *nfb,
-			      unsigned long action,
-			      void *hcpu)
+static int __cpuinit comp_pool_callback(struct notifier_block *nfb,
+					unsigned long action,
+					void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
 	struct ehca_cpu_comp_task *cct;
@@ -833,7 +828,11 @@ static int comp_pool_callback(struct not
 
 	return NOTIFY_OK;
 }
-#endif
+
+static struct notifier_block comp_pool_callback_nb __cpuinitdata = {
+	.notifier_call	= comp_pool_callback,
+	.priority	= 0,
+};
 
 int ehca_create_comp_pool(void)
 {
@@ -864,11 +863,7 @@ int ehca_create_comp_pool(void)
 		}
 	}
 
-#ifdef CONFIG_HOTPLUG_CPU
-	comp_pool_callback_nb.notifier_call = comp_pool_callback;
-	comp_pool_callback_nb.priority = 0;
-	register_cpu_notifier(&comp_pool_callback_nb);
-#endif
+	register_hotcpu_notifier(&comp_pool_callback_nb);
 
 	printk(KERN_INFO "eHCA scaling code enabled\n");
 
@@ -882,9 +877,7 @@ void ehca_destroy_comp_pool(void)
 	if (!ehca_scaling_code)
 		return;
 
-#ifdef CONFIG_HOTPLUG_CPU
-	unregister_cpu_notifier(&comp_pool_callback_nb);
-#endif
+	unregister_hotcpu_notifier(&comp_pool_callback_nb);
 
 	for (i = 0; i < NR_CPUS; i++) {
 		if (cpu_online(i))
_

Patches currently in -mm which might be from satyam@infradead.org are

cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
cpufreq-implement-config_cpu_freq-stub-for.patch
cpufreq_stats-misc-cpuinit-section-annotations.patch
git-hwmon.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
ia64-perfmon-remove-exit_pfm_fs.patch
git-ieee1394.patch
git-infiniband.patch
git-net.patch
git-net-fix-spidernet-build.patch
mv643xx_eth-remove-redundant-multiple-initialization.patch
iseries_veth-kill-unused-variable.patch
spider_net_ethtool-keep-up-with-recent-netdev-stats-changes.patch
pasemi_mac-build-fix-after-recent-netdev-stats.patch
git-s390.patch
sched-use-show_regs-to-improve-__schedule_bug-output.patch
git-scsi-misc.patch
mpt-fusion-shut-up-uninitialized-variable.patch
git-block.patch
git-watchdog.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
softlockup-improve-debug-output-fix.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch
i2o-fix-defined-but-not-used-build-warnings.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
unify-dma_bit_mask-definitions-v31.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch
