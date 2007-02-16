From: akpm@linux-foundation.org
Subject: + sis190-rtnl-and-flush_scheduled_work-deadlock.patch added to -mm tree
Date: Thu, 15 Feb 2007 17:20:34 -0800
Message-ID: <200702160120.l1G1Kd32015319@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42076 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbXBPBUm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 20:20:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: romieu@fr.zoreil.com


The patch titled
     sis190: RTNL and flush_scheduled_work deadlock
has been added to the -mm tree.  Its filename is
     sis190-rtnl-and-flush_scheduled_work-deadlock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sis190: RTNL and flush_scheduled_work deadlock
From: Francois Romieu <romieu@fr.zoreil.com>

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sis190.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/net/sis190.c~sis190-rtnl-and-flush_scheduled_work-deadlock drivers/net/sis190.c
--- a/drivers/net/sis190.c~sis190-rtnl-and-flush_scheduled_work-deadlock
+++ a/drivers/net/sis190.c
@@ -909,6 +909,9 @@ static void sis190_phy_task(struct work_
 
 	rtnl_lock();
 
+	if (!netif_running(dev))
+		goto out_unlock;
+
 	val = mdio_read(ioaddr, phy_id, MII_BMCR);
 	if (val & BMCR_RESET) {
 		// FIXME: needlessly high ?  -- FR 02/07/2005
@@ -981,6 +984,7 @@ static void sis190_phy_task(struct work_
 		netif_carrier_on(dev);
 	}
 
+out_unlock:
 	rtnl_unlock();
 }
 
@@ -1102,8 +1106,6 @@ static void sis190_down(struct net_devic
 
 	netif_stop_queue(dev);
 
-	flush_scheduled_work();
-
 	do {
 		spin_lock_irq(&tp->lock);
 
@@ -1857,6 +1859,7 @@ static void __devexit sis190_remove_one(
 	struct net_device *dev = pci_get_drvdata(pdev);
 
 	sis190_mii_remove(dev);
+	flush_scheduled_work();
 	unregister_netdev(dev);
 	sis190_release_board(pdev);
 	pci_set_drvdata(pdev, NULL);
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

origin.patch
r8169-rtnl-and-flush_scheduled_work-deadlock.patch
sis190-rtnl-and-flush_scheduled_work-deadlock.patch
8139too-rtnl-and-flush_scheduled_work-deadlock.patch
s2io-rtnl-and-flush_scheduled_work-deadlock.patch
