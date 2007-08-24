From: akpm@linux-foundation.org
Subject: - s390-appldata_base-remove-module_exit-function-and-modular.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:58:02 -0700
Message-ID: <200708242058.l7OKw24g014278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59280 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760217AbXHXVIN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390 appldata_base: Remove module_exit function and modular stuff
has been removed from the -mm tree.  Its filename was
     s390-appldata_base-remove-module_exit-function-and-modular.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s390 appldata_base: Remove module_exit function and modular stuff
From: Satyam Sharma <satyam@infradead.org>

arch/s390/Kconfig tells us that CONFIG_APPLDATA_BASE is bool and hence can
never be built modular.  Given this, defining appldata_exit() function is
pointless (and wasteful, actually).  Remove all that.

Previous patch annotated appldata_offline_cpu() as __cpuexit, but now with the
__exit function appldata_exit() gone, the only callsite that references it is
__cpuinit, so this function can also be __cpuinit, thereby saving space when
HOTPLUG_CPU=n.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/appldata/appldata_base.c |   48 ---------------------------
 1 files changed, 1 insertion(+), 47 deletions(-)

diff -puN arch/s390/appldata/appldata_base.c~s390-appldata_base-remove-module_exit-function-and-modular arch/s390/appldata/appldata_base.c
--- a/arch/s390/appldata/appldata_base.c~s390-appldata_base-remove-module_exit-function-and-modular
+++ a/arch/s390/appldata/appldata_base.c
@@ -547,7 +547,7 @@ static void __cpuinit appldata_online_cp
 	spin_unlock(&appldata_timer_lock);
 }
 
-static void __cpuexit appldata_offline_cpu(int cpu)
+static void __cpuinit appldata_offline_cpu(int cpu)
 {
 	del_virt_timer(&per_cpu(appldata_timer, cpu));
 	if (atomic_dec_and_test(&appldata_expire_count)) {
@@ -607,61 +607,15 @@ static int __init appldata_init(void)
 	register_hotcpu_notifier(&appldata_nb);
 
 	appldata_sysctl_header = register_sysctl_table(appldata_dir_table);
-#ifdef MODULE
-	appldata_dir_table[0].de->owner = THIS_MODULE;
-	appldata_table[0].de->owner = THIS_MODULE;
-	appldata_table[1].de->owner = THIS_MODULE;
-#endif
 
 	P_DEBUG("Base interface initialized.\n");
 	return 0;
 }
 
-/*
- * appldata_exit()
- *
- * stop timer, unregister /proc entries
- */
-static void __exit appldata_exit(void)
-{
-	struct list_head *lh;
-	struct appldata_ops *ops;
-	int rc, i;
-
-	P_DEBUG("Unloading module ...\n");
-	/*
-	 * ops list should be empty, but just in case something went wrong...
-	 */
-	spin_lock(&appldata_ops_lock);
-	list_for_each(lh, &appldata_ops_list) {
-		ops = list_entry(lh, struct appldata_ops, list);
-		rc = appldata_diag(ops->record_nr, APPLDATA_STOP_REC,
-				(unsigned long) ops->data, ops->size,
-				ops->mod_lvl);
-		if (rc != 0) {
-			P_ERROR("STOP DIAG 0xDC for %s failed, "
-				"return code: %d\n", ops->name, rc);
-		}
-	}
-	spin_unlock(&appldata_ops_lock);
-
-	unregister_hotcpu_notifier(&appldata_nb);
-
-	for_each_online_cpu(i)
-		appldata_offline_cpu(i);
-
-	appldata_timer_active = 0;
-
-	unregister_sysctl_table(appldata_sysctl_header);
-
-	destroy_workqueue(appldata_wq);
-	P_DEBUG("... module unloaded!\n");
-}
 /**************************** init / exit <END> ******************************/
 
 
 module_init(appldata_init);
-module_exit(appldata_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Gerald Schaefer");
 MODULE_DESCRIPTION("Linux-VM Monitor Stream, base infrastructure");
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
