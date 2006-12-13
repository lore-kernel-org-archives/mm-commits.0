From: akpm@osdl.org
Subject: - ide-complete-switch-to-pci_get.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:51:47 -0800
Message-ID: <200612130651.kBD6pluE030373@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57247 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964968AbWLMGv5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:51:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ide: complete switch to pci_get
has been removed from the -mm tree.  Its filename was
     ide-complete-switch-to-pci_get.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ide: complete switch to pci_get
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The reverse get function allows the final piece of the switching for the old
IDE layer

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/setup-pci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/ide/setup-pci.c~ide-complete-switch-to-pci_get drivers/ide/setup-pci.c
--- a/drivers/ide/setup-pci.c~ide-complete-switch-to-pci_get
+++ a/drivers/ide/setup-pci.c
@@ -844,11 +844,11 @@ void __init ide_scan_pcibus (int scan_di
 
 	pre_init = 0;
 	if (!scan_direction) {
-		while ((dev = pci_find_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+		while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
 			ide_scan_pcidev(dev);
 		}
 	} else {
-		while ((dev = pci_find_device_reverse(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+		while ((dev = pci_get_device_reverse(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
 			ide_scan_pcidev(dev);
 		}
 	}
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
tty-switch-to-ktermios-nozomi-fix.patch
git-libata-all.patch
ata-fix-platform_device_register_simple-error-check.patch
initializer-entry-defined-twice-in-pata_rz1000.patch
git-mtd.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pnx8550-uart-driver.patch
pci-quirks-fix-the-festering-mess-that-claims-to-handle-ide-quirks-ide-fix.patch
via-sb600-sata-quirk.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
xtensa-add-ktermios-and-minor-filename-fix.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
fix-numerous-kcalloc-calls-convert-to-kzalloc.patch
tty-remove-useless-memory-barrier.patch
ide-hpt3xxn-clocking-fixes.patch
ide-fix-hpt37x-timing-tables.patch
ide-optimize-hpt37x-timing-tables.patch
ide-fix-hpt3xx-hotswap-support.patch
ide-fix-the-case-of-multiple-hpt3xx-chips-present.patch
ide-hpt3xx-fix-pci-clock-detection.patch
ide-hpt3xx-fix-pci-clock-detection-fix-2.patch
hpt3xx-rework-rate-filtering.patch
hpt3xx-rework-rate-filtering-tidy.patch
hpt3xx-print-the-real-chip-name-at-startup.patch
hpt3xx-switch-to-using-pci_get_slot.patch
hpt3xx-cache-channels-mcr-address.patch
hpt3x7-merge-speedproc-handlers.patch
hpt370-clean-up-dma-timeout-handling.patch
hpt3xx-init-code-rewrite.patch
piix-fix-82371mx-enablebits.patch
piix-remove-check-for-broken-mw-dma-mode-0.patch
piix-slc90e66-pio-mode-fallback-fix.patch
pdc202xx_new-remove-useless-code.patch
pdc202xx_-remove-check_in_drive_lists-abomination.patch
getting-rid-of-all-casts-of-kalloc-calls.patch

