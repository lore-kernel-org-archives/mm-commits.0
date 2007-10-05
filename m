From: akpm@linux-foundation.org
Subject: - drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:57:02 -0700
Message-ID: <200710051957.l95Jv2LY022432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60057 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763038AbXJEUBS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: postfailathushmaildotcom@yahoo.com, alan@lxorguk.ukuu.org.uk, htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/ata/pata_ixp4xx_cf.c: ioremap return code check
has been removed from the -mm tree.  Its filename was
     drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/ata/pata_ixp4xx_cf.c: ioremap return code check
From: Scott Thompson <postfailathushmaildotcom@yahoo.com>

Add missing ioremap return checks.

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
Acked-by: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_ixp4xx_cf.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/ata/pata_ixp4xx_cf.c~drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check drivers/ata/pata_ixp4xx_cf.c
--- a/drivers/ata/pata_ixp4xx_cf.c~drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check
+++ a/drivers/ata/pata_ixp4xx_cf.c
@@ -195,6 +195,9 @@ static __devinit int ixp4xx_pata_probe(s
 	data->cs0 = devm_ioremap(&pdev->dev, cs0->start, 0x1000);
 	data->cs1 = devm_ioremap(&pdev->dev, cs1->start, 0x1000);
 
+	if (!data->cs0 || !data->cs1)
+		return -ENOMEM;
+
 	irq = platform_get_irq(pdev, 0);
 	if (irq)
 		set_irq_type(irq, IRQT_RISING);
_

Patches currently in -mm which might be from postfailathushmaildotcom@yahoo.com are

origin.patch
