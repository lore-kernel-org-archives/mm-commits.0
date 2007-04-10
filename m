From: akpm@linux-foundation.org
Subject: + cxgb3-mac-watchdog-update.patch added to -mm tree
Date: Tue, 10 Apr 2007 14:41:06 -0700
Message-ID: <200704102141.l3ALf6Ev018193@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46996 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbXDJVlQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 17:41:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: divy@chelsio.com


The patch titled
     cxgb3: MAC watchdog update
has been added to the -mm tree.  Its filename is
     cxgb3-mac-watchdog-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cxgb3: MAC watchdog update
From: Divy Le Ray <divy@chelsio.com>

The MAC watchdog was failing if the peer interface was brought down.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cxgb3/common.h     |    7 +-
 drivers/net/cxgb3/cxgb3_main.c |   10 +-
 drivers/net/cxgb3/xgmac.c      |  105 +++++++++++++++++++++++--------
 3 files changed, 88 insertions(+), 34 deletions(-)

diff -puN drivers/net/cxgb3/common.h~cxgb3-mac-watchdog-update drivers/net/cxgb3/common.h
--- a/drivers/net/cxgb3/common.h~cxgb3-mac-watchdog-update
+++ a/drivers/net/cxgb3/common.h
@@ -478,8 +478,11 @@ struct cmac {
 	struct adapter *adapter;
 	unsigned int offset;
 	unsigned int nucast;	/* # of address filters for unicast MACs */
-	unsigned int tcnt;
-	unsigned int xcnt;
+	unsigned int tx_tcnt;
+	unsigned int tx_xcnt;
+	u64 tx_mcnt;
+	unsigned int rx_xcnt;
+	u64 rx_mcnt;
 	unsigned int toggle_cnt;
 	unsigned int txen;
 	struct mac_stats stats;
diff -puN drivers/net/cxgb3/cxgb3_main.c~cxgb3-mac-watchdog-update drivers/net/cxgb3/cxgb3_main.c
--- a/drivers/net/cxgb3/cxgb3_main.c~cxgb3-mac-watchdog-update
+++ a/drivers/net/cxgb3/cxgb3_main.c
@@ -194,15 +194,13 @@ void t3_os_link_changed(struct adapter *
 
 	if (link_stat != netif_carrier_ok(dev)) {
 		if (link_stat) {
-			t3_set_reg_field(adapter,
-					 A_XGM_TXFIFO_CFG + mac->offset,
-					 F_ENDROPPKT, 0);
+			t3_mac_enable(mac, MAC_DIRECTION_RX);
 			netif_carrier_on(dev);
 		} else {
 			netif_carrier_off(dev);
-			t3_set_reg_field(adapter,
-					 A_XGM_TXFIFO_CFG + mac->offset,
-					 F_ENDROPPKT, F_ENDROPPKT);
+			pi->phy.ops->power_down(&pi->phy, 1);
+			t3_mac_disable(mac, MAC_DIRECTION_RX);
+			t3_link_start(&pi->phy, mac, &pi->link_config);
 		}
 
 		link_report(dev);
diff -puN drivers/net/cxgb3/xgmac.c~cxgb3-mac-watchdog-update drivers/net/cxgb3/xgmac.c
--- a/drivers/net/cxgb3/xgmac.c~cxgb3-mac-watchdog-update
+++ a/drivers/net/cxgb3/xgmac.c
@@ -367,6 +367,7 @@ int t3_mac_enable(struct cmac *mac, int 
 	int idx = macidx(mac);
 	struct adapter *adap = mac->adapter;
 	unsigned int oft = mac->offset;
+	struct mac_stats *s = &mac->stats;
 
 	if (which & MAC_DIRECTION_TX) {
 		t3_write_reg(adap, A_XGM_TX_CTRL + oft, F_TXEN);
@@ -376,10 +377,16 @@ int t3_mac_enable(struct cmac *mac, int 
 		t3_set_reg_field(adap, A_TP_PIO_DATA, 1 << idx, 1 << idx);
 
 		t3_write_reg(adap, A_TP_PIO_ADDR, A_TP_TX_DROP_CNT_CH0 + idx);
-		mac->tcnt = (G_TXDROPCNTCH0RCVD(t3_read_reg(adap,
-							    A_TP_PIO_DATA)));
-		mac->xcnt = (G_TXSPI4SOPCNT(t3_read_reg(adap,
-						A_XGM_TX_SPI4_SOP_EOP_CNT)));
+		mac->tx_mcnt = s->tx_frames;
+		mac->tx_tcnt = (G_TXDROPCNTCH0RCVD(t3_read_reg(adap,
+							A_TP_PIO_DATA)));
+		mac->tx_xcnt = (G_TXSPI4SOPCNT(t3_read_reg(adap,
+						A_XGM_TX_SPI4_SOP_EOP_CNT +
+						oft)));
+		mac->rx_mcnt = s->rx_frames;
+		mac->rx_xcnt = (G_TXSPI4SOPCNT(t3_read_reg(adap,
+						A_XGM_RX_SPI4_SOP_EOP_CNT +
+						oft)));
 		mac->txen = F_TXEN;
 		mac->toggle_cnt = 0;
 	}
@@ -392,6 +399,7 @@ int t3_mac_disable(struct cmac *mac, int
 {
 	int idx = macidx(mac);
 	struct adapter *adap = mac->adapter;
+	int val;
 
 	if (which & MAC_DIRECTION_TX) {
 		t3_write_reg(adap, A_XGM_TX_CTRL + mac->offset, 0);
@@ -401,44 +409,89 @@ int t3_mac_disable(struct cmac *mac, int
 		t3_set_reg_field(adap, A_TP_PIO_DATA, 1 << idx, 1 << idx);
 		mac->txen = 0;
 	}
-	if (which & MAC_DIRECTION_RX)
+	if (which & MAC_DIRECTION_RX) {
+		t3_set_reg_field(mac->adapter, A_XGM_RESET_CTRL + mac->offset,
+				 F_PCS_RESET_, 0);
+		msleep(100);
 		t3_write_reg(adap, A_XGM_RX_CTRL + mac->offset, 0);
+		val = F_MAC_RESET_;
+		if (is_10G(adap))
+			val |= F_PCS_RESET_;
+		else if (uses_xaui(adap))
+			val |= F_PCS_RESET_ | F_XG2G_RESET_;
+		else
+			val |= F_RGMII_RESET_ | F_XG2G_RESET_;
+		t3_write_reg(mac->adapter, A_XGM_RESET_CTRL + mac->offset, val);
+	}
 	return 0;
 }
 
 int t3b2_mac_watchdog_task(struct cmac *mac)
 {
 	struct adapter *adap = mac->adapter;
-	unsigned int tcnt, xcnt;
+	struct mac_stats *s = &mac->stats;
+	unsigned int tx_tcnt, tx_xcnt;
+	unsigned int tx_mcnt = s->tx_frames;
+	unsigned int rx_mcnt = s->rx_frames;
+	unsigned int rx_xcnt;
 	int status;
 
-	t3_write_reg(adap, A_TP_PIO_ADDR, A_TP_TX_DROP_CNT_CH0 + macidx(mac));
-	tcnt = (G_TXDROPCNTCH0RCVD(t3_read_reg(adap, A_TP_PIO_DATA)));
-	xcnt = (G_TXSPI4SOPCNT(t3_read_reg(adap, 
-					   A_XGM_TX_SPI4_SOP_EOP_CNT +
-					   mac->offset)));
-
-	if (tcnt != mac->tcnt && xcnt == 0 && mac->xcnt == 0) {
-		if (mac->toggle_cnt > 4) {
-			t3b2_mac_reset(mac);
+	if (tx_mcnt == mac->tx_mcnt) {
+		tx_xcnt = (G_TXSPI4SOPCNT(t3_read_reg(adap,
+						A_XGM_TX_SPI4_SOP_EOP_CNT +
+					       	mac->offset)));
+		if (tx_xcnt == 0) {
+			t3_write_reg(adap, A_TP_PIO_ADDR,
+				     A_TP_TX_DROP_CNT_CH0 + macidx(mac));
+			tx_tcnt = (G_TXDROPCNTCH0RCVD(t3_read_reg(adap,
+						      A_TP_PIO_DATA)));
+		} else {
 			mac->toggle_cnt = 0;
+			return 0;
+		}
+	} else {
+		mac->toggle_cnt = 0;
+		return 0;
+	}
+
+	if (((tx_tcnt != mac->tx_tcnt) &&
+	     (tx_xcnt == 0) && (mac->tx_xcnt == 0)) ||
+	    ((mac->tx_mcnt == tx_mcnt) &&
+	     (tx_xcnt != 0) && (mac->tx_xcnt != 0))) {
+		if (mac->toggle_cnt > 4)
 			status = 2;
-		} else {
-			t3_write_reg(adap, A_XGM_TX_CTRL + mac->offset, 0);
-			t3_read_reg(adap, A_XGM_TX_CTRL + mac->offset);
-			t3_write_reg(adap, A_XGM_TX_CTRL + mac->offset,
-				     mac->txen);
-			t3_read_reg(adap, A_XGM_TX_CTRL + mac->offset);
-			mac->toggle_cnt++;
+		else
 			status = 1;
-		}	
 	} else {
 		mac->toggle_cnt = 0;
-		status = 0;
+		return 0;
 	}
-	mac->tcnt = tcnt;
-	mac->xcnt = xcnt;
 
+	if (rx_mcnt != mac->rx_mcnt)
+		rx_xcnt = (G_TXSPI4SOPCNT(t3_read_reg(adap,
+						A_XGM_RX_SPI4_SOP_EOP_CNT +
+						mac->offset)));
+	else
+		return 0;
+
+	if (mac->rx_mcnt != s->rx_frames && rx_xcnt == 0 && mac->rx_xcnt == 0)
+		status = 2;
+
+	mac->tx_tcnt = tx_tcnt;
+	mac->tx_xcnt = tx_xcnt;
+	mac->tx_mcnt = s->tx_frames;
+	mac->rx_xcnt = rx_xcnt;
+	mac->rx_mcnt = s->rx_frames;
+	if (status == 1) {
+		t3_write_reg(adap, A_XGM_TX_CTRL + mac->offset, 0);
+		t3_read_reg(adap, A_XGM_TX_CTRL + mac->offset);  /* flush */
+		t3_write_reg(adap, A_XGM_TX_CTRL + mac->offset, mac->txen);
+		t3_read_reg(adap, A_XGM_TX_CTRL + mac->offset);  /* flush */
+		mac->toggle_cnt++;
+	} else if (status == 2) {
+		t3b2_mac_reset(mac);
+		mac->toggle_cnt = 0;
+	}
 	return status;
 }
 
_

Patches currently in -mm which might be from divy@chelsio.com are

cxgb3-avoid-deadlock-with-mac-watchdog.patch
cxgb3-mac-watchdog-update.patch
cxgb3-missing-cpl-handler-and-register-setting.patch
