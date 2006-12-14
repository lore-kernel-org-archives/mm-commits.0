From: akpm@osdl.org
Subject: - ide-hpt3xx-fix-pci-clock-detection.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:19:05 -0800
Message-ID: <200612140619.kBE6J4x0002363@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53005 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbWLNGWg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:22:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, B.Zolnierkiewicz@elka.pw.edu.pl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     ide: HPT3xx: fix PCI clock detection
has been removed from the -mm tree.  Its filename was
     ide-hpt3xx-fix-pci-clock-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ide: HPT3xx: fix PCI clock detection
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Use the f_CNT value saved by the HighPoint BIOS if available as reading it
directly would give us a wrong PCI frequency after DPLL has already been
calibrated by BIOS.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/hpt366.c |   46 +++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff -puN drivers/ide/pci/hpt366.c~ide-hpt3xx-fix-pci-clock-detection drivers/ide/pci/hpt366.c
--- a/drivers/ide/pci/hpt366.c~ide-hpt3xx-fix-pci-clock-detection
+++ a/drivers/ide/pci/hpt366.c
@@ -70,6 +70,8 @@
  * - fix/remove bad/unused timing tables and use one set of tables for the whole
  *   HPT37x chip family; save space by introducing the separate transfer mode
  *   table in which the mode lookup is done
+ * - use f_CNT value saved by  the HighPoint BIOS as reading it directly gives
+ *   the wrong PCI frequency since DPLL has already been calibrated by BIOS
  * - fix the hotswap code:  it caused RESET- to glitch when tristating the bus,
  *   and for HPT36x the obsolete HDIO_TRISTATE_HWIF handler was called instead
  * - pass to init_chipset() handlers a copy of the IDE PCI device structure as
@@ -1010,8 +1012,8 @@ static void __devinit hpt37x_clocking(id
 	struct hpt_info *info = ide_get_hwifdata(hwif);
 	struct pci_dev *dev = hwif->pci_dev;
 	int adjust, i;
-	u16 freq;
-	u32 pll;
+	u16 freq = 0;
+	u32 pll, temp = 0;
 	u8 reg5bh = 0, mcr1 = 0;
 	
 	/*
@@ -1025,15 +1027,34 @@ static void __devinit hpt37x_clocking(id
 	pci_write_config_byte(dev, 0x5b, 0x23);
 
 	/*
-	 * set up the PLL. we need to adjust it so that it's stable. 
-	 * freq = Tpll * 192 / Tpci
+	 * We'll have to read f_CNT value in order to determine
+	 * the PCI clock frequency according to the following ratio:
 	 *
-	 * Todo. For non x86 should probably check the dword is
-	 * set to 0xABCDExxx indicating the BIOS saved f_CNT
+	 * f_CNT = Fpci * 192 / Fdpll
+	 *
+	 * First try reading the register in which the HighPoint BIOS
+	 * saves f_CNT value before  reprogramming the DPLL from its
+	 * default setting (which differs for the various chips).
+	 * In case the signature check fails, we'll have to resort to
+	 * reading the f_CNT register itself in hopes that nobody has
+	 * touched the DPLL yet...
 	 */
-	pci_read_config_word(dev, 0x78, &freq);
-	freq &= 0x1FF;
-	
+	pci_read_config_dword(dev, 0x70, &temp);
+	if ((temp & 0xFFFFF000) != 0xABCDE000) {
+		int i;
+
+		printk(KERN_WARNING "HPT37X: no clock data saved by BIOS\n");
+
+		/* Calculate the average value of f_CNT */
+		for (temp = i = 0; i < 128; i++) {
+			pci_read_config_word(dev, 0x78, &freq);
+			temp += freq & 0x1ff;
+			mdelay(1);
+		}
+		freq = temp / 128;
+	} else
+		freq = temp & 0x1ff;
+
 	/*
 	 * HPT3xxN chips use different PCI clock information.
 	 * Currently we always set up the PLL for them.
@@ -1095,11 +1116,8 @@ static void __devinit hpt37x_clocking(id
 	info->flags |= PLL_MODE;
 	
 	/*
-	 * FIXME: make this work correctly, esp with 372N as per
-	 * reference driver code.
-	 *
-	 * adjust PLL based upon PCI clock, enable it, and wait for
-	 * stabilization.
+	 * Adjust the PLL based upon the PCI clock, enable it, and
+	 * wait for stabilization...
 	 */
 	adjust = 0;
 	freq = (pll < F_LOW_PCI_50) ? 2 : 4;
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

