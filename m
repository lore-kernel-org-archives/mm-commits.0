From: akpm@linux-foundation.org
Subject: + revert-gregkh-pci-pci_bridge-device.patch added to -mm tree
Date: Tue, 12 Jun 2007 17:28:48 -0700
Message-ID: <200706130032.l5D0WVio024618@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57882 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753770AbXFMAco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 20:32:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com


The patch titled
     revert gregkh-pci-pci_bridge-device
has been added to the -mm tree.  Its filename is
     revert-gregkh-pci-pci_bridge-device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert gregkh-pci-pci_bridge-device
From: Andrew Morton <akpm@linux-foundation.org>

It kills my x86_64 box early in boot.  The pic is on my cellphone, will upload
later.

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/bus.c    |   17 ++--------
 drivers/pci/pci.h    |    2 -
 drivers/pci/probe.c  |   64 ++++++++++++++++++++++++-----------------
 drivers/pci/remove.c |    6 ++-
 include/linux/pci.h  |    4 +-
 5 files changed, 50 insertions(+), 43 deletions(-)

diff -puN drivers/pci/bus.c~revert-gregkh-pci-pci_bridge-device drivers/pci/bus.c
--- a/drivers/pci/bus.c~revert-gregkh-pci-pci_bridge-device
+++ a/drivers/pci/bus.c
@@ -108,7 +108,6 @@ int pci_bus_add_device(struct pci_dev *d
 void pci_bus_add_devices(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
-	struct pci_bus *child_bus;
 	int retval;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
@@ -139,19 +138,11 @@ void pci_bus_add_devices(struct pci_bus 
 			       up_write(&pci_bus_sem);
 			}
 			pci_bus_add_devices(dev->subordinate);
-
-			/* register the bus with sysfs as the parent is now
-			 * properly registered. */
-			child_bus = dev->subordinate;
-			child_bus->dev.parent = child_bus->bridge;
-			retval = device_register(&child_bus->dev);
-			if (!retval)
-				retval = device_create_file(&child_bus->dev,
-							&dev_attr_cpuaffinity);
+			retval = sysfs_create_link(&dev->subordinate->class_dev.kobj,
+						   &dev->dev.kobj, "bridge");
 			if (retval)
-				dev_err(&dev->dev, "Error registering pci_bus"
-					" device bridge symlink,"
-					" continuing...\n");
+				dev_err(&dev->dev, "Error creating sysfs "
+					"bridge symlink, continuing...\n");
 		}
 	}
 }
diff -puN drivers/pci/pci.h~revert-gregkh-pci-pci_bridge-device drivers/pci/pci.h
--- a/drivers/pci/pci.h~revert-gregkh-pci-pci_bridge-device
+++ a/drivers/pci/pci.h
@@ -70,7 +70,7 @@ static inline int pci_no_d1d2(struct pci
 }
 extern int pcie_mch_quirk;
 extern struct device_attribute pci_dev_attrs[];
-extern struct device_attribute dev_attr_cpuaffinity;
+extern struct class_device_attribute class_device_attr_cpuaffinity;
 
 /**
  * pci_match_one_device - Tell if a PCI device structure has a matching
diff -puN drivers/pci/probe.c~revert-gregkh-pci-pci_bridge-device drivers/pci/probe.c
--- a/drivers/pci/probe.c~revert-gregkh-pci-pci_bridge-device
+++ a/drivers/pci/probe.c
@@ -41,7 +41,7 @@ static void pci_create_legacy_files(stru
 		b->legacy_io->attr.mode = S_IRUSR | S_IWUSR;
 		b->legacy_io->read = pci_read_legacy_io;
 		b->legacy_io->write = pci_write_legacy_io;
-		device_create_bin_file(&b->dev, b->legacy_io);
+		class_device_create_bin_file(&b->class_dev, b->legacy_io);
 
 		/* Allocated above after the legacy_io struct */
 		b->legacy_mem = b->legacy_io + 1;
@@ -49,15 +49,15 @@ static void pci_create_legacy_files(stru
 		b->legacy_mem->size = 1024*1024;
 		b->legacy_mem->attr.mode = S_IRUSR | S_IWUSR;
 		b->legacy_mem->mmap = pci_mmap_legacy_mem;
-		device_create_bin_file(&b->dev, b->legacy_mem);
+		class_device_create_bin_file(&b->class_dev, b->legacy_mem);
 	}
 }
 
 void pci_remove_legacy_files(struct pci_bus *b)
 {
 	if (b->legacy_io) {
-		device_remove_bin_file(&b->dev, b->legacy_io);
-		device_remove_bin_file(&b->dev, b->legacy_mem);
+		class_device_remove_bin_file(&b->class_dev, b->legacy_io);
+		class_device_remove_bin_file(&b->class_dev, b->legacy_mem);
 		kfree(b->legacy_io); /* both are allocated here */
 	}
 }
