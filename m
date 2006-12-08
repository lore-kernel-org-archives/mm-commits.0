From: akpm@osdl.org
Subject: - lpfc-make-emulex-lpfc-driver-legacy-i-o-port-free.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:04:47 -0800
Message-ID: <200612081104.kB8B4ltu018589@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48711 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425370AbWLHLFR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:05:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: seto.hidetoshi@jp.fujitsu.com, James.Bottomley@steeleye.com, James.Smart@Emulex.Com, greg@kroah.com, kaneshige.kenji@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     lpfc: make Emulex lpfc driver legacy I/O port free
has been removed from the -mm tree.  Its filename was
     lpfc-make-emulex-lpfc-driver-legacy-i-o-port-free.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: lpfc: make Emulex lpfc driver legacy I/O port free
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Make Emulex lpfc driver legacy I/O port free.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Greg KH <greg@kroah.com>
Acked-by: James Smart <James.Smart@Emulex.Com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/lpfc/lpfc_init.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/lpfc/lpfc_init.c~lpfc-make-emulex-lpfc-driver-legacy-i-o-port-free drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c~lpfc-make-emulex-lpfc-driver-legacy-i-o-port-free
+++ a/drivers/scsi/lpfc/lpfc_init.c
@@ -1453,10 +1453,11 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	int error = -ENODEV, retval;
 	int i;
 	uint16_t iotag;
+	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
 
-	if (pci_enable_device(pdev))
+	if (pci_enable_device_bars(pdev, bars))
 		goto out;
-	if (pci_request_regions(pdev, LPFC_DRIVER_NAME))
+	if (pci_request_selected_regions(pdev, bars, LPFC_DRIVER_NAME))
 		goto out_disable_device;
 
 	host = scsi_host_alloc(&lpfc_template, sizeof (struct lpfc_hba));
@@ -1759,7 +1760,7 @@ out_put_host:
 	phba->host = NULL;
 	scsi_host_put(host);
 out_release_regions:
-	pci_release_regions(pdev);
+	pci_release_selected_regions(pdev, bars);
 out_disable_device:
 	pci_disable_device(pdev);
 out:
@@ -1773,6 +1774,7 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 	struct Scsi_Host   *host = pci_get_drvdata(pdev);
 	struct lpfc_hba    *phba = (struct lpfc_hba *)host->hostdata;
 	unsigned long iflag;
+	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
 
 	lpfc_free_sysfs_attr(phba);
 
@@ -1816,7 +1818,7 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 	iounmap(phba->ctrl_regs_memmap_p);
 	iounmap(phba->slim_memmap_p);
 
-	pci_release_regions(phba->pcidev);
+	pci_release_selected_regions(phba->pcidev, bars);
 	pci_disable_device(phba->pcidev);
 
 	idr_remove(&lpfc_hba_index, phba->brd_no);
_

Patches currently in -mm which might be from seto.hidetoshi@jp.fujitsu.com are

cpei-gets-warning-at-kernel-irq-migrationc27-move_masked_irq.patch

