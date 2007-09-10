From: akpm@linux-foundation.org
Subject: + drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch added to -mm tree
Date: Mon, 10 Sep 2007 01:05:30 -0700
Message-ID: <200709100805.l8A85U3h014648@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49016 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755474AbXIJIFf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 04:05:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: postfailathushmaildotcom@yahoo.com, alan@lxorguk.ukuu.org.uk, htejun@gmail.com


The patch titled
     drivers/ata/pata_ixp4xx_cf.c: ioremap return code check
has been added to the -mm tree.  Its filename is
     drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
