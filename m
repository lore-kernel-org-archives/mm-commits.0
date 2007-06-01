From: akpm@linux-foundation.org
Subject: - x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3-fix.patch removed from -mm tree
Date: Fri, 01 Jun 2007 00:41:51 -0700
Message-ID: <200706010741.l517fsNX005261@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453AbXFAHmE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 03:42:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, asit.k.mallick@intel.com, ebiederm@xmission.com, keith.packard@intel.com, mingo@elte.hu, nanhai.zou@intel.com, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3-fix
has been removed from the -mm tree.  Its filename was
     x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3-fix.patch

This patch was dropped because it was folded into x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch

------------------------------------------------------
Subject: x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andi Kleen <ak@suse.de>
Cc: Asit Mallick <asit.k.mallick@intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Keith Packard <keith.packard@intel.com>
Cc: Nanhai Zou <nanhai.zou@intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/io_apic.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/kernel/io_apic.c~x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3-fix arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3-fix
+++ a/arch/x86_64/kernel/io_apic.c
@@ -1447,13 +1447,13 @@ static void ack_apic_level(unsigned int 
 	if (unlikely(do_unmask_irq)) {
 		/* Only migrate the irq if the ack has been received.
 		 *
-		 * On rare occaions the broadcast level triggered ack gets
+		 * On rare occasions the broadcast level triggered ack gets
 		 * delayed going to ioapics, and if we reprogram the
 		 * vector while Remote IRR is still the irq will never
 		 * fire again.
 		 *
 		 * To prevent this scenario we read the Remote IRR bit
-		 * of the ioapic.  This has two affects.
+		 * of the ioapic.  This has two effects.
 		 * - On any sane system the read of the ioapic will
 		 *   flush writes (and acks) going to the ioapic from
 		 *   this cpu.
@@ -1468,8 +1468,8 @@ static void ack_apic_level(unsigned int 
 		 *
 		 * However there appears to be no other way to plug
 		 * this race, so if the Remote IRR bit is not
-		 * accurate and causing problems it is a hardware bug
-		 * and you can go talk chipset vendor about it.
+		 * accurate and is causing problems then it is a hardware bug
+		 * and you can go talk to the chipset vendor about it.
 		 */
 		if (!io_apic_level_ack_pending(irq))
 			move_masked_irq(irq);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
potential-parse-error-in-ifdef.patch
potential-parse-error-in-ifdef-update.patch
alpha-support-graphics-on-non-zero-pci-domains.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
git-acpi.patch
git-acpi-export-acpi_set_cstate_limit.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-avr32.patch
git-cpufreq-fix.patch
8xx-mpc885ads-pcmcia-support.patch
fix-gregkh-driver-dmi-based-module-autoloading.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
driver-core-check-return-code-of-sysfs_create_link.patch
git-dvb.patch
git-gfs2-nmw.patch
git-input.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
git-mips-fixup.patch
git-mtd.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
git-ubi.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-pciseg.patch
git-scsi-misc.patch
git-scsi-rc-fixes.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch
git-unionfs.patch
fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
git-watchdog.patch
git-wireless.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
revert-x86_64-mm-allocate-sparsemem-memmap-above-4g-on-x86_64.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-sched-clock-share.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3-fix.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3-fix-fix.patch
git-xfs.patch
git-cryptodev.patch
git-xtensa.patch
fix-possible-leakage-of-blocks-in-udf-tidy.patch
aacraid-fix-shutdown-handler-to-also-disable-interrupts.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
change-zonelist-order-v6-zonelist-fix.patch
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
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty-fix.patch
mpu401-warning-fixes.patch
procfs-directory-entry-cleanup-fix.patch
vdso-print-fatal-signals.patch
reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
rd-remove-ramdisk_set_page_dirty-fix.patch
document-acked-by.patch
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
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix-2.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer-fix.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
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
check_dirty_inode_list.patch
w1-build-fix.patch
