From: akpm@linux-foundation.org
Subject: + drivers-net-irda-donauboe-convert-to-module_pci_driver.patch
 added to -mm tree
Date: Mon, 03 Jun 2013 15:01:14 -0700
Message-ID: <51ad122a.xisHm0G+f2tW2RV3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758787Ab3FCWBP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jun 2013 18:01:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, samuel@sortiz.org, libo.chen@huawei.com, clbchenlibo.chen@huawei.com

Subject: + drivers-net-irda-donauboe-convert-to-module_pci_driver.patch added to -mm tree
To: clbchenlibo.chen@huawei.com,libo.chen@huawei.com,samuel@sortiz.org
From: akpm@linux-foundation.org
Date: Mon, 03 Jun 2013 15:01:14 -0700


The patch titled
     Subject: drivers/net/irda/donauboe.c: convert to module_pci_driver
has been added to the -mm tree.  Its filename is
     drivers-net-irda-donauboe-convert-to-module_pci_driver.patch

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
Subject: drivers/net/irda/donauboe.c: convert to module_pci_driver

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/donauboe.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff -puN drivers/net/irda/donauboe.c~drivers-net-irda-donauboe-convert-to-module_pci_driver drivers/net/irda/donauboe.c
--- a/drivers/net/irda/donauboe.c~drivers-net-irda-donauboe-convert-to-module_pci_driver
+++ a/drivers/net/irda/donauboe.c
@@ -1755,17 +1755,4 @@ static struct pci_driver donauboe_pci_dr
 	.resume		= toshoboe_wakeup 
 };
 
-static int __init
-donauboe_init (void)
-{
-  return pci_register_driver(&donauboe_pci_driver);
-}
-
-static void __exit
-donauboe_cleanup (void)
-{
-  pci_unregister_driver(&donauboe_pci_driver);
-}
-
-module_init(donauboe_init);
-module_exit(donauboe_cleanup);
+module_pci_driver(donauboe_pci_driver);
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

