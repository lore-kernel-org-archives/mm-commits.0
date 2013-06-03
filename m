From: akpm@linux-foundation.org
Subject: + drivers-scsi-mvumi-convert-to-module_pci_driver.patch added to
 -mm tree
Date: Mon, 03 Jun 2013 15:01:13 -0700
Message-ID: <51ad1229.auBkVink7TeY/6t5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758784Ab3FCWBT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jun 2013 18:01:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, libo.chen@huawei.com, James.Bottomley@HansenPartnership.com, clbchenlibo.chen@huawei.com

Subject: + drivers-scsi-mvumi-convert-to-module_pci_driver.patch added to -mm tree
To: clbchenlibo.chen@huawei.com,James.Bottomley@HansenPartnership.com,libo.chen@huawei.com
From: akpm@linux-foundation.org
Date: Mon, 03 Jun 2013 15:01:13 -0700


The patch titled
     Subject: drivers/scsi/mvumi.c: convert to module_pci_driver
has been added to the -mm tree.  Its filename is
     drivers-scsi-mvumi-convert-to-module_pci_driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: drivers/scsi/mvumi.c: convert to module_pci_driver

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mvumi.c |   20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff -puN drivers/scsi/mvumi.c~drivers-scsi-mvumi-convert-to-module_pci_driver drivers/scsi/mvumi.c
--- a/drivers/scsi/mvumi.c~drivers-scsi-mvumi-convert-to-module_pci_driver
+++ a/drivers/scsi/mvumi.c
@@ -2735,22 +2735,4 @@ static struct pci_driver mvumi_pci_drive
 #endif
 };
 
-/**
- * mvumi_init - Driver load entry point
- */
-static int __init mvumi_init(void)
-{
-	return pci_register_driver(&mvumi_pci_driver);
-}
-
-/**
- * mvumi_exit - Driver unload entry point
- */
-static void __exit mvumi_exit(void)
-{
-
-	pci_unregister_driver(&mvumi_pci_driver);
-}
-
-module_init(mvumi_init);
-module_exit(mvumi_exit);
+module_pci_driver(mvumi_pci_driver);
_

Patches currently in -mm which might be from clbchenlibo.chen@huawei.com are

drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
drivers-cdrom-gdromc-fix-device-number-leak.patch
drivers-scsi-a100u2w-convert-to-module_pci_driver.patch
drivers-scsi-dc395x-convert-to-module_pci_driver.patch
drivers-scsi-dmx3191d-convert-to-module_pci_driver.patch
drivers-scsi-initio-convert-to-module_pci_driver.patch
drivers-scsi-mvumi-convert-to-module_pci_driver.patch
drivers-net-irda-donauboe-convert-to-module_pci_driver.patch
drivers-ide-delkin_cb-convert-to-module_pci_driver.patch
drivers-atm-he-convert-to-module_pci_driver.patch
drivers-mfd-lpc_ich-convert-to-module_pci_driver.patch
drivers-ptp-ptp_pch-convert-to-module_pci_driver.patch
drivers-memstick-host-r592-convert-to-module_pci_driver.patch
drivers-platform-x86-intel_ips-convert-to-module_pci_driver.patch
drivers-media-pci-mantis-mantis_cards-convert-to-module_pci_driver.patch
drivers-media-pci-dm1105-dm1105-convert-to-module_pci_driver.patch
drivers-media-pci-mantis-hopper_cards-convert-to-module_pci_driver.patch
drivers-media-pci-pluto2-pluto2-convert-to-module_pci_driver.patch
drivers-media-pci-pt1-pt1-convert-to-module_pci_driver.patch

