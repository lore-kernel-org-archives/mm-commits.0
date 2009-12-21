From: akpm@linux-foundation.org
Subject: [folded] mtd-nand-davinci-correct-4-bit-error-correction-update.patch removed from -mm tree
Date: Mon, 21 Dec 2009 15:57:23 -0800
Message-ID: <200912212357.nBLNvNIv003736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427AbZLUX57 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 18:57:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudhakar.raj@ti.com, dwmw2@infradead.org, nsnehaprabha@ti.com, mm-commits@vger.kernel.org


The patch titled
     mtd-nand: davinci: Correct 4-bit error correction
has been removed from the -mm tree.  Its filename was
     mtd-nand-davinci-correct-4-bit-error-correction-update.patch

This patch was dropped because it was folded into mtd-nand-davinci-correct-4-bit-error-correction.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd-nand: davinci: Correct 4-bit error correction
From: Sudhakar Rajashekhara <sudhakar.raj@ti.com>

 From the previous version, timeout has been added to come out
 of the infinite loop.

Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: Sneha Narnakaje <nsnehaprabha@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/davinci_nand.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/mtd/nand/davinci_nand.c~mtd-nand-davinci-correct-4-bit-error-correction-update drivers/mtd/nand/davinci_nand.c
--- a/drivers/mtd/nand/davinci_nand.c~mtd-nand-davinci-correct-4-bit-error-correction-update
+++ a/drivers/mtd/nand/davinci_nand.c
@@ -312,6 +312,7 @@ static int nand_davinci_correct_4bit(str
 	u32 syndrome[4];
 	u32 ecc_state;
 	unsigned num_errors, corrected;
+	unsigned long timeo = jiffies + msecs_to_jiffies(100);
 
 	/* All bytes 0xff?  It's an erased page; ignore its ECC. */
 	for (i = 0; i < 10; i++) {
@@ -374,7 +375,7 @@ compare:
 		ecc_state = (davinci_nand_readl(info,
 				NANDFSR_OFFSET) >> 8) & 0x0f;
 		cpu_relax();
-	} while (ecc_state < 4);
+	} while ((ecc_state < 4) && time_before(jiffies, timeo));
 
 	for (;;) {
 		u32	fsr = davinci_nand_readl(info, NANDFSR_OFFSET);
_

Patches currently in -mm which might be from sudhakar.raj@ti.com are

mtd-nand-davinci-correct-4-bit-error-correction.patch
mtd-nand-davinci-correct-4-bit-error-correction-update.patch

