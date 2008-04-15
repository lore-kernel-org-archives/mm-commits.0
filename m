From: akpm@linux-foundation.org
Subject: - sc92031-sysfs-link-missing.patch removed from -mm tree
Date: Tue, 15 Apr 2008 02:10:56 -0700
Message-ID: <200804150910.m3F9AuMM020665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762912AbYDOJLw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 05:11:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@vyatta.com, cesarb@cesarb.net, jgarzik@pobox.com, tom@sharkbay.at, mm-commits@vger.kernel.org


The patch titled
     sc92031: sysfs link missing
has been removed from the -mm tree.  Its filename was
     sc92031-sysfs-link-missing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sc92031: sysfs link missing
From: Stephen Hemminger <shemminger@vyatta.com>

Add missing sysfs device association. Compile tested only -ENOHW.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=10380

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
@@ -1444,6 +1444,7 @@ static int __devinit sc92031_probe(struc
 	}
 
 	pci_set_drvdata(pdev, dev);
+	SET_NETDEV_DEV(dev, &pdev->dev);
 
 #if SC92031_USE_BAR == 0
 	dev->mem_start = pci_resource_start(pdev, SC92031_USE_BAR);
_

Patches currently in -mm which might be from shemminger@vyatta.com are

origin.patch
git-net.patch
sc92031-use-net_device-stats.patch

