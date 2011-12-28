From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 28 Dec 2011 14:01:26 -0800
Message-ID: <20111228220128.84F87200084@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:55492 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab1L1WBb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2011 17:01:31 -0500
Received: by faar15 with SMTP id r15so405288faa.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2011 14:01:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/radeon/evergreen.c     |   27 
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c    |    6 
 drivers/md/md.c                        |    3 
 drivers/net/wireless/iwlwifi/iwl-agn.c | 1122 -----------------------
 net/bluetooth/l2cap_core.c             |    3 
 5 files changed, 1161 deletions(-)

diff -puN drivers/net/wireless/iwlwifi/iwl-agn.c~linux-next-git-rejects drivers/net/wireless/iwlwifi/iwl-agn.c
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c~linux-next-git-rejects
+++ a/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1629,1128 +1629,6 @@ static int iwl_init_drv(struct iwl_priv 
 
 	return 0;
 
-<<<<<<< HEAD
-			memcpy(data->tkip->mic_keys.tx,
-			       &key->key[NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY],
-			       IWLAGN_MIC_KEY_SIZE);
-
-			rx_mic_key = data->tkip->mic_keys.rx_unicast;
-		} else {
-			tkip_sc = data->rsc_tsc->all_tsc_rsc.tkip.multicast_rsc;
-			rx_p1ks = data->tkip->rx_multi;
-			rx_mic_key = data->tkip->mic_keys.rx_mcast;
-		}
-
-		/*
-		 * For non-QoS this relies on the fact that both the uCode and
-		 * mac80211 use TID 0 (as they need to to avoid replay attacks)
-		 * for checking the IV in the frames.
-		 */
-		for (i = 0; i < IWLAGN_NUM_RSC; i++) {
-			ieee80211_get_key_rx_seq(key, i, &seq);
-			tkip_sc[i].iv16 = cpu_to_le16(seq.tkip.iv16);
-			tkip_sc[i].iv32 = cpu_to_le32(seq.tkip.iv32);
-			/* wrapping isn't allowed, AP must rekey */
-			if (seq.tkip.iv32 > cur_rx_iv32)
-				cur_rx_iv32 = seq.tkip.iv32;
-		}
-
-		ieee80211_get_tkip_rx_p1k(key, data->bssid, cur_rx_iv32, p1k);
-		iwlagn_convert_p1k(p1k, rx_p1ks[0].p1k);
-		ieee80211_get_tkip_rx_p1k(key, data->bssid,
-					  cur_rx_iv32 + 1, p1k);
-		iwlagn_convert_p1k(p1k, rx_p1ks[1].p1k);
-
-		memcpy(rx_mic_key,
-		       &key->key[NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY],
-		       IWLAGN_MIC_KEY_SIZE);
-
-		data->use_tkip = true;
-		data->use_rsc_tsc = true;
-		break;
-	case WLAN_CIPHER_SUITE_CCMP:
-		if (sta) {
-			u8 *pn = seq.ccmp.pn;
-
-			aes_sc = data->rsc_tsc->all_tsc_rsc.aes.unicast_rsc;
-			aes_tx_sc = &data->rsc_tsc->all_tsc_rsc.aes.tsc;
-
-			ieee80211_get_key_tx_seq(key, &seq);
-			aes_tx_sc->pn = cpu_to_le64(
-					(u64)pn[5] |
-					((u64)pn[4] << 8) |
-					((u64)pn[3] << 16) |
-					((u64)pn[2] << 24) |
-					((u64)pn[1] << 32) |
-					((u64)pn[0] << 40));
-		} else
-			aes_sc = data->rsc_tsc->all_tsc_rsc.aes.multicast_rsc;
-
-		/*
-		 * For non-QoS this relies on the fact that both the uCode and
-		 * mac80211 use TID 0 for checking the IV in the frames.
-		 */
-		for (i = 0; i < IWLAGN_NUM_RSC; i++) {
-			u8 *pn = seq.ccmp.pn;
-
-			ieee80211_get_key_rx_seq(key, i, &seq);
-			aes_sc->pn = cpu_to_le64(
-					(u64)pn[5] |
-					((u64)pn[4] << 8) |
-					((u64)pn[3] << 16) |
-					((u64)pn[2] << 24) |
-					((u64)pn[1] << 32) |
-					((u64)pn[0] << 40));
-		}
-		data->use_rsc_tsc = true;
-		break;
-	}
-
-	mutex_unlock(&priv->shrd->mutex);
-}
-
-static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
-			      struct cfg80211_wowlan *wowlan)
-{
-	struct iwl_priv *priv = hw->priv;
-	struct iwlagn_wowlan_wakeup_filter_cmd wakeup_filter_cmd;
-	struct iwl_rxon_cmd rxon;
-	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-	struct iwlagn_wowlan_kek_kck_material_cmd kek_kck_cmd;
-	struct iwlagn_wowlan_tkip_params_cmd tkip_cmd = {};
-	struct wowlan_key_data key_data = {
-		.ctx = ctx,
-		.bssid = ctx->active.bssid_addr,
-		.use_rsc_tsc = false,
-		.tkip = &tkip_cmd,
-		.use_tkip = false,
-	};
-	int ret, i;
-	u16 seq;
-
-	if (WARN_ON(!wowlan))
-		return -EINVAL;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-	mutex_lock(&priv->shrd->mutex);
-
-	/* Don't attempt WoWLAN when not associated, tear down instead. */
-	if (!ctx->vif || ctx->vif->type != NL80211_IFTYPE_STATION ||
-	    !iwl_is_associated_ctx(ctx)) {
-		ret = 1;
-		goto out;
-	}
-
-	key_data.rsc_tsc = kzalloc(sizeof(*key_data.rsc_tsc), GFP_KERNEL);
-	if (!key_data.rsc_tsc) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	memset(&wakeup_filter_cmd, 0, sizeof(wakeup_filter_cmd));
-
-	/*
-	 * We know the last used seqno, and the uCode expects to know that
-	 * one, it will increment before TX.
-	 */
-	seq = le16_to_cpu(priv->last_seq_ctl) & IEEE80211_SCTL_SEQ;
-	wakeup_filter_cmd.non_qos_seq = cpu_to_le16(seq);
-
-	/*
-	 * For QoS counters, we store the one to use next, so subtract 0x10
-	 * since the uCode will add 0x10 before using the value.
-	 */
-	for (i = 0; i < 8; i++) {
-		seq = priv->shrd->tid_data[IWL_AP_ID][i].seq_number;
-		seq -= 0x10;
-		wakeup_filter_cmd.qos_seq[i] = cpu_to_le16(seq);
-	}
-
-	if (wowlan->disconnect)
-		wakeup_filter_cmd.enabled |=
-			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_BEACON_MISS |
-				    IWLAGN_WOWLAN_WAKEUP_LINK_CHANGE);
-	if (wowlan->magic_pkt)
-		wakeup_filter_cmd.enabled |=
-			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_MAGIC_PACKET);
-	if (wowlan->gtk_rekey_failure)
-		wakeup_filter_cmd.enabled |=
-			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_GTK_REKEY_FAIL);
-	if (wowlan->eap_identity_req)
-		wakeup_filter_cmd.enabled |=
-			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_EAP_IDENT_REQ);
-	if (wowlan->four_way_handshake)
-		wakeup_filter_cmd.enabled |=
-			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_4WAY_HANDSHAKE);
-	if (wowlan->rfkill_release)
-		wakeup_filter_cmd.enabled |=
-			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_RFKILL);
-	if (wowlan->n_patterns)
-		wakeup_filter_cmd.enabled |=
-			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_PATTERN_MATCH);
-
-	iwl_scan_cancel_timeout(priv, 200);
-
-	memcpy(&rxon, &ctx->active, sizeof(rxon));
-
-	iwl_trans_stop_device(trans(priv));
-
-	priv->shrd->wowlan = true;
-
-	ret = iwlagn_load_ucode_wait_alive(priv, &priv->ucode_wowlan,
-					   IWL_UCODE_WOWLAN);
-	if (ret)
-		goto error;
-
-	/* now configure WoWLAN ucode */
-	ret = iwl_alive_start(priv);
-	if (ret)
-		goto error;
-
-	memcpy(&ctx->staging, &rxon, sizeof(rxon));
-	ret = iwlagn_commit_rxon(priv, ctx);
-	if (ret)
-		goto error;
-
-	ret = iwl_power_update_mode(priv, true);
-	if (ret)
-		goto error;
-
-	if (!iwlagn_mod_params.sw_crypto) {
-		/* mark all keys clear */
-		priv->ucode_key_table = 0;
-		ctx->key_mapping_keys = 0;
-
-		/*
-		 * This needs to be unlocked due to lock ordering
-		 * constraints. Since we're in the suspend path
-		 * that isn't really a problem though.
-		 */
-		mutex_unlock(&priv->shrd->mutex);
-		ieee80211_iter_keys(priv->hw, ctx->vif,
-				    iwlagn_wowlan_program_keys,
-				    &key_data);
-		mutex_lock(&priv->shrd->mutex);
-		if (key_data.error) {
-			ret = -EIO;
-			goto error;
-		}
-
-		if (key_data.use_rsc_tsc) {
-			struct iwl_host_cmd rsc_tsc_cmd = {
-				.id = REPLY_WOWLAN_TSC_RSC_PARAMS,
-				.flags = CMD_SYNC,
-				.data[0] = key_data.rsc_tsc,
-				.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
-				.len[0] = sizeof(*key_data.rsc_tsc),
-			};
-
-			ret = iwl_trans_send_cmd(trans(priv), &rsc_tsc_cmd);
-			if (ret)
-				goto error;
-		}
-
-		if (key_data.use_tkip) {
-			ret = iwl_trans_send_cmd_pdu(trans(priv),
-						 REPLY_WOWLAN_TKIP_PARAMS,
-						 CMD_SYNC, sizeof(tkip_cmd),
-						 &tkip_cmd);
-			if (ret)
-				goto error;
-		}
-
-		if (priv->have_rekey_data) {
-			memset(&kek_kck_cmd, 0, sizeof(kek_kck_cmd));
-			memcpy(kek_kck_cmd.kck, priv->kck, NL80211_KCK_LEN);
-			kek_kck_cmd.kck_len = cpu_to_le16(NL80211_KCK_LEN);
-			memcpy(kek_kck_cmd.kek, priv->kek, NL80211_KEK_LEN);
-			kek_kck_cmd.kek_len = cpu_to_le16(NL80211_KEK_LEN);
-			kek_kck_cmd.replay_ctr = priv->replay_ctr;
-
-			ret = iwl_trans_send_cmd_pdu(trans(priv),
-						 REPLY_WOWLAN_KEK_KCK_MATERIAL,
-						 CMD_SYNC, sizeof(kek_kck_cmd),
-						 &kek_kck_cmd);
-			if (ret)
-				goto error;
-		}
-	}
-
-	ret = iwl_trans_send_cmd_pdu(trans(priv), REPLY_WOWLAN_WAKEUP_FILTER,
-				 CMD_SYNC, sizeof(wakeup_filter_cmd),
-				 &wakeup_filter_cmd);
-	if (ret)
-		goto error;
-
-	ret = iwlagn_send_patterns(priv, wowlan);
-	if (ret)
-		goto error;
-
-	device_set_wakeup_enable(bus(priv)->dev, true);
-
-	/* Now let the ucode operate on its own */
-	iwl_write32(bus(priv), CSR_UCODE_DRV_GP1_SET,
-			  CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
-
-	goto out;
-
- error:
-	priv->shrd->wowlan = false;
-	iwlagn_prepare_restart(priv);
-	ieee80211_restart_hw(priv->hw);
- out:
-	mutex_unlock(&priv->shrd->mutex);
-	kfree(key_data.rsc_tsc);
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-	return ret;
-}
-
-static int iwlagn_mac_resume(struct ieee80211_hw *hw)
-{
-	struct iwl_priv *priv = hw->priv;
-	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-	struct ieee80211_vif *vif;
-	unsigned long flags;
-	u32 base, status = 0xffffffff;
-	int ret = -EIO;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-	mutex_lock(&priv->shrd->mutex);
-
-	iwl_write32(bus(priv), CSR_UCODE_DRV_GP1_CLR,
-			  CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
-
-	base = priv->device_pointers.error_event_table;
-	if (iwlagn_hw_valid_rtc_data_addr(base)) {
-		spin_lock_irqsave(&bus(priv)->reg_lock, flags);
-		ret = iwl_grab_nic_access_silent(bus(priv));
-		if (ret == 0) {
-			iwl_write32(bus(priv), HBUS_TARG_MEM_RADDR, base);
-			status = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
-			iwl_release_nic_access(bus(priv));
-		}
-		spin_unlock_irqrestore(&bus(priv)->reg_lock, flags);
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-		if (ret == 0) {
-			if (!priv->wowlan_sram)
-				priv->wowlan_sram =
-					kzalloc(priv->ucode_wowlan.data.len,
-						GFP_KERNEL);
-
-			if (priv->wowlan_sram)
-				_iwl_read_targ_mem_words(
-					bus(priv), 0x800000, priv->wowlan_sram,
-					priv->ucode_wowlan.data.len / 4);
-		}
-#endif
-	}
-
-	/* we'll clear ctx->vif during iwlagn_prepare_restart() */
-	vif = ctx->vif;
-
-	priv->shrd->wowlan = false;
-
-	device_set_wakeup_enable(bus(priv)->dev, false);
-
-	iwlagn_prepare_restart(priv);
-
-	memset((void *)&ctx->active, 0, sizeof(ctx->active));
-	iwl_connection_init_rx_config(priv, ctx);
-	iwlagn_set_rxon_chain(priv, ctx);
-
-	mutex_unlock(&priv->shrd->mutex);
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-	ieee80211_resume_disconnect(vif);
-
-	return 1;
-}
-#endif
-
-static void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
-{
-	struct iwl_priv *priv = hw->priv;
-
-	IWL_DEBUG_MACDUMP(priv, "enter\n");
-
-	IWL_DEBUG_TX(priv, "dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
-		     ieee80211_get_tx_rate(hw, IEEE80211_SKB_CB(skb))->bitrate);
-
-	if (iwlagn_tx_skb(priv, skb))
-		dev_kfree_skb_any(skb);
-
-	IWL_DEBUG_MACDUMP(priv, "leave\n");
-}
-
-static void iwlagn_mac_update_tkip_key(struct ieee80211_hw *hw,
-				       struct ieee80211_vif *vif,
-				       struct ieee80211_key_conf *keyconf,
-				       struct ieee80211_sta *sta,
-				       u32 iv32, u16 *phase1key)
-{
-	struct iwl_priv *priv = hw->priv;
-
-	iwl_update_tkip_key(priv, vif, keyconf, sta, iv32, phase1key);
-}
-
-static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-			      struct ieee80211_vif *vif,
-			      struct ieee80211_sta *sta,
-			      struct ieee80211_key_conf *key)
-{
-	struct iwl_priv *priv = hw->priv;
-	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
-	struct iwl_rxon_context *ctx = vif_priv->ctx;
-	int ret;
-	bool is_default_wep_key = false;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	if (iwlagn_mod_params.sw_crypto) {
-		IWL_DEBUG_MAC80211(priv, "leave - hwcrypto disabled\n");
-		return -EOPNOTSUPP;
-	}
-
-	switch (key->cipher) {
-	case WLAN_CIPHER_SUITE_TKIP:
-		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
-		/* fall through */
-	case WLAN_CIPHER_SUITE_CCMP:
-		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-		break;
-	default:
-		break;
-	}
-
-	/*
-	 * We could program these keys into the hardware as well, but we
-	 * don't expect much multicast traffic in IBSS and having keys
-	 * for more stations is probably more useful.
-	 *
-	 * Mark key TX-only and return 0.
-	 */
-	if (vif->type == NL80211_IFTYPE_ADHOC &&
-	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
-		key->hw_key_idx = WEP_INVALID_OFFSET;
-		return 0;
-	}
-
-	/* If they key was TX-only, accept deletion */
-	if (cmd == DISABLE_KEY && key->hw_key_idx == WEP_INVALID_OFFSET)
-		return 0;
-
-	mutex_lock(&priv->shrd->mutex);
-	iwl_scan_cancel_timeout(priv, 100);
-
-	BUILD_BUG_ON(WEP_INVALID_OFFSET == IWLAGN_HW_KEY_DEFAULT);
-
-	/*
-	 * If we are getting WEP group key and we didn't receive any key mapping
-	 * so far, we are in legacy wep mode (group key only), otherwise we are
-	 * in 1X mode.
-	 * In legacy wep mode, we use another host command to the uCode.
-	 */
-	if ((key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
-	     key->cipher == WLAN_CIPHER_SUITE_WEP104) && !sta) {
-		if (cmd == SET_KEY)
-			is_default_wep_key = !ctx->key_mapping_keys;
-		else
-			is_default_wep_key =
-				key->hw_key_idx == IWLAGN_HW_KEY_DEFAULT;
-	}
-
-
-	switch (cmd) {
-	case SET_KEY:
-		if (is_default_wep_key) {
-			ret = iwl_set_default_wep_key(priv, vif_priv->ctx, key);
-			break;
-		}
-		ret = iwl_set_dynamic_key(priv, vif_priv->ctx, key, sta);
-		if (ret) {
-			/*
-			 * can't add key for RX, but we don't need it
-			 * in the device for TX so still return 0
-			 */
-			ret = 0;
-			key->hw_key_idx = WEP_INVALID_OFFSET;
-		}
-
-		IWL_DEBUG_MAC80211(priv, "enable hwcrypto key\n");
-		break;
-	case DISABLE_KEY:
-		if (is_default_wep_key)
-			ret = iwl_remove_default_wep_key(priv, ctx, key);
-		else
-			ret = iwl_remove_dynamic_key(priv, ctx, key, sta);
-
-		IWL_DEBUG_MAC80211(priv, "disable hwcrypto key\n");
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	mutex_unlock(&priv->shrd->mutex);
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-	return ret;
-}
-
-static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
-				   struct ieee80211_vif *vif,
-				   enum ieee80211_ampdu_mlme_action action,
-				   struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-				   u8 buf_size)
-{
-	struct iwl_priv *priv = hw->priv;
-	int ret = -EINVAL;
-	struct iwl_station_priv *sta_priv = (void *) sta->drv_priv;
-	struct iwl_rxon_context *ctx =  iwl_rxon_ctx_from_vif(vif);
-
-	IWL_DEBUG_HT(priv, "A-MPDU action on addr %pM tid %d\n",
-		     sta->addr, tid);
-
-	if (!(priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE))
-		return -EACCES;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-	mutex_lock(&priv->shrd->mutex);
-
-	switch (action) {
-	case IEEE80211_AMPDU_RX_START:
-		IWL_DEBUG_HT(priv, "start Rx\n");
-		ret = iwl_sta_rx_agg_start(priv, sta, tid, *ssn);
-		break;
-	case IEEE80211_AMPDU_RX_STOP:
-		IWL_DEBUG_HT(priv, "stop Rx\n");
-		ret = iwl_sta_rx_agg_stop(priv, sta, tid);
-		if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
-			ret = 0;
-		break;
-	case IEEE80211_AMPDU_TX_START:
-		IWL_DEBUG_HT(priv, "start Tx\n");
-		ret = iwlagn_tx_agg_start(priv, vif, sta, tid, ssn);
-		break;
-	case IEEE80211_AMPDU_TX_STOP:
-		IWL_DEBUG_HT(priv, "stop Tx\n");
-		ret = iwlagn_tx_agg_stop(priv, vif, sta, tid);
-		if ((ret == 0) && (priv->agg_tids_count > 0)) {
-			priv->agg_tids_count--;
-			IWL_DEBUG_HT(priv, "priv->agg_tids_count = %u\n",
-				     priv->agg_tids_count);
-		}
-		if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
-			ret = 0;
-		if (!priv->agg_tids_count && priv->cfg->ht_params &&
-		    priv->cfg->ht_params->use_rts_for_aggregation) {
-			/*
-			 * switch off RTS/CTS if it was previously enabled
-			 */
-			sta_priv->lq_sta.lq.general_params.flags &=
-				~LINK_QUAL_FLAGS_SET_STA_TLC_RTS_MSK;
-			iwl_send_lq_cmd(priv, iwl_rxon_ctx_from_vif(vif),
-					&sta_priv->lq_sta.lq, CMD_ASYNC, false);
-		}
-		break;
-	case IEEE80211_AMPDU_TX_OPERATIONAL:
-		buf_size = min_t(int, buf_size, LINK_QUAL_AGG_FRAME_LIMIT_DEF);
-
-		iwl_trans_tx_agg_setup(trans(priv), ctx->ctxid, iwl_sta_id(sta),
-				tid, buf_size);
-
-		/*
-		 * If the limit is 0, then it wasn't initialised yet,
-		 * use the default. We can do that since we take the
-		 * minimum below, and we don't want to go above our
-		 * default due to hardware restrictions.
-		 */
-		if (sta_priv->max_agg_bufsize == 0)
-			sta_priv->max_agg_bufsize =
-				LINK_QUAL_AGG_FRAME_LIMIT_DEF;
-
-		/*
-		 * Even though in theory the peer could have different
-		 * aggregation reorder buffer sizes for different sessions,
-		 * our ucode doesn't allow for that and has a global limit
-		 * for each station. Therefore, use the minimum of all the
-		 * aggregation sessions and our default value.
-		 */
-		sta_priv->max_agg_bufsize =
-			min(sta_priv->max_agg_bufsize, buf_size);
-
-		if (priv->cfg->ht_params &&
-		    priv->cfg->ht_params->use_rts_for_aggregation) {
-			/*
-			 * switch to RTS/CTS if it is the prefer protection
-			 * method for HT traffic
-			 */
-
-			sta_priv->lq_sta.lq.general_params.flags |=
-				LINK_QUAL_FLAGS_SET_STA_TLC_RTS_MSK;
-		}
-		priv->agg_tids_count++;
-		IWL_DEBUG_HT(priv, "priv->agg_tids_count = %u\n",
-			     priv->agg_tids_count);
-
-		sta_priv->lq_sta.lq.agg_params.agg_frame_cnt_limit =
-			sta_priv->max_agg_bufsize;
-
-		iwl_send_lq_cmd(priv, iwl_rxon_ctx_from_vif(vif),
-				&sta_priv->lq_sta.lq, CMD_ASYNC, false);
-
-		IWL_INFO(priv, "Tx aggregation enabled on ra = %pM tid = %d\n",
-			 sta->addr, tid);
-		ret = 0;
-		break;
-	}
-	mutex_unlock(&priv->shrd->mutex);
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-	return ret;
-}
-
-static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
-			      struct ieee80211_vif *vif,
-			      struct ieee80211_sta *sta)
-{
-	struct iwl_priv *priv = hw->priv;
-	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
-	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
-	bool is_ap = vif->type == NL80211_IFTYPE_STATION;
-	int ret = 0;
-	u8 sta_id;
-
-	IWL_DEBUG_MAC80211(priv, "received request to add station %pM\n",
-			sta->addr);
-	mutex_lock(&priv->shrd->mutex);
-	IWL_DEBUG_INFO(priv, "proceeding to add station %pM\n",
-			sta->addr);
-	sta_priv->sta_id = IWL_INVALID_STATION;
-
-	atomic_set(&sta_priv->pending_frames, 0);
-	if (vif->type == NL80211_IFTYPE_AP)
-		sta_priv->client = true;
-
-	ret = iwl_add_station_common(priv, vif_priv->ctx, sta->addr,
-				     is_ap, sta, &sta_id);
-	if (ret) {
-		IWL_ERR(priv, "Unable to add station %pM (%d)\n",
-			sta->addr, ret);
-		/* Should we return success if return code is EEXIST ? */
-		goto out;
-	}
-
-	sta_priv->sta_id = sta_id;
-
-	/* Initialize rate scaling */
-	IWL_DEBUG_INFO(priv, "Initializing rate scaling for station %pM\n",
-		       sta->addr);
-	iwl_rs_rate_init(priv, sta, sta_id);
- out:
-	mutex_unlock(&priv->shrd->mutex);
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-	return ret;
-}
-
-static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
-				struct ieee80211_channel_switch *ch_switch)
-{
-	struct iwl_priv *priv = hw->priv;
-	const struct iwl_channel_info *ch_info;
-	struct ieee80211_conf *conf = &hw->conf;
-	struct ieee80211_channel *channel = ch_switch->channel;
-	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
-	/*
-	 * MULTI-FIXME
-	 * When we add support for multiple interfaces, we need to
-	 * revisit this. The channel switch command in the device
-	 * only affects the BSS context, but what does that really
-	 * mean? And what if we get a CSA on the second interface?
-	 * This needs a lot of work.
-	 */
-	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-	u16 ch;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	mutex_lock(&priv->shrd->mutex);
-
-	if (iwl_is_rfkill(priv->shrd))
-		goto out;
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status) ||
-	    test_bit(STATUS_SCANNING, &priv->shrd->status) ||
-	    test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->shrd->status))
-		goto out;
-
-	if (!iwl_is_associated_ctx(ctx))
-		goto out;
-
-	if (!priv->cfg->lib->set_channel_switch)
-		goto out;
-
-	ch = channel->hw_value;
-	if (le16_to_cpu(ctx->active.channel) == ch)
-		goto out;
-
-	ch_info = iwl_get_channel_info(priv, channel->band, ch);
-	if (!is_channel_valid(ch_info)) {
-		IWL_DEBUG_MAC80211(priv, "invalid channel\n");
-		goto out;
-	}
-
-	spin_lock_irq(&priv->shrd->lock);
-
-	priv->current_ht_config.smps = conf->smps_mode;
-
-	/* Configure HT40 channels */
-	ctx->ht.enabled = conf_is_ht(conf);
-	if (ctx->ht.enabled)
-		iwlagn_config_ht40(conf, ctx);
-	else
-		ctx->ht.is_40mhz = false;
-
-	if ((le16_to_cpu(ctx->staging.channel) != ch))
-		ctx->staging.flags = 0;
-
-	iwl_set_rxon_channel(priv, channel, ctx);
-	iwl_set_rxon_ht(priv, ht_conf);
-	iwl_set_flags_for_band(priv, ctx, channel->band, ctx->vif);
-
-	spin_unlock_irq(&priv->shrd->lock);
-
-	iwl_set_rate(priv);
-	/*
-	 * at this point, staging_rxon has the
-	 * configuration for channel switch
-	 */
-	set_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->shrd->status);
-	priv->switch_channel = cpu_to_le16(ch);
-	if (priv->cfg->lib->set_channel_switch(priv, ch_switch)) {
-		clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->shrd->status);
-		priv->switch_channel = 0;
-		ieee80211_chswitch_done(ctx->vif, false);
-	}
-
-out:
-	mutex_unlock(&priv->shrd->mutex);
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-}
-
-static void iwlagn_configure_filter(struct ieee80211_hw *hw,
-				    unsigned int changed_flags,
-				    unsigned int *total_flags,
-				    u64 multicast)
-{
-	struct iwl_priv *priv = hw->priv;
-	__le32 filter_or = 0, filter_nand = 0;
-	struct iwl_rxon_context *ctx;
-
-#define CHK(test, flag)	do { \
-	if (*total_flags & (test))		\
-		filter_or |= (flag);		\
-	else					\
-		filter_nand |= (flag);		\
-	} while (0)
-
-	IWL_DEBUG_MAC80211(priv, "Enter: changed: 0x%x, total: 0x%x\n",
-			changed_flags, *total_flags);
-
-	CHK(FIF_OTHER_BSS | FIF_PROMISC_IN_BSS, RXON_FILTER_PROMISC_MSK);
-	/* Setting _just_ RXON_FILTER_CTL2HOST_MSK causes FH errors */
-	CHK(FIF_CONTROL, RXON_FILTER_CTL2HOST_MSK | RXON_FILTER_PROMISC_MSK);
-	CHK(FIF_BCN_PRBRESP_PROMISC, RXON_FILTER_BCON_AWARE_MSK);
-
-#undef CHK
-
-	mutex_lock(&priv->shrd->mutex);
-
-	for_each_context(priv, ctx) {
-		ctx->staging.filter_flags &= ~filter_nand;
-		ctx->staging.filter_flags |= filter_or;
-
-		/*
-		 * Not committing directly because hardware can perform a scan,
-		 * but we'll eventually commit the filter flags change anyway.
-		 */
-	}
-
-	mutex_unlock(&priv->shrd->mutex);
-
-	/*
-	 * Receiving all multicast frames is always enabled by the
-	 * default flags setup in iwl_connection_init_rx_config()
-	 * since we currently do not support programming multicast
-	 * filters into the device.
-	 */
-	*total_flags &= FIF_OTHER_BSS | FIF_ALLMULTI | FIF_PROMISC_IN_BSS |
-			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
-}
-
-static void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
-{
-	struct iwl_priv *priv = hw->priv;
-
-	mutex_lock(&priv->shrd->mutex);
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status)) {
-		IWL_DEBUG_TX(priv, "Aborting flush due to device shutdown\n");
-		goto done;
-	}
-	if (iwl_is_rfkill(priv->shrd)) {
-		IWL_DEBUG_TX(priv, "Aborting flush due to RF Kill\n");
-		goto done;
-	}
-
-	/*
-	 * mac80211 will not push any more frames for transmit
-	 * until the flush is completed
-	 */
-	if (drop) {
-		IWL_DEBUG_MAC80211(priv, "send flush command\n");
-		if (iwlagn_txfifo_flush(priv, IWL_DROP_ALL)) {
-			IWL_ERR(priv, "flush request fail\n");
-			goto done;
-		}
-	}
-	IWL_DEBUG_MAC80211(priv, "wait transmit/flush all frames\n");
-	iwl_trans_wait_tx_queue_empty(trans(priv));
-done:
-	mutex_unlock(&priv->shrd->mutex);
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-}
-
-void iwlagn_disable_roc(struct iwl_priv *priv)
-{
-	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_PAN];
-
-	lockdep_assert_held(&priv->shrd->mutex);
-
-	if (!priv->hw_roc_setup)
-		return;
-
-	ctx->staging.dev_type = RXON_DEV_TYPE_P2P;
-	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-
-	priv->hw_roc_channel = NULL;
-
-	memset(ctx->staging.node_addr, 0, ETH_ALEN);
-
-	iwlagn_commit_rxon(priv, ctx);
-
-	ctx->is_active = false;
-	priv->hw_roc_setup = false;
-}
-
-static void iwlagn_disable_roc_work(struct work_struct *work)
-{
-	struct iwl_priv *priv = container_of(work, struct iwl_priv,
-					     hw_roc_disable_work.work);
-
-	mutex_lock(&priv->shrd->mutex);
-	iwlagn_disable_roc(priv);
-	mutex_unlock(&priv->shrd->mutex);
-}
-
-static int iwlagn_mac_remain_on_channel(struct ieee80211_hw *hw,
-				     struct ieee80211_channel *channel,
-				     enum nl80211_channel_type channel_type,
-				     int duration)
-{
-	struct iwl_priv *priv = hw->priv;
-	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_PAN];
-	int err = 0;
-
-	if (!(priv->shrd->valid_contexts & BIT(IWL_RXON_CTX_PAN)))
-		return -EOPNOTSUPP;
-
-	if (!(ctx->interface_modes & BIT(NL80211_IFTYPE_P2P_CLIENT)))
-		return -EOPNOTSUPP;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-	mutex_lock(&priv->shrd->mutex);
-
-	if (test_bit(STATUS_SCAN_HW, &priv->shrd->status)) {
-		err = -EBUSY;
-		goto out;
-	}
-
-	priv->hw_roc_channel = channel;
-	priv->hw_roc_chantype = channel_type;
-	priv->hw_roc_duration = duration;
-	priv->hw_roc_start_notified = false;
-	cancel_delayed_work(&priv->hw_roc_disable_work);
-
-	if (!ctx->is_active) {
-		ctx->is_active = true;
-		ctx->staging.dev_type = RXON_DEV_TYPE_P2P;
-		memcpy(ctx->staging.node_addr,
-		       priv->contexts[IWL_RXON_CTX_BSS].staging.node_addr,
-		       ETH_ALEN);
-		memcpy(ctx->staging.bssid_addr,
-		       priv->contexts[IWL_RXON_CTX_BSS].staging.node_addr,
-		       ETH_ALEN);
-		err = iwlagn_commit_rxon(priv, ctx);
-		if (err)
-			goto out;
-		ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK |
-					     RXON_FILTER_PROMISC_MSK |
-					     RXON_FILTER_CTL2HOST_MSK;
-
-		err = iwlagn_commit_rxon(priv, ctx);
-		if (err) {
-			iwlagn_disable_roc(priv);
-			goto out;
-		}
-		priv->hw_roc_setup = true;
-	}
-
-	err = iwl_scan_initiate(priv, ctx->vif, IWL_SCAN_ROC, channel->band);
-	if (err)
-		iwlagn_disable_roc(priv);
-
- out:
-	mutex_unlock(&priv->shrd->mutex);
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-	return err;
-}
-
-static int iwlagn_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
-{
-	struct iwl_priv *priv = hw->priv;
-
-	if (!(priv->shrd->valid_contexts & BIT(IWL_RXON_CTX_PAN)))
-		return -EOPNOTSUPP;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-	mutex_lock(&priv->shrd->mutex);
-	iwl_scan_cancel_timeout(priv, priv->hw_roc_duration);
-	iwlagn_disable_roc(priv);
-	mutex_unlock(&priv->shrd->mutex);
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-	return 0;
-}
-
-static int iwlagn_mac_tx_sync(struct ieee80211_hw *hw,
-			      struct ieee80211_vif *vif,
-			      const u8 *bssid,
-			      enum ieee80211_tx_sync_type type)
-{
-	struct iwl_priv *priv = hw->priv;
-	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
-	struct iwl_rxon_context *ctx = vif_priv->ctx;
-	int ret;
-	u8 sta_id;
-
-	if (ctx->ctxid != IWL_RXON_CTX_PAN)
-		return 0;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-	mutex_lock(&priv->shrd->mutex);
-
-	if (iwl_is_associated_ctx(ctx)) {
-		ret = 0;
-		goto out;
-	}
-
-	if (ctx->preauth_bssid || test_bit(STATUS_SCAN_HW, &priv->shrd->status)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	ret = iwl_add_station_common(priv, ctx, bssid, true, NULL, &sta_id);
-	if (ret)
-		goto out;
-
-	if (WARN_ON(sta_id != ctx->ap_sta_id)) {
-		ret = -EIO;
-		goto out_remove_sta;
-	}
-
-	memcpy(ctx->bssid, bssid, ETH_ALEN);
-	ctx->preauth_bssid = true;
-
-	ret = iwlagn_commit_rxon(priv, ctx);
-
-	if (ret == 0)
-		goto out;
-
- out_remove_sta:
-	iwl_remove_station(priv, sta_id, bssid);
- out:
-	mutex_unlock(&priv->shrd->mutex);
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-	return ret;
-}
-
-static void iwlagn_mac_finish_tx_sync(struct ieee80211_hw *hw,
-				   struct ieee80211_vif *vif,
-				   const u8 *bssid,
-				   enum ieee80211_tx_sync_type type)
-{
-	struct iwl_priv *priv = hw->priv;
-	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
-	struct iwl_rxon_context *ctx = vif_priv->ctx;
-
-	if (ctx->ctxid != IWL_RXON_CTX_PAN)
-		return;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-	mutex_lock(&priv->shrd->mutex);
-
-	if (iwl_is_associated_ctx(ctx))
-		goto out;
-
-	iwl_remove_station(priv, ctx->ap_sta_id, bssid);
-	ctx->preauth_bssid = false;
-	/* no need to commit */
- out:
-	mutex_unlock(&priv->shrd->mutex);
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-}
-
-/*****************************************************************************
- *
- * driver setup and teardown
- *
- *****************************************************************************/
-
-static void iwl_setup_deferred_work(struct iwl_priv *priv)
-{
-	priv->shrd->workqueue = create_singlethread_workqueue(DRV_NAME);
-
-	init_waitqueue_head(&priv->shrd->wait_command_queue);
-
-	INIT_WORK(&priv->restart, iwl_bg_restart);
-	INIT_WORK(&priv->beacon_update, iwl_bg_beacon_update);
-	INIT_WORK(&priv->run_time_calib_work, iwl_bg_run_time_calib_work);
-	INIT_WORK(&priv->tx_flush, iwl_bg_tx_flush);
-	INIT_WORK(&priv->bt_full_concurrency, iwl_bg_bt_full_concurrency);
-	INIT_WORK(&priv->bt_runtime_config, iwl_bg_bt_runtime_config);
-	INIT_DELAYED_WORK(&priv->hw_roc_disable_work,
-			  iwlagn_disable_roc_work);
-
-	iwl_setup_scan_deferred_work(priv);
-
-	if (priv->cfg->lib->bt_setup_deferred_work)
-		priv->cfg->lib->bt_setup_deferred_work(priv);
-
-	init_timer(&priv->statistics_periodic);
-	priv->statistics_periodic.data = (unsigned long)priv;
-	priv->statistics_periodic.function = iwl_bg_statistics_periodic;
-
-	init_timer(&priv->ucode_trace);
-	priv->ucode_trace.data = (unsigned long)priv;
-	priv->ucode_trace.function = iwl_bg_ucode_trace;
-
-	init_timer(&priv->watchdog);
-	priv->watchdog.data = (unsigned long)priv;
-	priv->watchdog.function = iwl_bg_watchdog;
-}
-
-static void iwl_cancel_deferred_work(struct iwl_priv *priv)
-{
-	if (priv->cfg->lib->cancel_deferred_work)
-		priv->cfg->lib->cancel_deferred_work(priv);
-
-	cancel_work_sync(&priv->run_time_calib_work);
-	cancel_work_sync(&priv->beacon_update);
-
-	iwl_cancel_scan_deferred_work(priv);
-
-	cancel_work_sync(&priv->bt_full_concurrency);
-	cancel_work_sync(&priv->bt_runtime_config);
-	cancel_delayed_work_sync(&priv->hw_roc_disable_work);
-
-	del_timer_sync(&priv->statistics_periodic);
-	del_timer_sync(&priv->ucode_trace);
-}
-
-static void iwl_init_hw_rates(struct iwl_priv *priv,
-			      struct ieee80211_rate *rates)
-{
-	int i;
-
-	for (i = 0; i < IWL_RATE_COUNT_LEGACY; i++) {
-		rates[i].bitrate = iwl_rates[i].ieee * 5;
-		rates[i].hw_value = i; /* Rate scaling will work on indexes */
-		rates[i].hw_value_short = i;
-		rates[i].flags = 0;
-		if ((i >= IWL_FIRST_CCK_RATE) && (i <= IWL_LAST_CCK_RATE)) {
-			/*
-			 * If CCK != 1M then set short preamble rate flag.
-			 */
-			rates[i].flags |=
-				(iwl_rates[i].plcp == IWL_RATE_1M_PLCP) ?
-					0 : IEEE80211_RATE_SHORT_PREAMBLE;
-		}
-	}
-}
-
-static int iwl_init_drv(struct iwl_priv *priv)
-{
-	int ret;
-
-	spin_lock_init(&priv->shrd->sta_lock);
-
-	mutex_init(&priv->shrd->mutex);
-
-	priv->ieee_channels = NULL;
-	priv->ieee_rates = NULL;
-	priv->band = IEEE80211_BAND_2GHZ;
-
-	priv->iw_mode = NL80211_IFTYPE_STATION;
-	priv->current_ht_config.smps = IEEE80211_SMPS_STATIC;
-	priv->missed_beacon_threshold = IWL_MISSED_BEACON_THRESHOLD_DEF;
-	priv->agg_tids_count = 0;
-
-	/* initialize force reset */
-	priv->force_reset[IWL_RF_RESET].reset_duration =
-		IWL_DELAY_NEXT_FORCE_RF_RESET;
-	priv->force_reset[IWL_FW_RESET].reset_duration =
-		IWL_DELAY_NEXT_FORCE_FW_RELOAD;
-
-	priv->rx_statistics_jiffies = jiffies;
-
-	/* Choose which receivers/antennas to use */
-	iwlagn_set_rxon_chain(priv, &priv->contexts[IWL_RXON_CTX_BSS]);
-
-	iwl_init_scan_params(priv);
-
-	/* init bt coex */
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist) {
-		priv->kill_ack_mask = IWLAGN_BT_KILL_ACK_MASK_DEFAULT;
-		priv->kill_cts_mask = IWLAGN_BT_KILL_CTS_MASK_DEFAULT;
-		priv->bt_valid = IWLAGN_BT_ALL_VALID_MSK;
-		priv->bt_on_thresh = BT_ON_THRESHOLD_DEF;
-		priv->bt_duration = BT_DURATION_LIMIT_DEF;
-		priv->dynamic_frag_thresh = BT_FRAG_THRESHOLD_DEF;
-	}
-
-	ret = iwl_init_channel_map(priv);
-	if (ret) {
-		IWL_ERR(priv, "initializing regulatory failed: %d\n", ret);
-		goto err;
-	}
-
-	ret = iwl_init_geos(priv);
-	if (ret) {
-		IWL_ERR(priv, "initializing geos failed: %d\n", ret);
-		goto err_free_channel_map;
-	}
-	iwl_init_hw_rates(priv, priv->ieee_rates);
-
-	return 0;
-
-=======
->>>>>>> linux-next/akpm-end
 err_free_channel_map:
 	iwl_free_channel_map(priv);
 err:
diff -puN net/bluetooth/l2cap_core.c~linux-next-git-rejects net/bluetooth/l2cap_core.c
--- a/net/bluetooth/l2cap_core.c~linux-next-git-rejects
+++ a/net/bluetooth/l2cap_core.c
@@ -2403,10 +2403,7 @@ static int l2cap_parse_conf_rsp(struct l
 	int type, olen;
 	unsigned long val;
 	struct l2cap_conf_rfc rfc = { .mode = L2CAP_MODE_BASIC };
-<<<<<<< HEAD
-=======
 	struct l2cap_conf_efs efs;
->>>>>>> linux-next/akpm-end
 
 	BT_DBG("chan %p, rsp %p, len %d, req %p", chan, rsp, len, data);
 
diff -puN drivers/gpu/drm/radeon/evergreen.c~linux-next-git-rejects drivers/gpu/drm/radeon/evergreen.c
--- a/drivers/gpu/drm/radeon/evergreen.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/radeon/evergreen.c
@@ -3337,33 +3337,6 @@ int evergreen_init(struct radeon_device 
 		evergreen_pcie_gart_fini(rdev);
 		rdev->accel_working = false;
 	}
-<<<<<<< HEAD
-	if (rdev->accel_working) {
-		r = radeon_ib_pool_init(rdev);
-		if (r) {
-			DRM_ERROR("radeon: failed initializing IB pool (%d).\n", r);
-			rdev->accel_working = false;
-		}
-		r = r600_ib_test(rdev);
-		if (r) {
-			DRM_ERROR("radeon: failed testing IB (%d).\n", r);
-			rdev->accel_working = false;
-		}
-	}
-
-	/* Don't start up if the MC ucode is missing on BTC parts.
-	 * The default clocks and voltages before the MC ucode
-	 * is loaded are not suffient for advanced operations.
-	 */
-	if (ASIC_IS_DCE5(rdev)) {
-		if (!rdev->mc_fw && !(rdev->flags & RADEON_IS_IGP)) {
-			DRM_ERROR("radeon: MC ucode required for NI+.\n");
-			return -EINVAL;
-		}
-	}
-
-=======
->>>>>>> linux-next/akpm-end
 	return 0;
 }
 
diff -puN drivers/gpu/drm/vmwgfx/vmwgfx_kms.c~linux-next-git-rejects drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1093,11 +1093,8 @@ static struct drm_framebuffer *vmw_kms_f
 	struct vmw_surface *surface = NULL;
 	struct vmw_dma_buffer *bo = NULL;
 	struct ttm_base_object *user_obj;
-<<<<<<< HEAD
-=======
 	struct drm_mode_fb_cmd mode_cmd;
 	u64 required_size;
->>>>>>> linux-next/akpm-end
 	int ret;
 
 	mode_cmd.width = mode_cmd2->width;
@@ -1113,14 +1110,11 @@ static struct drm_framebuffer *vmw_kms_f
 	 * requested framebuffer.
 	 */
 
-<<<<<<< HEAD
 	if (!vmw_kms_validate_mode_vram(dev_priv,
 					mode_cmd->pitch,
 					mode_cmd->height)) {
-=======
 	required_size = mode_cmd.pitch * mode_cmd.height;
 	if (unlikely(required_size > (u64) dev_priv->vram_size)) {
->>>>>>> linux-next/akpm-end
 		DRM_ERROR("VRAM size is too small for requested mode.\n");
 		return ERR_PTR(-ENOMEM);
 	}
diff -puN drivers/md/md.c~linux-next-git-rejects drivers/md/md.c
--- a/drivers/md/md.c~linux-next-git-rejects
+++ a/drivers/md/md.c
@@ -7405,7 +7405,6 @@ static int remove_and_add_spares(struct 
 				if (sysfs_link_rdev(mddev, rdev))
 					/* failure here is OK */;
 				spares++;
-<<<<<<< HEAD
 			if (rdev->raid_disk < 0
 			    && !test_bit(Faulty, &rdev->flags)) {
 				rdev->recovery_offset = 0;
@@ -7417,10 +7416,8 @@ static int remove_and_add_spares(struct 
 					md_new_event(mddev);
 					set_bit(MD_CHANGE_DEVS, &mddev->flags);
 				}
-=======
 				md_new_event(mddev);
 				set_bit(MD_CHANGE_DEVS, &mddev->flags);
->>>>>>> linux-next/akpm-end
 			}
 		}
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-procfs-do-not-confuse-jiffies-with-cputime64_t.patch
linux-next.patch
i-need-old-gcc.patch
block-an-exiting-task-should-be-allowed-to-create-io_context.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-checkpatch-fixes.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
slub-document-setting-min-order-with-debug_guardpage_minorder-0-checkpatch-fixes.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-simplify-find_vma_prev-fix.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix.patch
mempool-fix-first-round-failure-behavior-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call-fix.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
leds-add-driver-for-tca6507-led-controller.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2-fix.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix-3.patch
mm-isolate-pages-for-immediate-reclaim-on-their-own-lru-fix-2.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
kexec-remove-kmsg_dump_kexec.patch
panic-dont-print-redundant-backtraces-on-oops-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

