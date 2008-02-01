From: akpm@linux-foundation.org
Subject: - wireless-iwlwifi3945-4965-fix-incorrect-counting-of-memory.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:29:31 -0800
Message-ID: <200802012229.m11MTVLG001810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58415 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756399AbYBAWqV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:46:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, linville@tuxdriver.com, tomasw@gmail.com, mm-commits@vger.kernel.org


The patch titled
     wireless: iwlwifi3945/4965 - fix incorrect counting of memory
has been removed from the -mm tree.  Its filename was
     wireless-iwlwifi3945-4965-fix-incorrect-counting-of-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wireless: iwlwifi3945/4965 - fix incorrect counting of memory
From: Cyrill Gorcunov <gorcunov@gmail.com>

Fix incorrect counting of memory allocated by kmalloc.  It seems that could
lead to allocated memory overrun and corrupt nearlaid memory area.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: "Tomas Winkler" <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/wireless/iwlwifi/iwl3945-base.c~wireless-iwlwifi3945-4965-fix-incorrect-counting-of-memory drivers/net/wireless/iwlwifi/iwl3945-base.c
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c~wireless-iwlwifi3945-4965-fix-incorrect-counting-of-memory
+++ a/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6646,7 +6646,7 @@ static void iwl3945_bg_request_scan(stru
 	 * that based on the direct_mask added to each channel entry */
 	scan->tx_cmd.len = cpu_to_le16(
 		iwl3945_fill_probe_req(priv, (struct ieee80211_mgmt *)scan->data,
-			IWL_MAX_SCAN_SIZE - sizeof(scan), 0));
+			IWL_MAX_SCAN_SIZE - sizeof(*scan), 0));
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
 	scan->tx_cmd.sta_id = priv->hw_setting.bcast_sta_id;
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
diff -puN drivers/net/wireless/iwlwifi/iwl4965-base.c~wireless-iwlwifi3945-4965-fix-incorrect-counting-of-memory drivers/net/wireless/iwlwifi/iwl4965-base.c
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c~wireless-iwlwifi3945-4965-fix-incorrect-counting-of-memory
+++ a/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7066,7 +7066,7 @@ static void iwl4965_bg_request_scan(stru
 	 * that based on the direct_mask added to each channel entry */
 	scan->tx_cmd.len = cpu_to_le16(
 		iwl4965_fill_probe_req(priv, (struct ieee80211_mgmt *)scan->data,
-			IWL_MAX_SCAN_SIZE - sizeof(scan), 0));
+			IWL_MAX_SCAN_SIZE - sizeof(*scan), 0));
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
 	scan->tx_cmd.sta_id = priv->hw_setting.bcast_sta_id;
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
git-dvb.patch
driver-ip27-rtc-convert-ioctl-to-unlocked_ioctl-v2.patch
mount-options-fix-udf.patch
