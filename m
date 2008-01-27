From: akpm@linux-foundation.org
Subject: + wireless-iwlwifi3945-4965-fix-incorrect-counting-of-memory.patch added to -mm tree
Date: Sat, 26 Jan 2008 22:28:36 -0800
Message-ID: <200801270628.m0R6SX5m001059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49392 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936AbYA0GaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 01:30:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, linville@tuxdriver.com, tomasw@gmail.com


The patch titled
     wireless: iwlwifi3945/4965 - fix incorrect counting of memory
has been added to the -mm tree.  Its filename is
     wireless-iwlwifi3945-4965-fix-incorrect-counting-of-memory.patch

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

cris-add-missed-local_irq_restore-call.patch
git-powerpc.patch
tcm825xfix-logical-typo-error.patch
wireless-iwlwifi3945-4965-fix-incorrect-counting-of-memory.patch
git-x86.patch
driver-ip27-rtc-convert-ioctl-to-unlocked_ioctl-v2.patch
