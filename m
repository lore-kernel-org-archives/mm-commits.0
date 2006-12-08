From: akpm@osdl.org
Subject: - ide-more-conversion-to-pci_get-apis.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:12:04 -0800
Message-ID: <200612082012.kB8KC4UE002976@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59220 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946659AbWLHUMO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:12:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ide: more conversion to pci_get APIs
has been removed from the -mm tree.  Its filename was
     ide-more-conversion-to-pci_get-apis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ide: more conversion to pci_get APIs
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This completes IDE except for one use which requires a new core PCI function
and will be polished up at the end

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/alim15x3.c     |   16 ++++++++--------
 drivers/ide/pci/pdc202xx_new.c |    7 +++++--
 drivers/ide/pci/sis5513.c      |    3 ++-
 include/asm-i386/ide.h         |    4 +++-
 4 files changed, 18 insertions(+), 12 deletions(-)

diff -puN drivers/ide/pci/alim15x3.c~ide-more-conversion-to-pci_get-apis drivers/ide/pci/alim15x3.c
--- a/drivers/ide/pci/alim15x3.c~ide-more-conversion-to-pci_get-apis
+++ a/drivers/ide/pci/alim15x3.c
@@ -586,11 +586,11 @@ static unsigned int __devinit init_chips
 {
 	unsigned long flags;
 	u8 tmpbyte;
-	struct pci_dev *north = pci_find_slot(0, PCI_DEVFN(0,0));
+	struct pci_dev *north = pci_get_slot(dev->bus, PCI_DEVFN(0,0));
 
 	pci_read_config_byte(dev, PCI_REVISION_ID, &m5229_revision);
 
-	isa_dev = pci_find_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533, NULL);
+	isa_dev = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533, NULL);
 
 #if defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_PROC_FS)
 	if (!ali_proc) {
@@ -613,8 +613,7 @@ static unsigned int __devinit init_chips
 		 * clear bit 7
 		 */
 		pci_write_config_byte(dev, 0x4b, tmpbyte & 0x7F);
-		local_irq_restore(flags);
-		return 0;
+		goto out;
 	}
 
 	/*
@@ -637,10 +636,8 @@ static unsigned int __devinit init_chips
 	 * box without a device at 0:0.0. The ALi bridge will be at
 	 * 0:0.0 so if we didn't find one we know what is cooking.
 	 */
-	if (north && north->vendor != PCI_VENDOR_ID_AL) {
-		local_irq_restore(flags);
-	        return 0;
-	}
+	if (north && north->vendor != PCI_VENDOR_ID_AL)
+		goto out;
 
 	if (m5229_revision < 0xC5 && isa_dev)
 	{	
@@ -661,6 +658,9 @@ static unsigned int __devinit init_chips
 			pci_write_config_byte(isa_dev, 0x79, tmpbyte | 0x02);
 		}
 	}
+out:
+	pci_dev_put(north);
+	pci_dev_put(isa_dev);
 	local_irq_restore(flags);
 	return 0;
 }
diff -puN drivers/ide/pci/pdc202xx_new.c~ide-more-conversion-to-pci_get-apis drivers/ide/pci/pdc202xx_new.c
--- a/drivers/ide/pci/pdc202xx_new.c~ide-more-conversion-to-pci_get-apis
+++ a/drivers/ide/pci/pdc202xx_new.c
@@ -362,6 +362,7 @@ static int __devinit init_setup_pdc20270
 					 ide_pci_device_t *d)
 {
 	struct pci_dev *findev = NULL;
+	int ret;
 
 	if ((dev->bus->self &&
 	     dev->bus->self->vendor == PCI_VENDOR_ID_DEC) &&
@@ -369,14 +370,16 @@ static int __devinit init_setup_pdc20270
 		if (PCI_SLOT(dev->devfn) & 2)
 			return -ENODEV;
 		d->extra = 0;
-		while ((findev = pci_find_device(PCI_ANY_ID, PCI_ANY_ID, findev)) != NULL) {
+		while ((findev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, findev)) != NULL) {
 			if ((findev->vendor == dev->vendor) &&
 			    (findev->device == dev->device) &&
 			    (PCI_SLOT(findev->devfn) & 2)) {
 				if (findev->irq != dev->irq) {
 					findev->irq = dev->irq;
 				}
-				return ide_setup_pci_devices(dev, findev, d);
+				ret = ide_setup_pci_devices(dev, findev, d);
+				pci_dev_put(findev);
+				return ret;
 			}
 		}
 	}
diff -puN drivers/ide/pci/sis5513.c~ide-more-conversion-to-pci_get-apis drivers/ide/pci/sis5513.c
--- a/drivers/ide/pci/sis5513.c~ide-more-conversion-to-pci_get-apis
+++ a/drivers/ide/pci/sis5513.c
@@ -800,9 +800,10 @@ static unsigned int __devinit init_chips
 
 			if (trueid == 0x5517) { /* SiS 961/961B */
 
-				lpc_bridge = pci_find_slot(0x00, 0x10); /* Bus 0, Dev 2, Fn 0 */
+				lpc_bridge = pci_get_slot(dev->bus, 0x10); /* Bus 0, Dev 2, Fn 0 */
 				pci_read_config_byte(lpc_bridge, PCI_REVISION_ID, &sbrev);
 				pci_read_config_byte(dev, 0x49, &prefctl);
+				pci_dev_put(lpc_bridge);
 
 				if (sbrev == 0x10 && (prefctl & 0x80)) {
 					printk(KERN_INFO "SIS5513: SiS 961B MuTIOL IDE UDMA133 controller\n");
diff -puN include/asm-i386/ide.h~ide-more-conversion-to-pci_get-apis include/asm-i386/ide.h
--- a/include/asm-i386/ide.h~ide-more-conversion-to-pci_get-apis
+++ a/include/asm-i386/ide.h
@@ -40,13 +40,14 @@ static __inline__ int ide_default_irq(un
 
 static __inline__ unsigned long ide_default_io_base(int index)
 {
+	struct pci_dev *pdev;
 	/*
 	 *	If PCI is present then it is not safe to poke around
 	 *	the other legacy IDE ports. Only 0x1f0 and 0x170 are
 	 *	defined compatibility mode ports for PCI. A user can 
 	 *	override this using ide= but we must default safe.
 	 */
-	if (pci_find_device(PCI_ANY_ID, PCI_ANY_ID, NULL) == NULL) {
+	if ((pdev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL)) == NULL) {
 		switch(index) {
 			case 2: return 0x1e8;
 			case 3: return 0x168;
@@ -54,6 +55,7 @@ static __inline__ unsigned long ide_defa
 			case 5: return 0x160;
 		}
 	}
+	pci_dev_put(pdev);
 	switch (index) {
 		case 0:	return 0x1f0;
 		case 1:	return 0x170;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
ide-more-conversion-to-pci_get-apis.patch
pdc202xx_new-fix-pio-mode-setup.patch
sl82c105-straighten-up-ide-control-status-register-caching.patch
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

