From: akpm@linux-foundation.org
Subject: [merged]
 drivers-memstick-host-r592-convert-to-module_pci_driver.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:37:14 -0700
Message-ID: <51db14ea.QHrLUONAKBkPh6FI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab3GHThO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, maximlevitsky@gmail.com, libo.chen@huawei.com, clbchenlibo.chen@huawei.com

Subject: [merged] drivers-memstick-host-r592-convert-to-module_pci_driver.patch removed from -mm tree
To: clbchenlibo.chen@huawei.com,libo.chen@huawei.com,maximlevitsky@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:14 -0700


The patch titled
     Subject: drivers/memstick/host/r592.c: convert to module_pci_driver
has been removed from the -mm tree.  Its filename was
     drivers-memstick-host-r592-convert-to-module_pci_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: drivers/memstick/host/r592.c: convert to module_pci_driver

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/r592.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/memstick/host/r592.c~drivers-memstick-host-r592-convert-to-module_pci_driver drivers/memstick/host/r592.c
--- a/drivers/memstick/host/r592.c~drivers-memstick-host-r592-convert-to-module_pci_driver
+++ a/drivers/memstick/host/r592.c
@@ -884,18 +884,7 @@ static struct pci_driver r852_pci_driver
 	.driver.pm	= &r592_pm_ops,
 };
 
-static __init int r592_module_init(void)
-{
-	return pci_register_driver(&r852_pci_driver);
-}
-
-static void __exit r592_module_exit(void)
-{
-	pci_unregister_driver(&r852_pci_driver);
-}
