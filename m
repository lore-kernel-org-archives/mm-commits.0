From: akpm@linux-foundation.org
Subject: + revert-mmconfig-validate-against-acpi-motherboard-resources.patch added to -mm tree
Date: Wed, 06 Jun 2007 09:41:02 -0700
Message-ID: <200706061644.l56GiZ2E001592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51154 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377AbXFFQph (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 12:45:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hancockr@shaw.ca


The patch titled
     revert mmconfig-validate-against-acpi-motherboard-resources
has been added to the -mm tree.  Its filename is
     revert-mmconfig-validate-against-acpi-motherboard-resources.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert mmconfig-validate-against-acpi-motherboard-resources
From: Andrew Morton <akpm@linux-foundation.org>

Needs redoing

Cc: Robert Hancock <hancockr@shaw.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/init.c            |    2 
 arch/i386/pci/mmconfig-shared.c |  150 +++---------------------------
 arch/i386/pci/pci.h             |    3 
 drivers/acpi/bus.c              |    4 
 4 files changed, 20 insertions(+), 139 deletions(-)

diff -puN arch/i386/pci/init.c~revert-mmconfig-validate-against-acpi-motherboard-resources arch/i386/pci/init.c
--- a/arch/i386/pci/init.c~revert-mmconfig-validate-against-acpi-motherboard-resources
+++ a/arch/i386/pci/init.c
@@ -12,7 +12,7 @@ static __init int pci_access_init(void)
 	type = pci_direct_probe();
 #endif
 #ifdef CONFIG_PCI_MMCONFIG
-	pci_mmcfg_early_init(type);
+	pci_mmcfg_init(type);
 #endif
 	if (raw_pci_ops)
 		return 0;
diff -puN arch/i386/pci/mmconfig-shared.c~revert-mmconfig-validate-against-acpi-motherboard-resources arch/i386/pci/mmconfig-shared.c
--- a/arch/i386/pci/mmconfig-shared.c~revert-mmconfig-validate-against-acpi-motherboard-resources
+++ a/arch/i386/pci/mmconfig-shared.c
@@ -206,78 +206,9 @@ static void __init pci_mmcfg_insert_reso
 	pci_mmcfg_resources_inserted = 1;
 }
 
-static acpi_status __init check_mcfg_resource(struct acpi_resource *res,
-					      void *data)
-{
-	struct resource *mcfg_res = data;
-	struct acpi_resource_address64 address;
-	acpi_status status;
-
-	if (res->type == ACPI_RESOURCE_TYPE_FIXED_MEMORY32) {
-		struct acpi_resource_fixed_memory32 *fixmem32 =
-			&res->data.fixed_memory32;
-		if (!fixmem32)
-			return AE_OK;
-		if ((mcfg_res->start >= fixmem32->address) &&
-		    (mcfg_res->end < (fixmem32->address +
-		    		      fixmem32->address_length))) {
-			mcfg_res->flags = 1;
-			return AE_CTRL_TERMINATE;
-		}
-	}
-	if ((res->type != ACPI_RESOURCE_TYPE_ADDRESS32) &&
-	    (res->type != ACPI_RESOURCE_TYPE_ADDRESS64))
-		return AE_OK;
-
-	status = acpi_resource_to_address64(res, &address);
-	if (ACPI_FAILURE(status) ||
-	   (address.address_length <= 0) ||
-	   (address.resource_type != ACPI_MEMORY_RANGE))
-		return AE_OK;
-
-	if ((mcfg_res->start >= address.minimum) &&
-	    (mcfg_res->end < (address.minimum + address.address_length))) {
-		mcfg_res->flags = 1;
-		return AE_CTRL_TERMINATE;
-	}
-	return AE_OK;
-}
-
-static acpi_status __init find_mboard_resource(acpi_handle handle, u32 lvl,
-		void *context, void **rv)
-{
-	struct resource *mcfg_res = context;
-
-	acpi_walk_resources(handle, METHOD_NAME__CRS,
-	  		    check_mcfg_resource, context);
-
-	if (mcfg_res->flags)
-		return AE_CTRL_TERMINATE;
-
-	return AE_OK;
-}
-
-static int __init is_acpi_reserved(unsigned long start, unsigned long end)
-{
-	struct resource mcfg_res;
-
-	mcfg_res.start = start;
-	mcfg_res.end = end;
-	mcfg_res.flags = 0;
-
-	acpi_get_devices("PNP0C01", find_mboard_resource, &mcfg_res, NULL);
-
-	if (!mcfg_res.flags)
-		acpi_get_devices("PNP0C02", find_mboard_resource, &mcfg_res,
-				 NULL);
-
-	return mcfg_res.flags;
-}
-
-static void __init pci_mmcfg_reject_broken(void)
+static void __init pci_mmcfg_reject_broken(int type)
 {
 	typeof(pci_mmcfg_config[0]) *cfg;
-	int i;
 
 	if ((pci_mmcfg_config_num == 0) ||
 	    (pci_mmcfg_config == NULL) ||
@@ -298,36 +229,17 @@ static void __init pci_mmcfg_reject_brok
 		goto reject;
 	}
 
-	for (i = 0; i < pci_mmcfg_config_num; i++) {
-		u32 size = (cfg->end_bus_number + 1) << 20;
-		cfg = &pci_mmcfg_config[i];
-		printk(KERN_NOTICE "PCI: MCFG configuration %d: base %p "
-		       "segment %hu buses %u - %u\n",
-		       i, (void*)cfg->address, cfg->pci_segment,
-		       (unsigned int)cfg->start_bus_number,
-		       (unsigned int)cfg->end_bus_number);
-		if (is_acpi_reserved(cfg->address, cfg->address + size - 1)) {
-			printk(KERN_NOTICE "PCI: MCFG area at %Lx reserved "
-			       "in ACPI motherboard resources\n",
-			       cfg->address);
-		} else {
-			printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is not "
-			       "reserved in ACPI motherboard resources\n",
-			       cfg->address);
-			/* Don't try to do this check unless configuration
-			   type 1 is available. */
-			if ((pci_probe & PCI_PROBE_CONF1) &&
-			    e820_all_mapped(cfg->address,
-			                    cfg->address + size - 1,
-					    E820_RESERVED))
-				printk(KERN_NOTICE
-				       "PCI: MCFG area at %Lx reserved in E820\n",
-				       cfg->address);
-			else
-				goto reject;
-		}
+	/*
+	 * Only do this check when type 1 works. If it doesn't work
+	 * assume we run on a Mac and always use MCFG
+	 */
+	if (type == 1 && !e820_all_mapped(cfg->address,
+					  cfg->address + MMCONFIG_APER_MIN,
+					  E820_RESERVED)) {
+		printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is not"
+		       " E820-reserved\n", cfg->address);
+		goto reject;
 	}
