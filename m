From: akpm@linux-foundation.org
Subject: - ipmi-add-pci-remove-handling.patch removed from -mm tree
Date: Thu, 15 Feb 2007 02:26:42 -0800
Message-ID: <200702151027.l1FARwgP026951@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42374 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965785AbXBOK2F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 05:28:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     ipmi: add pci remove handling
has been removed from the -mm tree.  Its filename was
     ipmi-add-pci-remove-handling.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: ipmi: add pci remove handling
From: Corey Minyard <minyard@acm.org>

Add pci_remove handling to the driver, so it will clean up if the device is
hot-removed.

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
+	pdev->dev->driver_data = info;
 
 	return try_smi_init(info);
 }
 
 static void __devexit ipmi_pci_remove(struct pci_dev *pdev)
 {
+	struct smi_info *info = pdev->dev->driver_data;
+	cleanup_one_si(info);
 }
 
 #ifdef CONFIG_PM
_

Patches currently in -mm which might be from minyard@acm.org are

origin.patch
ipmi-add-powerpc-openfirmware-sensing.patch
ipmi-allow-shared-interrupts.patch
ipmi-add-pci-remove-handling.patch
ipmi-add-new-ipmi-nmi-watchdog-handling.patch
