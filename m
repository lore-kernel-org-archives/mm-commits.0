From: akpm@linux-foundation.org
Subject: - driver-net-skgec-restart-the-interface-when-its-options-or-pauseparam-is-set-update.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:28:10 -0700
Message-ID: <200810092228.m99MSAjM006049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751309AbYJIW2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:28:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Xiaoming.Zhang@resilience.com, jeff@garzik.org, shemminger@vyatta.com, xiaoming.zhang@resilience.com, mm-commits@vger.kernel.org


The patch titled
     driver-net-skgec-restart-the-interface-when-its-options-or-pauseparam-is-set update
has been removed from the -mm tree.  Its filename was
     driver-net-skgec-restart-the-interface-when-its-options-or-pauseparam-is-set-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: driver-net-skgec-restart-the-interface-when-its-options-or-pauseparam-is-set update
From: "Xiaoming.Zhang" <Xiaoming.Zhang@resilience.com>

Since skge_up can fail because of out of memory, this code needs to
check the return value. And then if it fails the "limbo state" needs
to be handled in skge_down.

Signed-off-by: Zhang Xiaoming <xiaoming.zhang@resilience.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/skge.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN drivers/net/skge.c~driver-net-skgec-restart-the-interface-when-its-options-or-pauseparam-is-set-update drivers/net/skge.c
--- a/drivers/net/skge.c~driver-net-skgec-restart-the-interface-when-its-options-or-pauseparam-is-set-update
+++ a/drivers/net/skge.c
@@ -305,6 +305,7 @@ static int skge_set_settings(struct net_
 	struct skge_port *skge = netdev_priv(dev);
 	const struct skge_hw *hw = skge->hw;
 	u32 supported = skge_supported_modes(hw);
+	int err = 0;
 
 	if (ecmd->autoneg == AUTONEG_ENABLE) {
 		ecmd->advertising = supported;
@@ -355,7 +356,11 @@ static int skge_set_settings(struct net_
 
 	if (netif_running(dev)) {
 		skge_down(dev);
-		skge_up(dev);
+		err = skge_up(dev);
+		if (err) {
+			dev_close(dev);
+			return err;
+		}
 	}
 
 	return (0);
@@ -581,6 +586,7 @@ static int skge_set_pauseparam(struct ne
 {
 	struct skge_port *skge = netdev_priv(dev);
 	struct ethtool_pauseparam old;
+	int err = 0;
 
 	skge_get_pauseparam(dev, &old);
 
@@ -599,7 +605,11 @@ static int skge_set_pauseparam(struct ne
 
 	if (netif_running(dev)) {
 		skge_down(dev);
-		skge_up(dev);
+		err = skge_up(dev);
+		if (err) {
+			dev_close(dev);
+			return err;
+		}
 	}
 
 	return 0;
_

Patches currently in -mm which might be from Xiaoming.Zhang@resilience.com are

git-net.patch

