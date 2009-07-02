From: akpm@linux-foundation.org
Subject: + drivers-net-r6040c-minor-code-cleanup.patch added to -mm tree
Date: Thu, 02 Jul 2009 16:22:39 -0700
Message-ID: <200907022322.n62NMdIX024834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751027AbZGBXWz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 19:22:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael@free-electrons.com, florian@openwrt.org


The patch titled
     drivers/net/r6040.c: minor code cleanup
has been added to the -mm tree.  Its filename is
     drivers-net-r6040c-minor-code-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/r6040.c: minor code cleanup
From: Michael Opdenacker <michael@free-electrons.com>

Replaced '0' by 'bar' in the probe function.

The 'bar' variable was already set to '0' and is already used in
pci_iomap().  This is cleaner and improves code consistency.

Signed-off-by: Michael Opdenacker <michael@free-electrons.com>
Acked-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/r6040.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/r6040.c~drivers-net-r6040c-minor-code-cleanup drivers/net/r6040.c
--- a/drivers/net/r6040.c~drivers-net-r6040c-minor-code-cleanup
+++ a/drivers/net/r6040.c
@@ -1112,13 +1112,13 @@ static int __devinit r6040_init_one(stru
 	}
 
 	/* IO Size check */
-	if (pci_resource_len(pdev, 0) < io_size) {
+	if (pci_resource_len(pdev, bar) < io_size) {
 		printk(KERN_ERR DRV_NAME ": Insufficient PCI resources, aborting\n");
 		err = -EIO;
 		goto err_out;
 	}
 
-	pioaddr = pci_resource_start(pdev, 0);	/* IO map base address */
+	pioaddr = pci_resource_start(pdev, bar);	/* IO map base address */
 	pci_set_master(pdev);
 
 	dev = alloc_etherdev(sizeof(struct r6040_private));
_

Patches currently in -mm which might be from michael@free-electrons.com are

drivers-net-r6040c-minor-code-cleanup.patch

