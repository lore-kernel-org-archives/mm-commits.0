From: akpm@linux-foundation.org
Subject: - cpufreq_stats-misc-cpuinit-section-annotations.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:56:21 -0700
Message-ID: <200710051956.l95JuL0j022347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36951 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbXJET4h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 15:56:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     cpufreq_stats: misc cpuinit section annotations
has been removed from the -mm tree.  Its filename was
     cpufreq_stats-misc-cpuinit-section-annotations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpufreq_stats: misc cpuinit section annotations
From: Satyam Sharma <satyam@infradead.org>

* Stop referencing the callback directly from the __init and __exit
  functions of this driver, and instead explicitly call
  cpufreq_update_policy() et al. This enables the callback function
  to be marked as __cpuinit (and the notifier_block __cpuinitdata),
  thereby saving space when HOTPLUG_CPU=n. This also enables us to
  use other tricks to replace __cpuinit{data} in future.

* cpufreq_stats_free_table() is only called from __cpuinit or __exit
  marked functions, making it an ideal candidate for __cpuexit.

* Undo some 80-column extremism which was leading to the description
  of this module to being incorrectly printed with /sbin/modinfo :-(

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_stats.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff -puN drivers/cpufreq/cpufreq_stats.c~cpufreq_stats-misc-cpuinit-section-annotations drivers/cpufreq/cpufreq_stats.c
--- a/drivers/cpufreq/cpufreq_stats.c~cpufreq_stats-misc-cpuinit-section-annotations
+++ a/drivers/cpufreq/cpufreq_stats.c
@@ -164,8 +164,7 @@ freq_table_get_index(struct cpufreq_stat
 	return -1;
 }
 
-static void
-cpufreq_stats_free_table (unsigned int cpu)
+static void __cpuexit cpufreq_stats_free_table(unsigned int cpu)
 {
 	struct cpufreq_stats *stat = cpufreq_stats_table[cpu];
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
@@ -305,8 +304,9 @@ cpufreq_stat_notifier_trans (struct noti
 	return 0;
 }
 
-static int cpufreq_stat_cpu_callback(struct notifier_block *nfb,
-					unsigned long action, void *hcpu)
+static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
+					       unsigned long action,
+					       void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
 
@@ -323,7 +323,7 @@ static int cpufreq_stat_cpu_callback(str
 	return NOTIFY_OK;
 }
 
-static struct notifier_block cpufreq_stat_cpu_notifier =
+static struct notifier_block cpufreq_stat_cpu_notifier __cpuinitdata =
 {
 	.notifier_call = cpufreq_stat_cpu_callback,
 };
@@ -356,8 +356,7 @@ __init cpufreq_stats_init(void)
 
 	register_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
 	for_each_online_cpu(cpu) {
-		cpufreq_stat_cpu_callback(&cpufreq_stat_cpu_notifier,
-				CPU_ONLINE, (void *)(long)cpu);
+		cpufreq_update_policy(cpu);
 	}
 	return 0;
 }
@@ -372,14 +371,12 @@ __exit cpufreq_stats_exit(void)
 			CPUFREQ_TRANSITION_NOTIFIER);
 	unregister_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
 	for_each_online_cpu(cpu) {
-		cpufreq_stat_cpu_callback(&cpufreq_stat_cpu_notifier,
-						CPU_DEAD, (void *)(long)cpu);
+		cpufreq_stats_free_table(cpu);
 	}
 }
 
 MODULE_AUTHOR ("Zou Nan hai <nanhai.zou@intel.com>");
-MODULE_DESCRIPTION ("'cpufreq_stats' - A driver to export cpufreq stats"
-				"through sysfs filesystem");
+MODULE_DESCRIPTION ("'cpufreq_stats' - A driver to export cpufreq stats through sysfs filesystem");
 MODULE_LICENSE ("GPL");
 
 module_init(cpufreq_stats_init);
_

Patches currently in -mm which might be from satyam@infradead.org are

git-cpufreq.patch
git-powerpc.patch
git-hwmon.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
ia64-perfmon-remove-exit_pfm_fs.patch
git-ieee1394.patch
git-infiniband.patch
git-libata-all.patch
git-net.patch
git-s390.patch
git-scsi-misc.patch
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
