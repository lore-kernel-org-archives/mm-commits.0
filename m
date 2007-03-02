From: akpm@linux-foundation.org
Subject: + vlan-net-drivers-avoid-a-4-order-allocation.patch added to -mm tree
Date: Fri, 02 Mar 2007 13:24:57 -0800
Message-ID: <200703022124.l22LOvt2019370@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41548 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965658AbXCBVZK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 16:25:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: da-x@monatomic.org, greearb@candelatech.com


The patch titled
     vlan & net drivers: avoid a 4-order allocation
has been added to the -mm tree.  Its filename is
     vlan-net-drivers-avoid-a-4-order-allocation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vlan & net drivers: avoid a 4-order allocation
From: Dan Aloni <da-x@monatomic.org>

This patch splits the vlan_group struct into a multi-allocated struct. On
x86_64, the size of the original struct is a little more than 32KB, causing
a 4-order allocation, which is prune to problems caused by buddy-system
external fragmentation conditions.

I couldn't just use vmalloc() because vfree() cannot be called in the
softirq context of the RCU callback.

Signed-off-by: Dan Aloni <da-x@monatomic.org>
Cc: Ben Greear <greearb@candelatech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/8139cp.c            |    3 --
 drivers/net/acenic.c            |    5 ---
 drivers/net/amd8111e.c          |    3 --
 drivers/net/bnx2.c              |    4 --
 drivers/net/bonding/bond_main.c |   14 +++++-----
 drivers/net/chelsio/cxgb2.c     |    3 --
 drivers/net/e1000/e1000_main.c  |   13 +++------
 drivers/net/ehea/ehea_main.c    |    3 --
 drivers/net/gianfar.c           |    3 --
 drivers/net/ixgb/ixgb_main.c    |    5 +--
 drivers/net/ns83820.c           |    3 --
 drivers/net/r8169.c             |    3 --
 drivers/net/s2io.c              |    3 --
 drivers/net/sky2.c              |    3 --
 drivers/net/starfire.c          |    5 +--
 drivers/net/tg3.c               |    3 --
 drivers/net/typhoon.c           |    3 --
 drivers/s390/net/qeth_main.c    |   25 +++++++++--------
 include/linux/if_vlan.h         |   25 +++++++++++++++--
 net/8021q/vlan.c                |   42 ++++++++++++++++++++++--------
 20 files changed, 96 insertions(+), 75 deletions(-)

diff -puN drivers/net/8139cp.c~vlan-net-drivers-avoid-a-4-order-allocation drivers/net/8139cp.c
--- a/drivers/net/8139cp.c~vlan-net-drivers-avoid-a-4-order-allocation
+++ a/drivers/net/8139cp.c
@@ -448,8 +448,7 @@ static void cp_vlan_rx_kill_vid(struct n
 	spin_lock_irqsave(&cp->lock, flags);
 	cp->cpcmd &= ~RxVlanOn;
 	cpw16(CpCmd, cp->cpcmd);
-	if (cp->vlgrp)
-		cp->vlgrp->vlan_devices[vid] = NULL;
+	vlan_group_set_device(cp->vlgrp, vid, NULL);
 	spin_unlock_irqrestore(&cp->lock, flags);
 }
 #endif /* CP_VLAN_TAG_USED */
diff -puN drivers/net/acenic.c~vlan-net-drivers-avoid-a-4-order-allocation drivers/net/acenic.c
--- a/drivers/net/acenic.c~vlan-net-drivers-avoid-a-4-order-allocation
+++ a/drivers/net/acenic.c
@@ -2293,10 +2293,7 @@ static void ace_vlan_rx_kill_vid(struct 
 
 	local_irq_save(flags);
 	ace_mask_irq(dev);
-
-	if (ap->vlgrp)
-		ap->vlgrp->vlan_devices[vid] = NULL;
-
+	vlan_group_set_device(ap->vlgrp, vid, NULL);
 	ace_unmask_irq(dev);
 	local_irq_restore(flags);
 }
