From: akpm@linux-foundation.org
Subject: + blackfin-on-chip-ethernet-mac-controller-driver-update.patch added to -mm tree
Date: Fri, 02 Mar 2007 14:09:24 -0800
Message-ID: <200703022209.l22M9Onx020463@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43064 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030521AbXCBWJa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 17:09:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com


The patch titled
     Blackfin: on-chip ethernet MAC controller driver (update)
has been added to the -mm tree.  Its filename is
     blackfin-on-chip-ethernet-mac-controller-driver-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Blackfin: on-chip ethernet MAC controller driver (update)
From: "Wu, Bryan" <bryan.wu@analog.com>

a) Change to follow kernel coding style
b) rename some functions and structures
c) change '//' to '/* */'
d) use pr_debug()

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/bfin_mac.c |  249 ++++++++++++++++++---------------------
 drivers/net/bfin_mac.h |  127 ++++++++++---------
 2 files changed, 185 insertions(+), 191 deletions(-)

diff -puN drivers/net/bfin_mac.c~blackfin-on-chip-ethernet-mac-controller-driver-update drivers/net/bfin_mac.c
--- a/drivers/net/bfin_mac.c~blackfin-on-chip-ethernet-mac-controller-driver-update
+++ a/drivers/net/bfin_mac.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: bfin_mac.c,v 1.60 2006/12/16 11:23:56 hennerich Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -83,16 +81,14 @@ MODULE_DESCRIPTION("Blackfin MAC Driver"
 static void desc_list_free(void);
 
 /* pointers to maintain transmit list */
-struct net_dma_desc_tx *tx_list_head;
-struct net_dma_desc_tx *tx_list_tail;
-struct net_dma_desc_rx *rx_list_head;
-struct net_dma_desc_rx *rx_list_tail;
-struct net_dma_desc_rx *current_rx_ptr;
-struct net_dma_desc_tx *current_tx_ptr;
-struct net_dma_desc_tx *tx_desc;
-struct net_dma_desc_rx *rx_desc;
-
-extern void get_bf537_ether_addr(char *addr);
+static struct net_dma_desc_tx *tx_list_head;
+static struct net_dma_desc_tx *tx_list_tail;
+static struct net_dma_desc_rx *rx_list_head;
+static struct net_dma_desc_rx *rx_list_tail;
+static struct net_dma_desc_rx *current_rx_ptr;
+static struct net_dma_desc_tx *current_tx_ptr;
+static struct net_dma_desc_tx *tx_desc;
+static struct net_dma_desc_rx *rx_desc;
 
 static int desc_list_init(void)
 {
@@ -131,22 +127,22 @@ static int desc_list_init(void)
 		tmp_desc_tx->desc_a.start_addr =
 		    (unsigned long)tmp_desc_tx->packet;
 		tmp_desc_tx->desc_a.x_count = 0;
-		tmp_desc_tx->desc_a.config.b_DMA_EN = 0;	//disabled
-		tmp_desc_tx->desc_a.config.b_WNR = 0;	//read from memory
-		tmp_desc_tx->desc_a.config.b_WDSIZE = 2;	//wordsize is 32 bits
-		tmp_desc_tx->desc_a.config.b_NDSIZE = 6;	//6 half words is desc size.
-		tmp_desc_tx->desc_a.config.b_FLOW = 7;	//large desc flow
+		tmp_desc_tx->desc_a.config.b_DMA_EN = 0;	/* disabled */
+		tmp_desc_tx->desc_a.config.b_WNR = 0;		/* read from memory */
+		tmp_desc_tx->desc_a.config.b_WDSIZE = 2;	/* wordsize is 32 bits */
+		tmp_desc_tx->desc_a.config.b_NDSIZE = 6;	/* 6 half words is desc size. */
+		tmp_desc_tx->desc_a.config.b_FLOW = 7;		/* large desc flow */
 		tmp_desc_tx->desc_a.next_dma_desc = &(tmp_desc_tx->desc_b);
 
 		tmp_desc_tx->desc_b.start_addr =
 		    (unsigned long)(&(tmp_desc_tx->status));
 		tmp_desc_tx->desc_b.x_count = 0;
-		tmp_desc_tx->desc_b.config.b_DMA_EN = 1;	//enabled
-		tmp_desc_tx->desc_b.config.b_WNR = 1;	//write to memory
-		tmp_desc_tx->desc_b.config.b_WDSIZE = 2;	//wordsize is 32 bits
-		tmp_desc_tx->desc_b.config.b_DI_EN = 0;	//disable interrupt
+		tmp_desc_tx->desc_b.config.b_DMA_EN = 1;	/* enabled */
+		tmp_desc_tx->desc_b.config.b_WNR = 1;		/* write to memory */
+		tmp_desc_tx->desc_b.config.b_WDSIZE = 2;	/* wordsize is 32 bits */
+		tmp_desc_tx->desc_b.config.b_DI_EN = 0;		/* disable interrupt */
 		tmp_desc_tx->desc_b.config.b_NDSIZE = 6;
-		tmp_desc_tx->desc_b.config.b_FLOW = 7;	//stop mode
+		tmp_desc_tx->desc_b.config.b_FLOW = 7;		/* stop mode */
 		tmp_desc_tx->skb = NULL;
 		tx_list_tail->desc_b.next_dma_desc = &(tmp_desc_tx->desc_a);
 		tx_list_tail->next = tmp_desc_tx;
@@ -180,22 +176,22 @@ static int desc_list_init(void)
 		tmp_desc_rx->desc_a.start_addr =
 		    (unsigned long)new_skb->data - 2;
 		tmp_desc_rx->desc_a.x_count = 0;
-		tmp_desc_rx->desc_a.config.b_DMA_EN = 1;	//enabled
-		tmp_desc_rx->desc_a.config.b_WNR = 1;	//Write to memory
-		tmp_desc_rx->desc_a.config.b_WDSIZE = 2;	//wordsize is 32 bits
-		tmp_desc_rx->desc_a.config.b_NDSIZE = 6;	//6 half words is desc size.
-		tmp_desc_rx->desc_a.config.b_FLOW = 7;	//large desc flow
+		tmp_desc_rx->desc_a.config.b_DMA_EN = 1;	/* enabled */
+		tmp_desc_rx->desc_a.config.b_WNR = 1;		/* Write to memory */
+		tmp_desc_rx->desc_a.config.b_WDSIZE = 2;	/* wordsize is 32 bits */
+		tmp_desc_rx->desc_a.config.b_NDSIZE = 6;	/* 6 half words is desc size. */
+		tmp_desc_rx->desc_a.config.b_FLOW = 7;		/* large desc flow */
 		tmp_desc_rx->desc_a.next_dma_desc = &(tmp_desc_rx->desc_b);
 
 		tmp_desc_rx->desc_b.start_addr =
 		    (unsigned long)(&(tmp_desc_rx->status));
 		tmp_desc_rx->desc_b.x_count = 0;
-		tmp_desc_rx->desc_b.config.b_DMA_EN = 1;	//enabled
-		tmp_desc_rx->desc_b.config.b_WNR = 1;	//Write to memory
-		tmp_desc_rx->desc_b.config.b_WDSIZE = 2;	//wordsize is 32 bits
+		tmp_desc_rx->desc_b.config.b_DMA_EN = 1;	/* enabled */
+		tmp_desc_rx->desc_b.config.b_WNR = 1;		/* Write to memory */
+		tmp_desc_rx->desc_b.config.b_WDSIZE = 2;	/* wordsize is 32 bits */
 		tmp_desc_rx->desc_b.config.b_NDSIZE = 6;
-		tmp_desc_rx->desc_b.config.b_DI_EN = 1;	//enable interrupt
-		tmp_desc_rx->desc_b.config.b_FLOW = 7;	//large mode
+		tmp_desc_rx->desc_b.config.b_DI_EN = 1;		/* enable interrupt */
+		tmp_desc_rx->desc_b.config.b_FLOW = 7;		/* large mode */
 		rx_list_tail->desc_b.next_dma_desc = &(tmp_desc_rx->desc_a);
 
 		rx_list_tail->next = tmp_desc_rx;
@@ -254,16 +250,15 @@ static void desc_list_free(void)
 
 /*---PHY CONTROL AND CONFIGURATION-----------------------------------------*/
 
-//
-//Set FER regs to MUX in Ethernet pins
-//
-
-static void SetupPinMux(void)
+/* Set FER regs to MUX in Ethernet pins */
+static void setup_pin_mux(void)
 {
 	unsigned int fer_val;
 
-	// FER reg bug work-around
-	// read it once
+	/*
+	 * FER reg bug work-around
+	 * read it once
+	 */
 	fer_val = bfin_read_PORTH_FER();
 
 #if defined(CONFIG_BFIN_MAC_RMII)
@@ -271,122 +266,114 @@ static void SetupPinMux(void)
 #else
 	fer_val = 0xffff;
 #endif
-	// write it twice to the same value
+	/* write it twice to the same value */
 
 	bfin_write_PORTH_FER(fer_val);
 	bfin_write_PORTH_FER(fer_val);
 }
 
-//
-//Wait until the previous MDC/MDIO transaction has completed
-//
-
-static void PollMdcDone(void)
+/* Wait until the previous MDC/MDIO transaction has completed */
+static void poll_mdc_done(void)
 {
-	// poll the STABUSY bit
+	/* poll the STABUSY bit */
 	while ((bfin_read_EMAC_STAADD()) & STABUSY) {
 	};
 }
 
-//
-//Read an off-chip register in a PHY through the MDC/MDIO port
-//
-
-static u16 RdPHYReg(u16 PHYAddr, u16 RegAddr)
-{
-	PollMdcDone();
-	bfin_write_EMAC_STAADD(SET_PHYAD(PHYAddr) | SET_REGAD(RegAddr) | STABUSY);	// read mode
-	PollMdcDone();
+/* Read an off-chip register in a PHY through the MDC/MDIO port */
+static u16 read_phy_reg(u16 PHYAddr, u16 RegAddr)
+{
+	poll_mdc_done();
+	bfin_write_EMAC_STAADD(SET_PHYAD(PHYAddr) | SET_REGAD(RegAddr) | STABUSY);	/* read mode */
+	poll_mdc_done();
 
 	return (u16) bfin_read_EMAC_STADAT();
 }
 
-//
-//Write an off-chip register in a PHY through the MDC/MDIO port
-//
-
-static void RawWrPHYReg(u16 PHYAddr, u16 RegAddr, u32 Data)
+/* Write an off-chip register in a PHY through the MDC/MDIO port */
+static void raw_write_phy_reg(u16 PHYAddr, u16 RegAddr, u32 Data)
 {
-
 	bfin_write_EMAC_STADAT(Data);
 
-	bfin_write_EMAC_STAADD(SET_PHYAD(PHYAddr) | SET_REGAD(RegAddr) | STAOP | STABUSY);	//write mode
+	bfin_write_EMAC_STAADD(SET_PHYAD(PHYAddr) | SET_REGAD(RegAddr) | STAOP | STABUSY);	/* write mode */
 
-	PollMdcDone();
+	poll_mdc_done();
 }
 
-static void WrPHYReg(u16 PHYAddr, u16 RegAddr, u32 Data)
+static void write_phy_reg(u16 PHYAddr, u16 RegAddr, u32 Data)
 {
-	PollMdcDone();
-	RawWrPHYReg(PHYAddr, RegAddr, Data);
+	poll_mdc_done();
+	raw_write_phy_reg(PHYAddr, RegAddr, Data);
 }
 
-//
-//set up the phy
-//
+/* set up the phy */
 static void bf537mac_setphy(struct net_device *dev)
 {
 	u16 phydat;
 	u32 sysctl;
 	struct bf537mac_local *lp = netdev_priv(dev);
 
-	//printk(KERN_DEBUG CARDNAME ": start settting up phy\n");
+	pr_debug("start settting up phy\n");
 
-	//Program PHY registers
+	/* Program PHY registers */
 	phydat = 0;
 
-	// issue a reset
-	RawWrPHYReg(lp->PhyAddr, PHYREG_MODECTL, 0x8000);
+	/* issue a reset */
+	raw_write_phy_reg(lp->PhyAddr, PHYREG_MODECTL, 0x8000);
 
-	// wait half a second
+	/* wait half a second */
 	udelay(500);
 
-	phydat = RdPHYReg(lp->PhyAddr, PHYREG_MODECTL);
+	phydat = read_phy_reg(lp->PhyAddr, PHYREG_MODECTL);
 
-	// advertise flow control supported
-	phydat = RdPHYReg(lp->PhyAddr, PHYREG_ANAR);
+	/* advertise flow control supported */
+	phydat = read_phy_reg(lp->PhyAddr, PHYREG_ANAR);
 	phydat |= (1 << 10);
-	WrPHYReg(lp->PhyAddr, PHYREG_ANAR, phydat);
+	write_phy_reg(lp->PhyAddr, PHYREG_ANAR, phydat);
 
 	phydat = 0;
 	if (lp->Negotiate) {
-		phydat |= 0x1000;	// enable auto negotiation
+		phydat |= 0x1000;	/* enable auto negotiation */
 	} else {
 		if (lp->FullDuplex) {
-			phydat |= (1 << 8);	// full duplex
+			phydat |= (1 << 8);	/* full duplex */
 		} else {
-			phydat &= (~(1 << 8));	// half duplex
+			phydat &= (~(1 << 8));	/* half duplex */
 		}
 		if (!lp->Port10) {
-			phydat |= (1 << 13);	// 100 Mbps
+			phydat |= (1 << 13);	/* 100 Mbps */
 		} else {
-			phydat &= (~(1 << 13));	// 10 Mbps
+			phydat &= (~(1 << 13));	/* 10 Mbps */
 		}
 	}
 
 	if (lp->Loopback) {
-		phydat |= (1 << 14);	// enable TX->RX loopback
-		//WrPHYReg(lp->PhyAddr, PHYREG_MODECTL, phydat);
+		phydat |= (1 << 14);	/* enable TX->RX loopback */
+#if 0
+		write_phy_reg(lp->PhyAddr, PHYREG_MODECTL, phydat);
+#endif
 	}
 
-	WrPHYReg(lp->PhyAddr, PHYREG_MODECTL, phydat);
+	write_phy_reg(lp->PhyAddr, PHYREG_MODECTL, phydat);
 	udelay(500);
 
-	phydat = RdPHYReg(lp->PhyAddr, PHYREG_MODECTL);
-	// check for SMSC PHY
-	if ((RdPHYReg(lp->PhyAddr, PHYREG_PHYID1) == 0x7)
-	    && ((RdPHYReg(lp->PhyAddr, PHYREG_PHYID2) & 0xfff0) == 0xC0A0)) {
-		// we have SMSC PHY so reqest interrupt on link down condition
-		WrPHYReg(lp->PhyAddr, 30, 0x0ff);	// enable interrupts
-		// enable PHY_INT
+	phydat = read_phy_reg(lp->PhyAddr, PHYREG_MODECTL);
+	/* check for SMSC PHY */
+	if ((read_phy_reg(lp->PhyAddr, PHYREG_PHYID1) == 0x7)
+	    && ((read_phy_reg(lp->PhyAddr, PHYREG_PHYID2) & 0xfff0) == 0xC0A0)) {
+		/* we have SMSC PHY so reqest interrupt on link down condition */
+		write_phy_reg(lp->PhyAddr, 30, 0x0ff);	/* enable interrupts */
+		/* enable PHY_INT */
 		sysctl = bfin_read_EMAC_SYSCTL();
 		sysctl |= 0x1;
-		//bfin_write_EMAC_SYSCTL(sysctl);
+#if 0
+		bfin_write_EMAC_SYSCTL(sysctl);
+#endif
 	}
 }
 
 /**************************************************************************/
-void SetupSystemRegs(struct net_device *dev)
+void setup_system_regs(struct net_device *dev)
 {
 	int PHYADDR;
 	unsigned short sysctl, phydat;
@@ -414,12 +401,12 @@ void SetupSystemRegs(struct net_device *
 	/* full duplex          */
 	/* 100 Mbps             */
 	phydat = PHY_ANEG_EN | PHY_DUPLEX | PHY_SPD_SET;
-	WrPHYReg(PHYADDR, PHYREG_MODECTL, phydat);
+	write_phy_reg(PHYADDR, PHYREG_MODECTL, phydat);
 
 	/* test if full duplex supported */
 	do {
 		msleep(100);
-		phydat = RdPHYReg(PHYADDR, PHYREG_MODESTAT);
+		phydat = read_phy_reg(PHYADDR, PHYREG_MODESTAT);
 		if (count > 30) {
 			printk(KERN_NOTICE CARDNAME
 			       ": Link is down, please check your network connection\n");
@@ -428,7 +415,7 @@ void SetupSystemRegs(struct net_device *
 		count++;
 	} while (!(phydat & 0x0004));
 
-	phydat = RdPHYReg(PHYADDR, PHYREG_ANLPAR);
+	phydat = read_phy_reg(PHYADDR, PHYREG_ANLPAR);
 
 	if ((phydat & 0x0100) || (phydat & 0x0040)) {
 		opmode = FDMODE;
@@ -443,7 +430,9 @@ void SetupSystemRegs(struct net_device *
 
 	bfin_write_EMAC_OPMODE(opmode);
 
-	//bfin_write_EMAC_MMC_CTL(RSTC | CROLL | MMCE);
+#if 0
+	bfin_write_EMAC_MMC_CTL(RSTC | CROLL | MMCE);
+#endif
 	bfin_write_EMAC_MMC_CTL(RSTC | CROLL);
 
 	/* Initialize the TX DMA channel registers */
@@ -459,9 +448,9 @@ void SetupSystemRegs(struct net_device *
 	bfin_write_DMA1_Y_MODIFY(0);
 }
 
-void SetupMacAddr(u8 * mac_addr)
+void setup_mac_addr(u8 * mac_addr)
 {
-	// this depends on a little-endian machine
+	/* this depends on a little-endian machine */
 	bfin_write_EMAC_ADDRLO(*(u32 *) & mac_addr[0]);
 	bfin_write_EMAC_ADDRHI(*(u16 *) & mac_addr[4]);
 }
@@ -470,7 +459,7 @@ static void adjust_tx_list(void)
 {
 	if (tx_list_head->status.status_word != 0
 	    && current_tx_ptr != tx_list_head) {
-		goto adjust_head;	// released something, just return;
+		goto adjust_head;	/* released something, just return; */
 	}
 
 	/* if nothing released, check wait condition */
@@ -514,13 +503,13 @@ static int bf537mac_hard_start_xmit(stru
 	unsigned int data;
 
 	current_tx_ptr->skb = skb;
-	// Is skb->data always 16-bit aligned? Do we need to memcpy((char *)(tail->packet + 2),skb->data,len)?
+	/* Is skb->data always 16-bit aligned? Do we need to memcpy((char *)(tail->packet + 2),skb->data,len)? */
 	if ((((unsigned int)(skb->data)) & 0x02) == 2) {
-		//move skb->data to current_tx_ptr payload
+		/* move skb->data to current_tx_ptr payload */
 		data = (unsigned int)(skb->data) - 2;
 		*((unsigned short *)data) = (unsigned short)(skb->len);
 		current_tx_ptr->desc_a.start_addr = (unsigned long)data;
-		blackfin_dcache_flush_range(data, (data + (skb->len)) + 2);	//this is important!
+		blackfin_dcache_flush_range(data, (data + (skb->len)) + 2);	/* this is important! */
 
 	} else {
 		*((unsigned short *)(current_tx_ptr->packet)) =
@@ -538,14 +527,16 @@ static int bf537mac_hard_start_xmit(stru
 					    2);
 	}
 
-	current_tx_ptr->desc_a.config.b_DMA_EN = 1;	//enable this packet's dma
+	current_tx_ptr->desc_a.config.b_DMA_EN = 1;	/* enable this packet's dma */
 
-	if (bfin_read_DMA2_IRQ_STATUS() & 0x08) {	//tx dma is running, just return
+	if (bfin_read_DMA2_IRQ_STATUS() & 0x08) {	/* tx dma is running, just return */
 		goto out;
-	} else {		//tx dma is not running
+	} else {
+		/* tx dma is not running */
 		bfin_write_DMA2_NEXT_DESC_PTR(&(current_tx_ptr->desc_a));
-		bfin_write_DMA2_CONFIG(*((unsigned short *)(&(current_tx_ptr->desc_a.config))));	// dma enabled, read from memory, size is 6
-		// Turn on the EMAC tx
+		/* dma enabled, read from memory, size is 6 */
+		bfin_write_DMA2_CONFIG(*((unsigned short *)(&(current_tx_ptr->desc_a.config))));
+		/* Turn on the EMAC tx */
 		bfin_write_EMAC_OPMODE(bfin_read_EMAC_OPMODE() | TE);
 	}
 
@@ -577,7 +568,8 @@ static void bf537mac_rx(struct net_devic
 	skb_reserve(new_skb, 2);
 	current_rx_ptr->skb = new_skb;
 	current_rx_ptr->desc_a.start_addr = (unsigned long)new_skb->data - 2;
-/*
+
+#if 0
 	int i;
 	if (len >= 64) {
 		for (i=0;i<len;i++) {
@@ -586,7 +578,7 @@ static void bf537mac_rx(struct net_devic
 		}
 	printk("\n");
 	}
-*/
+#endif
 
 	len = (unsigned short)((current_rx_ptr->status.status_word) & RX_FRLEN);
 	skb_put(skb, len);
@@ -618,7 +610,7 @@ static irqreturn_t bf537mac_interrupt(in
 	int number = 0;
 
       get_one_packet:
-	if (current_rx_ptr->status.status_word == 0) {	// no more new packet received
+	if (current_rx_ptr->status.status_word == 0) {	/* no more new packet received */
 		if (number == 0) {
 			if (current_rx_ptr->next->status.status_word != 0) {
 				current_rx_ptr = current_rx_ptr->next;
@@ -662,9 +654,8 @@ static void bf537mac_reset(void)
 static int bf537mac_enable(struct net_device *dev)
 {
 	u32 opmode;
-	//u32 pkt_status;
 
-	//printk("%s: %s\n", dev->name, __FUNCTION__);
+	pr_debug("%s: %s\n", dev->name, __FUNCTION__);
 
 	/* Set RX DMA */
 	bfin_write_DMA1_NEXT_DESC_PTR(&(rx_list_head->desc_a));
@@ -673,7 +664,7 @@ static int bf537mac_enable(struct net_de
 				 *)(&(rx_list_head->desc_a.config))));
 
 	/* Wait MII done */
-	PollMdcDone();
+	poll_mdc_done();
 
 	/* We enable only RX here */
 	/* ASTP   : Enable Automatic Pad Stripping
@@ -704,7 +695,7 @@ static int bf537mac_enable(struct net_de
 /* Our watchdog timed out. Called by the networking layer */
 static void bf537mac_timeout(struct net_device *dev)
 {
-	//printk("%s: %s\n", dev->name, __FUNCTION__);
+	pr_debug("%s: %s\n", dev->name, __FUNCTION__);
 
 	bf537mac_reset();
 
@@ -727,7 +718,7 @@ static struct net_device_stats *bf537mac
 {
 	struct bf537mac_local *lp = netdev_priv(dev);
 
-	//printk("%s: %s\n", dev->name, __FUNCTION__);
+	pr_debug("%s: %s\n", dev->name, __FUNCTION__);
 
 	return &lp->stats;
 }
@@ -781,7 +772,7 @@ static void bf537mac_shutdown(struct net
  */
 static int bf537mac_open(struct net_device *dev)
 {
-	//printk("%s: %s\n", dev->name, __FUNCTION__);
+	pr_debug("%s: %s\n", dev->name, __FUNCTION__);
 
 	/*
 	 * Check that the address is valid.  If its not, refuse
@@ -797,11 +788,11 @@ static int bf537mac_open(struct net_devi
 	desc_list_init();
 
 	bf537mac_setphy(dev);
-	SetupSystemRegs(dev);
+	setup_system_regs(dev);
 	bf537mac_reset();
 	bf537mac_enable(dev);
 
-	//printk(KERN_DEBUG CARDNAME ": hardware init finished\n");
+	pr_debug("hardware init finished\n");
 	netif_start_queue(dev);
 	netif_carrier_on(dev);
 
@@ -816,7 +807,7 @@ static int bf537mac_open(struct net_devi
  */
 static int bf537mac_close(struct net_device *dev)
 {
-	//printk("%s: %s\n", dev->name, __FUNCTION__);
+	pr_debug("%s: %s\n", dev->name, __FUNCTION__);
 
 	netif_stop_queue(dev);
 	netif_carrier_off(dev);
@@ -843,7 +834,7 @@ static int __init bf537mac_probe(struct 
 	/*todo: how to proble? which is revision_register */
 	bfin_write_EMAC_ADDRLO(0x12345678);
 	if (bfin_read_EMAC_ADDRLO() != 0x12345678) {
-		//printk(CARDNAME ": can't detect bf537 mac!\n");
+		pr_debug("can't detect bf537 mac!\n");
 		retval = -ENODEV;
 		goto err_out;
 	}
@@ -860,7 +851,7 @@ static int __init bf537mac_probe(struct 
 		random_ether_addr(dev->dev_addr);
 	}
 
-	SetupMacAddr(dev->dev_addr);
+	setup_mac_addr(dev->dev_addr);
 
 	/* Fill in the fields of the device structure with ethernet values. */
 	ether_setup(dev);
@@ -871,7 +862,9 @@ static int __init bf537mac_probe(struct 
 	dev->tx_timeout = bf537mac_timeout;
 	dev->get_stats = bf537mac_query_statistics;
 	dev->set_multicast_list = bf537mac_set_multicast_list;
-	//  dev->ethtool_ops = &bf537mac_ethtool_ops;
+#if 0
+	dev->ethtool_ops = &bf537mac_ethtool_ops;
+#endif
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	dev->poll_controller = bf537mac_poll;
 #endif
@@ -885,8 +878,8 @@ static int __init bf537mac_probe(struct 
 	lp->FlowControl = 0;
 	spin_lock_init(&lp->lock);
 
-	// set the GPIO pins to Ethernet mode
-	SetupPinMux();
+	/* set the GPIO pins to Ethernet mode */
+	setup_pin_mux();
 
 	/* now, enable interrupts */
 	/* register irq handler */
@@ -898,7 +891,7 @@ static int __init bf537mac_probe(struct 
 		return -EBUSY;
 	}
 
-	/* Enable PHY output early*/
+	/* Enable PHY output early */
 	if (!(bfin_read_VR_CTL() & PHYCLKOE))
 		bfin_write_VR_CTL(bfin_read_VR_CTL() | PHYCLKOE);
 
diff -puN drivers/net/bfin_mac.h~blackfin-on-chip-ethernet-mac-controller-driver-update drivers/net/bfin_mac.h
--- a/drivers/net/bfin_mac.h~blackfin-on-chip-ethernet-mac-controller-driver-update
+++ a/drivers/net/bfin_mac.h
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: bfin_mac.h,v 1.8 2006/08/22 10:50:04 magicyang Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
@@ -29,44 +27,44 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-// -----------------------------------------------------------------------
-//                     PHY REGISTER NAMES                               //
-// -----------------------------------------------------------------------
-#define PHYREG_MODECTL          0x0000
-#define PHYREG_MODESTAT         0x0001
-#define PHYREG_PHYID1           0x0002
-#define PHYREG_PHYID2           0x0003
-#define PHYREG_ANAR                     0x0004
-#define PHYREG_ANLPAR           0x0005
-#define PHYREG_ANER                     0x0006
-#define PHYREG_NSR                      0x0010
-#define PHYREG_LBREMR           0x0011
-#define PHYREG_REC                      0x0012
-#define PHYREG_10CFG            0x0013
-#define PHYREG_PHY1_1           0x0014
-#define PHYREG_PHY1_2           0x0015
-#define PHYREG_PHY2                     0x0016
-#define PHYREG_TW_1                     0x0017
-#define PHYREG_TW_2                     0x0018
-#define PHYREG_TEST                     0x0019
-
-#define PHY_RESET               0x8000
-#define PHY_ANEG_EN             0x1000
-#define PHY_DUPLEX              0x0100
-#define PHY_SPD_SET             0x2000
+/*
+ * PHY REGISTER NAMES
+ */
+#define PHYREG_MODECTL		0x0000
+#define PHYREG_MODESTAT		0x0001
+#define PHYREG_PHYID1		0x0002
+#define PHYREG_PHYID2		0x0003
+#define PHYREG_ANAR		0x0004
+#define PHYREG_ANLPAR		0x0005
+#define PHYREG_ANER		0x0006
+#define PHYREG_NSR		0x0010
+#define PHYREG_LBREMR		0x0011
+#define PHYREG_REC		0x0012
+#define PHYREG_10CFG		0x0013
+#define PHYREG_PHY1_1		0x0014
+#define PHYREG_PHY1_2		0x0015
+#define PHYREG_PHY2		0x0016
+#define PHYREG_TW_1		0x0017
+#define PHYREG_TW_2		0x0018
+#define PHYREG_TEST		0x0019
+
+#define PHY_RESET		0x8000
+#define PHY_ANEG_EN		0x1000
+#define PHY_DUPLEX		0x0100
+#define PHY_SPD_SET		0x2000
 
 #define BFIN_MAC_CSUM_OFFLOAD
 
 typedef struct _DMA_CONFIG {
-	unsigned short b_DMA_EN:1;	//Bit 0 : DMA Enable
-	unsigned short b_WNR:1;	//Bit 1 : DMA Direction
-	unsigned short b_WDSIZE:2;	//Bit 2 & 3 : DMA Tranfer Word size
-	unsigned short b_DMA2D:1;	//Bit 4 : DMA Mode 2D or 1D
-	unsigned short b_RESTART:1;	//Bit 5 : Retain the FIFO
-	unsigned short b_DI_SEL:1;	//Bit 6 : Data Interrupt Timing Select
-	unsigned short b_DI_EN:1;	//Bit 7 : Data Interrupt Enable
-	unsigned short b_NDSIZE:4;	//Bit 8 to 11 : Flex descriptor Size
-	unsigned short b_FLOW:3;	//Bit 12 to 14 : FLOW
+	unsigned short b_DMA_EN:1;	/* Bit 0 : DMA Enable */
+	unsigned short b_WNR:1;		/* Bit 1 : DMA Direction */
+	unsigned short b_WDSIZE:2;	/* Bit 2 & 3 : DMA Tranfer Word size */
+	unsigned short b_DMA2D:1;	/* Bit 4 : DMA Mode 2D or 1D */
+	unsigned short b_RESTART:1;	/* Bit 5 : Retain the FIFO */
+	unsigned short b_DI_SEL:1;	/* Bit 6 : Data Interrupt Timing Select */
+	unsigned short b_DI_EN:1;	/* Bit 7 : Data Interrupt Enable */
+	unsigned short b_NDSIZE:4;	/* Bit 8 to 11 : Flex descriptor Size */
+	unsigned short b_FLOW:3;	/* Bit 12 to 14 : FLOW */
 } DMA_CONFIG_REG;
 
 struct dma_descriptor {
@@ -76,23 +74,24 @@ struct dma_descriptor {
 	unsigned short x_count;
 };
 
-/*
+#if 0
 struct status_area {
-  unsigned short ip_hdr_chksum;         // the IP header checksum
-  unsigned short ip_payload_chksum;     // the IP header and payload checksum
-  unsigned long  status_word;           // the frame status word
+  unsigned short ip_hdr_chksum;         /* the IP header checksum */
+  unsigned short ip_payload_chksum;     /* the IP header and payload checksum */
+  unsigned long  status_word;           /* the frame status word */
 };
-*/
+#endif
+
 struct status_area_rx {
 #if defined(BFIN_MAC_CSUM_OFFLOAD)
-	unsigned short ip_hdr_csum;	// ip header checksum
-	unsigned short ip_payload_csum;	// ip payload(udp or tcp or others) checksum
+	unsigned short ip_hdr_csum;	/* ip header checksum */
+	unsigned short ip_payload_csum;	/* ip payload(udp or tcp or others) checksum */
 #endif
-	unsigned long status_word;	// the frame status word
+	unsigned long status_word;	/* the frame status word */
 };
 
 struct status_area_tx {
-	unsigned long status_word;	// the frame status word
+	unsigned long status_word;	/* the frame status word */
 };
 
 /* use two descriptors for a packet */
@@ -124,23 +123,25 @@ struct bf537mac_local {
 
 	int version;
 
-	int FlowEnabled;	// record if data flow is active
-	int EtherIntIVG;	// IVG for the ethernet interrupt
-	int RXIVG;		// IVG for the RX completion
-	int TXIVG;		// IVG for the TX completion
-	int PhyAddr;		// PHY address
-	int OpMode;		// set these bits n the OPMODE regs
-	int Port10;		// set port speed to 10 Mbit/s
-	int GenChksums;		// IP checksums to be calculated
-	int NoRcveLnth;		// dont insert recv length at start of buffer
-	int StripPads;		// remove trailing pad bytes
-	int FullDuplex;		// set full duplex mode
-	int Negotiate;		// enable auto negotiation
-	int Loopback;		// loopback at the PHY
-	int Cache;		// Buffers may be cached
-	int FlowControl;	// flow control active
-	int CLKIN;		// clock in value in MHZ
-	unsigned short IntMask;	// interrupt mask
-	unsigned char Mac[6];	// MAC address of the board
+	int FlowEnabled;	/* record if data flow is active */
+	int EtherIntIVG;	/* IVG for the ethernet interrupt */
+	int RXIVG;		/* IVG for the RX completion */
+	int TXIVG;		/* IVG for the TX completion */
+	int PhyAddr;		/* PHY address */
+	int OpMode;		/* set these bits n the OPMODE regs */
+	int Port10;		/* set port speed to 10 Mbit/s */
+	int GenChksums;		/* IP checksums to be calculated */
+	int NoRcveLnth;		/* dont insert recv length at start of buffer */
+	int StripPads;		/* remove trailing pad bytes */
+	int FullDuplex;		/* set full duplex mode */
+	int Negotiate;		/* enable auto negotiation */
+	int Loopback;		/* loopback at the PHY */
+	int Cache;		/* Buffers may be cached */
+	int FlowControl;	/* flow control active */
+	int CLKIN;		/* clock in value in MHZ */
+	unsigned short IntMask;	/* interrupt mask */
+	unsigned char Mac[6];	/* MAC address of the board */
 	spinlock_t lock;
 };
+
+extern void get_bf537_ether_addr(char *addr);
_

Patches currently in -mm which might be from bryan.wu@analog.com are

blackfin-Documentation.patch
blackfin-arch.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-on-chip-ethernet-mac-controller-driver-update.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
