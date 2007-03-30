From: akpm@linux-foundation.org
Subject: + git-wireless-debug-build-fixes.patch added to -mm tree
Date: Fri, 30 Mar 2007 14:23:38 -0700
Message-ID: <200703302123.l2ULNcCb006171@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53386 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052AbXC3VYg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Mar 2007 17:24:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com


The patch titled
     git-wireless debug build fixes
has been added to the -mm tree.  Its filename is
     git-wireless-debug-build-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-wireless debug build fixes
From: Johannes Berg <johannes@sipsolutions.net>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/debugfs.c     |   20 ++++++++++----------
 net/mac80211/debugfs_sta.c |    4 ++++
 net/mac80211/ieee80211_i.h |    4 ++--
 net/mac80211/sta_info.h    |    2 ++
 4 files changed, 18 insertions(+), 12 deletions(-)

diff -puN net/mac80211/debugfs.c~git-wireless-debug-build-fixes net/mac80211/debugfs.c
--- a/net/mac80211/debugfs.c~git-wireless-debug-build-fixes
+++ a/net/mac80211/debugfs.c
@@ -246,12 +246,6 @@ DEBUGFS_STATS_FILE(rx_handlers_fragments
 		   local->rx_handlers_fragments);
 DEBUGFS_STATS_FILE(tx_status_drop, 20, "%u",
 		   local->tx_status_drop);
-#endif
-
-DEBUGFS_DEVSTATS_FILE(dot11ACKFailureCount);
-DEBUGFS_DEVSTATS_FILE(dot11RTSFailureCount);
-DEBUGFS_DEVSTATS_FILE(dot11FCSErrorCount);
-DEBUGFS_DEVSTATS_FILE(dot11RTSSuccessCount);
 
 static ssize_t stats_wme_rx_queue_read(struct file *file,
 				       char __user *userbuf,
@@ -292,6 +286,12 @@ static const struct file_operations stat
 	.read = stats_wme_tx_queue_read,
 	.open = mac80211_open_file_generic,
 };
+#endif
+
+DEBUGFS_DEVSTATS_FILE(dot11ACKFailureCount);
+DEBUGFS_DEVSTATS_FILE(dot11RTSFailureCount);
+DEBUGFS_DEVSTATS_FILE(dot11FCSErrorCount);
+DEBUGFS_DEVSTATS_FILE(dot11RTSSuccessCount);
 
 
 void debugfs_hw_add(struct ieee80211_local *local)
@@ -360,13 +360,13 @@ void debugfs_hw_add(struct ieee80211_loc
 	DEBUGFS_STATS_ADD(rx_expand_skb_head2);
 	DEBUGFS_STATS_ADD(rx_handlers_fragments);
 	DEBUGFS_STATS_ADD(tx_status_drop);
+	DEBUGFS_STATS_ADD(wme_tx_queue);
+	DEBUGFS_STATS_ADD(wme_rx_queue);
 #endif
 	DEBUGFS_STATS_ADD(dot11ACKFailureCount);
 	DEBUGFS_STATS_ADD(dot11RTSFailureCount);
 	DEBUGFS_STATS_ADD(dot11FCSErrorCount);
 	DEBUGFS_STATS_ADD(dot11RTSSuccessCount);
-	DEBUGFS_STATS_ADD(wme_tx_queue);
-	DEBUGFS_STATS_ADD(wme_rx_queue);
 }
 
 void debugfs_hw_del(struct ieee80211_local *local)
@@ -419,13 +419,13 @@ void debugfs_hw_del(struct ieee80211_loc
 	DEBUGFS_STATS_DEL(rx_expand_skb_head2);
 	DEBUGFS_STATS_DEL(rx_handlers_fragments);
 	DEBUGFS_STATS_DEL(tx_status_drop);
+	DEBUGFS_STATS_DEL(wme_tx_queue);
+	DEBUGFS_STATS_DEL(wme_rx_queue);
 #endif
 	DEBUGFS_STATS_DEL(dot11ACKFailureCount);
 	DEBUGFS_STATS_DEL(dot11RTSFailureCount);
 	DEBUGFS_STATS_DEL(dot11FCSErrorCount);
 	DEBUGFS_STATS_DEL(dot11RTSSuccessCount);
-	DEBUGFS_STATS_DEL(wme_tx_queue);
-	DEBUGFS_STATS_DEL(wme_rx_queue);
 
 	debugfs_remove(local->debugfs.statistics);
 	local->debugfs.statistics = NULL;
diff -puN net/mac80211/debugfs_sta.c~git-wireless-debug-build-fixes net/mac80211/debugfs_sta.c
--- a/net/mac80211/debugfs_sta.c~git-wireless-debug-build-fixes
+++ a/net/mac80211/debugfs_sta.c
@@ -222,8 +222,10 @@ void ieee80211_sta_debugfs_add(struct st
 	DEBUGFS_ADD(last_ack_ms);
 	DEBUGFS_ADD(inactive_ms);
 	DEBUGFS_ADD(last_seq_ctrl);
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	DEBUGFS_ADD(wme_rx_queue);
 	DEBUGFS_ADD(wme_tx_queue);
+#endif
 }
 
 void ieee80211_sta_debugfs_remove(struct sta_info *sta)
@@ -234,8 +236,10 @@ void ieee80211_sta_debugfs_remove(struct
 	DEBUGFS_DEL(last_ack_ms);
 	DEBUGFS_DEL(inactive_ms);
 	DEBUGFS_DEL(last_seq_ctrl);
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	DEBUGFS_DEL(wme_rx_queue);
 	DEBUGFS_DEL(wme_tx_queue);
+#endif
 
 	debugfs_remove(sta->debugfs.dir);
 	sta->debugfs.dir = NULL;
diff -puN net/mac80211/ieee80211_i.h~git-wireless-debug-build-fixes net/mac80211/ieee80211_i.h
--- a/net/mac80211/ieee80211_i.h~git-wireless-debug-build-fixes
+++ a/net/mac80211/ieee80211_i.h
@@ -647,13 +647,13 @@ struct ieee80211_local {
 			struct dentry *rx_expand_skb_head2;
 			struct dentry *rx_handlers_fragments;
 			struct dentry *tx_status_drop;
+			struct dentry *wme_tx_queue;
+			struct dentry *wme_rx_queue;
 #endif
 			struct dentry *dot11ACKFailureCount;
 			struct dentry *dot11RTSFailureCount;
 			struct dentry *dot11FCSErrorCount;
 			struct dentry *dot11RTSSuccessCount;
-			struct dentry *wme_tx_queue;
-			struct dentry *wme_rx_queue;
 		} stats;
 		struct dentry *stations;
 		struct dentry *keys;
diff -puN net/mac80211/sta_info.h~git-wireless-debug-build-fixes net/mac80211/sta_info.h
--- a/net/mac80211/sta_info.h~git-wireless-debug-build-fixes
+++ a/net/mac80211/sta_info.h
@@ -124,8 +124,10 @@ struct sta_info {
 		struct dentry *last_ack_ms;
 		struct dentry *inactive_ms;
 		struct dentry *last_seq_ctrl;
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 		struct dentry *wme_rx_queue;
 		struct dentry *wme_tx_queue;
+#endif
 	} debugfs;
 #endif
 };
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

git-alsa.patch
git-powerpc.patch
git-wireless.patch
git-wireless-debug-build-fixes.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-force-pm_opsvalid-callback-to-be.patch
fix-sscanf-%n-match-at-end-of-input-string.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
