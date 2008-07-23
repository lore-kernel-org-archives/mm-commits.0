From: akpm@linux-foundation.org
Subject: + x86-pci-replace-dbg-with-pr_debug-fix-2.patch added to -mm tree
Date: Tue, 22 Jul 2008 17:14:29 -0700
Message-ID: <200807230027.m6N0R4GW026614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750946AbYGWA1e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 20:27:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bjorn.helgaas@hp.com, jbarnes@virtuousgeek.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86-pci-replace-dbg-with-pr_debug-fix-2
has been added to the -mm tree.  Its filename is
     x86-pci-replace-dbg-with-pr_debug-fix-2.patch

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
arm-fix-fls-for-64-bit-arguments.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
pci-make-pci_register_driver-a-macro.patch
drivers-mfd-tc6393xbc-doesnt-compile-on-i386.patch
x86-pci-replace-dbg-with-pr_debug-fix.patch
x86-pci-replace-dbg-with-pr_debug-fix-2.patch
include-asm-generic-pgtable-nopmdh-macros-are-noxious-reason-435.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
git-input-build-fix.patch
git-jg-misc.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
git-kvm.patch
bridge-send-correct-mtu-value-in-pmtu-checkpatch-fixes.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
ftrace-disable-function-tracing-bringing-up-new-cpu-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
spufs-use-the-new-vm_ops-access-fix.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
mapping_set_error-add-unlikely.patch
huge-page-private-reservation-review-cleanups-fix.patch
vma-page-offset-has-no-callees-drop-it.patch
sync_file_range_write-may-and-will-block-document-that-fix.patch
vmallocinfo-add-numa-information-fix.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlb-override-default-huge-page-size-ia64-build.patch
linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-add-debugging-framework-fix.patch
bootmem-clean-up-free_all_bootmem_core-fix.patch
bootmem-free-reserve-helpers-fix.patch
revert-revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-factor-out-the-marking-of-a-pfn-range-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-v850-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-arm-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-mips-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-dvb.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-mtd-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fixes.patch
mmu-notifiers-add-mm_take_all_locks-operation-checkpatch-fixes.patch
mmu-notifier-core-checkpatch-fixes.patch
mmu-notifier-core-fix.patch
mmu-notifier-core-fix-2.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
security-protect-legacy-applications-from-executing-with-insufficient-privilege-checkpatch-fixes.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
build-kernel-profileo-only-when-requested-cleanups.patch
seq_file-fix-bug-when-seq_read-reads-nothing-fix.patch
exec-remove-some-includes-fix.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha.patch
spi-au1550_spi-improve-pio-transfer-mode-checkpatch-fixes.patch
autofs4-use-lookup-intent-flags-to-trigger-mounts-fix.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix-fix.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix-fix-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch
sm501-fixup-allocation-code-to-be-64bit-resource-compliant-sm501-align-panel-fb-to-page_size-fix.patch
lcd-add-platform_lcd-driver-fix.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver.patch
eink_apollofb-new-driver-for-apollo-eink-controller-cleanup.patch
fbcon-remove-stray-semicolons-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup.patch
ext3-handle-corrupted-orphan-list-at-mount-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix.patch
ext3-handle-deleting-corrupted-indirect-blocks-fix.patch
jbd-dont-abort-if-flushing-file-data-failed-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes.patch
devcgroup-code-cleanup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-limit-change-shrink-usage-checkpatch-fixes.patch
coredump-format_corename-fix-the-core_uses_pid-logic-checkpatch-fixes.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-pasemi_mac.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary-checkpatch-fixes.patch
calgary-iommu-use-the-first-kernels-tce-tables-in-kdump-coding-style-fixes.patch
tpm-increase-size-of-internal-tpm-response-buffers-checkpatch-fixes.patch
memstick-allow-set_param-method-to-return-an-error-code-checkpatch-fixes.patch
memstick-use-fully-asynchronous-request-processing-fix.patch
full-conversion-to-early_initcall-interface-remove-old-interface-cleanup.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
define-page_file_cache-function-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-units-fix.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-page-statistics-units-fix.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
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

