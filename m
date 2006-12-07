From: akpm@osdl.org
Subject: - alpha-switch-to-pci_get-api.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:58:55 -0800
Message-ID: <200612072258.kB7MwtqO029441@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50884 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163665AbWLGW7O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: switch to pci_get API
has been removed from the -mm tree.  Its filename was
     alpha-switch-to-pci_get-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: alpha: switch to pci_get API
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Now that we have pci_get_bus_and_slot we can do the job correctly.  Note that
some of these calls intentionally leak a device - this is because the device
in question is always needed from boot to reboot.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/alpha/kernel/pci.c          |    3 ++-
 arch/alpha/kernel/sys_miata.c    |   10 +++++++---
 arch/alpha/kernel/sys_nautilus.c |    2 +-
 3 files changed, 10 insertions(+), 5 deletions(-)

diff -puN arch/alpha/kernel/pci.c~alpha-switch-to-pci_get-api arch/alpha/kernel/pci.c
--- a/arch/alpha/kernel/pci.c~alpha-switch-to-pci_get-api
+++ a/arch/alpha/kernel/pci.c
@@ -516,10 +516,11 @@ sys_pciconfig_iobase(long which, unsigne
 		if (bus == 0 && dfn == 0) {
 			hose = pci_isa_hose;
 		} else {
-			dev = pci_find_slot(bus, dfn);
+			dev = pci_get_bus_and_slot(bus, dfn);
 			if (!dev)
 				return -ENODEV;
 			hose = dev->sysdata;
+			pci_dev_put(dev);
 		}
 	}
 
