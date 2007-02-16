From: akpm@linux-foundation.org
Subject: + e1000-fix-shared-interrupt-warning-message.patch added to -mm tree
Date: Thu, 15 Feb 2007 22:03:15 -0800
Message-ID: <200702160603.l1G63F2n021207@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52079 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932604AbXBPGDR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 01:03:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesse.brandeburg@intel.com, auke-jan.h.kok@intel.com


The patch titled
     e1000: fix shared interrupt warning message
has been added to the -mm tree.  Its filename is
     e1000-fix-shared-interrupt-warning-message.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
e1000-fix-shared-interrupt-warning-message.patch
e1000-fix-shared-interrupt-warning-message-fix.patch
