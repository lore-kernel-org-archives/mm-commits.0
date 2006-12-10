From: akpm@osdl.org
Subject: + zd1211rw-call-ieee80211_rx-in-tasklet.patch added to -mm tree
Date: Sun, 10 Dec 2006 11:13:12 -0800
Message-ID: <200612101913.kBAJDCE5000443@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51681 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762443AbWLJTOG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 14:14:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kune@deine-taler.de, linville@tuxdriver.com, stable@kernel.org


The patch titled
     zd1211rw: Call ieee80211_rx in tasklet
has been added to the -mm tree.  Its filename is
     zd1211rw-call-ieee80211_rx-in-tasklet.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: zd1211rw: Call ieee80211_rx in tasklet
From: Ulrich Kunitz <kune@deine-taler.de>

The driver called ieee80211_rx in hardware interrupt context.  This has
been against the intention of the ieee80211_rx function.  It caused a bug
in the crypto routines used by WPA.  This patch calls ieee80211_rx in a
tasklet.

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/wireless/zd1211rw/zd_mac.c |   96 ++++++++++++++++-------
 drivers/net/wireless/zd1211rw/zd_mac.h |    5 -
 drivers/net/wireless/zd1211rw/zd_usb.c |    4 
 3 files changed, 76 insertions(+), 29 deletions(-)

