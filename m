From: akpm@linux-foundation.org
Subject: - e1000e-use-device_set_wakeup_enable.patch removed from -mm tree
Date: Mon, 17 Nov 2008 13:27:23 -0800
Message-ID: <200811172127.mAHLRNPg024221@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005AbYKQV15 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Nov 2008 16:27:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     e1000e: use device_set_wakeup_enable
has been removed from the -mm tree.  Its filename was
     e1000e-use-device_set_wakeup_enable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e1000e: use device_set_wakeup_enable
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Since dev->power.should_wakeup bit is used by the PCI core to decide
whether the device should wake up the system from sleep states, set/unset
this bit whenever WOL is enabled/disabled using e1000_set_wol(). 
Accordingly, use device_can_wakeup() for checking if wake-up is supported
by the device.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000e/ethtool.c |    8 ++++++--
 drivers/net/e1000e/netdev.c  |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/net/e1000e/ethtool.c~e1000e-use-device_set_wakeup_enable drivers/net/e1000e/ethtool.c
--- a/drivers/net/e1000e/ethtool.c~e1000e-use-device_set_wakeup_enable
+++ a/drivers/net/e1000e/ethtool.c
@@ -1713,7 +1713,8 @@ static void e1000_get_wol(struct net_dev
 	wol->supported = 0;
 	wol->wolopts = 0;
 
-	if (!(adapter->flags & FLAG_HAS_WOL))
+	if (!(adapter->flags & FLAG_HAS_WOL) ||
+	    !device_can_wakeup(&adapter->pdev->dev))
 		return;
 
 	wol->supported = WAKE_UCAST | WAKE_MCAST |
@@ -1751,7 +1752,8 @@ static int e1000_set_wol(struct net_devi
 	if (wol->wolopts & WAKE_MAGICSECURE)
 		return -EOPNOTSUPP;
 
-	if (!(adapter->flags & FLAG_HAS_WOL))
+	if (!(adapter->flags & FLAG_HAS_WOL) ||
+	    !device_can_wakeup(&adapter->pdev->dev))
 		return wol->wolopts ? -EOPNOTSUPP : 0;
 
 	/* these settings will always override what we currently have */
@@ -1770,6 +1772,8 @@ static int e1000_set_wol(struct net_devi
 	if (wol->wolopts & WAKE_ARP)
 		adapter->wol |= E1000_WUFC_ARP;
 
+	device_set_wakeup_enable(&adapter->pdev->dev, adapter->wol);
+
 	return 0;
 }
 
diff -puN drivers/net/e1000e/netdev.c~e1000e-use-device_set_wakeup_enable drivers/net/e1000e/netdev.c
--- a/drivers/net/e1000e/netdev.c~e1000e-use-device_set_wakeup_enable
+++ a/drivers/net/e1000e/netdev.c
@@ -4963,6 +4963,7 @@ static int __devinit e1000_probe(struct 
 
 	/* initialize the wol settings based on the eeprom settings */
 	adapter->wol = adapter->eeprom_wol;
+	device_set_wakeup_enable(&adapter->pdev->dev, adapter->wol);
 
 	/* reset the hardware with the new settings */
 	e1000e_reset(adapter);
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
vfs-fix-switch_names-breakage-in-short-to-short-case.patch
shrink_slab-handle-bad-shrinkers.patch

