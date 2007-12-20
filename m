From: akpm@linux-foundation.org
Subject: - iwlwifi3945-4965-fix-rate-control-algo-reference-leak.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:38:33 -0800
Message-ID: <200712202338.lBKNcXrB018982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34517 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755427AbXLTXss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:48:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, linville@tuxdriver.com, yi.zhu@intel.com, mm-commits@vger.kernel.org


The patch titled
     iwlwifi3945/4965: fix rate control algo reference leak
has been removed from the -mm tree.  Its filename was
     iwlwifi3945-4965-fix-rate-control-algo-reference-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: iwlwifi3945/4965: fix rate control algo reference leak
From: Cyrill Gorcunov <gorcunov@gmail.com>

Fix rate control algo reference leak in case if network device has been
failed to register.  In this case special flag priv->mac80211_registered is
not set and the rate algo reference is not freeing on module unload.  That
leads to OOPs in further ieee80211 rate register/unregister procedure (by
any callee).

It should fix the bug #9470

	http://bugzilla.kernel.org/show_bug.cgi?id=9470

[akpm@linux-foundation.org: build fix]
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Zhu Yi <yi.zhu@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/net/wireless/iwlwifi/iwl3945-base.c~iwlwifi3945-4965-fix-rate-control-algo-reference-leak drivers/net/wireless/iwlwifi/iwl3945-base.c
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c~iwlwifi3945-4965-fix-rate-control-algo-reference-leak
+++ a/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6171,6 +6171,7 @@ static void iwl_alive_start(struct iwl_p
 		mutex_lock(&priv->mutex);
 
 		if (rc) {
+			iwl3945_rate_control_unregister(priv->hw);
 			IWL_ERROR("Failed to register network "
 				  "device (error %d)\n", rc);
 			return;
diff -puN drivers/net/wireless/iwlwifi/iwl4965-base.c~iwlwifi3945-4965-fix-rate-control-algo-reference-leak drivers/net/wireless/iwlwifi/iwl4965-base.c
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c~iwlwifi3945-4965-fix-rate-control-algo-reference-leak
+++ a/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6527,6 +6527,7 @@ static void iwl_alive_start(struct iwl_p
 		mutex_lock(&priv->mutex);
 
 		if (rc) {
+			iwl4965_rate_control_unregister(priv->hw);
 			IWL_ERROR("Failed to register network "
 				  "device (error %d)\n", rc);
 			return;
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
git-powerpc.patch
ppc-fix-missed-increment-on-device-interface-counter.patch
net-mac80211-fix-inappropriate-memory-freeing.patch
git-x86.patch
