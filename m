From: akpm@linux-foundation.org
Subject: - iwlwifi-4965-fix-race-conditional-panic.patch removed from -mm tree
Date: Wed, 12 Dec 2007 03:43:49 -0800
Message-ID: <200712121143.lBCBhnpX007946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51111 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759187AbXLLLn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 06:43:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joonwpark81@gmail.com, yi.zhu@intel.com, mm-commits@vger.kernel.org


The patch titled
     iwlwifi 4965: fix race conditional panic
has been removed from the -mm tree.  Its filename was
     iwlwifi-4965-fix-race-conditional-panic.patch

This patch was dropped because I've lost track of what's happening

------------------------------------------------------
Subject: iwlwifi 4965: fix race conditional panic
From: "Joonwoo Park" <joonwpark81@gmail.com>

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwlwifi/iwl4965-base.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/wireless/iwlwifi/iwl4965-base.c~iwlwifi-4965-fix-race-conditional-panic drivers/net/wireless/iwlwifi/iwl4965-base.c
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c~iwlwifi-4965-fix-race-conditional-panic
+++ a/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -9306,6 +9306,7 @@ static void iwl4965_pci_remove(struct pc
 	IWL_DEBUG_INFO("*** UNLOAD DRIVER ***\n");
 
 	mutex_lock(&priv->mutex);
+	cancel_delayed_work_sync(&priv->init_alive_start);
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
 	__iwl4965_down(priv);
 	mutex_unlock(&priv->mutex);
_

Patches currently in -mm which might be from joonwpark81@gmail.com are

git-net.patch
iwlwifi-4965-fix-race-conditional-panic.patch
