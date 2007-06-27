From: akpm@linux-foundation.org
Subject: + rtc-add-support-for-the-st-m48t59-rtc-fix-3.patch added to -mm tree
Date: Wed, 27 Jun 2007 02:30:03 -0700
Message-ID: <200706270934.l5R9Y2LA014289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57465 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206AbXF0Jen (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 05:34:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, rongkai.zhan@windriver.com


The patch titled
     rtc-add-support-for-the-st-m48t59-rtc-fix-3
has been added to the -mm tree.  Its filename is
     rtc-add-support-for-the-st-m48t59-rtc-fix-3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc-add-support-for-the-st-m48t59-rtc-fix-3
From: Andrew Morton <akpm@linux-foundation.org>

x86_64:

drivers/rtc/rtc-m48t59.c:77:47: error: macro "readb" passed 2 arguments, but takes just 1
drivers/rtc/rtc-m48t59.c:77:47: error: macro "writeb" passed 3 arguments, but takes just 2
drivers/rtc/rtc-m48t59.c: In function 'm48t59_rtc_read_time':
drivers/rtc/rtc-m48t59.c:77: warning: statement with no effect
drivers/rtc/rtc-m48t59.c:79:48: error: macro "readb" passed 2 arguments, but takes just 1
drivers/rtc/rtc-m48t59.c:79: error: invalid operands to binary &
drivers/rtc/rtc-m48t59.c:79: error: invalid operands to binary >>
drivers/rtc/rtc-m48t59.c:81:48: error: macro "readb" passed 2 arguments, but takes just 1
drivers/rtc/rtc-m48t59.c:81: error: invalid operands to binary &
drivers/rtc/rtc-m48t59.c:81: error: invalid operands to binary >>
drivers/rtc/rtc-m48t59.c:82:48: error: macro "readb" passed 2 arguments, but takes just 1

etc..

btw, macros which assume the presence of a particularly-named local variable
are evil.  Please just don't do it.

Instead of

#define M48T59_READ(reg)	pdata->read_byte(dev, reg)

please do

static inline u8 m48t59_read(m48t59_plat_data *pdata, struct device *dev,
				int reg)
{
	return pdata->read_byte(dev, reg);
}

ie: write your code in C, not in cpp..


Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Mark Zhan <rongkai.zhan@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m48t59.c   |   14 +++++++-------
 include/linux/rtc/m48t59.h |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-m48t59.c~rtc-add-support-for-the-st-m48t59-rtc-fix-3 drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~rtc-add-support-for-the-st-m48t59-rtc-fix-3
+++ a/drivers/rtc/rtc-m48t59.c
@@ -24,8 +24,8 @@
 #define NO_IRQ	(-1)
 #endif
 
-#define M48T59_READ(reg)	pdata->readb(dev, reg)
-#define M48T59_WRITE(val, reg)	pdata->writeb(dev, reg, val)
+#define M48T59_READ(reg)	pdata->read_byte(dev, reg)
+#define M48T59_WRITE(val, reg)	pdata->write_byte(dev, reg, val)
 
 #define M48T59_SET_BITS(mask, reg)	\
 	M48T59_WRITE((M48T59_READ(reg) | (mask)), (reg))
@@ -379,7 +379,7 @@ static int __devinit m48t59_rtc_probe(st
 		/* If we are I/O-mapped, the platform should provide
 		 * the operations accessing chip registers.
 		 */
-		if (!pdata || !pdata->writeb || !pdata->readb)
+		if (!pdata || !pdata->write_byte || !pdata->read_byte)
 			return -EINVAL;
 	} else if (res->flags & IORESOURCE_MEM) {
 		/* we are memory-mapped */
@@ -392,10 +392,10 @@ static int __devinit m48t59_rtc_probe(st
 		}
 
 		/* Try to use the generic memory read/write ops */
-		if (!pdata->writeb)
-			pdata->writeb = m48t59_mem_writeb;
-		if (!pdata->readb)
-			pdata->readb = m48t59_mem_readb;
+		if (!pdata->write_byte)
+			pdata->write_byte = m48t59_mem_writeb;
+		if (!pdata->read_byte)
+			pdata->read_byte = m48t59_mem_readb;
 	}
 
 	m48t59 = kzalloc(sizeof(*m48t59), GFP_KERNEL);
diff -puN include/linux/rtc/m48t59.h~rtc-add-support-for-the-st-m48t59-rtc-fix-3 include/linux/rtc/m48t59.h
--- a/include/linux/rtc/m48t59.h~rtc-add-support-for-the-st-m48t59-rtc-fix-3
+++ a/include/linux/rtc/m48t59.h
@@ -50,8 +50,8 @@ struct m48t59_plat_data {
 	/* The method to access M48T59 registers,
 	 * NOTE: The 'ofs' should be 0x00~0x1fff
 	 */
-	void (*writeb)(struct device *dev, u32 ofs, u8 val);
-	unsigned char (*readb)(struct device *dev, u32 ofs);
+	void (*write_byte)(struct device *dev, u32 ofs, u8 val);
+	unsigned char (*read_byte)(struct device *dev, u32 ofs);
 };
 
 #endif /* _LINUX_RTC_M48T59_H_ */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

smsc-ircc2-skip-preconfiguration-for-pnp-devices.patch
ioatdma-fix-section-mismatches.patch
ext2-fix-return-of-uninitialised-variable.patch
git-acpi.patch
git-acpi-fixup.patch
git-acpi-tickh-needs-hrtimerh.patch
git-acpi-add-exports.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-avr32.patch
git-cpufreq-fix.patch
bugfix-cpufreq-in-combination-with-performance-governor-fix.patch
8xx-mpc885ads-pcmcia-support.patch
revert-gregkh-driver-block-device.patch
driver-core-check-return-code-of-sysfs_create_link.patch
revert-saa7134-fix-thread-shutdown-handling.patch
git-dvb.patch
git-gfs2-nmw.patch
git-infiniband.patch
git-input.patch
serio_raw_read-warning-fix.patch
tsdev-fix-broken-usecto-millisecs-conversion.patch
git-kbuild.patch
git-kbuild-fixup.patch
git-kvm.patch
git-leds.patch
led_colour_show-warning-fix.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
ide_scan_pcibus-cehck-__pci_register_driver-return-value.patch
git-md-accel.patch
git-mips-fixup.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
git-ubi.patch
git-netdev-all.patch
sundance-phy-address-form-0-only-for-device-id-0x0200-fix.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-battery-vs-git-acpi.patch
git-ioat-vs-git-md-accel.patch
git-nfs-server-cluster-locking-api-fixup.patch
pa-risc-use-page-allocator-instead-of-slab-allocator-fix.patch
git-selinux.patch
git-selinux-fixup.patch
revert-gregkh-pci-pci_bridge-device.patch
pci-x-pci-express-read-control-interfaces-fix.patch
revert-acpi-change-for-scsi.patch
git-scsi-misc.patch
restore-acpi-change-for-scsi.patch
git-scsi-misc-vs-greg-sysfs-stuff.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch
git-unionfs.patch
fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
git-watchdog.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
revert-x86_64-mm-verify-cpu-rename.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-sched-clock-share.patch
fix-x86_64-mm-add-common-orderly_poweroff.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
mmconfig-validate-against-acpi-motherboard-resources-fix.patch
mmconfig-validate-against-acpi-motherboard-resources-fix-2.patch
mmconfig-validate-against-acpi-motherboard-resources-fix-3.patch
mmconfig-validate-against-acpi-motherboard-resources-fix-2-3.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86-64-calgary-introduce-chipset-specific-ops-fix.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2-fix.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions-fix.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
paravirt-helper-to-disable-all-io-space-fix.patch
i386-show-unhandled-signals-fix.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh-fix.patch
i386-add-cpu_relax-to-cmos_lock-fix.patch
highres-improve-debug-output-fix.patch
x86_64-flush_tlb_kernel_range-warning-fix.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
git-newsetup-fixup.patch
git-xfs.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
git-kgdb-fixup.patch
kgdb-warning-fix.patch
kgdb-kconfig-fix.patch
kgdb-use-new-style-interrupt-flags.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
change-zonelist-order-v6-zonelist-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
slub-support-slub_debug-on-by-default-tidy.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
create-the-zone_movable-zone-fix-2.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-3.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface.patch
mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
slab-allocators-cleanup-zeroing-allocations-fix.patch
slab-allocators-cleanup-zeroing-allocations-fix-2.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers-fix.patch
pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
pm-introduce-hibernation-and-suspend-notifiers-fix-fix.patch
pm-disable-usermode-helper-before-hibernation-and-suspend-fix.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage-fix.patch
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
improve-behaviour-of-spurious-irq-detect-fix.patch
revert-vanishing-ioctl-handler-debugging.patch
binfmt_elf-warning-fix.patch
dirty_writeback_centisecs_handler-cleanup.patch
blink-only-blink-when-parameter-is-set-fix.patch
add-documentation-sysctl-ctl_unnumberedtxt.patch
sysctlc-add-text-telling-people-to-use-ctl_unnumbered.patch
hfs-refactor-ascii-to-unicode-conversion-routine-fix.patch
sprint_symbol-cleanup.patch
replace-obscure-constructs-in-fs-block_devc-fix.patch
bd_claim_by_disk-fix-warning.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
spi-master-driver-for-xilinx-virtex-fix.patch
isdn-capi-warning-fixes.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix.patch
rtc-add-rtc-m41t80-driver-take-2-fix.patch
rtc-add-support-for-the-st-m48t59-rtc-vs-git-acpi.patch
rtc-add-support-for-the-st-m48t59-rtc-fix-3.patch
rtc-driver-for-ds1216-chips-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-net-driver.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix-2.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer-fix.patch
intel-iommu-pci-generic-helper-function-fix.patch
intel-iommu-iova-allocation-and-management-routines-fix.patch
intel-iommu-intel-iommu-driver-fix.patch
intel-iommu-intel-iommu-driver-fix-2.patch
intel-iommu-iommu-floppy-workaround-fix.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
cfs-warning-fixes.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
containersv10-basic-container-framework-fix.patch
containersv10-basic-container-framework-fix-2.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
add-containerstats-v3-fix.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
lockstat-core-infrastructure-fix-fix-fix.patch
lockdep-various-fixes-checkpatch.patch
lockstat-measure-lock-bouncing-checkpatch.patch
reiser4.patch
reiser4-fix.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
