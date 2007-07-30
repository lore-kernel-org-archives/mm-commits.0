From: akpm@linux-foundation.org
Subject: + kernel-schedc-make-code-static.patch added to -mm tree
Date: Mon, 30 Jul 2007 15:47:26 -0700
Message-ID: <200707302247.l6UMlQ9W002507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49798 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756116AbXG3WsU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 18:48:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, mingo@elte.hu


The patch titled
     kernel/sched.c: make code static
has been added to the -mm tree.  Its filename is
     kernel-schedc-make-code-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -6288,7 +6288,7 @@ static void detach_destroy_domains(const
 }
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-int arch_reinit_sched_domains(void)
+static int arch_reinit_sched_domains(void)
 {
 	int err;
 
@@ -6317,24 +6317,6 @@ static ssize_t sched_power_savings_store
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
@@ -6345,8 +6327,8 @@ static ssize_t sched_mc_power_savings_st
 {
 	return sched_power_savings_store(buf, count, 0);
 }
-SYSDEV_ATTR(sched_mc_power_savings, 0644, sched_mc_power_savings_show,
-	    sched_mc_power_savings_store);
+static SYSDEV_ATTR(sched_mc_power_savings, 0644, sched_mc_power_savings_show,
+		   sched_mc_power_savings_store);
 #endif
 
 #ifdef CONFIG_SCHED_SMT
@@ -6359,8 +6341,26 @@ static ssize_t sched_smt_power_savings_s
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
slow-down-printk-during-boot-fix-3.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
make-struct-sony_nc_ids-static.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
export-v4l2_int_device_unregister.patch
drivers-i2c-i2c-corec-make-code-static.patch
git-hwmon.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
mtd-onenand_simc-make-struct-info-static.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
fore200e_param_bs_queue-must-be-__devinit.patch
make-pktgencget_ipsec_sa-static-and-non-inline.patch
make-nf_ct_ipv6_skip_exthdr-static.patch
net-unix-af_unixc-make-code-static.patch
backlight-make-2-structs-static.patch
git-ocfs2.patch
cpqphp_ctrlc-remove-dead-code.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
make-scsi_host_link_pm_policy-static.patch
git-unionfs.patch
drivers-usb-serial-sierrac-make-3-functions-static.patch
fix-gregkh-usb-usb-add-the-concept-of-default-authorization-to-usb-hosts.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
acpi_ec_remove-fix-use-after-free.patch
acpi_battery_add-use-after-free.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
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
drivers-scsi-scsi_errorc-should-include.patch
include-linux-kbuild-remove-duplicate-entries.patch
parisc-extern-inline-static-inline.patch
remove-fs-jffs2-ioctlc.patch
drivers-scsi-constantsc-make-2-functions-static.patch
fs-afs-possible-cleanups.patch
ppc-remove-apus-support.patch
lib-ioremapc-should-include-linux-ioh.patch
i386-no-need-to-make-enable_cpu_hotplug-a-variable.patch
arch-i386-mm-discontigc-make-some-variables-static.patch
ipc-shmc-make-2-functions-static.patch
kernel-schedc-make-code-static.patch
mm-shmemc-make-3-functions-static.patch
mm-migratec-cleanups.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch
