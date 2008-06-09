From: akpm@linux-foundation.org
Subject: + iwlwifi-remove-iwl4965_ht-config.patch added to -mm tree
Date: Mon, 09 Jun 2008 15:14:33 -0700
Message-ID: <200806092214.m59MEXVC010999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752245AbYFIWPd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 18:15:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ron.rindjunsky@intel.com, johannes@sipsolutions.net, linville@tuxdriver.com, tomas.winkler@intel.com, yi.zhu@intel.com


The patch titled
     iwlwifi: remove IWL4965_HT config
has been added to the -mm tree.  Its filename is
     iwlwifi-remove-iwl4965_ht-config.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iwlwifi: remove IWL4965_HT config
From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch removes CONFIG_IWL4965_HT #ifdefs for iwl 4965 and 5000.  11n
feature is stable in those drivers and its mode of operation is determined
in mac80211, so this dependency is not needed any more.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: <linville@tuxdriver.com>
Cc: <johannes@sipsolutions.net>
Cc: <tomas.winkler@intel.com>
Cc: <yi.zhu@intel.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwlwifi/Kconfig        |    8 --
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |   46 -------------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   60 ++++++------------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   44 ++++++-------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   18 -----
 drivers/net/wireless/iwlwifi/iwl-core.h     |    4 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    4 -
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   14 ----
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   10 ---
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   10 ---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   23 ------
 11 files changed, 42 insertions(+), 199 deletions(-)

diff -puN drivers/net/wireless/iwlwifi/Kconfig~iwlwifi-remove-iwl4965_ht-config drivers/net/wireless/iwlwifi/Kconfig
--- a/drivers/net/wireless/iwlwifi/Kconfig~iwlwifi-remove-iwl4965_ht-config
+++ a/drivers/net/wireless/iwlwifi/Kconfig
@@ -54,14 +54,6 @@ config IWL4965
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
 	  module will be called iwl4965.ko.
 
-config IWL4965_HT
-	bool "Enable 802.11n HT features in iwl4965 driver"
-	depends on EXPERIMENTAL
-	depends on IWL4965
-	---help---
-	  This option enables IEEE 802.11n High Throughput features
-	  for the iwl4965 driver.
-
 config IWL4965_LEDS
 	bool "Enable LEDS features in iwl4965 driver"
 	depends on IWL4965
diff -puN drivers/net/wireless/iwlwifi/iwl-4965-rs.c~iwlwifi-remove-iwl4965_ht-config drivers/net/wireless/iwlwifi/iwl-4965-rs.c
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c~iwlwifi-remove-iwl4965_ht-config
+++ a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -105,8 +105,6 @@ struct iwl4965_scale_tbl_info {
 	struct iwl4965_rate_scale_data win[IWL_RATE_COUNT]; /* rate histories */
 };
 
-#ifdef CONFIG_IWL4965_HT
-
 struct iwl4965_traffic_load {
 	unsigned long time_stamp;	/* age of the oldest statistics */
 	u32 packet_count[TID_QUEUE_MAX_SIZE];   /* packet count in this time
@@ -118,8 +116,6 @@ struct iwl4965_traffic_load {
 	u8 head;			/* start of the circular buffer */
 };
 
-#endif /* CONFIG_IWL4965_HT */
-
 /**
  * struct iwl4965_lq_sta -- driver's rate scaling private structure
  *
@@ -157,16 +153,12 @@ struct iwl4965_lq_sta {
 
 	struct iwl_link_quality_cmd lq;
 	struct iwl4965_scale_tbl_info lq_info[LQ_SIZE]; /* "active", "search" */
-#ifdef CONFIG_IWL4965_HT
 	struct iwl4965_traffic_load load[TID_MAX_LOAD_COUNT];
 	u8 tx_agg_tid_en;
-#endif
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct dentry *rs_sta_dbgfs_scale_table_file;
 	struct dentry *rs_sta_dbgfs_stats_table_file;
-#ifdef CONFIG_IWL4965_HT
 	struct dentry *rs_sta_dbgfs_tx_agg_tid_en_file;
-#endif
 	u32 dbg_fixed_rate;
 #endif
 	struct iwl_priv *drv;
@@ -256,7 +248,6 @@ static inline u8 rs_is_valid_ant(u8 vali
 	return ((ant_type & valid_antenna) == ant_type);
 }
 
