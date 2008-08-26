From: akpm@linux-foundation.org
Subject: - arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:44:41 -0700
Message-ID: <200808261844.m7QIif3j021332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757493AbYHZSpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:45:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     arch/x86/pci/irq.c: attempt to clean up code layout
has been removed from the -mm tree.  Its filename was
     arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/pci/irq.c: attempt to clean up code layout
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/irq.c |   65 ++++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 28 deletions(-)

diff -puN arch/x86/pci/irq.c~arch-x86-pci-irqc-attempt-to-clean-up-code-layout arch/x86/pci/irq.c
--- a/arch/x86/pci/irq.c~arch-x86-pci-irqc-attempt-to-clean-up-code-layout
+++ a/arch/x86/pci/irq.c
@@ -1043,35 +1043,44 @@ static void __init pcibios_fixup_irqs(vo
 		if (io_apic_assign_pci_irqs) {
 			int irq;
 
-			if (pin) {
-				/*
-				 * interrupt pins are numbered starting
-				 * from 1
-				 */
-				pin--;
-				irq = IO_APIC_get_PCI_irq_vector(dev->bus->number,
-					PCI_SLOT(dev->devfn), pin);
-	/*
-	 * Busses behind bridges are typically not listed in the MP-table.
-	 * In this case we have to look up the IRQ based on the parent bus,
-	 * parent slot, and pin number. The SMP code detects such bridged
-	 * busses itself so we should get into this branch reliably.
-	 */
-				if (irq < 0 && dev->bus->parent) { /* go back to the bridge */
-					struct pci_dev *bridge = dev->bus->self;
+			if (!pin)
+				continue;
+
+			/*
+			 * interrupt pins are numbered starting from 1
+			 */
+			pin--;
+			irq = IO_APIC_get_PCI_irq_vector(dev->bus->number,
+				PCI_SLOT(dev->devfn), pin);
+			/*
+			 * Busses behind bridges are typically not listed in the
+			 * MP-table.  In this case we have to look up the IRQ
+			 * based on the parent bus, parent slot, and pin number.
+			 * The SMP code detects such bridged busses itself so we
+			 * should get into this branch reliably.
+			 */
+			if (irq < 0 && dev->bus->parent) {
+				/* go back to the bridge */
+				struct pci_dev *bridge = dev->bus->self;
+				int bus;
 
-					pin = (pin + PCI_SLOT(dev->devfn)) % 4;
-					irq = IO_APIC_get_PCI_irq_vector(bridge->bus->number,
-							PCI_SLOT(bridge->devfn), pin);
-					if (irq >= 0)
-						dev_warn(&dev->dev, "using bridge %s INT %c to get IRQ %d\n",
-							 pci_name(bridge),
-							 'A' + pin, irq);
-				}
-				if (irq >= 0) {
-					dev_info(&dev->dev, "PCI->APIC IRQ transform: INT %c -> IRQ %d\n", 'A' + pin, irq);
-					dev->irq = irq;
-				}
+				pin = (pin + PCI_SLOT(dev->devfn)) % 4;
+				bus = bridge->bus->number;
+				irq = IO_APIC_get_PCI_irq_vector(bus,
+						PCI_SLOT(bridge->devfn), pin);
+				if (irq >= 0)
+					dev_warn(&dev->dev,
+						"using bridge %s INT %c to "
+							"get IRQ %d\n",
+						 pci_name(bridge),
+						 'A' + pin, irq);
+			}
+			if (irq >= 0) {
+				dev_info(&dev->dev,
+					"PCI->APIC IRQ transform: INT %c "
+						"-> IRQ %d\n",
+					'A' + pin, irq);
+				dev->irq = irq;
 			}
 		}
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
vfs-fix-dio-write-returning-eio-when-try_to_release_page-fails-fix.patch
acer-wmi-remove-debugfs-entries-upon-unloading-cleanup.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
fs-sysfs-dirc-remove-unused-__sysfs_get_dentry.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
git-jg-misc.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards-fix.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers.patch
drivers-pci-hotplug-ibmphp_ebdac-list_for_each-to-list_for_each_entry-checkpatch-fixes.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
git-watchdog.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
fix-a-race-condtion-of-oops_in_progress-fix.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
nilfs2-continuous-snapshotting-file-system-fix.patch
nilfs2-continuous-snapshotting-file-system-fix-fix-2.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
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

