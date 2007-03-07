From: akpm@linux-foundation.org
Subject: + e1000-fix-be-ready-for-incoming-irq-at-pci_request_irq.patch added to -mm tree
Date: Wed, 07 Mar 2007 14:04:29 -0800
Message-ID: <200703072204.l27M4TBe010444@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33255 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992457AbXCGWEk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 17:04:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: auke-jan.h.kok@intel.com


The patch titled
     e1000: FIX: be ready for incoming irq at pci_request_irq
has been added to the -mm tree.  Its filename is
     e1000-fix-be-ready-for-incoming-irq-at-pci_request_irq.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: e1000: FIX: be ready for incoming irq at pci_request_irq
From: Auke Kok <auke-jan.h.kok@intel.com>

DEBUG_SHIRQ code exposed that e1000 was not ready for incoming interrupts
after having called pci_request_irq.  This obviously requires us to finish our
software setup which assigns the irq handler before we request the irq.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000_main.c |   66 +++++++++++++++++++++----------
 1 files changed, 45 insertions(+), 21 deletions(-)

diff -puN drivers/net/e1000/e1000_main.c~e1000-fix-be-ready-for-incoming-irq-at-pci_request_irq drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~e1000-fix-be-ready-for-incoming-irq-at-pci_request_irq
+++ a/drivers/net/e1000/e1000_main.c
@@ -522,14 +522,15 @@ e1000_release_manageability(struct e1000
 	}
 }
 
-int
-e1000_up(struct e1000_adapter *adapter)
+/**
+ * e1000_configure - configure the hardware for RX and TX
+ * @adapter = private board structure
+ **/
+static void e1000_configure(struct e1000_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
 	int i;
 
-	/* hardware has been reset, we need to reload some things */
-
 	e1000_set_multi(netdev);
 
 	e1000_restore_vlan(adapter);
@@ -548,14 +549,20 @@ e1000_up(struct e1000_adapter *adapter)
 	}
 
 	adapter->tx_queue_len = netdev->tx_queue_len;
+}
+
+int e1000_up(struct e1000_adapter *adapter)
+{
+	/* hardware has been reset, we need to reload some things */
+	e1000_configure(adapter);
+
+	clear_bit(__E1000_DOWN, &adapter->flags);
 
 #ifdef CONFIG_E1000_NAPI
-	netif_poll_enable(netdev);
+	netif_poll_enable(adapter->netdev);
 #endif
 	e1000_irq_enable(adapter);
 
-	clear_bit(__E1000_DOWN, &adapter->flags);
-
 	/* fire a link change interrupt to start the watchdog */
 	E1000_WRITE_REG(&adapter->hw, ICS, E1000_ICS_LSC);
 	return 0;
@@ -640,15 +647,15 @@ e1000_down(struct e1000_adapter *adapter
 	 * reschedule our watchdog timer */
 	set_bit(__E1000_DOWN, &adapter->flags);
 
+#ifdef CONFIG_E1000_NAPI
+	netif_poll_disable(netdev);
+#endif
 	e1000_irq_disable(adapter);
 
 	del_timer_sync(&adapter->tx_fifo_stall_timer);
 	del_timer_sync(&adapter->watchdog_timer);
 	del_timer_sync(&adapter->phy_info_timer);
 
-#ifdef CONFIG_E1000_NAPI
-	netif_poll_disable(netdev);
-#endif
 	netdev->tx_queue_len = adapter->tx_queue_len;
 	adapter->link_speed = 0;
 	adapter->link_duplex = 0;
@@ -1410,21 +1417,17 @@ e1000_open(struct net_device *netdev)
 		return -EBUSY;
 
 	/* allocate transmit descriptors */
-	if ((err = e1000_setup_all_tx_resources(adapter)))
+	err = e1000_setup_all_tx_resources(adapter);
+	if (err)
 		goto err_setup_tx;
 
 	/* allocate receive descriptors */
-	if ((err = e1000_setup_all_rx_resources(adapter)))
-		goto err_setup_rx;
-
-	err = e1000_request_irq(adapter);
+	err = e1000_setup_all_rx_resources(adapter);
 	if (err)
-		goto err_req_irq;
+		goto err_setup_rx;
 
 	e1000_power_up_phy(adapter);
 
-	if ((err = e1000_up(adapter)))
-		goto err_up;
 	adapter->mng_vlan_id = E1000_MNG_VLAN_NONE;
 	if ((adapter->hw.mng_cookie.status &
 			  E1000_MNG_DHCP_COOKIE_STATUS_VLAN_SUPPORT)) {
@@ -1437,12 +1440,33 @@ e1000_open(struct net_device *netdev)
 	    e1000_check_mng_mode(&adapter->hw))
 		e1000_get_hw_control(adapter);
 
+	/* before we allocate an interrupt, we must be ready to handle it.
+	 * Setting DEBUG_SHIRQ in the kernel makes it fire an interrupt
+	 * as soon as we call pci_request_irq, so we have to setup our
+	 * clean_rx handler before we do so.  */
+	e1000_configure(adapter);
+
+	err = e1000_request_irq(adapter);
+	if (err)
+		goto err_req_irq;
+
+	/* From here on the code is the same as e1000_up() */
+	clear_bit(__E1000_DOWN, &adapter->flags);
+
+#ifdef CONFIG_E1000_NAPI
+	netif_poll_enable(netdev);
+#endif
+
+	e1000_irq_enable(adapter);
+
+	/* fire a link status change interrupt to start the watchdog */
+	E1000_WRITE_REG(&adapter->hw, ICS, E1000_ICS_LSC);
+
 	return E1000_SUCCESS;
 
-err_up:
-	e1000_power_down_phy(adapter);
-	e1000_free_irq(adapter);
 err_req_irq:
+	e1000_release_hw_control(adapter);
+	e1000_power_down_phy(adapter);
 	e1000_free_all_rx_resources(adapter);
 err_setup_rx:
 	e1000_free_all_tx_resources(adapter);
_

Patches currently in -mm which might be from auke-jan.h.kok@intel.com are

git-netdev-all.patch
e1000-fix-be-ready-for-incoming-irq-at-pci_request_irq.patch
e1000-fix-firmware-handover-bits.patch
e1000-fix-stop-raw-interrupts-disabled-nag-from-rt.patch
e1000-use-flush_keventd_work.patch
e1000_7033_dump_ring.patch
e1000-printk-warning-fixes.patch
