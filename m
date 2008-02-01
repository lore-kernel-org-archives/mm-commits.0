From: akpm@linux-foundation.org
Subject: - revert-gregkh-pci-pci-use-dev_printk-in-x86-quirk-messages.patch removed from -mm tree
Date: Fri, 01 Feb 2008 13:07:14 -0800
Message-ID: <200802012107.m11L7Efs031238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54361 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759657AbYBAVHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 16:07:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     revert gregkh-pci-pci-use-dev_printk-in-x86-quirk-messages
has been removed from the -mm tree.  Its filename was
     revert-gregkh-pci-pci-use-dev_printk-in-x86-quirk-messages.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert gregkh-pci-pci-use-dev_printk-in-x86-quirk-messages
From: Andrew Morton <akpm@linux-foundation.org>

Please do not put x86 patches into the driver tree any more at all, ever.

Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/quirks.c |   43 +++++++++++++++++--------------------
 arch/x86/pci/fixup.c     |   22 +++++++++---------
 2 files changed, 31 insertions(+), 34 deletions(-)

diff -puN arch/x86/kernel/quirks.c~revert-gregkh-pci-pci-use-dev_printk-in-x86-quirk-messages arch/x86/kernel/quirks.c
--- a/arch/x86/kernel/quirks.c~revert-gregkh-pci-pci-use-dev_printk-in-x86-quirk-messages
+++ a/arch/x86/kernel/quirks.c
@@ -30,8 +30,8 @@ static void __devinit quirk_intel_irqbal
 	raw_pci_ops->read(0, 0, 0x40, 0x4c, 2, &word);
 
 	if (!(word & (1 << 13))) {
-		dev_info(&dev->dev, "Intel E7520/7320/7525 detected; "
-			"disabling irq balancing and affinity\n");
+		printk(KERN_INFO "Intel E7520/7320/7525 detected. "
+			"Disabling irq balancing and affinity\n");
 #ifdef CONFIG_IRQBALANCE
 		irqbalance_disable("");
 #endif
@@ -104,16 +104,14 @@ static void ich_force_enable_hpet(struct
 	pci_read_config_dword(dev, 0xF0, &rcba);
 	rcba &= 0xFFFFC000;
 	if (rcba == 0) {
-		dev_printk(KERN_DEBUG, &dev->dev, "RCBA disabled; "
-			"cannot force enable HPET\n");
+		printk(KERN_DEBUG "RCBA disabled. Cannot force enable HPET\n");
 		return;
 	}
 
 	/* use bits 31:14, 16 kB aligned */
 	rcba_base = ioremap_nocache(rcba, 0x4000);
 	if (rcba_base == NULL) {
-		dev_printk(KERN_DEBUG, &dev->dev, "ioremap failed; "
-			"cannot force enable HPET\n");
+		printk(KERN_DEBUG "ioremap failed. Cannot force enable HPET\n");
 		return;
 	}
 
@@ -124,8 +122,8 @@ static void ich_force_enable_hpet(struct
 		/* HPET is enabled in HPTC. Just not reported by BIOS */
 		val = val & 0x3;
 		force_hpet_address = 0xFED00000 | (val << 12);
-		dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at "
-			"0x%lx\n", force_hpet_address);
+		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
+			       force_hpet_address);
 		iounmap(rcba_base);
 		return;
 	}
@@ -144,12 +142,11 @@ static void ich_force_enable_hpet(struct
 	if (err) {
 		force_hpet_address = 0;
 		iounmap(rcba_base);
-		dev_printk(KERN_DEBUG, &dev->dev,
-			"Failed to force enable HPET\n");
+		printk(KERN_DEBUG "Failed to force enable HPET\n");
 	} else {
 		force_hpet_resume_type = ICH_FORCE_HPET_RESUME;
-		dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at "
-			"0x%lx\n", force_hpet_address);
+		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
+			       force_hpet_address);
 	}
 }
 
