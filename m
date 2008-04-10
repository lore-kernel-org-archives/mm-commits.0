From: akpm@linux-foundation.org
Subject: - revert-ide-mm-ide-remove-inswl-and-outswl-methods.patch removed from -mm tree
Date: Thu, 10 Apr 2008 12:12:54 -0700
Message-ID: <200804101912.m3AJCsdl013052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673AbYDJTNZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 15:13:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     revert ide-mm-ide-remove-inswl-and-outswl-methods
has been removed from the -mm tree.  Its filename was
     revert-ide-mm-ide-remove-inswl-and-outswl-methods.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert ide-mm-ide-remove-inswl-and-outswl-methods
From: Andrew Morton <akpm@linux-foundation.org>

oopses powerpc

Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/h8300/ide-h8300.c |    4 +
 drivers/ide/ide-iops.c        |  114 ++++++++++++++++++--------------
 drivers/ide/mips/au1xxx-ide.c |    3 
 drivers/ide/pci/scc_pata.c    |    4 +
 include/linux/ide.h           |    4 +
 5 files changed, 81 insertions(+), 48 deletions(-)

diff -puN drivers/ide/h8300/ide-h8300.c~revert-ide-mm-ide-remove-inswl-and-outswl-methods drivers/ide/h8300/ide-h8300.c
--- a/drivers/ide/h8300/ide-h8300.c~revert-ide-mm-ide-remove-inswl-and-outswl-methods
+++ a/drivers/ide/h8300/ide-h8300.c
@@ -88,7 +88,11 @@ static inline void hwif_setup(ide_hwif_t
 	hwif->output_data = h8300_output_data;
 
 	hwif->OUTW  = mm_outw;
+	hwif->OUTSW = mm_outsw;
 	hwif->INW   = mm_inw;
+	hwif->INSW  = mm_insw;
+	hwif->OUTSL = NULL;
+	hwif->INSL  = NULL;
 }
 
 static int __init h8300_ide_init(void)
diff -puN drivers/ide/ide-iops.c~revert-ide-mm-ide-remove-inswl-and-outswl-methods drivers/ide/ide-iops.c
--- a/drivers/ide/ide-iops.c~revert-ide-mm-ide-remove-inswl-and-outswl-methods
+++ a/drivers/ide/ide-iops.c
@@ -42,6 +42,16 @@ static u16 ide_inw (unsigned long port)
 	return (u16) inw(port);
 }
 
+static void ide_insw (unsigned long port, void *addr, u32 count)
+{
+	insw(port, addr, count);
+}
+
+static void ide_insl (unsigned long port, void *addr, u32 count)
+{
+	insl(port, addr, count);
+}
+
 static void ide_outb (u8 val, unsigned long port)
 {
 	outb(val, port);
@@ -57,13 +67,27 @@ static void ide_outw (u16 val, unsigned 
 	outw(val, port);
 }
 
+static void ide_outsw (unsigned long port, void *addr, u32 count)
+{
+	outsw(port, addr, count);
+}
+
+static void ide_outsl (unsigned long port, void *addr, u32 count)
+{
+	outsl(port, addr, count);
+}
+
 void default_hwif_iops (ide_hwif_t *hwif)
 {
 	hwif->OUTB	= ide_outb;
 	hwif->OUTBSYNC	= ide_outbsync;
 	hwif->OUTW	= ide_outw;
+	hwif->OUTSW	= ide_outsw;
+	hwif->OUTSL	= ide_outsl;
 	hwif->INB	= ide_inb;
 	hwif->INW	= ide_inw;
+	hwif->INSW	= ide_insw;
+	hwif->INSL	= ide_insl;
 }
 
 /*
@@ -80,6 +104,16 @@ static u16 ide_mm_inw (unsigned long por
 	return (u16) readw((void __iomem *) port);
 }
 
+static void ide_mm_insw (unsigned long port, void *addr, u32 count)
+{
+	__ide_mm_insw((void __iomem *) port, addr, count);
+}
+
+static void ide_mm_insl (unsigned long port, void *addr, u32 count)
+{
+	__ide_mm_insl((void __iomem *) port, addr, count);
+}
+
 static void ide_mm_outb (u8 value, unsigned long port)
 {
 	writeb(value, (void __iomem *) port);
@@ -95,6 +129,16 @@ static void ide_mm_outw (u16 value, unsi
 	writew(value, (void __iomem *) port);
 }
 
+static void ide_mm_outsw (unsigned long port, void *addr, u32 count)
+{
+	__ide_mm_outsw((void __iomem *) port, addr, count);
+}
+
+static void ide_mm_outsl (unsigned long port, void *addr, u32 count)
+{
+	__ide_mm_outsl((void __iomem *) port, addr, count);
+}
+
 void default_hwif_mmiops (ide_hwif_t *hwif)
 {
 	hwif->OUTB	= ide_mm_outb;
@@ -102,8 +146,12 @@ void default_hwif_mmiops (ide_hwif_t *hw
 	   this one is controller specific! */
 	hwif->OUTBSYNC	= ide_mm_outbsync;
 	hwif->OUTW	= ide_mm_outw;
+	hwif->OUTSW	= ide_mm_outsw;
+	hwif->OUTSL	= ide_mm_outsl;
 	hwif->INB	= ide_mm_inb;
 	hwif->INW	= ide_mm_inw;
+	hwif->INSW	= ide_mm_insw;
+	hwif->INSL	= ide_mm_insl;
 }
 
 EXPORT_SYMBOL(default_hwif_mmiops);
