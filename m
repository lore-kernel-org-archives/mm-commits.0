From: akpm@linux-foundation.org
Subject: - rtc-add-support-for-the-st-m48t59-rtc-fix-3.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:39:40 -0700
Message-ID: <200707092339.l69NdeB1020725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39222 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758643AbXGIXjw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:39:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, rongkai.zhan@windriver.com, mm-commits@vger.kernel.org


The patch titled
     rtc-add-support-for-the-st-m48t59-rtc-fix-3
has been removed from the -mm tree.  Its filename was
     rtc-add-support-for-the-st-m48t59-rtc-fix-3.patch

This patch was dropped because it was folded into rtc-add-support-for-the-st-m48t59-rtc.patch

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

git-acpi.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-avr32.patch
git-cpufreq-fix.patch
8xx-mpc885ads-pcmcia-support.patch
revert-gregkh-driver-block-device.patch
driver-core-check-return-code-of-sysfs_create_link.patch
revert-saa7134-fix-thread-shutdown-handling.patch
git-dvb.patch
git-dvb-saa7134-tvaudio-fix.patch
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
git-md-accel.patch
git-mips-fixup.patch
git-mtd.patch
mtd-onenand-build-fix.patch
git-ubi.patch
git-netdev-all.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-battery-vs-git-acpi.patch
git-ioat-vs-git-md-accel.patch
revert-gregkh-pci-pci_bridge-device.patch
fix-gregkh-pci-pci-syscallc-switch-to-refcounting-api.patch
pci-x-pci-express-read-control-interfaces-fix.patch
revert-acpi-change-for-scsi.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
restore-acpi-change-for-scsi.patch
git-scsi-misc-vs-greg-sysfs-stuff.patch
aacraid-rename-check_reset.patch
git-scsi-target-fixup.patch
splicec-revert-git-selinux-changes-so-that-git-block-will-apply.patch
git-block-fixup.patch
git-unionfs.patch
git-block-vs-git-unionfs.patch
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
mmconfig-validate-against-acpi-motherboard-resources.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86-64-calgary-introduce-chipset-specific-ops.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
paravirt-helper-to-disable-all-io-space-fix.patch
i386-show-unhandled-signals.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
i386-add-cpu_relax-to-cmos_lock.patch
x86_64-flush_tlb_kernel_range-warning-fix.patch
x86_64-add-ioapic-nmi-support.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
x86_64-get-mp_bus_to_node-as-early.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
git-newsetup-fixup.patch
git-xfs.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
git-kgdb-fixup.patch
kgdb-warning-fix.patch
kgdb-kconfig-fix.patch
kgdb-use-new-style-interrupt-flags.patch
kgdb-section-fix.patch
kgdb_skipexception-warning-fix.patch
kgdb-ia64-fixes.patch
kgdb-bust-on-ia64.patch
kgdb-build-fix-2.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
change-zonelist-order-zonelist-order-selection-logic.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
slub-support-slub_debug-on-by-default.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
fix-alpha-isa-support.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
fix-rmmod-read-write-races-in-proc-entries.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time.patch
use-boot-based-time-for-process-start-time-and-boot-time.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
mpu401-warning-fixes.patch
vdso-print-fatal-signals.patch
o_cloexec-for-scm_rights.patch
atmel_serial-fix-break-handling.patch
lib-add-idr_for_each.patch
ext3-ext4-orphan-list-check-on-destroy_inode.patch
taskstats-add-context-switch-counters.patch
improve-behaviour-of-spurious-irq-detect.patch
audit-add-tty-input-auditing.patch
revert-vanishing-ioctl-handler-debugging.patch
binfmt_elf-warning-fix.patch
dirty_writeback_centisecs_handler-cleanup.patch
diskquota-32bit-quota-tools-on-64bit-architectures.patch
sys_time-speedup.patch
add-documentation-sysctl-ctl_unnumberedtxt.patch
sysctlc-add-text-telling-people-to-use-ctl_unnumbered.patch
hfs-refactor-ascii-to-unicode-conversion-routine.patch
sprint_symbol-cleanup.patch
replace-obscure-constructs-in-fs-block_devc.patch
bd_claim_by_disk-fix-warning.patch
uninline-check_signature.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support.patch
spi-master-driver-for-xilinx-virtex.patch
isdn-capi-warning-fixes.patch
i2o_cfg_passthru-cleanup.patch
knfsd-exportfs-add-exportfsh-header.patch
knfsd-exportfs-remove-iget-abuse.patch
nfsd-warning-fix.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
rtc-add-rtc-m41t80-driver-take-2.patch
rtc-add-support-for-the-st-m48t59-rtc.patch
rtc-add-support-for-the-st-m48t59-rtc-fix-3.patch
rtc-add-support-for-the-st-m48t59-rtc-vs-git-acpi.patch
rtc-driver-for-ds1216-chips-fix.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
lguest-the-host-code.patch
lguest-the-host-code-handle-dodgy-non-existent-tsc-host-code-fix.patch
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
git-block-vs-reiser4.patch
allow-page_owner-to-be-set-on-any-architecture-fix.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