@@ -69,27 +69,26 @@ void pci_remove_legacy_files(struct pci_
 /*
  * PCI Bus Class Devices
  */
-static ssize_t pci_bus_show_cpuaffinity(struct device *dev,
-					struct device_attribute *attr,
+static ssize_t pci_bus_show_cpuaffinity(struct class_device *class_dev,
 					char *buf)
 {
 	int ret;
 	cpumask_t cpumask;
 
-	cpumask = pcibus_to_cpumask(to_pci_bus(dev));
+	cpumask = pcibus_to_cpumask(to_pci_bus(class_dev));
 	ret = cpumask_scnprintf(buf, PAGE_SIZE, cpumask);
 	if (ret < PAGE_SIZE)
 		buf[ret++] = '\n';
 	return ret;
 }
-DEVICE_ATTR(cpuaffinity, S_IRUGO, pci_bus_show_cpuaffinity, NULL);
+CLASS_DEVICE_ATTR(cpuaffinity, S_IRUGO, pci_bus_show_cpuaffinity, NULL);
 
 /*
  * PCI Bus Class
  */
-static void release_pcibus_dev(struct device *dev)
+static void release_pcibus_dev(struct class_device *class_dev)
 {
-	struct pci_bus *pci_bus = to_pci_bus(dev);
+	struct pci_bus *pci_bus = to_pci_bus(class_dev);
 
 	if (pci_bus->bridge)
 		put_device(pci_bus->bridge);
@@ -98,7 +97,7 @@ static void release_pcibus_dev(struct de
 
 static struct class pcibus_class = {
 	.name		= "pci_bus",
-	.dev_release	= &release_pcibus_dev,
+	.release	= &release_pcibus_dev,
 };
 
 static int __init pcibus_class_init(void)
@@ -381,6 +380,7 @@ pci_alloc_child_bus(struct pci_bus *pare
 {
 	struct pci_bus *child;
 	int i;
+	int retval;
 
 	/*
 	 * Allocate a new bus, and inherit stuff from the parent..
@@ -396,12 +396,15 @@ pci_alloc_child_bus(struct pci_bus *pare
 	child->bus_flags = parent->bus_flags;
 	child->bridge = get_device(&bridge->dev);
 
-	/* initialize some portions of the bus device, but don't register it
-	 * now as the parent is not properly set up yet.  This device will get
-	 * registered later in pci_bus_add_devices()
-	 */
-	child->dev.class = &pcibus_class;
-	sprintf(child->dev.bus_id, "%04x:%02x", pci_domain_nr(child), busnr);
+	child->class_dev.class = &pcibus_class;
+	sprintf(child->class_dev.class_id, "%04x:%02x", pci_domain_nr(child), busnr);
+	retval = class_device_register(&child->class_dev);
+	if (retval)
+		goto error_register;
+	retval = class_device_create_file(&child->class_dev,
+					  &class_device_attr_cpuaffinity);
+	if (retval)
+		goto error_file_create;
 
 	/*
 	 * Set up the primary, secondary and subordinate
@@ -419,6 +422,12 @@ pci_alloc_child_bus(struct pci_bus *pare
 	bridge->subordinate = child;
 
 	return child;
+
+error_file_create:
+	class_device_unregister(&child->class_dev);
+error_register:
+	kfree(child);
+	return NULL;
 }
 
 struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev, int busnr)
@@ -1088,27 +1097,32 @@ struct pci_bus * pci_create_bus(struct d
 		goto dev_reg_err;
 	b->bridge = get_device(dev);
 
-	b->dev.class = &pcibus_class;
-	b->dev.parent = b->bridge;
-	sprintf(b->dev.bus_id, "%04x:%02x", pci_domain_nr(b), bus);
-	error = device_register(&b->dev);
+	b->class_dev.class = &pcibus_class;
+	sprintf(b->class_dev.class_id, "%04x:%02x", pci_domain_nr(b), bus);
+	error = class_device_register(&b->class_dev);
 	if (error)
 		goto class_dev_reg_err;
-	error = device_create_file(&b->dev, &dev_attr_cpuaffinity);
+	error = class_device_create_file(&b->class_dev, &class_device_attr_cpuaffinity);
 	if (error)
-		goto dev_create_file_err;
+		goto class_dev_create_file_err;
 
 	/* Create legacy_io and legacy_mem files for this bus */
 	pci_create_legacy_files(b);
 
+	error = sysfs_create_link(&b->class_dev.kobj, &b->bridge->kobj, "bridge");
+	if (error)
+		goto sys_create_link_err;
+
 	b->number = b->secondary = bus;
 	b->resource[0] = &ioport_resource;
 	b->resource[1] = &iomem_resource;
 
 	return b;
 
-dev_create_file_err:
-	device_unregister(&b->dev);
+sys_create_link_err:
+	class_device_remove_file(&b->class_dev, &class_device_attr_cpuaffinity);
+class_dev_create_file_err:
+	class_device_unregister(&b->class_dev);
 class_dev_reg_err:
 	device_unregister(dev);
 dev_reg_err:
diff -puN drivers/pci/remove.c~revert-gregkh-pci-pci_bridge-device drivers/pci/remove.c
--- a/drivers/pci/remove.c~revert-gregkh-pci-pci_bridge-device
+++ a/drivers/pci/remove.c
@@ -74,8 +74,10 @@ void pci_remove_bus(struct pci_bus *pci_
 	list_del(&pci_bus->node);
 	up_write(&pci_bus_sem);
 	pci_remove_legacy_files(pci_bus);
-	device_remove_file(&pci_bus->dev, &dev_attr_cpuaffinity);
-	device_unregister(&pci_bus->dev);
+	class_device_remove_file(&pci_bus->class_dev,
+		&class_device_attr_cpuaffinity);
+	sysfs_remove_link(&pci_bus->class_dev.kobj, "bridge");
+	class_device_unregister(&pci_bus->class_dev);
 }
 EXPORT_SYMBOL(pci_remove_bus);
 
diff -puN include/linux/pci.h~revert-gregkh-pci-pci_bridge-device include/linux/pci.h
--- a/include/linux/pci.h~revert-gregkh-pci-pci_bridge-device
+++ a/include/linux/pci.h
@@ -267,13 +267,13 @@ struct pci_bus {
 	unsigned short  bridge_ctl;	/* manage NO_ISA/FBB/et al behaviors */
 	pci_bus_flags_t bus_flags;	/* Inherited by child busses */
 	struct device		*bridge;
-	struct device		dev;
+	struct class_device	class_dev;
 	struct bin_attribute	*legacy_io; /* legacy I/O for this bus */
 	struct bin_attribute	*legacy_mem; /* legacy mem */
 };
 
 #define pci_bus_b(n)	list_entry(n, struct pci_bus, node)
-#define to_pci_bus(n)	container_of(n, struct pci_bus, dev)
+#define to_pci_bus(n)	container_of(n, struct pci_bus, class_dev)
 
 /*
  * Error values that may be returned by PCI functions.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
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
git-dvb.patch
git-gfs2-nmw.patch
git-infiniband.patch
git-input.patch
git-input-fixup.patch
serio_raw_read-warning-fix.patch
git-jfs-fix.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
led_colour_show-warning-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
fix-ide-aec62xx-remove-init_dma-method-take-2.patch
ide_scan_pcibus-cehck-__pci_register_driver-return-value.patch
git-md-accel.patch
git-mips-fixup.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
git-ubi.patch
sundance-phy-address-form-0-only-for-device-id-0x0200-fix.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-ioat-vs-git-md-accel.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
git-r8169-fixup.patch
git-selinux.patch
git-selinux-fixup.patch
revert-gregkh-pci-pci_bridge-device.patch
fix-gregkh-pci-pci-change-all-drivers-to-use-pci_device-revision.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-scsi-misc.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch
git-unionfs.patch
fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
git-watchdog.patch
git-wireless.patch
git-wireless-vs-git-net.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
revert-x86_64-mm-verify-cpu-rename.patch
revert-x86_64-mm-allocate-sparsemem-memmap-above-4g-on-x86_64.patch
revert-x86_64-mm-cpa-cache-flush.patch
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
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86-64-calgary-introduce-chipset-specific-ops-fix.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2-fix.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions-fix.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
paravirt-helper-to-disable-all-io-space-fix.patch
i386-x86_64-trim-memory-not-covered-by-wb-mtrrs-fix.patch
i386-x86_64-trim-memory-not-covered-by-wb-mtrrs-fix-2.patch
i386-mtrr-clean-up-usage_table.patch
i386-show-unhandled-signals-fix.patch
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
fs-introduce-write_begin-write_end-and-perform_write-aops-fix.patch
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
allow-huge-page-allocations-to-use-gfp_high_movable-fix-3.patch
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
dirty_writeback_centisecs_handler-cleanup.patch
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
nick-broke-reiser4-too.patch
check_dirty_inode_list.patch
w1-build-fix.patch
