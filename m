From: akpm@linux-foundation.org
Subject: + drivers-scsi-ufs-fix-potential-null-pointer-dereferencing-error-in-ufshcd_probe.patch added to -mm tree
Date: Tue, 22 May 2012 13:15:42 -0700
Message-ID: <20120522201542.9D080A0241@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:35368 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304Ab2EVUPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 May 2012 16:15:44 -0400
Received: by eeit10 with SMTP id t10so386852eei.1
        for <mm-commits@vger.kernel.org>; Tue, 22 May 2012 13:15:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linkinjeon@gmail.com, James.Bottomley@HansenPartnership.com, santoshsy@gmail.com


The patch titled
     Subject: drivers/scsi/ufs: fix potential NULL pointer dereferencing error in ufshcd_probe()
has been added to the -mm tree.  Its filename is
     drivers-scsi-ufs-fix-potential-null-pointer-dereferencing-error-in-ufshcd_probe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/scsi/ufs: fix potential NULL pointer dereferencing error in ufshcd_probe()

Patches currently in -mm which might be from linkinjeon@gmail.com are

origin.patch
linux-next.patch
drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic.patch
ufs-fix-incorrect-return-value-about-success-and-failed.patch
drivers-scsi-ufs-fix-potential-null-pointer-dereferencing-error-in-ufshcd_probe.patch
fat-add-fat_msg_ratelimit.patch
fat-use-fat_msg_ratelimit-in-fat__get_entry.patch

