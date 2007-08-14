From: akpm@linux-foundation.org
Subject: - kernel-schedc-make-code-static.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:13:25 -0700
Message-ID: <200708141913.l7EJDPD6016503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54691 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762277AbXHNTbu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:31:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kernel/sched.c: make code static
has been removed from the -mm tree.  Its filename was
     kernel-schedc-make-code-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel/sched.c: make code static
From: Adrian Bunk <bunk@stusta.de>

This patch makes the following needlessly global code static:

- arch_reinit_sched_domains()
- struct attr_sched_mc_power_savings
- struct attr_sched_smt_power_savings

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h |    2 -
 kernel/sched.c      |   46 +++++++++++++++++++++---------------------
 2 files changed, 23 insertions(+), 25 deletions(-)

diff -puN include/linux/cpu.h~kernel-schedc-make-code-static include/linux/cpu.h
--- a/include/linux/cpu.h~kernel-schedc-make-code-static
+++ a/include/linux/cpu.h
@@ -41,8 +41,6 @@ extern void cpu_remove_sysdev_attr(struc
 extern int cpu_add_sysdev_attr_group(struct attribute_group *attrs);
 extern void cpu_remove_sysdev_attr_group(struct attribute_group *attrs);
 
-extern struct sysdev_attribute attr_sched_mc_power_savings;
-extern struct sysdev_attribute attr_sched_smt_power_savings;
 extern int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls);
 
 #ifdef CONFIG_HOTPLUG_CPU
diff -puN kernel/sched.c~kernel-schedc-make-code-static kernel/sched.c
--- a/kernel/sched.c~kernel-schedc-make-code-static
+++ a/kernel/sched.c
@@ -6317,7 +6317,7 @@ int partition_sched_domains(cpumask_t *p
 }
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-int arch_reinit_sched_domains(void)
+static int arch_reinit_sched_domains(void)
 {
 	int err;
 
@@ -6346,24 +6346,6 @@ static ssize_t sched_power_savings_store
 	return ret ? ret : count;
 }
 
-int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
-{
-	int err = 0;
-
-#ifdef CONFIG_SCHED_SMT
-	if (smt_capable())
-		err = sysfs_create_file(&cls->kset.kobj,
-					&attr_sched_smt_power_savings.attr);
-#endif
-#ifdef CONFIG_SCHED_MC
-	if (!err && mc_capable())
-		err = sysfs_create_file(&cls->kset.kobj,
-					&attr_sched_mc_power_savings.attr);
-#endif
-	return err;
-}
-#endif
-
 #ifdef CONFIG_SCHED_MC
 static ssize_t sched_mc_power_savings_show(struct sys_device *dev, char *page)
 {
@@ -6374,8 +6356,8 @@ static ssize_t sched_mc_power_savings_st
 {
 	return sched_power_savings_store(buf, count, 0);
 }
-SYSDEV_ATTR(sched_mc_power_savings, 0644, sched_mc_power_savings_show,
-	    sched_mc_power_savings_store);
+static SYSDEV_ATTR(sched_mc_power_savings, 0644, sched_mc_power_savings_show,
+		   sched_mc_power_savings_store);
 #endif
 
 #ifdef CONFIG_SCHED_SMT
@@ -6388,8 +6370,26 @@ static ssize_t sched_smt_power_savings_s
 {
 	return sched_power_savings_store(buf, count, 1);
 }
-SYSDEV_ATTR(sched_smt_power_savings, 0644, sched_smt_power_savings_show,
-	    sched_smt_power_savings_store);
+static SYSDEV_ATTR(sched_smt_power_savings, 0644, sched_smt_power_savings_show,
+		   sched_smt_power_savings_store);
+#endif
+
+int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
+{
+	int err = 0;
+
+#ifdef CONFIG_SCHED_SMT
+	if (smt_capable())
+		err = sysfs_create_file(&cls->kset.kobj,
+					&attr_sched_smt_power_savings.attr);
+#endif
+#ifdef CONFIG_SCHED_MC
+	if (!err && mc_capable())
+		err = sysfs_create_file(&cls->kset.kobj,
+					&attr_sched_mc_power_savings.attr);
+#endif
+	return err;
+}
 #endif
 
 /*
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
kernel-auditscc-fix-an-off-by-one.patch
slow-down-printk-during-boot-fix-3.patch
git-acpi.patch
git-alsa.patch
allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
include-linux-kbuild-remove-duplicate-entries.patch
git-kvm.patch
git-mmc.patch
git-mtd.patch
remove-fs-jffs2-ioctlc.patch
git-netdev-all.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
git-backlight.patch
parisc-extern-inline-static-inline.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
drivers-scsi-scsi_errorc-should-include.patch
drivers-scsi-constantsc-make-2-functions-static.patch
git-unionfs.patch
git-v9fs.patch
git-ipwireless_cs.patch
git-cryptodev.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
mm-shmemc-make-3-functions-static.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch
cleanup-arch-alpha-makefile.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
fs-nfsd-exportc-make-3-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
unexport-fb_prepare_logo.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
