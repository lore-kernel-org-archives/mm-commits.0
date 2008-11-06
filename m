From: akpm@linux-foundation.org
Subject: + igb-use-device_set_wakeup_enable.patch added to -mm tree
Date: Thu, 06 Nov 2008 13:37:41 -0800
Message-ID: <200811062137.mA6Lbf9m001093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbYKFViD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 16:38:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl


The patch titled
     igb: use device_set_wakeup_enable
has been added to the -mm tree.  Its filename is
     igb-use-device_set_wakeup_enable.patch

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
Subject: igb: use device_set_wakeup_enable
From: Rafael J. Wysocki <rjw@sisk.pl>

Since dev->power.should_wakeup bit is used by the PCI core to decide
whether the device should wake up the system from sleep states, set/unset
this bit whenever WOL is enabled/disabled using igb_set_wol(). 
Accordingly, use device_can_wakeup() for checking if wake-up is supported
by the device.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/igb/igb_ethtool.c |    8 ++++++--
 drivers/net/igb/igb_main.c    |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/net/igb/igb_ethtool.c~igb-use-device_set_wakeup_enable drivers/net/igb/igb_ethtool.c
--- a/drivers/net/igb/igb_ethtool.c~igb-use-device_set_wakeup_enable
+++ a/drivers/net/igb/igb_ethtool.c
@@ -1776,7 +1776,8 @@ static void igb_get_wol(struct net_devic
 
 	/* this function will set ->supported = 0 and return 1 if wol is not
 	 * supported by this hardware */
-	if (igb_wol_exclusion(adapter, wol))
+	if (igb_wol_exclusion(adapter, wol) ||
+	    !device_can_wakeup(&adapter->pdev->dev))
 		return;
 
 	/* apply any specific unsupported masks here */
@@ -1805,7 +1806,8 @@ static int igb_set_wol(struct net_device
 	if (wol->wolopts & (WAKE_PHY | WAKE_ARP | WAKE_MAGICSECURE))
 		return -EOPNOTSUPP;
 
-	if (igb_wol_exclusion(adapter, wol))
+	if (igb_wol_exclusion(adapter, wol) ||
+	    !device_can_wakeup(&adapter->pdev->dev))
 		return wol->wolopts ? -EOPNOTSUPP : 0;
 
 	switch (hw->device_id) {
@@ -1825,6 +1827,8 @@ static int igb_set_wol(struct net_device
 	if (wol->wolopts & WAKE_MAGIC)
 		adapter->wol |= E1000_WUFC_MAG;
 
+	device_set_wakeup_enable(&adapter->pdev->dev, adapter->wol);
+
 	return 0;
 }
 
diff -puN drivers/net/igb/igb_main.c~igb-use-device_set_wakeup_enable drivers/net/igb/igb_main.c
--- a/drivers/net/igb/igb_main.c~igb-use-device_set_wakeup_enable
+++ a/drivers/net/igb/igb_main.c
@@ -1244,6 +1244,7 @@ static int __devinit igb_probe(struct pc
 
 	/* initialize the wol settings based on the eeprom settings */
 	adapter->wol = adapter->eeprom_wol;
+	device_set_wakeup_enable(&adapter->pdev->dev, adapter->wol);
 
 	/* reset the hardware with the new settings */
 	igb_reset(adapter);
_

Patches currently in -mm which might be from rjw@sisk.pl are

linux-next.patch
e1000e-use-device_set_wakeup_enable.patch
e1000-use-device_set_wakeup_enable.patch
igb-use-device_set_wakeup_enable.patch
shrink_slab-handle-bad-shrinkers.patch

