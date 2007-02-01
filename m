From: akpm@osdl.org
Subject: + e100-fix-napi-ifdefs-removing-needed-code.patch added to -mm tree
Date: Thu, 01 Feb 2007 14:01:12 -0800
Message-ID: <200702012201.l11M1Cvb024166@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42701 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbXBAWBV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 17:01:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: auke-jan.h.kok@intel.com, jeff@garzik.org, jesse.brandeburg@intel.com, john.ronciak@intel.com


The patch titled
     e100: fix napi ifdefs removing needed code
has been added to the -mm tree.  Its filename is
     e100-fix-napi-ifdefs-removing-needed-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: e100: fix napi ifdefs removing needed code
From: Auke Kok <auke-jan.h.kok@intel.com>

The e100 driver is NAPI mode only.  We need to netif_poll_disable during
suspend and shutdown.  The non-NAPI driver code was removed and is only
avaiable in the out-of-tree e100 kernel driver.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
Cc: John Ronciak <john.ronciak@intel.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/e100.c |    7 +------
 1 files changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/net/e100.c~e100-fix-napi-ifdefs-removing-needed-code drivers/net/e100.c
--- a/drivers/net/e100.c~e100-fix-napi-ifdefs-removing-needed-code
+++ a/drivers/net/e100.c
@@ -2664,14 +2664,12 @@ static int e100_suspend(struct pci_dev *
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct nic *nic = netdev_priv(netdev);
 
-#ifdef CONFIG_E100_NAPI
 	if (netif_running(netdev))
 		netif_poll_disable(nic->netdev);
-#endif
 	del_timer_sync(&nic->watchdog);
 	netif_carrier_off(nic->netdev);
-
 	netif_device_detach(netdev);
+
 	pci_save_state(pdev);
 
 	if ((nic->flags & wol_magic) | e100_asf(nic)) {
@@ -2707,16 +2705,13 @@ static int e100_resume(struct pci_dev *p
 }
 #endif /* CONFIG_PM */
 
-
 static void e100_shutdown(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct nic *nic = netdev_priv(netdev);
 
-#ifdef CONFIG_E100_NAPI
 	if (netif_running(netdev))
 		netif_poll_disable(nic->netdev);
-#endif
 	del_timer_sync(&nic->watchdog);
 	netif_carrier_off(nic->netdev);
 
_

Patches currently in -mm which might be from auke-jan.h.kok@intel.com are

git-netdev-all.patch
e100-fix-napi-ifdefs-removing-needed-code.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
e1000-use-flush_keventd_work.patch
e1000_7033_dump_ring.patch
e1000-printk-warning-fixes.patch
