From: akpm@linux-foundation.org
Subject: + arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch added to -mm tree
Date: Mon, 28 Jul 2008 22:38:40 -0700
Message-ID: <200807290538.m6T5cece016626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746AbYG2FjK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 01:39:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     arch/x86/pci/irq.c: attempt to clean up code layout
has been added to the -mm tree.  Its filename is
     arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1041,35 +1041,44 @@ static void __init pcibios_fixup_irqs(vo
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
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
include-asm-generic-pgtable-nopmdh-macros-are-noxious-reason-435.patch
introduce-down_try-so-we-can-move-away-from-down_trylock-checkpatch-fixes.patch
drivers-char-pcmcia-ipwireless-networkc-build-fix.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
linux-next-rejects.patch
next-remove-localversion.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
pci-make-pci_register_driver-a-macro.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
git-jg-misc.patch
git-ubi-git-rejects.patch
bridge-send-correct-mtu-value-in-pmtu-checkpatch-fixes.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
git-block-git-rejects.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
drivers-net-wireless-iwlwifi-iwl-ledc-printk-fix.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
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
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
gru-driver-v3-hardware-data-structures-fix.patch
gru-driver-v3-hardware-data-structures-fix-fix.patch
gru-driver-v3-fixes-to-resolve-code-review-comments-checkpatch-fixes.patch
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

