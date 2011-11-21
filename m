From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 21 Nov 2011 12:28:24 -0800
Message-ID: <201111212028.pALKSOVT024078@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:39089 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab1KUU2a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2011 15:28:30 -0500
Received: by qyd20 with SMTP id 20so888206qyd.1
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2011 12:28:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/nvidia/forcedeth.c       |   52 ----------------
 drivers/net/wireless/brcm80211/brcmsmac/dma.c |    4 -
 drivers/net/wireless/libertas/cfg.c           |    5 -
 net/mac80211/mlme.c                           |   36 -----------
 4 files changed, 97 deletions(-)

diff -puN drivers/net/ethernet/nvidia/forcedeth.c~linux-next-git-rejects drivers/net/ethernet/nvidia/forcedeth.c
--- a/drivers/net/ethernet/nvidia/forcedeth.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/nvidia/forcedeth.c
@@ -1771,32 +1771,6 @@ nv_get_stats64(struct net_device *dev, s
 	} while (u64_stats_fetch_retry_bh(&np->swstats_tx_syncp, syncp_start));
 
 	/* If the nic supports hw counters then retrieve latest values */
-<<<<<<< HEAD
-	if (np->driver_data & (DEV_HAS_STATISTICS_V1|DEV_HAS_STATISTICS_V2|DEV_HAS_STATISTICS_V3)) {
-		nv_get_hw_stats(dev);
-
-		/*
-		 * Note: because HW stats are not always available and
-		 * for consistency reasons, the following ifconfig
-		 * stats are managed by software: rx_bytes, tx_bytes,
-		 * rx_packets and tx_packets. The related hardware
-		 * stats reported by ethtool should be equivalent to
-		 * these ifconfig stats, with 4 additional bytes per
-		 * packet (Ethernet FCS CRC).
-		 */
-
-		/* copy to net_device stats */
-		dev->stats.tx_fifo_errors = np->estats.tx_fifo_errors;
-		dev->stats.tx_carrier_errors = np->estats.tx_carrier_errors;
-		dev->stats.rx_crc_errors = np->estats.rx_crc_errors;
-		dev->stats.rx_over_errors = np->estats.rx_over_errors;
-		dev->stats.rx_fifo_errors = np->estats.rx_drop_frame;
-		dev->stats.rx_errors = np->estats.rx_errors_total;
-		dev->stats.tx_errors = np->estats.tx_errors_total;
-	}
-
-	return &dev->stats;
-=======
 	if (np->driver_data & DEV_HAS_STATISTICS_V123) {
 		spin_lock_bh(&np->hwstats_lock);
 
@@ -1824,7 +1798,6 @@ nv_get_stats64(struct net_device *dev, s
 	}
 
 	return storage;
->>>>>>> linux-next/akpm-end
 }
 
 /*
@@ -2498,15 +2471,10 @@ static int nv_tx_done(struct net_device 
 					    && !(flags & NV_TX_RETRYCOUNT_MASK))
 						nv_legacybackoff_reseed(dev);
 				} else {
-<<<<<<< HEAD
-					dev->stats.tx_packets++;
-					dev->stats.tx_bytes += np->get_tx_ctx->skb->len;
-=======
 					u64_stats_update_begin(&np->swstats_tx_syncp);
 					np->stat_tx_packets++;
 					np->stat_tx_bytes += np->get_tx_ctx->skb->len;
 					u64_stats_update_end(&np->swstats_tx_syncp);
->>>>>>> linux-next/akpm-end
 				}
 				dev_kfree_skb_any(np->get_tx_ctx->skb);
 				np->get_tx_ctx->skb = NULL;
@@ -2519,15 +2487,10 @@ static int nv_tx_done(struct net_device 
 					    && !(flags & NV_TX2_RETRYCOUNT_MASK))
 						nv_legacybackoff_reseed(dev);
 				} else {
-<<<<<<< HEAD
-					dev->stats.tx_packets++;
-					dev->stats.tx_bytes += np->get_tx_ctx->skb->len;
-=======
 					u64_stats_update_begin(&np->swstats_tx_syncp);
 					np->stat_tx_packets++;
 					np->stat_tx_bytes += np->get_tx_ctx->skb->len;
 					u64_stats_update_end(&np->swstats_tx_syncp);
->>>>>>> linux-next/akpm-end
 				}
 				dev_kfree_skb_any(np->get_tx_ctx->skb);
 				np->get_tx_ctx->skb = NULL;
@@ -2569,15 +2532,10 @@ static int nv_tx_done_optimized(struct n
 						nv_legacybackoff_reseed(dev);
 				}
 			} else {
-<<<<<<< HEAD
-				dev->stats.tx_packets++;
-				dev->stats.tx_bytes += np->get_tx_ctx->skb->len;
-=======
 					u64_stats_update_begin(&np->swstats_tx_syncp);
 					np->stat_tx_packets++;
 					np->stat_tx_bytes += np->get_tx_ctx->skb->len;
 					u64_stats_update_end(&np->swstats_tx_syncp);
->>>>>>> linux-next/akpm-end
 			}
 
 			dev_kfree_skb_any(np->get_tx_ctx->skb);
@@ -2837,15 +2795,10 @@ static int nv_rx_process(struct net_devi
 		skb_put(skb, len);
 		skb->protocol = eth_type_trans(skb, dev);
 		napi_gro_receive(&np->napi, skb);
-<<<<<<< HEAD
-		dev->stats.rx_packets++;
-		dev->stats.rx_bytes += len;
-=======
 		u64_stats_update_begin(&np->swstats_rx_syncp);
 		np->stat_rx_packets++;
 		np->stat_rx_bytes += len;
 		u64_stats_update_end(&np->swstats_rx_syncp);
->>>>>>> linux-next/akpm-end
 next_pkt:
 		if (unlikely(np->get_rx.orig++ == np->last_rx.orig))
 			np->get_rx.orig = np->first_rx.orig;
@@ -2928,15 +2881,10 @@ static int nv_rx_process_optimized(struc
 				__vlan_hwaccel_put_tag(skb, vid);
 			}
 			napi_gro_receive(&np->napi, skb);
-<<<<<<< HEAD
-			dev->stats.rx_packets++;
-			dev->stats.rx_bytes += len;
-=======
 			u64_stats_update_begin(&np->swstats_rx_syncp);
 			np->stat_rx_packets++;
 			np->stat_rx_bytes += len;
 			u64_stats_update_end(&np->swstats_rx_syncp);
->>>>>>> linux-next/akpm-end
 		} else {
 			dev_kfree_skb(skb);
 		}
diff -puN drivers/net/wireless/brcm80211/brcmsmac/dma.c~linux-next-git-rejects drivers/net/wireless/brcm80211/brcmsmac/dma.c
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c~linux-next-git-rejects
+++ a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -363,11 +363,7 @@ static uint _dma_ctrlflags(struct dma_in
 	uint dmactrlflags;
 
 	if (di == NULL) {
-<<<<<<< HEAD
-		DMA_ERROR(("_dma_ctrlflags: NULL dma handle\n"));
-=======
 		DMA_ERROR("NULL dma handle\n");
->>>>>>> linux-next/akpm-end
 		return 0;
 	}
 
diff -puN drivers/net/wireless/libertas/cfg.c~linux-next-git-rejects drivers/net/wireless/libertas/cfg.c
--- a/drivers/net/wireless/libertas/cfg.c~linux-next-git-rejects
+++ a/drivers/net/wireless/libertas/cfg.c
@@ -633,13 +633,8 @@ static int lbs_ret_scan(struct lbs_priva
 				     LBS_SCAN_RSSI_TO_MBM(rssi)/100);
 
 			if (channel &&
-<<<<<<< HEAD
-			    !(channel->flags & IEEE80211_CHAN_DISABLED))
-				cfg80211_inform_bss(wiphy, channel,
-=======
 			    !(channel->flags & IEEE80211_CHAN_DISABLED)) {
 				bss = cfg80211_inform_bss(wiphy, channel,
->>>>>>> linux-next/akpm-end
 					bssid, get_unaligned_le64(tsfdesc),
 					capa, intvl, ie, ielen,
 					LBS_SCAN_RSSI_TO_MBM(rssi),
diff -puN net/mac80211/mlme.c~linux-next-git-rejects net/mac80211/mlme.c
--- a/net/mac80211/mlme.c~linux-next-git-rejects
+++ a/net/mac80211/mlme.c
@@ -1593,41 +1593,6 @@ static bool ieee80211_assoc_success(stru
 			    &have_higher_than_11mbit,
 			    &min_rate, &min_rate_index);
 
-<<<<<<< HEAD
-		for (j = 0; j < sband->n_bitrates; j++) {
-			if (sband->bitrates[j].bitrate == rate) {
-				rates |= BIT(j);
-				if (is_basic)
-					basic_rates |= BIT(j);
-				if (rate < min_rate) {
-					min_rate = rate;
-					min_rate_index = j;
-				}
-				break;
-			}
-		}
-	}
-
-	for (i = 0; i < elems.ext_supp_rates_len; i++) {
-		int rate = (elems.ext_supp_rates[i] & 0x7f) * 5;
-		bool is_basic = !!(elems.ext_supp_rates[i] & 0x80);
-
-		if (rate > 110)
-			have_higher_than_11mbit = true;
-
-		for (j = 0; j < sband->n_bitrates; j++) {
-			if (sband->bitrates[j].bitrate == rate) {
-				rates |= BIT(j);
-				if (is_basic)
-					basic_rates |= BIT(j);
-				if (rate < min_rate) {
-					min_rate = rate;
-					min_rate_index = j;
-				}
-				break;
-			}
-		}
-=======
 	/*
 	 * some buggy APs don't advertise basic_rates. use the lowest
 	 * supported rate instead.
@@ -1636,7 +1601,6 @@ static bool ieee80211_assoc_success(stru
 		printk(KERN_DEBUG "%s: No basic rates in AssocResp. "
 		       "Using min supported rate instead.\n", sdata->name);
 		basic_rates = BIT(min_rate_index);
->>>>>>> linux-next/akpm-end
 	}
 
 	/*
_
Subject: Subject: linux-next-git-rejects

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

