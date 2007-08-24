From: akpm@linux-foundation.org
Subject: + drivers-ata-ioremap-returncode-check-pata_ixp4xx_cfc.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:38:37 -0700
Message-ID: <200708242238.l7OMcbxS018405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53162 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760818AbXHXWjU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:39:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: postfail@hushmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     drivers/ata/pata_ixp4xx_cf.c: ioremap return code check
has been added to the -mm tree.  Its filename is
     drivers-ata-ioremap-returncode-check-pata_ixp4xx_cfc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/ata/pata_ixp4xx_cf.c: ioremap return code check
From: "Scott Thompson" <postfail@hushmail.com>

Correct two missing ioremap return checks.

Signed-off-by: Scott Thompson <postfail@hushmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_ixp4xx_cf.c |    8 ++++++++
 1 files changed, 8 insertions(+)

diff -puN drivers/ata/pata_ixp4xx_cf.c~drivers-ata-ioremap-returncode-check-pata_ixp4xx_cfc drivers/ata/pata_ixp4xx_cf.c
--- a/drivers/ata/pata_ixp4xx_cf.c~drivers-ata-ioremap-returncode-check-pata_ixp4xx_cfc
+++ a/drivers/ata/pata_ixp4xx_cf.c
@@ -186,6 +186,14 @@ static __devinit int ixp4xx_pata_probe(s
 	data->cs0 = devm_ioremap(&pdev->dev, cs0->start, 0x1000);
 	data->cs1 = devm_ioremap(&pdev->dev, cs1->start, 0x1000);
 
+	if (!data->cs0 || !data->cs1) {
+		if (data->cs0)
+			iounmap(data->cs0);
+		if (data->cs1)
+			iounmap(data->cs1);
+		return -ENOMEM;
+	}
+
 	irq = platform_get_irq(pdev, 0);
 	if (irq)
 		set_irq_type(irq, IRQT_RISING);
_

Patches currently in -mm which might be from postfail@hushmail.com are

git-alsa.patch
drivers-ata-ioremap-returncode-check-pata_ixp4xx_cfc.patch
drivers-atm-ioremap-balancing-returncode-check.patch
