From: akpm@linux-foundation.org
Subject: - revert-gregkh-driver-spi-convert-from-class_device-to-device-for-spi.patch removed from -mm tree
Date: Tue, 16 Oct 2007 01:41:33 -0700
Message-ID: <200710160841.l9G8fXuR019402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42958 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932327AbXJPIlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 04:41:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david-b@pacbell.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     revert gregkh-driver-spi-convert-from-class_device-to-device-for-spi
has been removed from the -mm tree.  Its filename was
     revert-gregkh-driver-spi-convert-from-class_device-to-device-for-spi.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: revert gregkh-driver-spi-convert-from-class_device-to-device-for-spi
From: Andrew Morton <akpm@linux-foundation.org>

old...

Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/spi/spi-summary |   13 +++++------
 drivers/spi/spi.c             |   36 ++++++++++++++++----------------
 drivers/spi/spi_bitbang.c     |    2 -
 drivers/spi/spi_lm70llp.c     |    2 -
 include/linux/spi/spi.h       |   12 +++++-----
 5 files changed, 32 insertions(+), 33 deletions(-)

diff -puN Documentation/spi/spi-summary~revert-gregkh-driver-spi-convert-from-class_device-to-device-for-spi Documentation/spi/spi-summary
--- a/Documentation/spi/spi-summary~revert-gregkh-driver-spi-convert-from-class_device-to-device-for-spi
+++ a/Documentation/spi/spi-summary
@@ -167,9 +167,9 @@ shows up in sysfs in several locations:
 
    /sys/bus/spi/drivers/D ... driver for one or more spi*.* devices
 
-   /sys/class/spi_master/spiB ... device for the controller managing bus "B".
-	All the spiB.* devices share the same physical SPI bus segment, with
-	SCLK, MOSI, and MISO.
+   /sys/class/spi_master/spiB ... class device for the controller
+	managing bus "B".  All the spiB.* devices share the same
+	physical SPI bus segment, with SCLK, MOSI, and MISO.
 
 
 How does board-specific init code declare SPI devices?
@@ -337,8 +337,7 @@ SPI protocol drivers somewhat resemble p
 
 The driver core will autmatically attempt to bind this driver to any SPI
 device whose board_info gave a modalias of "CHIP".  Your probe() code