@@ -155,39 +203,24 @@ static void ata_input_data(ide_drive_t *
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	unsigned long data_addr = io_ports->data_addr;
 	u8 io_32bit = drive->io_32bit;
-	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 
 	len++;
 
 	if (io_32bit) {
-		unsigned long uninitialized_var(flags);
-
 		if (io_32bit & 2) {
+			unsigned long flags;
+
 			local_irq_save(flags);
 			ata_vlb_sync(drive, io_ports->nsect_addr);
-		}
-
-		if (mmio)
-			__ide_mm_insl((void __iomem *)data_addr, buf, len / 4);
-		else
-			insl(data_addr, buf, len / 4);
-
-		if (io_32bit & 2)
+			hwif->INSL(data_addr, buf, len / 4);
 			local_irq_restore(flags);
+		} else
+			hwif->INSL(data_addr, buf, len / 4);
 
-		if ((len & 3) >= 2) {
-			if (mmio)
-				__ide_mm_insw((void __iomem *)data_addr,
-						(u8 *)buf + (len & ~3), 1);
-			else
-				insw(data_addr, (u8 *)buf + (len & ~3), 1);
-		}
-	} else {
-		if (mmio)
-			__ide_mm_insw((void __iomem *)data_addr, buf, len / 2);
-		else
-			insw(data_addr, buf, len / 2);
-	}
+		if ((len & 3) >= 2)
+			hwif->INSW(data_addr, (u8 *)buf + (len & ~3), 1);
+	} else
+		hwif->INSW(data_addr, buf, len / 2);
 }
 
 /*
@@ -200,37 +233,22 @@ static void ata_output_data(ide_drive_t 
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	unsigned long data_addr = io_ports->data_addr;
 	u8 io_32bit = drive->io_32bit;
-	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 
 	if (io_32bit) {
-		unsigned long uninitialized_var(flags);
-
 		if (io_32bit & 2) {
+			unsigned long flags;
+
 			local_irq_save(flags);
 			ata_vlb_sync(drive, io_ports->nsect_addr);
-		}
-
-		if (mmio)
-			__ide_mm_outsl((void __iomem *)data_addr, buf, len / 4);
-		else
-			outsl(data_addr, buf, len / 4);
-
-		if (io_32bit & 2)
+			hwif->OUTSL(data_addr, buf, len / 4);
 			local_irq_restore(flags);
+		} else
+			hwif->OUTSL(data_addr, buf, len / 4);
 
-		if ((len & 3) >= 2) {
-			if (mmio)
-				__ide_mm_outsw((void __iomem *)data_addr,
-						 (u8 *)buf + (len & ~3), 1);
-			else
-				outsw(data_addr, (u8 *)buf + (len & ~3), 1);
-		}
-	} else {
-		if (mmio)
-			__ide_mm_outsw((void __iomem *)data_addr, buf, len / 2);
-		else
-			outsw(data_addr, buf, len / 2);
-	}
+		if ((len & 3) >= 2)
+			hwif->OUTSW(data_addr, (u8 *)buf + (len & ~3), 1);
+	} else
+		hwif->OUTSW(data_addr, buf, len / 2);
 }
 
 void default_hwif_transport(ide_hwif_t *hwif)
diff -puN drivers/ide/mips/au1xxx-ide.c~revert-ide-mm-ide-remove-inswl-and-outswl-methods drivers/ide/mips/au1xxx-ide.c
--- a/drivers/ide/mips/au1xxx-ide.c~revert-ide-mm-ide-remove-inswl-and-outswl-methods
+++ a/drivers/ide/mips/au1xxx-ide.c
@@ -613,6 +613,9 @@ static int au_ide_probe(struct device *d
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA	
 	hwif->input_data  = au1xxx_input_data;
 	hwif->output_data = au1xxx_output_data;
+
+	hwif->INSW                      = auide_insw;
+	hwif->OUTSW                     = auide_outsw;
 #endif
 	hwif->select_data               = 0;    /* no chipset-specific code */
 	hwif->config_data               = 0;    /* no chipset-specific code */
