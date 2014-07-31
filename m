From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 31 Jul 2014 13:18:30 -0700
Message-ID: <53daa496.hc8MCufguhDsCOxg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:47029 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaGaUSc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Jul 2014 16:18:32 -0400
Received: by mail-vc0-f201.google.com with SMTP id le20so431927vcb.4
        for <mm-commits@vger.kernel.org>; Thu, 31 Jul 2014 13:18:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/grant-table.c                  |   94 -----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    3 
 drivers/xen/grant-table.c                   |    7 
 include/xen/grant_table.h                   |    4 
 net/mac80211/cfg.c                          |  327 ------------------
 virt/kvm/arm/vgic.c                         |   55 ---
 6 files changed, 1 insertion(+), 489 deletions(-)

diff -puN arch/x86/xen/grant-table.c~linux-next-git-rejects arch/x86/xen/grant-table.c
--- a/arch/x86/xen/grant-table.c~linux-next-git-rejects
+++ a/arch/x86/xen/grant-table.c
@@ -49,11 +49,7 @@
 static struct gnttab_vm_area {
 	struct vm_struct *area;
 	pte_t **ptes;
-<<<<<<< HEAD
-} gnttab_shared_vm_area, gnttab_status_vm_area;
-=======
 } gnttab_shared_vm_area;
->>>>>>> linux-next/akpm-base
 
 int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
 			   unsigned long max_nr_gframes,
@@ -77,95 +73,6 @@ int arch_gnttab_map_shared(unsigned long
 	return 0;
 }
 
