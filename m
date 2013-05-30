From: akpm@linux-foundation.org
Subject: + drivers-pcmcia-pd6729c-convert-to-module_pci_driver.patch added to -mm tree
Date: Thu, 30 May 2013 15:23:12 -0700
Message-ID: <51a7d150.UBABTzN89mUCJRnN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758693Ab3E3WXN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 May 2013 18:23:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wfp5p@virginia.edu, linux@dominikbrodowski.net, gregkh@linuxfoundation.org, libo.chen@huawei.com

Subject: + drivers-pcmcia-pd6729c-convert-to-module_pci_driver.patch added to -mm tree
To: libo.chen@huawei.com,gregkh@linuxfoundation.org,linux@dominikbrodowski.net,wfp5p@virginia.edu
From: akpm@linux-foundation.org
Date: Thu, 30 May 2013 15:23:12 -0700


The patch titled
     Subject: drivers/pcmcia/pd6729.c: convert to module_pci_driver
has been added to the -mm tree.  Its filename is
     drivers-pcmcia-pd6729c-convert-to-module_pci_driver.patch

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
Subject: drivers/pcmcia/pd6729.c: convert to module_pci_driver

Use module_pci_driver instead of init/exit, make code clean.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Eric Miao <eric.y.miao.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/pd6729.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/pcmcia/pd6729.c~drivers-pcmcia-pd6729c-convert-to-module_pci_driver drivers/pcmcia/pd6729.c
--- a/drivers/pcmcia/pd6729.c~drivers-pcmcia-pd6729c-convert-to-module_pci_driver
+++ a/drivers/pcmcia/pd6729.c
@@ -775,15 +775,4 @@ static struct pci_driver pd6729_pci_driv
 	.remove		= pd6729_pci_remove,
 };
 
-static int pd6729_module_init(void)
-{
-	return pci_register_driver(&pd6729_pci_driver);
-}
-
-static void pd6729_module_exit(void)
-{
-	pci_unregister_driver(&pd6729_pci_driver);
-}
