From: akpm@linux-foundation.org
Subject: + percpu_counters-use-cpu-notifiers.patch added to -mm tree
Date: Wed, 16 May 2007 16:29:58 -0700
Message-ID: <200705162329.l4GNTwTL012678@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48101 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934071AbXEPXcr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 May 2007 19:32:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, ego@in.ibm.com, oleg@tv-sign.ru


The patch titled
     percpu_counters(): use cpu notifiers
has been added to the -mm tree.  Its filename is
     percpu_counters-use-cpu-notifiers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: percpu_counters(): use cpu notifiers
From: Andrew Morton <akpm@linux-foundation.org>

per-cpu counters presently must iterate over all possible CPUs in the
exhaustive percpu_counter_sum().

But it can be much better to only iterate over the presently-online CPUs.  To
do this, we must arrange for an offlined CPU's count to be spilled into the
counter's central count.

We can do this for all percpu_counters in the machine by linking them into a
single global list and walking that list at CPU_DEAD time.

(I hope.  Might have race windows in which the percpu_counter_sum() count is
inaccurate?)

Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |   18 ++------
 lib/percpu_counter.c           |   66 +++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+), 12 deletions(-)

diff -puN include/linux/percpu_counter.h~percpu_counters-use-cpu-notifiers include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~percpu_counters-use-cpu-notifiers
+++ a/include/linux/percpu_counter.h
@@ -8,6 +8,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/smp.h>
+#include <linux/list.h>
 #include <linux/threads.h>
 #include <linux/percpu.h>
 #include <linux/types.h>
@@ -17,6 +18,9 @@
 struct percpu_counter {
 	spinlock_t lock;
 	s64 count;
+#ifdef CONFIG_HOTPLUG_CPU
+	struct list_head list;	/* All percpu_counters are on a list */
+#endif
 	s32 *counters;
 };
 
@@ -26,18 +30,8 @@ struct percpu_counter {
 #define FBC_BATCH	(NR_CPUS*4)
 #endif
 
-static inline void percpu_counter_init(struct percpu_counter *fbc, s64 amount)
-{
-	spin_lock_init(&fbc->lock);
-	fbc->count = amount;
-	fbc->counters = alloc_percpu(s32);
-}
-
-static inline void percpu_counter_destroy(struct percpu_counter *fbc)
-{
-	free_percpu(fbc->counters);
-}
-
+void percpu_counter_init(struct percpu_counter *fbc, s64 amount);
+void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_mod(struct percpu_counter *fbc, s32 amount);
 s64 percpu_counter_sum(struct percpu_counter *fbc);
 
diff -puN lib/percpu_counter.c~percpu_counters-use-cpu-notifiers lib/percpu_counter.c
--- a/lib/percpu_counter.c~percpu_counters-use-cpu-notifiers
+++ a/lib/percpu_counter.c
@@ -3,8 +3,17 @@
  */
 
 #include <linux/percpu_counter.h>
+#include <linux/notifier.h>
+#include <linux/mutex.h>
+#include <linux/init.h>
+#include <linux/cpu.h>
 #include <linux/module.h>
 
+#ifdef CONFIG_HOTPLUG_CPU
+static LIST_HEAD(percpu_counters);
+static DEFINE_MUTEX(percpu_counters_lock);
+#endif
+
 void percpu_counter_mod(struct percpu_counter *fbc, s32 amount)
 {
 	long count;
@@ -44,3 +53,60 @@ s64 percpu_counter_sum(struct percpu_cou
 	return ret < 0 ? 0 : ret;
 }
 EXPORT_SYMBOL(percpu_counter_sum);
+
+void percpu_counter_init(struct percpu_counter *fbc, s64 amount)
+{
+	spin_lock_init(&fbc->lock);
+	fbc->count = amount;
+	fbc->counters = alloc_percpu(s32);
+#ifdef CONFIG_HOTPLUG_CPU
+	mutex_lock(&percpu_counters_lock);
+	list_add(&fbc->list, &percpu_counters);
+	mutex_unlock(&percpu_counters_lock);
+#endif
+}
+EXPORT_SYMBOL(percpu_counter_init);
+
+void percpu_counter_destroy(struct percpu_counter *fbc)
+{
+	free_percpu(fbc->counters);
+#ifdef CONFIG_HOTPLUG_CPU
+	mutex_lock(&percpu_counters_lock);
+	list_del(&fbc->list);
+	mutex_unlock(&percpu_counters_lock);
+#endif
+}
+EXPORT_SYMBOL(percpu_counter_destroy);
+
+#ifdef CONFIG_HOTPLUG_CPU
+static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
+					unsigned long action, void *hcpu)
+{
+	unsigned int cpu;
+	struct percpu_counter *fbc;
+
+	if (action != CPU_DEAD)
+		return NOTIFY_OK;
+
+	cpu = (unsigned long)hcpu;
+	mutex_lock(&percpu_counters_lock);
+	list_for_each_entry(fbc, &percpu_counters, list) {
+		s32 *pcount;
+
+		spin_lock(&fbc->lock);
+		pcount = per_cpu_ptr(fbc->counters, cpu);
+		fbc->count += *pcount;
+		*pcount = 0;
+		spin_unlock(&fbc->lock);
+	}
+	mutex_unlock(&percpu_counters_lock);
+	return NOTIFY_OK;
+}
+
+static int __init percpu_counter_startup(void)
+{
+	hotcpu_notifier(percpu_counter_hotcpu_callback, 0);
+	return 0;
+}
+module_init(percpu_counter_startup);
+#endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
parport_pc-needs-dma-mappingh.patch
git-acpi-export-acpi_set_cstate_limit.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
fix-agk-dm-dm-io-fix-panic-on-large-request.patch
8xx-mpc885ads-pcmcia-support-fix.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
git-dvb.patch
git-dvb-fixup.patch
cinergyt2-fix-file-release-handler.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-leds.patch
git-leds-fixup.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
drivers-ata-correct-a-wrong-free-function-for-sata_nv-driver-fix.patch
ide-warning-fixes.patch
git-mips-fixup.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver-build-fix.patch
git-ubi.patch
git-ubi-fixup.patch
git-battery.patch
git-battery-warning-fix.patch
ds2760_battery-warning-fix.patch
git-nfs.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-ocfs2.patch
ocfs2-fix-type-borkage.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-wireless.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-fix-machine-rebooting-fix.patch
xfs-clean-up-shrinker-games.patch
pci-x-pci-express-read-control-interfaces-fix.patch
remove-slab_ctor_constructor-fix.patch
let-smp_call_function_single-return-ebusy-on-up-fix.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using-fix.patch
slub-fix-handling-of-oversized-slabs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
compat_core_sys_select-avoid-kmalloc0.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
check_dirty_inode_list.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
reiser4.patch
reiser4-fix.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
git-gccbug-fixup.patch
w1-build-fix.patch
