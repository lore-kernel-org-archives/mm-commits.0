From: akpm@linux-foundation.org
Subject: [merged] mtd-nand-davinci-correct-4-bit-error-correction.patch removed from -mm tree
Date: Fri, 29 Jan 2010 12:16:44 -0800
Message-ID: <201001292016.o0TKGiV2003258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752823Ab0A2URX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jan 2010 15:17:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudhakar.raj@ti.com, dwmw2@infradead.org, nsnehaprabha@ti.com, mm-commits@vger.kernel.org


The patch titled
     mtd-nand: davinci: correct 4-bit error correction
has been removed from the -mm tree.  Its filename was
     mtd-nand-davinci-correct-4-bit-error-correction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd-nand: davinci: correct 4-bit error correction
From: Sudhakar Rajashekhara <sudhakar.raj@ti.com>

On TI's DA830/OMAP-L137, DA850/OMAP-L138 and DM365, after setting the
4BITECC_ADD_CALC_START bit in the NAND Flash control register to 1 and
before waiting for the NAND Flash status register to be equal to 1, 2 or
3, we have to wait till the ECC HW goes to correction state.  Without this
wait, ECC correction calculations will not be proper.

This has been tested on DA830/OMAP-L137, DA850/OMAP-L138, DM355 and DM365
EVMs.

Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Acked-by: Sneha Narnakaje <nsnehaprabha@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/davinci_nand.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN drivers/mtd/nand/davinci_nand.c~mtd-nand-davinci-correct-4-bit-error-correction drivers/mtd/nand/davinci_nand.c
--- a/drivers/mtd/nand/davinci_nand.c~mtd-nand-davinci-correct-4-bit-error-correction
+++ a/drivers/mtd/nand/davinci_nand.c
@@ -310,7 +310,9 @@ static int nand_davinci_correct_4bit(str
 	unsigned short ecc10[8];
 	unsigned short *ecc16;
 	u32 syndrome[4];
+	u32 ecc_state;
 	unsigned num_errors, corrected;
+	unsigned long timeo = jiffies + msecs_to_jiffies(100);
 
 	/* All bytes 0xff?  It's an erased page; ignore its ECC. */
 	for (i = 0; i < 10; i++) {
@@ -360,6 +362,21 @@ compare:
 	 */
 	davinci_nand_writel(info, NANDFCR_OFFSET,
 			davinci_nand_readl(info, NANDFCR_OFFSET) | BIT(13));
+
+	/*
+	 * ECC_STATE field reads 0x3 (Error correction complete) immediately
+	 * after setting the 4BITECC_ADD_CALC_START bit. So if you immediately
+	 * begin trying to poll for the state, you may fall right out of your
+	 * loop without any of the correction calculations having taken place.
+	 * The recommendation from the hardware team is to wait till ECC_STATE
+	 * reads less than 4, which means ECC HW has entered correction state.
+	 */
+	do {
+		ecc_state = (davinci_nand_readl(info,
+				NANDFSR_OFFSET) >> 8) & 0x0f;
+		cpu_relax();
+	} while ((ecc_state < 4) && time_before(jiffies, timeo));
+
 	for (;;) {
 		u32	fsr = davinci_nand_readl(info, NANDFSR_OFFSET);
 
_

Patches currently in -mm which might be from sudhakar.raj@ti.com are

linux-next.patch
davinci-mmc-add-support-for-8bit-mmc-cards.patch