diff -puN drivers/net/amd8111e.c~vlan-net-drivers-avoid-a-4-order-allocation drivers/net/amd8111e.c
--- a/drivers/net/amd8111e.c~vlan-net-drivers-avoid-a-4-order-allocation
+++ a/drivers/net/amd8111e.c
@@ -1737,8 +1737,7 @@ static void amd8111e_vlan_rx_kill_vid(st
 {
 	struct amd8111e_priv *lp = netdev_priv(dev);
 	spin_lock_irq(&lp->lock);
-	if (lp->vlgrp)
-		lp->vlgrp->vlan_devices[vid] = NULL;
+	vlan_group_set_device(lp->vlgrp, vid, NULL);
 	spin_unlock_irq(&lp->lock);
 }
 #endif
diff -puN drivers/net/bnx2.c~vlan-net-drivers-avoid-a-4-order-allocation drivers/net/bnx2.c
--- a/drivers/net/bnx2.c~vlan-net-drivers-avoid-a-4-order-allocation
+++ a/drivers/net/bnx2.c
@@ -4467,9 +4467,7 @@ bnx2_vlan_rx_kill_vid(struct net_device 
 	struct bnx2 *bp = netdev_priv(dev);
 
 	bnx2_netif_stop(bp);
-
-	if (bp->vlgrp)
-		bp->vlgrp->vlan_devices[vid] = NULL;
+	vlan_group_set_device(bp->vlgrp, vid, NULL);
 	bnx2_set_rx_mode(dev);
 
 	bnx2_netif_start(bp);
diff -puN drivers/net/bonding/bond_main.c~vlan-net-drivers-avoid-a-4-order-allocation drivers/net/bonding/bond_main.c
--- a/drivers/net/bonding/bond_main.c~vlan-net-drivers-avoid-a-4-order-allocation
+++ a/drivers/net/bonding/bond_main.c
@@ -488,9 +488,9 @@ static void bond_vlan_rx_kill_vid(struct
 			/* Save and then restore vlan_dev in the grp array,
 			 * since the slave's driver might clear it.
 			 */
-			vlan_dev = bond->vlgrp->vlan_devices[vid];
+			vlan_dev = vlan_group_get_device(bond->vlgrp, vid);
 			slave_dev->vlan_rx_kill_vid(slave_dev, vid);
-			bond->vlgrp->vlan_devices[vid] = vlan_dev;
+			vlan_group_set_device(bond->vlgrp, vid, vlan_dev);
 		}
 	}
 
@@ -550,9 +550,9 @@ static void bond_del_vlans_from_slave(st
 		/* Save and then restore vlan_dev in the grp array,
 		 * since the slave's driver might clear it.
 		 */
-		vlan_dev = bond->vlgrp->vlan_devices[vlan->vlan_id];
+		vlan_dev = vlan_group_get_device(bond->vlgrp, vlan->vlan_id);
 		slave_dev->vlan_rx_kill_vid(slave_dev, vlan->vlan_id);
-		bond->vlgrp->vlan_devices[vlan->vlan_id] = vlan_dev;
+		vlan_group_set_device(bond->vlgrp, vlan->vlan_id, vlan_dev);
 	}
 
 unreg:
@@ -2397,7 +2397,7 @@ static void bond_arp_send_all(struct bon
 		vlan_id = 0;
 		list_for_each_entry_safe(vlan, vlan_next, &bond->vlan_list,
 					 vlan_list) {
-			vlan_dev = bond->vlgrp->vlan_devices[vlan->vlan_id];
+			vlan_dev = vlan_group_get_device(bond->vlgrp, vlan->vlan_id);
 			if (vlan_dev == rt->u.dst.dev) {
 				vlan_id = vlan->vlan_id;
 				dprintk("basa: vlan match on %s %d\n",
@@ -2444,7 +2444,7 @@ static void bond_send_gratuitous_arp(str
 	}
 
 	list_for_each_entry(vlan, &bond->vlan_list, vlan_list) {
-		vlan_dev = bond->vlgrp->vlan_devices[vlan->vlan_id];
+		vlan_dev = vlan_group_get_device(bond->vlgrp, vlan->vlan_id);
 		if (vlan->vlan_ip) {
 			bond_arp_send(slave->dev, ARPOP_REPLY, vlan->vlan_ip,
 				      vlan->vlan_ip, vlan->vlan_id);
@@ -3371,7 +3371,7 @@ static int bond_inetaddr_event(struct no
 
 		list_for_each_entry_safe(vlan, vlan_next, &bond->vlan_list,
 					 vlan_list) {
-			vlan_dev = bond->vlgrp->vlan_devices[vlan->vlan_id];
+			vlan_dev = vlan_group_get_device(bond->vlgrp, vlan->vlan_id);
 			if (vlan_dev == event_dev) {
 				switch (event) {
 				case NETDEV_UP:
diff -puN drivers/net/chelsio/cxgb2.c~vlan-net-drivers-avoid-a-4-order-allocation drivers/net/chelsio/cxgb2.c
--- a/drivers/net/chelsio/cxgb2.c~vlan-net-drivers-avoid-a-4-order-allocation
+++ a/drivers/net/chelsio/cxgb2.c
@@ -889,8 +889,7 @@ static void vlan_rx_kill_vid(struct net_
 	struct adapter *adapter = dev->priv;
 
 	spin_lock_irq(&adapter->async_lock);
-	if (adapter->vlan_grp)
-		adapter->vlan_grp->vlan_devices[vid] = NULL;
+	vlan_group_set_device(adapter->vlan_grp, vid, NULL);
 	spin_unlock_irq(&adapter->async_lock);
 }
 #endif
diff -puN drivers/net/e1000/e1000_main.c~vlan-net-drivers-avoid-a-4-order-allocation drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~vlan-net-drivers-avoid-a-4-order-allocation
+++ a/drivers/net/e1000/e1000_main.c
@@ -376,7 +376,7 @@ e1000_update_mng_vlan(struct e1000_adapt
 	uint16_t vid = adapter->hw.mng_cookie.vlan_id;
 	uint16_t old_vid = adapter->mng_vlan_id;
 	if (adapter->vlgrp) {
-		if (!adapter->vlgrp->vlan_devices[vid]) {
+		if (!vlan_group_get_device(adapter->vlgrp, vid)) {
 			if (adapter->hw.mng_cookie.status &
 				E1000_MNG_DHCP_COOKIE_STATUS_VLAN_SUPPORT) {
 				e1000_vlan_rx_add_vid(netdev, vid);
@@ -386,7 +386,7 @@ e1000_update_mng_vlan(struct e1000_adapt
 
 			if ((old_vid != (uint16_t)E1000_MNG_VLAN_NONE) &&
 					(vid != old_vid) &&
-					!adapter->vlgrp->vlan_devices[old_vid])
+			    !vlan_group_get_device(adapter->vlgrp, old_vid))
 				e1000_vlan_rx_kill_vid(netdev, old_vid);
 		} else
 			adapter->mng_vlan_id = vid;
@@ -1482,7 +1482,7 @@ e1000_close(struct net_device *netdev)
 	if ((adapter->hw.mng_cookie.status &
 			  E1000_MNG_DHCP_COOKIE_STATUS_VLAN_SUPPORT) &&
 	     !(adapter->vlgrp &&
-			  adapter->vlgrp->vlan_devices[adapter->mng_vlan_id])) {
+	       vlan_group_get_device(adapter->vlgrp, adapter->mng_vlan_id))) {
 		e1000_vlan_rx_kill_vid(netdev, adapter->mng_vlan_id);
 	}
 
@@ -4998,10 +4998,7 @@ e1000_vlan_rx_kill_vid(struct net_device
 	uint32_t vfta, index;
 
 	e1000_irq_disable(adapter);
-
-	if (adapter->vlgrp)
-		adapter->vlgrp->vlan_devices[vid] = NULL;
-
+	vlan_group_set_device(adapter->vlgrp, vid, NULL);
 	e1000_irq_enable(adapter);
 
 	if ((adapter->hw.mng_cookie.status &
@@ -5027,7 +5024,7 @@ e1000_restore_vlan(struct e1000_adapter 
 	if (adapter->vlgrp) {
 		uint16_t vid;
 		for (vid = 0; vid < VLAN_GROUP_ARRAY_LEN; vid++) {
-			if (!adapter->vlgrp->vlan_devices[vid])
+			if (!vlan_group_get_device(adapter->vlgrp, vid))
 				continue;
 			e1000_vlan_rx_add_vid(adapter->netdev, vid);
 		}
diff -puN drivers/net/ehea/ehea_main.c~vlan-net-drivers-avoid-a-4-order-allocation drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~vlan-net-drivers-avoid-a-4-order-allocation
+++ a/drivers/net/ehea/ehea_main.c
@@ -1939,8 +1939,7 @@ static void ehea_vlan_rx_kill_vid(struct
 	int index;
 	u64 hret;
 
-	if (port->vgrp)
-		port->vgrp->vlan_devices[vid] = NULL;
+	vlan_group_set_device(port->vgrp, vid, NULL);
 
 	cb1 = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!cb1) {
diff -puN drivers/net/gianfar.c~vlan-net-drivers-avoid-a-4-order-allocation drivers/net/gianfar.c
--- a/drivers/net/gianfar.c~vlan-net-drivers-avoid-a-4-order-allocation
+++ a/drivers/net/gianfar.c
@@ -1132,8 +1132,7 @@ static void gfar_vlan_rx_kill_vid(struct
 
 	spin_lock_irqsave(&priv->rxlock, flags);
 
-	if (priv->vlgrp)
-		priv->vlgrp->vlan_devices[vid] = NULL;
+	vlan_group_set_device(priv->vgrp, vid, NULL);
 
 	spin_unlock_irqrestore(&priv->rxlock, flags);
 }
diff -puN drivers/net/ixgb/ixgb_main.c~vlan-net-drivers-avoid-a-4-order-allocation drivers/net/ixgb/ixgb_main.c
--- a/drivers/net/ixgb/ixgb_main.c~vlan-net-drivers-avoid-a-4-order-allocation
+++ a/drivers/net/ixgb/ixgb_main.c
@@ -2213,8 +2213,7 @@ ixgb_vlan_rx_kill_vid(struct net_device 
 
 	ixgb_irq_disable(adapter);
 
-	if(adapter->vlgrp)
-		adapter->vlgrp->vlan_devices[vid] = NULL;
+	vlan_group_set_device(adapter->vlgrp, vid, NULL);
 
 	ixgb_irq_enable(adapter);
 
@@ -2234,7 +2233,7 @@ ixgb_restore_vlan(struct ixgb_adapter *a
 	if(adapter->vlgrp) {
 		uint16_t vid;
 		for(vid = 0; vid < VLAN_GROUP_ARRAY_LEN; vid++) {
-			if(!adapter->vlgrp->vlan_devices[vid])
+			if(!vlan_group_get_device(adapter->vlgrp, vid))
 				continue;
 			ixgb_vlan_rx_add_vid(adapter->netdev, vid);
 		}
diff -puN drivers/net/ns83820.c~vlan-net-drivers-avoid-a-4-order-allocation drivers/net/ns83820.c
--- a/drivers/net/ns83820.c~vlan-net-drivers-avoid-a-4-order-allocation
+++ a/drivers/net/ns83820.c
@@ -518,8 +518,7 @@ static void ns83820_vlan_rx_kill_vid(str
 
 	spin_lock_irq(&dev->misc_lock);
 	spin_lock(&dev->tx_lock);
-	if (dev->vlgrp)
-		dev->vlgrp->vlan_devices[vid] = NULL;
+	vlan_group_set_device(dev->vlgrp, vid, NULL);
 	spin_unlock(&dev->tx_lock);
 	spin_unlock_irq(&dev->misc_lock);
 }
diff -puN drivers/net/r8169.c~vlan-net-drivers-avoid-a-4-order-allocation drivers/net/r8169.c
--- a/drivers/net/r8169.c~vlan-net-drivers-avoid-a-4-order-allocation
+++ a/drivers/net/r8169.c
@@ -890,8 +890,7 @@ static void rtl8169_vlan_rx_kill_vid(str
 	unsigned long flags;
 
 	spin_lock_irqsave(&tp->lock, flags);
-	if (tp->vlgrp)
-		tp->vlgrp->vlan_devices[vid] = NULL;
+	vlan_group_set_device(tp->vlgrp, vid, NULL);
 	spin_unlock_irqrestore(&tp->lock, flags);
 }
 
diff -puN drivers/net/s2io.c~vlan-net-drivers-avoid-a-4-order-allocation drivers/net/s2io.c
--- a/drivers/net/s2io.c~vlan-net-drivers-avoid-a-4-order-allocation
+++ a/drivers/net/s2io.c
@@ -325,8 +325,7 @@ static void s2io_vlan_rx_kill_vid(struct
 	unsigned long flags;
 
 	spin_lock_irqsave(&nic->tx_lock, flags);
-	if (nic->vlgrp)
-		nic->vlgrp->vlan_devices[vid] = NULL;
+	vlan_group_set_device(nic->vlgrp, vid, NULL);
 	spin_unlock_irqrestore(&nic->tx_lock, flags);
 }
 
diff -puN drivers/net/sky2.c~vlan-net-drivers-avoid-a-4-order-allocation drivers/net/sky2.c
--- a/drivers/net/sky2.c~vlan-net-drivers-avoid-a-4-order-allocation
+++ a/drivers/net/sky2.c
@@ -1053,8 +1053,7 @@ static void sky2_vlan_rx_kill_vid(struct
 
 	sky2_write32(hw, SK_REG(port, RX_GMF_CTRL_T), RX_VLAN_STRIP_OFF);
 	sky2_write32(hw, SK_REG(port, TX_GMF_CTRL_T), TX_VLAN_TAG_OFF);
-	if (sky2->vlgrp)
-		sky2->vlgrp->vlan_devices[vid] = NULL;
+	vlan_group_set_device(sky2->vlgrp, vid, NULL);
 
 	netif_tx_unlock_bh(dev);
 }
diff -puN drivers/net/starfire.c~vlan-net-drivers-avoid-a-4-order-allocation drivers/net/starfire.c
--- a/drivers/net/starfire.c~vlan-net-drivers-avoid-a-4-order-allocation
+++ a/drivers/net/starfire.c
@@ -677,8 +677,7 @@ static void netdev_vlan_rx_kill_vid(stru
 	spin_lock(&np->lock);
 	if (debug > 1)
 		printk("%s: removing vlanid %d from vlan filter\n", dev->name, vid);
-	if (np->vlgrp)
-		np->vlgrp->vlan_devices[vid] = NULL;
+	vlan_group_set_device(np->vlgrp, vid, NULL);
 	set_rx_mode(dev);
 	spin_unlock(&np->lock);
 }
@@ -1738,7 +1737,7 @@ static void set_rx_mode(struct net_devic
 		int vlan_count = 0;
 		void __iomem *filter_addr = ioaddr + HashTable + 8;
 		for (i = 0; i < VLAN_VID_MASK; i++) {
-			if (np->vlgrp->vlan_devices[i]) {
+			if (vlan_group_get_device(np->vlgrp, i)) {
 				if (vlan_count >= 32)
 					break;
 				writew(cpu_to_be16(i), filter_addr);
diff -puN drivers/net/tg3.c~vlan-net-drivers-avoid-a-4-order-allocation drivers/net/tg3.c
--- a/drivers/net/tg3.c~vlan-net-drivers-avoid-a-4-order-allocation
+++ a/drivers/net/tg3.c
@@ -9114,8 +9114,7 @@ static void tg3_vlan_rx_kill_vid(struct 
 		tg3_netif_stop(tp);
 
 	tg3_full_lock(tp, 0);
-	if (tp->vlgrp)
-		tp->vlgrp->vlan_devices[vid] = NULL;
+	vlan_group_set_device(tp->vlgrp, vid, NULL);
 	tg3_full_unlock(tp);
 
 	if (netif_running(dev))
diff -puN drivers/net/typhoon.c~vlan-net-drivers-avoid-a-4-order-allocation drivers/net/typhoon.c
--- a/drivers/net/typhoon.c~vlan-net-drivers-avoid-a-4-order-allocation
+++ a/drivers/net/typhoon.c
@@ -746,8 +746,7 @@ typhoon_vlan_rx_kill_vid(struct net_devi
 {
 	struct typhoon *tp = netdev_priv(dev);
 	spin_lock_bh(&tp->state_lock);
-	if(tp->vlgrp)
-		tp->vlgrp->vlan_devices[vid] = NULL;
+	vlan_group_set_device(tp->vlgrp, vid, NULL);
 	spin_unlock_bh(&tp->state_lock);
 }
 
diff -puN drivers/s390/net/qeth_main.c~vlan-net-drivers-avoid-a-4-order-allocation drivers/s390/net/qeth_main.c
--- a/drivers/s390/net/qeth_main.c~vlan-net-drivers-avoid-a-4-order-allocation
+++ a/drivers/s390/net/qeth_main.c
@@ -3654,7 +3654,7 @@ qeth_verify_vlan_dev(struct net_device *
 		return rc;
 
 	for (i = 0; i < VLAN_GROUP_ARRAY_LEN; i++){
-		if (vg->vlan_devices[i] == dev){
+		if (vlan_group_get_device(vg, i) == dev){
 			rc = QETH_VLAN_CARD;
 			break;
 		}
@@ -5261,7 +5261,7 @@ qeth_free_vlan_addresses4(struct qeth_ca
 	QETH_DBF_TEXT(trace, 4, "frvaddr4");
 
 	rcu_read_lock();
-	in_dev = __in_dev_get_rcu(card->vlangrp->vlan_devices[vid]);
+	in_dev = __in_dev_get_rcu(vlan_group_get_device(card->vlangrp, vid));
 	if (!in_dev)
 		goto out;
 	for (ifa = in_dev->ifa_list; ifa; ifa = ifa->ifa_next) {
@@ -5288,7 +5288,7 @@ qeth_free_vlan_addresses6(struct qeth_ca
 
 	QETH_DBF_TEXT(trace, 4, "frvaddr6");
 
-	in6_dev = in6_dev_get(card->vlangrp->vlan_devices[vid]);
+	in6_dev = in6_dev_get(vlan_group_get_device(card->vlangrp, vid));
 	if (!in6_dev)
 		return;
 	for (ifa = in6_dev->addr_list; ifa; ifa = ifa->lst_next){
@@ -5360,7 +5360,7 @@ qeth_layer2_process_vlans(struct qeth_ca
 	if (!card->vlangrp)
 		return;
 	for (i = 0; i < VLAN_GROUP_ARRAY_LEN; i++) {
-		if (card->vlangrp->vlan_devices[i] == NULL)
+		if (vlan_group_get_device(card->vlangrp, i) == NULL)
 			continue;
 		if (clear)
 			qeth_layer2_send_setdelvlan(card, i, IPA_CMD_DELVLAN);
@@ -5398,8 +5398,7 @@ qeth_vlan_rx_kill_vid(struct net_device 
 	spin_lock_irqsave(&card->vlanlock, flags);
 	/* unregister IP addresses of vlan device */
 	qeth_free_vlan_addresses(card, vid);
-	if (card->vlangrp)
-		card->vlangrp->vlan_devices[vid] = NULL;
+	vlan_group_set_device(card->vlangrp, vid, NULL);
 	spin_unlock_irqrestore(&card->vlanlock, flags);
 	if (card->options.layer2)
 		qeth_layer2_send_setdelvlan(card, vid, IPA_CMD_DELVLAN);
@@ -5662,10 +5661,11 @@ qeth_add_vlan_mc(struct qeth_card *card)
 
 	vg = card->vlangrp;
 	for (i = 0; i < VLAN_GROUP_ARRAY_LEN; i++) {
-		if (vg->vlan_devices[i] == NULL ||
-		    !(vg->vlan_devices[i]->flags & IFF_UP))
+		struct net_device *netdev = vlan_group_get_device(vg, i);
+		if (netdev == NULL ||
+		    !(netdev->flags & IFF_UP))
 			continue;
-		in_dev = in_dev_get(vg->vlan_devices[i]);
+		in_dev = in_dev_get(netdev);
 		if (!in_dev)
 			continue;
 		read_lock(&in_dev->mc_list_lock);
@@ -5749,10 +5749,11 @@ qeth_add_vlan_mc6(struct qeth_card *card
 
 	vg = card->vlangrp;
 	for (i = 0; i < VLAN_GROUP_ARRAY_LEN; i++) {
-		if (vg->vlan_devices[i] == NULL ||
-		    !(vg->vlan_devices[i]->flags & IFF_UP))
+		struct net_device *netdev = vlan_group_get_device(vg, i);
+		if (netdev == NULL ||
+		    !(netdev->flags & IFF_UP))
 			continue;
-		in_dev = in6_dev_get(vg->vlan_devices[i]);
+		in_dev = in6_dev_get(netdev);
 		if (!in_dev)
 			continue;
 		read_lock(&in_dev->lock);
diff -puN include/linux/if_vlan.h~vlan-net-drivers-avoid-a-4-order-allocation include/linux/if_vlan.h
--- a/include/linux/if_vlan.h~vlan-net-drivers-avoid-a-4-order-allocation
+++ a/include/linux/if_vlan.h
@@ -70,15 +70,34 @@ extern void vlan_ioctl_set(int (*hook)(v
  * depends on completely exhausting the VLAN identifier space.  Thus
  * it gives constant time look-up, but in many cases it wastes memory.
  */
-#define VLAN_GROUP_ARRAY_LEN 4096
+#define VLAN_GROUP_ARRAY_LEN          4096
+#define VLAN_GROUP_ARRAY_SPLIT_PARTS  8
+#define VLAN_GROUP_ARRAY_PART_LEN     (VLAN_GROUP_ARRAY_LEN/VLAN_GROUP_ARRAY_SPLIT_PARTS)
 
 struct vlan_group {
 	int real_dev_ifindex; /* The ifindex of the ethernet(like) device the vlan is attached to. */
 	struct hlist_node	hlist;	/* linked list */
-	struct net_device *vlan_devices[VLAN_GROUP_ARRAY_LEN];
+	struct net_device **vlan_devices_arrays[VLAN_GROUP_ARRAY_SPLIT_PARTS];
 	struct rcu_head		rcu;
 };
 
+static inline struct net_device *vlan_group_get_device(struct vlan_group *vg, int vlan_id)
+{
+	struct net_device **array;
+	array = vg->vlan_devices_arrays[vlan_id / VLAN_GROUP_ARRAY_PART_LEN];
+	return array[vlan_id % VLAN_GROUP_ARRAY_PART_LEN];
+}
+
+static inline void vlan_group_set_device(struct vlan_group *vg, int vlan_id,
+					 struct net_device *dev)
+{
+	struct net_device **array;
+	if (!vg)
+		return;
+	array = vg->vlan_devices_arrays[vlan_id / VLAN_GROUP_ARRAY_PART_LEN];
+	array[vlan_id % VLAN_GROUP_ARRAY_PART_LEN] = dev;
+}
+
 struct vlan_priority_tci_mapping {
 	unsigned long priority;
 	unsigned short vlan_qos; /* This should be shifted when first set, so we only do it
@@ -160,7 +179,7 @@ static inline int __vlan_hwaccel_rx(stru
 		return NET_RX_DROP;
 	}
 
-	skb->dev = grp->vlan_devices[vlan_tag & VLAN_VID_MASK];
+	skb->dev = vlan_group_get_device(grp, vlan_tag & VLAN_VID_MASK);
 	if (skb->dev == NULL) {
 		dev_kfree_skb_any(skb);
 
diff -puN net/8021q/vlan.c~vlan-net-drivers-avoid-a-4-order-allocation net/8021q/vlan.c
--- a/net/8021q/vlan.c~vlan-net-drivers-avoid-a-4-order-allocation
+++ a/net/8021q/vlan.c
@@ -184,14 +184,23 @@ struct net_device *__find_vlan_dev(struc
 	struct vlan_group *grp = __vlan_find_group(real_dev->ifindex);
 
 	if (grp)
-		return grp->vlan_devices[VID];
+                return vlan_group_get_device(grp, VID);
 
 	return NULL;
 }
 
+static void vlan_group_free(struct vlan_group *grp)
+{
+	int i;
+
+	for (i=0; i < VLAN_GROUP_ARRAY_SPLIT_PARTS; i++)
+		kfree(grp->vlan_devices_arrays[i]);
+	kfree(grp);
+}
+
 static void vlan_rcu_free(struct rcu_head *rcu)
 {
-	kfree(container_of(rcu, struct vlan_group, rcu));
+	vlan_group_free(container_of(rcu, struct vlan_group, rcu));
 }
 
 
@@ -223,7 +232,7 @@ static int unregister_vlan_dev(struct ne
 	ret = 0;
 
 	if (grp) {
-		dev = grp->vlan_devices[vlan_id];
+		dev = vlan_group_get_device(grp, vlan_id);
 		if (dev) {
 			/* Remove proc entry */
 			vlan_proc_rem_dev(dev);
@@ -237,7 +246,7 @@ static int unregister_vlan_dev(struct ne
 				real_dev->vlan_rx_kill_vid(real_dev, vlan_id);
 			}
 
-			grp->vlan_devices[vlan_id] = NULL;
+			vlan_group_set_device(grp, vlan_id, NULL);
 			synchronize_net();
 
 
@@ -251,7 +260,7 @@ static int unregister_vlan_dev(struct ne
 			 * group.
 			 */
 			for (i = 0; i < VLAN_VID_MASK; i++)
-				if (grp->vlan_devices[i])
+				if (vlan_group_get_device(grp, i))
 					break;
 
 			if (i == VLAN_VID_MASK) {
@@ -379,6 +388,7 @@ static struct net_device *register_vlan_
 	struct net_device *new_dev;
 	struct net_device *real_dev; /* the ethernet device */
 	char name[IFNAMSIZ];
+	int i;
 
 #ifdef VLAN_DEBUG
 	printk(VLAN_DBG "%s: if_name -:%s:-	vid: %i\n",
@@ -544,6 +554,15 @@ static struct net_device *register_vlan_
 		if (!grp)
 			goto out_free_unregister;
 
+		for (i=0; i < VLAN_GROUP_ARRAY_SPLIT_PARTS; i++) {
+			grp->vlan_devices_arrays[i] = kzalloc(
+				sizeof(struct net_device *)*VLAN_GROUP_ARRAY_PART_LEN,
+				GFP_KERNEL);
+
+			if (!grp->vlan_devices_arrays[i])
+				goto out_free_arrays;
+		}
+
 		/* printk(KERN_ALERT "VLAN REGISTER:  Allocated new group.\n"); */
 		grp->real_dev_ifindex = real_dev->ifindex;
 
@@ -554,7 +573,7 @@ static struct net_device *register_vlan_
 			real_dev->vlan_rx_register(real_dev, grp);
 	}
 
-	grp->vlan_devices[VLAN_ID] = new_dev;
+	vlan_group_set_device(grp, VLAN_ID, new_dev);
 
 	if (vlan_proc_add_dev(new_dev)<0)/* create it's proc entry */
 		printk(KERN_WARNING "VLAN: failed to add proc entry for %s\n",
@@ -571,6 +590,9 @@ static struct net_device *register_vlan_
 #endif
 	return new_dev;
 
+out_free_arrays:
+	vlan_group_free(grp);
+
 out_free_unregister:
 	unregister_netdev(new_dev);
 	goto out_unlock;
@@ -606,7 +628,7 @@ static int vlan_device_event(struct noti
 	case NETDEV_CHANGE:
 		/* Propagate real device state to vlan devices */
 		for (i = 0; i < VLAN_GROUP_ARRAY_LEN; i++) {
-			vlandev = grp->vlan_devices[i];
+			vlandev = vlan_group_get_device(grp, i);
 			if (!vlandev)
 				continue;
 
@@ -617,7 +639,7 @@ static int vlan_device_event(struct noti
 	case NETDEV_DOWN:
 		/* Put all VLANs for this dev in the down state too.  */
 		for (i = 0; i < VLAN_GROUP_ARRAY_LEN; i++) {
-			vlandev = grp->vlan_devices[i];
+			vlandev = vlan_group_get_device(grp, i);
 			if (!vlandev)
 				continue;
 
@@ -632,7 +654,7 @@ static int vlan_device_event(struct noti
 	case NETDEV_UP:
 		/* Put all VLANs for this dev in the up state too.  */
 		for (i = 0; i < VLAN_GROUP_ARRAY_LEN; i++) {
-			vlandev = grp->vlan_devices[i];
+			vlandev = vlan_group_get_device(grp, i);
 			if (!vlandev)
 				continue;
 
@@ -649,7 +671,7 @@ static int vlan_device_event(struct noti
 		for (i = 0; i < VLAN_GROUP_ARRAY_LEN; i++) {
 			int ret;
 
-			vlandev = grp->vlan_devices[i];
+			vlandev = vlan_group_get_device(grp, i);
 			if (!vlandev)
 				continue;
 
_

Patches currently in -mm which might be from da-x@monatomic.org are

vlan-net-drivers-avoid-a-4-order-allocation.patch
fix-i-oat-for-kexec.patch
