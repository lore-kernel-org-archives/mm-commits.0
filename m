From: akpm@linux-foundation.org
Subject: + iwlwifi-4965-fix-race-conditional-panic.patch added to -mm tree
Date: Thu, 29 Nov 2007 13:24:13 -0800
Message-ID: <200711292124.lATLODMn008062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50569 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760322AbXK2VY2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 16:24:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joonwpark81@gmail.com


The patch titled
     iwlwifi 4965: fix race conditional panic
has been added to the -mm tree.  Its filename is
     iwlwifi-4965-fix-race-conditional-panic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iwlwifi 4965: fix race conditional panic
From: "Joonwoo Park" <joonwpark81@gmail.com>

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwlwifi/iwl4965-base.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/wireless/iwlwifi/iwl4965-base.c~iwlwifi-4965-fix-race-conditional-panic drivers/net/wireless/iwlwifi/iwl4965-base.c
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c~iwlwifi-4965-fix-race-conditional-panic
+++ a/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -9182,6 +9182,7 @@ static void iwl_pci_remove(struct pci_de
 	IWL_DEBUG_INFO("*** UNLOAD DRIVER ***\n");
 
 	mutex_lock(&priv->mutex);
+	cancel_delayed_work_sync(&priv->init_alive_start);
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
 	__iwl_down(priv);
 	mutex_unlock(&priv->mutex);
_

Patches currently in -mm which might be from joonwpark81@gmail.com are

git-net.patch
net-fix-tx-bug-vlan-in-vlan.patch
iwlwifi-3945-fix-race-conditional-panic.patch
iwlwifi-4965-fix-race-conditional-panic.patch
