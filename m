From: akpm@linux-foundation.org
Subject: [merged]
 drivers-memstick-host-jmb38x_ms-convert-to-module_pci_driver.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:37:12 -0700
Message-ID: <51db14e8.yp0ZWpa4AKs/I6JA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab3GHThM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, libo.chen@huawei.com

Subject: [merged] drivers-memstick-host-jmb38x_ms-convert-to-module_pci_driver.patch removed from -mm tree
To: libo.chen@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:12 -0700


The patch titled
     Subject: drivers/memstick/host/jmb38x_ms: convert to module_pci_driver
has been removed from the -mm tree.  Its filename was
     drivers-memstick-host-jmb38x_ms-convert-to-module_pci_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Libo Chen <libo.chen@huawei.com>
Subject: drivers/memstick/host/jmb38x_ms: convert to module_pci_driver

Use module_pci_driver instead of init/exit, make code clean.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/jmb38x_ms.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/memstick/host/jmb38x_ms.c~drivers-memstick-host-jmb38x_ms-convert-to-module_pci_driver drivers/memstick/host/jmb38x_ms.c
--- a/drivers/memstick/host/jmb38x_ms.c~drivers-memstick-host-jmb38x_ms-convert-to-module_pci_driver
+++ a/drivers/memstick/host/jmb38x_ms.c
@@ -1046,20 +1046,9 @@ static struct pci_driver jmb38x_ms_drive
 	.resume = jmb38x_ms_resume
 };
 
-static int __init jmb38x_ms_init(void)
-{
-	return pci_register_driver(&jmb38x_ms_driver);
-}
-
-static void __exit jmb38x_ms_exit(void)
-{
-	pci_unregister_driver(&jmb38x_ms_driver);
-}
+module_pci_driver(jmb38x_ms_driver);
 
 MODULE_AUTHOR("Alex Dubov");
 MODULE_DESCRIPTION("JMicron jmb38x MemoryStick driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, jmb38x_ms_id_tbl);
