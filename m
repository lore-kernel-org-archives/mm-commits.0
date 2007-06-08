From: akpm@linux-foundation.org
Subject: - revert-gregkh-pci-pci-reduce-aer-init-error-information.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:34:51 -0700
Message-ID: <200706081734.l58HYpIe006318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47996 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760660AbXFHRfg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:35:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, yanmin.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     revert gregkh-pci-pci-reduce-aer-init-error-information
has been removed from the -mm tree.  Its filename was
     revert-gregkh-pci-pci-reduce-aer-init-error-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: revert gregkh-pci-pci-reduce-aer-init-error-information
From: Andrew Morton <akpm@linux-foundation.org>

It deletes aerdrv_acpi.c but we still need it.

Cc: "Zhang, Yanmin" <yanmin.zhang@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci-acpi.c             |    8 ++-
 drivers/pci/pcie/aer/aerdrv.h      |    5 +
 drivers/pci/pcie/aer/aerdrv_acpi.c |   68 +++++++++++++++++++++++++++
 drivers/pci/pcie/aer/aerdrv_core.c |   55 ++-------------------
 4 files changed, 86 insertions(+), 50 deletions(-)

diff -puN drivers/pci/pci-acpi.c~revert-gregkh-pci-pci-reduce-aer-init-error-information drivers/pci/pci-acpi.c
--- a/drivers/pci/pci-acpi.c~revert-gregkh-pci-pci-reduce-aer-init-error-information
+++ a/drivers/pci/pci-acpi.c
@@ -55,6 +55,8 @@ acpi_query_osc (
 
 	status = acpi_evaluate_object(handle, "_OSC", &input, &output);
 	if (ACPI_FAILURE (status)) {
+		printk(KERN_DEBUG  
+			"Evaluate _OSC Set fails. Status = 0x%04x\n", status);
 		*ret_status = status;
 		return status;
 	}
@@ -122,9 +124,11 @@ acpi_run_osc (
 	in_params[3].buffer.pointer 	= (u8 *)context;
 
 	status = acpi_evaluate_object(handle, "_OSC", &input, &output);
-	if (ACPI_FAILURE (status))
+	if (ACPI_FAILURE (status)) {
+		printk(KERN_DEBUG  
+			"Evaluate _OSC Set fails. Status = 0x%04x\n", status);
 		return status;
-
+	}
 	out_obj = output.pointer;
 	if (out_obj->type != ACPI_TYPE_BUFFER) {
 		printk(KERN_DEBUG  
diff -puN drivers/pci/pcie/aer/aerdrv.h~revert-gregkh-pci-pci-reduce-aer-init-error-information drivers/pci/pcie/aer/aerdrv.h
--- a/drivers/pci/pcie/aer/aerdrv.h~revert-gregkh-pci-pci-reduce-aer-init-error-information
+++ a/drivers/pci/pcie/aer/aerdrv.h
@@ -19,6 +19,10 @@
 #define AER_ERROR_MASK			0x001fffff
 #define AER_ERROR(d)			(d & AER_ERROR_MASK)
 
+#define OSC_METHOD_RUN_SUCCESS		0
+#define OSC_METHOD_NOT_SUPPORTED	1
+#define OSC_METHOD_RUN_FAILURE		2
+
 /* Root Error Status Register Bits */
 #define ROOT_ERR_STATUS_MASKS			0x0f
 
@@ -117,5 +121,6 @@ extern void aer_delete_rootport(struct a
 extern int aer_init(struct pcie_device *dev);
 extern void aer_isr(struct work_struct *work);
 extern void aer_print_error(struct pci_dev *dev, struct aer_err_info *info);
+extern int aer_osc_setup(struct pci_dev *dev);
 
 #endif //_AERDRV_H_
diff -puN /dev/null drivers/pci/pcie/aer/aerdrv_acpi.c
--- /dev/null
+++ a/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -0,0 +1,68 @@
+/*
+ * Access ACPI _OSC method
+ *
+ * Copyright (C) 2006 Intel Corp.
+ *	Tom Long Nguyen (tom.l.nguyen@intel.com)
+ *	Zhang Yanmin (yanmin.zhang@intel.com)
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/pm.h>
+#include <linux/suspend.h>
+#include <linux/acpi.h>
+#include <linux/pci-acpi.h>
+#include <linux/delay.h>
+#include "aerdrv.h"
+
+/**
+ * aer_osc_setup - run ACPI _OSC method
+ *
+ * Return:
+ *	Zero if success. Nonzero for otherwise.
+ *
+ * Invoked when PCIE bus loads AER service driver. To avoid conflict with
+ * BIOS AER support requires BIOS to yield AER control to OS native driver.
+ **/
+int aer_osc_setup(struct pci_dev *dev)
+{
+	int retval = OSC_METHOD_RUN_SUCCESS;
+	acpi_status status;
+	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
+	struct pci_dev *pdev = dev;
+	struct pci_bus *parent;
+
+	while (!handle) {
+		if (!pdev || !pdev->bus->parent)
+			break;
+		parent = pdev->bus->parent;
+		if (!parent->self)
+			/* Parent must be a host bridge */
+			handle = acpi_get_pci_rootbridge_handle(
+					pci_domain_nr(parent),
+					parent->number);
+		else
+			handle = DEVICE_ACPI_HANDLE(
+					&(parent->self->dev));
+		pdev = parent->self;
+	}
+
+	if (!handle)
+		return OSC_METHOD_NOT_SUPPORTED;
+
+	pci_osc_support_set(OSC_EXT_PCI_CONFIG_SUPPORT);
+	status = pci_osc_control_set(handle, OSC_PCI_EXPRESS_AER_CONTROL |
+		OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);
+	if (ACPI_FAILURE(status)) {
+		if (status == AE_SUPPORT)
+			retval = OSC_METHOD_NOT_SUPPORTED;
+	 	else
+			retval = OSC_METHOD_RUN_FAILURE;
+	}
+
+	return retval;
+}
+
diff -puN drivers/pci/pcie/aer/aerdrv_core.c~revert-gregkh-pci-pci-reduce-aer-init-error-information drivers/pci/pcie/aer/aerdrv_core.c
--- a/drivers/pci/pcie/aer/aerdrv_core.c~revert-gregkh-pci-pci-reduce-aer-init-error-information
+++ a/drivers/pci/pcie/aer/aerdrv_core.c
@@ -726,47 +726,6 @@ void aer_delete_rootport(struct aer_rpc 
 }
 
 /**
- * aer_osc_setup - run ACPI _OSC method
- *
- * Return:
- *	Zero if success. Nonzero for otherwise.
- *
- * Invoked when PCIE bus loads AER service driver. To avoid conflict with
- * BIOS AER support requires BIOS to yield AER control to OS native driver.
- **/
-acpi_status aer_osc_setup(struct pci_dev *dev)
-{
-	acpi_status status = AE_NOT_FOUND;
-	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
-	struct pci_dev *pdev = dev;
-	struct pci_bus *parent;
-
-	while (!handle) {
-		if (!pdev || !pdev->bus->parent)
-			break;
-		parent = pdev->bus->parent;
-		if (!parent->self)
-			/* Parent must be a host bridge */
-			handle = acpi_get_pci_rootbridge_handle(
-					pci_domain_nr(parent),
-					parent->number);
-		else
-			handle = DEVICE_ACPI_HANDLE(
-					&(parent->self->dev));
-		pdev = parent->self;
-	}
-
-	if (!handle)
-		return status;
-
-	pci_osc_support_set(OSC_EXT_PCI_CONFIG_SUPPORT);
-	status = pci_osc_control_set(handle, OSC_PCI_EXPRESS_AER_CONTROL |
-		OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);
-
-	return status;
-}
-
-/**
  * aer_init - provide AER initialization
  * @dev: pointer to AER pcie device
  *
@@ -774,19 +733,19 @@ acpi_status aer_osc_setup(struct pci_dev
  **/
 int aer_init(struct pcie_device *dev)
 {
-	acpi_status	status;
+	int status;
 
 	/* Run _OSC Method */
 	status = aer_osc_setup(dev->port);
 
-	if (ACPI_FAILURE(status)) {
-		printk(KERN_DEBUG "AER service couldn't init device %s - %s\n",
-		    dev->device.bus_id,
-		    (status == AE_SUPPORT || status == AE_NOT_FOUND) ?
-		    "no _OSC support" : "Run ACPI _OSC fails");
+	if(status != OSC_METHOD_RUN_SUCCESS) {
+		printk(KERN_DEBUG "%s: AER service init fails - %s\n",
+		__FUNCTION__,
+		(status == OSC_METHOD_NOT_SUPPORTED) ?
+			"No ACPI _OSC support" : "Run ACPI _OSC fails");
 
 		if (!forceload)
-			return -ENXIO;
+			return status;
 	}
 
 	return AER_SUCCESS;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
document-acked-by.patch
x86_64-oops_begin-fix.patch
git-acpi.patch
git-acpi-tickh-needs-hrtimerh.patch
git-acpi-add-exports.patch
git-acpi-disable-acpi_processor_throttling_seq_show.patch
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
git-input.patch
git-input-fixup.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
git-md-accel.patch
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
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
lockstat-core-infrastructure-fix-fix-fix.patch
reiser4.patch
reiser4-fix.patch
nick-broke-reiser4-too.patch
check_dirty_inode_list.patch
w1-build-fix.patch
