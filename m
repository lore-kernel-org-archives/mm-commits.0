From: akpm@linux-foundation.org
Subject: + blackfin-nfc-driver-mark-bf5xx_nand_add_partition-as-__devinit.patch added to -mm tree
Date: Mon, 12 Jan 2009 19:50:32 -0800
Message-ID: <200901130350.n0D3oW3x012981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754078AbZAMDut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 22:50:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, cooloney@kernel.org, dwmw2@infradead.org


The patch titled
     mtd: Blackfin NFC Driver: mark bf5xx_nand_add_partition() as __devinit
has been added to the -mm tree.  Its filename is
     blackfin-nfc-driver-mark-bf5xx_nand_add_partition-as-__devinit.patch

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
Subject: mtd: Blackfin NFC Driver: mark bf5xx_nand_add_partition() as __devinit
From: Mike Frysinger <vapier.adi@gmail.com>

The bf5xx_nand_add_partition() func is only called by __devinit functions,
so put it into the __devinit section as well

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/bf5xx_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/nand/bf5xx_nand.c~blackfin-nfc-driver-mark-bf5xx_nand_add_partition-as-__devinit drivers/mtd/nand/bf5xx_nand.c
--- a/drivers/mtd/nand/bf5xx_nand.c~blackfin-nfc-driver-mark-bf5xx_nand_add_partition-as-__devinit
+++ a/drivers/mtd/nand/bf5xx_nand.c
@@ -630,7 +630,7 @@ static int bf5xx_nand_hw_init(struct bf5
 /*
  * Device management interface
  */
-static int bf5xx_nand_add_partition(struct bf5xx_nand_info *info)
+static int __devinit bf5xx_nand_add_partition(struct bf5xx_nand_info *info)
 {
 	struct mtd_info *mtd = &info->mtd;
 
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

linux-next.patch
blackfin-nfc-driver-do-not-clobber-dmac1_perimux.patch
blackfin-nfc-driver-mark-bf5xx_nand_add_partition-as-__devinit.patch
blackfin-nfc-driver-drop-pointless-casts-with-set_dma_callback.patch
bin_elf_fdpic-check-the-return-value-of-clear_user.patch

