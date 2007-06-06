From: akpm@linux-foundation.org
Subject: - revert-slub-use-ilog2-instead-of-series-of-constant-comparisons.patch removed from -mm tree
Date: Wed, 06 Jun 2007 10:21:18 -0700
Message-ID: <200706061721.l56HLI4Q002247@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52716 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755435AbXFFRV4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 13:21:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     revert slub-use-ilog2-instead-of-series-of-constant-comparisons
has been removed from the -mm tree.  Its filename was
     revert-slub-use-ilog2-instead-of-series-of-constant-comparisons.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: revert slub-use-ilog2-instead-of-series-of-constant-comparisons
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |   61 +++++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 16 deletions(-)

diff -puN include/linux/slub_def.h~revert-slub-use-ilog2-instead-of-series-of-constant-comparisons include/linux/slub_def.h
--- a/include/linux/slub_def.h~revert-slub-use-ilog2-instead-of-series-of-constant-comparisons
+++ a/include/linux/slub_def.h
@@ -10,7 +10,6 @@
 #include <linux/gfp.h>
 #include <linux/workqueue.h>
 #include <linux/kobject.h>
-#include <linux/log2.h>
 
 struct kmem_cache_node {
 	spinlock_t list_lock;	/* Protect partial list and nr_partial */
@@ -59,8 +58,6 @@ struct kmem_cache {
  */
 #define KMALLOC_SHIFT_LOW 3
 
-#define KMALLOC_MIN_SIZE (1UL << KMALLOC_SHIFT_LOW)
-
 /*
  * We keep the general caches in an array of slab caches that are used for
  * 2^x bytes of allocations.
@@ -68,9 +65,8 @@ struct kmem_cache {
 extern struct kmem_cache kmalloc_caches[KMALLOC_SHIFT_HIGH + 1];
 
 /*
- * Determine the kmalloc array index given the object size.
- *
- * Return -1 if the object size is not supported.
+ * Sorry that the following has to be that ugly but some versions of GCC
+ * have trouble with constant propagation and loops.
  */
 static inline int kmalloc_index(size_t size)
 {
@@ -80,18 +76,42 @@ static inline int kmalloc_index(size_t s
 	if (size > KMALLOC_MAX_SIZE)
 		return -1;
 
-	if (size <= KMALLOC_MIN_SIZE)
-		return KMALLOC_SHIFT_LOW;
-
-	/*
-	 * We map the non power of two slabs to the unused
-	 * log2 values in the kmalloc array.
-	 */
 	if (size > 64 && size <= 96)
 		return 1;
 	if (size > 128 && size <= 192)
 		return 2;
-	return ilog2(size - 1) + 1;
+	if (size <=          8) return 3;
+	if (size <=         16) return 4;
+	if (size <=         32) return 5;
+	if (size <=         64) return 6;
+	if (size <=        128) return 7;
+	if (size <=        256) return 8;
+	if (size <=        512) return 9;
+	if (size <=       1024) return 10;
+	if (size <=   2 * 1024) return 11;
+	if (size <=   4 * 1024) return 12;
+	if (size <=   8 * 1024) return 13;
+	if (size <=  16 * 1024) return 14;
+	if (size <=  32 * 1024) return 15;
+	if (size <=  64 * 1024) return 16;
+	if (size <= 128 * 1024) return 17;
+	if (size <= 256 * 1024) return 18;
+	if (size <=  512 * 1024) return 19;
+	if (size <= 1024 * 1024) return 20;
+	if (size <=  2 * 1024 * 1024) return 21;
+	if (size <=  4 * 1024 * 1024) return 22;
+	if (size <=  8 * 1024 * 1024) return 23;
+	if (size <= 16 * 1024 * 1024) return 24;
+	if (size <= 32 * 1024 * 1024) return 25;
+	return -1;
+
+/*
+ * What we really wanted to do and cannot do because of compiler issues is:
+ *	int i;
+ *	for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++)
+ *		if (size <= (1 << i))
+ *			return i;
+ */
 }
 
 /*
@@ -108,9 +128,18 @@ static inline struct kmem_cache *kmalloc
 		return NULL;
 
 	/*
-	 * If this triggers then the amount of memory requested was too large.
+	 * This function only gets expanded if __builtin_constant_p(size), so
+	 * testing it here shouldn't be needed.  But some versions of gcc need
+	 * help.
 	 */
-	BUG_ON(index < 0);
+	if (__builtin_constant_p(size) && index < 0) {
+		/*
+		 * Generate a link failure. Would be great if we could
+		 * do something to stop the compile here.
+		 */
+		extern void __kmalloc_size_too_large(void);
+		__kmalloc_size_too_large();
+	}
 	return &kmalloc_caches[index];
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

document-acked-by.patch
git-acpi.patch
git-acpi-tickh-needs-hrtimerh.patch
git-acpi-add-exports.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-avr32.patch
git-cpufreq-fix.patch
bugfix-cpufreq-in-combination-with-performance-governor-fix.patch
8xx-mpc885ads-pcmcia-support.patch
driver-core-check-return-code-of-sysfs_create_link.patch
git-dvb.patch
git-gfs2-nmw.patch
git-input.patch
git-input-fixup.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
git-md-accel.patch
git-md-accel-fixup.patch
git-mips-fixup.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
git-ubi.patch
sundance-phy-address-form-0-only-for-device-id-0x0200-fix.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-scsi-misc.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch
git-unionfs.patch
fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
git-wireless.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
revert-x86_64-mm-verify-cpu-rename.patch
revert-x86_64-mm-allocate-sparsemem-memmap-above-4g-on-x86_64.patch
revert-x86_64-mm-cpa-cache-flush.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-sched-clock-share.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86-64-calgary-introduce-chipset-specific-ops-fix.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2-fix.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions-fix.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
paravirt-helper-to-disable-all-io-space-fix.patch
git-xfs.patch
git-cryptodev.patch
git-xtensa.patch
acpi-preserve-the-ebx-value-in-acpi_copy_wakeup_routine.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
change-zonelist-order-v6-zonelist-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
slub-support-slub_debug-on-by-default-tidy.patch
numa-mempolicy-allow-tunable-policy-for-system-init-fix.patch
nick-broke-stuff.patch
nick-broke-more-stuff.patch
nick-broke-even-more-stuff.patch
nick-really-did-it-this-time.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers-fix.patch
pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
pm-introduce-hibernation-and-suspend-notifiers-fix-fix.patch
pm-disable-usermode-helper-before-hibernation-and-suspend-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
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
mpu401-warning-fixes.patch
procfs-directory-entry-cleanup-fix.patch
vdso-print-fatal-signals.patch
reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
o_cloexec-for-scm_rights-fix.patch
o_cloexec-for-scm_rights-fix-2.patch
atmel_serial-fix-break-handling.patch
lib-add-idr_for_each-fix.patch
ext3-ext4-orphan-list-check-on-destroy_inode-fix.patch
taskstats-add-context-switch-counters-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
lguest-the-net-driver-include-fix.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix-2.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer-fix.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
cfs-warning-fixes.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
reiser4.patch
reiser4-fix.patch
nick-broke-reiser4-too.patch
check_dirty_inode_list.patch
w1-build-fix.patch
revert-slub-use-ilog2-instead-of-series-of-constant-comparisons.patch
