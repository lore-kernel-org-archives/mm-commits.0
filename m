From: akpm@osdl.org
Subject: - igafb-switch-to-pci_get-api.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:13:04 -0800
Message-ID: <200612082013.kB8KD458003058@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59473 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946746AbWLHUNW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:13:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, adaplas@pol.net, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     igafb: switch to pci_get API
has been removed from the -mm tree.  Its filename was
     igafb-switch-to-pci_get-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: igafb: switch to pci_get API
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/igafb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/igafb.c~igafb-switch-to-pci_get-api drivers/video/igafb.c
--- a/drivers/video/igafb.c~igafb-switch-to-pci_get-api
+++ a/drivers/video/igafb.c
@@ -384,19 +384,21 @@ int __init igafb_init(void)
         if (!con_is_present())
                 return -ENXIO;
 
-        pdev = pci_find_device(PCI_VENDOR_ID_INTERG, 
+        pdev = pci_get_device(PCI_VENDOR_ID_INTERG,
                                PCI_DEVICE_ID_INTERG_1682, 0);
 	if (pdev == NULL) {
 		/*
 		 * XXX We tried to use cyber2000fb.c for IGS 2000.
 		 * But it does not initialize the chip in JavaStation-E, alas.
 		 */
-        	pdev = pci_find_device(PCI_VENDOR_ID_INTERG, 0x2000, 0);
+        	pdev = pci_get_device(PCI_VENDOR_ID_INTERG, 0x2000, 0);
         	if(pdev == NULL) {
         	        return -ENXIO;
 		}
 		iga2000 = 1;
 	}
+	/* We leak a reference here but as it cannot be unloaded this is
+	   fine. If you write unload code remember to free it in unload */
 	
 	size = sizeof(struct fb_info) + sizeof(struct iga_par) + sizeof(u32)*16;
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
igafb-switch-to-pci_get-api.patch
tty-switch-to-ktermios-nozomi-fix.patch
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
ide-cd-handle-strange-interrupt-on-the-intel-esb2.patch

