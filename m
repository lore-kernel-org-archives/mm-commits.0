From: akpm@linux-foundation.org
Subject: - e1000e-incorporate-napi_struct-changes-from-net-2624git.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:27:21 -0700
Message-ID: <200709160927.l8G9RLIo009253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54350 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbXIPJiZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: auke-jan.h.kok@intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     e1000e: incorporate napi_struct changes from net-2.6.24.git
has been removed from the -mm tree.  Its filename was
     e1000e-incorporate-napi_struct-changes-from-net-2624git.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: e1000e: incorporate napi_struct changes from net-2.6.24.git
From: Auke Kok <auke-jan.h.kok@intel.com>

This incorporates the new napi_struct changes into e1000e. Included
bugfix for ifdown hang from Krishna Kumar for e1000.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000e/e1000.h  |    2 +
 drivers/net/e1000e/netdev.c |   35 +++++++++++++++-------------------
 2 files changed, 18 insertions(+), 19 deletions(-)

diff -puN drivers/net/e1000e/e1000.h~e1000e-incorporate-napi_struct-changes-from-net-2624git drivers/net/e1000e/e1000.h
--- a/drivers/net/e1000e/e1000.h~e1000e-incorporate-napi_struct-changes-from-net-2624git
+++ a/drivers/net/e1000e/e1000.h
@@ -188,6 +188,8 @@ struct e1000_adapter {
 	struct e1000_ring *tx_ring /* One per active queue */
 						____cacheline_aligned_in_smp;
 
+	struct napi_struct napi;
+
 	unsigned long tx_queue_len;
 	unsigned int restart_queue;
 	u32 txd_cmd;
diff -puN drivers/net/e1000e/netdev.c~e1000e-incorporate-napi_struct-changes-from-net-2624git drivers/net/e1000e/netdev.c
--- a/drivers/net/e1000e/netdev.c~e1000e-incorporate-napi_struct-changes-from-net-2624git
+++ a/drivers/net/e1000e/netdev.c
@@ -1149,12 +1149,12 @@ static irqreturn_t e1000_intr_msi(int ir
 			mod_timer(&adapter->watchdog_timer, jiffies + 1);
 	}
 
-	if (netif_rx_schedule_prep(netdev)) {
+	if (netif_rx_schedule_prep(netdev, &adapter->napi)) {
 		adapter->total_tx_bytes = 0;
 		adapter->total_tx_packets = 0;
 		adapter->total_rx_bytes = 0;
 		adapter->total_rx_packets = 0;
-		__netif_rx_schedule(netdev);
+		__netif_rx_schedule(netdev, &adapter->napi);
 	} else {
 		atomic_dec(&adapter->irq_sem);
 	}
@@ -1212,12 +1212,12 @@ static irqreturn_t e1000_intr(int irq, v
 			mod_timer(&adapter->watchdog_timer, jiffies + 1);
 	}
 
-	if (netif_rx_schedule_prep(netdev)) {
+	if (netif_rx_schedule_prep(netdev, &adapter->napi)) {
 		adapter->total_tx_bytes = 0;
 		adapter->total_tx_packets = 0;
 		adapter->total_rx_bytes = 0;
 		adapter->total_rx_packets = 0;
-		__netif_rx_schedule(netdev);
+		__netif_rx_schedule(netdev, &adapter->napi);
 	} else {
 		atomic_dec(&adapter->irq_sem);
 	}
@@ -1662,10 +1662,10 @@ set_itr_now:
  * e1000_clean - NAPI Rx polling callback
  * @adapter: board private structure
  **/
-static int e1000_clean(struct net_device *poll_dev, int *budget)
+static int e1000_clean(struct napi_struct *napi, int budget)
 {
-	struct e1000_adapter *adapter;
-	int work_to_do = min(*budget, poll_dev->quota);
+	struct e1000_adapter *adapter = container_of(napi, struct e1000_adapter, napi);
+	struct net_device *poll_dev = adapter->netdev;
 	int tx_cleaned = 0, work_done = 0;
 
 	/* Must NOT use netdev_priv macro here. */
@@ -1684,17 +1684,15 @@ static int e1000_clean(struct net_device
 		spin_unlock(&adapter->tx_queue_lock);
 	}
 
-	adapter->clean_rx(adapter, &work_done, work_to_do);
-	*budget -= work_done;
-	poll_dev->quota -= work_done;
+	adapter->clean_rx(adapter, &work_done, budget);
 
 	/* If no Tx and not enough Rx work done, exit the polling mode */
-	if ((!tx_cleaned && (work_done == 0)) ||
+	if ((tx_cleaned && (work_done < budget)) ||
 	   !netif_running(poll_dev)) {
 quit_polling:
 		if (adapter->itr_setting & 3)
 			e1000_set_itr(adapter);
-		netif_rx_complete(poll_dev);
+		netif_rx_complete(poll_dev, napi);
 		if (test_bit(__E1000_DOWN, &adapter->state))
 			atomic_dec(&adapter->irq_sem);
 		else
@@ -1702,7 +1700,7 @@ quit_polling:
 		return 0;
 	}
 
-	return 1;
+	return work_done;
 }
 
 static void e1000_vlan_rx_add_vid(struct net_device *netdev, u16 vid)
@@ -2439,7 +2437,7 @@ int e1000e_up(struct e1000_adapter *adap
 
 	clear_bit(__E1000_DOWN, &adapter->state);
 
-	netif_poll_enable(adapter->netdev);
+	napi_enable(&adapter->napi);
 	e1000_irq_enable(adapter);
 
 	/* fire a link change interrupt to start the watchdog */
@@ -2472,7 +2470,7 @@ void e1000e_down(struct e1000_adapter *a
 	e1e_flush();
 	msleep(10);
 
-	netif_poll_disable(netdev);
+	napi_disable(&adapter->napi);
 	e1000_irq_disable(adapter);
 
 	del_timer_sync(&adapter->watchdog_timer);
@@ -2605,7 +2603,7 @@ static int e1000_open(struct net_device 
 	/* From here on the code is the same as e1000e_up() */
 	clear_bit(__E1000_DOWN, &adapter->state);
 
-	netif_poll_enable(netdev);
+	napi_enable(&adapter->napi);
 
 	e1000_irq_enable(adapter);
 
@@ -4090,8 +4088,7 @@ static int __devinit e1000_probe(struct 
 	e1000e_set_ethtool_ops(netdev);
 	netdev->tx_timeout		= &e1000_tx_timeout;
 	netdev->watchdog_timeo		= 5 * HZ;
-	netdev->poll			= &e1000_clean;
-	netdev->weight			= 64;
+	netif_napi_add(netdev, &adapter->napi, e1000_clean, 64);
 	netdev->vlan_rx_register	= e1000_vlan_rx_register;
 	netdev->vlan_rx_add_vid		= e1000_vlan_rx_add_vid;
 	netdev->vlan_rx_kill_vid	= e1000_vlan_rx_kill_vid;
@@ -4260,7 +4257,7 @@ static int __devinit e1000_probe(struct 
 	/* tell the stack to leave us alone until e1000_open() is called */
 	netif_carrier_off(netdev);
 	netif_stop_queue(netdev);
-	netif_poll_disable(netdev);
+	napi_disable(&adapter->napi);
 
 	strcpy(netdev->name, "eth%d");
 	err = register_netdev(netdev);
_

Patches currently in -mm which might be from auke-jan.h.kok@intel.com are

git-hwmon.patch
git-net.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
e1000-if-0-two-functions.patch
