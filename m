From: akpm@linux-foundation.org
Subject: + sc92031-sysfs-link-missing.patch added to -mm tree
Date: Thu, 03 Apr 2008 14:57:33 -0700
Message-ID: <200804032157.m33LvXT5024658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:61000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754716AbYDCV62 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 17:58:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@vyatta.com, cesarb@cesarb.net, jgarzik@pobox.com, tom@sharkbay.at


The patch titled
     sc92031: sysfs link missing
has been added to the -mm tree.  Its filename is
     sc92031-sysfs-link-missing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sc92031: sysfs link missing
From: Stephen Hemminger <shemminger@vyatta.com>

Add missing sysfs device association. Compile tested only -ENOHW.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: <tom@sharkbay.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sc92031.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/sc92031.c~sc92031-sysfs-link-missing drivers/net/sc92031.c
--- a/drivers/net/sc92031.c~sc92031-sysfs-link-missing
+++ a/drivers/net/sc92031.c
@@ -1446,6 +1446,7 @@ static int __devinit sc92031_probe(struc
 	}
 
 	pci_set_drvdata(pdev, dev);
+	SET_NETDEV_DEV(dev, &hw->pdev->dev);
 
 #if SC92031_USE_BAR == 0
 	dev->mem_start = pci_resource_start(pdev, SC92031_USE_BAR);
_

Patches currently in -mm which might be from shemminger@vyatta.com are

git-net.patch
sc92031-sysfs-link-missing.patch

