From: akpm@linux-foundation.org
Subject: - x86_64-mce_amd-fix-section-mismatch-warnings.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:58:34 -0700
Message-ID: <200708242058.l7OKwYC2014315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36505 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758608AbXHXVIC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, mm-commits@vger.kernel.org


The patch titled
     x86_64 mce{_amd}: Fix section mismatch warnings
has been removed from the -mm tree.  Its filename was
     x86_64-mce_amd-fix-section-mismatch-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64 mce{_amd}: Fix section mismatch warnings
From: Satyam Sharma <satyam@infradead.org>

* mce.c:

mce_create_device() is marked __cpuinit and hence goes into .init.text
when HOTPLUG_CPU=n. However, the hotplug notifier callback function
mce_cpu_callback() is not marked __cpuinit therefore goes into .text
section unconditionally. This causes reference to .init.text from .text
which would cause modpost to warn (bogusly, because a CPU hotplug event
can never happen anyway if HOTPLUG_CPU=n). Anyway, let's fix this by
marking callback as __cpuinit and the notifier_block as __cpuinitdata.
Having done that, mce_remove_device() is only ever called from __cpuinit
marked functions so can be marked __cpuinit itself.

* mce_amd.c:

Has an exactly similar section mismatch as that discussed in previous
case. Solve it similarly by marking notifier callback as __cpuinit and
notifier_block as __cpuinitdata. This causes a viral effect and allows
us to mark a bunch of other functions as __cpuinit also.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/mce.c     |    6 +++---
 arch/x86_64/kernel/mce_amd.c |   10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/x86_64/kernel/mce.c~x86_64-mce_amd-fix-section-mismatch-warnings arch/x86_64/kernel/mce.c
--- a/arch/x86_64/kernel/mce.c~x86_64-mce_amd-fix-section-mismatch-warnings
+++ a/arch/x86_64/kernel/mce.c
@@ -833,7 +833,7 @@ static __cpuinit int mce_create_device(u
 	return err;
 }
 
-static void mce_remove_device(unsigned int cpu)
+static void __cpuinit mce_remove_device(unsigned int cpu)
 {
 	int i;
 
@@ -845,7 +845,7 @@ static void mce_remove_device(unsigned i
 }
 
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
-static int
+static int __cpuinit
 mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
@@ -863,7 +863,7 @@ mce_cpu_callback(struct notifier_block *
 	return NOTIFY_OK;
 }
 
-static struct notifier_block mce_cpu_notifier = {
+static struct notifier_block mce_cpu_notifier __cpuinitdata = {
 	.notifier_call = mce_cpu_callback,
 };
 
diff -puN arch/x86_64/kernel/mce_amd.c~x86_64-mce_amd-fix-section-mismatch-warnings arch/x86_64/kernel/mce_amd.c
--- a/arch/x86_64/kernel/mce_amd.c~x86_64-mce_amd-fix-section-mismatch-warnings
+++ a/arch/x86_64/kernel/mce_amd.c
@@ -570,7 +570,7 @@ out:
  *   of shared sysfs dir/files, and rest of the cores will be symlinked to it.
  */
 
-static void deallocate_threshold_block(unsigned int cpu,
+static void __cpuinit deallocate_threshold_block(unsigned int cpu,
 						 unsigned int bank)
 {
 	struct threshold_block *pos = NULL;
@@ -590,7 +590,7 @@ static void deallocate_threshold_block(u
 	per_cpu(threshold_banks, cpu)[bank]->blocks = NULL;
 }
 
-static void threshold_remove_bank(unsigned int cpu, int bank)
+static void __cpuinit threshold_remove_bank(unsigned int cpu, int bank)
 {
 	int i = 0;
 	struct threshold_bank *b;
@@ -632,7 +632,7 @@ free_out:
 	per_cpu(threshold_banks, cpu)[bank] = NULL;
 }
 
-static void threshold_remove_device(unsigned int cpu)
+static void __cpuinit threshold_remove_device(unsigned int cpu)
 {
 	unsigned int bank;
 
@@ -644,7 +644,7 @@ static void threshold_remove_device(unsi
 }
 
 /* get notified when a cpu comes on/off */
-static int threshold_cpu_callback(struct notifier_block *nfb,
+static int __cpuinit threshold_cpu_callback(struct notifier_block *nfb,
 					    unsigned long action, void *hcpu)
 {
 	/* cpu was unsigned int to begin with */
@@ -669,7 +669,7 @@ static int threshold_cpu_callback(struct
 	return NOTIFY_OK;
 }
 
-static struct notifier_block threshold_cpu_notifier = {
+static struct notifier_block threshold_cpu_notifier __cpuinitdata = {
 	.notifier_call = threshold_cpu_callback,
 };
 
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
cpufreq-implement-config_cpu_freq-stub-for.patch
cpufreq_stats-misc-cpuinit-section-annotations.patch
hwmon-coretemp-remove-bogus-__cpuinitdata-etc-cleanup.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
git-ieee1394.patch
ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch
git-netdev-all.patch
git-net.patch
git-s390.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
therm_throtc-fix-section-mismatch.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning-fix.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch
