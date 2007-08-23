From: akpm@linux-foundation.org
Subject: + cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch added to -mm tree
Date: Thu, 23 Aug 2007 16:17:23 -0700
Message-ID: <200708232317.l7NNHNuS032034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52915 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757864AbXHWXRh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 19:17:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, davej@codemonkey.org.uk


The patch titled
     cpufreq: mark hotplug notifier callback as __cpuinit
has been added to the -mm tree.  Its filename is
     cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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

origin.patch
cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
cpufreq-implement-config_cpu_freq-stub-for.patch
cpufreq_stats-misc-cpuinit-section-annotations.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
git-ieee1394.patch
ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch
git-netdev-all.patch
git-net.patch
s390-appldata_base-misc-cpuinit-annotations-and-bugfix.patch
s390-appldata_base-remove-module_exit-function-and-modular.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
therm_throtc-fix-section-mismatch.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch
x86_64-mce_amd-fix-section-mismatch-warnings.patch
drivers-video-geode-lxfb_corec-fix-build.patch