-<<<<<<< HEAD
-int arch_gnttab_map_status(uint64_t *frames, unsigned long nr_gframes,
-			   unsigned long max_nr_gframes,
-			   grant_status_t **__shared)
-{
-	grant_status_t *shared = *__shared;
-	unsigned long addr;
-	unsigned long i;
-
-	if (shared == NULL)
-		*__shared = shared = gnttab_status_vm_area.area->addr;
-
-	addr = (unsigned long)shared;
-
-	for (i = 0; i < nr_gframes; i++) {
-		set_pte_at(&init_mm, addr, gnttab_status_vm_area.ptes[i],
-			   mfn_pte(frames[i], PAGE_KERNEL));
-		addr += PAGE_SIZE;
-	}
-
-	return 0;
-}
-
-void arch_gnttab_unmap(void *shared, unsigned long nr_gframes)
-{
-	pte_t **ptes;
-	unsigned long addr;
-	unsigned long i;
-
-	if (shared == gnttab_status_vm_area.area->addr)
-		ptes = gnttab_status_vm_area.ptes;
-	else
-		ptes = gnttab_shared_vm_area.ptes;
-
-	addr = (unsigned long)shared;
-
-	for (i = 0; i < nr_gframes; i++) {
-		set_pte_at(&init_mm, addr, ptes[i], __pte(0));
-		addr += PAGE_SIZE;
-	}
-}
-
-static int arch_gnttab_valloc(struct gnttab_vm_area *area, unsigned nr_frames)
-{
-	area->ptes = kmalloc(sizeof(pte_t *) * nr_frames, GFP_KERNEL);
-	if (area->ptes == NULL)
-		return -ENOMEM;
-
-	area->area = alloc_vm_area(PAGE_SIZE * nr_frames, area->ptes);
-	if (area->area == NULL) {
-		kfree(area->ptes);
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static void arch_gnttab_vfree(struct gnttab_vm_area *area)
-{
-	free_vm_area(area->area);
-	kfree(area->ptes);
-}
-
-int arch_gnttab_init(unsigned long nr_shared, unsigned long nr_status)
-{
-	int ret;
-
-	if (!xen_pv_domain())
-		return 0;
-
-	ret = arch_gnttab_valloc(&gnttab_shared_vm_area, nr_shared);
-	if (ret < 0)
-		return ret;
-
-	/*
-	 * Always allocate the space for the status frames in case
-	 * we're migrated to a host with V2 support.
-	 */
-	ret = arch_gnttab_valloc(&gnttab_status_vm_area, nr_status);
-	if (ret < 0)
-		goto err;
-
-	return 0;
-  err:
-	arch_gnttab_vfree(&gnttab_shared_vm_area);
-	return -ENOMEM;
-}
-
-=======
 void arch_gnttab_unmap(void *shared, unsigned long nr_gframes)
 {
 	unsigned long addr;
@@ -203,7 +110,6 @@ int arch_gnttab_init(unsigned long nr_sh
 	return arch_gnttab_valloc(&gnttab_shared_vm_area, nr_shared);
 }
 
->>>>>>> linux-next/akpm-base
 #ifdef CONFIG_XEN_PVH
 #include <xen/balloon.h>
 #include <xen/events.h>
diff -puN drivers/net/wireless/iwlwifi/mvm/mac80211.c~linux-next-git-rejects drivers/net/wireless/iwlwifi/mvm/mac80211.c
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c~linux-next-git-rejects
+++ a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -329,12 +329,9 @@ int iwl_mvm_mac_setup_register(struct iw
 		hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
 	}
 
-<<<<<<< HEAD
-=======
 	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)
 		hw->flags |= IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS;
 
->>>>>>> linux-next/akpm-base
 	hw->sta_data_size = sizeof(struct iwl_mvm_sta);
 	hw->vif_data_size = sizeof(struct iwl_mvm_vif);
 	hw->chanctx_data_size = sizeof(u16);
diff -puN drivers/xen/grant-table.c~linux-next-git-rejects drivers/xen/grant-table.c
--- a/drivers/xen/grant-table.c~linux-next-git-rejects
+++ a/drivers/xen/grant-table.c
@@ -89,7 +89,7 @@ struct gnttab_ops {
 	/*
 	 * Introducing a valid entry into the grant table, granting the frame of
 	 * this grant entry to domain for accessing or transfering. Ref
-	 * parameter is reference of this introduced grant entry, domid is id of
+	 * parameter is referqence of this introduced grant entry, domid is id of
 	 * granted domain, frame is the page frame to be granted, and flags is
 	 * status of the grant entry to be updated.
 	 */
@@ -929,12 +929,7 @@ int gnttab_init(void)
 		}
 	}
 
-<<<<<<< HEAD
-	ret = arch_gnttab_init(max_nr_grant_frames,
-			       nr_status_frames(max_nr_grant_frames));
-=======
 	ret = arch_gnttab_init(max_nr_grant_frames);
->>>>>>> linux-next/akpm-base
 	if (ret < 0)
 		goto ini_nomem;
 
diff -puN include/xen/grant_table.h~linux-next-git-rejects include/xen/grant_table.h
--- a/include/xen/grant_table.h~linux-next-git-rejects
+++ a/include/xen/grant_table.h
@@ -145,11 +145,7 @@ gnttab_set_unmap_op(struct gnttab_unmap_
 	unmap->dev_bus_addr = 0;
 }
 
-<<<<<<< HEAD
-int arch_gnttab_init(unsigned long nr_shared, unsigned long nr_status);
-=======
 int arch_gnttab_init(unsigned long nr_shared);
->>>>>>> linux-next/akpm-base
 int arch_gnttab_map_shared(xen_pfn_t *frames, unsigned long nr_gframes,
 			   unsigned long max_nr_gframes,
 			   void **__shared);
diff -puN net/mac80211/cfg.c~linux-next-git-rejects net/mac80211/cfg.c
--- a/net/mac80211/cfg.c~linux-next-git-rejects
+++ a/net/mac80211/cfg.c
@@ -468,333 +468,6 @@ void sta_set_rate_info_rx(struct sta_inf
 		rinfo->flags |= RATE_INFO_FLAGS_160_MHZ_WIDTH;
 }
 
-<<<<<<< HEAD
-static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
-{
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct ieee80211_local *local = sdata->local;
-	struct rate_control_ref *ref = NULL;
-	struct timespec uptime;
-	u64 packets = 0;
-	u32 thr = 0;
-	int i, ac;
-
-	if (test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
-		ref = local->rate_ctrl;
-
-	sinfo->generation = sdata->local->sta_generation;
-
-	sinfo->filled = STATION_INFO_INACTIVE_TIME |
-			STATION_INFO_RX_BYTES64 |
-			STATION_INFO_TX_BYTES64 |
-			STATION_INFO_RX_PACKETS |
-			STATION_INFO_TX_PACKETS |
-			STATION_INFO_TX_RETRIES |
-			STATION_INFO_TX_FAILED |
-			STATION_INFO_TX_BITRATE |
-			STATION_INFO_RX_BITRATE |
-			STATION_INFO_RX_DROP_MISC |
-			STATION_INFO_BSS_PARAM |
-			STATION_INFO_CONNECTED_TIME |
-			STATION_INFO_STA_FLAGS |
-			STATION_INFO_BEACON_LOSS_COUNT;
-
-	do_posix_clock_monotonic_gettime(&uptime);
-	sinfo->connected_time = uptime.tv_sec - sta->last_connected;
-
-	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
-	sinfo->tx_bytes = 0;
-	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
-		sinfo->tx_bytes += sta->tx_bytes[ac];
-		packets += sta->tx_packets[ac];
-	}
-	sinfo->tx_packets = packets;
-	sinfo->rx_bytes = sta->rx_bytes;
-	sinfo->rx_packets = sta->rx_packets;
-	sinfo->tx_retries = sta->tx_retry_count;
-	sinfo->tx_failed = sta->tx_retry_failed;
-	sinfo->rx_dropped_misc = sta->rx_dropped;
-	sinfo->beacon_loss_count = sta->beacon_loss_count;
-
-	if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
-	    (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
-		sinfo->filled |= STATION_INFO_SIGNAL | STATION_INFO_SIGNAL_AVG;
-		if (!local->ops->get_rssi ||
-		    drv_get_rssi(local, sdata, &sta->sta, &sinfo->signal))
-			sinfo->signal = (s8)sta->last_signal;
-		sinfo->signal_avg = (s8) -ewma_read(&sta->avg_signal);
-	}
-	if (sta->chains) {
-		sinfo->filled |= STATION_INFO_CHAIN_SIGNAL |
-				 STATION_INFO_CHAIN_SIGNAL_AVG;
-
-		sinfo->chains = sta->chains;
-		for (i = 0; i < ARRAY_SIZE(sinfo->chain_signal); i++) {
-			sinfo->chain_signal[i] = sta->chain_signal_last[i];
-			sinfo->chain_signal_avg[i] =
-				(s8) -ewma_read(&sta->chain_signal_avg[i]);
-		}
-	}
-
-	sta_set_rate_info_tx(sta, &sta->last_tx_rate, &sinfo->txrate);
-	sta_set_rate_info_rx(sta, &sinfo->rxrate);
-
-	if (ieee80211_vif_is_mesh(&sdata->vif)) {
-#ifdef CONFIG_MAC80211_MESH
-		sinfo->filled |= STATION_INFO_LLID |
-				 STATION_INFO_PLID |
-				 STATION_INFO_PLINK_STATE |
-				 STATION_INFO_LOCAL_PM |
-				 STATION_INFO_PEER_PM |
-				 STATION_INFO_NONPEER_PM;
-
-		sinfo->llid = sta->llid;
-		sinfo->plid = sta->plid;
-		sinfo->plink_state = sta->plink_state;
-		if (test_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN)) {
-			sinfo->filled |= STATION_INFO_T_OFFSET;
-			sinfo->t_offset = sta->t_offset;
-		}
-		sinfo->local_pm = sta->local_pm;
-		sinfo->peer_pm = sta->peer_pm;
-		sinfo->nonpeer_pm = sta->nonpeer_pm;
-#endif
-	}
-
-	sinfo->bss_param.flags = 0;
-	if (sdata->vif.bss_conf.use_cts_prot)
-		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_CTS_PROT;
-	if (sdata->vif.bss_conf.use_short_preamble)
-		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_PREAMBLE;
-	if (sdata->vif.bss_conf.use_short_slot)
-		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
-	sinfo->bss_param.dtim_period = sdata->local->hw.conf.ps_dtim_period;
-	sinfo->bss_param.beacon_interval = sdata->vif.bss_conf.beacon_int;
-
-	sinfo->sta_flags.set = 0;
-	sinfo->sta_flags.mask = BIT(NL80211_STA_FLAG_AUTHORIZED) |
-				BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
-				BIT(NL80211_STA_FLAG_WME) |
-				BIT(NL80211_STA_FLAG_MFP) |
-				BIT(NL80211_STA_FLAG_AUTHENTICATED) |
-				BIT(NL80211_STA_FLAG_ASSOCIATED) |
-				BIT(NL80211_STA_FLAG_TDLS_PEER);
-	if (test_sta_flag(sta, WLAN_STA_AUTHORIZED))
-		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_AUTHORIZED);
-	if (test_sta_flag(sta, WLAN_STA_SHORT_PREAMBLE))
-		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_SHORT_PREAMBLE);
-	if (test_sta_flag(sta, WLAN_STA_WME))
-		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_WME);
-	if (test_sta_flag(sta, WLAN_STA_MFP))
-		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_MFP);
-	if (test_sta_flag(sta, WLAN_STA_AUTH))
-		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_AUTHENTICATED);
-	if (test_sta_flag(sta, WLAN_STA_ASSOC))
-		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_ASSOCIATED);
-	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER))
-		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_TDLS_PEER);
-
-	/* check if the driver has a SW RC implementation */
-	if (ref && ref->ops->get_expected_throughput)
-		thr = ref->ops->get_expected_throughput(sta->rate_ctrl_priv);
-	else
-		thr = drv_get_expected_throughput(local, &sta->sta);
-
-	if (thr != 0) {
-		sinfo->filled |= STATION_INFO_EXPECTED_THROUGHPUT;
-		sinfo->expected_throughput = thr;
-	}
-}
-
-static const char ieee80211_gstrings_sta_stats[][ETH_GSTRING_LEN] = {
-	"rx_packets", "rx_bytes", "wep_weak_iv_count",
-	"rx_duplicates", "rx_fragments", "rx_dropped",
-	"tx_packets", "tx_bytes", "tx_fragments",
-	"tx_filtered", "tx_retry_failed", "tx_retries",
-	"beacon_loss", "sta_state", "txrate", "rxrate", "signal",
-	"channel", "noise", "ch_time", "ch_time_busy",
-	"ch_time_ext_busy", "ch_time_rx", "ch_time_tx"
-};
-#define STA_STATS_LEN	ARRAY_SIZE(ieee80211_gstrings_sta_stats)
-
-static int ieee80211_get_et_sset_count(struct wiphy *wiphy,
-				       struct net_device *dev,
-				       int sset)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	int rv = 0;
-
-	if (sset == ETH_SS_STATS)
-		rv += STA_STATS_LEN;
-
-	rv += drv_get_et_sset_count(sdata, sset);
-
-	if (rv == 0)
-		return -EOPNOTSUPP;
-	return rv;
-}
-
-static void ieee80211_get_et_stats(struct wiphy *wiphy,
-				   struct net_device *dev,
-				   struct ethtool_stats *stats,
-				   u64 *data)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_chanctx_conf *chanctx_conf;
-	struct ieee80211_channel *channel;
-	struct sta_info *sta;
-	struct ieee80211_local *local = sdata->local;
-	struct station_info sinfo;
-	struct survey_info survey;
-	int i, q;
-#define STA_STATS_SURVEY_LEN 7
-
-	memset(data, 0, sizeof(u64) * STA_STATS_LEN);
-
-#define ADD_STA_STATS(sta)				\
-	do {						\
-		data[i++] += sta->rx_packets;		\
-		data[i++] += sta->rx_bytes;		\
-		data[i++] += sta->wep_weak_iv_count;	\
-		data[i++] += sta->num_duplicates;	\
-		data[i++] += sta->rx_fragments;		\
-		data[i++] += sta->rx_dropped;		\
-							\
-		data[i++] += sinfo.tx_packets;		\
-		data[i++] += sinfo.tx_bytes;		\
-		data[i++] += sta->tx_fragments;		\
-		data[i++] += sta->tx_filtered_count;	\
-		data[i++] += sta->tx_retry_failed;	\
-		data[i++] += sta->tx_retry_count;	\
-		data[i++] += sta->beacon_loss_count;	\
-	} while (0)
-
-	/* For Managed stations, find the single station based on BSSID
-	 * and use that.  For interface types, iterate through all available
-	 * stations and add stats for any station that is assigned to this
-	 * network device.
-	 */
-
-	mutex_lock(&local->sta_mtx);
-
-	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		sta = sta_info_get_bss(sdata, sdata->u.mgd.bssid);
-
-		if (!(sta && !WARN_ON(sta->sdata->dev != dev)))
-			goto do_survey;
-
-		sinfo.filled = 0;
-		sta_set_sinfo(sta, &sinfo);
-
-		i = 0;
-		ADD_STA_STATS(sta);
-
-		data[i++] = sta->sta_state;
-
-
-		if (sinfo.filled & STATION_INFO_TX_BITRATE)
-			data[i] = 100000 *
-				cfg80211_calculate_bitrate(&sinfo.txrate);
-		i++;
-		if (sinfo.filled & STATION_INFO_RX_BITRATE)
-			data[i] = 100000 *
-				cfg80211_calculate_bitrate(&sinfo.rxrate);
-		i++;
-
-		if (sinfo.filled & STATION_INFO_SIGNAL_AVG)
-			data[i] = (u8)sinfo.signal_avg;
-		i++;
-	} else {
-		list_for_each_entry(sta, &local->sta_list, list) {
-			/* Make sure this station belongs to the proper dev */
-			if (sta->sdata->dev != dev)
-				continue;
-
-			sinfo.filled = 0;
-			sta_set_sinfo(sta, &sinfo);
-			i = 0;
-			ADD_STA_STATS(sta);
-		}
-	}
-
-do_survey:
-	i = STA_STATS_LEN - STA_STATS_SURVEY_LEN;
-	/* Get survey stats for current channel */
-	survey.filled = 0;
-
-	rcu_read_lock();
-	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-	if (chanctx_conf)
-		channel = chanctx_conf->def.chan;
-	else
-		channel = NULL;
-	rcu_read_unlock();
-
-	if (channel) {
-		q = 0;
-		do {
-			survey.filled = 0;
-			if (drv_get_survey(local, q, &survey) != 0) {
-				survey.filled = 0;
-				break;
-			}
-			q++;
-		} while (channel != survey.channel);
-	}
-
-	if (survey.filled)
-		data[i++] = survey.channel->center_freq;
-	else
-		data[i++] = 0;
-	if (survey.filled & SURVEY_INFO_NOISE_DBM)
-		data[i++] = (u8)survey.noise;
-	else
-		data[i++] = -1LL;
-	if (survey.filled & SURVEY_INFO_CHANNEL_TIME)
-		data[i++] = survey.channel_time;
-	else
-		data[i++] = -1LL;
-	if (survey.filled & SURVEY_INFO_CHANNEL_TIME_BUSY)
-		data[i++] = survey.channel_time_busy;
-	else
-		data[i++] = -1LL;
-	if (survey.filled & SURVEY_INFO_CHANNEL_TIME_EXT_BUSY)
-		data[i++] = survey.channel_time_ext_busy;
-	else
-		data[i++] = -1LL;
-	if (survey.filled & SURVEY_INFO_CHANNEL_TIME_RX)
-		data[i++] = survey.channel_time_rx;
-	else
-		data[i++] = -1LL;
-	if (survey.filled & SURVEY_INFO_CHANNEL_TIME_TX)
-		data[i++] = survey.channel_time_tx;
-	else
-		data[i++] = -1LL;
-
-	mutex_unlock(&local->sta_mtx);
-
-	if (WARN_ON(i != STA_STATS_LEN))
-		return;
-
-	drv_get_et_stats(sdata, stats, &(data[STA_STATS_LEN]));
-}
-
-static void ieee80211_get_et_strings(struct wiphy *wiphy,
-				     struct net_device *dev,
-				     u32 sset, u8 *data)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	int sz_sta_stats = 0;
-
-	if (sset == ETH_SS_STATS) {
-		sz_sta_stats = sizeof(ieee80211_gstrings_sta_stats);
-		memcpy(data, ieee80211_gstrings_sta_stats, sz_sta_stats);
-	}
-	drv_get_et_strings(sdata, sset, &(data[sz_sta_stats]));
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static int ieee80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
 				  int idx, u8 *mac, struct station_info *sinfo)
 {
diff -puN virt/kvm/arm/vgic.c~linux-next-git-rejects virt/kvm/arm/vgic.c
--- a/virt/kvm/arm/vgic.c~linux-next-git-rejects
+++ a/virt/kvm/arm/vgic.c
@@ -1587,67 +1587,12 @@ int kvm_vgic_hyp_init(void)
 		goto out_free_irq;
 	}
 