diff -puN arch/alpha/kernel/sys_miata.c~alpha-switch-to-pci_get-api arch/alpha/kernel/sys_miata.c
--- a/arch/alpha/kernel/sys_miata.c~alpha-switch-to-pci_get-api
+++ a/arch/alpha/kernel/sys_miata.c
@@ -183,11 +183,15 @@ miata_map_irq(struct pci_dev *dev, u8 sl
 
 	if((slot == 7) && (PCI_FUNC(dev->devfn) == 3)) {
 		u8 irq=0;
-
-		if(pci_read_config_byte(pci_find_slot(dev->bus->number, dev->devfn & ~(7)), 0x40,&irq)!=PCIBIOS_SUCCESSFUL)
+		struct pci_dev *pdev = pci_get_slot(dev->bus, dev->devfn & ~7);
+		if(pdev == NULL || pci_read_config_byte(pdev, 0x40,&irq) != PCIBIOS_SUCCESSFUL) {
+			pci_dev_put(pdev);
 			return -1;
-		else	
+		}
+		else	{
+			pci_dev_put(pdev);
 			return irq;
+		}
 	}
 
 	return COMMON_TABLE_LOOKUP;
diff -puN arch/alpha/kernel/sys_nautilus.c~alpha-switch-to-pci_get-api arch/alpha/kernel/sys_nautilus.c
--- a/arch/alpha/kernel/sys_nautilus.c~alpha-switch-to-pci_get-api
+++ a/arch/alpha/kernel/sys_nautilus.c
@@ -200,7 +200,7 @@ nautilus_init_pci(void)
 	bus = pci_scan_bus(0, alpha_mv.pci_ops, hose);
 	hose->bus = bus;
 
-	irongate = pci_find_slot(0, 0);
+	irongate = pci_get_bus_and_slot(0, 0);
 	bus->self = irongate;
 	bus->resource[1] = &irongate_mem;
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
ata-fix-platform_device_register_simple-error-check.patch
initializer-entry-defined-twice-in-pata_rz1000.patch
pata_it8213-add-new-driver-for-the-it8213-card.patch
git-mtd.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pci-quirks-fix-the-festering-mess-that-claims-to-handle-ide-quirks-ide-fix.patch
pci-fix-multiple-problems-with-via-hardware.patch
via-sb600-sata-quirk.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
ide-complete-switch-to-pci_get.patch
do_task_stat-dont-take-tty_mutex.patch
mxser-correct-tty-driver-name.patch
pci-mxser-pci-refcounts.patch
mxser-make-an-experimental-clone.patch
char-mxser_new-correct-include-file.patch
char-mxser_new-upgrade-to-191.patch
char-mxser_new-rework-to-allow-dynamic-structs.patch
char-mxser_new-eliminate-tty-ldisc-deref.patch
char-mxser_new-testbit-for-bit-testing.patch
char-mxser_new-correct-fail-paths.patch
char-mxser_new-dont-check-tty_unregister-retval.patch
char-mxser_new-compress-isa-finding.patch
char-mxser_new-register-tty-devices-on-the-fly.patch
char-mxser_new-compact-structures-round2.patch
char-mxser_new-reverse-if-else-paths-patch.patch
char-mxser_new-comments-cleanup.patch
char-mxser_new-correct-intr-handler-proto.patch
char-mxser_new-delete-ttys-and-termios.patch
char-mxser_new-pci-probing.patch
mxser_new-correct-tty-driver-name.patch
char-stallion-use-pr_debug-macro.patch
char-stallion-remove-unneeded-casts.patch
char-stallion-kill-typedefs.patch
char-stallion-move-init-deinit.patch
char-stallion-uninline-functions.patch
char-stallion-mark-functions-as-init.patch
char-stallion-remove-many-prototypes.patch
tty-preparatory-structures-for-termios-revamp.patch
tty-preparatory-structures-for-termios-revamp-strip-fix.patch
tty-switch-to-ktermios-and-new-framework.patch
tty-switch-to-ktermios.patch
tty-switch-to-ktermios-nozomi-fix.patch
tty-switch-to-ktermios-bluetooth-fix.patch
tty-switch-to-ktermios-3270-fix.patch
tty-switch-to-ktermios-uml-fix.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2-update.patch
termios-enable-new-style-termios-ioctls-on-x86-64.patch
char-isicom-use-completion.patch
char-isicom-simplify-timer.patch
char-isicom-remove-cvs-stuff.patch
char-isicom-fix-tty-index-check.patch
char-sx-convert-to-pci-probing.patch
char-sx-use-kcalloc.patch
char-sx-mark-functions-as-devinit.patch
char-sx-use-eisa-probing.patch
char-sx-ifdef-isa-code.patch
char-sx-lock-boards-struct.patch
char-sx-remove-duplicite-code.patch
char-sx-whitespace-cleanup.patch
char-sx-simplify-timer-logic.patch
char-sx-fix-return-in-module-init.patch
char-sx-use-pci_iomap.patch
char-sx-request-regions.patch
char-stallion-convert-to-pci-probing.patch
char-stallion-prints-cleanup.patch
char-stallion-implement-fail-paths.patch
char-stallion-correct-__init-macros.patch
char-stallion-functions-cleanup.patch
char-stallion-fix-fail-paths.patch
char-stallion-brd-struct-locking.patch
char-stallion-remove-syntactic-sugar.patch
char-stallion-variables-cleanup.patch
char-stallion-use-dynamic-dev.patch
char-istallion-convert-to-pci-probing.patch
char-istallion-remove-the-mess.patch
char-istallion-eliminate-typedefs.patch
char-istallion-variables-cleanup.patch
char-istallion-ifdef-eisa-code.patch
char-istallion-brdnr-locking.patch
char-istallion-free-only-isa.patch
char-istallion-correct-fail-paths.patch
char-istallion-fix-enabling.patch
char-istallion-move-init-and-exit-code.patch
char-istallion-change-init-sequence.patch
char-istallion-dynamic-tty-device.patch
char-istallion-use-mod_timer.patch
char-cyclades-save-indent-levels.patch
char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch
ide-hpt3xxn-clocking-fixes.patch
ide-fix-hpt37x-timing-tables.patch
ide-optimize-hpt37x-timing-tables.patch
ide-fix-hpt3xx-hotswap-support.patch
ide-fix-the-case-of-multiple-hpt3xx-chips-present.patch
ide-hpt3xx-fix-pci-clock-detection.patch
ide-hpt3xx-fix-pci-clock-detection-fix-2.patch
piix-fix-82371mx-enablebits.patch
piix-remove-check-for-broken-mw-dma-mode-0.patch
piix-slc90e66-pio-mode-fallback-fix.patch
hpt3xx-rework-rate-filtering.patch
hpt3xx-rework-rate-filtering-tidy.patch
hpt3xx-print-the-real-chip-name-at-startup.patch
hpt3xx-switch-to-using-pci_get_slot.patch
hpt3xx-cache-channels-mcr-address.patch
hpt3x7-merge-speedproc-handlers.patch
hpt370-clean-up-dma-timeout-handling.patch
hpt3xx-init-code-rewrite.patch
ide-more-conversion-to-pci_get-apis.patch
pdc202xx_new-fix-pio-mode-setup.patch
ide-cd-handle-strange-interrupt-on-the-intel-esb2.patch
sl82c105-straighten-up-ide-control-status-register-caching.patch
igafb-switch-to-pci_get-api.patch