-might look like this unless you're creating a device which is managing a bus
-(appearing under /sys/class/spi_master).
+might look like this unless you're creating a class_device:
 
 	static int __devinit CHIP_probe(struct spi_device *spi)
 	{
@@ -443,7 +442,7 @@ An SPI controller will probably be regis
 a driver to bind to the device, whichever bus is involved.
 
 The main task of this type of driver is to provide an "spi_master".
-Use spi_alloc_master() to allocate the master, and spi_master_get_devdata()
+Use spi_alloc_master() to allocate the master, and class_get_devdata()
 to get the driver-private data allocated for that device.
 
 	struct spi_master	*master;
@@ -453,7 +452,7 @@ to get the driver-private data allocated
 	if (!master)
 		return -ENODEV;
 
-	c = spi_master_get_devdata(master);
+	c = class_get_devdata(&master->cdev);
 
 The driver will initialize the fields of that spi_master, including the
 bus number (maybe the same as the platform device ID) and three methods
diff -puN drivers/spi/spi.c~revert-gregkh-driver-spi-convert-from-class_device-to-device-for-spi drivers/spi/spi.c
--- a/drivers/spi/spi.c~revert-gregkh-driver-spi-convert-from-class_device-to-device-for-spi
+++ a/drivers/spi/spi.c
@@ -204,7 +204,7 @@ struct spi_device *spi_new_device(struct
 				  struct spi_board_info *chip)
 {
 	struct spi_device	*proxy;
-	struct device		*dev = master->dev.parent;
+	struct device		*dev = master->cdev.dev;
 	int			status;
 
 	/* NOTE:  caller did any chip->bus_num checks necessary.
@@ -239,7 +239,7 @@ struct spi_device *spi_new_device(struct
 	proxy->modalias = chip->modalias;
 
 	snprintf(proxy->dev.bus_id, sizeof proxy->dev.bus_id,
-			"%s.%u", master->dev.bus_id,
+			"%s.%u", master->cdev.class_id,
 			chip->chip_select);
 	proxy->dev.parent = dev;
 	proxy->dev.bus = &spi_bus_type;
@@ -338,18 +338,18 @@ static void scan_boardinfo(struct spi_ma
 
 /*-------------------------------------------------------------------------*/
 
-static void spi_master_release(struct device *dev)
+static void spi_master_release(struct class_device *cdev)
 {
 	struct spi_master *master;
 
-	master = container_of(dev, struct spi_master, dev);
+	master = container_of(cdev, struct spi_master, cdev);
 	kfree(master);
 }
 
 static struct class spi_master_class = {
 	.name		= "spi_master",
 	.owner		= THIS_MODULE,
-	.dev_release	= spi_master_release,
+	.release	= spi_master_release,
 };
 
 
@@ -357,7 +357,7 @@ static struct class spi_master_class = {
  * spi_alloc_master - allocate SPI master controller
  * @dev: the controller, possibly using the platform_bus
  * @size: how much zeroed driver-private data to allocate; the pointer to this
- *	memory is in the driver_data field of the returned device,
+ *	memory is in the class_data field of the returned class_device,
  *	accessible with spi_master_get_devdata().
  * Context: can sleep
  *
@@ -383,9 +383,9 @@ struct spi_master *spi_alloc_master(stru
 	if (!master)
 		return NULL;
 
-	device_initialize(&master->dev);
-	master->dev.class = &spi_master_class;
-	master->dev.parent = get_device(dev);
+	class_device_initialize(&master->cdev);
+	master->cdev.class = &spi_master_class;
+	master->cdev.dev = get_device(dev);
 	spi_master_set_devdata(master, &master[1]);
 
 	return master;
@@ -415,7 +415,7 @@ EXPORT_SYMBOL_GPL(spi_alloc_master);
 int spi_register_master(struct spi_master *master)
 {
 	static atomic_t		dyn_bus_id = ATOMIC_INIT((1<<15) - 1);
-	struct device		*dev = master->dev.parent;
+	struct device		*dev = master->cdev.dev;
 	int			status = -ENODEV;
 	int			dynamic = 0;
 
@@ -440,12 +440,12 @@ int spi_register_master(struct spi_maste
 	/* register the device, then userspace will see it.
 	 * registration fails if the bus ID is in use.
 	 */
-	snprintf(master->dev.bus_id, sizeof master->dev.bus_id,
+	snprintf(master->cdev.class_id, sizeof master->cdev.class_id,
 		"spi%u", master->bus_num);
-	status = device_add(&master->dev);
+	status = class_device_add(&master->cdev);
 	if (status < 0)
 		goto done;
-	dev_dbg(dev, "registered master %s%s\n", master->dev.bus_id,
+	dev_dbg(dev, "registered master %s%s\n", master->cdev.class_id,
 			dynamic ? " (dynamic)" : "");
 
 	/* populate children from any spi device tables */
@@ -478,8 +478,8 @@ void spi_unregister_master(struct spi_ma
 {
 	int dummy;
 
-	dummy = device_for_each_child(master->dev.parent, NULL, __unregister);
-	device_unregister(&master->dev);
+	dummy = device_for_each_child(master->cdev.dev, NULL, __unregister);
+	class_device_unregister(&master->cdev);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_master);
 
@@ -495,13 +495,13 @@ EXPORT_SYMBOL_GPL(spi_unregister_master)
  */
 struct spi_master *spi_busnum_to_master(u16 bus_num)
 {
-	struct device		*dev;
+	struct class_device	*cdev;
 	struct spi_master	*master = NULL;
 	struct spi_master	*m;
 
 	down(&spi_master_class.sem);
-	list_for_each_entry(dev, &spi_master_class.children, node) {
-		m = container_of(dev, struct spi_master, dev);
+	list_for_each_entry(cdev, &spi_master_class.children, node) {
+		m = container_of(cdev, struct spi_master, cdev);
 		if (m->bus_num == bus_num) {
 			master = spi_master_get(m);
 			break;
diff -puN drivers/spi/spi_bitbang.c~revert-gregkh-driver-spi-convert-from-class_device-to-device-for-spi drivers/spi/spi_bitbang.c
--- a/drivers/spi/spi_bitbang.c~revert-gregkh-driver-spi-convert-from-class_device-to-device-for-spi
+++ a/drivers/spi/spi_bitbang.c
@@ -472,7 +472,7 @@ int spi_bitbang_start(struct spi_bitbang
 	/* this task is the only thing to touch the SPI bits */
 	bitbang->busy = 0;
 	bitbang->workqueue = create_singlethread_workqueue(
-			bitbang->master->dev.parent->bus_id);
+			bitbang->master->cdev.dev->bus_id);
 	if (bitbang->workqueue == NULL) {
 		status = -EBUSY;
 		goto err1;
diff -puN drivers/spi/spi_lm70llp.c~revert-gregkh-driver-spi-convert-from-class_device-to-device-for-spi drivers/spi/spi_lm70llp.c
--- a/drivers/spi/spi_lm70llp.c~revert-gregkh-driver-spi-convert-from-class_device-to-device-for-spi
+++ a/drivers/spi/spi_lm70llp.c
@@ -82,7 +82,7 @@ struct spi_lm70llp {
 	struct pardevice	*pd;
 	struct spi_device	*spidev_lm70;
 	struct spi_board_info	info;
-	//struct device		*dev;
+	struct class_device	*cdev;
 };
 
 /* REVISIT : ugly global ; provides "exclusive open" facility */
diff -puN include/linux/spi/spi.h~revert-gregkh-driver-spi-convert-from-class_device-to-device-for-spi include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~revert-gregkh-driver-spi-convert-from-class_device-to-device-for-spi
+++ a/include/linux/spi/spi.h
@@ -195,7 +195,7 @@ static inline void spi_unregister_driver
 
 /**
  * struct spi_master - interface to SPI master controller
- * @dev: device interface to this driver
+ * @cdev: class interface to this driver
  * @bus_num: board-specific (and often SOC-specific) identifier for a
  *	given SPI controller.
  * @num_chipselect: chipselects are used to distinguish individual
@@ -222,7 +222,7 @@ static inline void spi_unregister_driver
  * message's completion function when the transaction completes.
  */
 struct spi_master {
-	struct device	dev;
+	struct class_device	cdev;
 
 	/* other than negative (== assign one dynamically), bus_num is fully
 	 * board-specific.  usually that simplifies to being SOC-specific.
@@ -268,17 +268,17 @@ struct spi_master {
 
 static inline void *spi_master_get_devdata(struct spi_master *master)
 {
-	return dev_get_drvdata(&master->dev);
+	return class_get_devdata(&master->cdev);
 }
 
 static inline void spi_master_set_devdata(struct spi_master *master, void *data)
 {
-	dev_set_drvdata(&master->dev, data);
+	class_set_devdata(&master->cdev, data);
 }
 
 static inline struct spi_master *spi_master_get(struct spi_master *master)
 {
-	if (!master || !get_device(&master->dev))
+	if (!master || !class_device_get(&master->cdev))
 		return NULL;
 	return master;
 }
@@ -286,7 +286,7 @@ static inline struct spi_master *spi_mas
 static inline void spi_master_put(struct spi_master *master)
 {
 	if (master)
-		put_device(&master->dev);
+		class_device_put(&master->cdev);
 }
 
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slow-down-printk-during-boot.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
mm-use-pagevec-to-rotate-reclaimable-page.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
nfs-convert-to-new-aops.patch
fs-restore-nobh.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
categorize-gfp-flags.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support.patch
mm-mempolicyc-cleanups.patch
uml-fix-stub-address-calculations.patch
uml-arch-um-drivers-formatting.patch
ecryptfs-printk-warning-fixes.patch
rtc-cmos-probe-cleanup.patch
tdfxfb-mtrr-support.patch
fbdev-fb_create_modedb-non-static-int-first-=-1.patch
intel-fb-support-for-interlaced-video-modes.patch
export-font_vga_8x16.patch
drivers-video-pmag-ba-fbc-improve-diagnostics.patch
fbcon-logo-disable-logo-at-boot.patch
fbdev-copyarea-function-taught-to-fully-support-swapped-pixel-order-in-byte.patch
net-sunrpc-xprtrdma-verbsc-printk-warning-fix.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-cifs.patch
revert-gregkh-driver-spi-convert-from-class_device-to-device-for-spi.patch
git-dvb.patch
applesmc-for-mac-pro-2-x-quad-core-fix.patch
console-keyboard-events-and-accessibility.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-jg-warning-fixes.patch
git-jg-misc-powernow-fix.patch
git-kbuild.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
git-md-accel-fixup.patch
forcedeth-power-down-phy-when-interface-is-down-checkpatch-fixes.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
git-nfs-vs-git-unionfs.patch
git-nfsd-fixup.patch
git-sched.patch
qla2xxx-printk-fixes.patch
git-block.patch
sparc-support-for-new-termios-checkpatch-fixes.patch
git-unionfs.patch
git-v9fs-fixup.patch
git-watchdog-fixup.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-ath5k-broke.patch
revert-x86_64-mm-cpa-einval.patch
fix-x86_64-mm-sched-clock-share.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
asm-i386-ioh-fix-constness.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
git-xfs.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
mm-bdi-init-hooks.patch
mm-per-device-dirty-threshold-warning-fix.patch
mm-dirty-balancing-for-tasks-warning-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix-2.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-do-not-take-callback_mutex-fix.patch
writeback-dont-propagate-aop_writepage_activate.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
pm-qos-infrastructure-and-interface-fix.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2-fix-3.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
binfmt_flat-warning-fixes.patch
console-events-and-accessibility-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished-fix.patch
stop-using-dma_xxbit_mask.patch
stop-using-dma_xxbit_mask-fix.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
kernel-printkc-concerns-about-the-console-handover.patch
userc-ifdef-mq_bytes-fix.patch
f_dupfd_cloexec-implementation-fix-2.patch
ext3-lighten-up-resize-transaction-requirements-checkpatch-fixes.patch
drivers-char-ip2-fix-used-uninitd-bug-checkpatch-fixes.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch
writeback-remove-pages_skipped-accounting-in-__block_write_full_page-fix.patch
revert-faster-ext2_clear_inode.patch
ext2-reservations-fix-for-percpu_counter-changes.patch
md-software-raid-autodetect-dev-list-not-array.patch
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
pnp-use-dev_info-dev_err-etc-in-core-fix.patch
pnp-add-debug-message-for-adding-new-device-fix-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
cpuset-sched_load_balance-flag-fix.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
w1-build-fix.patch
