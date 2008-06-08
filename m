From: akpm@linux-foundation.org
Subject: - linux-next-fixup.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:35:37 -0700
Message-ID: <200806081935.m58JZbWQ017026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752831AbYFHTfs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:35:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david-b@pacbell.net, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     linux-next-fixup
has been removed from the -mm tree.  Its filename was
     linux-next-fixup.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Attempt to repair spi-fix-refcount-related-spidev-oops-on-rmmod versus
linux-next smashup.

Cc: David Brownell <david-b@pacbell.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spidev.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/spi/spidev.c~linux-next-fixup drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~linux-next-fixup
+++ a/drivers/spi/spidev.c
@@ -578,9 +578,10 @@ static int spidev_probe(struct spi_devic
 		struct device *dev;
 
 		spidev->devt = MKDEV(SPIDEV_MAJOR, minor);
-		dev = device_create(spidev_class, &spi->dev, spidev->devt,
-				"spidev%d.%d",
-				spi->master->bus_num, spi->chip_select);
+		dev = device_create_drvdata(spidev_class, &spi->dev,
+					spidev->devt, spidev,
+					"spidev%d.%d",
+					spi->master->bus_num, spi->chip_select);
 		status = IS_ERR(dev) ? PTR_ERR(dev) : 0;
 	} else {
 		dev_dbg(&spi->dev, "no minor number available!\n");
@@ -588,7 +589,6 @@ static int spidev_probe(struct spi_devic
 	}
 	if (status == 0) {
 		set_bit(minor, minors);
-		spi_set_drvdata(spi, spidev);
 		list_add(&spidev->device_entry, &device_list);
 	}
 	mutex_unlock(&device_list_lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
linux-next-fixup.patch
linux-next-rtc-fix.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
kvm-is-busted-on-ia64.patch
drivers-net-usb-kawethc-fix-printk-warning.patch
mtd-unbork.patch
revert-x86-remove-the-static-256k-node_to_cpumask_map.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
lguest-use-cpu-capability-accessors.patch
intel-agp-rewrite-gtt-on-resume-checkpatch-fixes.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2.patch
arch-powerpc-platforms-pseries-eeh_driverc-fix-warning.patch
arch-powerpc-platforms-pseries-eeh_driverc-fix-warning-checkpatch-fixes.patch
git-dvb.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hid.patch
git-input.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
git-kvm.patch
git-leds.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
git-mmc.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
drivers-mtd-devices-block2mtdc-suppress-warning.patch
git-ubifs.patch
git-net-next.patch
bluetooth-hci_bcspc-small-cleanups-api-users-fix.patch
sundance-set-carrier-status-on-link-change-events.patch
net-sh_eth-add-support-for-renesas-superh-ethernet-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
pci-introduce-pci_slot.patch
acpi-pci-slot-detection-driver.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
pktcdvd-push-bkl-down-into-driver-fix.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues-fix.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues-fix-2.patch
watchdog-pcwd-clean-up-unlocked_ioctl-usage-fix.patch
watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl-fix.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
spufs-use-the-new-vm_ops-access-fix.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
mapping_set_error-add-unlikely.patch
huge-page-private-reservation-review-cleanups-fix.patch
sync_file_range_write-may-and-will-block-document-that-fix.patch
vmallocinfo-add-numa-information-fix.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
build-kernel-profileo-only-when-requested-cleanups.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha.patch
cputopology-always-define-cpu-topology-information-cleanup.patch
oprofile-multiplexing-checkpatch-fixes.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
pnp-convert-resource-options-to-single-linked-list-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-commit-transaction-cleanup.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
reiser4.patch
reiser4-semaphore-fix.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

