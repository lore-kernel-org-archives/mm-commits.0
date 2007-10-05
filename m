From: akpm@linux-foundation.org
Subject: - cpufreq-implement-config_cpu_freq-stub-for.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:56:19 -0700
Message-ID: <200710051956.l95JuJdY022344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46709 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760152AbXJET4g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 15:56:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     cpufreq: implement !CONFIG_CPU_FREQ stub for  cpufreq_unregister_notifier()
has been removed from the -mm tree.  Its filename was
     cpufreq-implement-config_cpu_freq-stub-for.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpufreq: implement !CONFIG_CPU_FREQ stub for  cpufreq_unregister_notifier()
From: Satyam Sharma <satyam@infradead.org>

Callsites such as arch/powerpc/oprofile/op_model_cell.c are having to
open-code #ifdef CONFIG_CPU_FREQ only to be able to get at the full definition
of cpufreq_unregister_notifier(), because no empty stub is available for the
!CONFIG_CPU_FREQ case.  Let's provide one, to be able to remove such #ifdef's
from the rest of the kernel tree -- those will come in a subsequent patch.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpufreq.h |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -puN include/linux/cpufreq.h~cpufreq-implement-config_cpu_freq-stub-for include/linux/cpufreq.h
--- a/include/linux/cpufreq.h~cpufreq-implement-config_cpu_freq-stub-for
+++ a/include/linux/cpufreq.h
@@ -32,12 +32,24 @@
  *                     CPUFREQ NOTIFIER INTERFACE                    *
  *********************************************************************/
 
-int cpufreq_register_notifier(struct notifier_block *nb, unsigned int list);
-int cpufreq_unregister_notifier(struct notifier_block *nb, unsigned int list);
-
 #define CPUFREQ_TRANSITION_NOTIFIER	(0)
 #define CPUFREQ_POLICY_NOTIFIER		(1)
 
+#ifdef CONFIG_CPU_FREQ
+int cpufreq_register_notifier(struct notifier_block *nb, unsigned int list);
+int cpufreq_unregister_notifier(struct notifier_block *nb, unsigned int list);
+#else		/* CONFIG_CPU_FREQ */
+static inline int cpufreq_register_notifier(struct notifier_block *nb,
+						unsigned int list)
+{
+	return 0;
+}
+static inline int cpufreq_unregister_notifier(struct notifier_block *nb,
+						unsigned int list)
+{
+	return 0;
+}
+#endif		/* CONFIG_CPU_FREQ */
 
 /* if (cpufreq_driver->target) exists, the ->governor decides what frequency
  * within the limits is used. If (cpufreq_driver->setpolicy> exists, these
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
