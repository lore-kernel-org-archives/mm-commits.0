From: akpm@linux-foundation.org
Subject: - sky2-hardware-receive-timestamp-counter.patch removed from -mm tree
Date: Thu, 06 Sep 2007 17:03:00 -0700
Message-ID: <200709070003.l87030s3014709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34794 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932483AbXIGADD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2007 20:03:03 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l87031Me024665
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 6 Sep 2007 17:03:02 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     sky2: hardware receive timestamp counter
has been removed from the -mm tree.  Its filename was
     sky2-hardware-receive-timestamp-counter.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: sky2: hardware receive timestamp counter
From: Stephen Hemminger <shemminger@linux-foundation.org>

Use hardware timestamp counter to stamp receive packets.  It allows for higher
resolution values without the hardware overhead of doing gettimeofday.

Even though the network stack is smart enough to not stamp packets unless
needed, any installation with dhcpd ends up using af_packet and that turns on
timestamping by default.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sky2.c |   63 ++++++++++++++++++++++++++++++++++++++++---
 drivers/net/sky2.h |    9 ++++--
 2 files changed, 66 insertions(+), 6 deletions(-)

diff -puN drivers/net/sky2.c~sky2-hardware-receive-timestamp-counter drivers/net/sky2.c
--- a/drivers/net/sky2.c~sky2-hardware-receive-timestamp-counter
+++ a/drivers/net/sky2.c
@@ -26,6 +26,7 @@
 #include <linux/kernel.h>
 #include <linux/version.h>
 #include <linux/module.h>
+#include <linux/reciprocal_div.h>
 #include <linux/netdevice.h>
 #include <linux/dma-mapping.h>
 #include <linux/etherdevice.h>
@@ -2186,6 +2187,36 @@ error:
 	goto resubmit;
 }
 