-#ifdef CONFIG_IWL4965_HT
 /*
  *	removes the old data from the statistics. All data that is older than
  *	TID_MAX_TIME_DIFF, will be deleted.
@@ -389,8 +380,6 @@ static void rs_tl_turn_on_agg(struct iwl
 			rs_tl_turn_on_agg_for_tid(priv, lq_data, tid, sta);
 }
 
-#endif /* CONFIG_IWLWIFI_HT */
-
 static inline int get_num_of_ant_from_rate(u32 rate_n_flags)
 {
 	return (!!(rate_n_flags & RATE_MCS_ANT_A_MSK) +
@@ -626,7 +615,6 @@ static int rs_toggle_antenna(u32 valid_a
 
 /* FIXME:RS: in 4965 we don't use greenfield at all */
 /* FIXME:RS: don't use greenfield for now in TX */
-/* #ifdef CONFIG_IWL4965_HT */
 #if 0
 static inline u8 rs_use_green(struct iwl_priv *priv, struct ieee80211_conf *conf)
 {
@@ -634,12 +622,11 @@ static inline u8 rs_use_green(struct iwl
 		priv->current_ht_config.is_green_field &&
 		!priv->current_ht_config.non_GF_STA_present);
 }
-#else
+#endif
 static inline u8 rs_use_green(struct iwl_priv *priv, struct ieee80211_conf *conf)
 {
 	return 0;
 }
-#endif	/* CONFIG_IWL4965_HT */
 
 /**
  * rs_get_supported_rates - get the available rates
@@ -1050,7 +1037,6 @@ static void rs_set_expected_tpt_table(st
 		tbl->expected_tpt = expected_tpt_G;
 }
 
-#ifdef CONFIG_IWL4965_HT
 /*
  * Find starting rate for new "search" high-throughput mode of modulation.
  * Goal is to find lowest expected rate (under perfect conditions) that is
@@ -1152,12 +1138,10 @@ static s32 rs_get_best_rate(struct iwl_p
 
 	return new_rate;
 }
-#endif				/* CONFIG_IWL4965_HT */
 
 /*
  * Set up search table for MIMO
  */
-#ifdef CONFIG_IWL4965_HT
 static int rs_switch_to_mimo2(struct iwl_priv *priv,
 			     struct iwl4965_lq_sta *lq_sta,
 			     struct ieee80211_conf *conf,
@@ -1221,16 +1205,6 @@ static int rs_switch_to_mimo2(struct iwl
 		     tbl->current_rate, is_green);
 	return 0;
 }
-#else
-static int rs_switch_to_mimo2(struct iwl_priv *priv,
-			     struct iwl4965_lq_sta *lq_sta,
-			     struct ieee80211_conf *conf,
-			     struct sta_info *sta,
-			     struct iwl4965_scale_tbl_info *tbl, int index)
-{
-	return -1;
-}
-#endif	/*CONFIG_IWL4965_HT */
 
 /*
  * Set up search table for SISO
@@ -1241,7 +1215,6 @@ static int rs_switch_to_siso(struct iwl_
 			     struct sta_info *sta,
 			     struct iwl4965_scale_tbl_info *tbl, int index)
 {
-#ifdef CONFIG_IWL4965_HT
 	u16 rate_mask;
 	u8 is_green = lq_sta->is_green;
 	s32 rate;
@@ -1291,9 +1264,6 @@ static int rs_switch_to_siso(struct iwl_
 	IWL_DEBUG_RATE("LQ: Switch to new mcs %X index is green %X\n",
 		     tbl->current_rate, is_green);
 	return 0;
-#else
-	return -1;
-#endif	/*CONFIG_IWL4965_HT */
 }
 
 /*
@@ -1689,9 +1659,7 @@ static void rs_rate_scale_perform(struct
 	u8 done_search = 0;
 	u16 high_low;
 	s32 sr;
-#ifdef CONFIG_IWL4965_HT
 	u8 tid = MAX_TID_COUNT;
-#endif
 
 	IWL_DEBUG_RATE("rate scale calculate new rate for skb\n");
 
@@ -1712,9 +1680,7 @@ static void rs_rate_scale_perform(struct
 	}
 	lq_sta = (struct iwl4965_lq_sta *)sta->rate_ctrl_priv;
 
-#ifdef CONFIG_IWL4965_HT
 	rs_tl_add_packet(lq_sta, hdr);
-#endif
 	/*
 	 * Select rate-scale / modulation-mode table to work with in
 	 * the rest of this function:  "search" if searching for better
@@ -2013,9 +1979,7 @@ lq_update:
 		 * before next round of mode comparisons. */
 		tbl1 = &(lq_sta->lq_info[lq_sta->active_tbl]);
 		if (is_legacy(tbl1->lq_type) &&
-#ifdef CONFIG_IWL4965_HT
 		   (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE)) &&
-#endif
 		    (lq_sta->action_counter >= 1)) {
 			lq_sta->action_counter = 0;
 			IWL_DEBUG_RATE("LQ: STAY in legacy table\n");
@@ -2027,14 +1991,12 @@ lq_update:
 		 * mode for a while before next round of mode comparisons. */
 		if (lq_sta->enable_counter &&
 		    (lq_sta->action_counter >= IWL_ACTION_LIMIT)) {
-#ifdef CONFIG_IWL4965_HT
 			if ((lq_sta->last_tpt > IWL_AGG_TPT_THREHOLD) &&
 			    (lq_sta->tx_agg_tid_en & (1 << tid)) &&
 			    (tid != MAX_TID_COUNT)) {
 				IWL_DEBUG_RATE("try to aggregate tid %d\n", tid);
 				rs_tl_turn_on_agg(priv, tid, lq_sta, sta);
 			}
-#endif /*CONFIG_IWL4965_HT */
 			lq_sta->action_counter = 0;
 			rs_set_stay_in_table(priv, 0, lq_sta);
 		}
@@ -2279,7 +2241,6 @@ static void rs_rate_init(void *priv_rate
 	lq_sta->active_legacy_rate = priv->active_rate & ~(0x1000);
 	lq_sta->active_rate_basic = priv->active_rate_basic;
 	lq_sta->band = priv->band;
-#ifdef CONFIG_IWL4965_HT
 	/*
 	 * active_siso_rate mask includes 9 MBits (bit 5), and CCK (bits 0-3),
 	 * supp_rates[] does not; shift to convert format, force 9 MBits off.
@@ -2317,7 +2278,6 @@ static void rs_rate_init(void *priv_rate
 
 	/* as default allow aggregation for all tids */
 	lq_sta->tx_agg_tid_en = IWL_AGG_ALL_TID;
-#endif /*CONFIG_IWL4965_HT*/
 #ifdef CONFIG_MAC80211_DEBUGFS
 	lq_sta->drv = priv;
 #endif
@@ -2635,11 +2595,9 @@ static void rs_add_debugfs(void *priv, v
 	lq_sta->rs_sta_dbgfs_stats_table_file =
 		debugfs_create_file("rate_stats_table", 0600, dir,
 			lq_sta, &rs_sta_dbgfs_stats_table_ops);
-#ifdef CONFIG_IWL4965_HT
 	lq_sta->rs_sta_dbgfs_tx_agg_tid_en_file =
 		debugfs_create_u8("tx_agg_tid_enable", 0600, dir,
 		&lq_sta->tx_agg_tid_en);
-#endif
 
 }
 
@@ -2648,9 +2606,7 @@ static void rs_remove_debugfs(void *priv
 	struct iwl4965_lq_sta *lq_sta = priv_sta;
 	debugfs_remove(lq_sta->rs_sta_dbgfs_scale_table_file);
 	debugfs_remove(lq_sta->rs_sta_dbgfs_stats_table_file);
-#ifdef CONFIG_IWL4965_HT
 	debugfs_remove(lq_sta->rs_sta_dbgfs_tx_agg_tid_en_file);
-#endif
 }
 #endif
 
diff -puN drivers/net/wireless/iwlwifi/iwl-4965.c~iwlwifi-remove-iwl4965_ht-config drivers/net/wireless/iwlwifi/iwl-4965.c
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c~iwlwifi-remove-iwl4965_ht-config
+++ a/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2819,7 +2819,6 @@ void iwl4965_rx_reply_rx(struct iwl_priv
 		break;
 
 	case IEEE80211_FTYPE_CTL:
-#ifdef CONFIG_IWL4965_HT
 		switch (fc & IEEE80211_FCTL_STYPE) {
 		case IEEE80211_STYPE_BACK_REQ:
 			IWL_DEBUG_HT("IEEE80211_STYPE_BACK_REQ arrived\n");
@@ -2829,7 +2828,6 @@ void iwl4965_rx_reply_rx(struct iwl_priv
 		default:
 			break;
 		}
-#endif
 		break;
 
 	case IEEE80211_FTYPE_DATA: {
@@ -2863,8 +2861,6 @@ void iwl4965_rx_reply_rx(struct iwl_priv
 	}
 }
 
-#ifdef CONFIG_IWL4965_HT
-
 /**
  * iwl4965_tx_status_reply_compressed_ba - Update tx status from block-ack
  *
@@ -3154,10 +3150,6 @@ static int iwl4965_txq_agg_enable(struct
 	return 0;
 }
 
-#endif /* CONFIG_IWL4965_HT */
-
-
-#ifdef CONFIG_IWL4965_HT
 static int iwl4965_rx_agg_start(struct iwl_priv *priv,
 				const u8 *addr, int tid, u16 ssn)
 {
@@ -3231,8 +3223,6 @@ int iwl4965_mac_ampdu_action(struct ieee
 	}
 	return 0;
 }
-#endif /* CONFIG_IWL4965_HT */
-
 
 static u16 iwl4965_get_hcmd_size(u8 cmd_id, u16 len)
 {
@@ -3262,7 +3252,6 @@ static u16 iwl4965_build_addsta_hcmd(con
 	return (u16)sizeof(struct iwl4965_addsta_cmd);
 }
 
-#ifdef CONFIG_IWL4965_HT
 static inline u32 iwl4965_get_scd_ssn(struct iwl4965_tx_resp *tx_resp)
 {
 	__le32 *scd_ssn = (__le32 *)((u32 *)&tx_resp->status +
@@ -3388,7 +3377,6 @@ static int iwl4965_tx_status_reply_tx(st
 	}
 	return 0;
 }
-#endif
 
 /**
  * iwl4965_rx_reply_tx - Handle standard (non-aggregation) Tx response
@@ -3404,12 +3392,10 @@ static void iwl4965_rx_reply_tx(struct i
 	struct ieee80211_tx_info *info;
 	struct iwl4965_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	u32  status = le32_to_cpu(tx_resp->status);
-#ifdef CONFIG_IWL4965_HT
 	int tid = MAX_TID_COUNT, sta_id = IWL_INVALID_STATION;
 	u16 fc;
 	struct ieee80211_hdr *hdr;
 	u8 *qc = NULL;
-#endif
 
 	if ((index >= txq->q.n_bd) || (iwl_queue_used(&txq->q, index) == 0)) {
 		IWL_ERROR("Read index for DMA queue txq_id (%d) index %d "
@@ -3422,7 +3408,6 @@ static void iwl4965_rx_reply_tx(struct i
 	info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb[0]);
 	memset(&info->status, 0, sizeof(info->status));
 
-#ifdef CONFIG_IWL4965_HT
 	hdr = iwl_tx_queue_get_hdr(priv, txq_id, index);
 	fc = le16_to_cpu(hdr->frame_control);
 	if (ieee80211_is_qos_data(fc)) {
@@ -3474,32 +3459,31 @@ static void iwl4965_rx_reply_tx(struct i
 			iwl_txq_check_empty(priv, sta_id, tid, txq_id);
 		}
 	} else {
-#endif /* CONFIG_IWL4965_HT */
+		info->status.retry_count = tx_resp->failure_frame;
+		info->flags |=
+			iwl_is_tx_success(status) ? IEEE80211_TX_STAT_ACK : 0;
+		iwl4965_hwrate_to_tx_control(priv,
+					le32_to_cpu(tx_resp->rate_n_flags),
+					info);
 
-	info->status.retry_count = tx_resp->failure_frame;
-	info->flags |= iwl_is_tx_success(status) ? IEEE80211_TX_STAT_ACK : 0;
-	iwl4965_hwrate_to_tx_control(priv, le32_to_cpu(tx_resp->rate_n_flags),
-				     info);
-
-	IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) rate_n_flags 0x%x "
-		     "retries %d\n", txq_id, iwl_get_tx_fail_reason(status),
-		     status, le32_to_cpu(tx_resp->rate_n_flags),
-		     tx_resp->failure_frame);
-
-	IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
-#ifdef CONFIG_IWL4965_HT
-	if (index != -1) {
-		int freed = iwl_tx_queue_reclaim(priv, txq_id, index);
-		if (tid != MAX_TID_COUNT)
+		IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) rate_n_flags "
+			     "0x%x retries %d\n", txq_id,
+				iwl_get_tx_fail_reason(status),
+				status, le32_to_cpu(tx_resp->rate_n_flags),
+				tx_resp->failure_frame);
+
+		IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
+		if (index != -1) {
+		    int freed = iwl_tx_queue_reclaim(priv, txq_id, index);
+		    if (tid != MAX_TID_COUNT)
 			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
-		if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
+		    if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
 			(txq_id >= 0) && priv->mac80211_registered)
 			ieee80211_wake_queue(priv->hw, txq_id);
-		if (tid != MAX_TID_COUNT)
+		    if (tid != MAX_TID_COUNT)
 			iwl_txq_check_empty(priv, sta_id, tid, txq_id);
+		}
 	}
-	}
-#endif /* CONFIG_IWL4965_HT */
 
 	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
 		IWL_ERROR("TODO:  Implement Tx ABORT REQUIRED!!!\n");
@@ -3513,10 +3497,8 @@ static void iwl4965_rx_handler_setup(str
 	priv->rx_handlers[REPLY_RX] = iwl4965_rx_reply_rx;
 	/* Tx response */
 	priv->rx_handlers[REPLY_TX] = iwl4965_rx_reply_tx;
-
-#ifdef CONFIG_IWL4965_HT
+	/* block ack */
 	priv->rx_handlers[REPLY_COMPRESSED_BA] = iwl4965_rx_reply_compressed_ba;
-#endif /* CONFIG_IWL4965_HT */
 }
 
 void iwl4965_hw_setup_deferred_work(struct iwl_priv *priv)
@@ -3558,10 +3540,8 @@ static struct iwl_lib_ops iwl4965_lib = 
 	.shared_mem_rx_idx = iwl4965_shared_mem_rx_idx,
 	.txq_update_byte_cnt_tbl = iwl4965_txq_update_byte_cnt_tbl,
 	.txq_set_sched = iwl4965_txq_set_sched,
-#ifdef CONFIG_IWL4965_HT
 	.txq_agg_enable = iwl4965_txq_agg_enable,
 	.txq_agg_disable = iwl4965_txq_agg_disable,
-#endif
 	.rx_handler_setup = iwl4965_rx_handler_setup,
 	.is_valid_rtc_data_addr = iwl4965_hw_valid_rtc_data_addr,
 	.alive_notify = iwl4965_alive_notify,
diff -puN drivers/net/wireless/iwlwifi/iwl-5000.c~iwlwifi-remove-iwl4965_ht-config drivers/net/wireless/iwlwifi/iwl-5000.c
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c~iwlwifi-remove-iwl4965_ht-config
+++ a/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1136,12 +1136,10 @@ static void iwl5000_rx_reply_tx(struct i
 	struct ieee80211_tx_info *info;
 	struct iwl5000_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	u32  status = le16_to_cpu(tx_resp->status.status);
-#ifdef CONFIG_IWL4965_HT
 	int tid = MAX_TID_COUNT, sta_id = IWL_INVALID_STATION;
 	u16 fc;
 	struct ieee80211_hdr *hdr;
 	u8 *qc = NULL;
-#endif
 
 	if ((index >= txq->q.n_bd) || (iwl_queue_used(&txq->q, index) == 0)) {
 		IWL_ERROR("Read index for DMA queue txq_id (%d) index %d "
@@ -1154,7 +1152,6 @@ static void iwl5000_rx_reply_tx(struct i
 	info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb[0]);
 	memset(&info->status, 0, sizeof(info->status));
 
-#ifdef CONFIG_IWL4965_HT
 	hdr = iwl_tx_queue_get_hdr(priv, txq_id, index);
 	fc = le16_to_cpu(hdr->frame_control);
 	if (ieee80211_is_qos_data(fc)) {
@@ -1205,32 +1202,31 @@ static void iwl5000_rx_reply_tx(struct i
 			iwl_txq_check_empty(priv, sta_id, tid, txq_id);
 		}
 	} else {
-#endif /* CONFIG_IWL4965_HT */
-
-	info->status.retry_count = tx_resp->failure_frame;
-	info->flags = iwl_is_tx_success(status) ? IEEE80211_TX_STAT_ACK : 0;
-	iwl4965_hwrate_to_tx_control(priv, le32_to_cpu(tx_resp->rate_n_flags),
-				     info);
-
-	IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) rate_n_flags 0x%x "
-		     "retries %d\n", txq_id, iwl_get_tx_fail_reason(status),
-		     status, le32_to_cpu(tx_resp->rate_n_flags),
-		     tx_resp->failure_frame);
-
-	IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
-#ifdef CONFIG_IWL4965_HT
-	if (index != -1) {
-		int freed = iwl_tx_queue_reclaim(priv, txq_id, index);
-		if (tid != MAX_TID_COUNT)
+		info->status.retry_count = tx_resp->failure_frame;
+		info->flags =
+			iwl_is_tx_success(status) ? IEEE80211_TX_STAT_ACK : 0;
+		iwl4965_hwrate_to_tx_control(priv,
+					le32_to_cpu(tx_resp->rate_n_flags),
+					info);
+
+		IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) rate_n_flags "
+			     "0x%x retries %d\n", txq_id,
+				iwl_get_tx_fail_reason(status),
+				status, le32_to_cpu(tx_resp->rate_n_flags),
+				tx_resp->failure_frame);
+
+		IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
+		if (index != -1) {
+		    int freed = iwl_tx_queue_reclaim(priv, txq_id, index);
+		    if (tid != MAX_TID_COUNT)
 			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
-		if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
+		    if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
 			(txq_id >= 0) && priv->mac80211_registered)
 			ieee80211_wake_queue(priv->hw, txq_id);
-		if (tid != MAX_TID_COUNT)
+		    if (tid != MAX_TID_COUNT)
 			iwl_txq_check_empty(priv, sta_id, tid, txq_id);
+		}
 	}
