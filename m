From: akpm@linux-foundation.org
Subject: - atmel_nand-work-around-at32ap7000-ecc-errata.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:35:42 -0700
Message-ID: <200807141935.m6EJZgaq023945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757006AbYGNTf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:35:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haavard.skinnemoen@atmel.com, dwmw2@infradead.org, linux@maxim.org.za, mm-commits@vger.kernel.org


The patch titled
     atmel_nand: Work around AT32AP7000 ECC errata
has been removed from the -mm tree.  Its filename was
     atmel_nand-work-around-at32ap7000-ecc-errata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_nand: Work around AT32AP7000 ECC errata
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

The ALE signal isn't correctly wired up to the ECC controller on the
AP7000, so it starts calculating ECC during the address cycles.

Work around this by resetting the ECC controller between the address and
data cycles.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/atmel_nand.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/nand/atmel_nand.c~atmel_nand-work-around-at32ap7000-ecc-errata drivers/mtd/nand/atmel_nand.c
--- a/drivers/mtd/nand/atmel_nand.c~atmel_nand-work-around-at32ap7000-ecc-errata
+++ a/drivers/mtd/nand/atmel_nand.c
@@ -33,6 +33,7 @@
 #include <linux/io.h>
 
 #include <asm/arch/board.h>
+#include <asm/arch/cpu.h>
 
 #ifdef CONFIG_MTD_NAND_ATMEL_ECC_HW
 #define hard_ecc	1
@@ -264,6 +265,19 @@ static int atmel_nand_read_page(struct m
 	uint8_t *ecc_pos;
 	int stat;
 
+	/*
+	 * Errata: ALE is incorrectly wired up to the ECC controller
+	 * on the AP7000, so it will include the address cycles in the
+	 * ECC calculation.
+	 *
+	 * Workaround: Reset the parity registers before reading the
+	 * actual data.
+	 */
+	if (cpu_is_at32ap7000()) {
+		struct atmel_nand_host *host = chip->priv;
+		ecc_writel(host->ecc, CR, ATMEL_ECC_RST);
+	}
+
 	/* read the page */
 	chip->read_buf(mtd, p, eccsize);
 
@@ -377,9 +391,16 @@ static int atmel_nand_correct(struct mtd
 }
 
 /*
- * Enable HW ECC : unsused
+ * Enable HW ECC : unused on most chips
  */
-static void atmel_nand_hwctl(struct mtd_info *mtd, int mode) { ; }
+static void atmel_nand_hwctl(struct mtd_info *mtd, int mode)
+{
+	if (cpu_is_at32ap7000()) {
+		struct nand_chip *nand_chip = mtd->priv;
+		struct atmel_nand_host *host = nand_chip->priv;
+		ecc_writel(host->ecc, CR, ATMEL_ECC_RST);
+	}
+}
 
 #ifdef CONFIG_MTD_PARTITIONS
 static const char *part_probes[] = { "cmdlinepart", NULL };
_

Patches currently in -mm which might be from haavard.skinnemoen@atmel.com are

linux-next.patch

