From: akpm@linux-foundation.org
Subject: - freezer-make-kernel-threads-nonfreezable-by-default-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:14:51 -0700
Message-ID: <200707092114.l69LEp80012172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44822 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755017AbXGIVP1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:15:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ego@in.ibm.com, nigel@nigel.suspend2.net, oleg@tv-sign.ru, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     freezer-make-kernel-threads-nonfreezable-by-default-fix
has been removed from the -mm tree.  Its filename was
     freezer-make-kernel-threads-nonfreezable-by-default-fix.patch

This patch was dropped because it was folded into freezer-make-kernel-threads-nonfreezable-by-default.patch

------------------------------------------------------
Subject: freezer-make-kernel-threads-nonfreezable-by-default-fix
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "set_freezable" [drivers/media/video/msp3400.ko] undefined!

Make sure all affected fiels include freezer.h.  Might be overkill.

Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apm.c                 |    1 +
 drivers/block/loop.c                   |    1 +
 drivers/char/apm-emulation.c           |    1 +
 drivers/ieee1394/ieee1394_core.c       |    1 +
 drivers/media/video/msp3400-kthreads.c |    1 +
 drivers/mmc/card/queue.c               |    1 +
 drivers/mtd/mtd_blkdevs.c              |    1 +
 drivers/scsi/libsas/sas_scsi_host.c    |    1 +
 drivers/scsi/scsi_error.c              |    1 +
 kernel/exit.c                          |    1 +
 kernel/rcutorture.c                    |    1 +
 kernel/softirq.c                       |    1 +
 kernel/softlockup.c                    |    1 +
 net/bluetooth/bnep/core.c              |    1 +
 net/bluetooth/cmtp/core.c              |    1 +
 net/bluetooth/hidp/core.c              |    1 +
 net/bluetooth/rfcomm/core.c            |    1 +
 17 files changed, 17 insertions(+)

diff -puN arch/i386/kernel/apm.c~freezer-make-kernel-threads-nonfreezable-by-default-fix arch/i386/kernel/apm.c
--- a/arch/i386/kernel/apm.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/arch/i386/kernel/apm.c
@@ -222,6 +222,7 @@
 #include <linux/capability.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
+#include <linux/freezer.h>
 #include <linux/smp.h>
 #include <linux/dmi.h>
 #include <linux/suspend.h>
diff -puN drivers/block/loop.c~freezer-make-kernel-threads-nonfreezable-by-default-fix drivers/block/loop.c
--- a/drivers/block/loop.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/drivers/block/loop.c
@@ -68,6 +68,7 @@
 #include <linux/loop.h>
 #include <linux/compat.h>
 #include <linux/suspend.h>
+#include <linux/freezer.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>		/* for invalidate_bdev() */
 #include <linux/completion.h>
diff -puN drivers/char/apm-emulation.c~freezer-make-kernel-threads-nonfreezable-by-default-fix drivers/char/apm-emulation.c
--- a/drivers/char/apm-emulation.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/drivers/char/apm-emulation.c
@@ -20,6 +20,7 @@
 #include <linux/sched.h>
 #include <linux/pm.h>
 #include <linux/apm-emulation.h>
+#include <linux/freezer.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
diff -puN drivers/ieee1394/ieee1394_core.c~freezer-make-kernel-threads-nonfreezable-by-default-fix drivers/ieee1394/ieee1394_core.c
--- a/drivers/ieee1394/ieee1394_core.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/drivers/ieee1394/ieee1394_core.c
@@ -30,6 +30,7 @@
 #include <linux/moduleparam.h>
 #include <linux/bitops.h>
 #include <linux/kdev_t.h>
+#include <linux/freezer.h>
 #include <linux/suspend.h>
 #include <linux/kthread.h>
 #include <linux/preempt.h>
diff -puN drivers/media/video/msp3400-kthreads.c~freezer-make-kernel-threads-nonfreezable-by-default-fix drivers/media/video/msp3400-kthreads.c
--- a/drivers/media/video/msp3400-kthreads.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/drivers/media/video/msp3400-kthreads.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/freezer.h>
 #include <linux/videodev.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
diff -puN drivers/mmc/card/queue.c~freezer-make-kernel-threads-nonfreezable-by-default-fix drivers/mmc/card/queue.c
--- a/drivers/mmc/card/queue.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/drivers/mmc/card/queue.c
@@ -11,6 +11,7 @@
  */
 #include <linux/module.h>
 #include <linux/blkdev.h>
+#include <linux/freezer.h>
 #include <linux/kthread.h>
 
 #include <linux/mmc/card.h>
diff -puN drivers/mtd/mtd_blkdevs.c~freezer-make-kernel-threads-nonfreezable-by-default-fix drivers/mtd/mtd_blkdevs.c
--- a/drivers/mtd/mtd_blkdevs.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/drivers/mtd/mtd_blkdevs.c
@@ -16,6 +16,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
+#include <linux/freezer.h>
 #include <linux/spinlock.h>
 #include <linux/hdreg.h>
 #include <linux/init.h>
diff -puN drivers/scsi/libsas/sas_scsi_host.c~freezer-make-kernel-threads-nonfreezable-by-default-fix drivers/scsi/libsas/sas_scsi_host.c
--- a/drivers/scsi/libsas/sas_scsi_host.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/drivers/scsi/libsas/sas_scsi_host.c
@@ -40,6 +40,7 @@
 
 #include <linux/err.h>
 #include <linux/blkdev.h>
