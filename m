From: akpm@linux-foundation.org
Subject: + mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips-update.patch added to -mm tree
Date: Fri, 07 Aug 2009 14:00:45 -0700
Message-ID: <200908072100.n77L0j9a013856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754927AbZHGVBz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2009 17:01:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nsnehaprabha@ti.com, dbrownell@users.sourceforge.net, dwmw2@infradead.org, s-paulraj@ti.com, tglx@linutronix.de, troy.kisky@boundarydevices.com


The patch titled
     mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips-update
has been added to the -mm tree.  Its filename is
     mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips-update.patch

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
Subject: mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips-update
From: Sneha Narnakaje <nsnehaprabha@ti.com>

This patch adds 4-bit ECC support for large page NAND chips using the new
ECC mode NAND_ECC_HW_OOB_FIRST.  The platform data from board-dm355-evm
has been adjusted to use this mode.

The patches have been verified on DM355 device with 2K Micron devices
using mtd-tests and JFFS2.  Error correction upto 4-bits has also been
verified using nandwrite/nanddump utilities.

This patch series applies to linux-mtd next (mmotm) GIT tree.

This version (v4) addresses the review comment to leave 2 bytes at offset
0 for NAND manufacturer badblock markers.

Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Sneha Narnakaje <nsnehaprabha@ti.com>
Signed-off-by: Sandeep Paulraj <s-paulraj@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Troy Kisky <troy.kisky@boundarydevices.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/davinci_nand.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/nand/davinci_nand.c~mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips-update drivers/mtd/nand/davinci_nand.c
--- a/drivers/mtd/nand/davinci_nand.c~mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips-update
+++ a/drivers/mtd/nand/davinci_nand.c
@@ -522,8 +522,8 @@ static struct nand_ecclayout hwecc4_2048
 		54, 55, 56, 57, 58, 59, 60, 61, 62, 63,
 		},
 	.oobfree = {
-		/* 1 byte at offset 0 holds manufacturer badblock marker */
-		{.offset = 1, .length = 23, },
+		/* 2 bytes at offset 0 hold manufacturer badblock markers */
+		{.offset = 2, .length = 22, },
 		/* 5 bytes at offset 8 hold BBT markers */
 		/* 8 bytes at offset 16 hold JFFS2 clean markers */
 	},
_

Patches currently in -mm which might be from nsnehaprabha@ti.com are

mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis.patch
mtd-nand-add-new-ecc-mode-ecc_hw_oob_first.patch
mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips.patch
mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips-update.patch