diff -puN drivers/ide/pci/scc_pata.c~revert-ide-mm-ide-remove-inswl-and-outswl-methods drivers/ide/pci/scc_pata.c
--- a/drivers/ide/pci/scc_pata.c~revert-ide-mm-ide-remove-inswl-and-outswl-methods
+++ a/drivers/ide/pci/scc_pata.c
@@ -624,9 +624,13 @@ static void __devinit init_mmio_iops_scc
 
 	hwif->INB = scc_ide_inb;
 	hwif->INW = scc_ide_inw;
+	hwif->INSW = scc_ide_insw;
+	hwif->INSL = scc_ide_insl;
 	hwif->OUTB = scc_ide_outb;
 	hwif->OUTBSYNC = scc_ide_outbsync;
 	hwif->OUTW = scc_ide_outw;
+	hwif->OUTSW = scc_ide_outsw;
+	hwif->OUTSL = scc_ide_outsl;
 
 	io_ports->data_addr	= dma_base + 0x20;
 	io_ports->error_addr	= dma_base + 0x24;
diff -puN include/linux/ide.h~revert-ide-mm-ide-remove-inswl-and-outswl-methods include/linux/ide.h
--- a/include/linux/ide.h~revert-ide-mm-ide-remove-inswl-and-outswl-methods
+++ a/include/linux/ide.h
@@ -480,9 +480,13 @@ typedef struct hwif_s {
 	void (*OUTB)(u8 addr, unsigned long port);
 	void (*OUTBSYNC)(ide_drive_t *drive, u8 addr, unsigned long port);
 	void (*OUTW)(u16 addr, unsigned long port);
+	void (*OUTSW)(unsigned long port, void *addr, u32 count);
+	void (*OUTSL)(unsigned long port, void *addr, u32 count);
 
 	u8  (*INB)(unsigned long port);
 	u16 (*INW)(unsigned long port);
+	void (*INSW)(unsigned long port, void *addr, u32 count);
+	void (*INSL)(unsigned long port, void *addr, u32 count);
 
 	/* dma physical region descriptor table (cpu view) */
 	unsigned int	*dmatable_cpu;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
es1968-fix-sleep-while-holding-lock-bug.patch
include-asm-alpha-semaphoreh-use-static-inline-on-inlines.patch
revert-x86-fix-call-to-set_cyc2ns_scale-from-time_cpufreq_notifier.patch
revert-set-relay-file-can-not-be-read-by-pread2.patch
git-acpi.patch
git-acpi-revert-suspend-wakeup-code-in-c.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-x86.patch
arch-x86-mm-ioremapc-fix-printk-warnings.patch
git-x86-fix-warning-in-arch-x86-kernel-vsmp_64c.patch
git-kgdb-light.patch
git-x86-hack-around-to-make-git-kgdb-build.patch
git-x86-vs-git-kgdb-lite.patch
git-alsa-tiwai.patch
es1968-fix-jitter-on-some-maestro-cards-checkpatch-fixes.patch
git-agpgart-export-agp_generic_alloc_pages.patch
git-agpgart-fix-type-confusion.patch
git-agpgart-drivers-char-agp-i460-agpc-hacks.patch
cifs-suppress-warning.patch
git-powerpc.patch
pm-remove-destroy_suspended_device.patch
scsi-add-iscsi-ibft-support.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7-fix.patch
pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type-rev-3-fix.patch
git-dvb.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-dlm-vs-git-gfs2-nwm.patch
git-hid.patch
git-hrt.patch
time-close-small-window-for-vsyscall-time-inconsistencies-checkpatch-fixes.patch
arch-ia64-kernel-use-time_-macros.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-vs-gregkh-driver-ib-convert-struct-class_device-to-struct-device.patch
gregkh-driver-ib-convert-struct-class_device-to-struct-device-vs-git-infiniband.patch
maple-add-driver-for-sega-dreamcast-controller.patch
touch-screen-driver-for-the-superh-migor-board-checkpatch-fixes.patch
git-leds.patch
git-libata-all.patch
drivers-ata-sata_fslc-fix-warnings-small-memory-leak.patch
revert-ide-mm-ide-remove-inswl-and-outswl-methods.patch
git-async-tx.patch
git-mips.patch
git-net.patch
net-ipv6-ip6_inputc-fix-a-couple-of-warnings.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
ehea-fix-dlpar-memory-add-support-fix.patch
sundance-set-carrier-status-on-link-change-events-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
git-nfsd.patch
git-ocfs2.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
revert-gregkh-pci-pci-arm-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-cris-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-frv-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mips-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mn10300-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-parisc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-ppc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sh-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-v850-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-xtensa-use-generic-pci_enable_resources.patch
pci-hotplug-introduce-pci_slot-fix.patch
pci-hotplug-introduce-pci_slot-fix-fix.patch
pci-hotplug-introduce-pci_slot-fix-2.patch
pci-hotplug-introduce-pci_slot-fix-99.patch
pci-hotplug-acpi-pci-slot-detection-driver-fix.patch
drivers-acpi-pci_slotc-fix-build-with-config_dmi=n.patch
git-s390.patch
git-sched.patch
git-sh.patch
sh-arch-sh-kernel-traps_32c-needs-asm-fpuh.patch
git-scsi-misc.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device-fix.patch
scsi-fix-section-mismatch-in-aic94xx.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
git-block-git-rejects.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
git-v9fs.patch
git-vfs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
xfs-suppress-uninitialized-var-warnings.patch
git-cryptodev-misplaced-hunk.patch
git-cryptodev-fix-conflict.patch
git-cryptodev-fix-conflict-hack.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
git-semaphore-vs-git-x86.patch
git-semaphore-git-rejects.patch
ext4-is-busted-on-m68k.patch
smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries-sneak-in-a-coding-style-fix.patch
mm-introduce-pte_special-pte-bit-fix.patch
hugetlb-vmstat-events-for-huge-page-allocations-cleanup.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
codafs-fix-build-warning.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
lib-swiotlbc-cleanups.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
drivers-acpi-thermalc-fix-build-with-config_dmi=n.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-convert-stub-functions-from-macros-into-inlines.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-add-power-management-functionality-fix.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
fat_valid_media-remove-pointless-test.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-add-definitions-of-ushort_max-and-others-checkpatch-fixes.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
sxc-fix-printk-warnings-on-sparc32.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
proc-switch-to-proc_create.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
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
profile-likely-unlikely-macros-fix.patch
w1-build-fix.patch

