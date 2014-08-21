From: akpm@linux-foundation.org
Subject: [merged]
 drivers-net-irda-donauboe-convert-to-module_pci_driver.patch removed from
 -mm tree
Date: Thu, 21 Aug 2014 13:28:35 -0700
Message-ID: <53f65673.G9zziNvs2Aqp8ww1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:51856 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbaHUU2g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Aug 2014 16:28:36 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so1161575qap.4
        for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2014 13:28:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clbchenlibo.chen@huawei.com, samuel@sortiz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/net/irda/donauboe.c: convert to module_pci_driver
has been removed from the -mm tree.  Its filename was
     drivers-net-irda-donauboe-convert-to-module_pci_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
