From: akpm@linux-foundation.org
Subject: - i386-cpuid-misc-cpuinit-annotations.patch removed from -mm tree
Date: Tue, 02 Oct 2007 15:55:22 -0700
Message-ID: <200710022255.l92MtMav026778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60542 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271AbXJBWzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2007 18:55:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, ak@suse.de, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     i386 cpuid: Misc cpuinit annotations
has been removed from the -mm tree.  Its filename was
     i386-cpuid-misc-cpuinit-annotations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 cpuid: Misc cpuinit annotations
From: Satyam Sharma <satyam@infradead.org>

cpuid_class_cpu_callback() is callback function of a CPU hotplug
notifier_block (that is already marked as __cpuinitdata).  Therefore it can
safely be marked as __cpuinit.

cpuid_device_create() is only referenced from other functions that are
__cpuinit or __init.  So it can also be safely marked __cpuinit.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Andi Kleen <ak@suse.de>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpuid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/cpuid.c~i386-cpuid-misc-cpuinit-annotations arch/i386/kernel/cpuid.c
--- a/arch/i386/kernel/cpuid.c~i386-cpuid-misc-cpuinit-annotations
+++ a/arch/i386/kernel/cpuid.c
@@ -136,7 +136,7 @@ static const struct file_operations cpui
 	.open = cpuid_open,
 };
 
-static int cpuid_device_create(int cpu)
+static int __cpuinit cpuid_device_create(int cpu)
 {
 	struct device *dev;
 
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
git-libata-all.patch
git-net.patch
git-s390.patch
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
