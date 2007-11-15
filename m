From: akpm@linux-foundation.org
Subject: - cris-build-fixes-update-eth_v10c-ethernet-driver.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:11:43 -0800
Message-ID: <200711152111.lAFLBhq5015790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39758 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932321AbXKOVRy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, jeff@garzik.org, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris build fixes: update eth_v10.c ethernet driver
has been removed from the -mm tree.  Its filename was
     cris-build-fixes-update-eth_v10c-ethernet-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cris build fixes: update eth_v10.c ethernet driver
From: Jesper Nilsson <jesper.nilsson@axis.com>

New (updated) version of ethernet driver for cris v10.

- First steps to simplify and make the MII code more similar
  between the etrax100 and etraxfs ports.

- Start the transmit queue before enabling tx interrupts
  to avoid race with the first frame.

- Flip the comparition statement to stick to physical addresses
  to avoid phys_to_virt mapping a potential null pointer.
  This was not an error but the change simplifies debugging
  of address-space mappings.

- Made myPrevRxDesc local to e100_rx since it was only used there.
  Fixed out of memory handling in e100_rx.  If dev_alloc_skb() fails
  persistently the system is hosed anyway but at least it won't
  loop in an interrupt handler.

- Correct some code formatting issues.

- Add defines SET_ETH_ENABLE_LEDS, SET_ETH_DISABLE_LEDS
  and SET_ETH_AUTONEG used in new cris v10 ethernet driver.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Mikael Starvik <starvik@axis.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cris/eth_v10.c  |  430 +++++++++++++++++++++-------------
 include/asm-cris/ethernet.h |    3 
 2 files changed, 280 insertions(+), 153 deletions(-)

diff -puN drivers/net/cris/eth_v10.c~cris-build-fixes-update-eth_v10c-ethernet-driver drivers/net/cris/eth_v10.c
--- a/drivers/net/cris/eth_v10.c~cris-build-fixes-update-eth_v10c-ethernet-driver
+++ a/drivers/net/cris/eth_v10.c
@@ -250,6 +250,7 @@
 #include <asm/system.h>
 #include <asm/ethernet.h>
 #include <asm/cache.h>
+#include <asm/arch/io_interface_mux.h>
 
 //#define ETHDEBUG
 #define D(x)
@@ -279,6 +280,9 @@ struct net_local {
 	 * by this lock as well.
 	 */
 	spinlock_t lock;
+
+	spinlock_t led_lock; /* Protect LED state */
+	spinlock_t transceiver_lock; /* Protect transceiver state. */
 };
 
 typedef struct etrax_eth_descr
@@ -295,8 +299,6 @@ struct transceiver_ops
 	void (*check_duplex)(struct net_device* dev);
 };
 
