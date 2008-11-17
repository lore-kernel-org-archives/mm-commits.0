From: akpm@linux-foundation.org
Subject: - e1000-use-device_set_wakeup_enable.patch removed from -mm tree
Date: Mon, 17 Nov 2008 13:27:25 -0800
Message-ID: <200811172127.mAHLRP7P024227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752029AbYKQV2A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Nov 2008 16:28:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     e1000: use device_set_wakeup_enable
has been removed from the -mm tree.  Its filename was
     e1000-use-device_set_wakeup_enable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e1000: use device_set_wakeup_enable
From: Rafael J. Wysocki <rjw@sisk.pl>

Since dev->power.should_wakeup bit is used by the PCI core to decide
whether the device should wake up the system from sleep states, set/unset
this bit whenever WOL is enabled/disabled using e1000_set_wol(). 
Accordingly, use device_can_wakeup() for checking if wake-up is supported
by the device.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000_ethtool.c |    8 ++++++--
 drivers/net/e1000/e1000_main.c    |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/net/e1000/e1000_ethtool.c~e1000-use-device_set_wakeup_enable drivers/net/e1000/e1000_ethtool.c
--- a/drivers/net/e1000/e1000_ethtool.c~e1000-use-device_set_wakeup_enable
+++ a/drivers/net/e1000/e1000_ethtool.c
@@ -1774,7 +1774,8 @@ static void e1000_get_wol(struct net_dev
 
 	/* this function will set ->supported = 0 and return 1 if wol is not
 	 * supported by this hardware */
-	if (e1000_wol_exclusion(adapter, wol))
+	if (e1000_wol_exclusion(adapter, wol) ||
+	    !device_can_wakeup(&adapter->pdev->dev))
 		return;
 
 	/* apply any specific unsupported masks here */
@@ -1811,7 +1812,8 @@ static int e1000_set_wol(struct net_devi
 	if (wol->wolopts & (WAKE_PHY | WAKE_ARP | WAKE_MAGICSECURE))
 		return -EOPNOTSUPP;
 
-	if (e1000_wol_exclusion(adapter, wol))
+	if (e1000_wol_exclusion(adapter, wol) ||
+	    !device_can_wakeup(&adapter->pdev->dev))
 		return wol->wolopts ? -EOPNOTSUPP : 0;
 
 	switch (hw->device_id) {
@@ -1838,6 +1840,8 @@ static int e1000_set_wol(struct net_devi
 	if (wol->wolopts & WAKE_MAGIC)
 		adapter->wol |= E1000_WUFC_MAG;
 
+	device_set_wakeup_enable(&adapter->pdev->dev, adapter->wol);
+
 	return 0;
 }
 
diff -puN drivers/net/e1000/e1000_main.c~e1000-use-device_set_wakeup_enable drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~e1000-use-device_set_wakeup_enable
+++ a/drivers/net/e1000/e1000_main.c
@@ -1175,6 +1175,7 @@ static int __devinit e1000_probe(struct 
 
 	/* initialize the wol settings based on the eeprom settings */
 	adapter->wol = adapter->eeprom_wol;
+	device_set_wakeup_enable(&adapter->pdev->dev, adapter->wol);
 
 	/* print bus type/speed/width info */
 	DPRINTK(PROBE, INFO, "(PCI%s:%s:%s) ",
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
vfs-fix-switch_names-breakage-in-short-to-short-case.patch
shrink_slab-handle-bad-shrinkers.patch

