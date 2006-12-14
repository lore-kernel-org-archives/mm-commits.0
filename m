From: akpm@osdl.org
Subject: - ide-fix-the-case-of-multiple-hpt3xx-chips-present.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:18:56 -0800
Message-ID: <200612140618.kBE6Itbr002356@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52991 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbWLNGW1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:22:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, B.Zolnierkiewicz@elka.pw.edu.pl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     ide: fix the case of multiple HPT3xx chips present
has been removed from the -mm tree.  Its filename was
     ide-fix-the-case-of-multiple-hpt3xx-chips-present.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ide: fix the case of multiple HPT3xx chips present
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

init_chipset_hpt366() modifies some fields of the ide_pci_device_t structure
depending on the chip's revision, so pass it a copy of the structure to avoid
issues when multiple different chips are present.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/hpt366.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/ide/pci/hpt366.c~ide-fix-the-case-of-multiple-hpt3xx-chips-present drivers/ide/pci/hpt366.c
--- a/drivers/ide/pci/hpt366.c~ide-fix-the-case-of-multiple-hpt3xx-chips-present
+++ a/drivers/ide/pci/hpt366.c
@@ -72,6 +72,8 @@
  *   table in which the mode lookup is done
  * - fix the hotswap code:  it caused RESET- to glitch when tristating the bus,
  *   and for HPT36x the obsolete HDIO_TRISTATE_HWIF handler was called instead
+ * - pass to init_chipset() handlers a copy of the IDE PCI device structure as
+ *   they tamper with its fields
  *		<source@mvista.com>
  *
  */
@@ -1564,13 +1566,16 @@ static ide_pci_device_t hpt366_chipsets[
  *
  *	Called when the PCI registration layer (or the IDE initialization)
  *	finds a device matching our IDE device tables.
+ *
+ *	NOTE: since we'll have to modify some fields of the ide_pci_device_t
+ *	structure depending on the chip's revision, we'd better pass a local
+ *	copy down the call chain...
  */
- 
 static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_pci_device_t *d = &hpt366_chipsets[id->driver_data];
+	ide_pci_device_t d = hpt366_chipsets[id->driver_data];
 
-	return d->init_setup(dev, d);
+	return d.init_setup(dev, &d);
 }
 
 static struct pci_device_id hpt366_pci_tbl[] = {
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

git-mtd.patch
3x59x-fix-pci-resource-management.patch
toshiba-tc86c001-ide-driver-take-2.patch
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

