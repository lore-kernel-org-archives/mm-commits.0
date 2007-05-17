From: akpm@linux-foundation.org
Subject: - drivers-ata-correct-a-wrong-free-function-for-sata_nv-driver.patch removed from -mm tree
Date: Thu, 17 May 2007 15:31:12 -0700
Message-ID: <200705172231.l4HMVCv9002077@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37252 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754770AbXEQWeu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 18:34:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pchen@nvidia.com, jeff@garzik.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/ata: correct a wrong free function for sata_nv driver
has been removed from the -mm tree.  Its filename was
     drivers-ata-correct-a-wrong-free-function-for-sata_nv-driver.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: drivers/ata: correct a wrong free function for sata_nv driver
From: "Peer Chen" <pchen@nvidia.com>

For sata_nv driver in kernel 2.6.21 onward, Inside nv_init_one(),use 'hpriv
= devm_kzalloc(&pdev->dev, sizeof(*hpriv), GFP_KERNEL);' but using the
kfree(hpriv) to free that data struction in nv_remove_one(), which will
cause system hang when removing the sata_nv module.

Change the 'kfree()' function to 'devm_kfree' will fix this bug.

Signed-off-by: Peer Chen <pchen@nvidia.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/sata_nv.c~drivers-ata-correct-a-wrong-free-function-for-sata_nv-driver drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~drivers-ata-correct-a-wrong-free-function-for-sata_nv-driver
+++ a/drivers/ata/sata_nv.c
@@ -1613,7 +1613,7 @@ static void nv_remove_one (struct pci_de
 	struct nv_host_priv *hpriv = host->private_data;
 
 	ata_pci_remove_one(pdev);
-	kfree(hpriv);
+	devm_kfree(&pci_dev->dev, hpriv);
 }
 
 #ifdef CONFIG_PM
_

Patches currently in -mm which might be from pchen@nvidia.com are

drivers-ata-remove-the-wildcard-from-sata_nv-driver.patch
sata_nv-fix-fallout-of-devres-conversion.patch
drivers-ata-correct-a-wrong-free-function-for-sata_nv-driver.patch
drivers-ata-correct-a-wrong-free-function-for-sata_nv-driver-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy.patch
