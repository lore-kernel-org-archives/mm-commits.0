From: akpm@linux-foundation.org
Subject: - e1000-fix-shared-interrupt-warning-message.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:14:46 -0800
Message-ID: <200702180214.l1I2Ek72008307@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55617 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993083AbXBRCOs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:14:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesse.brandeburg@intel.com, auke-jan.h.kok@intel.com, mm-commits@vger.kernel.org


The patch titled
     e1000: fix shared interrupt warning message
has been removed from the -mm tree.  Its filename was
     e1000-fix-shared-interrupt-warning-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: e1000: fix shared interrupt warning message
From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000_main.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/net/e1000/e1000_main.c~e1000-fix-shared-interrupt-warning-message drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~e1000-fix-shared-interrupt-warning-message
+++ a/drivers/net/e1000/e1000_main.c
@@ -1417,10 +1417,6 @@ e1000_open(struct net_device *netdev)
 	if ((err = e1000_setup_all_rx_resources(adapter)))
 		goto err_setup_rx;
 
-	err = e1000_request_irq(adapter);
-	if (err)
-		goto err_req_irq;
-
 	e1000_power_up_phy(adapter);
 
 	if ((err = e1000_up(adapter)))
@@ -1431,6 +1427,10 @@ e1000_open(struct net_device *netdev)
 		e1000_update_mng_vlan(adapter);
 	}
 
+	err = e1000_request_irq(adapter);
+	if (err)
+		goto err_req_irq;
+
 	/* If AMT is enabled, let the firmware know that the network
 	 * interface is now open */
 	if (adapter->hw.mac_type == e1000_82573 &&
@@ -1439,10 +1439,11 @@ e1000_open(struct net_device *netdev)
 
 	return E1000_SUCCESS;
 
+err_req_irq:
+	e1000_down(adapter);
+	e1000_free_irq(adapter);
 err_up:
 	e1000_power_down_phy(adapter);
-	e1000_free_irq(adapter);
-err_req_irq:
 	e1000_free_all_rx_resources(adapter);
 err_setup_rx:
 	e1000_free_all_tx_resources(adapter);
_

Patches currently in -mm which might be from jesse.brandeburg@intel.com are

origin.patch
git-netdev-all.patch
