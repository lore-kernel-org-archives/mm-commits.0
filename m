From: akpm@linux-foundation.org
Subject: - cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:56:17 -0700
Message-ID: <200710051956.l95JuHOr022341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53737 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759298AbXJET4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 15:56:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     cpufreq: mark hotplug notifier callback as __cpuinit
has been removed from the -mm tree.  Its filename was
     cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpufreq: mark hotplug notifier callback as __cpuinit
From: Satyam Sharma <satyam@infradead.org>

The notifier_block is already __cpuinitdata, thereby allowing us to safely
mark the callback function as __cpuinit also, thereby saving space when
HOTPLUG_CPU=n.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cpufreq/cpufreq.c~cpufreq-mark-hotplug-notifier-callback-as-__cpuinit drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~cpufreq-mark-hotplug-notifier-callback-as-__cpuinit
+++ a/drivers/cpufreq/cpufreq.c
@@ -1730,7 +1730,7 @@ int cpufreq_update_policy(unsigned int c
 }
 EXPORT_SYMBOL(cpufreq_update_policy);
 
-static int cpufreq_cpu_callback(struct notifier_block *nfb,
+static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
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