-	}
-#endif /* CONFIG_IWL4965_HT */
 
 	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
 		IWL_ERROR("TODO:  Implement Tx ABORT REQUIRED!!!\n");
diff -puN drivers/net/wireless/iwlwifi/iwl-core.c~iwlwifi-remove-iwl4965_ht-config drivers/net/wireless/iwlwifi/iwl-core.c
--- a/drivers/net/wireless/iwlwifi/iwl-core.c~iwlwifi-remove-iwl4965_ht-config
+++ a/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -321,7 +321,6 @@ void iwl_reset_qos(struct iwl_priv *priv
 }
 EXPORT_SYMBOL(iwl_reset_qos);
 
-#ifdef CONFIG_IWL4965_HT
 #define MAX_BIT_RATE_40_MHZ 0x96; /* 150 Mbps */
 #define MAX_BIT_RATE_20_MHZ 0x48; /* 72 Mbps */
 static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
@@ -374,13 +373,6 @@ static void iwlcore_init_ht_hw_capab(con
 		ht_info->supp_mcs_set[12] |= ((tx_chains_num - 1) << 2);
 	}
 }
-#else
-static inline void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
-			      struct ieee80211_ht_info *ht_info,
-			      enum ieee80211_band band)
-{
-}
-#endif /* CONFIG_IWL4965_HT */
 
 static void iwlcore_init_hw_rates(struct iwl_priv *priv,
 			      struct ieee80211_rate *rates)
