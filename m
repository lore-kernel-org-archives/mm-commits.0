From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-ufs-fix-potential-null-pointer-dereferencing-error-in-ufshcd_probe.patch removed from -mm tree
Date: Fri, 25 May 2012 13:48:24 -0700
Message-ID: <20120525204824.C9214A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:57760 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232Ab2EYUsZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 16:48:25 -0400
Received: by qcsp5 with SMTP id p5so150637qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 13:48:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linkinjeon@gmail.com, James.Bottomley@HansenPartnership.com, santoshsy@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/ufs: fix potential NULL pointer dereferencing error in ufshcd_probe()
has been removed from the -mm tree.  Its filename was
     drivers-scsi-ufs-fix-potential-null-pointer-dereferencing-error-in-ufshcd_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: drivers/scsi/ufs: fix potential NULL pointer dereferencing error in ufshcd_probe()

Avoid dereferencing a NULL pointer if scsi_host_alloc() failed.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Acked-by: Santosh Y <santoshsy@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ufs/ufshcd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ufs/ufshcd.c~drivers-scsi-ufs-fix-potential-null-pointer-dereferencing-error-in-ufshcd_probe drivers/scsi/ufs/ufshcd.c
--- a/drivers/scsi/ufs/ufshcd.c~drivers-scsi-ufs-fix-potential-null-pointer-dereferencing-error-in-ufshcd_probe
+++ a/drivers/scsi/ufs/ufshcd.c
@@ -1838,7 +1838,7 @@ ufshcd_probe(struct pci_dev *pdev, const
 	err = pci_request_regions(pdev, UFSHCD);
 	if (err < 0) {
 		dev_err(&pdev->dev, "request regions failed\n");
-		goto out_disable;
+		goto out_host_put;
 	}
 
 	hba->mmio_base = pci_ioremap_bar(pdev, 0);
@@ -1927,8 +1927,9 @@ out_iounmap:
 	iounmap(hba->mmio_base);
 out_release_regions:
 	pci_release_regions(pdev);
-out_disable:
+out_host_put:
 	scsi_host_put(host);
+out_disable:
 	pci_clear_master(pdev);
 	pci_disable_device(pdev);
 out_error:
_

Patches currently in -mm which might be from linkinjeon@gmail.com are

origin.patch
linux-next.patch
drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic.patch
ufs-fix-incorrect-return-value-about-success-and-failed.patch
fat-add-fat_msg_ratelimit.patch
fat-use-fat_msg_ratelimit-in-fat__get_entry.patch

