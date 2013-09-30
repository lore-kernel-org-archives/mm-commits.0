From: akpm@linux-foundation.org
Subject: [merged]
 drivers-pcmcia-pd6729c-convert-to-module_pci_driver.patch removed from -mm
 tree
Date: Mon, 30 Sep 2013 11:57:32 -0700
Message-ID: <5249c99c.bNPQfPcO1RcYv2Ha%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab3I3S5d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Sep 2013 14:57:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wfp5p@virginia.edu, linux@dominikbrodowski.net, gregkh@linuxfoundation.org, eric.y.miao@gmail.com, libo.chen@huawei.com

Subject: [merged] drivers-pcmcia-pd6729c-convert-to-module_pci_driver.patch removed from -mm tree
To: libo.chen@huawei.com,eric.y.miao@gmail.com,gregkh@linuxfoundation.org,linux@dominikbrodowski.net,wfp5p@virginia.edu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 30 Sep 2013 11:57:32 -0700


The patch titled
     Subject: drivers/pcmcia/pd6729.c: convert to module_pci_driver
has been removed from the -mm tree.  Its filename was
     drivers-pcmcia-pd6729c-convert-to-module_pci_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Libo Chen <libo.chen@huawei.com>
Subject: drivers/pcmcia/pd6729.c: convert to module_pci_driver

Use module_pci_driver instead of init/exit, make code clean.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/pd6729.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/pcmcia/pd6729.c~drivers-pcmcia-pd6729c-convert-to-module_pci_driver drivers/pcmcia/pd6729.c
--- a/drivers/pcmcia/pd6729.c~drivers-pcmcia-pd6729c-convert-to-module_pci_driver
+++ a/drivers/pcmcia/pd6729.c
@@ -777,15 +777,4 @@ static struct pci_driver pd6729_pci_driv
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
