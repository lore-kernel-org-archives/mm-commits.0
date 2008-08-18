From: akpm@linux-foundation.org
Subject: - p54-fix-regression-due-to-commit-b19fa1f.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:41:17 -0700
Message-ID: <200808181941.m7IJfHv9008537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754848AbYHRTuY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:50:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chunkeey@web.de, Larry.Finger@lwfinger.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     p54: fix regression due to commit b19fa1f
has been removed from the -mm tree.  Its filename was
     p54-fix-regression-due-to-commit-b19fa1f.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: p54: fix regression due to commit b19fa1f
From: Christian Lamparter <chunkeey@web.de>

This patch fixes the regression due to commit b19fa1f.  In addition, the
old logic always tx'ed cts frames (if enabled) with a short preamble when
[rate > 3].  (i.e.  with any 802.11g rate).  Of course this isn't that
bad, but it's still wrong!

Signed-off-by: Christian Lamparter <chunkeey@web.de>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/p54/p54common.c |   30 ++++++++++++-------------
 drivers/net/wireless/p54/p54common.h |   18 +++++++--------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff -puN drivers/net/wireless/p54/p54common.c~p54-fix-regression-due-to-commit-b19fa1f drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c~p54-fix-regression-due-to-commit-b19fa1f
+++ a/drivers/net/wireless/p54/p54common.c
@@ -413,12 +413,12 @@ static void p54_rx_frame_sent(struct iee
 			last_addr = range->end_addr;
 			__skb_unlink(entry, &priv->tx_queue);
 			memset(&info->status, 0, sizeof(info->status));
-			priv->tx_stats[skb_get_queue_mapping(skb)].len--;
 			entry_hdr = (struct p54_control_hdr *) entry->data;
 			entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
 			if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) != 0)
 				pad = entry_data->align[0];
 
+			priv->tx_stats[entry_data->hw_queue - 4].len--;
 			if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
 				if (!(payload->status & 0x01))
 					info->flags |= IEEE80211_TX_STAT_ACK;
@@ -557,6 +557,7 @@ static int p54_tx(struct ieee80211_hw *d
 	struct p54_tx_control_allocdata *txhdr;
 	size_t padding, len;
 	u8 rate;
+	u8 cts_rate = 0x20;
 
 	current_queue = &priv->tx_stats[skb_get_queue_mapping(skb)];
 	if (unlikely(current_queue->len > current_queue->limit))
@@ -581,28 +582,27 @@ static int p54_tx(struct ieee80211_hw *d
 	hdr->type = (info->flags & IEEE80211_TX_CTL_NO_ACK) ? 0 : cpu_to_le16(1);
 	hdr->retry1 = hdr->retry2 = info->control.retry_limit;
 
-	memset(txhdr->wep_key, 0x0, 16);
-	txhdr->padding = 0;
-	txhdr->padding2 = 0;
-
 	/* TODO: add support for alternate retry TX rates */
 	rate = ieee80211_get_tx_rate(dev, info)->hw_value;
-	if (info->flags & IEEE80211_TX_CTL_SHORT_PREAMBLE)
+	if (info->flags & IEEE80211_TX_CTL_SHORT_PREAMBLE) {
 		rate |= 0x10;
-	if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS)
+		cts_rate |= 0x10;
+	} if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) {
 		rate |= 0x40;
-	else if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)
+		cts_rate |= ieee80211_get_rts_cts_rate(dev, info)->hw_value;
+	} else if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT) {
 		rate |= 0x20;
+		cts_rate |= ieee80211_get_rts_cts_rate(dev, info)->hw_value;
+	}
 	memset(txhdr->rateset, rate, 8);
-	txhdr->wep_key_present = 0;
-	txhdr->wep_key_len = 0;
-	txhdr->frame_type = cpu_to_le32(skb_get_queue_mapping(skb) + 4);
-	txhdr->magic4 = 0;
-	txhdr->antenna = (info->antenna_sel_tx == 0) ?
+	txhdr->key_type = 0;
+	txhdr->key_len = 0;
+	txhdr->hw_queue = skb_get_queue_mapping(skb) + 4;
+	txhdr->tx_antenna = (info->antenna_sel_tx == 0) ?
 		2 : info->antenna_sel_tx - 1;
 	txhdr->output_power = 0x7f; // HW Maximum
-	txhdr->magic5 = (info->flags & IEEE80211_TX_CTL_NO_ACK) ?
-		0 : ((rate > 0x3) ? cpu_to_le32(0x33) : cpu_to_le32(0x23));
+	txhdr->cts_rate = (info->flags & IEEE80211_TX_CTL_NO_ACK) ?
+			  0 : cts_rate;
 	if (padding)
 		txhdr->align[0] = padding;
 
diff -puN drivers/net/wireless/p54/p54common.h~p54-fix-regression-due-to-commit-b19fa1f drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h~p54-fix-regression-due-to-commit-b19fa1f
+++ a/drivers/net/wireless/p54/p54common.h
@@ -183,16 +183,16 @@ struct p54_frame_sent_hdr {
 
 struct p54_tx_control_allocdata {
 	u8 rateset[8];
-	u16 padding;
-	u8 wep_key_present;
-	u8 wep_key_len;
-	u8 wep_key[16];
-	__le32 frame_type;
-	u32 padding2;
-	__le16 magic4;
-	u8 antenna;
+	u8 unalloc0[2];
+	u8 key_type;
+	u8 key_len;
+	u8 key[16];
+	u8 hw_queue;
+	u8 unalloc1[9];
+	u8 tx_antenna;
 	u8 output_power;
-	__le32 magic5;
+	u8 cts_rate;
+	u8 unalloc2[3];
 	u8 align[0];
 } __attribute__ ((packed));
 
_

Patches currently in -mm which might be from chunkeey@web.de are

linux-next.patch

