From: akpm@linux-foundation.org
Subject: - revert-ide-ide-hpa-detect-from-resume.patch removed from -mm tree
Date: Mon, 11 Jun 2007 14:57:11 -0700
Message-ID: <200706112157.l5BLvB5D030095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751418AbXFKV6I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 17:58:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bzolnier@gmail.com, lt73@cs.drexel.edu, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     revert ide-ide-hpa-detect-from-resume
has been removed from the -mm tree.  Its filename was
     revert-ide-ide-hpa-detect-from-resume.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: revert ide-ide-hpa-detect-from-resume
From: Andrew Morton <akpm@linux-foundation.org>

Rafael said:

Here's the result of the search for the second patch that breaks resuming
from RAM on HPC nx6325 (x86_64):

ide-ide-hpa-detect-from-resume.patch

The symptom is that after the resume there's no backlight and the screen
apparently doesn't work, 100% of the time, although apart from this the system
seems to be functional.

The box doesn't even have an IDE HDD, but the DVD is handled by the atiixp
driver.

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Lee Trager <lt73@cs.drexel.edu>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-disk.c |   12 ------------
 drivers/ide/ide.c      |    9 +--------
 include/linux/ide.h    |    1 -
 3 files changed, 1 insertion(+), 21 deletions(-)

diff -puN drivers/ide/ide-disk.c~revert-ide-ide-hpa-detect-from-resume drivers/ide/ide-disk.c
--- a/drivers/ide/ide-disk.c~revert-ide-ide-hpa-detect-from-resume
+++ a/drivers/ide/ide-disk.c
@@ -1037,17 +1037,6 @@ static void ide_disk_release(struct kref
 
 static int ide_disk_probe(ide_drive_t *drive);
 
-/*
- * On HPA drives the capacity needs to be
- * reinitilized on resume otherwise the disk
- * can not be used and a hard reset is required
- */
-static void ide_disk_resume(ide_drive_t *drive)
-{
-	if (idedisk_supports_hpa(drive->id))
-		init_idedisk_capacity(drive);
-}
-
 static void ide_device_shutdown(ide_drive_t *drive)
 {
 #ifdef	CONFIG_ALPHA
@@ -1082,7 +1071,6 @@ static ide_driver_t idedisk_driver = {
 	},
 	.probe			= ide_disk_probe,
 	.remove			= ide_disk_remove,
-	.resume			= ide_disk_resume,
 	.shutdown		= ide_device_shutdown,
 	.version		= IDEDISK_VERSION,
 	.media			= ide_disk,
diff -puN drivers/ide/ide.c~revert-ide-ide-hpa-detect-from-resume drivers/ide/ide.c
--- a/drivers/ide/ide.c~revert-ide-ide-hpa-detect-from-resume
+++ a/drivers/ide/ide.c
@@ -1010,11 +1010,9 @@ static int generic_ide_resume(struct dev
 {
 	ide_drive_t *drive = dev->driver_data;
 	ide_hwif_t *hwif = HWIF(drive);
-	ide_driver_t *drv = to_ide_driver(dev->driver);
 	struct request rq;
 	struct request_pm_state rqpm;
 	ide_task_t args;
-	int err;
 
 	/* Call ACPI _STM only once */
 	if (!(drive->dn % 2))
@@ -1031,12 +1029,7 @@ static int generic_ide_resume(struct dev
 	rqpm.pm_step = ide_pm_state_start_resume;
 	rqpm.pm_state = PM_EVENT_ON;
 
-	err = ide_do_drive_cmd(drive, &rq, ide_head_wait);
-
-	if (err == 0 && drv && drv->resume)
-		drv->resume(drive);
-
-	return err;
+	return ide_do_drive_cmd(drive, &rq, ide_head_wait);
 }
 
 int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device *bdev,
diff -puN include/linux/ide.h~revert-ide-ide-hpa-detect-from-resume include/linux/ide.h
--- a/include/linux/ide.h~revert-ide-ide-hpa-detect-from-resume
+++ a/include/linux/ide.h
@@ -1002,7 +1002,6 @@ struct ide_driver_s {
 	struct device_driver	gen_driver;
 	int		(*probe)(ide_drive_t *);
 	void		(*remove)(ide_drive_t *);
-	void		(*resume)(ide_drive_t *);
 	void		(*shutdown)(ide_drive_t *);
 #ifdef CONFIG_IDE_PROC_FS
 	ide_proc_entry_t	*proc;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
document-acked-by.patch
x86_64-oops_begin-fix.patch
git-acpi.patch
git-acpi-tickh-needs-hrtimerh.patch
git-acpi-add-exports.patch
git-alsa.patch
ali5451-warning-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-avr32.patch
git-cpufreq-fix.patch
bugfix-cpufreq-in-combination-with-performance-governor-fix.patch
8xx-mpc885ads-pcmcia-support.patch
revert-gregkh-driver-block-device.patch
driver-core-check-return-code-of-sysfs_create_link.patch
git-dvb.patch
git-gfs2-nmw.patch
gfs2_lookupi-uninitialised-var-fix.patch
ib_umem_get-warning-fix.patch
git-input.patch
git-input-fixup.patch
serio_raw_read-warning-fix.patch
git-jfs-fix.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
led_colour_show-warning-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
revert-ide-ide-hpa-detect-from-resume.patch
ide_scan_pcibus-cehck-__pci_register_driver-return-value.patch
git-md-accel.patch
git-mips-fixup.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
git-ubi.patch
sundance-phy-address-form-0-only-for-device-id-0x0200-fix.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
git-selinux-allnoconfig-fix.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-scsi-misc.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch
git-unionfs.patch
fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
watchdog-driver-for-at32ap700x-devices-fix.patch
watchdog-driver-for-at32ap700x-devices-fix-2.patch
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
mmconfig-validate-against-acpi-motherboard-resources-fix.patch
mmconfig-validate-against-acpi-motherboard-resources-fix-2.patch
mmconfig-validate-against-acpi-motherboard-resources-fix-3.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86-64-calgary-introduce-chipset-specific-ops-fix.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2-fix.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions-fix.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
paravirt-helper-to-disable-all-io-space-fix.patch
i386-x86_64-trim-memory-not-covered-by-wb-mtrrs-fix.patch
i386-x86_64-trim-memory-not-covered-by-wb-mtrrs-fix-2.patch
i386-mtrr-clean-up-usage_table.patch
git-xfs.patch
git-cryptodev.patch
acpi-preserve-the-ebx-value-in-acpi_copy_wakeup_routine.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
change-zonelist-order-v6-zonelist-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
slub-support-slub_debug-on-by-default-tidy.patch
nick-broke-stuff.patch
nick-broke-more-stuff.patch
nick-broke-even-more-stuff.patch
nick-really-did-it-this-time.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
create-the-zone_movable-zone-fix-2.patch
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
udf-fix-possible-leakage-of-blocks-fix.patch
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
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
isdn-capi-warning-fixes.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-net-driver.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix-2.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer-fix.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
cfs-warning-fixes.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
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
reiser4.patch
reiser4-fix.patch
nick-broke-reiser4-too.patch
check_dirty_inode_list.patch
w1-build-fix.patch
