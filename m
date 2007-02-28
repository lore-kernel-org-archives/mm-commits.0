From: akpm@linux-foundation.org
Subject: + sk98lin-handle-pci_enable_device-return-value-in-skge_resume.patch added to -mm tree
Date: Tue, 27 Feb 2007 22:29:35 -0800
Message-ID: <200702280629.l1S6TdIF008802@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41963 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbXB1G3m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 01:29:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@openvz.org


The patch titled
     sk98lin: handle pci_enable_device() return value in skge_resume()
has been added to the -mm tree.  Its filename is
     sk98lin-handle-pci_enable_device-return-value-in-skge_resume.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sk98lin: handle pci_enable_device() return value in skge_resume()
From: Dmitriy Monakhov <dmonakhov@openvz.org>

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sk98lin/skge.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN drivers/net/sk98lin/skge.c~sk98lin-handle-pci_enable_device-return-value-in-skge_resume drivers/net/sk98lin/skge.c
--- a/drivers/net/sk98lin/skge.c~sk98lin-handle-pci_enable_device-return-value-in-skge_resume
+++ a/drivers/net/sk98lin/skge.c
@@ -5125,7 +5125,12 @@ static int skge_resume(struct pci_dev *p
 
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
-	pci_enable_device(pdev);
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		printk(KERN_WARNING "sk98lin: unable to enable device %s "
+				"in resume\n", dev->name);
+		goto err_out;
+	}
 	pci_set_master(pdev);
 	if (pAC->GIni.GIMacsFound == 2)
 		ret = request_irq(dev->irq, SkGeIsr, IRQF_SHARED, "sk98lin", dev);
@@ -5133,10 +5138,8 @@ static int skge_resume(struct pci_dev *p
 		ret = request_irq(dev->irq, SkGeIsrOnePort, IRQF_SHARED, "sk98lin", dev);
 	if (ret) {
 		printk(KERN_WARNING "sk98lin: unable to acquire IRQ %d\n", dev->irq);
-		pAC->AllocFlag &= ~SK_ALLOC_IRQ;
-		dev->irq = 0;
-		pci_disable_device(pdev);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto err_out_disable_pdev;
 	}
 
 	netif_device_attach(dev);
@@ -5153,6 +5156,13 @@ static int skge_resume(struct pci_dev *p
 	}
 
 	return 0;
+
+err_out_disable_pdev:
+	pci_disable_device(pdev);
+err_out:
+	pAC->AllocFlag &= ~SK_ALLOC_IRQ;
+	dev->irq = 0;
+	return ret;
 }
 #else
 #define skge_suspend NULL
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

ecryptfs-set-o_largefile-when-opening-lower-file.patch
ecryptfs-remove-unnecessary-flush_dcache_page.patch
ecryptfs-no-path_release-after-path_lookup-error.patch
libata-handle-ata_pci_device_do_resume-failure-while-resuming-v2.patch
3c59x-handle-pci_enable_device-failure-while-resuming.patch
sk98lin-handle-pci_enable_device-return-value-in-skge_resume.patch
mpt-fusion-handle-mpt_resume-failure-while-resuming.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
irq-add-__must_check-to-request_irq.patch
ecryptfs-handles-aop_truncated_page-better.patch
