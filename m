From: akpm@osdl.org
Subject: - ide-hpt3xx-fix-pci-clock-detection-fix-2.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:19:14 -0800
Message-ID: <200612140619.kBE6JDnH002366@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53012 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbWLNGWr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:22:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, B.Zolnierkiewicz@elka.pw.edu.pl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     HPT37x: read f_CNT saved by BIOS from port
has been removed from the -mm tree.  Its filename was
     ide-hpt3xx-fix-pci-clock-detection-fix-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: HPT37x: read f_CNT saved by BIOS from port
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

The undocumented register BIOS uses for saving f_CNT seems to only be
mapped to I/O space while all the other HPT3xx regs are dual-mapped.  Looks
like another HighPoint's dirty trick.  With this patch, the deadly kernel
oops on the cards having the modern HighPoint BIOSes is now at last gone!

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/hpt366.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/ide/pci/hpt366.c~ide-hpt3xx-fix-pci-clock-detection-fix-2 drivers/ide/pci/hpt366.c
--- a/drivers/ide/pci/hpt366.c~ide-hpt3xx-fix-pci-clock-detection-fix-2
+++ a/drivers/ide/pci/hpt366.c
@@ -1035,14 +1035,14 @@ static void __devinit hpt37x_clocking(id
 	 * First try reading the register in which the HighPoint BIOS
 	 * saves f_CNT value before  reprogramming the DPLL from its
 	 * default setting (which differs for the various chips).
+	 * NOTE: This register is only accessible via I/O space.
+	 *
 	 * In case the signature check fails, we'll have to resort to
 	 * reading the f_CNT register itself in hopes that nobody has
 	 * touched the DPLL yet...
 	 */
-	pci_read_config_dword(dev, 0x70, &temp);
+	temp = inl(pci_resource_start(dev, 4) + 0x90);
 	if ((temp & 0xFFFFF000) != 0xABCDE000) {
-		int i;
-
 		printk(KERN_WARNING "HPT37X: no clock data saved by BIOS\n");
 
 		/* Calculate the average value of f_CNT */
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

