From: akpm@osdl.org
Subject: + sata_nv-fix-kfree-ordering-in-remove.patch added to -mm tree
Date: Tue, 12 Dec 2006 12:40:40 -0800
Message-ID: <200612122040.kBCKee9w015109@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:39347 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbWLLUkm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 15:40:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hancockr@shaw.ca


The patch titled
     sata_nv: fix kfree ordering in remove
has been added to the -mm tree.  Its filename is
     sata_nv-fix-kfree-ordering-in-remove.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sata_nv: fix kfree ordering in remove
From: Robert Hancock <hancockr@shaw.ca>

The suspend/resume change for sata_nv introduced a potential bug where the
hpriv structure could be used after it was freed in nv_remove_one.  Fix
that.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/sata_nv.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/sata_nv.c~sata_nv-fix-kfree-ordering-in-remove drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~sata_nv-fix-kfree-ordering-in-remove
+++ a/drivers/ata/sata_nv.c
@@ -1554,8 +1554,8 @@ static void nv_remove_one (struct pci_de
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
 	struct nv_host_priv *hpriv = host->private_data;
 
-	kfree(hpriv);
 	ata_pci_remove_one(pdev);
+	kfree(hpriv);
 }
 
 static int nv_pci_device_resume(struct pci_dev *pdev)
_

Patches currently in -mm which might be from hancockr@shaw.ca are

origin.patch
sata_nv-add-suspend-resume-support.patch
sata_nv-fix-kfree-ordering-in-remove.patch