@@ -553,7 +545,6 @@ static void iwlcore_free_geos(struct iwl
 	clear_bit(STATUS_GEO_CONFIGURED, &priv->status);
 }
 
-#ifdef CONFIG_IWL4965_HT
 static u8 is_single_rx_stream(struct iwl_priv *priv)
 {
 	return !priv->current_ht_config.is_ht ||
@@ -660,13 +651,6 @@ void iwl_set_rxon_ht(struct iwl_priv *pr
 }
 EXPORT_SYMBOL(iwl_set_rxon_ht);
 
-#else
-static inline u8 is_single_rx_stream(struct iwl_priv *priv)
-{
-	return 1;
-}
-#endif	/*CONFIG_IWL4965_HT */
-
 /*
  * Determine how many receiver/antenna chains to use.
  * More provides better reception via diversity.  Fewer saves power.
@@ -791,10 +775,8 @@ int iwl_setup_mac(struct iwl_priv *priv)
 		    IEEE80211_HW_NOISE_DBM;
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
-#ifdef CONFIG_IWL4965_HT
 	/* Enhanced value; more queues, to support 11n aggregation */
 	hw->ampdu_queues = 12;
-#endif /* CONFIG_IWL4965_HT */
 
 	hw->conf.beacon_int = 100;
 
diff -puN drivers/net/wireless/iwlwifi/iwl-core.h~iwlwifi-remove-iwl4965_ht-config drivers/net/wireless/iwlwifi/iwl-core.h
--- a/drivers/net/wireless/iwlwifi/iwl-core.h~iwlwifi-remove-iwl4965_ht-config
+++ a/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -111,13 +111,11 @@ struct iwl_lib_ops {
 	void (*txq_inval_byte_cnt_tbl)(struct iwl_priv *priv,
 				       struct iwl_tx_queue *txq);
 	void (*txq_set_sched)(struct iwl_priv *priv, u32 mask);
-#ifdef CONFIG_IWL4965_HT
 	/* aggregations */
 	int (*txq_agg_enable)(struct iwl_priv *priv, int txq_id, int tx_fifo,
 			      int sta_id, int tid, u16 ssn_idx);
 	int (*txq_agg_disable)(struct iwl_priv *priv, u16 txq_id, u16 ssn_idx,
 			       u8 tx_fifo);
-#endif /* CONFIG_IWL4965_HT */
 	/* setup Rx handler */
 	void (*rx_handler_setup)(struct iwl_priv *priv);
 	/* alive notification after init uCode load */
@@ -233,11 +231,9 @@ void iwl_hw_txq_ctx_free(struct iwl_priv
 int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *tfd,
 					dma_addr_t addr, u16 len);
 int iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
-#ifdef CONFIG_IWL4965_HT
 int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn);
 int iwl_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid);
 int iwl_txq_check_empty(struct iwl_priv *priv, int sta_id, u8 tid, int txq_id);