@@ -209,8 +206,8 @@ static void old_ich_force_enable_hpet(st
 	if (val & 0x4) {
 		val &= 0x3;
 		force_hpet_address = 0xFED00000 | (val << 12);
-		dev_printk(KERN_DEBUG, &dev->dev, "HPET at 0x%lx\n",
-			force_hpet_address);
+		printk(KERN_DEBUG "HPET at base address 0x%lx\n",
+			       force_hpet_address);
 		return;
 	}
 
@@ -230,14 +227,14 @@ static void old_ich_force_enable_hpet(st
 		/* HPET is enabled in HPTC. Just not reported by BIOS */
 		val &= 0x3;
 		force_hpet_address = 0xFED00000 | (val << 12);
-		dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at "
-			"0x%lx\n", force_hpet_address);
+		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
+			       force_hpet_address);
 		cached_dev = dev;
 		force_hpet_resume_type = OLD_ICH_FORCE_HPET_RESUME;
 		return;
 	}
 
-	dev_printk(KERN_DEBUG, &dev->dev, "Failed to force enable HPET\n");
+	printk(KERN_DEBUG "Failed to force enable HPET\n");
 }
 
 /*
@@ -295,8 +292,8 @@ static void vt8237_force_enable_hpet(str
 	 */
 	if (val & 0x80) {
 		force_hpet_address = (val & ~0x3ff);
-		dev_printk(KERN_DEBUG, &dev->dev, "HPET at 0x%lx\n",
-			force_hpet_address);
+		printk(KERN_DEBUG "HPET at base address 0x%lx\n",
+			       force_hpet_address);
 		return;
 	}
 
@@ -310,14 +307,14 @@ static void vt8237_force_enable_hpet(str
 	pci_read_config_dword(dev, 0x68, &val);
 	if (val & 0x80) {
 		force_hpet_address = (val & ~0x3ff);
-		dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at "
-			"0x%lx\n", force_hpet_address);
+		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
+			       force_hpet_address);
 		cached_dev = dev;
 		force_hpet_resume_type = VT8237_FORCE_HPET_RESUME;
 		return;
 	}
 
-	dev_printk(KERN_DEBUG, &dev->dev, "Failed to force enable HPET\n");
+	printk(KERN_DEBUG "Failed to force enable HPET\n");
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8235,
@@ -345,7 +342,7 @@ static void nvidia_force_enable_hpet(str
 	pci_read_config_dword(dev, 0x44, &val);
 	force_hpet_address = val & 0xfffffffe;
 	force_hpet_resume_type = NVIDIA_FORCE_HPET_RESUME;
-	dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at 0x%lx\n",
+	printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
 		force_hpet_address);
 	cached_dev = dev;
 	return;
diff -puN arch/x86/pci/fixup.c~revert-gregkh-pci-pci-use-dev_printk-in-x86-quirk-messages arch/x86/pci/fixup.c
--- a/arch/x86/pci/fixup.c~revert-gregkh-pci-pci-use-dev_printk-in-x86-quirk-messages
+++ a/arch/x86/pci/fixup.c
@@ -17,7 +17,7 @@ static void __devinit pci_fixup_i450nx(s
 	int pxb, reg;
 	u8 busno, suba, subb;
 
-	dev_warn(&d->dev, "Searching for i450NX host bridges\n");
+	printk(KERN_WARNING "PCI: Searching for i450NX host bridges on %s\n", pci_name(d));
 	reg = 0xd0;
 	for(pxb=0; pxb<2; pxb++) {
 		pci_read_config_byte(d, reg++, &busno);
@@ -41,7 +41,7 @@ static void __devinit pci_fixup_i450gx(s
 	 */
 	u8 busno;
 	pci_read_config_byte(d, 0x4a, &busno);
-	dev_info(&d->dev, "i440KX/GX host bridge; secondary bus %02x\n", busno);
+	printk(KERN_INFO "PCI: i440KX/GX host bridge %s: secondary bus %02x\n", pci_name(d), busno);
 	pci_scan_bus_with_sysdata(busno);
 	pcibios_last_bus = -1;
 }
@@ -55,7 +55,7 @@ static void __devinit  pci_fixup_umc_ide
 	 */
 	int i;
 
-	dev_warn(&d->dev, "Fixing base address flags\n");
+	printk(KERN_WARNING "PCI: Fixing base address flags for device %s\n", pci_name(d));
 	for(i=0; i<4; i++)
 		d->resource[i].flags |= PCI_BASE_ADDRESS_SPACE_IO;
 }
@@ -68,7 +68,7 @@ static void __devinit  pci_fixup_ncr53c8
 	 * Fix class to be PCI_CLASS_STORAGE_SCSI
 	 */
 	if (!d->class) {
-		dev_warn(&d->dev, "Fixing NCR 53C810 class code\n");
+		printk(KERN_WARNING "PCI: fixing NCR 53C810 class code for %s\n", pci_name(d));
 		d->class = PCI_CLASS_STORAGE_SCSI << 8;
 	}
 }