-<<<<<<< HEAD
-	ret = of_address_to_resource(vgic_node, 2, &vctrl_res);
-	if (ret) {
-		kvm_err("Cannot obtain VCTRL resource\n");
-		goto out_free_irq;
-	}
-
-	vgic_vctrl_base = of_iomap(vgic_node, 2);
-	if (!vgic_vctrl_base) {
-		kvm_err("Cannot ioremap VCTRL\n");
-		ret = -ENOMEM;
-		goto out_free_irq;
-	}
-
-	vgic_nr_lr = readl_relaxed(vgic_vctrl_base + GICH_VTR);
-	vgic_nr_lr = (vgic_nr_lr & 0x3f) + 1;
-
-	ret = create_hyp_io_mappings(vgic_vctrl_base,
-				     vgic_vctrl_base + resource_size(&vctrl_res),
-				     vctrl_res.start);
-	if (ret) {
-		kvm_err("Cannot map VCTRL into hyp\n");
-		goto out_unmap;
-	}
-
-	if (of_address_to_resource(vgic_node, 3, &vcpu_res)) {
-		kvm_err("Cannot obtain VCPU resource\n");
-		ret = -ENXIO;
-		goto out_unmap;
-	}
-
-	if (!PAGE_ALIGNED(vcpu_res.start)) {
-		kvm_err("GICV physical address 0x%llx not page aligned\n",
-			(unsigned long long)vcpu_res.start);
-		ret = -ENXIO;
-		goto out_unmap;
-	}
-
-	if (!PAGE_ALIGNED(resource_size(&vcpu_res))) {
-		kvm_err("GICV size 0x%llx not a multiple of page size 0x%lx\n",
-			(unsigned long long)resource_size(&vcpu_res),
-			PAGE_SIZE);
-		ret = -ENXIO;
-		goto out_unmap;
-	}
-
-	vgic_vcpu_base = vcpu_res.start;
-
-	kvm_info("%s@%llx IRQ%d\n", vgic_node->name,
-		 vctrl_res.start, vgic_maint_irq);
-	on_each_cpu(vgic_init_maintenance_interrupt, NULL, 1);
-
-	goto out;
-=======
 	on_each_cpu(vgic_init_maintenance_interrupt, NULL, 1);
 
 	/* Callback into for arch code for setup */
 	vgic_arch_setup(vgic);
 
 	return 0;
->>>>>>> linux-next/akpm-base
 
 out_free_irq:
 	free_percpu_irq(vgic->maint_irq, kvm_get_running_vcpus());
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kbuild-explain-stack-protector-strong-config-logic.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
rtc-add-pcf85063-support-fix.patch
fs-isofs-logging-clean-up-fix.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

