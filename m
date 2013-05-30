From: akpm@linux-foundation.org
Subject: +
 drivers-memstick-host-jmb38x_ms-convert-to-module_pci_driver.patch added to -mm tree
Date: Thu, 30 May 2013 15:21:47 -0700
Message-ID: <51a7d0fb.3ujSgSyhXxxR81sy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759070Ab3E3WVs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 May 2013 18:21:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, libo.chen@huawei.com

Subject: + drivers-memstick-host-jmb38x_ms-convert-to-module_pci_driver.patch added to -mm tree
To: libo.chen@huawei.com
From: akpm@linux-foundation.org
Date: Thu, 30 May 2013 15:21:47 -0700


The patch titled
     Subject: drivers/memstick/host/jmb38x_ms: convert to module_pci_driver
has been added to the -mm tree.  Its filename is
     drivers-memstick-host-jmb38x_ms-convert-to-module_pci_driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