-struct transceiver_ops* transceiver;
-
 /* Duplex settings */
 enum duplex
 {
@@ -307,7 +309,7 @@ enum duplex
 
 /* Dma descriptors etc. */
 
-#define MAX_MEDIA_DATA_SIZE 1518
+#define MAX_MEDIA_DATA_SIZE 1522
 
 #define MIN_PACKET_LEN      46
 #define ETHER_HEAD_LEN      14
@@ -332,8 +334,8 @@ enum duplex
 
 /*Intel LXT972A specific*/
 #define MDIO_INT_STATUS_REG_2			0x0011
-#define MDIO_INT_FULL_DUPLEX_IND		( 1 << 9 )
-#define MDIO_INT_SPEED				( 1 << 14 )
+#define MDIO_INT_FULL_DUPLEX_IND       (1 << 9)
+#define MDIO_INT_SPEED                (1 << 14)
 
 /* Network flash constants */
 #define NET_FLASH_TIME                  (HZ/50) /* 20 ms */
@@ -344,8 +346,8 @@ enum duplex
 #define NO_NETWORK_ACTIVITY 0
 #define NETWORK_ACTIVITY    1
 
-#define NBR_OF_RX_DESC     64
-#define NBR_OF_TX_DESC     256
+#define NBR_OF_RX_DESC     32
+#define NBR_OF_TX_DESC     16
 
 /* Large packets are sent directly to upper layers while small packets are */
 /* copied (to reduce memory waste). The following constant decides the breakpoint */
@@ -367,7 +369,6 @@ enum duplex
 static etrax_eth_descr *myNextRxDesc;  /* Points to the next descriptor to
                                           to be processed */
 static etrax_eth_descr *myLastRxDesc;  /* The last processed descriptor */
-static etrax_eth_descr *myPrevRxDesc;  /* The descriptor right before myNextRxDesc */
 
 static etrax_eth_descr RxDescList[NBR_OF_RX_DESC] __attribute__ ((aligned(32)));
 
@@ -377,7 +378,6 @@ static etrax_eth_descr* myNextTxDesc;  /
 static etrax_eth_descr TxDescList[NBR_OF_TX_DESC] __attribute__ ((aligned(32)));
 
 static unsigned int network_rec_config_shadow = 0;
-static unsigned int mdio_phy_addr; /* Transciever address */
 
 static unsigned int network_tr_ctrl_shadow = 0;
 
@@ -411,7 +411,7 @@ static int e100_set_config(struct net_de
 static void e100_tx_timeout(struct net_device *dev);
 static struct net_device_stats *e100_get_stats(struct net_device *dev);
 static void set_multicast_list(struct net_device *dev);
-static void e100_hardware_send_packet(char *buf, int length);
+static void e100_hardware_send_packet(struct net_local* np, char *buf, int length);
 static void update_rx_stats(struct net_device_stats *);
 static void update_tx_stats(struct net_device_stats *);
 static int e100_probe_transceiver(struct net_device* dev);
@@ -434,7 +434,10 @@ static void e100_clear_network_leds(unsi
 static void e100_set_network_leds(int active);
 
 static const struct ethtool_ops e100_ethtool_ops;
-
+#if defined(CONFIG_ETRAX_NO_PHY)
+static void dummy_check_speed(struct net_device* dev);
+static void dummy_check_duplex(struct net_device* dev);
+#else
 static void broadcom_check_speed(struct net_device* dev);
 static void broadcom_check_duplex(struct net_device* dev);
 static void tdk_check_speed(struct net_device* dev);
@@ -443,16 +446,28 @@ static void intel_check_speed(struct net
 static void intel_check_duplex(struct net_device* dev);
 static void generic_check_speed(struct net_device* dev);
 static void generic_check_duplex(struct net_device* dev);
+#endif
+#ifdef CONFIG_NET_POLL_CONTROLLER
+static void e100_netpoll(struct net_device* dev);
+#endif
+
+static int autoneg_normal = 1;
 
 struct transceiver_ops transceivers[] =
 {
+#if defined(CONFIG_ETRAX_NO_PHY)
+	{0x0000, dummy_check_speed, dummy_check_duplex}        /* Dummy */
+#else
 	{0x1018, broadcom_check_speed, broadcom_check_duplex},  /* Broadcom */
 	{0xC039, tdk_check_speed, tdk_check_duplex},            /* TDK 2120 */
 	{0x039C, tdk_check_speed, tdk_check_duplex},            /* TDK 2120C */
         {0x04de, intel_check_speed, intel_check_duplex},     	/* Intel LXT972A*/
 	{0x0000, generic_check_speed, generic_check_duplex}     /* Generic, must be last */
+#endif
 };
 
+struct transceiver_ops* transceiver = &transceivers[0];
+
 #define tx_done(dev) (*R_DMA_CH0_CMD == 0)
 
 /*
@@ -471,14 +486,22 @@ etrax_ethernet_init(void)
 	int i, err;
 
 	printk(KERN_INFO
-	       "ETRAX 100LX 10/100MBit ethernet v2.0 (c) 2000-2003 Axis Communications AB\n");
+	       "ETRAX 100LX 10/100MBit ethernet v2.0 (c) 1998-2007 Axis Communications AB\n");
 
-	dev = alloc_etherdev(sizeof(struct net_local));
-	np = dev->priv;
+	if (cris_request_io_interface(if_eth, cardname)) {
+		printk(KERN_CRIT "etrax_ethernet_init failed to get IO interface\n");
+		return -EBUSY;
+	}
 
+	dev = alloc_etherdev(sizeof(struct net_local));
 	if (!dev)
 		return -ENOMEM;
 
+	np = netdev_priv(dev);
+
+	/* we do our own locking */
+	dev->features |= NETIF_F_LLTX;
+
 	dev->base_addr = (unsigned int)R_NETWORK_SA_0; /* just to have something to show */
 
 	/* now setup our etrax specific stuff */
@@ -498,14 +521,22 @@ etrax_ethernet_init(void)
 	dev->do_ioctl           = e100_ioctl;
 	dev->set_config		= e100_set_config;
 	dev->tx_timeout         = e100_tx_timeout;
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	dev->poll_controller = e100_netpoll;
+#endif
+
+	spin_lock_init(&np->lock);
+	spin_lock_init(&np->led_lock);
+	spin_lock_init(&np->transceiver_lock);
 
 	/* Initialise the list of Etrax DMA-descriptors */
 
 	/* Initialise receive descriptors */
 
 	for (i = 0; i < NBR_OF_RX_DESC; i++) {
-		/* Allocate two extra cachelines to make sure that buffer used by DMA
-		 * does not share cacheline with any other data (to avoid cache bug)
+		/* Allocate two extra cachelines to make sure that buffer used
+		 * by DMA does not share cacheline with any other data (to
+		 * avoid cache bug)
 		 */
 		RxDescList[i].skb = dev_alloc_skb(MAX_MEDIA_DATA_SIZE + 2 * L1_CACHE_BYTES);
 		if (!RxDescList[i].skb)
@@ -541,7 +572,6 @@ etrax_ethernet_init(void)
 
 	myNextRxDesc  = &RxDescList[0];
 	myLastRxDesc  = &RxDescList[NBR_OF_RX_DESC - 1];
-	myPrevRxDesc  = &RxDescList[NBR_OF_RX_DESC - 1];
 	myFirstTxDesc = &TxDescList[0];
 	myNextTxDesc  = &TxDescList[0];
 	myLastTxDesc  = &TxDescList[NBR_OF_TX_DESC - 1];
@@ -562,10 +592,11 @@ etrax_ethernet_init(void)
 	current_speed = 10;
 	current_speed_selection = 0; /* Auto */
 	speed_timer.expires = jiffies + NET_LINK_UP_CHECK_INTERVAL;
-        duplex_timer.data = (unsigned long)dev;
+	speed_timer.data = (unsigned long)dev;
 	speed_timer.function = e100_check_speed;
 
 	clear_led_timer.function = e100_clear_network_leds;
+	clear_led_timer.data = (unsigned long)dev;
 
 	full_duplex = 0;
 	current_duplex = autoneg;
@@ -574,7 +605,6 @@ etrax_ethernet_init(void)
 	duplex_timer.function = e100_check_duplex;
 
         /* Initialize mii interface */
-	np->mii_if.phy_id = mdio_phy_addr;
 	np->mii_if.phy_id_mask = 0x1f;
 	np->mii_if.reg_num_mask = 0x1f;
 	np->mii_if.dev = dev;
@@ -585,6 +615,9 @@ etrax_ethernet_init(void)
 	/* unwanted addresses are matched */
 	*R_NETWORK_GA_0 = 0x00000000;
 	*R_NETWORK_GA_1 = 0x00000000;
+
+	/* Initialize next time the led can flash */
+	led_next_time = jiffies;
 	return 0;
 }
 
@@ -595,7 +628,7 @@ etrax_ethernet_init(void)
 static int
 e100_set_mac_address(struct net_device *dev, void *p)
 {
-	struct net_local *np = (struct net_local *)dev->priv;
+	struct net_local *np = netdev_priv(dev);
 	struct sockaddr *addr = p;
 	int i;
 
@@ -686,6 +719,25 @@ e100_open(struct net_device *dev)
 		goto grace_exit2;
 	}
 
+	/*
+	 * Always allocate the DMA channels after the IRQ,
+	 * and clean up on failure.
+	 */
+
+	if (cris_request_dma(NETWORK_TX_DMA_NBR,
+	                     cardname,
+	                     DMA_VERBOSE_ON_ERROR,
+	                     dma_eth)) {
+		goto grace_exit3;
+        }
+
+	if (cris_request_dma(NETWORK_RX_DMA_NBR,
+	                     cardname,
+	                     DMA_VERBOSE_ON_ERROR,
+	                     dma_eth)) {
+		goto grace_exit4;
+        }
+
 	/* give the HW an idea of what MAC address we want */
 
 	*R_NETWORK_SA_0 = dev->dev_addr[0] | (dev->dev_addr[1] << 8) |
@@ -700,6 +752,7 @@ e100_open(struct net_device *dev)
 
 	*R_NETWORK_REC_CONFIG = 0xd; /* broadcast rec, individ. rec, ma0 enabled */
 #else
+	SETS(network_rec_config_shadow, R_NETWORK_REC_CONFIG, max_size, size1522);
 	SETS(network_rec_config_shadow, R_NETWORK_REC_CONFIG, broadcast, receive);
 	SETS(network_rec_config_shadow, R_NETWORK_REC_CONFIG, ma0, enable);
 	SETF(network_rec_config_shadow, R_NETWORK_REC_CONFIG, duplex, full_duplex);
@@ -719,8 +772,7 @@ e100_open(struct net_device *dev)
 	SETS(network_tr_ctrl_shadow, R_NETWORK_TR_CTRL, crc, enable);
 	*R_NETWORK_TR_CTRL = network_tr_ctrl_shadow;
 
-	save_flags(flags);
-	cli();
+	local_irq_save(flags);
 
 	/* enable the irq's for ethernet DMA */
 
@@ -752,12 +804,13 @@ e100_open(struct net_device *dev)
 
 	*R_DMA_CH0_FIRST = 0;
 	*R_DMA_CH0_DESCR = virt_to_phys(myLastTxDesc);
+	netif_start_queue(dev);
 
-	restore_flags(flags);
+	local_irq_restore(flags);
 
 	/* Probe for transceiver */
 	if (e100_probe_transceiver(dev))
-		goto grace_exit3;
+		goto grace_exit5;
 
 	/* Start duplex/speed timers */
 	add_timer(&speed_timer);
@@ -766,10 +819,14 @@ e100_open(struct net_device *dev)
 	/* We are now ready to accept transmit requeusts from
 	 * the queueing layer of the networking.
 	 */
-	netif_start_queue(dev);
+	netif_carrier_on(dev);
 
 	return 0;
 
+grace_exit5:
+	cris_free_dma(NETWORK_RX_DMA_NBR, cardname);
+grace_exit4:
+	cris_free_dma(NETWORK_TX_DMA_NBR, cardname);
 grace_exit3:
 	free_irq(NETWORK_STATUS_IRQ_NBR, (void *)dev);
 grace_exit2:
@@ -780,12 +837,20 @@ grace_exit0:
 	return -EAGAIN;
 }
 
-
+#if defined(CONFIG_ETRAX_NO_PHY)
+static void
+dummy_check_speed(struct net_device* dev)
+{
+	current_speed = 100;
+}
+#else
 static void
 generic_check_speed(struct net_device* dev)
 {
 	unsigned long data;
-	data = e100_get_mdio_reg(dev, mdio_phy_addr, MII_ADVERTISE);
+	struct net_local *np = netdev_priv(dev);
+
+	data = e100_get_mdio_reg(dev, np->mii_if.phy_id, MII_ADVERTISE);
 	if ((data & ADVERTISE_100FULL) ||
 	    (data & ADVERTISE_100HALF))
 		current_speed = 100;
@@ -797,7 +862,10 @@ static void
 tdk_check_speed(struct net_device* dev)
 {
 	unsigned long data;
-	data = e100_get_mdio_reg(dev, mdio_phy_addr, MDIO_TDK_DIAGNOSTIC_REG);
+	struct net_local *np = netdev_priv(dev);
+
+	data = e100_get_mdio_reg(dev, np->mii_if.phy_id,
+				 MDIO_TDK_DIAGNOSTIC_REG);
 	current_speed = (data & MDIO_TDK_DIAGNOSTIC_RATE ? 100 : 10);
 }
 
@@ -805,7 +873,10 @@ static void
 broadcom_check_speed(struct net_device* dev)
 {
 	unsigned long data;
-	data = e100_get_mdio_reg(dev, mdio_phy_addr, MDIO_AUX_CTRL_STATUS_REG);
+	struct net_local *np = netdev_priv(dev);
+
+	data = e100_get_mdio_reg(dev, np->mii_if.phy_id,
+				 MDIO_AUX_CTRL_STATUS_REG);
 	current_speed = (data & MDIO_BC_SPEED ? 100 : 10);
 }
 
@@ -813,46 +884,62 @@ static void
 intel_check_speed(struct net_device* dev)
 {
 	unsigned long data;
-	data = e100_get_mdio_reg(dev, mdio_phy_addr, MDIO_INT_STATUS_REG_2);
+	struct net_local *np = netdev_priv(dev);
+
+	data = e100_get_mdio_reg(dev, np->mii_if.phy_id,
+				 MDIO_INT_STATUS_REG_2);
 	current_speed = (data & MDIO_INT_SPEED ? 100 : 10);
 }
-
+#endif
 static void
 e100_check_speed(unsigned long priv)
 {
 	struct net_device* dev = (struct net_device*)priv;
+	struct net_local *np = netdev_priv(dev);
 	static int led_initiated = 0;
 	unsigned long data;
 	int old_speed = current_speed;
 
-	data = e100_get_mdio_reg(dev, mdio_phy_addr, MII_BMSR);
+	spin_lock(&np->transceiver_lock);
+
+	data = e100_get_mdio_reg(dev, np->mii_if.phy_id, MII_BMSR);
 	if (!(data & BMSR_LSTATUS)) {
 		current_speed = 0;
 	} else {
 		transceiver->check_speed(dev);
 	}
 
+	spin_lock(&np->led_lock);
 	if ((old_speed != current_speed) || !led_initiated) {
 		led_initiated = 1;
 		e100_set_network_leds(NO_NETWORK_ACTIVITY);
+		if (current_speed)
+			netif_carrier_on(dev);
+		else
+			netif_carrier_off(dev);
 	}
+	spin_unlock(&np->led_lock);
 
 	/* Reinitialize the timer. */
 	speed_timer.expires = jiffies + NET_LINK_UP_CHECK_INTERVAL;
 	add_timer(&speed_timer);
+
+	spin_unlock(&np->transceiver_lock);
 }
 
 static void
 e100_negotiate(struct net_device* dev)
 {
-	unsigned short data = e100_get_mdio_reg(dev, mdio_phy_addr, MII_ADVERTISE);
+	struct net_local *np = netdev_priv(dev);
+	unsigned short data = e100_get_mdio_reg(dev, np->mii_if.phy_id,
+						MII_ADVERTISE);
 
 	/* Discard old speed and duplex settings */
 	data &= ~(ADVERTISE_100HALF | ADVERTISE_100FULL |
 	          ADVERTISE_10HALF | ADVERTISE_10FULL);
 
 	switch (current_speed_selection) {
-		case 10 :
+		case 10:
 			if (current_duplex == full)
 				data |= ADVERTISE_10FULL;
 			else if (current_duplex == half)
@@ -861,7 +948,7 @@ e100_negotiate(struct net_device* dev)
 				data |= ADVERTISE_10HALF | ADVERTISE_10FULL;
 			break;
 
-		case 100 :
+		case 100:
 			 if (current_duplex == full)
 				data |= ADVERTISE_100FULL;
 			else if (current_duplex == half)
@@ -870,7 +957,7 @@ e100_negotiate(struct net_device* dev)
 				data |= ADVERTISE_100HALF | ADVERTISE_100FULL;
 			break;
 
-		case 0 : /* Auto */
+		case 0: /* Auto */
 			 if (current_duplex == full)
 				data |= ADVERTISE_100FULL | ADVERTISE_10FULL;
 			else if (current_duplex == half)
@@ -880,35 +967,44 @@ e100_negotiate(struct net_device* dev)
 				  ADVERTISE_100HALF | ADVERTISE_100FULL;
 			break;
 
-		default : /* assume autoneg speed and duplex */
+		default: /* assume autoneg speed and duplex */
 			data |= ADVERTISE_10HALF | ADVERTISE_10FULL |
 				  ADVERTISE_100HALF | ADVERTISE_100FULL;
+			break;
 	}
 
-	e100_set_mdio_reg(dev, mdio_phy_addr, MII_ADVERTISE, data);
+	e100_set_mdio_reg(dev, np->mii_if.phy_id, MII_ADVERTISE, data);
 
 	/* Renegotiate with link partner */
-	data = e100_get_mdio_reg(dev, mdio_phy_addr, MII_BMCR);
+	if (autoneg_normal) {
+	  data = e100_get_mdio_reg(dev, np->mii_if.phy_id, MII_BMCR);
 	data |= BMCR_ANENABLE | BMCR_ANRESTART;
-
-	e100_set_mdio_reg(dev, mdio_phy_addr, MII_BMCR, data);
+	}
+	e100_set_mdio_reg(dev, np->mii_if.phy_id, MII_BMCR, data);
 }
 
 static void
 e100_set_speed(struct net_device* dev, unsigned long speed)
 {
+	struct net_local *np = netdev_priv(dev);
+
+	spin_lock(&np->transceiver_lock);
 	if (speed != current_speed_selection) {
 		current_speed_selection = speed;
 		e100_negotiate(dev);
 	}
+	spin_unlock(&np->transceiver_lock);
 }
 
 static void
 e100_check_duplex(unsigned long priv)
 {
 	struct net_device *dev = (struct net_device *)priv;
-	struct net_local *np = (struct net_local *)dev->priv;
-	int old_duplex = full_duplex;
+	struct net_local *np = netdev_priv(dev);
+	int old_duplex;
+
+	spin_lock(&np->transceiver_lock);
+	old_duplex = full_duplex;
 	transceiver->check_duplex(dev);
 	if (old_duplex != full_duplex) {
 		/* Duplex changed */
@@ -920,13 +1016,22 @@ e100_check_duplex(unsigned long priv)
 	duplex_timer.expires = jiffies + NET_DUPLEX_CHECK_INTERVAL;
 	add_timer(&duplex_timer);
 	np->mii_if.full_duplex = full_duplex;
+	spin_unlock(&np->transceiver_lock);
 }
-
+#if defined(CONFIG_ETRAX_NO_PHY)
+static void
+dummy_check_duplex(struct net_device* dev)
+{
+	full_duplex = 1;
+}
+#else
 static void
 generic_check_duplex(struct net_device* dev)
 {
 	unsigned long data;
-	data = e100_get_mdio_reg(dev, mdio_phy_addr, MII_ADVERTISE);
+	struct net_local *np = netdev_priv(dev);
+
+	data = e100_get_mdio_reg(dev, np->mii_if.phy_id, MII_ADVERTISE);
 	if ((data & ADVERTISE_10FULL) ||
 	    (data & ADVERTISE_100FULL))
 		full_duplex = 1;
@@ -938,7 +1043,10 @@ static void
 tdk_check_duplex(struct net_device* dev)
 {
 	unsigned long data;
-	data = e100_get_mdio_reg(dev, mdio_phy_addr, MDIO_TDK_DIAGNOSTIC_REG);
+	struct net_local *np = netdev_priv(dev);
+
+	data = e100_get_mdio_reg(dev, np->mii_if.phy_id,
+				 MDIO_TDK_DIAGNOSTIC_REG);
 	full_duplex = (data & MDIO_TDK_DIAGNOSTIC_DPLX) ? 1 : 0;
 }
 
@@ -946,7 +1054,10 @@ static void
 broadcom_check_duplex(struct net_device* dev)
 {
 	unsigned long data;
-	data = e100_get_mdio_reg(dev, mdio_phy_addr, MDIO_AUX_CTRL_STATUS_REG);
+	struct net_local *np = netdev_priv(dev);
+
+	data = e100_get_mdio_reg(dev, np->mii_if.phy_id,
+				 MDIO_AUX_CTRL_STATUS_REG);
 	full_duplex = (data & MDIO_BC_FULL_DUPLEX_IND) ? 1 : 0;
 }
 
@@ -954,38 +1065,51 @@ static void
 intel_check_duplex(struct net_device* dev)
 {
 	unsigned long data;
-	data = e100_get_mdio_reg(dev, mdio_phy_addr, MDIO_INT_STATUS_REG_2);
+	struct net_local *np = netdev_priv(dev);
+
+	data = e100_get_mdio_reg(dev, np->mii_if.phy_id,
+				 MDIO_INT_STATUS_REG_2);
 	full_duplex = (data & MDIO_INT_FULL_DUPLEX_IND) ? 1 : 0;
 }
-
+#endif
 static void
 e100_set_duplex(struct net_device* dev, enum duplex new_duplex)
 {
+	struct net_local *np = netdev_priv(dev);
+
+	spin_lock(&np->transceiver_lock);
 	if (new_duplex != current_duplex) {
 		current_duplex = new_duplex;
 		e100_negotiate(dev);
 	}
+	spin_unlock(&np->transceiver_lock);
 }
 
 static int
 e100_probe_transceiver(struct net_device* dev)
 {
+#if !defined(CONFIG_ETRAX_NO_PHY)
 	unsigned int phyid_high;
 	unsigned int phyid_low;
 	unsigned int oui;
 	struct transceiver_ops* ops = NULL;
+	struct net_local *np = netdev_priv(dev);
+
+	spin_lock(&np->transceiver_lock);
 
 	/* Probe MDIO physical address */
-	for (mdio_phy_addr = 0; mdio_phy_addr <= 31; mdio_phy_addr++) {
-		if (e100_get_mdio_reg(dev, mdio_phy_addr, MII_BMSR) != 0xffff)
+	for (np->mii_if.phy_id = 0; np->mii_if.phy_id <= 31;
+	     np->mii_if.phy_id++) {
+		if (e100_get_mdio_reg(dev,
+				      np->mii_if.phy_id, MII_BMSR) != 0xffff)
 			break;
 	}
-	if (mdio_phy_addr == 32)
+	if (np->mii_if.phy_id == 32)
 		 return -ENODEV;
 
 	/* Get manufacturer */
-	phyid_high = e100_get_mdio_reg(dev, mdio_phy_addr, MII_PHYSID1);
-	phyid_low = e100_get_mdio_reg(dev, mdio_phy_addr, MII_PHYSID2);
+	phyid_high = e100_get_mdio_reg(dev, np->mii_if.phy_id, MII_PHYSID1);
+	phyid_low = e100_get_mdio_reg(dev, np->mii_if.phy_id, MII_PHYSID2);
 	oui = (phyid_high << 6) | (phyid_low >> 10);
 
 	for (ops = &transceivers[0]; ops->oui; ops++) {
@@ -994,6 +1118,8 @@ e100_probe_transceiver(struct net_device
 	}
 	transceiver = ops;
 
+	spin_unlock(&np->transceiver_lock);
+#endif
 	return 0;
 }
 
@@ -1088,13 +1214,14 @@ e100_receive_mdio_bit()
 static void
 e100_reset_transceiver(struct net_device* dev)
 {
+	struct net_local *np = netdev_priv(dev);
 	unsigned short cmd;
 	unsigned short data;
 	int bitCounter;
 
-	data = e100_get_mdio_reg(dev, mdio_phy_addr, MII_BMCR);
+	data = e100_get_mdio_reg(dev, np->mii_if.phy_id, MII_BMCR);
 
-	cmd = (MDIO_START << 14) | (MDIO_WRITE << 12) | (mdio_phy_addr << 7) | (MII_BMCR << 2);
+	cmd = (MDIO_START << 14) | (MDIO_WRITE << 12) | (np->mii_if.phy_id << 7) | (MII_BMCR << 2);
 
 	e100_send_mdio_cmd(cmd, 1);
 
@@ -1112,7 +1239,7 @@ e100_reset_transceiver(struct net_device
 static void
 e100_tx_timeout(struct net_device *dev)
 {
-	struct net_local *np = (struct net_local *)dev->priv;
+	struct net_local *np = netdev_priv(dev);
 	unsigned long flags;
 
 	spin_lock_irqsave(&np->lock, flags);
@@ -1134,8 +1261,7 @@ e100_tx_timeout(struct net_device *dev)
 	e100_reset_transceiver(dev);
 
 	/* and get rid of the packets that never got an interrupt */
-	while (myFirstTxDesc != myNextTxDesc)
-	{
+	while (myFirstTxDesc != myNextTxDesc) {
 		dev_kfree_skb(myFirstTxDesc->skb);
 		myFirstTxDesc->skb = 0;
 		myFirstTxDesc = phys_to_virt(myFirstTxDesc->descr.next);
@@ -1161,7 +1287,7 @@ e100_tx_timeout(struct net_device *dev)
 static int
 e100_send_packet(struct sk_buff *skb, struct net_device *dev)
 {
-	struct net_local *np = (struct net_local *)dev->priv;
+	struct net_local *np = netdev_priv(dev);
 	unsigned char *buf = skb->data;
 	unsigned long flags;
 
@@ -1174,7 +1300,7 @@ e100_send_packet(struct sk_buff *skb, st
 
 	dev->trans_start = jiffies;
 
-	e100_hardware_send_packet(buf, skb->len);
+	e100_hardware_send_packet(np, buf, skb->len);
 
 	myNextTxDesc = phys_to_virt(myNextTxDesc->descr.next);
 
@@ -1197,13 +1323,15 @@ static irqreturn_t
 e100rxtx_interrupt(int irq, void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
-	struct net_local *np = (struct net_local *)dev->priv;
-	unsigned long irqbits = *R_IRQ_MASK2_RD;
+	struct net_local *np = netdev_priv(dev);
+	unsigned long irqbits;
 
-	/* Disable RX/TX IRQs to avoid reentrancy */
-	*R_IRQ_MASK2_CLR =
-	  IO_STATE(R_IRQ_MASK2_CLR, dma0_eop, clr) |
-	  IO_STATE(R_IRQ_MASK2_CLR, dma1_eop, clr);
+	/*
+	 * Note that both rx and tx interrupts are blocked at this point,
+	 * regardless of which got us here.
+	 */
+
+	irqbits = *R_IRQ_MASK2_RD;
 
 	/* Handle received packets */
 	if (irqbits & IO_STATE(R_IRQ_MASK2_RD, dma1_eop, active)) {
@@ -1219,7 +1347,7 @@ e100rxtx_interrupt(int irq, void *dev_id
 			 * allocate a new buffer to put a packet in.
 			 */
 			e100_rx(dev);
-			((struct net_local *)dev->priv)->stats.rx_packets++;
+			np->stats.rx_packets++;
 			/* restart/continue on the channel, for safety */
 			*R_DMA_CH1_CMD = IO_STATE(R_DMA_CH1_CMD, cmd, restart);
 			/* clear dma channel 1 eop/descr irq bits */
@@ -1233,9 +1361,8 @@ e100rxtx_interrupt(int irq, void *dev_id
 	}
 
 	/* Report any packets that have been sent */
-	while (myFirstTxDesc != phys_to_virt(*R_DMA_CH0_FIRST) &&
-	       myFirstTxDesc != myNextTxDesc)
-	{
+	while (virt_to_phys(myFirstTxDesc) != *R_DMA_CH0_FIRST &&
+	       (netif_queue_stopped(dev) || myFirstTxDesc != myNextTxDesc)) {
 		np->stats.tx_bytes += myFirstTxDesc->skb->len;
 		np->stats.tx_packets++;
 
@@ -1244,19 +1371,15 @@ e100rxtx_interrupt(int irq, void *dev_id
 		dev_kfree_skb_irq(myFirstTxDesc->skb);
 		myFirstTxDesc->skb = 0;
 		myFirstTxDesc = phys_to_virt(myFirstTxDesc->descr.next);
+                /* Wake up queue. */
+		netif_wake_queue(dev);
 	}
 
 	if (irqbits & IO_STATE(R_IRQ_MASK2_RD, dma0_eop, active)) {
-		/* acknowledge the eop interrupt and wake up queue */
+		/* acknowledge the eop interrupt. */
 		*R_DMA_CH0_CLR_INTR = IO_STATE(R_DMA_CH0_CLR_INTR, clr_eop, do);
-		netif_wake_queue(dev);
 	}
 
-	/* Enable RX/TX IRQs again */
-	*R_IRQ_MASK2_SET =
-	  IO_STATE(R_IRQ_MASK2_SET, dma0_eop, set) |
-	  IO_STATE(R_IRQ_MASK2_SET, dma1_eop, set);
-
 	return IRQ_HANDLED;
 }
 
@@ -1264,7 +1387,7 @@ static irqreturn_t
 e100nw_interrupt(int irq, void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
-	struct net_local *np = (struct net_local *)dev->priv;
+	struct net_local *np = netdev_priv(dev);
 	unsigned long irqbits = *R_IRQ_MASK0_RD;
 
 	/* check for underrun irq */
@@ -1286,7 +1409,6 @@ e100nw_interrupt(int irq, void *dev_id)
 		SETS(network_tr_ctrl_shadow, R_NETWORK_TR_CTRL, clr_error, clr);
 		*R_NETWORK_TR_CTRL = network_tr_ctrl_shadow;
 		SETS(network_tr_ctrl_shadow, R_NETWORK_TR_CTRL, clr_error, nop);
-		*R_NETWORK_TR_CTRL = IO_STATE(R_NETWORK_TR_CTRL, clr_error, clr);
 		np->stats.tx_errors++;
 		D(printk("ethernet excessive collisions!\n"));
 	}
@@ -1299,12 +1421,13 @@ e100_rx(struct net_device *dev)
 {
 	struct sk_buff *skb;
 	int length = 0;
-	struct net_local *np = (struct net_local *)dev->priv;
+	struct net_local *np = netdev_priv(dev);
 	unsigned char *skb_data_ptr;
 #ifdef ETHDEBUG
 	int i;
 #endif
-
+	etrax_eth_descr *prevRxDesc;  /* The descriptor right before myNextRxDesc */
+	spin_lock(&np->led_lock);
 	if (!led_active && time_after(jiffies, led_next_time)) {
 		/* light the network leds depending on the current speed. */
 		e100_set_network_leds(NETWORK_ACTIVITY);
@@ -1314,9 +1437,10 @@ e100_rx(struct net_device *dev)
 		led_active = 1;
 		mod_timer(&clear_led_timer, jiffies + HZ/10);
 	}
+	spin_unlock(&np->led_lock);
 
 	length = myNextRxDesc->descr.hw_len - 4;
-	((struct net_local *)dev->priv)->stats.rx_bytes += length;
+	np->stats.rx_bytes += length;
 
 #ifdef ETHDEBUG
 	printk("Got a packet of length %d:\n", length);
@@ -1336,7 +1460,7 @@ e100_rx(struct net_device *dev)
 		if (!skb) {
 			np->stats.rx_errors++;
 			printk(KERN_NOTICE "%s: Memory squeeze, dropping packet.\n", dev->name);
-			return;
+			goto update_nextrxdesc;
 		}
 
 		skb_put(skb, length - ETHER_HEAD_LEN);        /* allocate room for the packet body */
@@ -1354,15 +1478,15 @@ e100_rx(struct net_device *dev)
 	else {
 		/* Large packet, send directly to upper layers and allocate new
 		 * memory (aligned to cache line boundary to avoid bug).
-		 * Before sending the skb to upper layers we must make sure that
-		 * skb->data points to the aligned start of the packet.
+		 * Before sending the skb to upper layers we must make sure
+		 * that skb->data points to the aligned start of the packet.
 		 */
 		int align;
 		struct sk_buff *new_skb = dev_alloc_skb(MAX_MEDIA_DATA_SIZE + 2 * L1_CACHE_BYTES);
 		if (!new_skb) {
 			np->stats.rx_errors++;
 			printk(KERN_NOTICE "%s: Memory squeeze, dropping packet.\n", dev->name);
-			return;
+			goto update_nextrxdesc;
 		}
 		skb = myNextRxDesc->skb;
 		align = (int)phys_to_virt(myNextRxDesc->descr.buf) - (int)skb->data;
@@ -1377,9 +1501,10 @@ e100_rx(struct net_device *dev)
 	/* Send the packet to the upper layers */
 	netif_rx(skb);
 
+  update_nextrxdesc:
 	/* Prepare for next packet */
 	myNextRxDesc->descr.status = 0;
-	myPrevRxDesc = myNextRxDesc;
+	prevRxDesc = myNextRxDesc;
 	myNextRxDesc = phys_to_virt(myNextRxDesc->descr.next);
 
 	rx_queue_len++;
@@ -1387,9 +1512,9 @@ e100_rx(struct net_device *dev)
 	/* Check if descriptors should be returned */
 	if (rx_queue_len == RX_QUEUE_THRESHOLD) {
 		flush_etrax_cache();
-		myPrevRxDesc->descr.ctrl |= d_eol;
+		prevRxDesc->descr.ctrl |= d_eol;
 		myLastRxDesc->descr.ctrl &= ~d_eol;
-		myLastRxDesc = myPrevRxDesc;
+		myLastRxDesc = prevRxDesc;
 		rx_queue_len = 0;
 	}
 }
@@ -1398,7 +1523,7 @@ e100_rx(struct net_device *dev)
 static int
 e100_close(struct net_device *dev)
 {
-	struct net_local *np = (struct net_local *)dev->priv;
+	struct net_local *np = netdev_priv(dev);
 
 	printk(KERN_INFO "Closing %s.\n", dev->name);
 
@@ -1426,6 +1551,9 @@ e100_close(struct net_device *dev)
 	free_irq(NETWORK_DMA_TX_IRQ_NBR, (void *)dev);
 	free_irq(NETWORK_STATUS_IRQ_NBR, (void *)dev);
 
+	cris_free_dma(NETWORK_TX_DMA_NBR, cardname);
+	cris_free_dma(NETWORK_RX_DMA_NBR, cardname);
+
 	/* Update the statistics here. */
 
 	update_rx_stats(&np->stats);
@@ -1443,18 +1571,11 @@ e100_ioctl(struct net_device *dev, struc
 {
 	struct mii_ioctl_data *data = if_mii(ifr);
 	struct net_local *np = netdev_priv(dev);
+	int rc = 0;
+        int old_autoneg;
 
 	spin_lock(&np->lock); /* Preempt protection */
 	switch (cmd) {
-		case SIOCGMIIPHY: /* Get PHY address */
-			data->phy_id = mdio_phy_addr;
-			break;
-		case SIOCGMIIREG: /* Read MII register */
-			data->val_out = e100_get_mdio_reg(dev, mdio_phy_addr, data->reg_num);
-			break;
-		case SIOCSMIIREG: /* Write MII register */
-			e100_set_mdio_reg(dev, mdio_phy_addr, data->reg_num, data->val_in);
-			break;
 		/* The ioctls below should be considered obsolete but are */
 		/* still present for compatability with old scripts/apps  */
 		case SET_ETH_SPEED_10:                  /* 10 Mbps */
@@ -1463,60 +1584,47 @@ e100_ioctl(struct net_device *dev, struc
 		case SET_ETH_SPEED_100:                /* 100 Mbps */
 			e100_set_speed(dev, 100);
 			break;
-		case SET_ETH_SPEED_AUTO:              /* Auto negotiate speed */
+		case SET_ETH_SPEED_AUTO:        /* Auto-negotiate speed */
 			e100_set_speed(dev, 0);
 			break;
-		case SET_ETH_DUPLEX_HALF:              /* Half duplex. */
+		case SET_ETH_DUPLEX_HALF:       /* Half duplex */
 			e100_set_duplex(dev, half);
 			break;
-		case SET_ETH_DUPLEX_FULL:              /* Full duplex. */
+		case SET_ETH_DUPLEX_FULL:       /* Full duplex */
 			e100_set_duplex(dev, full);
 			break;
-		case SET_ETH_DUPLEX_AUTO:             /* Autonegotiate duplex*/
+		case SET_ETH_DUPLEX_AUTO:       /* Auto-negotiate duplex */
 			e100_set_duplex(dev, autoneg);
 			break;
+	        case SET_ETH_AUTONEG:
+			old_autoneg = autoneg_normal;
+		        autoneg_normal = *(int*)data;
+			if (autoneg_normal != old_autoneg)
+				e100_negotiate(dev);
+			break;
 		default:
-			return -EINVAL;
+			rc = generic_mii_ioctl(&np->mii_if, if_mii(ifr),
+						cmd, NULL);
+			break;
 	}
 	spin_unlock(&np->lock);
-	return 0;
+	return rc;
 }
 
-static int e100_set_settings(struct net_device *dev,
-			     struct ethtool_cmd *ecmd)
+static int e100_get_settings(struct net_device *dev,
+			     struct ethtool_cmd *cmd)
 {
-	ecmd->supported = SUPPORTED_Autoneg | SUPPORTED_TP | SUPPORTED_MII |
-			  SUPPORTED_10baseT_Half | SUPPORTED_10baseT_Full |
-			  SUPPORTED_100baseT_Half | SUPPORTED_100baseT_Full;
-	ecmd->port = PORT_TP;
-	ecmd->transceiver = XCVR_EXTERNAL;
-	ecmd->phy_address = mdio_phy_addr;
-	ecmd->speed = current_speed;
-	ecmd->duplex = full_duplex ? DUPLEX_FULL : DUPLEX_HALF;
-	ecmd->advertising = ADVERTISED_TP;
-
-	if (current_duplex == autoneg && current_speed_selection == 0)
-		ecmd->advertising |= ADVERTISED_Autoneg;
-	else {
-		ecmd->advertising |=
-			ADVERTISED_10baseT_Half | ADVERTISED_10baseT_Full |
-			ADVERTISED_100baseT_Half | ADVERTISED_100baseT_Full;
-		if (current_speed_selection == 10)
-			ecmd->advertising &= ~(ADVERTISED_100baseT_Half |
-					       ADVERTISED_100baseT_Full);
-		else if (current_speed_selection == 100)
-			ecmd->advertising &= ~(ADVERTISED_10baseT_Half |
-					       ADVERTISED_10baseT_Full);
-		if (current_duplex == half)
-			ecmd->advertising &= ~(ADVERTISED_10baseT_Full |
-					       ADVERTISED_100baseT_Full);
-		else if (current_duplex == full)
-			ecmd->advertising &= ~(ADVERTISED_10baseT_Half |
-					       ADVERTISED_100baseT_Half);
-	}
+	struct net_local *np = netdev_priv(dev);
+	int err;
 
-	ecmd->autoneg = AUTONEG_ENABLE;
-	return 0;
+	spin_lock_irq(&np->lock);
+	err = mii_ethtool_gset(&np->mii_if, cmd);
+	spin_unlock_irq(&np->lock);
+
+	/* The PHY may support 1000baseT, but the Etrax100 does not.  */
+	cmd->supported &= ~(SUPPORTED_1000baseT_Half
+			    | SUPPORTED_1000baseT_Full);
+	return err;
 }
 
 static int e100_set_settings(struct net_device *dev,
@@ -1560,7 +1668,8 @@ static const struct ethtool_ops e100_eth
 static int
 e100_set_config(struct net_device *dev, struct ifmap *map)
 {
-	struct net_local *np = (struct net_local *)dev->priv;
+	struct net_local *np = netdev_priv(dev);
+
 	spin_lock(&np->lock); /* Preempt protection */
 
 	switch(map->port) {
@@ -1612,7 +1721,6 @@ update_tx_stats(struct net_device_stats 
 	es->collisions +=
 		IO_EXTRACT(R_TR_COUNTERS, single_col, r) +
 		IO_EXTRACT(R_TR_COUNTERS, multiple_col, r);
-	es->tx_errors += IO_EXTRACT(R_TR_COUNTERS, deferred, r);
 }
 
 /*
@@ -1622,8 +1730,9 @@ update_tx_stats(struct net_device_stats 
 static struct net_device_stats *
 e100_get_stats(struct net_device *dev)
 {
-	struct net_local *lp = (struct net_local *)dev->priv;
+	struct net_local *lp = netdev_priv(dev);
 	unsigned long flags;
+
 	spin_lock_irqsave(&lp->lock, flags);
 
 	update_rx_stats(&lp->stats);
@@ -1643,13 +1752,13 @@ e100_get_stats(struct net_device *dev)
 static void
 set_multicast_list(struct net_device *dev)
 {
-	struct net_local *lp = (struct net_local *)dev->priv;
+	struct net_local *lp = netdev_priv(dev);
 	int num_addr = dev->mc_count;
 	unsigned long int lo_bits;
 	unsigned long int hi_bits;
+
 	spin_lock(&lp->lock);
-	if (dev->flags & IFF_PROMISC)
-	{
+	if (dev->flags & IFF_PROMISC) {
 		/* promiscuous mode */
 		lo_bits = 0xfffffffful;
 		hi_bits = 0xfffffffful;
@@ -1679,9 +1788,10 @@ set_multicast_list(struct net_device *de
 		struct dev_mc_list *dmi = dev->mc_list;
 		int i;
 		char *baddr;
+
 		lo_bits = 0x00000000ul;
 		hi_bits = 0x00000000ul;
-		for (i=0; i<num_addr; i++) {
+		for (i = 0; i < num_addr; i++) {
 			/* Calculate the hash index for the GA registers */
 
 			hash_ix = 0;
@@ -1708,8 +1818,7 @@ set_multicast_list(struct net_device *de
 
 			if (hash_ix >= 32) {
 				hi_bits |= (1 << (hash_ix-32));
-			}
-			else {
+			} else {
 				lo_bits |= (1 << hash_ix);
 			}
 			dmi = dmi->next;
@@ -1724,10 +1833,11 @@ set_multicast_list(struct net_device *de
 }
 
 void
-e100_hardware_send_packet(char *buf, int length)
+e100_hardware_send_packet(struct net_local *np, char *buf, int length)
 {
 	D(printk("e100 send pack, buf 0x%x len %d\n", buf, length));
 
+	spin_lock(&np->led_lock);
 	if (!led_active && time_after(jiffies, led_next_time)) {
 		/* light the network leds depending on the current speed. */
 		e100_set_network_leds(NETWORK_ACTIVITY);
@@ -1737,6 +1847,7 @@ e100_hardware_send_packet(char *buf, int
 		led_active = 1;
 		mod_timer(&clear_led_timer, jiffies + HZ/10);
 	}
+	spin_unlock(&np->led_lock);
 
 	/* configure the tx dma descriptor */
 	myNextTxDesc->descr.sw_len = length;
@@ -1754,6 +1865,11 @@ e100_hardware_send_packet(char *buf, int
 static void
 e100_clear_network_leds(unsigned long dummy)
 {
+	struct net_device *dev = (struct net_device *)dummy;
+	struct net_local *np = netdev_priv(dev);
+
+	spin_lock(&np->led_lock);
+
 	if (led_active && time_after(jiffies, led_next_time)) {
 		e100_set_network_leds(NO_NETWORK_ACTIVITY);
 
@@ -1761,6 +1877,8 @@ e100_clear_network_leds(unsigned long du
 		led_next_time = jiffies + NET_FLASH_PAUSE;
 		led_active = 0;
 	}
+
+	spin_unlock(&np->led_lock);
 }
 
 static void
@@ -1781,19 +1899,25 @@ e100_set_network_leds(int active)
 #else
 		LED_NETWORK_SET(LED_OFF);
 #endif
-	}
-	else if (light_leds) {
+	} else if (light_leds) {
 		if (current_speed == 10) {
 			LED_NETWORK_SET(LED_ORANGE);
 		} else {
 			LED_NETWORK_SET(LED_GREEN);
 		}
-	}
-	else {
+	} else {
 		LED_NETWORK_SET(LED_OFF);
 	}
 }
 
+#ifdef CONFIG_NET_POLL_CONTROLLER
+static void
+e100_netpoll(struct net_device* netdev)
+{
+	e100rxtx_interrupt(NETWORK_DMA_TX_IRQ_NBR, netdev, NULL);
+}
+#endif
+
 static int
 etrax_init_module(void)
 {
diff -puN include/asm-cris/ethernet.h~cris-build-fixes-update-eth_v10c-ethernet-driver include/asm-cris/ethernet.h
--- a/include/asm-cris/ethernet.h~cris-build-fixes-update-eth_v10c-ethernet-driver
+++ a/include/asm-cris/ethernet.h
@@ -15,4 +15,7 @@
 #define SET_ETH_DUPLEX_AUTO     SIOCDEVPRIVATE+3        /* Auto neg duplex */
 #define SET_ETH_DUPLEX_HALF     SIOCDEVPRIVATE+4        /* Full duplex */
 #define SET_ETH_DUPLEX_FULL     SIOCDEVPRIVATE+5        /* Half duplex */
+#define SET_ETH_ENABLE_LEDS     SIOCDEVPRIVATE+6        /* Enable net LEDs */
+#define SET_ETH_DISABLE_LEDS    SIOCDEVPRIVATE+7        /* Disable net LEDs */
+#define SET_ETH_AUTONEG         SIOCDEVPRIVATE+8
 #endif /* _CRIS_ETHERNET_H */
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

origin.patch
cris-build-fixes-atomich-needs-compilerh.patch
git-mtd.patch