diff -puN drivers/net/wireless/zd1211rw/zd_mac.c~zd1211rw-call-ieee80211_rx-in-tasklet drivers/net/wireless/zd1211rw/zd_mac.c
--- a/drivers/net/wireless/zd1211rw/zd_mac.c~zd1211rw-call-ieee80211_rx-in-tasklet
+++ a/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -41,6 +41,8 @@ static void housekeeping_disable(struct 
 
 static void set_multicast_hash_handler(struct work_struct *work);
 
+static void do_rx(unsigned long mac_ptr);
+
 int zd_mac_init(struct zd_mac *mac,
 	        struct net_device *netdev,
 	        struct usb_interface *intf)
@@ -53,6 +55,10 @@ int zd_mac_init(struct zd_mac *mac,
 	INIT_DELAYED_WORK(&mac->set_rts_cts_work, set_rts_cts_work);
 	INIT_DELAYED_WORK(&mac->set_basic_rates_work, set_basic_rates_work);
 
+	skb_queue_head_init(&mac->rx_queue);
+	tasklet_init(&mac->rx_tasklet, do_rx, (unsigned long)mac);
+	tasklet_disable(&mac->rx_tasklet);
+
 	ieee_init(ieee);
 	softmac_init(ieee80211_priv(netdev));
 	zd_chip_init(&mac->chip, netdev, intf);
@@ -140,6 +146,8 @@ out:
 void zd_mac_clear(struct zd_mac *mac)
 {
 	flush_workqueue(zd_workqueue);
+	skb_queue_purge(&mac->rx_queue);
+	tasklet_kill(&mac->rx_tasklet);
 	zd_chip_clear(&mac->chip);
 	ZD_ASSERT(!spin_is_locked(&mac->lock));
 	ZD_MEMCLEAR(mac, sizeof(struct zd_mac));
@@ -168,6 +176,8 @@ int zd_mac_open(struct net_device *netde
 	struct zd_chip *chip = &mac->chip;
 	int r;
 
+	tasklet_enable(&mac->rx_tasklet);
+
 	r = zd_chip_enable_int(chip);
 	if (r < 0)
 		goto out;
@@ -218,6 +228,8 @@ int zd_mac_stop(struct net_device *netde
 	 */
 
 	zd_chip_disable_rx(chip);
+	skb_queue_purge(&mac->rx_queue);
+	tasklet_disable(&mac->rx_tasklet);
 	housekeeping_disable(mac);
 	ieee80211softmac_stop(netdev);
 
@@ -470,13 +482,13 @@ static void bssinfo_change(struct net_de
 
 	if (changes & IEEE80211SOFTMAC_BSSINFOCHG_RATES) {
 		/* Set RTS rate to highest available basic rate */
-		u8 rate = ieee80211softmac_highest_supported_rate(softmac,
+		u8 hi_rate = ieee80211softmac_highest_supported_rate(softmac,
 			&bssinfo->supported_rates, 1);
-		rate = rate_to_zd_rate(rate);
+		hi_rate = rate_to_zd_rate(hi_rate);
 
 		spin_lock_irqsave(&mac->lock, flags);
-		if (rate != mac->rts_rate) {
-			mac->rts_rate = rate;
+		if (hi_rate != mac->rts_rate) {
+			mac->rts_rate = hi_rate;
 			need_set_rts_cts = 1;
 		}
 		spin_unlock_irqrestore(&mac->lock, flags);
@@ -1072,43 +1084,75 @@ static int fill_rx_stats(struct ieee8021
 	return 0;
 }
 
-int zd_mac_rx(struct zd_mac *mac, const u8 *buffer, unsigned int length)
+static void zd_mac_rx(struct zd_mac *mac, struct sk_buff *skb)
 {
 	int r;
 	struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
 	struct ieee80211_rx_stats stats;
 	const struct rx_status *status;
-	struct sk_buff *skb;
 
-	if (length < ZD_PLCP_HEADER_SIZE + IEEE80211_1ADDR_LEN +
-	             IEEE80211_FCS_LEN + sizeof(struct rx_status))
-		return -EINVAL;
+	if (skb->len < ZD_PLCP_HEADER_SIZE + IEEE80211_1ADDR_LEN +
+	               IEEE80211_FCS_LEN + sizeof(struct rx_status))
+	{
+		dev_dbg_f(zd_mac_dev(mac), "Packet with length %u to small.\n",
+			 skb->len);
+		goto free_skb;
+	}
 
-	r = fill_rx_stats(&stats, &status, mac, buffer, length);
-	if (r)
-		return r;
+	r = fill_rx_stats(&stats, &status, mac, skb->data, skb->len);
+	if (r) {
+		/* Only packets with rx errors are included here. */
+		goto free_skb;
+	}
 
-	length -= ZD_PLCP_HEADER_SIZE+IEEE80211_FCS_LEN+
-		  sizeof(struct rx_status);
-	buffer += ZD_PLCP_HEADER_SIZE;
+	__skb_pull(skb, ZD_PLCP_HEADER_SIZE);
+	__skb_trim(skb, skb->len -
+		        (IEEE80211_FCS_LEN + sizeof(struct rx_status)));
 
-	update_qual_rssi(mac, buffer, length, stats.signal, stats.rssi);
+	update_qual_rssi(mac, skb->data, skb->len, stats.signal,
+		         status->signal_strength);
 
-	r = filter_rx(ieee, buffer, length, &stats);
-	if (r <= 0)
-		return r;
+	r = filter_rx(ieee, skb->data, skb->len, &stats);
+	if (r <= 0) {
+		if (r < 0)
+			dev_dbg_f(zd_mac_dev(mac), "Error in packet.\n");
+		goto free_skb;
+	}
 
-	skb = dev_alloc_skb(sizeof(struct zd_rt_hdr) + length);
-	if (!skb)
-		return -ENOMEM;
 	if (ieee->iw_mode == IW_MODE_MONITOR)
-		fill_rt_header(skb_put(skb, sizeof(struct zd_rt_hdr)), mac,
+		fill_rt_header(skb_push(skb, sizeof(struct zd_rt_hdr)), mac,
 			       &stats, status);
-	memcpy(skb_put(skb, length), buffer, length);
 
 	r = ieee80211_rx(ieee, skb, &stats);
-	if (!r)
-		dev_kfree_skb_any(skb);
+	if (r)
+		return;
+free_skb:
+	/* We are always in a soft irq. */
+	dev_kfree_skb(skb);
+}
+
+static void do_rx(unsigned long mac_ptr)
+{
+	struct zd_mac *mac = (struct zd_mac *)mac_ptr;
+	struct sk_buff *skb;
+
+	while ((skb = skb_dequeue(&mac->rx_queue)) != NULL)
+		zd_mac_rx(mac, skb);
+}
+
+int zd_mac_rx_irq(struct zd_mac *mac, const u8 *buffer, unsigned int length)
+{
+	struct sk_buff *skb;
+
+	skb = dev_alloc_skb(sizeof(struct zd_rt_hdr) + length);
+	if (!skb) {
+		dev_warn(zd_mac_dev(mac), "Could not allocate skb.\n");
+		return -ENOMEM;
+	}
+	skb_reserve(skb, sizeof(struct zd_rt_hdr));
+	memcpy(__skb_put(skb, length), buffer, length);
+	skb_queue_tail(&mac->rx_queue, skb);
+	tasklet_schedule(&mac->rx_tasklet);
 	return 0;
 }
 
diff -puN drivers/net/wireless/zd1211rw/zd_mac.h~zd1211rw-call-ieee80211_rx-in-tasklet drivers/net/wireless/zd1211rw/zd_mac.h
--- a/drivers/net/wireless/zd1211rw/zd_mac.h~zd1211rw-call-ieee80211_rx-in-tasklet
+++ a/drivers/net/wireless/zd1211rw/zd_mac.h
@@ -138,6 +138,9 @@ struct zd_mac {
 	struct delayed_work set_rts_cts_work;
 	struct delayed_work set_basic_rates_work;
 
+	struct tasklet_struct rx_tasklet;
+	struct sk_buff_head rx_queue;
+
 	unsigned int stats_count;
 	u8 qual_buffer[ZD_MAC_STATS_BUFFER_SIZE];
 	u8 rssi_buffer[ZD_MAC_STATS_BUFFER_SIZE];
@@ -193,7 +196,7 @@ int zd_mac_stop(struct net_device *netde
 int zd_mac_set_mac_address(struct net_device *dev, void *p);
 void zd_mac_set_multicast_list(struct net_device *netdev);
 
-int zd_mac_rx(struct zd_mac *mac, const u8 *buffer, unsigned int length);
+int zd_mac_rx_irq(struct zd_mac *mac, const u8 *buffer, unsigned int length);
 
 int zd_mac_set_regdomain(struct zd_mac *zd_mac, u8 regdomain);
 u8 zd_mac_get_regdomain(struct zd_mac *zd_mac);
diff -puN drivers/net/wireless/zd1211rw/zd_usb.c~zd1211rw-call-ieee80211_rx-in-tasklet drivers/net/wireless/zd1211rw/zd_usb.c
--- a/drivers/net/wireless/zd1211rw/zd_usb.c~zd1211rw-call-ieee80211_rx-in-tasklet
+++ a/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -598,13 +598,13 @@ static void handle_rx_packet(struct zd_u
 			n = l+k;
 			if (n > length)
 				return;
-			zd_mac_rx(mac, buffer+l, k);
+			zd_mac_rx_irq(mac, buffer+l, k);
 			if (i >= 2)
 				return;
 			l = (n+3) & ~3;
 		}
 	} else {
-		zd_mac_rx(mac, buffer, length);
+		zd_mac_rx_irq(mac, buffer, length);
 	}
 }
 
_

Patches currently in -mm which might be from kune@deine-taler.de are

origin.patch
ieee80211softmac-fix-errors-related-to-the-work_struct-changes.patch
zd1211rw-call-ieee80211_rx-in-tasklet.patch