-#endif
 
 /*****************************************************
  *   S e n d i n g     H o s t     C o m m a n d s   *
diff -puN drivers/net/wireless/iwlwifi/iwl-debugfs.c~iwlwifi-remove-iwl4965_ht-config drivers/net/wireless/iwlwifi/iwl-debugfs.c
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c~iwlwifi-remove-iwl4965_ht-config
+++ a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -255,21 +255,18 @@ static ssize_t iwl_dbgfs_stations_read(s
 			pos += scnprintf(buf + pos, bufsz - pos, "tid data:\n");
 			pos += scnprintf(buf + pos, bufsz - pos,
 					"seq_num\t\ttxq_id");
-#ifdef CONFIG_IWL4965_HT
 			pos += scnprintf(buf + pos, bufsz - pos,
 					"\tframe_count\twait_for_ba\t");
 			pos += scnprintf(buf + pos, bufsz - pos,
 					"start_idx\tbitmap0\t");
 			pos += scnprintf(buf + pos, bufsz - pos,
 					"bitmap1\trate_n_flags");
-#endif
 			pos += scnprintf(buf + pos, bufsz - pos, "\n");
 
 			for (j = 0; j < MAX_TID_COUNT; j++) {
 				pos += scnprintf(buf + pos, bufsz - pos,
 						"[%d]:\t\t%u", j,
 						station->tid[j].seq_number);
-#ifdef CONFIG_IWL4965_HT
 				pos += scnprintf(buf + pos, bufsz - pos,
 						"\t%u\t\t%u\t\t%u\t\t",
 						station->tid[j].agg.txq_id,
@@ -280,7 +277,6 @@ static ssize_t iwl_dbgfs_stations_read(s
 						station->tid[j].agg.start_idx,
 						(unsigned long long)station->tid[j].agg.bitmap,
 						station->tid[j].agg.rate_n_flags);
-#endif
 				pos += scnprintf(buf + pos, bufsz - pos, "\n");
 			}
 			pos += scnprintf(buf + pos, bufsz - pos, "\n");
diff -puN drivers/net/wireless/iwlwifi/iwl-dev.h~iwlwifi-remove-iwl4965_ht-config drivers/net/wireless/iwlwifi/iwl-dev.h
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h~iwlwifi-remove-iwl4965_ht-config
+++ a/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -401,7 +401,6 @@ struct iwl_rx_queue {
 #define IWL_INVALID_RATE     0xFF
 #define IWL_INVALID_VALUE    -1
 
-#ifdef CONFIG_IWL4965_HT
 /**
  * struct iwl_ht_agg -- aggregation status while waiting for block-ack
  * @txq_id: Tx queue used for Tx attempt
@@ -430,14 +429,11 @@ struct iwl_ht_agg {
 	u8 state;
 };
 
-#endif /* CONFIG_IWL4965_HT */
 
 struct iwl_tid_data {
 	u16 seq_number;
 	u16 tfds_in_queue;
-#ifdef CONFIG_IWL4965_HT
 	struct iwl_ht_agg agg;
-#endif /* CONFIG_IWL4965_HT */
 };
 
 struct iwl_hw_key {
@@ -752,7 +748,6 @@ extern void iwl4965_hwrate_to_tx_control
 					 u32 rate_n_flags,
 					 struct ieee80211_tx_info *info);
 
