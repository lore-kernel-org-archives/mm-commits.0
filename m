From: akpm@linux-foundation.org
Subject: - s390-appldata_base-misc-cpuinit-annotations-and-bugfix.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:58:00 -0700
Message-ID: <200708242058.l7OKw0aP014269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48167 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759755AbXHXVIN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390 appldata_base: Misc cpuinit annotations and bugfix
has been removed from the -mm tree.  Its filename was
     s390-appldata_base-misc-cpuinit-annotations-and-bugfix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s390 appldata_base: Misc cpuinit annotations and bugfix
From: Satyam Sharma <satyam@infradead.org>

appldata_offline_cpu() is only called from __cpuinit-marked hotplug
notifier callback and from the __exit-marked module_exit function,
therefore candidate for __cpuexit.

BTW the __exit module_exit function appldata_exit() of this driver fails to
unregister_hotcpu_notifier() the notifier_block that was registered by
appldata_init() during module startup.  This will lead to oops if hotplug
notification comes after module has been unloaded.  Let's fix this by
unregistering the notifier appropriately (before appldata_offline_cpu()'ing
the CPUs).

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/appldata/appldata_base.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff -puN arch/s390/appldata/appldata_base.c~s390-appldata_base-misc-cpuinit-annotations-and-bugfix arch/s390/appldata/appldata_base.c
--- a/arch/s390/appldata/appldata_base.c~s390-appldata_base-misc-cpuinit-annotations-and-bugfix
+++ a/arch/s390/appldata/appldata_base.c
@@ -547,8 +547,7 @@ static void __cpuinit appldata_online_cp
 	spin_unlock(&appldata_timer_lock);
 }
 
-static void
-appldata_offline_cpu(int cpu)
+static void __cpuexit appldata_offline_cpu(int cpu)
 {
 	del_virt_timer(&per_cpu(appldata_timer, cpu));
 	if (atomic_dec_and_test(&appldata_expire_count)) {
@@ -560,9 +559,9 @@ appldata_offline_cpu(int cpu)
 	spin_unlock(&appldata_timer_lock);
 }
 
-static int __cpuinit
-appldata_cpu_notify(struct notifier_block *self,
-		    unsigned long action, void *hcpu)
+static int __cpuinit appldata_cpu_notify(struct notifier_block *self,
+					 unsigned long action,
+					 void *hcpu)
 {
 	switch (action) {
 	case CPU_ONLINE:
@@ -646,6 +645,8 @@ static void __exit appldata_exit(void)
 	}
 	spin_unlock(&appldata_ops_lock);
 
+	unregister_hotcpu_notifier(&appldata_nb);
+
 	for_each_online_cpu(i)
 		appldata_offline_cpu(i);
 
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
