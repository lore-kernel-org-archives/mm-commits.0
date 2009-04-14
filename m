From: akpm@linux-foundation.org
Subject: + drivers-mtd-nand-cafe_nandc-fix-irq-handler-return-type.patch added to -mm tree
Date: Tue, 14 Apr 2009 16:01:46 -0700
Message-ID: <200904142301.n3EN1kOM012522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34371 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751715AbZDNXEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 19:04:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: helight.xu@gmail.com, dwmw2@infradead.org, kyungmin.park@samsung.com


The patch titled
     drivers/mtd/nand/cafe_nand.c: fix irq handler return type
has been added to the -mm tree.  Its filename is
     drivers-mtd-nand-cafe_nandc-fix-irq-handler-return-type.patch

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
Subject: drivers/mtd/nand/cafe_nand.c: fix irq handler return type
From: Zhenwen Xu <helight.xu@gmail.com>

drivers/mtd/nand/cafe_nand.c: In function `cafe_nand_probe':
drivers/mtd/nand/cafe_nand.c:730: warning: passing argument 2 of `request_irq' from incompatible pointer type

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
Cc: <kyungmin.park@samsung.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/cafe_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/nand/cafe_nand.c~drivers-mtd-nand-cafe_nandc-fix-irq-handler-return-type drivers/mtd/nand/cafe_nand.c
--- a/drivers/mtd/nand/cafe_nand.c~drivers-mtd-nand-cafe_nandc-fix-irq-handler-return-type
+++ a/drivers/mtd/nand/cafe_nand.c
@@ -332,7 +332,7 @@ static void cafe_select_chip(struct mtd_
 		cafe->ctl1 &= ~CTRL1_CHIPSELECT;
 }
 
-static int cafe_nand_interrupt(int irq, void *id)
+static irqreturn_t cafe_nand_interrupt(int irq, void *id)
 {
 	struct mtd_info *mtd = id;
 	struct cafe_priv *cafe = mtd->priv;
_

Patches currently in -mm which might be from helight.xu@gmail.com are

drivers-mtd-nand-cafe_nandc-fix-irq-handler-return-type.patch
fix-a-warning-on-drivers-net-via-velocityc.patch