+static inline u32 sky2_tist2ns(const struct sky2_hw *hw, u32 clk)
+{
+	return reciprocal_divide(clk * 1000, hw->tist_rate);
+}
+
+/*
+ * Convert hardware timestamp clock into a real time value
+ */
+static void sky2_set_timestamp(struct sk_buff *skb,
+			       const struct sky2_hw *hw, u32 stamp)
+{
+	unsigned long seq;
+
+	do {
+		s32 delta;
+
+		seq = read_seqbegin(&hw->tist_lock);
+
+		/* ticks since last synchronization */
+		delta = stamp - hw->tist_base;
+
+		if (delta > 0)
+			skb->tstamp = ktime_add_ns(hw->tist_real,
+						   sky2_tist2ns(hw, delta));
+		else
+			skb->tstamp = ktime_sub_ns(hw->tist_real,
+						   sky2_tist2ns(hw, -delta));
+	} while (read_seqretry(&hw->tist_lock, seq));
+}
+
 /* Transmit complete */
 static inline void sky2_tx_done(struct net_device *dev, u16 last)
 {
@@ -2262,6 +2293,16 @@ static int sky2_status_intr(struct sky2_
 			break;
 
 #ifdef SKY2_VLAN_TAG_USED
+		case OP_RXTIMEVLAN:
+			sky2->rx_tag = length;
+			/* fall through */
+#endif
+		case OP_RXTIMESTAMP:
+			skb = sky2->rx_ring[sky2->rx_next].skb;
+			sky2_set_timestamp(skb, hw, status);
+			break;
+
+#ifdef SKY2_VLAN_TAG_USED
 		case OP_RXVLAN:
 			sky2->rx_tag = length;
 			break;
@@ -2457,11 +2498,15 @@ static void sky2_le_error(struct sky2_hw
 	sky2_write32(hw, Q_ADDR(q, Q_CSR), BMU_CLR_IRQ_CHK);
 }
 
-/* Check for lost IRQ once a second */
+/* Once a second timer for safety checking and polling for timestamp
+ *
+ * Note: receive and timer processing both happen under softirq
+ */
 static void sky2_watchdog(unsigned long arg)
 {
 	struct sky2_hw *hw = (struct sky2_hw *) arg;
 
+	/* Look for lost IRQ */
 	if (sky2_read32(hw, B0_ISRC)) {
 		struct net_device *dev = hw->dev[0];
 
@@ -2469,6 +2514,14 @@ static void sky2_watchdog(unsigned long 
 			__netif_rx_schedule(dev);
 	}
 
+	/* Snapshot current system realtime at current timestamp value
+	 * @ 150Mhz counter wraps in 28.6 secs
+	 */
+	write_seqlock(&hw->tist_lock);
+	hw->tist_real = ktime_get_real();
+	hw->tist_base = sky2_read32(hw, GMAC_TI_ST_VAL);
+	write_sequnlock(&hw->tist_lock);
+
 	if (hw->active > 0)
 		mod_timer(&hw->watchdog_timer, round_jiffies(jiffies + HZ));
 }
@@ -2707,9 +2760,8 @@ static void sky2_reset(struct sky2_hw *h
 	/* Turn off descriptor polling */
 	sky2_write32(hw, B28_DPT_CTRL, DPT_STOP);
 
-	/* Turn off receive timestamp */
-	sky2_write8(hw, GMAC_TI_ST_CTRL, GMT_ST_STOP);
-	sky2_write8(hw, GMAC_TI_ST_CTRL, GMT_ST_CLR_IRQ);
+	/* Turn on receive timestamp */
+	sky2_write8(hw, GMAC_TI_ST_CTRL, GMT_ST_CLR_IRQ|GMT_ST_START);
 
 	/* enable the Tx Arbiters */
 	for (i = 0; i < hw->ports; i++)
@@ -4061,6 +4113,9 @@ static int __devinit sky2_probe(struct p
 			sky2_show_addr(dev1);
 	}
 
+	seqlock_init(&hw->tist_lock);
+	hw->tist_rate = reciprocal_value(sky2_mhz(hw));
+
 	setup_timer(&hw->watchdog_timer, sky2_watchdog, (unsigned long) hw);
 	INIT_WORK(&hw->restart_work, sky2_restart);
 
diff -puN drivers/net/sky2.h~sky2-hardware-receive-timestamp-counter drivers/net/sky2.h
--- a/drivers/net/sky2.h~sky2-hardware-receive-timestamp-counter
+++ a/drivers/net/sky2.h
@@ -352,7 +352,7 @@ enum {
 
 /* Hardware error interrupt mask for Yukon 2 */
 enum {
-	Y2_IS_TIST_OV	= 1<<29,/* Time Stamp Timer overflow interrupt */
+	Y2_IS_TIST_OV	= 1<<29, /* Time Stamp Timer overflow interrupt */
 	Y2_IS_SENSOR	= 1<<28, /* Sensor interrupt */
 	Y2_IS_MST_ERR	= 1<<27, /* Master error interrupt */
 	Y2_IS_IRQ_STAT	= 1<<26, /* Status exception interrupt */
@@ -378,7 +378,7 @@ enum {
 	Y2_HWE_L2_MASK	= Y2_IS_PAR_RD2 | Y2_IS_PAR_WR2 | Y2_IS_PAR_MAC2 |
 			  Y2_IS_PAR_RX2 | Y2_IS_TCP_TXS2| Y2_IS_TCP_TXA2,
 
-	Y2_HWE_ALL_MASK	= Y2_IS_TIST_OV | Y2_IS_MST_ERR | Y2_IS_IRQ_STAT |
+	Y2_HWE_ALL_MASK	= Y2_IS_MST_ERR | Y2_IS_IRQ_STAT |
 			  Y2_HWE_L1_MASK | Y2_HWE_L2_MASK,
 };
 
@@ -2032,6 +2032,11 @@ struct sky2_hw {
 	u8		     ports;
 	u8		     active;
 
+	seqlock_t	     tist_lock;
+	ktime_t		     tist_real;
+	u32		     tist_base;
+	u32		     tist_rate;
+
 	struct sky2_status_le *st_le;
 	u32		     st_idx;
 	dma_addr_t   	     st_dma;
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

pci-x-pci-express-read-control-interfaces-mthca.patch
git-netdev-all.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
sky2-use-net_device-internal-stats.patch
ktime_sub_ns-analog-of-ktime_add_ns.patch
export-reciprocal_value-for-modules.patch
sky2-hardware-receive-timestamp-counter.patch
sky2-avoid-divide-in-receive-path.patch
sky2-118.patch
git-net.patch
i386-optimize-memset-of-6-and-8-bytes.patch
