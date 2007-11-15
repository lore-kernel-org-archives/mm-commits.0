From: akpm@linux-foundation.org
Subject: - iwlwifi-remove-unnecessary-code-in-iwl3945-and-iwl4965-drivers.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:40:48 -0800
Message-ID: <200711152140.lAFLemd4017041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56416 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933355AbXKOVmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:42:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mboton@gmail.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     iwlwifi: remove unnecessary code in iwl3945 and iwl4965 drivers
has been removed from the -mm tree.  Its filename was
     iwlwifi-remove-unnecessary-code-in-iwl3945-and-iwl4965-drivers.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: iwlwifi: remove unnecessary code in iwl3945 and iwl4965 drivers
From: Miguel Boton <mboton@gmail.com>

Remove unnecesary code in iwl3945 and iwl4965 drivers.

"final_mode" variable is already initialized with the value of the "mode"
variable.

Signed-off-by: Miguel Boton <mboton@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 ---
 2 files changed, 6 deletions(-)

diff -puN drivers/net/wireless/iwlwifi/iwl3945-base.c~iwlwifi-remove-unnecessary-code-in-iwl3945-and-iwl4965-drivers drivers/net/wireless/iwlwifi/iwl3945-base.c
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c~iwlwifi-remove-unnecessary-code-in-iwl3945-and-iwl4965-drivers
+++ a/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2153,9 +2153,6 @@ static int iwl_send_power_mode(struct iw
 	case IWL_POWER_AC:
 		final_mode = IWL_POWER_MODE_CAM;
 		break;
-	default:
-		final_mode = mode;
-		break;
 	}
 
 	iwl_update_power_cmd(priv, &cmd, final_mode);
diff -puN drivers/net/wireless/iwlwifi/iwl4965-base.c~iwlwifi-remove-unnecessary-code-in-iwl3945-and-iwl4965-drivers drivers/net/wireless/iwlwifi/iwl4965-base.c
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c~iwlwifi-remove-unnecessary-code-in-iwl3945-and-iwl4965-drivers
+++ a/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2232,9 +2232,6 @@ static int iwl_send_power_mode(struct iw
 	case IWL_POWER_AC:
 		final_mode = IWL_POWER_MODE_CAM;
 		break;
-	default:
-		final_mode = mode;
-		break;
 	}
 
 	cmd.keep_alive_beacons = 0;
_

Patches currently in -mm which might be from mboton@gmail.com are

iwlwifi-remove-unnecessary-code-in-iwl3945-and-iwl4965-drivers.patch
