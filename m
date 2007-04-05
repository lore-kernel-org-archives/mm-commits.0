From: akpm@linux-foundation.org
Subject: - cxgb3-tighten-xgmac-workaround.patch removed from -mm tree
Date: Wed, 04 Apr 2007 19:00:36 -0700
Message-ID: <200704050200.l3520aYk004837@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38054 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451AbXDECAq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 22:00:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: divy@chelsio.com, mm-commits@vger.kernel.org


The patch titled
     cxgb3: tighten xgmac workaround
has been removed from the -mm tree.  Its filename was
     cxgb3-tighten-xgmac-workaround.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cxgb3: tighten xgmac workaround
From: Divy Le Ray <divy@chelsio.com>

Run the watchdog task when the link is up.
Flush the XGMAC Tx FIFO when the link drops.

Also remove a statistics update that should have gone
in the previous modification of xgmac.c.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cxgb3/cxgb3_main.c |   16 +++++++++++++---
 drivers/net/cxgb3/regs.h       |    4 ++++
 drivers/net/cxgb3/xgmac.c      |    1 -
 3 files changed, 17 insertions(+), 4 deletions(-)

diff -puN drivers/net/cxgb3/cxgb3_main.c~cxgb3-tighten-xgmac-workaround drivers/net/cxgb3/cxgb3_main.c
--- a/drivers/net/cxgb3/cxgb3_main.c~cxgb3-tighten-xgmac-workaround
+++ a/drivers/net/cxgb3/cxgb3_main.c
@@ -185,16 +185,26 @@ void t3_os_link_changed(struct adapter *
 			int speed, int duplex, int pause)
 {
 	struct net_device *dev = adapter->port[port_id];
+	struct port_info *pi = netdev_priv(dev);
+	struct cmac *mac = &pi->mac;
 
 	/* Skip changes from disabled ports. */
 	if (!netif_running(dev))
 		return;
 
 	if (link_stat != netif_carrier_ok(dev)) {
-		if (link_stat)
+		if (link_stat) {
+			t3_set_reg_field(adapter,
+					 A_XGM_TXFIFO_CFG + mac->offset,
+					 F_ENDROPPKT, 0);
 			netif_carrier_on(dev);
-		else
+		} else {
 			netif_carrier_off(dev);
+			t3_set_reg_field(adapter,
+					 A_XGM_TXFIFO_CFG + mac->offset,
+					 F_ENDROPPKT, F_ENDROPPKT);
+		}
+
 		link_report(dev);
 	}
 }
@@ -2119,7 +2129,7 @@ static void check_t3b2_mac(struct adapte
 			continue;
 
 		status = 0;
-		if (netif_running(dev))
+		if (netif_running(dev) && netif_carrier_ok(dev))
 			status = t3b2_mac_watchdog_task(&p->mac);
 		if (status == 1)
 			p->mac.stats.num_toggled++;
diff -puN drivers/net/cxgb3/regs.h~cxgb3-tighten-xgmac-workaround drivers/net/cxgb3/regs.h
--- a/drivers/net/cxgb3/regs.h~cxgb3-tighten-xgmac-workaround
+++ a/drivers/net/cxgb3/regs.h
@@ -1940,6 +1940,10 @@
 
 #define V_TXFIFOTHRESH(x) ((x) << S_TXFIFOTHRESH)
 
+#define S_ENDROPPKT    21
+#define V_ENDROPPKT(x) ((x) << S_ENDROPPKT)
+#define F_ENDROPPKT    V_ENDROPPKT(1U)
+
 #define A_XGM_SERDES_CTRL 0x890
 #define A_XGM_SERDES_CTRL0 0x8e0
 
diff -puN drivers/net/cxgb3/xgmac.c~cxgb3-tighten-xgmac-workaround drivers/net/cxgb3/xgmac.c
--- a/drivers/net/cxgb3/xgmac.c~cxgb3-tighten-xgmac-workaround
+++ a/drivers/net/cxgb3/xgmac.c
@@ -471,7 +471,6 @@ const struct mac_stats *t3_mac_update_st
 	RMON_UPDATE(mac, rx_symbol_errs, RX_SYM_CODE_ERR_FRAMES);
 
 	RMON_UPDATE(mac, rx_too_long, RX_OVERSIZE_FRAMES);
-	mac->stats.rx_too_long += RMON_READ(mac, A_XGM_RX_MAX_PKT_SIZE_ERR_CNT);
 
 	v = RMON_READ(mac, A_XGM_RX_MAX_PKT_SIZE_ERR_CNT);
 	if (mac->adapter->params.rev == T3_REV_B2)
_

Patches currently in -mm which might be from divy@chelsio.com are

origin.patch
