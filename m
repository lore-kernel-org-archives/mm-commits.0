From: akpm@linux-foundation.org
Subject: + drivers-scsi-dc395x-convert-to-module_pci_driver.patch added to -mm tree
Date: Mon, 03 Jun 2013 15:01:10 -0700
Message-ID: <51ad1226.oXsHukxTZ+3NLwfK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758630Ab3FCWBL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jun 2013 18:01:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, libo.chen@huawei.com, James.Bottomley@HansenPartnership.com, clbchenlibo.chen@huawei.com

Subject: + drivers-scsi-dc395x-convert-to-module_pci_driver.patch added to -mm tree
To: clbchenlibo.chen@huawei.com,James.Bottomley@HansenPartnership.com,libo.chen@huawei.com
From: akpm@linux-foundation.org
Date: Mon, 03 Jun 2013 15:01:10 -0700


The patch titled
     Subject: drivers/scsi/dc395x.c: convert to module_pci_driver
has been added to the -mm tree.  Its filename is
     drivers-scsi-dc395x-convert-to-module_pci_driver.patch

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
Subject: drivers/scsi/dc395x.c: convert to module_pci_driver

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/dc395x.c |   24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff -puN drivers/scsi/dc395x.c~drivers-scsi-dc395x-convert-to-module_pci_driver drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c~drivers-scsi-dc395x-convert-to-module_pci_driver
+++ a/drivers/scsi/dc395x.c
@@ -4882,29 +4882,7 @@ static struct pci_driver dc395x_driver =
 	.remove         = dc395x_remove_one,
 };
 
-
-/**
- * dc395x_module_init - Module initialization function
- *
- * Used by both module and built-in driver to initialise this driver.
- **/
-static int __init dc395x_module_init(void)
-{
-	return pci_register_driver(&dc395x_driver);
-}
-
-
-/**
- * dc395x_module_exit - Module cleanup function.
- **/
-static void __exit dc395x_module_exit(void)
-{
-	pci_unregister_driver(&dc395x_driver);
-}
-
-
-module_init(dc395x_module_init);
-module_exit(dc395x_module_exit);
+module_pci_driver(dc395x_driver);
 
 MODULE_AUTHOR("C.L. Huang / Erich Chen / Kurt Garloff");
 MODULE_DESCRIPTION("SCSI host adapter driver for Tekram TRM-S1040 based adapters: Tekram DC395 and DC315 series");
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

