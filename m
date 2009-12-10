From: akpm@linux-foundation.org
Subject: + mtd-nand-davinci-correct-4-bit-error-correction-update.patch added to -mm tree
Date: Thu, 10 Dec 2009 15:09:55 -0800
Message-ID: <200912102309.nBAN9taP028481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933088AbZLJXKE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Dec 2009 18:10:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sudhakar.raj@ti.com, dwmw2@infradead.org, nsnehaprabha@ti.com


The patch titled
     mtd-nand: davinci: Correct 4-bit error correction
has been added to the -mm tree.  Its filename is
     mtd-nand-davinci-correct-4-bit-error-correction-update.patch

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

origin.patch
linux-next.patch
mtd-nand-davinci-correct-4-bit-error-correction.patch
mtd-nand-davinci-correct-4-bit-error-correction-update.patch
davinci-mmc-modify-data-types-of-edma-related-variables.patch
davinci-fb-calculate-the-clock-divider-from-pixel-clock-info.patch

