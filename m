From: akpm@linux-foundation.org
Subject: - ipmi-add-pci-remove-handling.patch removed from -mm tree
Date: Tue, 08 May 2007 19:44:21 -0700
Message-ID: <200705090244.l492iLRM008580@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970080AbXEICoY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:44:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     ipmi: add pci remove handling
has been removed from the -mm tree.  Its filename was
     ipmi-add-pci-remove-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ipmi: add pci remove handling
From: Corey Minyard <minyard@acm.org>

Add pci_remove handling to the driver, so it will clean up if
the device is hot-removed.

Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-add-pci-remove-handling drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-add-pci-remove-handling
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -2189,12 +2189,15 @@ static int __devinit ipmi_pci_probe(stru
 		info->irq_setup = std_irq_setup;
 
 	info->dev = &pdev->dev;
+	pci_set_drvdata(pdev, info);
 
 	return try_smi_init(info);
 }
 
 static void __devexit ipmi_pci_remove(struct pci_dev *pdev)
 {
+	struct smi_info *info = pci_get_drvdata(pdev);
+	cleanup_one_si(info);
 }
 
 #ifdef CONFIG_PM
_

Patches currently in -mm which might be from minyard@acm.org are

origin.patch
