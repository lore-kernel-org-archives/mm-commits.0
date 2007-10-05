From: akpm@linux-foundation.org
Subject: - ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:57:00 -0700
Message-ID: <200710051957.l95Jv011022423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50544 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763038AbXJEUBL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Ata: pata_marvell, use ioread* for iomap-ped memory
has been removed from the -mm tree.  Its filename was
     ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Ata: pata_marvell, use ioread* for iomap-ped memory
From: Jiri Slaby <jirislaby@gmail.com>

pata_marvell, use ioread* for iomap-ped memory

read* on pci_iomapped memory is incorrect, fix it

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_marvell.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/ata/pata_marvell.c~ata-pata_marvell-use-ioread-for-iomap-ped-memory drivers/ata/pata_marvell.c
--- a/drivers/ata/pata_marvell.c~ata-pata_marvell-use-ioread-for-iomap-ped-memory
+++ a/drivers/ata/pata_marvell.c
@@ -45,10 +45,10 @@ static int marvell_pre_reset(struct ata_
 		return -ENOMEM;
 	printk("BAR5:");
 	for(i = 0; i <= 0x0F; i++)
-		printk("%02X:%02X ", i, readb(barp + i));
+		printk("%02X:%02X ", i, ioread8(barp + i));
 	printk("\n");
 
-	devices = readl(barp + 0x0C);
+	devices = ioread32(barp + 0x0C);
 	pci_iounmap(pdev, barp);
 
 	if ((pdev->device == 0x6145) && (ap->port_no == 0) &&
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-net.patch
git-wireless.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-mxser_new-upgrade-to-110.patch
char-mxser_new-move-to-pci_vdevice.patch
char-mxser_new-remove-useless-comments-in-mxser_cards.patch
mxser-remove-commented-crap.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
char-moxa-cleanup-prints.patch
char-moxa-function-names-cleanup.patch
char-moxa-remove-sleep_on.patch
fs-select-remove-unused-macros.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
remove-bits_to_type-macro.patch
remove-bits_to_type-macro-fix.patch
remove-asm-bitopsh-includes-reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
