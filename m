From: akpm@linux-foundation.org
Subject: [failures] drivers-ptp-ptp_pch-convert-to-module_pci_driver.patch removed from -mm tree
Date: Thu, 06 Jun 2013 13:09:14 -0700
Message-ID: <51b0ec6a.eQzF6LTukCKS/fnX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab3FFUJP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 16:09:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, richardcochran@gmail.com, libo.chen@huawei.com, clbchenlibo.chen@huawei.com

Subject: [failures] drivers-ptp-ptp_pch-convert-to-module_pci_driver.patch removed from -mm tree
To: clbchenlibo.chen@huawei.com,libo.chen@huawei.com,richardcochran@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 13:09:14 -0700


The patch titled
     Subject: drivers/ptp/ptp_pch.c: convert to module_pci_driver
has been removed from the -mm tree.  Its filename was
     drivers-ptp-ptp_pch-convert-to-module_pci_driver.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: drivers/ptp/ptp_pch.c: convert to module_pci_driver

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ptp/ptp_pch.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff -puN drivers/ptp/ptp_pch.c~drivers-ptp-ptp_pch-convert-to-module_pci_driver drivers/ptp/ptp_pch.c
--- a/drivers/ptp/ptp_pch.c~drivers-ptp-ptp_pch-convert-to-module_pci_driver
+++ a/drivers/ptp/ptp_pch.c
@@ -707,23 +707,7 @@ static struct pci_driver pch_driver = {
 	.resume = pch_resume,
 };
 
-static void __exit ptp_pch_exit(void)
-{
-	pci_unregister_driver(&pch_driver);
-}
-
-static s32 __init ptp_pch_init(void)
-{
-	s32 ret;
-
-	/* register the driver with the pci core */
-	ret = pci_register_driver(&pch_driver);
-
-	return ret;
-}
-
-module_init(ptp_pch_init);
-module_exit(ptp_pch_exit);
+module_pci_driver(pch_driver);
 
 module_param_string(station,
 		    pch_param.station, sizeof(pch_param.station), 0444);
_

Patches currently in -mm which might be from clbchenlibo.chen@huawei.com are

linux-next.patch
drivers-platform-x86-intel_ips-convert-to-module_pci_driver.patch
drivers-media-pci-mantis-mantis_cards-convert-to-module_pci_driver.patch
drivers-media-pci-dm1105-dm1105-convert-to-module_pci_driver.patch
drivers-media-pci-mantis-hopper_cards-convert-to-module_pci_driver.patch
drivers-media-pci-pluto2-pluto2-convert-to-module_pci_driver.patch
drivers-media-pci-pt1-pt1-convert-to-module_pci_driver.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
drivers-ide-delkin_cb-convert-to-module_pci_driver.patch
drivers-mfd-lpc_ich-convert-to-module_pci_driver.patch
drivers-atm-he-convert-to-module_pci_driver.patch
drivers-scsi-a100u2w-convert-to-module_pci_driver.patch
drivers-scsi-dc395x-convert-to-module_pci_driver.patch
drivers-scsi-dmx3191d-convert-to-module_pci_driver.patch
drivers-scsi-initio-convert-to-module_pci_driver.patch
drivers-scsi-mvumi-convert-to-module_pci_driver.patch
drivers-net-irda-donauboe-convert-to-module_pci_driver.patch
drivers-cdrom-gdromc-fix-device-number-leak.patch
drivers-memstick-host-r592-convert-to-module_pci_driver.patch

