From: akpm@linux-foundation.org
Subject: [merged] drivers-mtd-nand-cafe_nandc-fix-irq-handler-return-type.patch removed from -mm tree
Date: Fri, 24 Apr 2009 12:28:01 -0700
Message-ID: <200904241928.n3OJS1TF015999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbZDXTa2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Apr 2009 15:30:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: helight.xu@gmail.com, dwmw2@infradead.org, kyungmin.park@samsung.com, mm-commits@vger.kernel.org


The patch titled
     drivers/mtd/nand/cafe_nand.c: fix irq handler return type
has been removed from the -mm tree.  Its filename was
     drivers-mtd-nand-cafe_nandc-fix-irq-handler-return-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

drivers-infiniband-hw-nes-nes_cmc-fix-unused-var-warning.patch
drivers-pci-hotplug-ibmphp_corec-fix-warning-due-to-missing-module_exit.patch
drivers-scsi-ncr_d700c-fix-irq-handler-return-type.patch

