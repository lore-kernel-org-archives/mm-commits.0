From: akpm@linux-foundation.org
Subject: + iwlwifi3945-4965-fix-rate-control-algo-reference-leak.patch added to -mm tree
Date: Wed, 12 Dec 2007 00:58:38 -0800
Message-ID: <200712120858.lBC8wc6I002075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42887 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756222AbXLLI7d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 03:59:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, linville@tuxdriver.com, yi.zhu@intel.com


The patch titled
     iwlwifi3945/4965: fix rate control algo reference leak
has been added to the -mm tree.  Its filename is
     iwlwifi3945-4965-fix-rate-control-algo-reference-leak.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -6280,6 +6280,7 @@ static void iwl3945_alive_start(struct i
 		mutex_lock(&priv->mutex);
 
 		if (rc) {
+			iwl_rate_control_unregister(priv->hw);
 			IWL_ERROR("Failed to register network "
 				  "device (error %d)\n", rc);
 			return;
diff -puN drivers/net/wireless/iwlwifi/iwl4965-base.c~iwlwifi3945-4965-fix-rate-control-algo-reference-leak drivers/net/wireless/iwlwifi/iwl4965-base.c
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c~iwlwifi3945-4965-fix-rate-control-algo-reference-leak
+++ a/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6693,6 +6693,7 @@ static void iwl4965_alive_start(struct i
 		mutex_lock(&priv->mutex);
 
 		if (rc) {
+			iwl_rate_control_unregister(priv->hw);
 			IWL_ERROR("Failed to register network "
 				  "device (error %d)\n", rc);
 			return;
_

Patches currently in -mm which might be from gorcunov@gmail.com are

git-powerpc.patch
ppc-fix-missed-increment-on-device-interface-counter.patch
ppc-chrp-fix-possible-null-pointer-dereference.patch
ppc-chrp-fix-possible-null-pointer-dereference-checkpatch-fixes.patch
net-mac80211-fix-inappropriate-memory-freeing.patch
git-x86.patch
ieee80211_rate-missed-unlock.patch
iwlwifi3945-4965-fix-rate-control-algo-reference-leak.patch
