From: akpm@linux-foundation.org
Subject: - x86-pci-replace-dbg-with-pr_debug-fix-2.patch removed from -mm tree
Date: Mon, 28 Jul 2008 22:31:46 -0700
Message-ID: <200807290531.m6T5Vknw016420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852AbYG2FdF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 01:33:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bjorn.helgaas@hp.com, jbarnes@virtuousgeek.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86-pci-replace-dbg-with-pr_debug-fix-2
has been removed from the -mm tree.  Its filename was
     x86-pci-replace-dbg-with-pr_debug-fix-2.patch

This patch was dropped because it was folded into x86-pci-replace-dbg-with-pr_debug.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86-pci-replace-dbg-with-pr_debug-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/fixup.c |    3 ++-
 arch/x86/pci/irq.c   |   24 ++++++++++++------------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff -puN arch/x86/pci/fixup.c~x86-pci-replace-dbg-with-pr_debug-fix-2 arch/x86/pci/fixup.c
--- a/arch/x86/pci/fixup.c~x86-pci-replace-dbg-with-pr_debug-fix-2
+++ a/arch/x86/pci/fixup.c
@@ -23,7 +23,8 @@ static void __devinit pci_fixup_i450nx(s
 		pci_read_config_byte(d, reg++, &busno);
 		pci_read_config_byte(d, reg++, &suba);
 		pci_read_config_byte(d, reg++, &subb);
-		DBG("i450NX PXB %d: %02x/%02x/%02x\n", pxb, busno, suba, subb);
+		pr_debug("i450NX PXB %d: %02x/%02x/%02x\n",
+				pxb, busno, suba, subb);
 		if (busno)
 			pci_scan_bus_with_sysdata(busno);	/* Bus A */
 		if (suba < subb)
diff -puN arch/x86/pci/irq.c~x86-pci-replace-dbg-with-pr_debug-fix-2 arch/x86/pci/irq.c
--- a/arch/x86/pci/irq.c~x86-pci-replace-dbg-with-pr_debug-fix-2
+++ a/arch/x86/pci/irq.c
@@ -874,7 +874,7 @@ static int pcibios_lookup_irq(struct pci
 	/* Find IRQ pin */
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 	if (!pin) {
-		DBG(KERN_DEBUG " -> no interrupt pin\n");
+		pr_debug(KERN_DEBUG " -> no interrupt pin\n");
 		return 0;
 	}
 	pin = pin - 1;
@@ -884,19 +884,19 @@ static int pcibios_lookup_irq(struct pci
 	if (!pirq_table)
 		return 0;
 
-	DBG(KERN_DEBUG "IRQ for %s[%c]", pci_name(dev), 'A' + pin);
+	pr_debug(KERN_DEBUG "IRQ for %s[%c]", pci_name(dev), 'A' + pin);
 	info = pirq_get_info(dev);
 	if (!info) {
-		DBG(" -> not found in routing table\n" KERN_DEBUG);
+		pr_debug(" -> not found in routing table\n" KERN_DEBUG);
 		return 0;
 	}
 	pirq = info->irq[pin].link;
 	mask = info->irq[pin].bitmap;
 	if (!pirq) {
-		DBG(" -> not routed\n" KERN_DEBUG);
+		pr_debug(" -> not routed\n" KERN_DEBUG);
 		return 0;
 	}
-	DBG(" -> PIRQ %02x, mask %04x, excl %04x", pirq, mask,
+	pr_debug(" -> PIRQ %02x, mask %04x, excl %04x", pirq, mask,
 		pirq_table->exclusive_irqs);
 	mask &= pcibios_irq_mask;
 
@@ -941,31 +941,31 @@ static int pcibios_lookup_irq(struct pci
 				newirq = i;
 		}
 	}
-	DBG(" -> newirq=%d", newirq);
+	pr_debug(" -> newirq=%d", newirq);
 
 	/* Check if it is hardcoded */
 	if ((pirq & 0xf0) == 0xf0) {
 		irq = pirq & 0xf;
-		DBG(" -> hardcoded IRQ %d\n", irq);
+		pr_debug(" -> hardcoded IRQ %d\n", irq);
 		msg = "Hardcoded";
 	} else if (r->get && (irq = r->get(pirq_router_dev, dev, pirq)) && \
 	((!(pci_probe & PCI_USE_PIRQ_MASK)) || ((1 << irq) & mask))) {
-		DBG(" -> got IRQ %d\n", irq);
+		pr_debug(" -> got IRQ %d\n", irq);
 		msg = "Found";
 		eisa_set_level_irq(irq);
 	} else if (newirq && r->set &&
 		(dev->class >> 8) != PCI_CLASS_DISPLAY_VGA) {
-		DBG(" -> assigning IRQ %d", newirq);
+		pr_debug(" -> assigning IRQ %d", newirq);
 		if (r->set(pirq_router_dev, dev, pirq, newirq)) {
 			eisa_set_level_irq(newirq);
-			DBG(" ... OK\n");
+			pr_debug(" ... OK\n");
 			msg = "Assigned";
 			irq = newirq;
 		}
 	}
 
 	if (!irq) {
-		DBG(" ... failed\n");
+		pr_debug(" ... failed\n");
 		if (newirq && mask == (1 << newirq)) {
 			msg = "Guessed";
 			irq = newirq;
@@ -1022,7 +1022,7 @@ static void __init pcibios_fixup_irqs(vo
 		 * already in use.
 		 */
 		if (dev->irq >= 16) {
-			DBG(KERN_DEBUG "%s: ignoring bogus IRQ %d\n",
+			pr_debug(KERN_DEBUG "%s: ignoring bogus IRQ %d\n",
 				pci_name(dev), dev->irq);
 			dev->irq = 0;
 		}
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
x86-pci-replace-dbg-with-pr_debug.patch
x86-pci-replace-dbg-with-pr_debug-fix-2.patch
arch-x86-pci-i386c-fix-printk-warnings.patch
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

