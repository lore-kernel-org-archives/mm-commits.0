From: akpm@linux-foundation.org
Subject: + drivers-pcmcia-yenta_socketc-convert-to-module_pci_driver.patch added to -mm tree
Date: Thu, 30 May 2013 15:25:06 -0700
Message-ID: <51a7d1c2.DLpioO3kLu2sVMbD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759294Ab3E3WZM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 May 2013 18:25:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wfp5p@virginia.edu, linux@dominikbrodowski.net, gregkh@linuxfoundation.org, eric.y.miao@gmail.com, bhelgaas@google.com, libo.chen@huawei.com

Subject: + drivers-pcmcia-yenta_socketc-convert-to-module_pci_driver.patch added to -mm tree
To: libo.chen@huawei.com,bhelgaas@google.com,eric.y.miao@gmail.com,gregkh@linuxfoundation.org,linux@dominikbrodowski.net,wfp5p@virginia.edu
From: akpm@linux-foundation.org
Date: Thu, 30 May 2013 15:25:06 -0700


The patch titled
     Subject: drivers/pcmcia/yenta_socket.c: convert to module_pci_driver
has been added to the -mm tree.  Its filename is
     drivers-pcmcia-yenta_socketc-convert-to-module_pci_driver.patch

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
Subject: drivers/pcmcia/yenta_socket.c: convert to module_pci_driver

Use module_pci_driver instead of init/exit, make code clean.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/yenta_socket.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff -puN drivers/pcmcia/yenta_socket.c~drivers-pcmcia-yenta_socketc-convert-to-module_pci_driver drivers/pcmcia/yenta_socket.c
--- a/drivers/pcmcia/yenta_socket.c~drivers-pcmcia-yenta_socketc-convert-to-module_pci_driver
+++ a/drivers/pcmcia/yenta_socket.c
@@ -1439,20 +1439,6 @@ static struct pci_driver yenta_cardbus_d
 	.driver.pm	= YENTA_PM_OPS,
 };
 
-
-static int __init yenta_socket_init(void)
-{
-	return pci_register_driver(&yenta_cardbus_driver);
-}
-
-
-static void __exit yenta_socket_exit(void)
-{
-	pci_unregister_driver(&yenta_cardbus_driver);
-}
-