-#ifdef CONFIG_IWL4965_HT
 extern void iwl4965_init_ht_hw_capab(const struct iwl_priv *priv,
 				struct ieee80211_ht_info *ht_info,
 				enum ieee80211_band band);
@@ -763,12 +758,7 @@ int iwl4965_mac_ampdu_action(struct ieee
 				    const u8 *addr, u16 tid, u16 *ssn);
 int iwl4965_check_empty_hw_queue(struct iwl_priv *priv, int sta_id,
 					u8 tid, int txq_id);
-#else
-static inline void iwl4965_init_ht_hw_capab(const struct iwl_priv *priv,
-					    struct ieee80211_ht_info *ht_info,
-					    enum ieee80211_band band) {}
 
-#endif /*CONFIG_IWL4965_HT */
 /* Structures, enum, and defines specific to the 4965 */
 
 #define IWL_KW_SIZE 0x1000	/*4k */
@@ -1073,9 +1063,7 @@ struct iwl_priv {
 	__le16 sensitivity_tbl[HD_TABLE_SIZE];
 #endif /*CONFIG_IWLWIFI_RUN_TIME_CALIB*/
 
-#ifdef CONFIG_IWL4965_HT
 	struct iwl_ht_info current_ht_config;
-#endif
 	u8 last_phy_res[100];
 
 	/* Rate scaling data */
@@ -1250,7 +1238,6 @@ static inline const char *iwl_get_tx_fai
 #endif
 
 
-#ifdef CONFIG_IWL4965_HT
 static inline int iwl_get_ra_sta_id(struct iwl_priv *priv,
 				    struct ieee80211_hdr *hdr)
 {
@@ -1270,7 +1257,6 @@ static inline struct ieee80211_hdr *iwl_
 				txb[idx].skb[0]->data;
 	return NULL;
 }
-#endif
 
 
 static inline int iwl_is_associated(struct iwl_priv *priv)
diff -puN drivers/net/wireless/iwlwifi/iwl-sta.c~iwlwifi-remove-iwl4965_ht-config drivers/net/wireless/iwlwifi/iwl-sta.c
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c~iwlwifi-remove-iwl4965_ht-config
+++ a/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -156,8 +156,6 @@ int iwl_send_add_sta(struct iwl_priv *pr
 }
 EXPORT_SYMBOL(iwl_send_add_sta);
 
-#ifdef CONFIG_IWL4965_HT
-
 static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
 				   struct ieee80211_ht_info *sta_ht_inf)
 {
@@ -202,12 +200,6 @@ static void iwl_set_ht_add_station(struc
  done:
 	return;
 }
-#else
-static inline void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
-					struct ieee80211_ht_info *sta_ht_info)
-{
-}
-#endif
 
 /**
  * iwl_add_station_flags - Add station to tables in driver and device
@@ -842,7 +834,6 @@ int iwl_rxon_add_station(struct iwl_priv
 	u8 sta_id;
 
 	/* Add station to device's station table */
