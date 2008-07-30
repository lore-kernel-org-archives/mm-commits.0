From: akpm@linux-foundation.org
Subject: - linux-next-rejects.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:04:37 -0700
Message-ID: <200807301904.m6UJ4c8Q010479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753994AbYG3TEk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:04:40 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m6UJ4cji020809
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 30 Jul 2008 12:04:39 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/genapic_64.c |   84 ++++++++++-----------------------
 1 file changed, 27 insertions(+), 57 deletions(-)

diff -puN drivers/media/dvb/ttpci/Kconfig~linux-next-rejects drivers/media/dvb/ttpci/Kconfig
diff -puN include/linux/stop_machine.h~linux-next-rejects include/linux/stop_machine.h
diff -puN kernel/stop_machine.c~linux-next-rejects kernel/stop_machine.c
diff -puN arch/x86/kernel/genapic_64.c~linux-next-rejects arch/x86/kernel/genapic_64.c
--- a/arch/x86/kernel/genapic_64.c~linux-next-rejects
+++ a/arch/x86/kernel/genapic_64.c
@@ -21,82 +21,52 @@
 #include <asm/ipi.h>
 #include <asm/genapic.h>
 
-#ifdef CONFIG_ACPI
-#include <acpi/acpi_bus.h>
-#endif
-
-DEFINE_PER_CPU(int, x2apic_extra_bits);
+extern struct genapic apic_flat;
+extern struct genapic apic_physflat;
+extern struct genapic apic_x2xpic_uv_x;
+extern struct genapic apic_x2apic_phys;
+extern struct genapic apic_x2apic_cluster;
 
 struct genapic __read_mostly *genapic = &apic_flat;
 
-static enum uv_system_type uv_system_type;
+static struct genapic *apic_probe[] __initdata = {
+	&apic_x2apic_uv_x,
+	&apic_x2apic_phys,
+	&apic_x2apic_cluster,
+	&apic_physflat,
+	NULL,
+};
 
 /*
  * Check the APIC IDs in bios_cpu_apicid and choose the APIC mode.
  */
 void __init setup_apic_routing(void)
 {
-	if (uv_system_type == UV_NON_UNIQUE_APIC)
-		genapic = &apic_x2apic_uv_x;
-	else
-#ifdef CONFIG_ACPI
-	/*
-	 * Quirk: some x86_64 machines can only use physical APIC mode
-	 * regardless of how many processors are present (x86_64 ES7000
-	 * is an example).
-	 */
-	if (acpi_gbl_FADT.header.revision > FADT2_REVISION_ID &&
-			(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL))
-		genapic = &apic_physflat;
-	else
-#endif
-
-	if (max_physical_apicid < 8)
-		genapic = &apic_flat;
-	else
-		genapic = &apic_physflat;
-
-	printk(KERN_INFO "Setting APIC routing to %s\n", genapic->name);
+	if (genapic == &apic_flat) {
+		if (max_physical_apicid >= 8)
+			genapic = &apic_physflat;
+		printk(KERN_INFO "Setting APIC routing to %s\n", genapic->name);
+	}
 }
 
 /* Same for both flat and physical. */
 
-void send_IPI_self(int vector)
+void apic_send_IPI_self(int vector)
 {
 	__send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
 }
 
 int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	if (!strcmp(oem_id, "SGI")) {
-		if (!strcmp(oem_table_id, "UVL"))
-			uv_system_type = UV_LEGACY_APIC;
-		else if (!strcmp(oem_table_id, "UVX"))
-			uv_system_type = UV_X2APIC;
-		else if (!strcmp(oem_table_id, "UVH"))
-			uv_system_type = UV_NON_UNIQUE_APIC;
+	int i;
+
+	for (i = 0; apic_probe[i]; ++i) {
+		if (apic_probe[i]->acpi_madt_oem_check(oem_id, oem_table_id)) {
+			genapic = apic_probe[i];
+			printk(KERN_INFO "Setting APIC routing to %s.\n",
+				genapic->name);
+			return 1;
+		}
 	}
 	return 0;
 }
-
-unsigned int read_apic_id(void)
-{
-	unsigned int id;
-
-	WARN_ON(preemptible() && num_online_cpus() > 1);
-	id = apic_read(APIC_ID);
-	if (uv_system_type >= UV_X2APIC)
-		id  |= __get_cpu_var(x2apic_extra_bits);
-	return id;
-}
-
-enum uv_system_type get_uv_system_type(void)
-{
-	return uv_system_type;
-}
-
-int is_uv_system(void)
-{
-	return uv_system_type != UV_NONE;
-}
-EXPORT_SYMBOL_GPL(is_uv_system);
diff -puN include/linux/semaphore.h~linux-next-rejects include/linux/semaphore.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
linux-next-rejects.patch
next-remove-localversion.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
pci-make-pci_register_driver-a-macro.patch
git-acpi.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
powerpc-replace-__function__-with-__func__-checkpatch-fixes.patch
verify_dynamic_kobject_allocation-dont-use-kmalloc.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-serio-xilinx_ps2c-fix-warning.patch
git-jg-misc.patch
git-kvm.patch
git-mtd.patch
drivers-mtd-nand-nandsimc-fix-printk-warnings.patch
drivers-mtd-nand-fsl_elbc_nandc-fix-printk-warning.patch
bridge-send-correct-mtu-value-in-pmtu-checkpatch-fixes.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
git-nfsd.patch
sched-type-fix.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
git-block-git-rejects.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
drivers-net-wireless-iwlwifi-iwl-ledc-printk-fix.patch
git-xtensa.patch
drivers-telephony-ixjc-depends-on-pnp.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
hwmon-adc124s501-generic-driver.patch
drivers-net-netxen-netxen_nic_hwc-fix-printk-warnings.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works-comment.patch
ftrace-disable-function-tracing-bringing-up-new-cpu-fix.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
devpts-switch-to-ida-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
w1-feature-enable-hardware-strong-pullup-checkpatch-fixes.patch
w1-ds2490c-add-support-for-strong-pullup-checkpatch-fixes.patch
w1-ds2490c-optimize-ds_set_pullup-checkpatch-fixes.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
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