+#include <linux/freezer.h>
 #include <linux/scatterlist.h>
 
 /* ---------- SCSI Host glue ---------- */
diff -puN drivers/scsi/scsi_error.c~freezer-make-kernel-threads-nonfreezable-by-default-fix drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/drivers/scsi/scsi_error.c
@@ -19,6 +19,7 @@
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
diff -puN kernel/exit.c~freezer-make-kernel-threads-nonfreezable-by-default-fix kernel/exit.c
--- a/kernel/exit.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/kernel/exit.c
@@ -31,6 +31,7 @@
 #include <linux/mempolicy.h>
 #include <linux/taskstats_kern.h>
 #include <linux/delayacct.h>
+#include <linux/freezer.h>
 #include <linux/cpuset.h>
 #include <linux/syscalls.h>
 #include <linux/signal.h>
diff -puN kernel/rcutorture.c~freezer-make-kernel-threads-nonfreezable-by-default-fix kernel/rcutorture.c
--- a/kernel/rcutorture.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/kernel/rcutorture.c
@@ -40,6 +40,7 @@
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
+#include <linux/freezer.h>
 #include <linux/cpu.h>
 #include <linux/random.h>
 #include <linux/delay.h>
diff -puN kernel/softirq.c~freezer-make-kernel-threads-nonfreezable-by-default-fix kernel/softirq.c
--- a/kernel/softirq.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/kernel/softirq.c
@@ -14,6 +14,7 @@
 #include <linux/notifier.h>
 #include <linux/percpu.h>
 #include <linux/cpu.h>
+#include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/rcupdate.h>
 #include <linux/smp.h>
diff -puN kernel/softlockup.c~freezer-make-kernel-threads-nonfreezable-by-default-fix kernel/softlockup.c
--- a/kernel/softlockup.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/kernel/softlockup.c
@@ -10,6 +10,7 @@
 #include <linux/cpu.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/notifier.h>
 #include <linux/module.h>
diff -puN net/bluetooth/bnep/core.c~freezer-make-kernel-threads-nonfreezable-by-default-fix net/bluetooth/bnep/core.c
--- a/net/bluetooth/bnep/core.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/net/bluetooth/bnep/core.c
@@ -36,6 +36,7 @@
 #include <linux/signal.h>
 #include <linux/init.h>
 #include <linux/wait.h>
+#include <linux/freezer.h>
 #include <linux/errno.h>
 #include <linux/net.h>
 #include <net/sock.h>
diff -puN net/bluetooth/cmtp/core.c~freezer-make-kernel-threads-nonfreezable-by-default-fix net/bluetooth/cmtp/core.c
--- a/net/bluetooth/cmtp/core.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/net/bluetooth/cmtp/core.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/fcntl.h>
+#include <linux/freezer.h>
 #include <linux/skbuff.h>
 #include <linux/socket.h>
 #include <linux/ioctl.h>
diff -puN net/bluetooth/hidp/core.c~freezer-make-kernel-threads-nonfreezable-by-default-fix net/bluetooth/hidp/core.c
--- a/net/bluetooth/hidp/core.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/net/bluetooth/hidp/core.c
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
+#include <linux/freezer.h>
 #include <linux/fcntl.h>
 #include <linux/skbuff.h>
 #include <linux/socket.h>
diff -puN net/bluetooth/rfcomm/core.c~freezer-make-kernel-threads-nonfreezable-by-default-fix net/bluetooth/rfcomm/core.c
--- a/net/bluetooth/rfcomm/core.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/net/bluetooth/rfcomm/core.c
@@ -33,6 +33,7 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/init.h>
+#include <linux/freezer.h>
 #include <linux/wait.h>
 #include <linux/device.h>
 #include <linux/net.h>
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
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
fix-alpha-isa-support-fix.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers-fix.patch
pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
pm-introduce-hibernation-and-suspend-notifiers-fix-fix.patch
pm-disable-usermode-helper-before-hibernation-and-suspend-fix.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch
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
audit-add-tty-input-auditing-fix-2.patch
revert-vanishing-ioctl-handler-debugging.patch
binfmt_elf-warning-fix.patch
dirty_writeback_centisecs_handler-cleanup.patch
diskquota-32bit-quota-tools-on-64bit-architectures-fix-fix.patch
sys_time-speedup-build-fixes.patch
add-documentation-sysctl-ctl_unnumberedtxt.patch
sysctlc-add-text-telling-people-to-use-ctl_unnumbered.patch
hfs-refactor-ascii-to-unicode-conversion-routine-fix.patch
sprint_symbol-cleanup.patch
replace-obscure-constructs-in-fs-block_devc-fix.patch
bd_claim_by_disk-fix-warning.patch
uninline-check_signature.patch
uninline-check_signature-fix.patch
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
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix-fix.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix.patch
rtc-add-rtc-m41t80-driver-take-2-fix.patch
rtc-add-support-for-the-st-m48t59-rtc-vs-git-acpi.patch
rtc-add-support-for-the-st-m48t59-rtc-fix-3.patch
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