-#ifdef CONFIG_IWL4965_HT
 	struct ieee80211_conf *conf = &priv->hw->conf;
 	struct ieee80211_ht_info *cur_ht_config = &conf->ht_conf;
 
@@ -852,7 +843,6 @@ int iwl_rxon_add_station(struct iwl_priv
 		sta_id = iwl_add_station_flags(priv, addr, is_ap,
 						   0, cur_ht_config);
 	else
-#endif /* CONFIG_IWL4965_HT */
 		sta_id = iwl_add_station_flags(priv, addr, is_ap,
 						   0, NULL);
 
diff -puN drivers/net/wireless/iwlwifi/iwl-tx.c~iwlwifi-remove-iwl4965_ht-config drivers/net/wireless/iwlwifi/iwl-tx.c
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c~iwlwifi-remove-iwl4965_ht-config
+++ a/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -36,8 +36,6 @@
 #include "iwl-io.h"
 #include "iwl-helpers.h"
 
-#ifdef CONFIG_IWL4965_HT
-
 static const u16 default_tid_to_tx_fifo[] = {
 	IWL_TX_FIFO_AC1,
 	IWL_TX_FIFO_AC0,
@@ -58,9 +56,6 @@ static const u16 default_tid_to_tx_fifo[
 	IWL_TX_FIFO_AC3
 };
 
-#endif	/*CONFIG_IWL4965_HT */
-
-
 
 /**
  * iwl_hw_txq_free_tfd - Free all chunks referenced by TFD [txq->q.read_ptr]
@@ -848,12 +843,10 @@ int iwl_tx_skb(struct iwl_priv *priv, st
 			(hdr->seq_ctrl &
 				__constant_cpu_to_le16(IEEE80211_SCTL_FRAG));
 		seq_number += 0x10;
-#ifdef CONFIG_IWL4965_HT
 		/* aggregation is on for this <sta,tid> */
 		if (info->flags & IEEE80211_TX_CTL_AMPDU)
 			txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
 		priv->stations[sta_id].tid[tid].tfds_in_queue++;
-#endif /* CONFIG_IWL4965_HT */
 	}
 
 	/* Descriptor for chosen Tx queue */
@@ -1196,8 +1189,6 @@ void iwl_tx_cmd_complete(struct iwl_priv
 }
 EXPORT_SYMBOL(iwl_tx_cmd_complete);
 
-
-#ifdef CONFIG_IWL4965_HT
 /*
  * Find first available (lowest unused) Tx Queue, mark it "active".
  * Called only when finding queue for aggregation.
@@ -1359,7 +1350,6 @@ int iwl_txq_check_empty(struct iwl_priv 
 	return 0;
 }
 EXPORT_SYMBOL(iwl_txq_check_empty);
-#endif /* CONFIG_IWL4965_HT */
 
 #ifdef CONFIG_IWLWIF_DEBUG
 #define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
diff -puN drivers/net/wireless/iwlwifi/iwl4965-base.c~iwlwifi-remove-iwl4965_ht-config drivers/net/wireless/iwlwifi/iwl4965-base.c
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c~iwlwifi-remove-iwl4965_ht-config
+++ a/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -634,7 +634,6 @@ static u16 iwl4965_supported_rate_to_ie(
 	return ret_rates;
 }
 
-#ifdef CONFIG_IWL4965_HT
 static void iwl4965_ht_conf(struct iwl_priv *priv,
 			    struct ieee80211_bss_conf *bss_conf)
 {
@@ -707,17 +706,6 @@ static void iwl_ht_cap_to_ie(const struc
 			IEEE80211_HT_CAP_AMPDU_DENSITY);
 	*left -= sizeof(struct ieee80211_ht_cap);
 }
-#else
-static inline void iwl4965_ht_conf(struct iwl_priv *priv,
-				   struct ieee80211_bss_conf *bss_conf)
-{
-}
-static void iwl_ht_cap_to_ie(const struct ieee80211_supported_band *sband,
-			u8 *pos, int *left)
-{
-}
-#endif
-
 
 /**
  * iwl4965_fill_probe_req - fill in all required fields and IE for probe request
@@ -862,10 +850,8 @@ static void iwl4965_activate_qos(struct 
 		priv->qos_data.def_qos_parm.qos_flags |=
 			QOS_PARAM_FLG_UPDATE_EDCA_MSK;
 
-#ifdef CONFIG_IWL4965_HT
 	if (priv->current_ht_config.is_ht)
 		priv->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
-#endif /* CONFIG_IWL4965_HT */
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -3515,10 +3501,9 @@ static void iwl4965_post_associate(struc
 
 	priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 
-#ifdef CONFIG_IWL4965_HT
 	if (priv->current_ht_config.is_ht)
 		iwl_set_rxon_ht(priv, &priv->current_ht_config);
-#endif /* CONFIG_IWL4965_HT*/
+
 	iwl_set_rxon_chain(priv);
 	priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
 
@@ -3854,7 +3839,6 @@ static int iwl4965_mac_config(struct iee
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-#ifdef CONFIG_IWL4965_HT
 	/* if we are switching from ht to 2.4 clear flags
 	 * from any ht related info since 2.4 does not
 	 * support ht */
@@ -3864,7 +3848,6 @@ static int iwl4965_mac_config(struct iee
 #endif
 	)
 		priv->staging_rxon.flags = 0;
-#endif /* CONFIG_IWL4965_HT */
 
 	iwl_set_rxon_channel(priv, conf->channel->band, channel);
 
@@ -4489,11 +4472,9 @@ static void iwl4965_mac_reset_tsf(struct
 	IWL_DEBUG_MAC80211("enter\n");
 
 	priv->lq_mngr.lq_ready = 0;
-#ifdef CONFIG_IWL4965_HT
 	spin_lock_irqsave(&priv->lock, flags);
 	memset(&priv->current_ht_config, 0, sizeof(struct iwl_ht_info));
 	spin_unlock_irqrestore(&priv->lock, flags);
-#endif /* CONFIG_IWL4965_HT */
 
 	iwl_reset_qos(priv);
 
@@ -5100,9 +5081,7 @@ static struct ieee80211_ops iwl4965_hw_o
 	.reset_tsf = iwl4965_mac_reset_tsf,
 	.beacon_update = iwl4965_mac_beacon_update,
 	.bss_info_changed = iwl4965_bss_info_changed,
-#ifdef CONFIG_IWL4965_HT
 	.ampdu_action = iwl4965_mac_ampdu_action,
-#endif  /* CONFIG_IWL4965_HT */
 	.hw_scan = iwl4965_mac_hw_scan
 };
 
_

Patches currently in -mm which might be from ron.rindjunsky@intel.com are

linux-next.patch
iwlwifi-remove-iwl4965_ht-config.patch

