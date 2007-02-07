From: akpm@linux-foundation.org
Subject: - sata_nv-propagate-ata_pci_device_do_resume-return-value.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:52:41 -0800
Message-ID: <200702071952.l17Jqfqa025260@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33637 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422751AbXBGTwn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:52:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hancockr@shaw.ca, mm-commits@vger.kernel.org


The patch titled
     sata_nv: propagate ata_pci_device_do_resume return value
has been removed from the -mm tree.  Its filename was
     sata_nv-propagate-ata_pci_device_do_resume-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sata_nv: propagate ata_pci_device_do_resume return value
From: Robert Hancock <hancockr@shaw.ca>

ata_pci_device_do_resume can fail if the PCI device couldn't be re-enabled.
 Update sata_nv to propagate the return value from this call and to not try
to do any other resume activities if it fails.  Fixes a compile warning.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/ata/sata_nv.c~sata_nv-propagate-ata_pci_device_do_resume-return-value drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~sata_nv-propagate-ata_pci_device_do_resume-return-value
+++ a/drivers/ata/sata_nv.c
@@ -1567,8 +1567,11 @@ static int nv_pci_device_resume(struct p
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
 	struct nv_host_priv *hpriv = host->private_data;
+	int rc;
 
-	ata_pci_device_do_resume(pdev);
+	rc = ata_pci_device_do_resume(pdev);
+	if(rc)
+		return rc;
 
 	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
 		if(hpriv->type >= CK804) {
_

Patches currently in -mm which might be from hancockr@shaw.ca are

git-libata-all.patch
