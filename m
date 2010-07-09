From: akpm@linux-foundation.org
Subject: + mtd-nand-davinci-correct-4-bit-error-correction.patch added to -mm tree
Date: Fri, 09 Jul 2010 15:40:02 -0700
Message-ID: <201007092240.o69Me24S029612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270Ab0GIWkj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 18:40:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sudhakar.raj@ti.com, cbouatmailru@gmail.com, dwmw2@infradead.org, nsnehaprabha@ti.com


The patch titled
     mtd-nand: davinci: correct 4-bit error correction
has been added to the -mm tree.  Its filename is
     mtd-nand-davinci-correct-4-bit-error-correction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/davinci_nand.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN drivers/mtd/nand/davinci_nand.c~mtd-nand-davinci-correct-4-bit-error-correction drivers/mtd/nand/davinci_nand.c
--- a/drivers/mtd/nand/davinci_nand.c~mtd-nand-davinci-correct-4-bit-error-correction
+++ a/drivers/mtd/nand/davinci_nand.c
@@ -311,7 +311,9 @@ static int nand_davinci_correct_4bit(str
 	unsigned short ecc10[8];
 	unsigned short *ecc16;
 	u32 syndrome[4];
+	u32 ecc_state;
 	unsigned num_errors, corrected;
+	unsigned long timeo = jiffies + msecs_to_jiffies(100);
 
 	/* All bytes 0xff?  It's an erased page; ignore its ECC. */
 	for (i = 0; i < 10; i++) {
@@ -361,6 +363,21 @@ compare:
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
mtd-nand-davinci-correct-4-bit-error-correction.patch
mtdpart-memory-accessor-interface-for-mtd-layer.patch