@@ -80,7 +80,7 @@ static void __devinit  pci_fixup_latency
 	 *  SiS 5597 and 5598 chipsets require latency timer set to
 	 *  at most 32 to avoid lockups.
 	 */
-	dev_dbg(&d->dev, "Setting max latency to 32\n");
+	DBG("PCI: Setting max latency to 32\n");
 	pcibios_max_latency = 32;
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_5597, pci_fixup_latency);
@@ -138,7 +138,7 @@ static void pci_fixup_via_northbridge_bu
 
 	pci_read_config_byte(d, where, &v);
 	if (v & ~mask) {
-		dev_warn(&d->dev, "Disabling VIA memory write queue (PCI ID %04x, rev %02x): [%02x] %02x & %02x -> %02x\n", \
+		printk(KERN_WARNING "Disabling VIA memory write queue (PCI ID %04x, rev %02x): [%02x] %02x & %02x -> %02x\n", \
 			d->device, d->revision, where, v, mask, v & mask);
 		v &= mask;
 		pci_write_config_byte(d, where, v);
@@ -200,7 +200,7 @@ static void pci_fixup_nforce2(struct pci
 	 * Apply fixup if needed, but don't touch disconnect state
 	 */
 	if ((val & 0x00FF0000) != 0x00010000) {
-		dev_warn(&dev->dev, "nForce2 C1 Halt Disconnect fixup\n");
+		printk(KERN_WARNING "PCI: nForce2 C1 Halt Disconnect fixup\n");
 		pci_write_config_dword(dev, 0x6c, (val & 0xFF00FFFF) | 0x00010000);
 	}
 }
@@ -348,7 +348,7 @@ static void __devinit pci_fixup_video(st
 	pci_read_config_word(pdev, PCI_COMMAND, &config);
 	if (config & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY)) {
 		pdev->resource[PCI_ROM_RESOURCE].flags |= IORESOURCE_ROM_SHADOW;
-		dev_printk(KERN_DEBUG, &pdev->dev, "Boot video device\n");
+		printk(KERN_DEBUG "Boot video device is %s\n", pci_name(pdev));
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, pci_fixup_video);
@@ -388,11 +388,11 @@ static void __devinit pci_fixup_msi_k8t_
 		/* verify the change for status output */
 		pci_read_config_byte(dev, 0x50, &val);
 		if (val & 0x40)
-			dev_info(&dev->dev, "Detected MSI K8T Neo2-FIR; "
+			printk(KERN_INFO "PCI: Detected MSI K8T Neo2-FIR, "
 					"can't enable onboard soundcard!\n");
 		else
-			dev_info(&dev->dev, "Detected MSI K8T Neo2-FIR; "
-					"enabled onboard soundcard\n");
+			printk(KERN_INFO "PCI: Detected MSI K8T Neo2-FIR, "
+					"enabled onboard soundcard.\n");
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8237,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration-checkpatch-fixes.patch
timerfd-v3-new-timerfd-api-ia64-fix.patch
timerfd-v3-new-timerfd-api-m68k-fix.patch
timerfd-v3-new-timerfd-api-mips-fix.patch
timerfd-v3-new-timerfd-api-arch-fixes.patch
timerfd-v3-new-timerfd-api-powerpc-fix.patch
timerfd-v3-new-timerfd-api-sparc64-fix.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-ignore-acpi-video-devices-that-arent-present-in-hardware-checkpatch-fixes.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
acpi-backlight-reset-brightness-on-resume-checkpatch-fixes.patch
git-alsa.patch
git-alsa-disable-sound-pci-ice1712-ice1724c.patch
git-agpgart.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-audit-master.patch
git-audit-printk-warning-fix.patch
git-cpufreq.patch
revert-agk-dm-dm-loop.patch
include-asm-powerpc-nvramh-needs-listh.patch
include-asm-powerpc-nvramh-needs-listh-fix.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
drivers-media-video-em28xx-em28xx-corec-fix-use-of-potentially-uninitialized-variable.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip-fix.patch
revert-git-hrt.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
drivers-ide-ide-acpic-fix-uninitialized-var-warning.patch
drivers-ide-legacy-hdc-fix-uninitialized-var-warning.patch
git-md-accel.patch
memstick-initial-commit-for-sony-memorystick-support-fix-2.patch
git-mmc.patch
git-mtd.patch
drivers-mtd-ubi-wlc-fix-uninitialized-var-warning.patch
drivers-mtd-ubi-scanc-fix-uninitialized-var-warning.patch
drivers-mtd-ubi-cdevc-unused-var.patch
git-netdev-all-fix-conflicts-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-backlight.patch
git-battery.patch
bluetooth-uninlining.patch
git-nfsd.patch
git-selinux-vs-git-lblnet.patch
serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh-checkpatch-fixes.patch
revert-gregkh-pci-pci-use-dev_printk-in-x86-quirk-messages.patch
fix-gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform-checkpatch-fixes.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
git-scsi-misc-vs-gregkh-pci-pci-remove-users-of-pci_enable_device_bars.patch
scsi-fix-isa-pcmcia-compile-problem-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes-checkpatch-fixes.patch
drivers-scsi-dc395xc-fix-uninitialized-var-warning.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fixes.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
git-watchdog.patch
git-watchdog-fixup.patch
git-ipwireless_cs.patch
revert-kvm-stuff-to-make-git-x86-apply.patch
git-x86.patch
git-x86-fixup.patch
git-x86-vs-pm-acquire-device-locks-on-suspend-rev-3.patch
git-x86-fix-doubly-merged-patch.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
pci-dont-load-acpi_php-when-acpi-is-disabled-fix.patch
x86-mmconf-enable-mcfg-early-cleanup.patch
git-newsetup.patch
git-xtensa.patch
add-iscsi-ibft-support-v046-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
vmalloc-add-const-to-void-parameters-fix.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-add-proc-kpagecount-interface-fix.patch
maps4-add-proc-kpageflags-interface-fix.patch
maps4-add-proc-kpageflags-interface-fix-2-fix.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
mm-page-writeback-highmem_is_dirtyable-option-fix.patch
mm-remove-fastcall-from-mm-checkpatch-fixes.patch
page-migraton-handle-orphaned-pages-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-fix.patch
alpha-atomic_add_return-should-return-int.patch
alpha-fix-warning-by-fixing-flush_tlb_kernel_range.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
kernel-printkc-concerns-about-the-console-handover.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
read_current_time-cleanups.patch
read_current_time-cleanups-build-fix-fix.patch
address-hfs-on-disk-corruption-robustness-review-comments.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
stopmachine-semaphore-to-mutex-fix.patch
parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard-fix.patch
debug_smp_processor_id-fixlets.patch
use-ilog2-in-fs-namespacec-fix.patch
export-iov_shorten-for-ext4s-use-fix.patch
system-timer-fix-crash-in-100hz-system-timer-cleanup.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
add-have_oprofile.patch
drivers-isdn-hardware-eicon-debugc-fix-uninitialized-var-warning.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
neofb-avoid-overwriting-fb_info-fields.patch
vermilionc-use-align-not-__align_mask.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
jbd-remove-useless-loop-in-journal_write_commit_record-checkpatch-fixes.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files-oops-fix.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
cpusets-update_cpumask-revision-fix.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
modules-make-module_address_lookup-safe-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
rcu-split-listh-and-move-rcu-protected-lists-into-rculisth-checkpatch-fixes.patch
char-applicom-use-pci_match_id-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
