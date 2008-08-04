From: akpm@linux-foundation.org
Subject: - blackfin-nfc-driver-add-support-for-the-ecc-layout-the-blackfin-bootrom-uses.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:06:47 -0700
Message-ID: <200808042006.m74K6lA3027719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758727AbYHDUG4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:06:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Blackfin NFC Driver: add support for the ECC layout the Blackfin bootrom uses
has been removed from the -mm tree.  Its filename was
     blackfin-nfc-driver-add-support-for-the-ecc-layout-the-blackfin-bootrom-uses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin NFC Driver: add support for the ECC layout the Blackfin bootrom uses
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/Kconfig      |   12 +++++++++
 drivers/mtd/nand/bf5xx_nand.c |   40 ++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff -puN drivers/mtd/nand/Kconfig~blackfin-nfc-driver-add-support-for-the-ecc-layout-the-blackfin-bootrom-uses drivers/mtd/nand/Kconfig
--- a/drivers/mtd/nand/Kconfig~blackfin-nfc-driver-add-support-for-the-ecc-layout-the-blackfin-bootrom-uses
+++ a/drivers/mtd/nand/Kconfig
@@ -109,6 +109,18 @@ config MTD_NAND_BF5XX_HWECC
 	  Enable the use of the BF5XX's internal ECC generator when
 	  using NAND.
 
+config MTD_NAND_BF5XX_BOOTROM_ECC
+	bool "Use Blackfin BootROM ECC Layout"
+	default n
+	depends on MTD_NAND_BF5XX_HWECC
+	help
+	  If you wish to modify NAND pages and allow the Blackfin on-chip
+	  BootROM to boot from them, say Y here.  This is only necessary
+	  if you are booting U-Boot out of NAND and you wish to update
+	  U-Boot from Linux' userspace.  Otherwise, you should say N here.
+
+	  If unsure, say N.
+
 config MTD_NAND_RTC_FROM4
 	tristate "Renesas Flash ROM 4-slot interface board (FROM_BOARD4)"
 	depends on SH_SOLUTION_ENGINE
diff -puN drivers/mtd/nand/bf5xx_nand.c~blackfin-nfc-driver-add-support-for-the-ecc-layout-the-blackfin-bootrom-uses drivers/mtd/nand/bf5xx_nand.c
--- a/drivers/mtd/nand/bf5xx_nand.c~blackfin-nfc-driver-add-support-for-the-ecc-layout-the-blackfin-bootrom-uses
+++ a/drivers/mtd/nand/bf5xx_nand.c
@@ -91,6 +91,41 @@ static const unsigned short bfin_nfc_pin
 	 P_NAND_ALE,
 	 0};
 
+#ifdef CONFIG_MTD_NAND_BF5XX_BOOTROM_ECC
+static uint8_t bbt_pattern[] = { 0xff };
+
+static struct nand_bbt_descr bootrom_bbt = {
+	.options = 0,
+	.offs = 63,
+	.len = 1,
+	.pattern = bbt_pattern,
+};
+
+static struct nand_ecclayout bootrom_ecclayout = {
+	.eccbytes = 24,
+	.eccpos = {
+		0x8 * 0, 0x8 * 0 + 1, 0x8 * 0 + 2,
+		0x8 * 1, 0x8 * 1 + 1, 0x8 * 1 + 2,
+		0x8 * 2, 0x8 * 2 + 1, 0x8 * 2 + 2,
+		0x8 * 3, 0x8 * 3 + 1, 0x8 * 3 + 2,
+		0x8 * 4, 0x8 * 4 + 1, 0x8 * 4 + 2,
+		0x8 * 5, 0x8 * 5 + 1, 0x8 * 5 + 2,
+		0x8 * 6, 0x8 * 6 + 1, 0x8 * 6 + 2,
+		0x8 * 7, 0x8 * 7 + 1, 0x8 * 7 + 2
+	},
+	.oobfree = {
+		{ 0x8 * 0 + 3, 5 },
+		{ 0x8 * 1 + 3, 5 },
+		{ 0x8 * 2 + 3, 5 },
+		{ 0x8 * 3 + 3, 5 },
+		{ 0x8 * 4 + 3, 5 },
+		{ 0x8 * 5 + 3, 5 },
+		{ 0x8 * 6 + 3, 5 },
+		{ 0x8 * 7 + 3, 5 },
+	}
+};
+#endif
+
 /*
  * Data structures for bf5xx nand flash controller driver
  */
@@ -712,6 +747,11 @@ static int bf5xx_nand_probe(struct platf
 
 	/* setup hardware ECC data struct */
 	if (hardware_ecc) {
+#ifdef CONFIG_MTD_NAND_BF5XX_BOOTROM_ECC
+		chip->badblock_pattern = &bootrom_bbt;
+		chip->ecc.layout = &bootrom_ecclayout;
+#endif
+
 		if (plat->page_size == NFC_PG_SIZE_256) {
 			chip->ecc.bytes = 3;
 			chip->ecc.size = 256;
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
blackfin-rtc-driver-add-support-for-power-management-framework.patch
blackfin-rtc-driver-dont-bother-passing-the-rtc-struct-down-to-bfin_rtc_int_setclear-since-it-isnt-needed-shaves-off-100bytes.patch
blackfin-rtc-driver-disable-the-write-complete-irq-upon-close.patch
blackfin-rtc-driver-wait-for-the-write-complete-interrupt-complete-before-sleeping.patch
blackfin-rtc-driver-convert-pie-handling-to-irq_set_state-as-pointed-out-by-david-brownell.patch
blackfin-rtc-driver-drop-pie-stopwatch-code-since-the-hardware-can-only-do-a-max-of-1hz-and-this-same-functionality-is-provided-by-uie.patch