-
 	return;
 
 reject:
@@ -337,46 +249,20 @@ reject:
 	pci_mmcfg_config_num = 0;
 }
 
-void __init pci_mmcfg_early_init(int type)
-{
-	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
-		return;
-
-	/* If type 1 access is available, no need to enable MMCONFIG yet, we can
-	   defer until later when the ACPI interpreter is available to better
-	   validate things. */
-	if (type == 1)
-		return;
-
-	acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
-
-	if ((pci_mmcfg_config_num == 0) ||
-	    (pci_mmcfg_config == NULL) ||
-	    (pci_mmcfg_config[0].address == 0))
-		return;
-
-	if (pci_mmcfg_arch_init())
-		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
-}
-
-void __init pci_mmcfg_late_init(void)
+void __init pci_mmcfg_init(int type)
 {
 	int known_bridge = 0;
 
-	/* MMCONFIG disabled */
 	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
 		return;
 
-	/* MMCONFIG already enabled */
-	if (!(pci_probe & PCI_PROBE_MASK & ~PCI_PROBE_MMCONF))
-		return;
-
-	if ((pci_probe & PCI_PROBE_CONF1) && pci_mmcfg_check_hostbridge())
+	if (type == 1 && pci_mmcfg_check_hostbridge())
 		known_bridge = 1;
-	else
-		acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
 
-	pci_mmcfg_reject_broken();
+	if (!known_bridge) {
+		acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
+		pci_mmcfg_reject_broken(type);
+	}
 
 	if ((pci_mmcfg_config_num == 0) ||
 	    (pci_mmcfg_config == NULL) ||
@@ -384,7 +270,7 @@ void __init pci_mmcfg_late_init(void)
 		return;
 
 	if (pci_mmcfg_arch_init()) {
-		if (pci_probe & PCI_PROBE_CONF1)
+		if (type == 1)
 			unreachable_devices();
 		if (known_bridge)
 			pci_mmcfg_insert_resources(IORESOURCE_BUSY);
diff -puN arch/i386/pci/pci.h~revert-mmconfig-validate-against-acpi-motherboard-resources arch/i386/pci/pci.h
--- a/arch/i386/pci/pci.h~revert-mmconfig-validate-against-acpi-motherboard-resources
+++ a/arch/i386/pci/pci.h
@@ -91,8 +91,7 @@ extern int pci_conf1_read(unsigned int s
 extern int pci_direct_probe(void);
 extern void pci_direct_init(int type);
 extern void pci_pcbios_init(void);
-extern void pci_mmcfg_early_init(int type);
-extern void pci_mmcfg_late_init(void);
+extern void pci_mmcfg_init(int type);
 extern void pcibios_sort(void);
 
 /* pci-mmconfig.c */
diff -puN drivers/acpi/bus.c~revert-mmconfig-validate-against-acpi-motherboard-resources drivers/acpi/bus.c
--- a/drivers/acpi/bus.c~revert-mmconfig-validate-against-acpi-motherboard-resources
+++ a/drivers/acpi/bus.c
@@ -42,7 +42,6 @@
 ACPI_MODULE_NAME("bus");
 #ifdef	CONFIG_X86
 extern void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger);
-extern void __init pci_mmcfg_late_init(void);
 #endif
 
 struct acpi_device *acpi_root;
@@ -756,9 +755,6 @@ static int __init acpi_init(void)
 	result = acpi_bus_init();
 
 	if (!result) {
-#ifdef CONFIG_X86
-		pci_mmcfg_late_init();
-#endif
 #ifdef CONFIG_PM_LEGACY
 		if (!PM_IS_ACTIVE())
 			pm_active = 1;
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
audit-rework-execve-audit-fix.patch
mm-variable-length-argument-support-fix.patch
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
revert-mmconfig-validate-against-acpi-motherboard-resources.patch
